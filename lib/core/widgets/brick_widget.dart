import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/lp_colors.dart';

/// A flat stylized LEGO brick: rounded body, grid of studs with a light
/// highlight, darker bottom edge for depth.
///
/// [columns] × [rows] is the stud grid (e.g. 4 × 2 for a "2x4" brick,
/// 4 × 1 for a "1x4"). Each stud cell is [unit] logical pixels.
class BrickWidget extends StatelessWidget {
  const BrickWidget({
    super.key,
    required this.color,
    this.columns = 2,
    this.rows = 2,
    this.unit = 22,
    this.outlined = true,
  });

  final Color color;
  final int columns;
  final int rows;
  final double unit;

  /// Draws the 2 px black toy outline (tray bricks). The plan-loading
  /// bouncing brick turns this off for the softer prototype look.
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(columns * unit, rows * unit),
      painter: BrickPainter(
        color: color,
        columns: columns,
        rows: rows,
        outlined: outlined,
      ),
    );
  }
}

/// Paints the brick body, bottom edge and studs. Reused by the build/trace
/// exercise canvases which paint bricks directly on a baseplate.
class BrickPainter extends CustomPainter {
  const BrickPainter({
    required this.color,
    this.columns = 2,
    this.rows = 2,
    this.outlined = true,
  });

  final Color color;
  final int columns;
  final int rows;
  final bool outlined;

  @override
  void paint(Canvas canvas, Size size) {
    paintBrick(
      canvas,
      Offset.zero & size,
      color: color,
      columns: columns,
      rows: rows,
      outlined: outlined,
    );
  }

  /// Static so exercise canvases can stamp bricks anywhere on a canvas.
  static void paintBrick(
    Canvas canvas,
    Rect rect, {
    required Color color,
    required int columns,
    required int rows,
    bool outlined = true,
  }) {
    final body = RRect.fromRectAndRadius(rect, const Radius.circular(4));
    canvas.drawRRect(body, Paint()..color = color);

    // Darker bottom edge for depth.
    final edgeHeight = math.min(rect.height * 0.16, 7.0);
    canvas.save();
    canvas.clipRRect(body);
    canvas.drawRect(
      Rect.fromLTWH(
        rect.left,
        rect.bottom - edgeHeight,
        rect.width,
        edgeHeight,
      ),
      Paint()..color = LpColors.darken(color, 0.28),
    );
    canvas.restore();

    // Studs.
    final unitW = rect.width / columns;
    final unitH = rect.height / rows;
    final r = math.min(unitW, unitH) * 0.30;
    final studFill = Paint()..color = LpColors.lighten(color, 0.08);
    final studRing = Paint()
      ..color = LpColors.darken(color, 0.24)
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1.2, r * 0.18);
    final studHighlight = Paint()..color = LpColors.lighten(color, 0.35);
    for (var cy = 0; cy < rows; cy++) {
      for (var cx = 0; cx < columns; cx++) {
        final center = Offset(
          rect.left + (cx + 0.5) * unitW,
          rect.top + (cy + 0.5) * unitH,
        );
        canvas.drawCircle(center, r, studFill);
        canvas.drawCircle(center, r, studRing);
        canvas.drawCircle(
          center.translate(-r * 0.3, -r * 0.3),
          r * 0.28,
          studHighlight,
        );
      }
    }

    if (outlined) {
      canvas.drawRRect(
        body.deflate(1),
        Paint()
          ..color = LpColors.ink
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }
  }

  @override
  bool shouldRepaint(BrickPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.columns != columns ||
      oldDelegate.rows != rows ||
      oldDelegate.outlined != outlined;
}
