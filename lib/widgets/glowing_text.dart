import 'package:flutter/material.dart';

/// A label with a soft, slowly breathing glow — used for the active
/// mantra name under the jewel.
class GlowingText extends StatefulWidget {
  const GlowingText({super.key, required this.text, required this.color});

  final String text;
  final Color color;

  @override
  State<GlowingText> createState() => _GlowingTextState();
}

class _GlowingTextState extends State<GlowingText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final glow = 0.35 + _controller.value * 0.4;
        return Text(
          widget.text,
          textAlign: TextAlign.center,
          style: theme.textTheme.titleLarge?.copyWith(
            shadows: [
              Shadow(
                color: widget.color.withValues(alpha: glow),
                blurRadius: 16,
              ),
              Shadow(
                color: widget.color.withValues(alpha: glow * 0.6),
                blurRadius: 4,
              ),
            ],
          ),
        );
      },
    );
  }
}
