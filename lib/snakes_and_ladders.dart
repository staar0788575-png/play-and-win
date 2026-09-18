// ====================================================================
// (Snakes and Ladders Game Logic & UI) - لعبة السلم والثعبان 🐍🪜
// المتوافق مع هيكل التطبيق والمنطق البرمجي الكامل
// ====================================================================

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class Vector2 {
  double x;
  double y;
  Vector2(this.x, this.y);

  static final zero = Vector2(0.0, 0.0);
}

class SnakesAndLaddersGameLogic extends StatefulWidget {
  const SnakesAndLaddersGameLogic({Key? key}) : super(key: key);

  @override
  State<SnakesAndLaddersGameLogic> createState() => _SnakesAndLaddersGameLogicState();
}

class _SnakesAndLaddersGameLogicState extends State<SnakesAndLaddersGameLogic> {
  // --- إشارات العيد / SIGNALS ---
  Function(int resultValue)? diceRoller;
  Function(int playerId, int finalTile)? playerMoved;
  Function(String actionType, int targetPlayerId)? socialActionTriggered;
  Function(int playerId)? playerWon;

  // --- الإعدادات والثوابت / CONSTANTS ---
  static const int MAX_TILES = 100; // إجمالي عدد مربعات اللوحة
  static const double TURN_TIME_LIMIT = 15.0; // الميقاتي الدولي لكل لاعب

  // قاموس السلالم والثعابين (السلم: مربع البداية -> السلم: مربع النهاية)
  static const Map<int, int> LADDERS = {
    4: 18,
    20: 38,
    28: 84,
  };

  static const Map<int, int> SNAKES = {
    38: 27,
    83: 73,
    96: 1,
  };

  // --- معتادة العتاد / ONREADY VARIABLES ---
  List<Vector2> tilesCoordinates = [];

  // --- متغيرات حالة اللعبة / GAME STATE ---
  int currentPlayerTurn = 0;
  bool isRolling = false;

  Map<int, Map<String, dynamic>> playersPositions = {
    0: {"name": "Green Player", "current_tile": 0, "node_name": "TokenGreen"},
    1: {"name": "Yellow Player", "current_tile": 0, "node_name": "TokenYellow"},
  };

  final List<String> chatMessages = [];
  final TextEditingController chatInputController = TextEditingController();

  bool isMicActive = false;
  bool isSpeakerActive = false;

  @override
  void initState() {
    super.initState();
    ready();
  }

  // ====================================================================
  // 1. بدء اللعبة والتجهيز / (INITIALIZATION)
  // ====================================================================
  void ready() {
    _generateBoardCoordinates();
    _setupSocialConnections();
    _startTurn();
  }

  void _generateBoardCoordinates() {
    tilesCoordinates.clear();
    for (int i = 0; i <= 101; i++) {
      tilesCoordinates.add(Vector2(50 * (i % 10).toDouble(), 600 - (50 * (i / 10).toInt()).toDouble()));
    }
    debugPrint("تم بناء مصميفة الـ 100 مربع وتحديثها المشروع حيث حيث.");
  }

  void _setupSocialConnections() {
    debugPrint("ربط أزرار الدردشة والواجهة في واجهة المنافسة بنجاح.");
  }

  // ====================================================================
  // 2. نظام رمي النرد / (DICE MECHANICS)
  // ====================================================================
  void _startTurn() {
    setState(() {
      isRolling = false;
    });
    debugPrint("Turn: ${playersPositions[currentPlayerTurn]!["name"]}");
  }

  void _onRollPressed() {
    if (isRolling) return;
    setState(() {
      isRolling = true;
    });

    var random = Random();
    int diceResult = random.nextInt(6) + 1;
    
    if (diceRoller != null) {
      diceRoller!(diceResult);
    }

    _animateDiceRoll(diceResult);
  }

  void _animateDiceRoll(int result) async {
    await Future.delayed(const Duration(milliseconds: 600));
    _movePlayerToken(currentPlayerTurn, result);
  }

