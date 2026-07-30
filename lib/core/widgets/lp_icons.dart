/// Playful hand-painted brand icons: solid fills with bold black outlines.
/// Used by the stats bar, the bottom nav and placeholder screens.
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/lp_colors.dart';

Paint _fill(Color color) => Paint()..color = color;

Paint _stroke(double width, [Color color = LpColors.ink]) => Paint()
  ..color = color
  ..style = PaintingStyle.stroke
  ..strokeWidth = width
  ..strokeJoin = StrokeJoin.round
  ..strokeCap = StrokeCap.round;

/// Four-pointed sparkle ✦ — XP currency.
class SparkleIcon extends StatelessWidget {
  const SparkleIcon({
    super.key,
    this.size = 24,
    this.color = LpColors.brandYellow,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size.square(size), painter: _SparklePainter(color));
}

class _SparklePainter extends CustomPainter {
  const _SparklePainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final path = Path()
      ..moveTo(w * 0.50, h * 0.02)
      ..quadraticBezierTo(w * 0.56, h * 0.38, w * 0.62, h * 0.42)
      ..quadraticBezierTo(w * 0.70, h * 0.46, w * 0.98, h * 0.50)
      ..quadraticBezierTo(w * 0.62, h * 0.56, w * 0.60, h * 0.60)
      ..quadraticBezierTo(w * 0.55, h * 0.68, w * 0.50, h * 0.98)
      ..quadraticBezierTo(w * 0.44, h * 0.62, w * 0.38, h * 0.58)
      ..quadraticBezierTo(w * 0.30, h * 0.54, w * 0.02, h * 0.50)
      ..quadraticBezierTo(w * 0.38, h * 0.44, w * 0.40, h * 0.40)
      ..quadraticBezierTo(w * 0.45, h * 0.32, w * 0.50, h * 0.02)
      ..close();
    canvas.drawPath(path, _fill(color));
    canvas.drawPath(path, _stroke(math.max(1.6, w * 0.075)));
  }

  @override
  bool shouldRepaint(_SparklePainter oldDelegate) => oldDelegate.color != color;
}

/// Lightning bolt ⚡ — energy.
class BoltIcon extends StatelessWidget {
  const BoltIcon({
    super.key,
    this.size = 24,
    this.color = LpColors.brandYellow,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size.square(size), painter: _BoltPainter(color));
}

class _BoltPainter extends CustomPainter {
  const _BoltPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final path = Path()
      ..moveTo(w * 0.58, h * 0.04)
      ..lineTo(w * 0.22, h * 0.58)
      ..lineTo(w * 0.46, h * 0.58)
      ..lineTo(w * 0.40, h * 0.96)
      ..lineTo(w * 0.78, h * 0.42)
      ..lineTo(w * 0.53, h * 0.42)
      ..close();
    canvas.drawPath(path, _fill(color));
    canvas.drawPath(path, _stroke(math.max(1.6, w * 0.075)));
  }

  @override
  bool shouldRepaint(_BoltPainter oldDelegate) => oldDelegate.color != color;
}

/// Red heart with black outline — lives.
class HeartIcon extends StatelessWidget {
  const HeartIcon({super.key, this.size = 24, this.color = LpColors.brickRed});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size.square(size), painter: _HeartPainter(color));
}

class _HeartPainter extends CustomPainter {
  const _HeartPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final path = Path()
      ..moveTo(w * 0.50, h * 0.88)
      ..cubicTo(w * 0.08, h * 0.60, w * 0.02, h * 0.30, w * 0.26, h * 0.15)
      ..cubicTo(w * 0.40, h * 0.07, w * 0.50, h * 0.20, w * 0.50, h * 0.28)
      ..cubicTo(w * 0.50, h * 0.20, w * 0.60, h * 0.07, w * 0.74, h * 0.15)
      ..cubicTo(w * 0.98, h * 0.30, w * 0.92, h * 0.60, w * 0.50, h * 0.88)
      ..close();
    canvas.drawPath(path, _fill(color));
    canvas.drawPath(path, _stroke(math.max(1.6, w * 0.075)));
    // Tiny highlight for the toy look.
    canvas.drawCircle(
      Offset(w * 0.32, h * 0.30),
      w * 0.07,
      _fill(LpColors.bgWhite.withValues(alpha: 0.75)),
    );
  }

  @override
  bool shouldRepaint(_HeartPainter oldDelegate) => oldDelegate.color != color;
}

/// Green settings gear.
class GearIcon extends StatelessWidget {
  const GearIcon({super.key, this.size = 26, this.color = LpColors.legoGreen});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size.square(size), painter: _GearPainter(color));
}

