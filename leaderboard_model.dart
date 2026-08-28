import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class LeaderboardEntry extends Equatable {
  const LeaderboardEntry({
    required this.userId,
    required this.username,
    required this.totalPoints,
    required this.rank,
    this.avatarUrl,
    this.tournamentsWon = 0,
    this.winRate = 0.0,
  });

  final String userId;
  final String username;
  final int totalPoints;
  final int rank;
  final String? avatarUrl;
  final int tournamentsWon;
  final double winRate;

  factory LeaderboardEntry.fromMap(Map<String, dynamic> map) {
    return LeaderboardEntry(
      userId: map['userId'] as String,
      username: map['username'] as String,
      totalPoints: (map['totalPoints'] as num?)?.toInt() ?? 0,
      rank: (map['rank'] as num?)?.toInt() ?? 0,
      avatarUrl: map['avatarUrl'] as String?,
      tournamentsWon: (map['tournamentsWon'] as num?)?.toInt() ?? 0,
      winRate: (map['winRate'] as num?)?.toDouble() ?? 0.0,
    );
  }

  factory LeaderboardEntry.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return LeaderboardEntry.fromMap({'userId': doc.id, ...data});
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'totalPoints': totalPoints,
      'rank': rank,
      'avatarUrl': avatarUrl,
      'tournamentsWon': tournamentsWon,
      'winRate': winRate,
    };
  }

  @override
  List<Object?> get props => [
        userId, username, totalPoints, rank,
        avatarUrl, tournamentsWon, winRate,
      ];
}
