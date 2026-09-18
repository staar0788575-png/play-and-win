// ==============================================================================
// 🎱 مستند الكود البرمجي المترجم والمحدث بالكامل - لعبة بلياردو توب توب (Carrom/Biliards Pool Clone)
// لغة البرمجة: Dart (Flutter) - مخصص بالكامل لمشروع "العب واربح" على GitHub
// ==============================================================================

import 'package:flutter/material.dart';

class BiliardsGameController extends StatefulWidget {
  const BiliardsGameController({Key? key}) : super(key: key);

  @override
  State<BiliardsGameController> createState() => _BiliardsGameControllerState();
}

class _BiliardsGameControllerState extends State<BiliardsGameController> with SingleTickerProviderStateMixin {
  
  // --- [ الثوابت وإعدادات اللعبة / CONSTANTS ] ---
  static const double MAX_STRIKER_FORCE = 800.0;
  static const double SLIDER_MIN_X = 150.0;
  static const double SLIDER_MAX_X = 450.0;

  // --- [ متغيرات حالة اللعبة / GAME STATE ] ---
  bool isMyTurn = true;
  int currentTurnPlayerId = 0;
  bool isAiming = false;
  bool isWaitingForSettlement = false;
  
  double strikerPositionValue = 50.0; // القيمة من 0 إلى 100 لتحديد مكان المضرب أفقياً
  double powerSliderValue = 0.0;     // قوة الضربة الحالية من 0 إلى 100
  
  // بيانات اللاعبين والنتيجة
  Map<int, Map<String, dynamic>> playersData = {
    0: {"name": "Oman", "score": 0, "color": Colors.red},
    1: {"name": "Player_2", "score": 0, "color": Colors.green},
    2: {"name": "Player_3", "score": 0, "color": Colors.amber},
    3: {"name": "Player_4", "score": 0, "color": Colors.blue},
  };

  // الأقراص النشطة على الطاولة
  List<String> activePucks = ["White", "White", "White", "Queen", "Black", "Black"];

  // نظام الدردشة داخل اللعبة
  final List<String> chatMessages = [];
  final TextEditingController chatInputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setupGameBoard();
  }

  // ==============================================================================
  // 1. دالة بدء اللعبة والتجهيز (INITIALIZATION)
  // ==============================================================================
  void setupGameBoard() {
    debugPrint("تم شحن طاولة البلياردو الافتراضية بنجاح.");
    resetStrikerForTurn();
  }

  // ==============================================================================
  // 2. تحريك المضرب وتحديد الهدف (STRIKER AIMING & POSITIONING)
  // ==============================================================================
  void onStrikerPositionChanged(double value) {
    if (!isMyTurn || isWaitingForSettlement) return;
    setState(() {
      strikerPositionValue = value;
    });
  }

  // ==============================================================================
  // 3. نظام قوة الضربة والإطلاق (SHOOTING MECHANICAL SYSTEM)
  // ==============================================================================
  void onPowerSliderChanged(double value) {
    if (!isMyTurn) return;
    setState(() {
      isAiming = true;
      powerSliderValue = value;
    });
  }

  void onPowerReleased() {
    if (!isMyTurn || !isAiming || isWaitingForSettlement) return;
    
    setState(() {
      isAiming = false;
      isWaitingForSettlement = true;
    });

    double forceAmount = (powerSliderValue / 100.0) * MAX_STRIKER_FORCE;
    debugPrint("تم إطلاق المضرب في لعبة البلياردو بقوة فيزيائية: $forceAmount");

    // تم إزالة await الخاطئة لأن الدالة void لضمان نجاح البناء على GitHub
    awaitBoardSettlement();
  }

  // ==============================================================================
  // 4. منطق احتساب الأهداف وانتهاء الدور (SCORING & POCKETING LOGIC)
  // ==============================================================================
  void simulatePocketingPuck(String puckType) {
    debugPrint("🎯 تم إسقاط قرص من نوع: $puckType في البلياردو");
    calculateScore(puckType);
  }

  void calculateScore(String puckType) {
    int points = (puckType == "Queen") ? 25 : 10;
    setState(() {
      playersData[currentTurnPlayerId]!["score"] += points;
    });
  }

  void penaltyFoul() {
    debugPrint("⚠️ خطأ كلاسيكي! سقط المضرب في الحفرة.");
    resetStrikerForTurn();
    switchTurn();
  }

  void awaitBoardSettlement() {
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      setState(() {
        isWaitingForSettlement = false;
      });
      resetStrikerForTurn();
      switchTurn();
    });
  }

  void resetStrikerForTurn() {
    setState(() {
      powerSliderValue = 0.0;
      isAiming = false;
      strikerPositionValue = 50.0;
    });
  }

  void switchTurn() {
    setState(() {
      currentTurnPlayerId = (currentTurnPlayerId + 1) % 4;
    });
    debugPrint("انتقل الدور الآن للاعب رقم: $currentTurnPlayerId في البلياردو");
  }

  // ==============================================================================
  // 5. نظام الشات والفقاعات (SOCIAL CHAT SYSTEM)
  // ==============================================================================
  void onChatMessageSubmitted(String newText) {
    if (newText.trim().isEmpty) return;
    
    setState(() {
      String senderName = playersData[currentTurnPlayerId]!["name"];
      chatMessages.add("$senderName: $newText");
      chatInputController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("بلياردو توب توب - دور: ${playersData[currentTurnPlayerId]!["name"]}"),
        backgroundColor: Colors.teal[900],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F0B19), Color(0xFF0F2027)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // قسم محاكاة طاولة البلياردو والتصويب
            Expanded(
              flex: 3,
              child: Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.tealAccent.withOpacity(0.3)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.sports_bar, size: 60, color: Colors.tealAccent),
                    const SizedBox(height: 10),
                    Text(
                      "النقاط: ${playersData[currentTurnPlayerId]!["score"]}",
                      style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    // شريط تحديد مكان المضرب أفقياً
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        children: [
                          const Text("موقع المضرب الأفقي", style: TextStyle(color: Colors.white70, fontSize: 12)),
                          Slider(
                            value: strikerPositionValue,
                            min: 0,
                            max: 100,
                            activeColor: Colors.tealAccent,
                            onChanged: onStrikerPositionChanged,
                          ),
                        ],
                      ),
                    ),
                    // شريط قوة الضربة
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        children: [
                          Text("قوة الضربة: ${powerSliderValue.toInt()}%", style: const TextStyle(color: Colors.white70, fontSize: 12)),
                          Slider(
                            value: powerSliderValue,
                            min: 0,
                            max: 100,
                            activeColor: Colors.amber,
                            onChanged: onPowerSliderChanged,
                            onChangeEnd: (val) => onPowerReleased(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // قسم الشات المصغر
            Expanded(
              flex: 2,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                        hintText: "اكتب رسالة في البلياردو...",
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
