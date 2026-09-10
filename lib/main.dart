import 'package:flutter/material.dart';
import 'firebase_config.dart';
import 'home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await FirebaseConfig.initializeFirebase();
  } catch (e) {
    // تجاهل خطأ التهيئة المؤقت في حال عدم توفر إعدادات فايربيز الحقيقية حالياً
  }
  runApp(const PlayAndWinApp());
}

class PlayAndWinApp extends StatelessWidget {
  const PlayAndWinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Play and Win',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
