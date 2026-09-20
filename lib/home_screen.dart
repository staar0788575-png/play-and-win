// -------------------------------------------------------------------
// (Home Screen) - الشاشة الرئيسية لتطبيق العب واربح 🎮 (نسخة محسنة ومكتملة)
// -------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'wallet_screen.dart';
import 'social_screen.dart';
import 'billiards.dart';
import 'snakes_and_ladders.dart';
import 'dominoes.dart';
// استيراد شاشة لعبة لودو إذا كانت موجودة لديك، يمكنك إلغاء التعليق عند إضافتها:
// import 'game_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: const Color(0xFFff1fc2).withOpacity(0.8),
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'تطبيق العب واربح',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(width: 15),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.amber.withOpacity(0.5)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    '2,500',
                    style: TextStyle(
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.monetization_on, color: Colors.amber, size: 16),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.people, color: Colors.blueAccent),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SocialScreen()),
              );
            },
            tooltip: 'المجتمع والأصدقاء',
          ),
          IconButton(
            icon: const Icon(Icons.account_balance_wallet, color: Colors.amber),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WalletScreen()),
              );
            },
            tooltip: 'المحفظة والشحن',
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFff1fc2), Color(0xFF92bdab)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'اختر لعبتك المفضلة وابدأ التحدي:',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  children: [
                    // 1. لعبة البلياردو
                    _buildGameCard(
                      context,
                      title: 'لعبة البلياردو',
                      icon: Icons.sports_basketball,
                      color: Colors.green,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BilliardsScreen(),
                          ),
                        );
                      },
                    ),
                    // 2. السلم والثعبان
                    _buildGameCard(
                      context,
                      title: 'السلم والثعبان',
                      icon: Icons.grid_view,
                      color: Colors.orange,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SnakesAndLaddersScreen(),
                          ),
                        );
                      },
                    ),
                    // 3. لعبة الدومينو
                    _buildGameCard(
                      context,
                      title: 'لعبة الدومينو',
                      icon: Icons.extension,
                      color: Colors.blue,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DominoesScreen(),
                          ),
                        );
                      },
                    ),
                    // 4. لعبة لودو
                    _buildGameCard(
                      context,
                      title: 'لعبة لودو',
                      icon: Icons.casino,
                      color: Colors.red,
                      onTap: () {
                        // استبدل LudoScreen بالشاشة الخاصة بلعبة لودو عند توفرها
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('لعبة لودو قريباً!')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
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
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: color.withOpacity(0.1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
