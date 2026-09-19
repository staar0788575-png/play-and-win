// ---------------------------------------------------------
// (Main App File) - ملف التشغيل الرئيسي لمشروع "العب واربح" 🎮
// ---------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // تم إلغاء التعليق لتفعيل فايربيس
import 'game_lobby.dart'; // استيراد ملف الواجهة الرئيسية للعبة

void main() async {
  // ضمان تهيئة الفلاتر قبل تحميل خدمات فايربيس
  WidgetsFlutterBinding.ensureInitialized();

  // تفعيل فايربيس بشكل صحيح وحل مشكلة الخطأ الظاهرة
  await Firebase.initializeApp();

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
      home: const GameLobbyScreen(), // تشغيل صالة الألعاب بواجهة لودو أولاً
    );
  }
}
