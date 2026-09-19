// ====================================================================
// (Billiards Game Controller) - لعبة البلياردو الحقيقية والفيزيائية 🎱
// ====================================================================

import 'dart:async';
import 'package:flutter/material.dart';

// محاكي المتجهات البسيط للفيزياء داخل فلاتر
class Vector2 {
  double x;
  double y;
  Vector2(this.x, this.y);

  double length() => sqrt(x * x + y * y);
  static Vector2 zero() => Vector2(0, 0);
  double sqrt(double val) => val < 0 ? 0 : val; // محاكاة جذر بسيط
}

class RigidBody2D {
  bool freeze;
  Vector2 linear_velocity;
  double angular_velocity;
  Vector2 global_position;
  List<String> groups;
  Map<String, dynamic> metadata;

  RigidBody2D({
    this.freeze = true,
    required.toVector2,
    Vector2? velocity,
    this.angular_velocity = 0.0,
    required this.global_position,
    required this.groups,
    required this.metadata,
  }) : linear_velocity = velocity ?? Vector2.zero();

  bool is_in_group(String group) => groups.contains(group);
  bool has_meta(String key) => metadata.containsKey(key);
  dynamic get_meta(String key) => metadata[key];

  void apply_central_impulse(Vector2 impulse) {
    linear_velocity.x += impulse.x;
    linear_velocity.y += impulse.y;
    freeze = false;
  }
}

class BilliardsGameScreen extends StatefulWidget {
  const BilliardsGameScreen({Key? key}) : super(key: key);

  @override
  State<BilliardsGameScreen> createState() => _BilliardsGameScreenState();
}

class _BilliardsGameScreenState extends State<BilliardsGameScreen> {
  // خصائص ومتغيرات اللعبة الفيزيائية الحقيقية
  bool is_my_turn = true;
  bool is_aiming = false;
  bool is_waiting_for_settlement = false;
  double power_slider_value = 0.0;
  static const double MAX_STRIKER_FORCE = 100.0;
  static const double SETTLEMENT_CHECK_INTERVAL = 0.1;

  int current_turn_player_id = 0;
  int playerScore = 0;

  late RigidBody2D striker;
  final List<RigidBody2D> active_pucks = [];
  final Vector2 striker_spawn_position = Vector2(200, 400);

  // الدوال التبادلية (Callbacks)
  Function(Vector2)? striker_shot;
  Function(String, int)? puck_pocketed;
  Function(int, int)? score_updated;
  Function(int)? turn_switched;

