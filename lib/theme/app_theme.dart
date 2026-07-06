import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Builds the dark ("midnight") and light ("ivory/luxury") themes.
/// Both share the same crimson jewel, the same Playfair/Inter type
/// pair, and the same restrained, minimal shapes — only the surface
/// and accent colors change.
class AppTheme {
  AppTheme._();

  static ThemeData get dark => _build(
        brightness: Brightness.dark,
        background: AppColors.midnightBackground,
        surface: AppColors.midnightSurface,
        accent: AppColors.goldAccentOnDark,
        onBackground: Colors.white,
      );

  static ThemeData get light => _build(
        brightness: Brightness.light,
        background: AppColors.ivoryBackground,
        surface: AppColors.ivorySurface,
        accent: AppColors.goldAccentOnLight,
        onBackground: const Color(0xFF1A1A1A),
      );

  static ThemeData _build({
    required Brightness brightness,
    required Color background,
    required Color surface,
    required Color accent,
    required Color onBackground,
  }) {
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: accent,
      onPrimary: brightness == Brightness.dark ? Colors.black : Colors.white,
      secondary: AppColors.jewelCore,
      onSecondary: Colors.white,
      error: const Color(0xFFCF6679),
      onError: Colors.white,
      surface: surface,
      onSurface: onBackground,
    );

    final textTheme = TextTheme(
      headlineMedium: GoogleFonts.playfairDisplay(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: onBackground,
      ),
      titleLarge: GoogleFonts.playfairDisplay(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: onBackground,
      ),
      bodyLarge: GoogleFonts.inter(fontSize: 16, color: onBackground),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        color: onBackground.withValues(alpha: 0.75),
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: onBackground,
      ),
    );

    return ThemeData(
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      textTheme: textTheme,
      iconTheme: IconThemeData(color: onBackground.withValues(alpha: 0.6)),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: accent.withValues(alpha: 0.15)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.jewelDeep,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
            side: BorderSide(color: accent, width: 1.4),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
          textStyle: textTheme.labelLarge?.copyWith(color: Colors.white),
          elevation: 0,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? accent
              : onBackground.withValues(alpha: 0.4),
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? accent.withValues(alpha: 0.4)
              : onBackground.withValues(alpha: 0.15),
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: accent,
        inactiveTrackColor: accent.withValues(alpha: 0.2),
        thumbColor: accent,
      ),
      useMaterial3: true,
    );
  }
}
