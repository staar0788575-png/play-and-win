import 'package:flutter/material.dart';
import 'game_model.dart';
import 'game_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GameRepository _gameRepository = GameRepository();
  List<GameModel> _games = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGames();
  }

  Future<void> _loadGames() async {
    final games = await _gameRepository.fetchGames();
    setState(() {
      _games = games;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تطبيق العب واربح'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _games.length,
              padding: const EdgeInsets.all(16.0),
              itemBuilder: (context, index) {
                final game = _games[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12.0),
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.games),
                    ),
                    title: Text(
                      game.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('النقاط المستحقة: ${game.rewardPoints}'),
                    trailing: ElevatedButton(
                      onPressed: () {
                        // سيتم إضافة تفاصيل بدء اللعب لاحقاً
                      },
                      child: const Text('العب الآن'),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

