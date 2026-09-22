import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'game_lobby.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // هنحاول نشغل فايربيس، لو فشل التطبيق هيكمل عادي
  try {
    await Firebase.initializeApp();
    print("Firebase اشتغل تمام");
  } catch (e) {
    print("Firebase فيه مشكلة بس هنكمل: $e");
  }

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
      home: const SplashWrapper(),
    );
  }
}

// دي الشاشة اللي هتحل مشكلتك
class SplashWrapper extends StatefulWidget {
  const SplashWrapper({Key? key}) : super(key: key);
  @override
  State<SplashWrapper> createState() => _SplashWrapperState();
}

class _SplashWrapperState extends State<SplashWrapper> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const GameLobbyScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.videogame_asset, size: 100, color: Colors.indigo),
            SizedBox(height: 20),
            Text('العب واربح', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 10),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
