import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/mantra_provider.dart';
import '../providers/mantra_session_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/glowing_text.dart';
import '../widgets/jewel_widget.dart';
import '../widgets/primary_action_button.dart';
import 'mantras_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(mantraSessionProvider);
    final sessionNotifier = ref.read(mantraSessionProvider.notifier);
    final activeMantra = ref.watch(activeMantraProvider);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // ── Main content ──────────────────────────────────────────────
            Column(
              children: [
                // Jewel + mantra name: vertically centered in the remaining
                // space above the button.
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        JewelWidget(isActive: session.isRunning),
                        const SizedBox(height: 24),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: GlowingText(
                            text: activeMantra.titleKey!.tr(),
                            color: AppColors.jewelCore,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Button pinned to the bottom with generous breathing room
                Padding(
                  padding: const EdgeInsets.only(bottom: 52),
                  child: PrimaryActionButton(
                    isRunning: session.isRunning,
                    onPressed: () => session.isRunning
                        ? sessionNotifier.stop()
                        : sessionNotifier.start(),
                  ),
                ),
              ],
            ),

            // ── Corner icon buttons ───────────────────────────────────────
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: const Icon(Icons.settings_outlined, size: 22),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                ),
              ),
            ),
            Positioned(
              top: 8,
              left: 8,
              child: IconButton(
                icon: const Icon(Icons.menu_book_outlined, size: 22),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const MantrasScreen()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
