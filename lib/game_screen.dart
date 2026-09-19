// ====================================================================
// (Ludo Game Controller) - لوحة لودو الحقيقية والمرئية بالكامل 🎲
// ====================================================================

import 'dart:async';
import 'package:flutter/material.dart';

class LudoGameController extends StatefulWidget {
  const LudoGameController({Key? key}) : super(key: key);

  @override
  State<LudoGameController> createState() => _LudoGameControllerState();
}

class _LudoGameControllerState extends State<LudoGameController>
    with SingleTickerProviderStateMixin {
  static const int TOTAL_CELLS = 52;
  static const int FINAL_HOME_CELL = 57;
  static const List<int> SAFE_ZONES = [0, 9, 14, 22, 27, 35, 40, 48];

  int currentPlayerTurn = 0;
  int diceValue = 1;
  bool hasRolledThisTurn = false;
  int consecutiveSixes = 0;

  // بيانات اللاعبين الأربعة بخصائصهم الكاملة
  final Map<int, Map<String, dynamic>> playersData = {
    0: {"name": "Oman (الأحمر)", "color": Colors.red, "tokens_pos": [-1, -1, -1, -1], "is_bot": false},
    1: {"name": "الأخضر", "color": Colors.green, "tokens_pos": [-1, -1, -1, -1], "is_bot": true},
    2: {"name": "الأصفر", "color": Colors.amber, "tokens_pos": [-1, -1, -1, -1], "is_bot": true},
    3: {"name": "الأزرق", "color": Colors.blue, "tokens_pos": [-1, -1, -1, -1], "is_bot": true},
  };

  final List<String> chatMessages = [];
  final TextEditingController chatInputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    startNewGame();
  }

  void startNewGame() {
    setState(() {
      currentPlayerTurn = 0;
      consecutiveSixes = 0;
      preparePlayerTurn();
    });
  }

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
  }

  void onDicePressed() {
    if (hasRolledThisTurn) return;

    setState(() {
      hasRolledThisTurn = true;
      diceValue = 1 + (DateTime.now().millisecondsSinceEpoch % 6);
    });

    if (diceValue == 6) {
      consecutiveSixes++;
      if (consecutiveSixes >= 3) {
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) nextTurn();
        });
        return;
      }
    } else {
      consecutiveSixes = 0;
    }

    processDiceResult(currentPlayerTurn, diceValue);
  }

  void processDiceResult(int playerId, int steps) {
    int targetTokenId = getFirstMovableToken(playerId, steps);
    if (targetTokenId != -1) {
      moveToken(playerId, targetTokenId, steps);
    } else {
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          if (diceValue == 6) {
            preparePlayerTurn();
          } else {
            nextTurn();
          }
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
      if (currentPositions[i] != -1 && currentPositions[i] < FINAL_HOME_CELL) {
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

      if (diceValue == 6) {
        preparePlayerTurn();
      } else {
        nextTurn();
      }
    });
  }

  void checkTokenCollision(int cellIndex, int movingPlayerId) {
    if (SAFE_ZONES.contains(cellIndex) || cellIndex >= TOTAL_CELLS) return;

    playersData.forEach((pid, pData) {
      if (pid == movingPlayerId) return;

      List<int> enemyPositions = List<int>.from(pData["tokens_pos"]);
      for (int tId = 0; tId < 4; tId++) {
        if (enemyPositions[tId] == cellIndex) {
          setState(() {
            pData["tokens_pos"][tId] = -1;
          });
        }
      }
    });
  }

  void checkPlayerVictory(int playerId) {
    List<int> positions = List<int>.from(playersData[playerId]!["tokens_pos"]);
    int wonCount = positions.where((pos) => pos >= FINAL_HOME_CELL).length;

    if (wonCount == 4) {
      debugPrint("🏆 الفائز: $playerId");
    }
  }

  void onChatMessageSubmitted(String newText) {
    if (newText.trim().isEmpty) return;

    setState(() {
      String senderName = playersData[currentPlayerTurn]!["name"];
      chatMessages.add("$senderName: $newText");
      chatInputController.clear();
    });
  }

  String getRolledText(bool rolled) {
    return rolled ? 'انتظر الدور...' : 'رمي النرد 🎲';
  }

  @override
  Widget build(BuildContext context) {
    Color activeColor = playersData[currentPlayerTurn]!["color"];

    return Scaffold(
      appBar: AppBar(
        title: Text('لوحة لودو الحقيقية - دور: ${playersData[currentPlayerTurn]!["name"]}'),
        backgroundColor: activeColor,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F0F19), Color(0xFF172A45)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // لوحة اللعب المرئية الحقيقية (تخطيط يشبه طاولات اللودو الكلاسيكية)
            Expanded(
              flex: 5,
              child: Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF151522),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: activeColor, width: 2.5),
                ),
                child: Column(
                  children: [
                    // شريط النرد العلوي داخل اللوحة
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.casino, color: Colors.amberAccent, size: 28),
                            const SizedBox(width: 8),
                            Text(
                              'النرد: $diceValue',
                              style: const TextStyle(color: Colors.amberAccent, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: activeColor,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: hasRolledThisTurn ? null : onDicePressed,
                          child: Text(getRolledText(hasRolledThisTurn)),
                        ),
                      ],
                    ),
                    const Divider(color: Colors.white24, height: 12),
                    
                    // شبكة القواعد والبيوت الأربعة الحقيقية للعبة اللودو
                    Expanded(
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 4,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 6,
                          mainAxisSpacing: 6,
                        ),
                        itemBuilder: (context, playerIndex) {
                          var player = playersData[playerIndex]!;
                          List<int> tokens = player["tokens_pos"];
                          Color pColor = player["color"];
                          bool isCurrentTurn = (currentPlayerTurn == playerIndex);

                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: pColor.withOpacity(isCurrentTurn ? 0.35 : 0.12),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isCurrentTurn ? Colors.amberAccent : pColor,
                                width: isCurrentTurn ? 2.5 : 1.2,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      player["name"],
                                      style: TextStyle(color: pColor, fontWeight: FontWeight.bold, fontSize: 13),
                                    ),
                                    if (isCurrentTurn)
                                      const Icon(Icons.star, color: Colors.amber, size: 16),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                // قطع اللاعب الأربعة المرئية على اللوحة
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: List.generate(4, (tokenIndex) {
                                    int pos = tokens[tokenIndex];
                                    return CircleAvatar(
                                      radius: 16,
                                      backgroundColor: pos == -1 ? Colors.grey[850] : pColor,
                                      child: Text(
                                        pos == -1 ? '🏠' : '$pos',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: pos == -1 ? Colors.white70 : Colors.white,
                                        ),
                                      ),
                                    );
                                  }),
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
            ),

            // صندوق الدردشة السفلي
            Expanded(
              flex: 3,
              child: Container(
                margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white24),
                ),
                child: Column(
                  children: [
                    const Text('دردشة الطاولة التفاعلية', style: TextStyle(color: Colors.white54, fontSize: 11)),
                    Expanded(
                      child: ListView.builder(
                        itemCount: chatMessages.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Text(chatMessages[index], style: const TextStyle(color: Colors.white70, fontSize: 13)),
                          );
                        },
                      ),
                    ),
                    TextField(
                      controller: chatInputController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'اكتب رسالتك...',
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                        isDense: true,
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
