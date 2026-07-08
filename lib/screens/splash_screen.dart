import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/settings_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/jewel_widget.dart';
import 'home_screen.dart';
import 'onboarding_screen.dart';

/// First screen shown on every cold start.
///
/// While the splash is visible it runs two tasks in parallel:
///   1. Initialises the notification service (timezone DB + plugin).
///   2. Waits for SharedPreferences settings to be read.
/// Both must finish AND a minimum display time must elapse before navigation.
///
/// Showing initialisation here (after the first frame) instead of before
/// runApp() prevents the main-thread block that was causing Android ANR.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  static const _minDisplayMs = 2400;

  late final AnimationController _progress;
  late final CurvedAnimation _curved;

  @override
  void initState() {
    super.initState();
    _progress = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: _minDisplayMs),
    );
    _curved = CurvedAnimation(parent: _progress, curve: Curves.easeInOut);
    _progress.forward();
    _startup();
  }

  Future<void> _startup() async {
    await Future.wait([
      _initNotifications(),
      ref.read(settingsProvider.notifier).loaded,
      Future.delayed(const Duration(milliseconds: _minDisplayMs)),
    ]);
    if (!mounted) return;
    _navigate();
  }

  Future<void> _initNotifications() async {
    final svc = ref.read(notificationServiceProvider);

    // Step 1: timezone + plugin — errors degrade gracefully (UTC fallback)
    // but we still proceed to permission request regardless of outcome.
    try {
      await svc.init();
    } catch (e) {
      debugPrint('[Splash] notification init error: $e');
    }

    try {
      await svc.requestPermissions();
    } catch (e) {
      debugPrint('[Splash] permission request error: $e');
    }
  }

  void _navigate() {
    final settings = ref.read(settingsProvider);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => settings.hasSeenOnboarding
            ? const HomeScreen()
            : const OnboardingScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _curved.dispose();
    _progress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.midnightBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Glowing jewel — active state shows glow + pulsating bloom
            const JewelWidget(isActive: true),

            const SizedBox(height: 32),

            Text(
              'app_name'.tr(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),

            const SizedBox(height: 64),

            // Loading progress bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64),
              child: AnimatedBuilder(
                animation: _curved,
                builder: (context, _) => LinearProgressIndicator(
                  value: _curved.value,
                  minHeight: 3,
                  borderRadius: BorderRadius.circular(4),
                  backgroundColor: Colors.white10,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.jewelCore,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
