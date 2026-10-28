import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static const _dailyNotificationId = 1;
  static const _migrationChannel =
      MethodChannel('com.joyaroja/migration');

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz_data.initializeTimeZones();

    try {
      final localTz = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(localTz));
      debugPrint('[Notif] timezone set to $localTz');
    } catch (e) {
      debugPrint('[Notif] timezone detection failed ($e) — using UTC fallback');
    }

    await _plugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('ic_launcher_foreground'),
        iOS: DarwinInitializationSettings(),
      ),
    );
    debugPrint('[Notif] plugin initialised');

    await _migrateNotificationCache();
  }

  // Clears stale notification data written by a pre-v18 plugin version.
  // RuntimeTypeAdapterFactory (added in v18) requires a "type" field in every
  // serialised StyleInformation; older data lacks it, so every call to
  // cancel() or zonedSchedule() throws "Missing type parameter". Writing "[]"
  // directly is the only way to reset the named SharedPreferences instance
  // used internally by the plugin without a full app uninstall.
  Future<void> _migrateNotificationCache() async {
    const key = 'notif_cache_cleared_v18';
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(key) == true) return;
    try {
      await _migrationChannel.invokeMethod<void>('clearNotificationCache');
      await prefs.setBool(key, true);
      debugPrint('[Notif] migration: cleared stale notification cache');
    } catch (e) {
      debugPrint('[Notif] migration error (will retry next launch): $e');
    }
  }

  Future<void> requestPermissions() async {
    final notifStatus = await Permission.notification.request();
    debugPrint('[Notif] POST_NOTIFICATIONS → $notifStatus');

    await _plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  Future<void> scheduleDaily({
    required int hour,
    required int minute,
    required String title,
    required String body,
  }) async {
    // cancel() can throw "Missing type parameter" when notification data on
    // device was stored by an older plugin version. Swallow the error: the
    // new zonedSchedule implicitly replaces the alarm via the same ID.
    try {
      await _plugin.cancel(_dailyNotificationId);
    } catch (e) {
      debugPrint('[Notif] cancel error (stale data): $e');
    }

    final scheduledDate = _nextInstanceOf(hour, minute);
    debugPrint('[Notif] scheduling $hour:$minute → ${scheduledDate.toIso8601String()}');

    try {
      await _plugin.zonedSchedule(
        _dailyNotificationId,
        title,
        body,
        scheduledDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_mantra_channel', 'Recordatorio diario',
            importance: Importance.high, priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        matchDateTimeComponents: DateTimeComponents.time,
        // Inexact on purpose: Play restricts exact alarms to alarm/calendar
        // apps, and a daily mantra reminder tolerates a few minutes of drift.
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
      debugPrint('[Notif] scheduled successfully');
    } on PlatformException catch (e) {
      final msg = e.message ?? '';
      // RuntimeException wrapped by Flutter channel (code='error') when
      // loadScheduledNotifications() fails on stale v<18 SharedPreferences data.
      // setupAlarm() already ran before the cache step, so the alarm IS set in
      // AlarmManager — the notification will fire. Only boot-recovery is affected.
      if (e.code == 'error' &&
          (msg.contains('type parameter') || msg.contains('cannot deserialize'))) {
        debugPrint('[Notif] cache save failed — alarm was set: $msg');
        return;
      }
      debugPrint('[Notif] zonedSchedule FAILED: $e');
      rethrow;
    }
  }

  tz.TZDateTime _nextInstanceOf(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}
