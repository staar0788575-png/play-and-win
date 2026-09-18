// ====================================================================
// (Snakes and Ladders Game Logic & UI) - لعبة السلم والثعبان 🐍🪜
// المتوافق مع شريط الـ VIP والورود، والدردشة الفورية عبر Firebase
// ====================================================================

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'game_chat_widget.dart'; // استيراد ويدجت الدردشة المشترك المتصل بـ Firebase
import 'game_social_bar.dart'; // استيراد شريط الميزات الاجتماعية والـ VIP والورود

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
  // --- إشارات اللعبة / SIGNALS ---
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

  List<Vector2> tilesCoordinates = [];

  // --- متغيرات حالة اللعبة / GAME STATE ---
  int currentPlayerTurn = 0;
  bool isRolling = false;

  Map<int, Map<String, dynamic>> playersPositions = {
    0: {"name": "Green Player", "current_tile": 0, "node_name": "TokenGreen"},
    1: {"name": "Yellow Player", "current_tile": 0, "node_name": "TokenYellow"},
  };

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
    debugPrint("تم بناء مصميفة الـ 100 مربع وتحديثها بنجاح.");
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
  // 4. ميزات التحكم الصوتي
  // ====================================================================
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
    String currentName = playersPositions[currentPlayerTurn]!["name"];

    return Scaffold(
      appBar: AppBar(
        title: Text('السلم والثعبان 🐍 - دور: $currentName'),
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
            // 🌟 شريط الميزات الاجتماعية والـ VIP والورود اليومية
            GameSocialBar(
              isVip: true,
              dailyFlowersCount: 5,
              onMicToggle: (isMicOn) {
                debugPrint(isMicOn ? "تم فتح المايك الصوتي في السلم والثعبان" : "تم كتم المايك");
              },
              onSendGift: () {
                debugPrint("تم إرسال هدية أو وردة في طاولة السلم والثعبان");
              },
            ),

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
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                      onPressed: isRolling ? null : _onRollPressed,
                      child: Text(
                        isRolling ? 'جاري التحرك...' : 'رمي النرد 🎲',
                        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // قسم الدردشة الاجتماعية المباشرة عبر Firebase
            Expanded(
              flex: 3,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                      child: Text(
                        '💬 دردشة طاولة السلم والثعبان:',
                        style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                    const Divider(color: Colors.white24, height: 1),
                    Expanded(
                      child: GameChatWidget(
                        playerName: currentName,
                      ),
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
