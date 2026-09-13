// المسار: lib/game_screen.dart
import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  final String gameName;

  const GameScreen({Key? key, required this.gameName}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  // متغيرات حالة اللعبة المتوافقة مع منطق اللودو الكبير
  int currentPlayerTurn = 0; // 0: أحمر، 1: أخضر، 2: أصفر، 3: أزرق
  int diceValue = 1;
  bool hasRolledThisTurn = hasRolledThisTurn = false;
  int consecutiveSixes = 0;
  
  final List<String> playerNames = ["Oman", "Player_2", "Player_3", "Player_4"];
  final List<Color> playerColors = [Colors.red, Colors.green, Colors.amber, Colors.blue];
  
  // تتبع مواقع القطع الأربعة لكل لاعب (-1 يعني في القلعة)
  Map<int, List<int>> tokensPosition = {
    0: [-1, -1, -1, -1],
    1: [-1, -1, -1, -1],
    2: [-1, -1, -1, -1],
    3: [-1, -1, -1, -1],
  };

  void rollDice() {
    if (hasRolledThisTurn) return;

    setState(() {
      hasRolledThisTurn = true;
      // توليد رقم عشوائي للنرد من 1 إلى 6 (مطابق للمنطق البرمجي)
      diceValue = (1 + (DateTime.now().millisecondsSinceEpoch % 6));

      if (diceValue == 6) {
        consecutiveSixes++;
        if (consecutiveSixes >= 3) {
          // عقوبة 3 مرات رقم 6 وتخطي الدور
          consecutiveSixes = 0;
          nextTurn();
          return;
        }
      } else {
        consecutiveSixes = 0;
      }

      // معالجة حركة القطع بناءً على نتيجة النرد
      processDiceResult(currentPlayerTurn, diceValue);
    });
  }

  void processDiceResult(int playerId, int steps) {
    int movableToken = getFirstMovableToken(playerId, steps);
    if (movableToken != -1) {
      // تحريك القطعة
      int currentPos = tokensPosition[playerId]![movableToken];
      int newPos = (currentPos == -1 && steps == 6) ? 0 : currentPos + steps;
      
      setState(() {
        tokensPosition[playerId]![movableToken] = newPos;
      });

      // إذا لم تكن الرمية 6، ينتقل الدور تلقائياً
      if (diceValue != 6) {
        Future.delayed(const Duration(seconds: 1), () {
          nextTurn();
        });
      } else {
        // يحق له اللعب مجدداً إذا حصل على 6
        setState(() {
          hasRolledThisTurn = false;
        });
      }
    } else {
      // لا توجد حركات متاحة
      Future.delayed(const Duration(seconds: 1), () {
        nextTurn();
      });
    }
  }

  int getFirstMovableToken(int playerId, int steps) {
    List<int> positions = tokensPosition[playerId]!;
    for (int i = 0; i < 4; i++) {
      if (positions[i] == -1 && steps == 6) return i;
      if (positions[i] != -1 && (positions[i] + steps) <= 57) return i;
    }
    return -1;
  }

  void nextTurn() {
    setState(() {
      consecutiveSixes = 0;
      currentPlayerTurn = (currentPlayerTurn + 1) % 4;
      hasRolledThisTurn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.gameName} - دور: ${playerNames[currentPlayerTurn]}"),
        backgroundColor: playerColors[currentPlayerTurn],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F0B19), Color(0xFF0FF0172A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // عرض لوحة اللعبة التفاعلية المصغرة
            Expanded(
              flex: 3,
              child: Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.amber.withOpacity(0.3)),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.sports_esports, size: 60, color: Colors.amberAccent),
                      const SizedBox(height: 10),
                      Text(
                        "لاعب حالي: ${playerNames[currentPlayerTurn]}",
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 15),
                      // عرض النرد المركزي والأزرار المتوافقة
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: playerColors[currentPlayerTurn],
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        ),
                        onPressed: hasRolledThisTurn ? null : rollDice,
                        child: Text(
                          hasRolledThisTurn ? "النتيجة: $diceValue" : "رمي النرد ($diceValue)",
                          style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // لوحة مصغرة لعرض حالة القطع الخاصة باللاعبين
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        "اللاعب: ${playerNames[index]} ${index == currentPlayerTurn ? '(دورك)' : ''}",
                        style: TextStyle(color: index == currentPlayerTurn ? Colors.amberAccent : Colors.white70),
                      ),
                      subtitle: Text(
                        "مواقع القطع: ${tokensPosition[index]}",
                        style: const TextStyle(color: Colors.white38),
                      ),
                    );
                  },
                ),
              ),
            ),

            // زر العودة والخروج
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('إلغاء والعودة', style: TextStyle(color: Colors.black)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
