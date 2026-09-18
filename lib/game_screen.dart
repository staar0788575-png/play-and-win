// ====================================================================
// (Ludo Game Controller) - لعبة لودو المصححة 🎲
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
  static const int HOME_STRETCH_START = 51;
  static const int FINAL_HOME_CELL = 57;
  static const List<int> SAFE_ZONES = [0, 9, 14, 22, 27, 35, 40, 48];
  static const double TURN_TIME_LIMIT = 15.0;

  int currentPlayerTurn = 0;
  int diceValue = 1;
  bool hasRolledThisTurn = false;
  int consecutiveSixes = 0;

  final List<Offset> boardCoordinatesArray = [];

  final Map<int, Map<String, dynamic>> playersData = {
    0: {"name": "Oman", "color": "Red", "tokens_pos": [-1, -1, -1, -1], "is_bot": false},
    1: {"name": "Player_2", "color": "Green", "tokens_pos": [-1, -1, -1, -1], "is_bot": true},
    2: {"name": "Player_3", "color": "Yellow", "tokens_pos": [-1, -1, -1, -1], "is_bot": true},
    3: {"name": "Player_4", "color": "Blue", "tokens_pos": [-1, -1, -1, -1], "is_bot": true},
  };

  final List<String> chatMessages = [];
  final TextEditingController chatInputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initializeBoardGrid();
    startNewGame();
  }

  void initializeBoardGrid() {
    boardCoordinatesArray.clear();
    for (int i = 0; i <= TOTAL_CELLS + 10; i++) {
      boardCoordinatesArray.add(const Offset(1800.0, 200.0));
    }
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
    return rolled ? 'انتظر الدور القادم...' : 'رمي النرد 🎲';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('لعبة لودو - دور اللاعب: ${playersData[currentPlayerTurn]!["name"]}'),
        backgroundColor: Colors.indigo[900],
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
            Expanded(
              flex: 3,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.casino, size: 70, color: Colors.amberAccent),
                    const SizedBox(height: 10),
                    Text(
                      'نتيجة النرد: $diceValue',
                      style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                      onPressed: hasRolledThisTurn ? null : onDicePressed,
                      child: Text(
                        getRolledText(hasRolledThisTurn),
                        style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                margin: const EdgeInsets.all(16),
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
                        hintText: 'اكتب رسالتك...',
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
