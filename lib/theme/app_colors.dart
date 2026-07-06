import 'package:flutter/material.dart';

/// Shared color constants for both themes. The jewel keeps the same
/// crimson gradient in both modes — only the surrounding palette
/// shifts between "midnight" (dark) and "ivory" (light, pure/luxury).
class AppColors {
  AppColors._();

  static const jewelCore = Color(0xFFFF3B57);
  static const jewelDeep = Color(0xFF7A0C1F);
  static const jewelHighlight = Color(0xFFFFE3C2);

  static const goldAccentOnDark = Color(0xFFD4AF37);
  static const goldAccentOnLight = Color(0xFF9C7A29);

  static const midnightBackground = Color(0xFF0E0E10);
  static const midnightSurface = Color(0xFF18181B);

  static const ivoryBackground = Color(0xFFFAF7F2);
  static const ivorySurface = Color(0xFFFFFFFF);
}
