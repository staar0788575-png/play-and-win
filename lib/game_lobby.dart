// ====================================================================
// (Game Lobby Screen) - القائمة الرئيسية لتطبيق العب واربح 🎮
// ====================================================================

import 'package:flutter/material.dart';
import 'ludo_game_screen.dart'; // شاشة لعبة لودو
import 'domino_game_screen.dart'; // شاشة لعبة الدومينو
import 'snakes_ladders_screen.dart'; // شاشة السلم والثعبان
import 'billiards_game_screen.dart'; // شاشة البلياردو والكيرم

class GameLobbyScreen extends StatelessWidget {
  const GameLobbyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('العب واربح - صالة الألعاب'),
        backgroundColor: Colors.indigo[900],
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F0F19), Color(0xFF172A45)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'اختر اللعبة للبدء:',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  // 1. البلياردو والكيرم
                  _buildGameCard(
                    context,
                    title: 'البلياردو والكيرم',
                    icon: Icons.sports_esports,
                    color: Colors.teal[700]!,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const BilliardsGameScreen()),
                      );
                    },
                  ),
                  // 2. لعبة الدومينو
                  _buildGameCard(
                    context,
                    title: 'لعبة الدومينو',
                    icon: Icons.casino,
                    color: Colors.indigo[700]!,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const DominoGameScreen()),
                      );
                    },
                  ),
                  // 3. السلم والثعبان
                  _buildGameCard(
                    context,
                    title: 'السلم والثعبان',
                    icon: Icons.leaderboard,
                    color: Colors.deepOrange[700]!,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SnakesLaddersScreen()),
                      );
                    },
                  ),
                  // 4. لعبة لودو
                  _buildGameCard(
                    context,
                    title: 'لعبة لودو',
                    icon: Icons.star,
                    color: Colors.purple[700]!,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LudoGameScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.white),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
