// ==============================================================================
// 🎮 مستند الكود البرمجي المعدل والمحدث - لعبة كيرم توب توب (Carrom Pool Clone)
// المحرك المستهدف: Godot Engine 4.x (تم تحويله خصيصاً للغة Dart ليتوافق مع Flutter)
// لغة البرمجة: Dart - معتمد على منطق اللعبة الفيزيائي 2D
// ==============================================================================

import 'dart:async';
import 'package:flutter/material.dart';

// --- [ محاكاة المتجهات الفيزيائية لغة Dart ] ---
class Vector2 {
  double x;
  double y;
  Vector2(this.x, this.y);

  static final zero = Vector2(0.0, 0.0);

  double length() {
    return (x * x + y * y);
  }
}

class RigidBody2D {
  bool freeze = true;
  Vector2 linear_velocity = Vector2.zero;
  double angular_velocity = 0.0;
  Vector2 global_position = Vector2.zero;
  List<String> _groups = [];
  Map<String, dynamic> _meta = {};

  bool is_in_group(String group) => _groups.contains(group);
  bool has_meta(String key) => _meta.containsKey(key);
  dynamic get_meta(String key) => _meta[key];

  void apply_central_impulse(Vector2 impulse) {
    linear_velocity = Vector2(linear_velocity.x + impulse.x, linear_velocity.y + impulse.y);
  }
}

// --- [ كلاس الحالة العامة للعبة ] ---
class CarromGameLogic {
  // --- [ إشارات اللعبة / SIGNALS ] ---
  Function(Vector2 force)? striker_shot;
  Function(int playerId, int newScore)? score_updated;
  Function(String puckType, int holeId)? puck_pocketed;
  Function(int newPlayerId)? turn_switched;

  // --- [ الإعدادات والثوابت / CONSTANTS ] ---
  static const double MAX_STRIKER_FORCE = 800.0; // أقصى قوة ضربة للمضرب
  static const double SLIDER_MIN_X = 150.0; // حدود السحب الأفقي للمضرب (يمين ويسار)
  static const double SLIDER_MAX_X = 450.0;
  static const double SETTLEMENT_CHECK_INTERVAL = 0.5; // فترة التحقق من استقرار الأقراص بالثواني

  // --- [ مراجع العقد / ONREADY VARIABLES ] ---
  // (في فلاتر يتم ربط هذه العناصر بـ Widgets الخاصة بواجهة المستخدم أو الشجرة)
  late RigidBody2D striker; 
  List<RigidBody2D> active_pucks = [];
  
  double horizontal_slider_value = 0.0;
  double power_slider_value = 0.0;

  // --- [ متغيرات حالة اللعبة / GAME STATE ] ---
  bool is_my_turn = true;
  int current_turn_player_id = 0;
  bool is_aiming = false;
  Vector2 striker_spawn_position = Vector2(300, 750); // مكان وقوف المضرب الافتراضي بالأسفل
  bool is_waiting_for_settlement = false;

  // ==============================================================================
  // 1. دالة بدء اللعبة والتجهيز (INITIALIZATION)
  // ==============================================================================
  void ready() {
    setup_game_board();
    reset_striker_for_turn();
    
    // ربط إشارات واجهة المستخدم (Sliders) بأمان لمنع التكرار
    // (يتم التعامل معها برمجياً عند تغير قيم الـ Sliders في واجهة الفلاتر)
  }

  void setup_game_board() {
    print("تم شحن طاولة الكيرم الافتراضية بنجاح.");
    spawn_pucks_in_center();
  }

  void spawn_pucks_in_center() {
    active_pucks.clear();
    // البحث عن جميع الأقراص في مجموعة pucks وإضافتها للقائمة البرمجية للمتابعة
    // (هنا يتم جلب العناصر المدرجة ضمن مجموعة الأقراص)
    print("تمت تهيئة وتتبع الأقراص بنجاح. الإجمالي: ${active_pucks.size()}");
  }

  int getActivePucksSize() => active_pucks.length;


