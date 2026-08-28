import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/game_model.dart';
import '../models/tournament_model.dart';
import '../models/match_model.dart';
import '../../core/constants/app_constants.dart';

class FirestoreService {
  FirestoreService._();

  static final FirestoreService instance = FirestoreService._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Games
  Stream<List<GameModel>> gamesStream() {
    return _db
        .collection(AppConstants.gamesCollection)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snap) => snap.docs.map(GameModel.fromFirestore).toList());
  }

  Future<List<GameModel>> getGames() async {
    final snap = await _db
        .collection(AppConstants.gamesCollection)
        .where('isActive', isEqualTo: true)
        .get();
    return snap.docs.map(GameModel.fromFirestore).toList();
  }

  Future<GameModel?> getGame(String gameId) async {
    final doc = await _db
        .collection(AppConstants.gamesCollection)
        .doc(gameId)
        .get();
    return doc.exists ? GameModel.fromFirestore(doc) : null;
  }

  // Tournaments
  Stream<List<TournamentModel>> tournamentsStream({
    TournamentStatus? status,
  }) {
    var query = _db
        .collection(AppConstants.tournamentsCollection)
        .orderBy('startsAt', descending: false);

    if (status != null) {
      query = query.where('status', isEqualTo: status.name);
    }

    return query.snapshots().map((snap) => snap.docs
        .map(TournamentModel.fromFirestore)
        .where((t) => t.status != TournamentStatus.cancelled)
        .toList());
  }

  Future<List<TournamentModel>> getTournaments({
    TournamentStatus? status,
  }) async {
    var query = _db
        .collection(AppConstants.tournamentsCollection)
        .orderBy('startsAt', descending: false);

    if (status != null) {
      query = query.where('status', isEqualTo: status.name);
    }

    final snap = await query.get();
    return snap.docs.map(TournamentModel.fromFirestore).toList();
  }

  Future<TournamentModel?> getTournament(String tournamentId) async {
    final doc = await _db
        .collection(AppConstants.tournamentsCollection)
        .doc(tournamentId)
        .get();
    return doc.exists ? TournamentModel.fromFirestore(doc) : null;
  }

  Future<void> registerForTournament({
    required String tournamentId,
    required String userId,
  }) async {
    await _db.runTransaction((tx) async {
      final ref = _db.collection(AppConstants.tournamentsCollection).doc(tournamentId);
      final doc = await tx.get(ref);

      if (!doc.exists) throw Exception('Tournament not found');

      final tournament = TournamentModel.fromFirestore(doc);
      if (tournament.isFull) throw Exception('Tournament is full');
      if (!tournament.canRegister) throw Exception('Registration is closed');

      tx.update(ref, {
        'registeredPlayers': FieldValue.increment(1),
        'registeredUserIds': FieldValue.arrayUnion([userId]),
      });
    });
  }

  Future<void> unregisterFromTournament({
    required String tournamentId,
    required String userId,
  }) async {
    await _db.runTransaction((tx) async {
      final ref = _db.collection(AppConstants.tournamentsCollection).doc(tournamentId);
      final doc = await tx.get(ref);

      if (!doc.exists) throw Exception('Tournament not found');

      tx.update(ref, {
        'registeredPlayers': FieldValue.increment(-1),
        'registeredUserIds': FieldValue.arrayRemove([userId]),
      });
    });
  }

  // Matches
  Stream<List<MatchModel>> matchesStream(String tournamentId) {
    return _db
        .collection(AppConstants.matchesCollection)
        .where('tournamentId', isEqualTo: tournamentId)
        .snapshots()
        .map((snap) => snap.docs.map(MatchModel.fromFirestore).toList());
  }

  Future<List<MatchModel>> getMatches(String tournamentId) async {
    final snap = await _db
        .collection(AppConstants.matchesCollection)
        .where('tournamentId', isEqualTo: tournamentId)
        .get();
    return snap.docs.map(MatchModel.fromFirestore).toList();
  }

  // Leaderboard
  Stream<QuerySnapshot> leaderboardStream({int limit = 100}) {
    return _db
        .collection(AppConstants.usersCollection)
        .orderBy('totalPoints', descending: true)
        .limit(limit)
        .snapshots();
  }

  // User updates
  Future<void> updateUserProfile({
    required String userId,
    String? displayName,
    String? avatarUrl,
    String? bio,
  }) async {
    final updates = <String, dynamic>{
      'updatedAt': Timestamp.now(),
    };

    if (displayName != null) updates['displayName'] = displayName;
    if (avatarUrl != null) updates['avatarUrl'] = avatarUrl;
    if (bio != null) updates['bio'] = bio;

    await _db
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .update(updates);
  }

  Future<void> updateUserStats({
    required String userId,
    int? additionalPoints,
    double? additionalWinnings,
    int? additionalTournamentsWon,
    int? additionalTournamentsPlayed,
    int? additionalMatchesPlayed,
    int? additionalMatchesWon,
  }) async {
    final updates = <String, dynamic>{'updatedAt': Timestamp.now()};

    if (additionalPoints != null) {
      updates['totalPoints'] = FieldValue.increment(additionalPoints);
    }
    if (additionalWinnings != null) {
      updates['totalWinnings'] = FieldValue.increment(additionalWinnings);
    }
    if (additionalTournamentsWon != null) {
      updates['tournamentsWon'] = FieldValue.increment(additionalTournamentsWon);
    }
    if (additionalTournamentsPlayed != null) {
      updates['tournamentsPlayed'] = FieldValue.increment(additionalTournamentsPlayed);
    }
    if (additionalMatchesPlayed != null) {
      updates['matchesPlayed'] = FieldValue.increment(additionalMatchesPlayed);
    }
    if (additionalMatchesWon != null) {
      updates['matchesWon'] = FieldValue.increment(additionalMatchesWon);
    }

    await _db
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .update(updates);
  }
}
