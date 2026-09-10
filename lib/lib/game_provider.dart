import 'package:flutter/foundation.dart';
import 'game_model.dart';

class GameProvider with ChangeNotifier {
  List<GameModel> _games = [];
  bool _isLoading = false;

  List<GameModel> get games => _games;
  bool get isLoading => _isLoading;

  void setGames(List<GameModel> gamesList) {
    _games = gamesList;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}

