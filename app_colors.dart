import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary — Deep Blue
  static const Color primary = Color(0xFF1B4DFF);
  static const Color primaryLight = Color(0xFF5B7BFF);
  static const Color primaryDark = Color(0xFF0A2BBF);
  static const Color primaryContainer = Color(0xFFE0E7FF);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFF00164E);

  // Secondary — Teal
  static const Color secondary = Color(0xFF00BFA6);
  static const Color secondaryLight = Color(0xFF5BE3D0);
  static const Color secondaryDark = Color(0xFF00897B);
  static const Color secondaryContainer = Color(0xFFB6F5EC);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onSecondaryContainer = Color(0xFF00201A);

  // Accent — Amber
  static const Color accent = Color(0xFFFFB300);
  static const Color accentLight = Color(0xFFFFD54F);
  static const Color accentDark = Color(0xFFFF8F00);
  static const Color accentContainer = Color(0xFFFFF3D9);
  static const Color onAccent = Color(0xFF1A1A1A);

  // Success
  static const Color success = Color(0xFF2E7D32);
  static const Color successLight = Color(0xFF66BB6A);
  static const Color successContainer = Color(0xFFC8E6C9);

  // Warning
  static const Color warning = Color(0xFFF57C00);
  static const Color warningLight = Color(0xFFFFB74D);
  static const Color warningContainer = Color(0xFFFFE0B2);

  // Error
  static const Color error = Color(0xFFD32F2F);
  static const Color errorLight = Color(0xFFEF5350);
  static const Color errorContainer = Color(0xFFFFCDD2);

  // Neutrals
  static const Color neutral0 = Color(0xFF000000);
  static const Color neutral10 = Color(0xFF1A1A1A);
  static const Color neutral20 = Color(0xFF333333);
  static const Color neutral30 = Color(0xFF4D4D4D);
  static const Color neutral40 = Color(0xFF666666);
  static const Color neutral50 = Color(0xFF808080);
  static const Color neutral60 = Color(0xFF999999);
  static const Color neutral70 = Color(0xFFB3B3B3);
  static const Color neutral80 = Color(0xFFCCCCCC);
  static const Color neutral90 = Color(0xFFE6E6E6);
  static const Color neutral95 = Color(0xFFF2F2F2);
  static const Color neutral100 = Color(0xFFFFFFFF);

  // Dark theme backgrounds
  static const Color darkBackground = Color(0xFF0D1117);
  static const Color darkSurface = Color(0xFF161B22);
  static const Color darkSurfaceVariant = Color(0xFF1F2937);
  static const Color darkCard = Color(0xFF1C2333);

  // Light theme backgrounds
  static const Color lightBackground = Color(0xFFF7F8FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFF0F1F4);
  static const Color lightCard = Color(0xFFFFFFFF);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF1B4DFF), Color(0xFF00BFA6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFFFB300), Color(0xFFFF8F00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF161B22), Color(0xFF0D1117)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
