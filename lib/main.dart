// المسار: lib/main.dart
import 'package:flutter/material.dart';
import 'game_screen.dart';

void main() {
  runApp(const PlayAndWinApp());
}

class PlayAndWinApp extends StatelessWidget {
  const PlayAndWinApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'العب واربح',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFF0F0B19),
      ),
      // جعل شاشة اللودو التي أنشأناها هي الشاشة الرئيسية للتطبيق
      home: const LudoGameController(),
    );
  }
}
