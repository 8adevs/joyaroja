import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/settings_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/jewel_widget.dart';
import 'home_screen.dart';

class _OnboardingStep {
  const _OnboardingStep({required this.titleKey, required this.bodyKey});
  final String titleKey;
  final String bodyKey;
}

const _steps = [
  _OnboardingStep(
    titleKey: 'onboarding.step1_title',
    bodyKey: 'onboarding.step1_body',
  ),
  _OnboardingStep(
    titleKey: 'onboarding.step2_title',
    bodyKey: 'onboarding.step2_body',
  ),
  _OnboardingStep(
    titleKey: 'onboarding.step3_title',
    bodyKey: 'onboarding.step3_body',
  ),
  _OnboardingStep(
    titleKey: 'onboarding.step4_title',
    bodyKey: 'onboarding.step4_body',
  ),
];

/// Shown the first time the app is opened (and on demand from
/// Settings) to explain the 4-step flow as a swipeable carousel.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key, this.markAsSeenOnFinish = true});

  /// When replaying from Settings, finishing the carousel shouldn't
  /// need to touch the persisted flag — it's already true.
  final bool markAsSeenOnFinish;

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    if (widget.markAsSeenOnFinish) {
      await ref.read(settingsProvider.notifier).setHasSeenOnboarding(true);
    }
    if (!mounted) return;
    if (widget.markAsSeenOnFinish) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  void _next() {
    if (_page == _steps.length - 1) {
      _finish();
      return;
    }
    _controller.nextPage(
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLast = _page == _steps.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'onboarding.welcome_title'.tr(),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge,
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _steps.length,
                onPageChanged: (index) => setState(() => _page = index),
                itemBuilder: (context, index) {
                  final step = _steps[index];
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: Padding(
                      key: ValueKey(index),
                      padding: const EdgeInsets.symmetric(horizontal: 36),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          JewelWidget(isActive: index == 3),
                          const SizedBox(height: 40),
                          Text(
                            step.titleKey.tr(),
                            style: theme.textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            step.bodyKey.tr(),
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_steps.length, (index) {
                final active = index == _page;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: active ? 22 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: active
                        ? AppColors.jewelCore
                        : theme.colorScheme.onSurface.withValues(alpha: 0.2),
                  ),
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 24, 32, 32),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _next,
                  child: Text(
                    isLast
                        ? 'onboarding.start_button'.tr()
                        : 'onboarding.next_button'.tr(),
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
