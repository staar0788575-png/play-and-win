// ====================================================================
// (Main App File) - ملف التشغيل الرئيسي لمشروع "العب واربح" 🎮
// ====================================================================

import 'package:flutter/material.dart';
import 'game_lobby.dart'; // استيراد ملف صالة الألعاب الرئيسي

void main() {
  runApp(const PlayAndWinApp());
}

class PlayAndWinApp extends StatelessWidget {
  const PlayAndWinApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'العب واربح',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        brightness: Brightness.dark,
      ),
      home: const GameLobbyScreen(), // تشغيل صالة الألعاب كواجهة أولية
    );
  }
}
