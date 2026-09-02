import 'package:flutter/material.dart';
import 'dart:math' as math;

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
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0E1A),
        primaryColor: const Color(0xFFD4AF37),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> games = [
      {'title': 'لودو الملكية', 'icon': Icons.casino, 'color': Colors.amber},
      {'title': 'السلم والثعبان', 'icon': Icons.trending_up, 'color': Colors.greenAccent},
      {'title': 'البلياردو الاحترافي', 'icon': Icons.sports_bar, 'color': Colors.blueAccent},
      {'title': 'الدومينو الكلاسيكية', 'icon': Icons.grid_view, 'color': Colors.orangeAccent},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('العب واربح - الرئيسية', style: TextStyle(color: Color(0xFFD4AF37))),
        backgroundColor: const Color(0xFF141A29),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.card_giftcard, color: Color(0xFFD4AF37)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LuckyWheelScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // زر عجلة الحظ البارز
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LuckyWheelScreen()),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFD4AF37), Color(0xFFAA820A)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFD4AF37).withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: const [
                    Icon(Icons.stars, color: Colors.black, size: 40),
                    SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'عجلة الحظ اليومية',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                          SizedBox(height: 3),
                          Text(
                            'العب واربح جوائز يومية مجانية الآن!',
                            style: TextStyle(fontSize: 13, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, color: Colors.black, size: 18),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'الألعاب المتاحة',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFD4AF37)),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 1.1,
                ),
                itemCount: games.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF141A29),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: games[index]['color'].withOpacity(0.3)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(games[index]['icon'], size: 50, color: games[index]['color']),
                        const SizedBox(height: 12),
                        Text(
                          games[index]['title'],
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LuckyWheelScreen extends StatefulWidget {
  const LuckyWheelScreen({Key? key}) : super(key: key);

  @override
  State<LuckyWheelScreen> createState() => _LuckyWheelScreenState();
}

class _LuckyWheelScreenState extends State<LuckyWheelScreen> {
  bool canSpin = true;
  String prizeResult = "اضغط على زر الدوران لاختبار حظك!";

  void spinWheel() {
    if (!canSpin) return;
    setState(() {
      canSpin = false;
      prizeResult = "جاري تدوير العجلة...";
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        prizeResult = "مبروك! حصلت على 500 جوهرة ذهبية 🎉";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('عجلة الحظ اليومية', style: TextStyle(color: Color(0xFFD4AF37))),
        backgroundColor: const Color(0xFF141A29),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFD4AF37), int.parse('4') == 4 ? 4 : 4),
                  gradient: const RadialGradient(
                    colors: [Color(0xFF1A1F35), Color(0xFF0A0E1A)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFD4AF37).withOpacity(0.3),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(Icons.star_rounded, size: 90, color: Color(0xFFD4AF37)),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                prizeResult,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: canSpin ? const Color(0xFFD4AF37) : Colors.grey,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: canSpin ? spinWheel : null,
                child: Text(
                  canSpin ? 'دور الآن (مرة واحدة اليوم)' : 'تم الاستخدام اليوم',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

