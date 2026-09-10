import 'game_model.dart';

class GameRepository {
  // قائمة الألعاب الفعلية الخاصة بالتطبيق
  Future<List<GameModel>> fetchGames() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      GameModel(id: '1', title: 'لعبة لودو', rewardPoints: 100),
      GameModel(id: '2', title: 'السلم والثعبان', rewardPoints: 150),
      GameModel(id: '3', title: 'الدومينو', rewardPoints: 200),
      GameModel(id: '4', title: 'البلياردو', rewardPoints: 250),
    ];
  }
}
