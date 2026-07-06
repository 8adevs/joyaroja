import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// The central gem with two PNG layers:
///   • jewel_base.png  — always visible at full opacity (the "off" state)
///   • jewel_glow.png  — fades IN when a session starts, fades OUT when done
///
/// A warm radial bloom and outer BoxShadow both follow the same
/// AnimationController, which:
///   — pulses (repeat reverse) while the session is active
///   — animates back to 0 when the session ends (clean fade-out)
///
/// Files required in assets/images/ before building:
///   jewel_base.png   (gem without inner glow, transparent background)
///   jewel_glow.png   (same gem with warm inner glow, transparent background)
class JewelWidget extends StatefulWidget {
  const JewelWidget({super.key, required this.isActive});

  final bool isActive;

  @override
  State<JewelWidget> createState() => _JewelWidgetState();
}

class _JewelWidgetState extends State<JewelWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bloom;

  @override
  void initState() {
    super.initState();
    _bloom = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4500),
    );
    if (widget.isActive) _bloom.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant JewelWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isActive == widget.isActive) return;
    if (widget.isActive) {
      _bloom.repeat(reverse: true);
    } else {
      _bloom.animateTo(
        0.0,
        duration: const Duration(milliseconds: 900),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _bloom.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const size = 220.0;

    return AnimatedBuilder(
      animation: _bloom,
      builder: (context, _) {
        final t = _bloom.value; // 0.0 at rest → oscillates 0..1 when active

        // All visual effects are driven solely by t:
        //   t = 0  → base image only, no glow, no shadow
        //   t > 0  → glow grows, bloom brightens, shadow expands
        final shadowAlpha = (t * 0.80 + 0.08).clamp(0.0, 1.0);
        final bloomAlpha  = (t * 0.38).clamp(0.0, 1.0);
        final blurRadius  = 24.0 + t * 56;
        final spreadRadius = t * 20;

        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: AppColors.jewelCore.withValues(alpha: shadowAlpha),
                blurRadius: blurRadius,
                spreadRadius: spreadRadius,
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Layer 1 — base gem, always fully opaque
              Image.asset(
                'assets/images/jewel_base.png',
                width: size,
                height: size,
                fit: BoxFit.contain,
              ),

              // Layer 2 — glow gem: smooth 700 ms crossfade on session start/end
              AnimatedOpacity(
                opacity: widget.isActive ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeInOut,
                child: Image.asset(
                  'assets/images/jewel_glow.png',
                  width: size,
                  height: size,
                  fit: BoxFit.contain,
                ),
              ),

              // Layer 3 — warm circular bloom, explicitly clipped to a circle
              // so it is always round regardless of the container's shape.
              // Size breathes slightly with t to reinforce the pulse feel.
              Container(
                width: size * (0.55 + t * 0.15),
                height: size * (0.55 + t * 0.15),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFFF5030).withValues(alpha: bloomAlpha),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 1.0],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
