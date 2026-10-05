import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';
import 'package:flutter/services.dart';

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

// ================= الشاشة الرئيسية فيها الألعاب + زرار الشحن =================
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int tab = 0;
  @override
  Widget build(BuildContext context) {
    Widget body;
    if (tab == 0) { body = const LudoRoyalFull(); }
    else if (tab == 1) { body = const CarromProFull(); }
    else { body = const SnakeLadderFull(); }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Play & Win - منصة الألعاب'),
        backgroundColor: const Color(0xFF1E293B),
        actions: [
          // زرار الشحن اللي يفتح صفحة منفصلة
          IconButton(
            icon: const Icon(Icons.diamond, color: Colors.amber),
            tooltip: 'الشحن',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (c) => const ShopScreen()));
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: tab,
        onTap: (i) { setState(() { tab = i; }); },
        backgroundColor: const Color(0xFF0A1931),
        selectedItemColor: const Color(0xFFFFD700),
        unselectedItemColor: Colors.white54,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.casino), label: "لودو"),
          BottomNavigationBarItem(icon: Icon(Icons.circle), label: "كيرم"),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: "سلم"),
        ],
      ),
    );
  }
}

// ================= صفحة الشحن المنفصلة - نفس كودك بالظبط =================
class ShopScreen extends StatelessWidget {
  const ShopScreen({Key? key}) : super(key: key);
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
        child: Text(title, style: const TextStyle(color: Colors.amber, fontSize: 16)),
      ),
    );
  }
}

// ================= باقي الأكواد - 3 ألعاب كاملة بدون حذف =================
class SoundManager {
  static void dice() { HapticFeedback.mediumImpact(); }
  static void move() { HapticFeedback.lightImpact(); }
  static void capture() { HapticFeedback.heavyImpact(); }
  static void win() { HapticFeedback.vibrate(); }
  static void hit() { HapticFeedback.selectionClick(); }
  static void pot() { HapticFeedback.lightImpact(); }
}

class CarromProFull extends CarromProLikeImage { const CarromProFull({super.key}); }
class SnakeLadderFull extends SnakeLadderRoyal { const SnakeLadderFull({super.key}); }

class CarromPiece {
  Offset pos; Color color; bool isWhite; bool isQueen; bool isStriker; Offset vel;
  CarromPiece(this.pos, this.color, this.isWhite, {this.isQueen = false, this.isStriker = false}) : vel = Offset.zero;
}
class CarromImagePainter extends CustomPainter {
  @override void paint(Canvas canvas, Size size) {
    final p = Paint()..color = const Color(0xFF8D6E63).withOpacity(0.7)..style = PaintingStyle.stroke..strokeWidth = 1.5;
    double inset = size.width * 0.14;
    RRect r = RRect.fromRectAndRadius(Rect.fromLTWH(inset, inset, size.width - inset * 2, size.height - inset * 2), const Radius.circular(32));
    canvas.drawRRect(r, p);
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
class AimPainter extends CustomPainter {
  final Offset from; final Offset to; final double power;
  AimPainter(this.from, this.to, this.power);
  @override void paint(Canvas c, Size s) { var p = Paint()..color = const Color(0xE6FFFFFF)..strokeWidth = 3..style = PaintingStyle.stroke; c.drawLine(from, to, p); }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ================= LUDO FULL =================
class LudoRoyalFull extends StatefulWidget { const LudoRoyalFull({super.key}); @override State<LudoRoyalFull> createState() => _LudoRoyalFullState(); }
class _LudoRoyalFullState extends State<LudoRoyalFull> {
  int dice = 6; int turn = 0; int winner = -1; int countdown = 10;
  bool canRoll = true; bool gameOver = false; bool micOn = true; bool privateMode = false;
  String msg = "جبت 6"; String flyingEmoji = ""; String selectedGift = "";
  List<List<int>> tokens = [[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1]];
  List<int> start = [0,39,13,26]; List<int> safe = [0,8,13,21,26,34,39,47];
  List<List<int>> homePath = [[52,53,54,55,56,57],[58,59,60,61,62,63],[64,65,66,67,68,69],[70,71,72,73,74,75]];
  List<String> publicChat = ["P3: عاش 💪","Me: السلام عليكم"]; List<String> privateChat = ["P1 خاص: يلا"];
  List<String> gifts = ["❤️","🌹","👑","🚗","🦁","💎"]; List<String> emojis = ["😂","😡","😍","👏","🎉","🔥"];
  TextEditingController chatCtrl = TextEditingController(); Timer? countdownTimer;
  List<Offset> path = [const Offset(6,1),const Offset(6,2),const Offset(6,3),const Offset(6,4),const Offset(6,5),const Offset(5,6),const Offset(4,6),const Offset(3,6),const Offset(2,6),const Offset(1,6),const Offset(0,6),const Offset(0,7),const Offset(0,8),const Offset(1,8),const Offset(2,8),const Offset(3,8),const Offset(4,8),const Offset(5,8),const Offset(6,9),const Offset(6,10),const Offset(6,11),const Offset(6,12),const Offset(6,13),const Offset(6,14),const Offset(7,14),const Offset(8,14),const Offset(8,13),const Offset(8,12),const Offset(8,11),const Offset(8,10),const Offset(8,9),const Offset(9,8),const Offset(10,8),const Offset(11,8),const Offset(12,8),const Offset(13,8),const Offset(14,8),const Offset(14,7),const Offset(14,6),const Offset(13,6),const Offset(12,6),const Offset(11,6),const Offset(10,6),const Offset(9,6),const Offset(8,5),const Offset(8,4),const Offset(8,3),const Offset(8,2),const Offset(8,1),const Offset(8,0),const Offset(7,0),const Offset(6,0)];
  Map<int,Offset> homeC = {52:const Offset(7,1),53:const Offset(7,2),54:const Offset(7,3),55:const Offset(7,4),56:const Offset(7,5),57:const Offset(7,6),58:const Offset(13,7),59:const Offset(12,7),60:const Offset(11,7),61:const Offset(10,7),62:const Offset(9,7),63:const Offset(8,7),64:const Offset(1,7),65:const Offset(2,7),66:const Offset(3,7),67:const Offset(4,7),68:const Offset(5,7),69:const Offset(6,7),70:const Offset(7,13),71:const Offset(7,12),72:const Offset(7,11),73:const Offset(7,10),74:const Offset(7,9),75:const Offset(7
