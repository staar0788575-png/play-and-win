import 'package:flutter/material.dart';

class QuickGamesScreen extends StatelessWidget {
  const QuickGamesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // لون خلفية التطبيق الداكنة
      appBar: AppBar(
        title: const Text('الألعاب السريعة', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1E293B),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildGameCard(
              context,
              title: 'لعبة اللودو (Ludo)',
              description: 'العب ونافس الأصدقاء واجمع النقاط!',
              icon: Icons.casino,
              color: Colors.redAccent,
              onTap: () {
                _showGameDialog(context, 'لعبة اللودو');
              },
            ),
            const SizedBox(height: 16),
            _buildGameCard(
              context,
              title: 'السلم والثعبان',
              description: 'حرك النرد وتجنب الثعبان لتصل إلى القمة!',
              icon: Icons.trending_up,
              color: Colors.greenAccent,
              onTap: () {
                _showGameDialog(context, 'لعبة السلم والثعبان');
              },
            ),
            const SizedBox(height: 16),
            _buildGameCard(
              context,
              title: 'البلياردو',
              description: 'أظهر مهاراتك في التصويب وربح الجوائز!',
              icon: Icons.sports_bar,
              color: Colors.blueAccent,
              onTap: () {
                _showGameDialog(context, 'لعبة البلياردو');
              },
            ),
            const SizedBox(height: 16),
            _buildGameCard(
              context,
              title: 'الدومينو',
              description: 'تحدي الذكاء والتركيز في رص الاحجار!',
              icon: Icons.grid_view,
              color: Colors.amber,
              onTap: () {
                _showGameDialog(context, 'لعبة الدومينو');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameCard(BuildContext context, {required String title, required String description, required IconData icon, required Color color, required VoidCallback onTap}) {
    return Card(
      color: const Color(0xFF1E293B),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          radius: 30,
          child: Icon(icon, color: color, size: 32),
        ),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            description,
            style: TextStyle(color: Colors.grey[400], fontSize: 14),
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 18),
        onTap: onTap,
      ),
    );
  }

  void _showGameDialog(BuildContext context, String gameName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: Text(gameName, style: const TextStyle(color: Colors.white)),
        content: Text(
          'أنت على وشك البدء في $gameName! جاري تهيئة بيئة اللعبة وربطها بنظام النقاط...',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('بدء اللعب', style: TextStyle(color: Colors.orangeAccent)),
          ),
        ],
      ),
    );
  }
}
