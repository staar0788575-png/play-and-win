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
