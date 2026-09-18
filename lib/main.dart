// ====================================================================
// (Main App File) - ملف التشغيل الرئيسي لمشروع "العب واربح" 🎮
// ====================================================================

import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart'; // قم بإلغاء التعليق عند تفعيل فايربيس
import 'game_lobby.dart'; // استيراد ملف الشاشة الرئيسية للعبة

void main() async {
  // ضمان تهيئة الفلاتر قبل تشغيل خدمات فايربيس
  WidgetsFlutterBinding.ensureInitialized();
  
  // تهيئة فايربيس (قم بتفعيل السطر التالي بعد إضافة ملفات التكوين)
  // await Firebase.initializeApp();

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
      home: const GameLobbyScreen(), // تشغيل صالة الألعاب تواجه أولاً
    );
  }
}
