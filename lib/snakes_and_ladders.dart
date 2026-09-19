// ====================================================================
// (Snakes and Ladders Game Logic & UI) - لعبة السلم والثعبان الاحترافية 🐍🪜
// المتوافق مع شريط الـ VIP والورود، والدردشة الفورية، ورسم لوحة الـ 100 مربع الحقيقية
// ====================================================================

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class SnakesAndLaddersGameScreen extends StatefulWidget {
  const SnakesAndLaddersGameScreen({Key? key}) : super(key: key);

  @override
  State<SnakesAndLaddersGameScreen> createState() => _SnakesAndLaddersGameScreenState();
}

class _SnakesAndLaddersGameScreenState extends State<SnakesAndLaddersGameScreen> {
  static const int MAX_TILES = 100;
  
  // قاموس السلالم والثعابين الدقيق
  static const Map<int, int> LADDERS = {
    4: 18,
    20: 38,
    28: 84,
    40: 59,
    51: 67,
    71: 91,
  };

  static const Map<int, int> SNAKES = {
    38: 27,
    83: 73,
    96: 12,
    54: 34,
    62: 19,
    88: 24,
  };

  int currentPlayerTurn = 0;
  bool isRolling = false;
  int lastDiceResult = 1;

  final Map<int, Map<String, dynamic>> playersData = {
    0: {"name": "اللاعب الأخضر", "color": Colors.green, "current_tile": 1},
    1: {"name": "اللاعب الأصفر", "color": Colors.amber, "current_tile": 1},
  };

  final List<String> chatMessages = [
    "النظام: مرحباً بك في طاولة السلم والثعبان الاحترافية!",
  ];
  final TextEditingController chatInputController = TextEditingController();

  bool isMicActive = false;
  bool isSpeakerActive = false;

  @override
  void initState() {
    super.initState();
  }

  void _onRollPressed() {
    if (isRolling) return;
    setState(() {
      isRolling = true;
    });

    var random = Random();
    int diceResult = random.nextInt(6) + 1;
    lastDiceResult = diceResult;

    _animateDiceRoll(diceResult);
  }

  void _animateDiceRoll(int result) async {
    await Future.delayed(const Duration(milliseconds: 700));
    _movePlayerToken(currentPlayerTurn, result);
  }

  void _movePlayerToken(int playerId, int steps) async {
    int oldTile = playersData[playerId]!["current_tile"];
    int targetTile = oldTile + steps;

    if (targetTile > MAX_TILES) {
      // الارتداد أو البقاء في حال تجاوز المربع 100
      targetTile = MAX_TILES - (targetTile - MAX_TILES);
    }

    // حركة تدريجية لكل خطوة لإظهار الاحترافية
    for (int step = oldTile + 1; step <= targetTile; step++) {
      setState(() {
        playersData[playerId]!["current_tile"] = step;
      });
      await Future.delayed(const Duration(milliseconds: 120));
    }

    await _checkBoardModifiers(playerId, targetTile);
  }

  Future<void> _checkBoardModifiers(int playerId, int currentTile) async {
    int finalDestination = currentTile;

    if (LADDERS.containsKey(currentTile)) {
      finalDestination = LADDERS[currentTile]!;
      debugPrint("🚀 تسلق سلم إلى: $finalDestination");
    } else if (SNAKES.containsKey(currentTile)) {
      finalDestination = SNAKES[currentTile]!;
      debugPrint("🐍 لدغة ثعبان إلى: $finalDestination");
    }

    if (finalDestination != currentTile) {
      await Future.delayed(const Duration(milliseconds: 250));
      setState(() {
        playersData[playerId]!["current_tile"] = finalDestination;
      });
    }

    if (finalDestination == MAX_TILES) {
      _declareWinner(playerId);
    } else {
      _switchTurn();
    }
  }

  void _switchTurn() {
    setState(() {
      isRolling = false;
      currentPlayerTurn = (currentPlayerTurn + 1) % playersData.length;
    });
  }

