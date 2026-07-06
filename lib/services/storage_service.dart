import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_settings.dart';

/// Wraps shared_preferences with individual keys (rather than one JSON
/// blob) so future settings can be added/migrated independently.
class StorageService {
  static const _keyNotificationHour = 'notification_hour';
  static const _keyNotificationMinute = 'notification_minute';
  static const _keyDurationMinutes = 'duration_minutes';
  static const _keyThemeMode = 'theme_mode';
  static const _keySelectedMantraId = 'selected_mantra_id';
  static const _keyRandomDailyMantra = 'random_daily_mantra';
  static const _keyHasSeenOnboarding = 'has_seen_onboarding';

  Future<AppSettings> load() async {
    final prefs = await SharedPreferences.getInstance();
    final defaults = AppSettings.defaults();
    return AppSettings(
      notificationHour:
          prefs.getInt(_keyNotificationHour) ?? defaults.notificationHour,
      notificationMinute:
          prefs.getInt(_keyNotificationMinute) ?? defaults.notificationMinute,
      durationMinutes:
          prefs.getInt(_keyDurationMinutes) ?? defaults.durationMinutes,
      themeMode: _themeModeFromString(prefs.getString(_keyThemeMode)) ??
          defaults.themeMode,
      selectedMantraId:
          prefs.getString(_keySelectedMantraId) ?? defaults.selectedMantraId,
      randomDailyMantra: prefs.getBool(_keyRandomDailyMantra) ??
          defaults.randomDailyMantra,
      hasSeenOnboarding: prefs.getBool(_keyHasSeenOnboarding) ??
          defaults.hasSeenOnboarding,
    );
  }

  Future<void> save(AppSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.setInt(_keyNotificationHour, settings.notificationHour),
      prefs.setInt(_keyNotificationMinute, settings.notificationMinute),
      prefs.setInt(_keyDurationMinutes, settings.durationMinutes),
      prefs.setString(_keyThemeMode, settings.themeMode.name),
      prefs.setString(_keySelectedMantraId, settings.selectedMantraId),
      prefs.setBool(_keyRandomDailyMantra, settings.randomDailyMantra),
      prefs.setBool(_keyHasSeenOnboarding, settings.hasSeenOnboarding),
    ]);
  }

  ThemeMode? _themeModeFromString(String? value) {
    if (value == null) return null;
    return ThemeMode.values.where((m) => m.name == value).firstOrNull;
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
