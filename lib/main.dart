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
        title: const Text('العب واربح - المرحلة الأولى', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // المرحلة الحالية: لعبة لودو الحقيقية
            _buildGameButton(
              context,
              'لعبة لودو الملكية الحقيقية (المرحلة 1)',
              Icons.casino,
              Colors.orange,
              const LudoRealGameScreen(),
            ),
            const SizedBox(height: 12),
            _buildGameButton(
              context,
              'لعبة السلم والثعبان (قريباً في المرحلة 2)',
              Icons.straighten,
              Colors.grey,
              const PlaceholderScreen(title: 'السلم والثعبان - قريباً'),
            ),
            const SizedBox(height: 12),
            _buildGameButton(
              context,
              'لعبة البلياردو الاحترافية (قريباً في المرحلة 3)',
              Icons.sports_bar,
              Colors.grey,
              const PlaceholderScreen(title: 'البلياردو - قريباً'),
            ),
            const SizedBox(height: 12),
            _buildGameButton(
              context,
              'لعبة الدومينو الذكية (قريباً في المرحلة 4)',
              Icons.dashboard,
              Colors.grey,
              const PlaceholderScreen(title: 'الدومينو - قريباً'),
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
            Expanded(
              child: Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// شاشة مؤقتة للألعاب القادمة
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title, style: const TextStyle(color: Colors.white)), backgroundColor: const Color(0xFF1E293B), iconTheme: const IconThemeData(color: Colors.white)),
      body: Center(
        child: Text(
          'هذه اللعبة قيد التجهيز للمرحلة القادمة!',
          style: const TextStyle(color: Colors.amber, fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

// 🎲 المرحلة الأولى: شاشة لعبة لودو الحقيقية واللوحة المرئية
class LudoRealGameScreen extends StatefulWidget {
  const LudoRealGameScreen({Key? key}) : super(key: key);

  @override
  State<LudoRealGameScreen> createState() => _LudoRealGameScreenState();
}

class _LudoRealGameScreenState extends State<LudoRealGameScreen> {
  int _diceValue = 6;
  int _tokenPosition = 0; // من 0 إلى 20 كمحاكاة لمسار اللوحة المرئي
  bool _isRolling = false;
  String _message = 'اضغط لرمي النرد وحرك قطعة اللودو على اللوحة!';

  void _rollDiceAndMove() {
    setState(() => _isRolling = true);
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _diceValue = Random().nextInt(6) + 1;
        
        if (_tokenPosition == 0 && _diceValue == 6) {
          _tokenPosition = 1;
          _message = 'ممتاز! خرجت القطعة من البيت إلى اللوحة.';
          WalletData.addEarnings(15.00);
        } else if (_tokenPosition > 0) {
          _tokenPosition += _diceValue;
          if (_tokenPosition >= 20) {
            _tokenPosition = 20;
            _message = 'تهانينا! وصلت القطعة لخط النهاية وربحت \$100!';
            WalletData.addEarnings(100.00);
          } else {
            _message = 'تقدمت القطعة على اللوحة بمقدار $_diceValue خطوات.';
            WalletData.addEarnings(_diceValue * 3.0);
          }
        } else {
          _message = 'تحتاج إلى ظهور رقم 6 لإخراج القطعة من البيت!';
        }
        _isRolling = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
}
