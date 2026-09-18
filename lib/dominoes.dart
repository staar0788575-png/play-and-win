// ====================================================================
// (Dominoes Game Logic & UI) - لعبة الدومينو 🎲
// المتوافق مع هيكل التطبيق والمنطق البرمجي الكامل
// ====================================================================

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

// --- محاكاة متجهات الهندسة لـ Dart ---
class Vector2 {
  double x;
  double y;
  Vector2(this.x, this.y);

  static final zero = Vector2(0.0, 0.0);
}

// --- كلاس حال اللعبة والمنطق الاجتماعي ---
class DominoesGameLogic extends StatefulWidget {
  const DominoesGameLogic({Key? key}) : super(key: key);

  @override
  State<DominoesGameLogic> createState() => _DominoesGameLogicState();
}

class _DominoesGameLogicState extends State<DominoesGameLogic> {
  // --- إشارات العيد / SIGNALS ---
  Function(int dominoIndex, int sideChosen)? dominoPlaced;
  Function(int nextPlayerId)? turnSwitched;
  Function(int playerId)? playerPassedTurn;
  Function(int playerId)? playerWon;

  // --- الإعدادات والثوابت / CONSTANTS ---
  static const int HAND_LIMIT = 7; // عدد القطع الافتراضي في يد كل لاعب

  // --- متغيرات الحالة / GAME STATE ---
  int currentPlayerTurn = 0;
  int tableLeftValue = -1;
  int tableRightValue = -1;

  Map<int, Map<String, dynamic>> playersHands = {
    0: {"name": "Player 1", "dominoes": <List<int>>[]},
    1: {"name": "Player 2", "dominoes": <List<int>>[]},
  };

  // قائمة الرسائل والتحكم في الشات
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
    _initializeDominoDeck();
    _setupSocialFeatures();
    _startGameRound();
  }

  void _initializeDominoDeck() {
    debugPrint("تم سحب الأقطعة الكلاسيكي بنجاح لمشروع جيت هب.");
    var random = Random();
    for (int i = 0; i < HAND_LIMIT; i++) {
      playersHands[0]!["dominoes"].add([random.nextInt(7), random.nextInt(7)]);
      playersHands[1]!["dominoes"].add([random.nextInt(7), random.nextInt(7)]);
    }
  }

  void _setupSocialFeatures() {
    debugPrint("تم إعداد الميزات الاجتماعية بنجاح.");
  }

  // ====================================================================
  // 2. ميكانيكيات اللعب والتطبيق / (DOMINO PLAY & MATCHING LOGIC)
  // ====================================================================
  void _startGameRound() {
    setState(() {
      currentPlayerTurn = 0;
      _updateTurnUi();
    });
  }

  void _updateTurnUi() {
    debugPrint("دور اللاعب: ${playersHands[currentPlayerTurn]!["name"]}");
  }

  void _onDistributePressed() {
    debugPrint("تم الضغط على 🀄 الموزع سحب قطعة جديدة يدعمها النظام البرمجي.");
    var random = Random();
    setState(() {
      playersHands[currentPlayerTurn]!["dominoes"].add([random.nextInt(7), random.nextInt(7)]);
    });
  }

  void _tryPlaceDomino(int playerId, int dominoIndex, int valA, int valB, bool placeAtLeft) {
    if (playerId != currentPlayerTurn) {
      debugPrint("ليس دورك الحركي الآن!");
      return;
    }

    if (tableLeftValue == -1 && tableRightValue == -1) {
      setState(() {
        tableLeftValue = valA;
        tableRightValue = valB;
        _executeDominoPlacement(playerId, dominoIndex, Vector2(0.0, 0.0));
      });
      return;
    }

    if (placeAtLeft) {
      if (valA == tableLeftValue) {
        setState(() {
          tableLeftValue = valB;
          _executeDominoPlacement(playerId, dominoIndex, _getNextLeftPosition());
        });
      } else if (valB == tableLeftValue) {
        setState(() {
          tableLeftValue = valA;
          _executeDominoPlacement(playerId, dominoIndex, _getNextLeftPosition());
        });
      } else {
        debugPrint("الحركة غير قانونية للطرف اليسري.");
      }
    } else {
      if (valA == tableRightValue) {
        setState(() {
          tableRightValue = valB;
          _executeDominoPlacement(playerId, dominoIndex, _getNextRightPosition());
        });
      } else if (valB == tableRightValue) {
        setState(() {
          tableRightValue = valA;
          _executeDominoPlacement(playerId, dominoIndex, _getNextRightPosition());
        });
      } else {
        debugPrint("الحركة غير قانونية للطرف اليمني.");
      }
    }
  }

  void _executeDominoPlacement(int playerId, int dominoIndex, Vector2 spawnPos) {
    List<List<int>> dominoesList = playersHands[playerId]!["dominoes"];
    if (dominoIndex >= 0 && dominoIndex < dominoesList.length) {
      dominoesList.removeAt(dominoIndex);
      debugPrint("تم وضع قطعة الدومينو بنجاح على اللوحة برمجياً.");

      if (dominoesList.isEmpty) {
        debugPrint("🎉 الفائز بالدور هو ${playersHands[playerId]!["name"]}");
        if (playerWon != null) playerWon!(playerId);
      } else {
        _switchTurn();
      }
    }
  }

  void _switchTurn() {
    setState(() {
      currentPlayerTurn = (currentPlayerTurn + 1) % 2;
      _updateTurnUi();
    });
  }

  Vector2 _getNextLeftPosition() => Vector2(-100, 0);
  Vector2 _getNextRightPosition() => Vector2(100, 0);

  // ====================================================================
  // 3. ميزات الدردشة والمايك الصوتية / (INTEGRATED SOCIAL FEATURES)
  // ====================================================================
  void _onChatMessageSubmitted(String newText) {
    if (newText.trim().isEmpty) return;
    setState(() {
      String chatMessage = "${playersHands[currentPlayerTurn]!["name"]}: $newText";
      chatMessages.add(chatMessage);
      chatInputController.clear();
    });
  }

  void _onMicToggled(bool isActive) {
    setState(() {
      isMicActive = isActive;
    });
    debugPrint(isActive ? "تم تفعيل المايك الصوت لغرفة اللعبة." : "تم كتم المايك الشخصي.");
  }

  void _onSpeakerToggled(bool isActive) {
    setState(() {
      isSpeakerActive = isActive;
    });
    debugPrint("مكبر الصوت معدل: $isActive");
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> currentHand = playersHands[currentPlayerTurn]!["dominoes"] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('لعبة الدومينو - دور: ${playersHands[currentPlayerTurn]!["name"]}'),
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
            // طاولة اللعبة الرئيسية
            Expanded(
              flex: 4,
              child: Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.brown[800],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.amber, width: 3),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.casino, size: 40, color: Colors.amberAccent),
                    const SizedBox(height: 8),
                    Text(
                      'الطاولة: [ $tableLeftValue ]  ⇄  [ $tableRightValue ]',
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                      onPressed: _onDistributePressed,
                      icon: const Icon(Icons.add, color: Colors.black),
                      label: const Text('سحب قطعة من الموزع', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 12),
                    const Text('قطع يد اللاعب الحالي:', style: TextStyle(color: Colors.white70, fontSize: 14)),
                    const SizedBox(height: 6),
                    SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: currentHand.length,
                        itemBuilder: (context, index) {
                          var domino = currentHand[index];
                          return GestureDetector(
                            onTap: () => _tryPlaceDomino(currentPlayerTurn, index, domino[0], domino[1], true),
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text('${domino[0]} | ${domino[1]}',
                                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
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
