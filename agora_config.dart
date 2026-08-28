class AgoraConfig {
  AgoraConfig._();

  static const String appId = String.fromEnvironment(
    'AGORA_APP_ID',
    defaultValue: 'your_agora_app_id',
  );

  static const String appCertificate = String.fromEnvironment(
    'AGORA_APP_CERTIFICATE',
    defaultValue: 'your_agora_app_certificate',
  );

  // Token server endpoint (deploy as Firebase Cloud Function or edge function)
  static const String tokenServerUrl =
      'https://us-central1-play-and-win-demo.cloudfunctions.net/agoraToken';

  // RTC settings
  static const int videoProfile = 0; // 120p
  static const int audioSampleRate = 44100;
  static const int audioChannels = 1;
  static const bool enableVideo = true;
  static const bool enableAudio = true;

  // Channel prefix for tournament rooms
  static const String tournamentChannelPrefix = 'tournament_';
  static const String matchChannelPrefix = 'match_';

  // Role constants
  static const int roleBroadcaster = 1;
  static const int roleAudience = 2;
}
