import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';
import 'package:flutter/services.dart';

void main() {
  runApp(
    const MaterialApp(
      home: GameHub(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class SoundManager {
  static void dice() {
    HapticFeedback.mediumImpact();
    SystemSound.play(SystemSoundType.click);
  }
  static void move() {
    HapticFeedback.lightImpact();
  }
  static void capture() {
    HapticFeedback.heavyImpact();
    SystemSound.play(SystemSoundType.alert);
  }
  static void win() {
    HapticFeedback.vibrate();
  }
  static void carromHit() {
    HapticFeedback.selectionClick();
  }
  static void carromPot() {
    HapticFeedback.lightImpact();
  }
}

class CarromPiece {
  Offset pos;
  Color color;
  bool isWhite;
  bool isQueen;
  bool isStriker;
  Offset vel;
  CarromPiece(
    this.pos,
    this.color,
    this.isWhite, {
    this.isQueen = false,
    this.isStriker = false,
  }) : vel = Offset.zero;
}

class CarromImagePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var p = Paint()
     ..color = const Color(0xFF8D6E63).withOpacity(0.7)
     ..style = PaintingStyle.stroke
     ..strokeWidth = 1.5;
    double inset = size.width * 0.14;
    RRect r = RRect.fromRectAndRadius(
      Rect.fromLTWH(inset, inset, size.width - inset * 2, size.height - inset * 2),
      const Radius.circular(32),
    );
    canvas.drawRRect(r, p);
    var yellow = Paint()
     ..color = const Color(0xFFFFD54F)
     ..style = PaintingStyle.fill;
    var border = Paint()
     ..color = const Color(0xFF8D6E63)
     ..style = PaintingStyle.stroke
     ..strokeWidth = 2;
    double rad = size.width * 0.05;
    List<Offset> pts = [
      Offset(inset + 18, inset + 18),
      Offset(size.width - inset - 18, inset + 18),
      Offset(inset + 18, size.height / 2 - 20),
      Offset(size.width - inset - 18, size.height / 2 - 20),
      Offset(inset + 18, size.height / 2 + 20),
      Offset(size.width - inset - 18, size.height / 2 + 20),
      Offset(inset + 18, size.height - inset - 18),
      Offset(size.width - inset - 18, size.height - inset - 18),
    ];
    for (var pt in pts) {
      canvas.drawCircle(pt, rad, yellow);
      canvas.drawCircle(pt, rad, border);
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class AimPainterPro extends CustomPainter {
  Offset from;
  Offset to;
  double power;
  AimPainterPro(this.from, this.to, this.power);
  @override
  void paint(Canvas c, Size s) {
    var p = Paint()
     ..color = const Color(0xE6FFFFFF)
     ..strokeWidth = 3
     ..style = PaintingStyle.stroke
     ..strokeCap = StrokeCap.round;
    c.drawLine(from, to, p);
    Offset dir = to - from;
    double len = dir.distance;
    if (len > 0) {
      Offset n = dir / len;
      c.drawLine(
        to,
        to + n * power * 300,
        Paint()
         ..color = const Color(0xFFFFFF00)
         ..strokeWidth = 4
         ..style = PaintingStyle.stroke,
      );
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter o) => true;
}

class GameHub extends StatefulWidget {
  const GameHub({super.key});
  @override
  State<GameHub> createState() => _GameHubState();
}

class _GameHubState extends State<GameHub> {
  int tab = 0;
  @override
  Widget build(BuildContext context) {
    Widget body;
    if (tab == 0) {
      body = LudoRoyalFull();
    } else if (tab == 1) {
      body = CarromProLikeImage();
    } else {
      body = SnakeLadderRoyal();
    }
    return Scaffold(
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: tab,
        onTap: (i) {
          setState(() {
            tab = i;
          });
        },
        backgroundColor: const Color(0xFF0A1931),
        selectedItemColor: const Color(0xFFFFD700),
        unselectedItemColor: Colors.white54,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.workspace_premium), label: "لودو"),
          BottomNavigationBarItem(icon: Icon(Icons.circle), label: "كيرم"),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: "سلم وثعبان"),
        ],
      ),
    );
  }
}

// ================= LUDO FULL =================
class LudoRoyalFull extends StatefulWidget {
  @override
  State<LudoRoyalFull> createState() => _LudoRoyalFullState();
}

class _LudoRoyalFullState extends State<LudoRoyalFull> {
  int dice = 6;
  int turn = 0;
  int winner = -1;
  int countdown = 10;
  bool canRoll = true;
  bool gameOver = false;
  bool micOn = true;
  bool privateMode = false;
  String msg = "جبت 6";
  String flyingEmoji = "";
  String selectedGift = "";

  List<List<int>> tokens = [
    [-1, -1, -1, -1],
    [-1, -1, -1, -1],
    [-1, -1, -1, -1],
    [-1, -1, -1, -1]
  ];

  List<int> start = [0, 39, 13, 26];
  List<int> safe = [0, 8, 13, 21, 26, 34, 39, 47];

  List<List<int>> homePath = [
    [52, 53, 54, 55, 56, 57],
    [58, 59, 60, 61, 62, 63],
    [64, 65, 66, 67, 68, 69],
    [70, 71, 72, 73, 74, 75]
  ];

  List<String> publicChat = ["P3: عاش 💪", "Me: السلام عليكم", "P1: يلا نلعب 👑"];
  List<String> privateChat = ["P1 خاص: يلا"];
  List<String> gifts = ["❤️", "🌹", "👑", "🚗", "🦁", "💎"];
  List<String> emojis = ["😂", "😡", "😍", "👏", "🎉", "🔥"];

  TextEditingController chatCtrl = TextEditingController();
  Timer? countdownTimer;

  List<Offset> path = [
    const Offset(6, 1), const Offset(6, 2), const Offset(6, 3), const Offset(6, 4), const Offset(6, 5),
    const Offset(5, 6), const Offset(4, 6), const Offset(3, 6), const Offset(2, 6), const Offset(1, 6), const Offset(0, 6),
    const Offset(0, 7), const Offset(0, 8), const Offset(1, 8), const Offset(2, 8), const Offset(3, 8), const Offset(4, 8), const Offset(5, 8),
    const Offset(6, 9), const Offset(6, 10), const Offset(6, 11), const Offset(6, 12), const Offset(6, 13), const Offset(6, 14),
    const Offset(7, 14), const Offset(8, 13), const Offset(8, 12), const Offset(8, 11), const Offset(8, 10), const Offset(8, 9),
    const Offset(9, 8), const Offset(10, 8), const Offset(11, 8), const Offset(12, 8), const Offset(13, 8), const Offset(14, 8),
    const Offset(14, 7), const Offset(14, 6), const Offset(13, 6), const Offset(12, 6), const Offset(11, 6), const Offset(10, 6), const Offset(9, 6),
    const Offset(8, 5), const Offset(8, 4), const Offset(8, 3), const Offset(8, 2), const Offset(8, 1), const Offset(8, 0), const Offset(7, 0), const Offset(6, 0),
  ];

  Map<int, Offset> homeC = {
    52: const Offset(7, 1), 53: const Offset(7, 2), 54: const Offset(7, 3), 55: const Offset(7, 4), 56: const Offset(7, 5), 57: const Offset(7, 6),
    58: const Offset(13, 7), 59: const Offset(12, 7), 60: const Offset(11, 7), 61: const Offset(10, 7), 62: const Offset(9, 7), 63: const Offset(8, 7),
    64: const Offset(1, 7), 65: const Offset(2, 7), 66: const Offset(3, 7), 67: const Offset(4, 7), 68: const Offset(5, 7), 69: const Offset(6, 7),
    70: const Offset(7, 13), 71: const Offset(7, 12), 72: const Offset(7, 11), 73: const Offset(7, 10), 74: const Offset(7, 9), 75: const Offset(7, 8),
  };

  void checkWin() {
    for (int p = 0; p < 4; p++) {
      if (tokens[p].every((e) => e == 100)) {
        setState(() {
          gameOver = true;
          winner = p;
          countdown = 10;
        });
        SoundManager.win();
        startCountdown();
        break;
      }
    }
  }

  void startCountdown() {
    countdownTimer?.cancel();
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() {
        countdown--;
      });
      if (countdown <= 0) {
        t.cancel();
        resetGame();
      }
    });
  }

  void resetGame() {
    setState(() {
      tokens = [
        [-1, -1, -1, -1],
        [-1, -1, -1, -1],
        [-1, -1, -1, -1],
        [-1, -1
