// ==============================================================================
// 🎮 مستند الكود البرمجي المعدل والمحدث - لعبة الدومينو الاجتماعية (Dominoes Clone)
// المحرك المستهدف: Godot Engine 4.x (تم تحويله خصيصاً لـ Dart وتوافق Flutter)
// لغة البرمجة: Dart - متوافق مع مستودع جيت هب ومكتبات البناء التلقائي
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
class DominoesGameLogic {
  // --- [ إشارات اللعبة / SIGNALS ] ---
  Function(int dominoId, int sideChosen)? dominoPlaced;
  Function(int nextPlayerId)? turnSwitched;
  Function(int playerId)? playerPassedTurn;
  Function(int playerId)? playerWon;

  // --- [ الإعدادات والثوابت / CONSTANTS ] ---
  static const int HAND_LIMIT = 7; // عدد القطع الافتراضي في يد كل لاعب عند البداية

  // --- [ مراجع العقد / ONREADY VARIABLES - محاكاة الحالة ] ---
  // (يتم ربط هذه العناصر بـ Widgets الواجهة الرسومية في فلاتر)
  
  // --- [ متغيرات حالة اللعبة / GAME STATE ] ---
  int currentPlayerTurn = 0;
  int tableLeftValue = -1;
  int tableRightValue = -1;
  
  Map<int, Map<String, dynamic>> playersHands = {
    0: {"name": "Player 1", "dominoes": <List<int>>[]},
    1: {"name": "Player 2", "dominoes": <List<int>>[]}
  };

  // ==============================================================================
  // 1. دالة بدء اللعبة والتجهيز (INITIALIZATION)
  // ==============================================================================
  void ready() {
    initializeDominoDeck();
    setupSocialFeatures();
    startGameRound();
  }

  void initializeDominoDeck() {
    print("تم شحن الرقعة الخضراء وورق الدومينو الكلاسيكي بنجاح لمشروع جيت هب.");
    var random = Random();
    for (int i = 0; i < HAND_LIMIT; i++) {
      playersHands[0]["dominoes"].add([random.nextInt(7), random.nextInt(7)]);
      playersHands[1]["dominoes"].add([random.nextInt(7), random.nextInt(7)]);
    }
  }

  void setupSocialFeatures() {
    // ربط الأزرار والدردشة برمجياً في واجهة الفلاتر
    print("تم إعداد الميزات الاجتماعية بنجاح.");
  }

  // ==============================================================================
  // 2. ميكانيكيات اللعب والمطابقة (DOMINO PLAY & MATCHING LOGIC)
  // ==============================================================================
  void startGameRound() {
    currentPlayerTurn = 0;
    updateTurnUi();
  }

  void updateTurnUi() {
    print("دور اللاعب: Turn: " + playersHands[currentPlayerTurn]["name"]);
  }

  void onDistributePressed() {
    print("تم الضغط على زر التوزيع، سحب قطعة جديدة يدعمها النظام البرمجي.");
    var random = Random();
    playersHands[currentPlayerTurn]["dominoes"].add([random.nextInt(7), random.nextInt(7)]);
  }

  void tryPlaceDomino(int playerId, int dominoIndex, int valA, int valB, bool placeAtLeft) {
    if (playerId != currentPlayerTurn) {
      print("ليس دورك الحركي الآن!");
      return;
    }
    if (tableLeftValue == -1 && tableRightValue == -1) {
      tableLeftValue = valA;
      tableRightValue = valB;
      executeDominoPlacement(playerId, dominoIndex, Vector2(0, 0), 0.0);
      return;
    }

    if (placeAtLeft) {
      if (valA == tableLeftValue) {
        tableLeftValue = valB;
        executeDominoPlacement(playerId, dominoIndex, getNextLeftPosition(), 90.0);
      } else if (valB == tableLeftValue) {
        tableLeftValue = valA;
        executeDominoPlacement(playerId, dominoIndex, getNextLeftPosition(), 90.0);
      } else {
        print("الحركة غير قانونية للأطرف اليسرى.");
      }
    } else {
      if (valA == tableRightValue) {
        tableRightValue = valB;
        executeDominoPlacement(playerId, dominoIndex, getNextRightPosition(), 0.0);
      } else if (valB == tableRightValue) {
        tableRightValue = valA;
        executeDominoPlacement(playerId, dominoIndex, getNextRightPosition(), 0.0);
      } else {
        print("الحركة غير قانونية للأطرف اليمنى.");
      }
    }
  }

  void executeDominoPlacement(int playerId, int dominoIndex, Vector2 spawnPos, double rotationAngle) {
    List dominoesList = playersHands[playerId]["dominoes"];
    if (dominoIndex >= 0 && dominoIndex < dominoesList.length) {
      dominoesList.removeAt(dominoIndex);
      print("تم وضع قطعة الدومينو بنجاح على اللوحة برمجياً.");
      if (dominoPlaced != null) dominoPlaced!(dominoIndex, placeChosenSide(rotationAngle));

      if (dominoesList.isEmpty) {
        print("🏆 الفائز بالدور هو: " + playersHands[playerId]["name"]);
        if (playerWon != null) playerWon!(playerId);
      } else {
        switchTurn();
      }
    }
  }

  int placeChosenSide(double angle) {
    return angle == 90.0 ? 0 : 1;
  }

  void switchTurn() {
    currentPlayerTurn = (currentPlayerTurn + 1) % 2;
    if (turnSwitched != null) turnSwitched!(currentPlayerTurn);
    updateTurnUi();
  }

  Vector2 getNextLeftPosition() {
    return Vector2(-100, 0);
  }

  Vector2 getNextRightPosition() {
    return Vector2(100, 0);
  }

  // ==============================================================================
  // 3. ميزات الدردشة والمايك الصوتية المدمجة (INTEGRATED SOCIAL FEATURES)
  // ==============================================================================
  void onChatMessageSubmitted(String newText) {
    if (newText.trim().isEmpty) return;
    var chatMessage = playersHands[currentPlayerTurn]["name"] + ": " + newText;
    print("رسالة دردشة جديدة: $chatMessage");
  }

  void onMicToggled(bool isActive) {
    if (isActive) {
      print("🎙️ تم تفعيل المايك وبث الصوت لغرفة الدومينو.");
    } else {
      print("🔇 تم كتم المايك الشخصي.");
    }
  }

  void onSpeakerToggled(bool isActive) {
    print("🔊 حالة مكبر صوت الطاولة التنافسية: $isActive");
  }
}
