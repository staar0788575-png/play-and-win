import 'dart:math';
import 'package:flutter/material.dart';

class LudoGamePage extends StatefulWidget {
  const LudoGamePage({Key? key}) : super(key: key);

  @override
  _LudoGamePageState createState() => _LudoGamePageState();
}

class _LudoGamePageState extends State<LudoGamePage> {
  // رصيد المحافظة (افتراضي)
  double walletBalance = 1250.00;
  
  // قيمة النرد الحالية
  int diceValue = 1;
  bool isRolling = false;

  // دالة رمي النرد عشوائياً من 1 إلى 6
  void rollDice() {
    setState(() {
      isRolling = true;
    });

    // محاكاة حركة النرد البسيطة
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        diceValue = Random().nextInt(6) + 1;
        isRolling = false;
        // يمكنك هنا إضافة منطق تحديث الأرباح أو رصيد المحفظة بناءً على النتيجة
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E2738), // نفس لون خلفية التطبيق لديك
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E2738),
        elevation: 0,
        title: const Text(
          'لعبة لودو',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // عرض رصيد المحفظة
            Text(
              'رصيد المحفظة: \$${walletBalance.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Color(0xFFFFB300),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),

            // لوحة اللعبة أو شكل مبسط يمثل لوحة لودو (قاعدة القطع والمسار)
            Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                color: const Color(0xFF2A3447),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFFFB300), width: 2),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // أركان اللوحة الأربعة (منازل اللاعبين كمثال مرئي للودو)
                  Positioned(top: 15, left: 15, child: _buildBaseCorner(Colors.red)),
                  Positioned(top: 15, right: 15, child: _buildBaseCorner(Colors.green)),
                  Positioned(bottom: 15, left: 15, child: _buildBaseCorner(Colors.blue)),
                  Positioned(bottom: 15, right: 15, child: _buildBaseCorner(Colors.yellow)),

                  // خانة عرض النرد في منتصف اللوحة
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: const Color(0xFF3E4A61),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: const Color(0xFFFFB300), width: 2),
                    ),
                    child: Center(
                      child: Text(
                        isRolling ? '...' : '$diceValue',
                        style: const TextStyle(
                          color: Color(0xFFFFB300),
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),

            // زر ارم النرد واربح
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF8F00),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: isRolling ? null : rollDice,
                child: const Text(
                  'ارم النرد واربح',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ودجت مساعد لرسم زوايا اللوحة (قواعد اللودو الأربعة)
  Widget _buildBaseCorner(Color color) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: color.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color, width: 2),
      ),
    );
  }
}