  // ====================================================================
  // 3. مسار الحركة: السلالم والثعابين / (GAMEPLAY LOGIC)
  // ====================================================================
  void _movePlayerToken(int playerId, int steps) async {
    int oldTile = playersPositions[playerId]!["current_tile"];
    int targetTile = oldTile + steps;

    if (targetTile > MAX_TILES) {
      targetTile = oldTile;
      debugPrint("تجاوزت السقف المربع 100. تم البقاء في المربع الحالي.");
      _switchTurn();
      return;
    }

    for (int step = oldTile + 1; step <= targetTile; step++) {
      playersPositions[playerId]!["current_tile"] = step;
      await _animateTokenStep(playerId, step);
    }

    await _checkBoardModifiers(playerId, targetTile);
  }

  Future<void> _animateTokenStep(int playerId, int tileIndex) async {
    await Future.delayed(const Duration(milliseconds: 200));
  }

  Future<void> _checkBoardModifiers(int playerId, int currentTile) async {
    if (LADDERS.containsKey(currentTile)) {
      int topTile = LADDERS[currentTile]!;
      debugPrint("🚀 تسلقوا إلى المربع $topTile");
      playersPositions[playerId]!["current_tile"] = topTile;
      await _animateTokenStep(playerId, topTile);
    } else if (SNAKES.containsKey(currentTile)) {
      int bottomTile = SNAKES[currentTile]!;
      debugPrint("🐍 عذرا! الهبوط إلى المربع $bottomTile");
      playersPositions[playerId]!["current_tile"] = bottomTile;
      await _animateTokenStep(playerId, bottomTile);
    }

    if (playerMoved != null) {
      playerMoved!(playerId, playersPositions[playerId]!["current_tile"]);
    }

    if (playersPositions[playerId]!["current_tile"] == MAX_TILES) {
      _declareWinner(playerId);
    } else {
      _switchTurn();
    }
  }

  void _switchTurn() {
    setState(() {
      currentPlayerTurn = (currentPlayerTurn + 1) % playersPositions.length;
      _startTurn();
    });
  }

  void _declareWinner(int playerId) {
    debugPrint("🏆 الفائز بالمركز الأول هو ${playersPositions[playerId]!["name"]}");
    if (playerWon != null) {
      playerWon!(playerId);
    }
  }

  // ====================================================================
  // 4. الميزات الاجتماعية والدردشة الصوتية / (INTEGRATED SOCIAL FEATURES)
  // ====================================================================
  void _onChatMessageSubmitted(String newText) {
    if (newText.trim().isEmpty) return;
    setState(() {
      String messageText = "${playersPositions[currentPlayerTurn]!["name"]}: $newText";
      chatMessages.add(messageText);
      chatInputController.clear();
    });
  }

  void _onMicToggled(bool isActive) {
    setState(() {
      isMicActive = isActive;
    });
    debugPrint(isActive ? "تم تفعيل المايكروفون بث الصوت لغرفة اللعبة." : "تم كتم المايكروفون الشخصي.");
  }

  void _onSpeakerToggled(bool isActive) {
    setState(() {
      isSpeakerActive = isActive;
    });
    debugPrint("مكبر الصوت معدل: $isActive");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('السلم والثعبان - دور: ${playersPositions[currentPlayerTurn]!["name"]}'),
        backgroundColor: Colors.indigo[900],
        actions: [
          IconButton(
            icon: Icon(isMicActive ? Icons.mic : Icons.mic_off),
            onPressed: () => _onMicToggled(!isMicActive),
          ),
          IconButton(
            icon: Icon(isSpeakerActive ? Icons.volume_up : Icons.volume_mute),
            onPressed: () => _onSpeakerToggled(!isSpeakerActive),
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
            // لوحة اللعب الرئيسية والنرد
            Expanded(
              flex: 4,
              child: Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[900],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.amber, width: 3),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.casino, size: 50, color: Colors.amberAccent),
                    const SizedBox(height: 10),
                    Text(
                      'موقع الأخضر: ${playersPositions[0]!["current_tile"]} | موقع الأصفر: ${playersPositions[1]!["current_tile"]}',
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.styleFrom().runtimeType == ButtonStyle
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                            onPressed: isRolling ? null : _onRollPressed,
                            child: Text(isRolling ? 'جاري التحرك...' : 'رمي النرد 🎲',
                                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                          )
                        : Container(),
                  ],
                ),
              ),
            ),

            // قسم الدردشة الاجتماعية
            Expanded(
              flex: 2,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                          return Text(chatMessages[index], style: const TextStyle(color: Colors.white75));
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
