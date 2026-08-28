import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class MatchModel extends Equatable {
  const MatchModel({
    required this.id,
    required this.tournamentId,
    required this.gameId,
    required this.playerIds,
    required this.status,
    required this.scheduledAt,
    this.winnerId,
    this.scores = const {},
    this.agoraChannelName,
    this.agoraToken,
    this.durationMinutes,
    this.completedAt,
  });

  final String id;
  final String tournamentId;
  final String gameId;
  final List<String> playerIds;
  final MatchStatus status;
  final DateTime scheduledAt;
  final String? winnerId;
  final Map<String, int> scores;
  final String? agoraChannelName;
  final String? agoraToken;
  final int? durationMinutes;
  final DateTime? completedAt;

  factory MatchModel.fromMap(Map<String, dynamic> map) {
    return MatchModel(
      id: map['id'] as String,
      tournamentId: map['tournamentId'] as String,
      gameId: map['gameId'] as String,
      playerIds: (map['playerIds'] as List).map((e) => e as String).toList(),
      status: MatchStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => MatchStatus.scheduled,
      ),
      scheduledAt: (map['scheduledAt'] as Timestamp).toDate(),
      winnerId: map['winnerId'] as String?,
      scores: (map['scores'] as Map?)?.map(
        (k, v) => MapEntry(k as String, (v as num).toInt()),
      ) ?? {},
      agoraChannelName: map['agoraChannelName'] as String?,
      agoraToken: map['agoraToken'] as String?,
      durationMinutes: (map['durationMinutes'] as num?)?.toInt(),
      completedAt: (map['completedAt'] as Timestamp?)?.toDate(),
    );
  }

  factory MatchModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MatchModel.fromMap({'id': doc.id, ...data});
  }

  Map<String, dynamic> toMap() {
    return {
      'tournamentId': tournamentId,
      'gameId': gameId,
      'playerIds': playerIds,
      'status': status.name,
      'scheduledAt': Timestamp.fromDate(scheduledAt),
      'winnerId': winnerId,
      'scores': scores,
      'agoraChannelName': agoraChannelName,
      'agoraToken': agoraToken,
      'durationMinutes': durationMinutes,
      'completedAt': completedAt != null ? Timestamp.fromDate(completedAt!) : null,
    };
  }

  @override
  List<Object?> get props => [
        id, tournamentId, gameId, playerIds, status,
        scheduledAt, winnerId, scores, agoraChannelName,
        agoraToken, durationMinutes, completedAt,
      ];
}

enum MatchStatus {
  scheduled,
  inProgress,
  completed,
  cancelled,
}
