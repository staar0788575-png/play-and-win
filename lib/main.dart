import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Play and Win',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('العب واربح'),
          backgroundColor: const Color(0xFF1E293B),
        ),
        backgroundColor: const Color(0xFF1E293B),
        body: const Center(
          child: Text(
            'التطبيق يعمل بنجاح',
            style: TextStyle(color: Colors.white, fontSize: 22),
          ),
        ),
      ),
    );
  }
}
