// استبدل محتوى ملف lib/main.dart بهذا الكود الكامل بعد التعديل:

import 'package:flutter/material.dart';

void main() {
  runApp(const PlayAndWinApp());
}

class PlayAndWinApp extends StatelessWidget {
  const PlayAndWinApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Play and Win',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.amber,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Play & Win - منصة الألعاب'),
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'عروض الشحن والبطاقات',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // الأسطر المعدلة بعلامة الهروب المانعة للخطأ:
            _buildOfferCard('عرض المبتدئين: احصل على 500 عملة + 50 وردة هدية*، 4.99\$'),
            _buildOfferCard('عرض الأعضاء المميزين: احصل على 1500 عملة + 200 وردة هدية*، 9.99\$'),
            _buildOfferCard('عرض النخبة الماسى: احصل على 5000 عملة + 600 وردة هدية*، 24.99\$'),
          ],
        ),
      ),
    );
  }

  Widget _buildOfferCard(String title) {
    return Card(
      color: const Color(0xFF1E293B),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          title,
          style: const TextStyle(color: Colors.amber, fontSize: 16),
        ),
      ),
    );
  }
}