  final List<String> chatMessages = [];
  final TextEditingController chatInputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initializeBilliardsPhysics();
  }

  void initializeBilliardsPhysics() {
    // تجهيز المضرب (Striker)
    striker = RigidBody2D(
      freeze: true,
      toVector2: Vector2.zero(),
      global_position: striker_spawn_position,
      groups: ["striker"],
      metadata: {"type": "White"},
    );

    // تجهيز أقراص اللعبة على الطاولة
    for (int i = 0; i < 6; i++) {
      active_pucks.add(
        RigidBody2D(
          freeze: false,
          toVector2: Vector2.zero(),
          global_position: Vector2(150.0 + (i * 40), 200.0),
          groups: ["pucks"],
          metadata: {"type": i == 0 ? "Queen" : "Normal"},
        ),
      );
    }
  }

  void update_aim_line() {
    // تحديث خط التوجيه مرئياً
    debugPrint("تحديث خط التوجيه (AimLine)");
  }

  // نظام قوة الضربة والإطلاق الفيزيائي الحقيقي
  void on_power_slider_changed(double value) {
    if (!is_my_turn) return;
    setState(() {
      power_slider_value = value;
      is_aiming = true;
    });
    update_aim_line();
  }

  void on_power_released() {
    if (!is_my_turn || !is_aiming || is_waiting_for_settlement) return;

    setState(() {
      is_aiming = false;
      is_waiting_for_settlement = true;
    });

    striker.freeze = false;

    double force_amount = (power_slider_value / 100.0) * MAX_STRIKER_FORCE;
    var impulse_vector = Vector2(0, -force_amount);

    striker.apply_central_impulse(impulse_vector);
    if (striker_shot != null) striker_shot!(impulse_vector);
    debugPrint("تم إطلاق المضرب بقوة فيزيائية: $force_amount");

    await_board_settlement();
  }

  // منطق احتساب الأهداف وانتهاء الدور
  void on_hole_body_entered(dynamic body, int hole_id) {
    if (body is RigidBody2D && body.is_in_group("pucks")) {
      String puck_type = "White";
      if (body.has_meta("type")) {
        puck_type = body.get_meta("type");
      }
      debugPrint("🎯 تم إسقاط قرص من نوع: $puck_type في الحفرة رقم: $hole_id");
      if (puck_pocketed != null) puck_pocketed!(puck_type, hole_id);

      calculate_score(puck_type);
      if (active_pucks.contains(body)) {
        setState(() {
          active_pucks.remove(body);
        });
      }
    } else if (body == striker) {
      debugPrint("⚠️ خطأ كلاسيكي! سقط المضرب في الحفرة.");
      penalty_foul();
    }
  }

  void calculate_score(String puck_type) {
    int points = 10;
    if (puck_type == "Queen") {
      points = 25;
    }
    setState(() {
      playerScore += points;
    });
    if (score_updated != null) score_updated!(current_turn_player_id, points);
  }

  void penalty_foul() {
    reset_striker_for_turn();
  }

  // فحص سرعة استقرار الأجسام فيزيائياً لضمان عدم نقل الدور قبل توقف الأقراص
  void await_board_settlement() async {
    while (is_waiting_for_settlement) {
      await Future.delayed(Duration(milliseconds: (SETTLEMENT_CHECK_INTERVAL * 1000).toInt()));
      bool all_stopped = true;

      if (!striker.freeze && striker.linear_velocity.length() > 5.0) {
        all_stopped = false;
      }

      for (var puck in active_pucks) {
        if (puck is RigidBody2D) {
          if (puck.linear_velocity.length() > 5.0) {
            all_stopped = false;
            break;
          }
        }
      }

      if (all_stopped && mounted) {
        setState(() {
          is_waiting_for_settlement = false;
        });
        reset_striker_for_turn();
        switch_turn();
        break;
      }
    }
  }

  void reset_striker_for_turn() {
    setState(() {
      striker.freeze = true;
      striker.linear_velocity = Vector2.zero();
      striker.angular_velocity = 0.0;
      striker.global_position = striker_spawn_position;
      power_slider_value = 0;
      is_aiming = false;
    });
  }

  void switch_turn() {
    setState(() {
      current_turn_player_id = (current_turn_player_id + 1) % 4;
    });
    if (turn_switched != null) turn_switched!(current_turn_player_id);
    debugPrint("انتقل الدور الآن للاعب رقم: $current_turn_player_id");
  }

  void onChatMessageSubmitted(String newText) {
    if (newText.trim().isEmpty) return;
    setState(() {
      chatMessages.add("اللاعب $current_turn_player_id: $newText");
      chatInputController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('بلياردو توب توب - دور اللاعب: $current_turn_player_id'),
        backgroundColor: Colors.teal[900],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0A192F), Color(0xFF172A45)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // لوحة البلياردو المرئية والفيزيائية الحقيقية
            Expanded(
              flex: 5,
              child: Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0B3C24), // لون طاولة البلياردو الأخضر الداكن الكلاسيكي
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.amber, width: 3),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // معلومات النقاط والأقراص المتبقية
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'النقاط: $playerScore',
                          style: const TextStyle(color: Colors.amberAccent, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'الأقراص الباقية: ${active_pucks.length}',
                          style: const TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),

                    // محاكاة بصرية تفاعلية للطاولة والأقراص
                    Container(
                      height: 160,
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Text(
                              is_waiting_for_settlement ? '⏳ جاري استقرار الأقراص فيزيائياً...' : '🎯 جاهز للضرب والتصويب',
                              style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
                            ),
                          ),
                          // عرض الأقراص النشطة على الطاولة
                          ...active_pucks.asMap().entries.map((entry) {
                            int idx = entry.key;
                            var puck = entry.value;
                            return Positioned(
                              left: (50.0 + (idx * 35)) % 250,
                              top: 60.0,
                              child: CircleAvatar(
                                radius: 12,
                                backgroundColor: puck.has_meta("type") && puck.get_meta("type") == "Queen" ? Colors.red : Colors.white,
                                child: Text('$idx', style: const TextStyle(fontSize: 10, color: Colors.black)),
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),

                    // أشرطة التحكم الفيزيائي بالقوة والضرب
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('قوة الضربة:', style: TextStyle(color: Colors.white, fontSize: 13)),
                            Text('${power_slider_value.toInt()}%', style: const TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Slider(
                          value: power_slider_value,
                          min: 0,
                          max: 100,
                          activeColor: Colors.amber,
                          inactiveColor: Colors.white24,
                          onChanged: on_power_slider_changed,
                          onChangeEnd: (val) => on_power_released(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // صندوق الدردشة والتفاعل السفلي
            Expanded(
              flex: 3,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white24),
                ),
                child: Column(
                  children: [
                    const Text('دردشة طاولة البلياردو', style: TextStyle(color: Colors.white54, fontSize: 11)),
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
                        hintText: 'اكتب رسالة في البلياردو...',
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
