import 'package:flutter/material.dart';

/// User-configurable settings, persisted via StorageService.
///
/// Language is intentionally not stored here: easy_localization already
/// persists and restores the chosen locale on its own, so duplicating it
/// would create two sources of truth.
class AppSettings {
  const AppSettings({
    required this.notificationHour,
    required this.notificationMinute,
    required this.durationMinutes,
    required this.themeMode,
    required this.selectedMantraId,
    required this.randomDailyMantra,
    required this.hasSeenOnboarding,
  });

  factory AppSettings.defaults() => const AppSettings(
        notificationHour: 8,
        notificationMinute: 0,
        durationMinutes: 3,
        themeMode: ThemeMode.dark,
        selectedMantraId: 'mantra_1',
        randomDailyMantra: false,
        hasSeenOnboarding: false,
      );

  final int notificationHour;
  final int notificationMinute;
  final int durationMinutes;
  final ThemeMode themeMode;
  final String selectedMantraId;
  final bool randomDailyMantra;
  final bool hasSeenOnboarding;

  AppSettings copyWith({
    int? notificationHour,
    int? notificationMinute,
    int? durationMinutes,
    ThemeMode? themeMode,
    String? selectedMantraId,
    bool? randomDailyMantra,
    bool? hasSeenOnboarding,
  }) {
    return AppSettings(
      notificationHour: notificationHour ?? this.notificationHour,
      notificationMinute: notificationMinute ?? this.notificationMinute,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      themeMode: themeMode ?? this.themeMode,
      selectedMantraId: selectedMantraId ?? this.selectedMantraId,
      randomDailyMantra: randomDailyMantra ?? this.randomDailyMantra,
      hasSeenOnboarding: hasSeenOnboarding ?? this.hasSeenOnboarding,
    );
  }
}
