import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/mantra_provider.dart';
import '../providers/settings_provider.dart';
import 'onboarding_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _pickNotificationTime(
    BuildContext context,
    WidgetRef ref,
    int currentHour,
    int currentMinute,
  ) async {
    // dialOnly removes the keyboard-input toggle button, which prevents the
    // non-normalized BoxConstraints crash (minHeight > available height) that
    // Flutter's time-picker keyboard mode triggers when the soft keyboard
    // opens inside the already-constrained dialog.
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: currentHour, minute: currentMinute),
      initialEntryMode: TimePickerEntryMode.dialOnly,
    );
    if (picked == null) return;

    final repository = ref.read(mantraRepositoryProvider);
    try {
      await ref.read(settingsProvider.notifier).setNotificationTime(
            hour: picked.hour,
            minute: picked.minute,
            notificationTitle: 'notification.title'.tr(),
            notificationBodyBuilder: (mantraId) {
              final mantra = repository.byId(mantraId);
              return 'notification.body'.tr(args: [mantra.titleKey!.tr()]);
            },
          );
      if (!context.mounted) return;
      final timeLabel =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('settings.notification_scheduled'.tr(args: [timeLabel])),
        backgroundColor: Colors.green.shade700,
      ));
    } catch (e) {
      debugPrint('[Settings] notification scheduling error: $e');
      if (!context.mounted) return;
      final errStr = e.toString();
      final isPermError = errStr.contains('exact_alarms_not_permitted');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(isPermError
            ? 'settings.notification_error_exact'.tr()
            : '🔴 $errStr'),
        backgroundColor: Colors.red.shade900,
        duration: const Duration(seconds: 15),
        action: isPermError
            ? SnackBarAction(
                label: 'settings.grant_permission'.tr(),
                textColor: Colors.white,
                onPressed: () =>
                    ref.read(notificationServiceProvider).requestPermissions(),
              )
            : null,
      ));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text('settings.title'.tr())),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text('settings.notification_time'.tr()),
            trailing: Text(
              TimeOfDay(
                hour: settings.notificationHour,
                minute: settings.notificationMinute,
              ).format(context),
              style: theme.textTheme.bodyLarge,
            ),
            onTap: () => _pickNotificationTime(
              context,
              ref,
              settings.notificationHour,
              settings.notificationMinute,
            ),
          ),
          const Divider(height: 32),
          Text('settings.duration_minutes'.tr(), style: theme.textTheme.bodyLarge),
          Slider(
            min: 1,
            max: 10,
            divisions: 9,
            value: settings.durationMinutes.toDouble(),
            label: 'settings.duration_minutes_value'
                .tr(args: ['${settings.durationMinutes}']),
            onChanged: (value) => notifier.setDurationMinutes(value.round()),
          ),
          const Divider(height: 32),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text('settings.theme'.tr()),
            subtitle: Text(
              settings.themeMode == ThemeMode.dark
                  ? 'settings.theme_dark'.tr()
                  : 'settings.theme_light'.tr(),
            ),
            value: settings.themeMode == ThemeMode.dark,
            onChanged: (isDark) =>
                notifier.setThemeMode(isDark ? ThemeMode.dark : ThemeMode.light),
          ),
          const Divider(height: 32),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text('settings.language'.tr()),
            trailing: DropdownButton<String>(
              value: context.locale.languageCode,
              underline: const SizedBox.shrink(),
              items: const [
                DropdownMenuItem(value: 'es', child: Text('Español')),
                DropdownMenuItem(value: 'en', child: Text('English')),
              ],
              onChanged: (code) {
                if (code == null) return;
                context.setLocale(Locale(code));
              },
            ),
          ),
          const Divider(height: 32),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text('settings.random_daily_mantra'.tr()),
            subtitle: Text('settings.random_daily_mantra_subtitle'.tr()),
            value: settings.randomDailyMantra,
            onChanged: notifier.setRandomDailyMantra,
          ),
          const Divider(height: 32),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text('settings.view_tutorial'.tr()),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) =>
                    const OnboardingScreen(markAsSeenOnFinish: false),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
