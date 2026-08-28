import 'dart:async';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import '../../core/constants/agora_config.dart';

class AgoraService {
  AgoraService._();

  static final AgoraService instance = AgoraService._();

  final RtcEngine _engine = createAgoraRtcEngine();
  bool _isInitialized = false;

  RtcEngine get engine => _engine;
  bool get isInitialized => _isInitialized;

  final StreamController<int> _userJoinedController =
      StreamController<int>.broadcast();
  final StreamController<int> _userLeftController =
      StreamController<int>.broadcast();
  final StreamController<bool> _localAudioMutedController =
      StreamController<bool>.broadcast();
  final StreamController<bool> _localVideoMutedController =
      StreamController<bool>.broadcast();

  Stream<int> get onUserJoined => _userJoinedController.stream;
  Stream<int> get onUserLeft => _userLeftController.stream;
  Stream<bool> get onLocalAudioMuted => _localAudioMutedController.stream;
  Stream<bool> get onLocalVideoMuted => _localVideoMutedController.stream;

  Future<void> initialize() async {
    if (_isInitialized) return;

    await _engine.initialize(RtcEngineContext(
      appId: AgoraConfig.appId,
      areaCode: AreaCode.areaCodeGlob,
      logConfig: const LogConfig(level: LogLevel.logLevelInfo),
    ));

    _engine.registerEventHandler(RtcEngineEventHandler(
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        // Handle join success
      },
      onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
        _userJoinedController.add(remoteUid);
      },
      onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
        _userLeftController.add(remoteUid);
      },
      onLeaveChannel: (RtcConnection connection, RtcStats stats) {
        // Handle leave
      },
    ));

    _isInitialized = true;
  }

  Future<void> joinChannel({
    required String token,
    required String channelName,
    required int uid,
    bool enableVideo = true,
  }) async {
    if (!_isInitialized) await initialize();

    if (enableVideo) {
      await _engine.enableVideo();
      await _engine.startPreview();
    } else {
      await _engine.disableVideo();
    }

    await _engine.enableAudio();
    await _engine.setChannelProfile(ChannelProfileType.channelProfileCommunication);

    await _engine.joinChannel(
      token: token,
      channelId: channelName,
      uid: uid,
      options: ChannelMediaOptions(
        channelProfile: ChannelProfileType.channelProfileCommunication,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        autoSubscribeVideo: true,
        autoSubscribeAudio: true,
        publishMicrophoneTrack: true,
        publishCameraTrack: enableVideo,
      ),
    );
  }

  Future<void> leaveChannel() async {
    await _engine.leaveChannel();
    await _engine.stopPreview();
  }

  Future<void> toggleAudio(bool muted) async {
    await _engine.muteLocalAudioStream(muted);
    _localAudioMutedController.add(muted);
  }

  Future<void> toggleVideo(bool muted) async {
    await _engine.muteLocalVideoStream(muted);
    _localVideoMutedController.add(muted);
  }

  Future<void> switchCamera() async {
    await _engine.switchCamera();
  }

  Future<void> setVideoEncoderConfig() async {
    await _engine.setVideoEncoderConfiguration(
      const VideoEncoderConfiguration(
        dimensions: VideoDimensions(width: 640, height: 360),
        frameRate: 15,
        bitrate: 0,
      ),
    );
  }

  void dispose() {
    _userJoinedController.close();
    _userLeftController.close();
    _localAudioMutedController.close();
    _localVideoMutedController.close();
    _engine.release();
    _isInitialized = false;
  }
}