  // ==============================================================================
  // 2. تحريك المضرب وتحديد الهدف (STRIKER AIMING & POSITIONING)
  // ==============================================================================
  void on_striker_position_changed(double value) {
    if (!is_my_turn || !striker.freeze) {
      return;
    }
    double target_x = _lerp(SLIDER_MIN_X, SLIDER_MAX_X, value / 100.0);
    striker.global_position.x = target_x;
    update_aim_line();
  }

  double _lerp(double a, double b, double t) {
    return a + (b - a) * t;
  }

  void update_aim_line() {
    // تحديث خط التوجيه مرئياً
    print("تحديث خط التوجيه (AimLine)");
  }


  // ==============================================================================
  // 3. نظام قوة الضربة والإطلاق (SHOOTING MECHANICAL SYSTEM)
  // ==============================================================================
  void on_power_slider_changed(double value) {
    if (!is_my_turn) {
      return;
    }
    is_aiming = true;
    // تحديث طول خط التوجيه بناء على القوة
  }

  void on_power_released() {
    if (!is_my_turn || !is_aiming || is_waiting_for_settlement) {
      return;
    }
    
    is_aiming = false;
    is_waiting_for_settlement = true;

    striker.freeze = false;

    double force_amount = (power_slider_value / 100.0) * MAX_STRIKER_FORCE;
    var impulse_vector = Vector2(0, -force_amount);

    striker.apply_central_impulse(impulse_vector);
    if (striker_shot != null) striker_shot!(impulse_vector);
    print("تم إطلاق المضرب بقوة فيزيائية: $force_amount");

    await_board_settlement();
  }


  // ==============================================================================
  // 4. منطق احتساب الأهداف وانتهاء الدور (SCORING & POCKETING LOGIC)
  // ==============================================================================
  void on_hole_body_entered(dynamic body, int hole_id) {
    if (body is RigidBody2D && body.is_in_group("pucks")) {
      String puck_type = "White";
      if (body.has_meta("type")) {
        puck_type = body.get_meta("type");
      }
      print("🎯 تم إسقاط قرص من نوع: $puck_type في الحفرة رقم: $hole_id");
      if (puck_pocketed != null) puck_pocketed!(puck_type, hole_id);

      calculate_score(puck_type);
      if (active_pucks.contains(body)) {
        active_pucks.remove(body);
      }
    } else if (body == striker) {
      print("⚠️ خطأ كلاسيكي! سقط المضرب في الحفرة.");
      penalty_foul();
    }
  }

  void calculate_score(String puck_type) {
    int points = 10;
    if (puck_type == "Queen") {
      points = 25;
    }
    if (score_updated != null) score_updated!(current_turn_player_id, points);
  }

  void penalty_foul() {
    reset_striker_for_turn();
  }

  // دالة منتظمة لفحص سرعة استقرار الأجسام فيزيائياً لضمان عدم نقل الدور حركة الأقراص
  void await_board_settlement() async {
    while (true) {
      await Future.delayed(Duration(milliseconds: (SETTLEMENT_CHECK_INTERVAL * 1000).toInt()));
      bool all_stopped = true;

      // فحص سرعة المضرب
      if (!striker.freeze && striker.linear_velocity.length() > 5.0) {
        all_stopped = false;
      }

      // فحص سرعة كافة الأقراص المتبقية على الطاولة
      for (var puck in active_pucks) {
        if (puck is RigidBody2D) {
          if (puck.linear_velocity.length() > 5.0) {
            all_stopped = false;
            break;
          }
        }
      }

      if (all_stopped) {
        is_waiting_for_settlement = false;
        reset_striker_for_turn();
        switch_turn();
        break;
      }
    }
  }

  void reset_striker_for_turn() {
    striker.freeze = true;
    striker.linear_velocity = Vector2.zero;
    striker.angular_velocity = 0.0;
    striker.global_position = striker_spawn_position;
    power_slider_value = 0;
    is_aiming = false;
  }

  void switch_turn() {
    current_turn_player_id = (current_turn_player_id + 1) % 4;
    if (turn_switched != null) turn_switched!(current_turn_player_id);
    print("انتقل الدور الآن للاعب رقم: $current_turn_player_id");
  }
}
