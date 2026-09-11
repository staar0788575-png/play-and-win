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
        child: Column(
          children: [
            // بطاقة زر لعبة لودو
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LudoGameScreen()),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF334155),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.orange, width: 2),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.casino, color: Colors.orange, size: 40),
                    SizedBox(width: 16),
                    Text(
                      'لعبة لودو الملكية',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// شاشة لعبة لودو التفاعلية المرتبطة بالمحفظة
class LudoGameScreen extends StatefulWidget {
  const LudoGameScreen({Key? key}) : super(key: key);

  @override
  State<LudoGameScreen> createState() => _LudoGameScreenState();
}

class _LudoGameScreenState extends State<LudoGameScreen> {
  int _diceValue = 1;
  bool _isRolling = false;

  void _rollDice() {
    setState(() {
      _isRolling = true;
    });

    Future.delayed(const Duration(milliseconds: 400), () {
      setState(() {
        _diceValue = Random().nextInt(6) + 1;
        WalletData.addEarnings(_diceValue * 5.0); // إضافة أرباح للمحفظة
        _isRolling = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لعبة لودو', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1E293B),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'رصيد المحفظة الحالي: \$${WalletData.balance.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.amber, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.orange, width: 2),
              ),
              child: Center(
                child: Text(
                  _isRolling ? '...' : '$_diceValue',
                  style: const TextStyle(color: Colors.orange, fontSize: 50, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _isRolling ? null : _rollDice,
              child: Text(
                _isRolling ? 'جاري رمي النرد...' : 'ارمِ النرد واربح',
                style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
