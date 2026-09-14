// ==============================================================================
// 📱 ملف التشغيل الرئيسي - مشروع "العب واربح" (play-and-win)
// ==============================================================================

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
      home: const LudoGameController(),
    );
  }
}
