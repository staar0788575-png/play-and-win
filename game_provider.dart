import 'package:flutter/material.dart';
import '../../data/repositories/game_repository.dart';
import '../../data/models/game_model.dart';
import '../../data/models/tournament_model.dart';
import '../../data/models/match_model.dart';
import '../../data/models/leaderboard_model.dart';

class GameProvider extends ChangeNotifier {
  GameProvider() {
    _loadGames();
    _loadTournaments();
  }

  final GameRepository _repo = GameRepository.instance;

  List<GameModel> _games = [];
  List<TournamentModel> _tournaments = [];
  List<LeaderboardEntry> _leaderboard = [];
  bool _isLoading = false;
  String? _error;

  List<GameModel> get games => _games;
  List<TournamentModel> get tournaments => _tournaments;
  List<TournamentModel> get liveTournaments =>
      _tournaments.where((t) => t.status == TournamentStatus.live).toList();
  List<TournamentModel> get upcomingTournaments =>
      _tournaments.where((t) => t.status == TournamentStatus.upcoming).toList();
  List<LeaderboardEntry> get leaderboard => _leaderboard;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void _loadGames() {
    _repo.gamesStream().listen((games) {
      _games = games;
      notifyListeners();
    });
  }

  void _loadTournaments() {
    _repo.tournamentsStream().listen((tournaments) {
      _tournaments = tournaments;
      notifyListeners();
    });
  }

  void loadLeaderboard() {
    _repo.leaderboardStream().listen((entries) {
      _leaderboard = entries;
      notifyListeners();
    });
  }

  Future<bool> registerForTournament(String tournamentId, String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repo.registerForTournament(
          tournamentId: tournamentId, userId: userId);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> unregisterFromTournament(String tournamentId, String userId) async {
    try {
      await _repo.unregisterFromTournament(
          tournamentId: tournamentId, userId: userId);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
