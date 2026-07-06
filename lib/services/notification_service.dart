import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static const _dailyNotificationId = 1;

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  /// Loads the timezone database, sets the device's local timezone, and
  /// initialises the plugin.
  ///
  /// Timezone detection is wrapped in its own try/catch so that a failure
  /// (e.g. MissingPluginException on old builds) falls back to UTC instead
  /// of aborting the entire initialisation.
  Future<void> init() async {
    // Load full IANA timezone database
    tz_data.initializeTimeZones();

    // Detect device timezone — CRITICAL: without this tz.local = UTC and
    // every scheduled notification fires at the wrong local time.
    try {
      final localTz = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(localTz));
      debugPrint('[Notif] timezone set to $localTz');
    } catch (e) {
      debugPrint('[Notif] timezone detection failed ($e) — using UTC fallback');
    }

    // Wire up the notifications plugin
    await _plugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
    );
    debugPrint('[Notif] plugin initialised');
  }

  /// Requests runtime permissions for notifications.
  ///
  /// • POST_NOTIFICATIONS  (Android 13+): shows system dialog via
  ///   permission_handler — the most reliable path for this permission.
  /// • SCHEDULE_EXACT_ALARM (Android 12+): opens "Alarms & Reminders" in
  ///   system Settings if the permission is not already granted.
  /// • iOS: standard alert / badge / sound prompt.
  Future<void> requestPermissions() async {
    // POST_NOTIFICATIONS via permission_handler (reliable on all Android 13+ devices)
    final notifStatus = await Permission.notification.request();
    debugPrint('[Notif] POST_NOTIFICATIONS → $notifStatus');

    // SCHEDULE_EXACT_ALARM via the plugin (opens system settings if denied)
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      final canExact = await android.canScheduleExactNotifications();
      debugPrint('[Notif] canScheduleExactNotifications → $canExact');
      if (canExact == false) {
        await android.requestExactAlarmsPermission();
      }
    }

    // iOS
    await _plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  /// Cancels any existing daily reminder and schedules a new one at
  /// [hour]:[minute] in the device's local timezone, repeating every day.
  Future<void> scheduleDaily({
    required int hour,
    required int minute,
    required String title,
    required String body,
  }) async {
    await _plugin.cancel(_dailyNotificationId);

    final scheduledDate = _nextInstanceOf(hour, minute);
    debugPrint('[Notif] scheduling for $hour:$minute → ${scheduledDate.toIso8601String()}');

    await _plugin.zonedSchedule(
      _dailyNotificationId,
      title,
      body,
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_mantra_channel',
          'Recordatorio diario',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      matchDateTimeComponents: DateTimeComponents.time,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
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