class _GearPainter extends CustomPainter {
  const _GearPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final r = size.width / 2;
    final strokeW = math.max(1.6, size.width * 0.07);
    final toothW = r * 0.52;
    // 8 rounded teeth radiating from the middle.
    for (var i = 0; i < 8; i++) {
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(i * math.pi / 4);
      final tooth = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(0, -r * 0.62),
          width: toothW,
          height: r * 0.75,
        ),
        Radius.circular(r * 0.16),
      );
      canvas.drawRRect(tooth, _fill(color));
      canvas.drawRRect(tooth, _stroke(strokeW));
      canvas.restore();
    }
    // Gear body over the teeth roots.
    canvas.drawCircle(center, r * 0.62, _fill(color));
    canvas.drawCircle(center, r * 0.62, _stroke(strokeW));
    // Hole.
    canvas.drawCircle(center, r * 0.24, _fill(LpColors.bgWhite));
    canvas.drawCircle(center, r * 0.24, _stroke(strokeW));
  }

  @override
  bool shouldRepaint(_GearPainter oldDelegate) => oldDelegate.color != color;
}

/// White house with a green door — Home tab.
class HouseIcon extends StatelessWidget {
  const HouseIcon({super.key, this.size = 30});

  final double size;

  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size.square(size), painter: const _HousePainter());
}

class _HousePainter extends CustomPainter {
  const _HousePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final strokeW = math.max(1.6, w * 0.07);
    final body = RRect.fromRectAndRadius(
      Rect.fromLTRB(w * 0.18, h * 0.42, w * 0.82, h * 0.90),
      Radius.circular(w * 0.05),
    );
    canvas.drawRRect(body, _fill(LpColors.bgWhite));
    canvas.drawRRect(body, _stroke(strokeW));
    final roof = Path()
      ..moveTo(w * 0.08, h * 0.46)
      ..lineTo(w * 0.50, h * 0.08)
      ..lineTo(w * 0.92, h * 0.46)
      ..close();
    canvas.drawPath(roof, _fill(LpColors.bgWhite));
    canvas.drawPath(roof, _stroke(strokeW));
    final door = RRect.fromRectAndCorners(
      Rect.fromLTRB(w * 0.40, h * 0.58, w * 0.60, h * 0.90),
      topLeft: Radius.circular(w * 0.10),
      topRight: Radius.circular(w * 0.10),
    );
    canvas.drawRRect(door, _fill(LpColors.legoGreen));
    canvas.drawRRect(door, _stroke(strokeW * 0.85));
  }

  @override
  bool shouldRepaint(_HousePainter oldDelegate) => false;
}

/// Royal-blue crown — Leaderboard tab.
class CrownIcon extends StatelessWidget {
  const CrownIcon({super.key, this.size = 30, this.color = LpColors.royalBlue});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size.square(size), painter: _CrownPainter(color));
}

class _CrownPainter extends CustomPainter {
  const _CrownPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final strokeW = math.max(1.6, w * 0.07);
    final body = Path()
      ..moveTo(w * 0.12, h * 0.82)
      ..lineTo(w * 0.10, h * 0.34)
      ..lineTo(w * 0.32, h * 0.52)
      ..lineTo(w * 0.50, h * 0.18)
      ..lineTo(w * 0.68, h * 0.52)
      ..lineTo(w * 0.90, h * 0.34)
      ..lineTo(w * 0.88, h * 0.82)
      ..close();
    canvas.drawPath(body, _fill(color));
    canvas.drawPath(body, _stroke(strokeW));
    // Jewels on the three tips.
    final jewel = _fill(LpColors.brandYellow);
    for (final c in <Offset>[
      Offset(w * 0.10, h * 0.30),
      Offset(w * 0.50, h * 0.14),
      Offset(w * 0.90, h * 0.30),
    ]) {
      canvas.drawCircle(c, w * 0.075, jewel);
      canvas.drawCircle(c, w * 0.075, _stroke(strokeW * 0.7));
    }
  }

  @override
  bool shouldRepaint(_CrownPainter oldDelegate) => oldDelegate.color != color;
}

/// Green smiley — Profile tab.
class SmileyIcon extends StatelessWidget {
  const SmileyIcon({
    super.key,
    this.size = 30,
    this.color = LpColors.legoGreen,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size.square(size), painter: _SmileyPainter(color));
}

class _SmileyPainter extends CustomPainter {
  const _SmileyPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final center = size.center(Offset.zero);
    final strokeW = math.max(1.6, w * 0.07);
    canvas.drawCircle(center, w * 0.44, _fill(color));
    canvas.drawCircle(center, w * 0.44, _stroke(strokeW));
    // Eyes.
    final eye = _fill(LpColors.ink);
    canvas.drawCircle(Offset(w * 0.36, w * 0.40), w * 0.055, eye);
    canvas.drawCircle(Offset(w * 0.64, w * 0.40), w * 0.055, eye);
    // Smile.
    canvas.drawArc(
      Rect.fromCircle(center: Offset(w * 0.50, w * 0.52), radius: w * 0.20),
      math.pi * 0.15,
      math.pi * 0.7,
      false,
      _stroke(strokeW * 0.9),
    );
  }

  @override
  bool shouldRepaint(_SmileyPainter oldDelegate) => oldDelegate.color != color;
}