  void _declareWinner(int playerId) {
    String winnerName = playersData[playerId]!["name"];
    setState(() {
      chatMessages.add("🏆 تهانينا! الفائز بالمركز الأول هو: $winnerName");
    });
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF172A45),
        title: const Text('🎉 فوز مبهر!', style: TextStyle(color: Colors.amberAccent)),
        content: Text('لقد فاز $winnerName وتصدر الطاولة بجدارة!', style: const TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                playersData[0]!["current_tile"] = 1;
                playersData[1]!["current_tile"] = 1;
                currentPlayerTurn = 0;
              });
            },
            child: const Text('لعب دور جديد', style: TextStyle(color: Colors.amber)),
          ),
        ],
      ),
    );
  }

  void _onChatMessageSubmitted(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      String playerName = playersData[currentPlayerTurn]!["name"];
      chatMessages.add("$playerName: $text");
      chatInputController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    var activePlayer = playersData[currentPlayerTurn]!;

    return Scaffold(
      appBar: AppBar(
        title: Text('السلم والثعبان الاحترافية - دور: ${activePlayer["name"]}'),
        backgroundColor: const Color(0xFF0F0F19),
        actions: [
          IconButton(
            icon: Icon(isMicActive ? Icons.mic : Icons.mic_off, color: isMicActive ? Colors.green : Colors.white70),
            onPressed: () => setState(() => isMicActive = !isMicActive),
          ),
          IconButton(
            icon: Icon(isSpeakerActive ? Icons.volume_up : Icons.volume_mute, color: isSpeakerActive ? Colors.amber : Colors.white70),
            onPressed: () => setState(() => isSpeakerActive = !isSpeakerActive),
          ),
        ],
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
            // 🌟 شريط الـ VIP والورود العلوي
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.black26,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.workspace_premium, color: Colors.amber, size: 24),
                      SizedBox(width: 6),
                      Text('غرفة VIP التفاعلية', style: TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.local_florist, color: Colors.pinkAccent, size: 20),
                      const SizedBox(width: 4),
                      const Text('الورود اليومية: 5', style: TextStyle(color: Colors.white70, fontSize: 13)),
                    ],
                  ),
                ],
              ),
            ),

            // لوحة اللعب الاحترافية (100 مربع مرئي حقيقي)
            Expanded(
              flex: 5,
              child: Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFF102030),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: activePlayer["color"], width: 2.5),
                ),
                child: Column(
                  children: [
                    // شريط النرد العلوي داخل اللوحة
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.casino, color: Colors.amberAccent, size: 26),
                              const SizedBox(width: 6),
                              Text('النتيجة: $lastDiceResult', style: const TextStyle(color: Colors.amberAccent, fontSize: 16, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: activePlayer["color"]),
                            onPressed: isRolling ? null : _onRollPressed,
                            child: Text(isRolling ? 'جاري التحرك...' : 'رمي النرد 🎲', style: const TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                    const Divider(color: Colors.white24, height: 8),

                    // شبكة اللوحة الاحترافية 10×10
                    Expanded(
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 100,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 10,
                          crossAxisSpacing: 2,
                          mainAxisSpacing: 2,
                        ),
                        itemBuilder: (context, index) {
                          // حساب رقم المربع بتصميم مسار تصاعدي/تنازلي احترافي
                          int row = index ~/ 10;
                          int col = index % 10;
                          int tileNum = (row % 2 == 0) ? (100 - (row * 10) - col) : (100 - (row * 10) - (9 - col));

                          bool isGreenHere = playersData[0]!["current_tile"] == tileNum;
                          bool isYellowHere = playersData[1]!["current_tile"] == tileNum;
                          bool hasLadder = LADDERS.containsKey(tileNum);
                          bool hasSnake = SNAKES.containsKey(tileNum);

                          Color tileColor = const Color(0xFF1E3A5F);
                          if (hasLadder) tileColor = Colors.green.withOpacity(0.4);
                          if (hasSnake) tileColor = Colors.red.withOpacity(0.4);

                          return Container(
                            decoration: BoxDecoration(
                              color: tileColor,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.white10),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Text(
                                  '$tileNum',
                                  style: TextStyle(
                                    color: (hasLadder || hasSnake) ? Colors.white : Colors.white54,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (isGreenHere || isYellowHere)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (isGreenHere)
                                        Container(width: 8, height: 8, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.green)),
                                      if (isYellowHere)
                                        Container(width: 8, height: 8, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.amber)),
                                    ],
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

            // صندوق الدردشة السفلية
            Expanded(
              flex: 3,
              child: Container(
                margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white24),
                ),
                child: Column(
                  children: [
                    const Text('دردشة الطاولة المباشرة', style: TextStyle(color: Colors.white54, fontSize: 11)),
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
                        hintText: 'اكتب رسالتك في السلم والثعبان...',
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                      onSubmitted: _onChatMessageSubmitted,
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
