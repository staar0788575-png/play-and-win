// ==============================================================================
// 🎮 مستند الكود البرمجي المدمج والمحدث بالكامل - لودو توب توب (TopTop Ludo Clone)
// لغة البرمجة: Dart (Flutter) - مخصص بالكامل لمشروع "العب واربح" على GitHub
// ==============================================================================

import 'package:flutter/material.dart';

class LudoGameController extends StatefulWidget {
  const LudoGameController({Key? key}) : super(key: key);

  @override
  State<LudoGameController> createState() => _LudoGameControllerState();
}

class _LudoGameControllerState extends State<LudoGameController> with SingleTickerProviderStateMixin {
  
  // --- [ الثوابت وإعدادات اللعبة / CONSTANTS ] ---
  static const int TOTAL_CELLS = 52;
  static const int HOME_STRETCH_START = 51;
  static const int FINAL_HOME_CELL = 57;
  static const List<int> SAFE_ZONES = [1, 9, 14, 22, 27, 35, 40, 48];
  static const double TURN_TIME_LIMIT = 15.0;

  // --- [ متغيرات حالة اللعبة / GAME STATE ] ---
  int currentPlayerTurn = 0; // 0: أحمر، 1: أخضر، 2: أصفر، 3: أزرق
  int diceValue = 1;
  bool hasRolledThisTurn = false;
  int consecutiveSixes = 0;
  
  // إحداثيات مسار الرقعة البرمجي
  List<Offset> boardCoordinatesArray = [];

  // بيانات اللاعبين والقطع (-1 يعني داخل القلعة، 0 إلى 51 مسار عام، 52+ المسار النهائي)
  Map<int, Map<String, dynamic>> playersData = {
    0: {"name": "Oman", "color": "Red", "tokens_pos": [-1, -1, -1, -1], "is_bot": false},
    1: {"name": "Player_2", "color": "Green", "tokens_pos": [-1, -1, -1, -1], "is_bot": false},
    2: {"name": "Player_3", "color": "Yellow", "tokens_pos": [-1, -1, -1, -1], "is_bot": false},
    3: {"name": "Player_4", "color": "Blue", "tokens_pos": [-1, -1, -1, -1], "is_bot": false}
  };

