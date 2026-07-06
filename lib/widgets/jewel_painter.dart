import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Draws a faceted, pear-cut gem: a pointed crown over a rounded base,
/// split into angular facets so light reads as a sparkle rather than a
/// flat gradient. [glow] (0..1) drives how saturated/bright the facets
/// and the surrounding halo are.
class JewelPainter extends CustomPainter {
  const JewelPainter({required this.glow});

  final double glow;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final w = size.width;
    final h = size.height;

    final gemPath = Path()
      ..moveTo(center.dx, 0)
      ..lineTo(w * 0.78, h * 0.32)
      ..lineTo(w * 0.66, h * 0.5)
      ..lineTo(w * 0.82, h * 0.62)
      ..lineTo(w * 0.62, h * 0.95)
      ..quadraticBezierTo(center.dx, h * 1.04, w * 0.38, h * 0.95)
      ..lineTo(w * 0.18, h * 0.62)
      ..lineTo(w * 0.34, h * 0.5)
      ..lineTo(w * 0.22, h * 0.32)
      ..close();

    final basePaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Color.lerp(AppColors.jewelHighlight, Colors.white, glow * 0.3)!,
          AppColors.jewelCore,
          AppColors.jewelDeep,
        ],
        stops: const [0.0, 0.5, 1.0],
        center: const Alignment(-0.2, -0.6),
        radius: 1.1,
      ).createShader(Rect.fromCircle(center: center, radius: w * 0.7));
    canvas.drawPath(gemPath, basePaint);

    void facet(List<Offset> points, Color color, double opacity) {
      final path = Path()..addPolygon(points, true);
      canvas.drawPath(
        path,
        Paint()..color = color.withValues(alpha: opacity),
      );
    }

    final highlightOpacity = 0.25 + glow * 0.35;
    facet(
      [
        Offset(center.dx, 0),
        Offset(w * 0.78, h * 0.32),
        Offset(w * 0.5, h * 0.4),
        Offset(w * 0.22, h * 0.32),
      ],
      AppColors.jewelHighlight,
      highlightOpacity,
    );
    facet(
      [
        Offset(w * 0.5, h * 0.4),
        Offset(w * 0.66, h * 0.5),
        Offset(w * 0.5, h * 0.62),
        Offset(w * 0.34, h * 0.5),
      ],
      Colors.white,
      0.12 + glow * 0.18,
    );
    facet(
      [
        Offset(w * 0.5, h * 0.62),
        Offset(w * 0.82, h * 0.62),
        Offset(w * 0.62, h * 0.95),
      ],
      AppColors.jewelDeep,
      0.25,
    );

    canvas.drawPath(
      gemPath,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..color = AppColors.jewelHighlight.withValues(alpha: 0.4 + glow * 0.3),
    );

    final sparkleOpacity = (glow - 0.5).clamp(0.0, 1.0) * 0.9;
    if (sparkleOpacity > 0) {
      final sparklePaint = Paint()
        ..color = Colors.white.withValues(alpha: sparkleOpacity);
      canvas.drawCircle(Offset(w * 0.36, h * 0.3), w * 0.025, sparklePaint);
      canvas.drawCircle(Offset(w * 0.6, h * 0.5), w * 0.018, sparklePaint);
    }
  }

  @override
  bool shouldRepaint(covariant JewelPainter oldDelegate) =>
      oldDelegate.glow != glow;
}
