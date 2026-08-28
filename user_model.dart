import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  const UserModel({
    required this.id,
    required this.email,
    required this.username,
    this.displayName,
    this.avatarUrl,
    this.bio,
    this.totalPoints = 0,
    this.totalWinnings = 0.0,
    this.tournamentsWon = 0,
    this.tournamentsPlayed = 0,
    this.matchesPlayed = 0,
    this.matchesWon = 0,
    this.walletBalance = 0.0,
    this.rank = 0,
    this.level = 1,
    this.isOnline = false,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String email;
  final String username;
  final String? displayName;
  final String? avatarUrl;
  final String? bio;
  final int totalPoints;
  final double totalWinnings;
  final int tournamentsWon;
  final int tournamentsPlayed;
  final int matchesPlayed;
  final int matchesWon;
  final double walletBalance;
  final int rank;
  final int level;
  final bool isOnline;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  double get winRate {
    if (matchesPlayed == 0) return 0.0;
    return (matchesWon / matchesPlayed) * 100;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      email: map['email'] as String,
      username: map['username'] as String,
      displayName: map['displayName'] as String?,
      avatarUrl: map['avatarUrl'] as String?,
      bio: map['bio'] as String?,
      totalPoints: (map['totalPoints'] as num?)?.toInt() ?? 0,
      totalWinnings: (map['totalWinnings'] as num?)?.toDouble() ?? 0.0,
      tournamentsWon: (map['tournamentsWon'] as num?)?.toInt() ?? 0,
      tournamentsPlayed: (map['tournamentsPlayed'] as num?)?.toInt() ?? 0,
      matchesPlayed: (map['matchesPlayed'] as num?)?.toInt() ?? 0,
      matchesWon: (map['matchesWon'] as num?)?.toInt() ?? 0,
      walletBalance: (map['walletBalance'] as num?)?.toDouble() ?? 0.0,
      rank: (map['rank'] as num?)?.toInt() ?? 0,
      level: (map['level'] as num?)?.toInt() ?? 1,
      isOnline: map['isOnline'] as bool? ?? false,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel.fromMap({'id': doc.id, ...data});
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'username': username,
      'displayName': displayName,
      'avatarUrl': avatarUrl,
      'bio': bio,
      'totalPoints': totalPoints,
      'totalWinnings': totalWinnings,
      'tournamentsWon': tournamentsWon,
      'tournamentsPlayed': tournamentsPlayed,
      'matchesPlayed': matchesPlayed,
      'matchesWon': matchesWon,
      'walletBalance': walletBalance,
      'rank': rank,
      'level': level,
      'isOnline': isOnline,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  UserModel copyWith({
    String? displayName,
    String? avatarUrl,
    String? bio,
    int? totalPoints,
    double? totalWinnings,
    int? tournamentsWon,
    int? tournamentsPlayed,
    int? matchesPlayed,
    int? matchesWon,
    double? walletBalance,
    int? rank,
    int? level,
    bool? isOnline,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id,
      email: email,
      username: username,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      totalPoints: totalPoints ?? this.totalPoints,
      totalWinnings: totalWinnings ?? this.totalWinnings,
      tournamentsWon: tournamentsWon ?? this.tournamentsWon,
      tournamentsPlayed: tournamentsPlayed ?? this.tournamentsPlayed,
      matchesPlayed: matchesPlayed ?? this.matchesPlayed,
      matchesWon: matchesWon ?? this.matchesWon,
      walletBalance: walletBalance ?? this.walletBalance,
      rank: rank ?? this.rank,
      level: level ?? this.level,
      isOnline: isOnline ?? this.isOnline,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id, email, username, displayName, avatarUrl, bio,
        totalPoints, totalWinnings, tournamentsWon, tournamentsPlayed,
        matchesPlayed, matchesWon, walletBalance, rank, level,
        isOnline, createdAt, updatedAt,
      ];
}
