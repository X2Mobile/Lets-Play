import 'package:flutter/material.dart';

import '../theme/lp_colors.dart';

/// White surface covered by a grid of faint gray stud outlines — the LEGO
/// baseplate behind the build-the-letter exercise.
class BaseplateBackground extends StatelessWidget {
  const BaseplateBackground({super.key, this.studSpacing = 28, this.child});

  final double studSpacing;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _BaseplatePainter(studSpacing), child: child);
  }
}

class _BaseplatePainter extends CustomPainter {
  const _BaseplatePainter(this.spacing);

  final double spacing;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = LpColors.bgWhite);
    final stud = Paint()
      ..color = LpColors.borderGray.withValues(alpha: 0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final r = spacing * 0.22;
    for (var y = spacing / 2; y < size.height; y += spacing) {
      for (var x = spacing / 2; x < size.width; x += spacing) {
        canvas.drawCircle(Offset(x, y), r, stud);
      }
    }
  }

  @override
  bool shouldRepaint(_BaseplatePainter oldDelegate) =>
      oldDelegate.spacing != spacing;
}
