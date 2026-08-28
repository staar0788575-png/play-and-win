import '../services/firestore_service.dart';
import '../models/game_model.dart';
import '../models/tournament_model.dart';
import '../models/match_model.dart';
import '../models/leaderboard_model.dart';

class GameRepository {
  GameRepository._();

  static final GameRepository instance = GameRepository._();

  final FirestoreService _firestore = FirestoreService.instance;

  Stream<List<GameModel>> gamesStream() => _firestore.gamesStream();
  Future<List<GameModel>> getGames() => _firestore.getGames();
  Future<GameModel?> getGame(String id) => _firestore.getGame(id);

  Stream<List<TournamentModel>> tournamentsStream({TournamentStatus? status}) =>
      _firestore.tournamentsStream(status: status);
  Future<List<TournamentModel>> getTournaments({TournamentStatus? status}) =>
      _firestore.getTournaments(status: status);
  Future<TournamentModel?> getTournament(String id) =>
      _firestore.getTournament(id);

  Future<void> registerForTournament({
    required String tournamentId,
    required String userId,
  }) =>
      _firestore.registerForTournament(
          tournamentId: tournamentId, userId: userId);

  Future<void> unregisterFromTournament({
    required String tournamentId,
    required String userId,
  }) =>
      _firestore.unregisterFromTournament(
          tournamentId: tournamentId, userId: userId);

  Stream<List<MatchModel>> matchesStream(String tournamentId) =>
      _firestore.matchesStream(tournamentId);
  Future<List<MatchModel>> getMatches(String tournamentId) =>
      _firestore.getMatches(tournamentId);

  Stream<List<LeaderboardEntry>> leaderboardStream({int limit = 100}) {
    return _firestore.leaderboardStream(limit: limit).map((snap) {
      final docs = snap.docs;
      return docs.asMap().entries.map((entry) {
        final rank = entry.key + 1;
        final data = entry.value.data();
        return LeaderboardEntry.fromMap({
          'userId': entry.value.id,
          'rank': rank,
          ...data,
        });
      }).toList();
    });
  }
}