  // نظام الدردشة داخل اللعبة
  final List<String> chatMessages = [];
  final TextEditingController chatInputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initializeBoardGrid();
    startNewGame();
  }

  // ==============================================================================
  // 1. دالة بدء اللعبة والتجهيز (INITIALIZATION)
  // ==============================================================================
  void initializeBoardGrid() {
    boardCoordinatesArray.clear();
    for (int i = 0; i <= TOTAL_CELLS + 10; i++) {
      boardCoordinatesArray.add(Offset(100.0 + (i * 8), 200.0));
    }
    debugPrint("تم تحديث مسار الرقعة البرمجي للعبة لودو بنجاح. الإجمالي: ${boardCoordinatesArray.length}");
  }

  void startNewGame() {
    currentPlayerTurn = 0;
    consecutiveSixes = 0;
    preparePlayerTurn();
  }

  // ==============================================================================
  // 2. نظام الدور والمؤقت المركزي (TURN & TIMER SYSTEM)
  // ==============================================================================
  void preparePlayerTurn() {
    setState(() {
      hasRolledThisTurn = false;
    });
  }

  void nextTurn() {
    setState(() {
      consecutiveSixes = 0;
      currentPlayerTurn = (currentPlayerTurn + 1) % 4;
      preparePlayerTurn();
    });
    debugPrint("انتقل الدور الآن للاعب رقم: $currentPlayerTurn");
  }

  // ==============================================================================
  // 3. نظام رمي النرد المركزي (CENTRAL DICE SYSTEM)
  // ==============================================================================
  void onDicePressed() {
    if (hasRolledThisTurn) return;
    
    setState(() {
      hasRolledThisTurn = true;
      diceValue = 1 + (DateTime.now().millisecondsSinceEpoch % 6);
      
      // قاعدة الـ 3 مرات رقم 6 (عقوبة حرمان اللاعب من الدور)
      if (diceValue == 6) {
        consecutiveSixes++;
        if (consecutiveSixes >= 3) {
          debugPrint("حصل على 3 مرات رقم 6 توالياً! يتم إلغاء دوره وتخطي دوره فوراً.");
          Future.delayed(const Duration(seconds: 1), () {
            nextTurn();
          });
          return;
        }
      } else {
        consecutiveSixes = 0;
      }
    });

    processDiceResult(currentPlayerTurn, diceValue);
  }

  // ==============================================================================
  // 4. منطق حركة القطع والأكل (GAMEPLAY & COLLISION LOGIC)
  // ==============================================================================
  void processDiceResult(int playerId, int steps) {
    int targetTokenId = getFirstMovableToken(playerId, steps);
    if (targetTokenId != -1) {
      moveToken(playerId, targetTokenId, steps);
    } else {
      debugPrint("لا توجد حركات قانونية متاحة.");
      Future.delayed(const Duration(seconds: 1), () {
        if (diceValue != 6) {
          nextTurn();
        } else {
          preparePlayerTurn();
        }
      });
    }
  }

  int getFirstMovableToken(int playerId, int steps) {
    List<int> currentPositions = List<int>.from(playersData[playerId]!["tokens_pos"]);
    for (int i = 0; i < 4; i++) {
      if (currentPositions[i] == -1 && steps == 6) {
        return i;
      }
      if (currentPositions[i] != -1 && currentPositions[i] <= FINAL_HOME_CELL) {
        if ((currentPositions[i] + steps) <= FINAL_HOME_CELL) {
          return i;
        }
      }
    }
    return -1;
  }

  void moveToken(int playerId, int tokenId, int steps) {
    int currentPos = playersData[playerId]!["tokens_pos"][tokenId];
    int newPos = (currentPos == -1 && steps == 6) ? 0 : currentPos + steps;

    setState(() {
      playersData[playerId]!["tokens_pos"][tokenId] = newPos;
    });

    animateTokenMovement(playerId, tokenId, newPos);
  }

  void animateTokenMovement(int playerId, int tokenId, int targetCell) {
    Future.delayed(const Duration(milliseconds: 250), () {
      if (targetCell == FINAL_HOME_CELL) {
        checkPlayerVictory(playerId);
      } else {
        checkTokenCollision(targetCell, playerId);
      }

      // قاعدة الـ 6 الكلاسيكية للاستمرارية
      if (diceValue == 6) {
        debugPrint("حقق رمية 6، يحق له اللعب مجدداً.");
        preparePlayerTurn();
      } else {
        nextTurn();
      }
    });
  }

  void checkTokenCollision(int cellIndex, int movingPlayerId) {
    if (SAFE_ZONES.contains(cellIndex) || cellIndex > TOTAL_CELLS) {
      return;
    }
    
    playersData.forEach((pId, pData) {
      if (pId == movingPlayerId) return;

      List<int> enemyPositions = List<int>.from(pData["tokens_pos"]);
      for (int tId = 0; tId < 4; tId++) {
        if (enemyPositions[tId] == cellIndex) {
          debugPrint("💥 تم أكل قطعة الخصم وإعادتها للقلعة.");
          setState(() {
            playersData[pId]!["tokens_pos"][tId] = -1;
          });
          resetTokenToBase(pId, tId);
        }
      }
    });
  }

  void resetTokenToBase(int playerId, int tokenId) {
    debugPrint("إعادة القطعة $tokenId الخاصة باللاعب $playerId إلى القاعدة.");
  }

  void checkPlayerVictory(int playerId) {
    List<int> positions = List<int>.from(playersData[playerId]!["tokens_pos"]);
    int wonCount = positions.where((pos) => pos == FINAL_HOME_CELL).length;
    
    if (wonCount == 4) {
      debugPrint("🎉 الف مبروك! اللاعب رقم $playerId أتم جميع قطعه وفاز باللعبة!");
    }
  }

  // ==============================================================================
  // 5. نظام الشات والفقاعات (SOCIAL CHAT SYSTEM)
  // ==============================================================================
  void onChatMessageSubmitted(String newText) {
    if (newText.trim().isEmpty) return;
    
    setState(() {
      String senderName = playersData[currentPlayerTurn]!["name"];
      chatMessages.add("$senderName: $newText");
      chatInputController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("لودو توب توب - دور اللاعب: ${playersData[currentPlayerTurn]!["name"]}"),
        backgroundColor: Colors.indigo[900],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F0B19), Color(0xFF172A45)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // قسم رقعة اللعبة والنرد
            Expanded(
              flex: 3,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.casino, size: 70, color: Colors.amberAccent),
                    const SizedBox(height: 10),
                    Text(
                      "نتيجة النرد: $diceValue",
                      style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                      onPressed: hasRolledThisTurn ? null : onDicePressed,
                      child: const Text("رمي النرد", style: TextStyle(color: Colors.black, fontSize: 18)),
                    ),
                  ],
                ),
              ),
            ),
            
            // قسم الشات المصغر
            Expanded(
              flex: 2,
              child: Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white24),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: chatMessages.length,
                        itemBuilder: (context, index) {
                          return Text(chatMessages[index], style: const TextStyle(color: Colors.white70));
                        },
                      ),
                    ),
                    TextField(
                      controller: chatInputController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: "اكتب رسالتك...",
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                      ),
                      onSubmitted: onChatMessageSubmitted,
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
