import 'package:flutter/material.dart';
// استيراد ملفات الألعاب الأربع
import 'billiards.dart';
import 'snakes_and_ladders.dart';
import 'dominoes.dart';
// (يمكنك استيراد ملف لودو هنا أيضاً عندما يكون جاهزاً)

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('العب واربح - القائمة الرئيسية'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: [
            // زر لعبة البلياردو
            _buildGameCard(
              context,
              title: 'لعبة البلياردو',
              icon: Icons.sports_basketball, // استبدلها بأيقونة تناسب اللعبة
              color: Colors.green,
              onTap: () {
                // الانتقال المباشر لشاشة أو منطق البلياردو
                print("الانتقال إلى البلياردو");
              },
            ),
            // زر لعبة السلم والثعبان
            _buildGameCard(
              context,
              title: 'السلم والثعبان',
              icon: Icons.grid_view,
              color: Colors.orange,
              onTap: () {
                print("الانتقال إلى السلم والثعبان");
              },
            ),
            // زر لعبة الدومينو
            _buildGameCard(
              context,
              title: 'لعبة الدومينو',
              icon: Icons.extension,
              color: Colors.blue,
              onTap: () {
                print("الانتقال إلى الدومينو");
              },
            ),
            // زر لعبة لودو
            _buildGameCard(
              context,
              title: 'لعبة لودو',
              icon: Icons.casino,
              color: Colors.red,
              onTap: () {
                print("الانتقال إلى لودو");
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameCard(BuildContext context, {required String title, required IconData icon, required Color color, required VoidCallback onTap}) {
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
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
