// المسار: lib/game_screen.dart
import 'package:flutter/material.dart';

class GameScreen extends StatelessWidget {
  final String gameName;

  const GameScreen({Key? key, required this.gameName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(gameName),
        backgroundColor: const Color(0xFF0F172A),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0B0F19), Color(0xFF0F172A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.sports_esports, size: 80, color: Colors.amberAccent),
              const SizedBox(height: 20),
              Text(
                'جاري تحميل $gameName...',
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const CircularProgressIndicator(color: Colors.amberAccent),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                onPressed: () {
                  // العودة للصفحة الرئيسية واكتساب النقاط
                  Navigator.pop(context);
                },
                child: const Text('إنهاء اللعب والعودة', style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
