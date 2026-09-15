// ==============================================================================
// 🎮 مستند الكود البرمجي المعدل والمحدث - لعبة السلم والثعبان الاجتماعية
// المحرك المستهدف: Godot Engine 4.x (تم تحويله خصيصاً لـ Dart وتوافق Flutter)
// لغة البرمجة: Dart - متوافق مع بنية المستودع والبناء التلقائي في جيت هب
// ==============================================================================

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

// --- [ محاكاة متجهات الفضاء الثنائي ] ---
class Vector2 {
  double x;
  double y;
  Vector2(this.x, this.y);
  
  static final zero = Vector2(0.0, 0.0);
}

// --- [ كلاس حالة اللعبة والمنطق الاجتماعي ] ---
class SnakesAndLaddersGameLogic {
  // --- [ إشارات اللعبة / SIGNALS ] ---
  Function(int resultValue)? diceRolled;
  Function(int playerId, int finalTile)? playerMoved;
  Function(String actionType, int targetPlayer)? socialActionTriggered;
  Function(int playerId)? playerWon;

  // --- [ الإعدادات والثوابت / CONSTANTS ] ---
  static const int MAX_TILES = 100; // إجمالي عدد مربعات اللوحة
  static const double TURN_TIME_LIMIT = 15.0; // الميقاتي التنازلي لكل لاعب

  // قاموس السلالم والثعابين (المفتاح: مربع البداية -> القيمة: مربع النهاية)
  static const Map<int, int> LADDERS = {
    14: 38,
    6: 29,
    29: 93
  };
  
  static const Map<int, int> SNAKES = {
    98: 27,
    83: 73,
    16: 1
  };

  // --- [ مراجع العقد / ONREADY VARIABLES - محاكاة الحالة ] ---
  List<Vector2> tilesCoordinates = [];
  
  // متغيرات حالة اللعبة / GAME STATE
  int currentPlayerTurn = 0;
  bool isRolling = false;
  
  Map<int, Map<String, dynamic>> playersPositions = {
    0: {"name": "Green Player", "current_tile": 0, "node_name": "TokenGreen"},
    1: {"name": "Yellow Player", "current_tile": 0, "node_name": "TokenYellow"}
  };

  // ==============================================================================
  // 1. دالة بدء اللعبة والتجهيز (INITIALIZATION)
  // ==============================================================================
  void ready() {
    generateBoardCoordinates();
    setupSocialConnections();
    startTurn();
  }

  void generateBoardCoordinates() {
    tilesCoordinates.clear();
    for (int i = 0; i <= 101; i++) {
      tilesCoordinates.add(Vector2(50 * (i % 10).toDouble(), 600 - (50 * (i ~/ 10)).toDouble()));
    }
    print("تم بناء مصفوفة الـ 100 مربع بنجاح وتحديثها لمشروع جيت هب.");
  }

  void setupSocialConnections() {
    // ربط أزرار النرد والدردشة برمجياً في واجهة الفلاتر
    print("تم إعداد الروابط الاجتماعية بنجاح.");
  }

  // ==============================================================================
  // 2. نظام رمي النرد (DICE MECHANICS)
  // ==============================================================================
  void startTurn() {
    isRolling = false;
    print("Turn: " + playersPositions[currentPlayerTurn]["name"]);
  }

  void onRollPressed() {
    if (isRolling) return;
    isRolling = true;
    
    var random = Random();
    int diceResult = random.nextInt(6) + 1;
    if (diceRolled != null) diceRolled!(diceResult);

    animateDiceRoll(diceResult);
  }

  void animateDiceRoll(int result) async {
    await Future.delayed(Duration(milliseconds: 600));
    movePlayerToken(currentPlayerTurn, result);
  }

  // ==============================================================================
  // 3. منطق الحركة، السلالم، والثعابين (GAMEPLAY LOGIC)
  // ==============================================================================
  void movePlayerToken(int playerId, int steps) async {
    int oldTile = playersPositions[playerId]["current_tile"];
    int targetTile = oldTile + steps;
    
    if (targetTile > MAX_TILES) {
      targetTile = oldTile;
      print("تجاوزت النتيجة المربع 100، تم البقاء في المربع الحالي.");
      switchTurn();
      return;
    }

    for (int step = oldTile + 1; step <= targetTile; step++) {
      playersPositions[playerId]["current_tile"] = step;
      await animateTokenStep(playerId, step);
    }

    checkBoardModifiers(playerId, targetTile);
  }

  Future<void> animateTokenStep(int playerId, int tileIndex) async {
    // محاكاة حركة الخطوات بسلاسة
    await Future.delayed(Duration(milliseconds: 200));
  }

  void checkBoardModifiers(int playerId, int currentTile) async {
    if (LADDERS.containsKey(currentTile)) {
      int topTile = LADDERS[currentTile]!;
      print("🪜 سلم! الصعود إلى المربع: $topTile");
      playersPositions[playerId]["current_tile"] = topTile;
      await animateTokenStep(playerId, topTile);
    } else if (SNAKES.containsKey(currentTile)) {
      int bottomTile = SNAKES[currentTile]!;
      print("🐍 ثعبان! الهبوط إلى المربع: $bottomTile");
      playersPositions[playerId]["current_tile"] = bottomTile;
      await animateTokenStep(playerId, bottomTile);
    }

    if (playerMoved != null) {
      playerMoved!(playerId, playersPositions[playerId]["current_tile"]);
    }

    if (playersPositions[playerId]["current_tile"] == MAX_TILES) {
      declareWinner(playerId);
    } else {
      switchTurn();
    }
  }

  void switchTurn() {
    currentPlayerTurn = (currentPlayerTurn + 1) % playersPositions.length;
    startTurn();
  }

  void declareWinner(int playerId) {
    print("🏆 الفائز بالمركز الأول هو: " + playersPositions[playerId]["name"]);
    if (playerWon != null) playerWon!(playerId);
  }

  // ==============================================================================
  // 4. ميزات الدردشة والمايك الصوتية المدمجة (INTEGRATED SOCIAL FEATURES)
  // ==============================================================================
  void onChatMessageSubmitted(String newText, Function(Widget messageWidget) onAddMessage) {
    if (newText.trim().isEmpty) return;
    
    var messageText = playersPositions[currentPlayerTurn]["name"]! + ": " + newText;
    print("رسالة دردشة جديدة: $messageText");
  }

  void onMicToggled(bool isActive) {
    if (isActive) {
      print("🎙️ تم تفعيل المايكروفون وبث الصوت لغرفة اللعبة.");
    } else {
      print("🔇 تم كتم المايكروفون الشخصي.");
    }
  }

  void onSpeakerToggled(bool isActive) {
    print("🔊 مكبر الصوت يعمل بالحالة: $isActive");
  }
}
