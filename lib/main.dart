import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class WalletData {
  static double balance = 1250.00;
  static void addEarnings(double amount) {
    balance += amount;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Play and Win',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF1E293B),
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
        title: const Text('العب واربح', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // زر لعبة لودو
            _buildGameButton(
              context,
              'لعبة لودو الملكية',
              Icons.casino,
              Colors.orange,
              const LudoGameScreen(),
            ),
            const SizedBox(height: 12),
            // زر لعبة السلم والثعبان
            _buildGameButton(
              context,
              'لعبة السلم والثعبان',
              Icons.straighten,
              Colors.green,
              const SnakesGameScreen(),
            ),
            const SizedBox(height: 12),
            // زر لعبة البلياردو
            _buildGameButton(
              context,
              'لعبة البلياردو الاحترافية',
              Icons.sports_bar,
              Colors.blueAccent,
              const BilliardsGameScreen(),
            ),
            const SizedBox(height: 12),
            // زر لعبة الدومينو
            _buildGameButton(
              context,
              'لعبة الدومينو الذكية',
              Icons.dashboard,
              Colors.purple,
              const DominoGameScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameButton(BuildContext context, String title, IconData icon, Color color, Widget screen) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF334155),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color, width: 2),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 35),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

// 1. شاشة لعبة لودو
class LudoGameScreen extends StatefulWidget {
  const LudoGameScreen({Key? key}) : super(key: key);

  @override
  State<LudoGameScreen> createState() => _LudoGameScreenState();
}

class _LudoGameScreenState extends State<LudoGameScreen> {
  int _diceValue = 1;
  bool _isRolling = false;

  void _rollDice() {
    setState(() => _isRolling = true);
    Future.delayed(const Duration(milliseconds: 400), () {
      setState(() {
        _diceValue = Random().nextInt(6) + 1;
        WalletData.addEarnings(_diceValue * 5.0);
        _isRolling = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('لعبة لودو', style: TextStyle(color: Colors.white)), backgroundColor: const Color(0xFF1E293B), iconTheme: const IconThemeData(color: Colors.white)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('رصيد المحفظة: \$${WalletData.balance.toStringAsFixed(2)}', style: const TextStyle(color: Colors.amber, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            Container(
              width: 120, height: 120,
              decoration: BoxDecoration(color: Colors.orange.withOpacity(0.2), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.orange, width: 2)),
              child: Center(child: Text(_isRolling ? '...' : '$_diceValue', style: const TextStyle(color: Colors.orange, fontSize: 50, fontWeight: FontWeight.bold))),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, minimumSize: const Size(double.infinity, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              onPressed: _isRolling ? null : _rollDice,
              child: Text(_isRolling ? 'جاري رمي النرد...' : 'ارمِ النرد واربح', style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

// 2. شاشة السلم والثعبان
class SnakesGameScreen extends StatefulWidget {
  const SnakesGameScreen({Key? key}) : super(key: key);

  @override
  State<SnakesGameScreen> createState() => _SnakesGameScreenState();
}

class _SnakesGameScreenState extends State<SnakesGameScreen> {
  int _position = 1;
  int _diceValue = 1;
  bool _isRolling = false;
  String _message = 'اصعد السلالم واربح أرباحاً فورية!';

  void _rollAndMove() {
    setState(() => _isRolling = true);
    Future.delayed(const Duration(milliseconds: 400), () {
      setState(() {
        _diceValue = Random().nextInt(6) + 1;
        _position += _diceValue;
        if (_position >= 30) {
          _message = 'تهانينا! وصلت للنهاية وربحت \$10 إضافية!';
          WalletData.addEarnings(10.00);
          _position = 30;
        } else {
          _message = 'تقدمت للخانة رقم: $_position';
          WalletData.addEarnings(2.00);
        }
        _isRolling = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('لعبة السلم والثعبان', style: TextStyle(color: Colors.white)), backgroundColor: const Color(0xFF1E293B), iconTheme: const IconThemeData(color: Colors.white)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('الخانة الحالية: $_position / 30', style: const TextStyle(color: Colors.greenAccent, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            Container(
              width: 100, height: 100,
              decoration: BoxDecoration(color: Colors.green.withOpacity(0.2), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.green, width: 2)),
              child: Center(child: Text(_isRolling ? '...' : '$_diceValue', style: const TextStyle(color: Colors.green, fontSize: 40, fontWeight: FontWeight.bold))),
            ),
            const SizedBox(height: 20),
            Text(_message, style: const TextStyle(color: Colors.amber, fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, minimumSize: const Size(double.infinity, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              onPressed: _isRolling ? null : _rollAndMove,
              child: Text(_isRolling ? 'جاري التحرك...' : 'ارمِ النرد وتقدم', style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

// 3. شاشة البلياردو
class BilliardsGameScreen extends StatefulWidget {
  const BilliardsGameScreen({Key? key}) : super(key: key);

  @override
  State<BilliardsGameScreen> createState() => _BilliardsGameScreenState();
}

class _BilliardsGameScreenState extends State<BilliardsGameScreen> {
  int _ballsPocketed = 0;
  String _status = 'صوب بدقة لتسجيل الكرات في الجيوب!';
  bool _isShooting = false;

  void _shootBall() {
    setState(() => _isShooting = true);
    Future.delayed(const Duration(milliseconds: 400), () {
      setState(() {
        bool success = Random().nextBool();
        if (success) {
          _ballsPocketed += 1;
          _status = 'رائعة! دخلت الكرة وأُضيفت \$3 للمحفظة.';
          WalletData.addEarnings(3.00);
        } else {
          _status = 'خارج الجيب! حاول التركيز في التصويب القادم.';
        }
        _isShooting = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('لعبة البلياردو', style: TextStyle(color: Colors.white)), backgroundColor: const Color(0xFF1E293B), iconTheme: const IconThemeData(color: Colors.white)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('الكرات المسجلة: $_ballsPocketed', style: const TextStyle(color: Colors.blueAccent, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            Container(
              width: 100, height: 100,
              decoration: BoxDecoration(color: Colors.blueAccent.withOpacity(0.2), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.blueAccent, width: 2)),
              child: const Center(child: Icon(Icons.sports_bar, color: Colors.blueAccent, size: 45)),
            ),
            const SizedBox(height: 20),
            Text(_status, style: const TextStyle(color: Colors.amber, fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, minimumSize: const Size(double.infinity, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              onPressed: _isShooting ? null : _shootBall,
              child: Text(_isShooting ? 'جاري التصويب...' : 'صوب الآن واربح', style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

// 4. شاشة الدومينو
class DominoGameScreen extends StatefulWidget {
  const DominoGameScreen({Key? key}) : super(key: key);

  @override
  State<DominoGameScreen> createState() => _DominoGameScreenState();
}

class _DominoGameScreenState extends State<DominoGameScreen> {
  int _dominoScore = 0;
  String _dominoStatus = 'طابق قطع الدومينو واكسب النقاط!';
  bool _isPlaying = false;

  void _playDomino() {
    setState(() => _isPlaying = true);
    Future.delayed(const Duration(milliseconds: 400), () {
      setState(() {
        int earned = (Random().nextInt(5) + 1) * 5;
        _dominoScore += earned;
        WalletData.addEarnings(earned * 0.2);
        _dominoStatus = 'تمت المطابقة بنجاح! تم ربح أرباح للمحفظة.';
        _isPlaying = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('لعبة الدومينو', style: TextStyle(color: Colors.white)), backgroundColor: const Color(0xFF1E293B), iconTheme: const IconThemeData(color: Colors.white)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('مجموع النقاط: $_dominoScore', style: const TextStyle(color: Colors.purpleAccent, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            Container(
              width: 100, height: 100,
              decoration: BoxDecoration(color: Colors.purple.withOpacity(0.2), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.purple, width: 2)),
              child: const Center(child: Icon(Icons.dashboard, color: Colors.purple, size: 45)),
            ),
            const SizedBox(height: 20),
            Text(_dominoStatus, style: const TextStyle(color: Colors.amber, fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, minimumSize: const Size(double.infinity, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              onPressed: _isPlaying ? null : _playDomino,
              child: Text(_isPlaying ? 'جاري اللعب...' : 'العب قطعة دومينو', style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
