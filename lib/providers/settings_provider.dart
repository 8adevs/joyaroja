import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_settings.dart';
import '../services/notification_service.dart';
import '../services/storage_service.dart';

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  return SettingsNotifier(
    storageService: ref.watch(storageServiceProvider),
    notificationService: ref.watch(notificationServiceProvider),
  );
});

class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier({
    required StorageService storageService,
    required NotificationService notificationService,
  })  : _storageService = storageService,
        _notificationService = notificationService,
        super(AppSettings.defaults()) {
    _loaded = _loadInitial();
  }

  final StorageService _storageService;
  final NotificationService _notificationService;

  /// Completes once settings have been read from SharedPreferences.
  /// Await this in SplashScreen before reading hasSeenOnboarding.
  late final Future<void> _loaded;
  Future<void> get loaded => _loaded;

  Future<void> _loadInitial() async {
    state = await _storageService.load();
  }

  Future<void> _persist(AppSettings next) async {
    state = next;
    await _storageService.save(next);
  }

  Future<void> setNotificationTime({
    required int hour,
    required int minute,
    required String notificationTitle,
    required String Function(String mantraId) notificationBodyBuilder,
  }) async {
    await _persist(
      state.copyWith(notificationHour: hour, notificationMinute: minute),
    );
    await _notificationService.scheduleDaily(
      hour: hour,
      minute: minute,
      title: notificationTitle,
      body: notificationBodyBuilder(state.selectedMantraId),
    );
  }

  Future<void> setDurationMinutes(int minutes) =>
      _persist(state.copyWith(durationMinutes: minutes));

  Future<void> setThemeMode(ThemeMode mode) =>
      _persist(state.copyWith(themeMode: mode));

  Future<void> setSelectedMantra(String mantraId) =>
      _persist(state.copyWith(selectedMantraId: mantraId));

  Future<void> setRandomDailyMantra(bool enabled) =>
      _persist(state.copyWith(randomDailyMantra: enabled));

  Future<void> setHasSeenOnboarding(bool seen) =>
      _persist(state.copyWith(hasSeenOnboarding: seen));
}
