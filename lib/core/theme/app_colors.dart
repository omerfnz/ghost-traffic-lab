import 'package:flutter/material.dart';

abstract final class AppColors {
  // Primary Palette (Dark Mode)
  static const surface = Color(0xFF0D1117);
  static const surfaceVariant = Color(0xFF161B22);
  static const card = Color(0xFF1C2333);
  static const border = Color(0xFF30363D);

  // Accent
  static const primary = Color(0xFF58A6FF);
  static const primaryDim = Color(0xFF1F6FEB);

  // Status Colors
  static const armed = Color(0xFFF0883E);
  static const disarmed = Color(0xFF8B949E);
  static const running = Color(0xFF3FB950);
  static const error = Color(0xFFF85149);

  // Text
  static const textPrimary = Color(0xFFE6EDF3);
  static const textSecondary = Color(0xFF8B949E);
  static const textMuted = Color(0xFF6E7681);
}
