import 'package:flutter/material.dart';

import '../theme/lp_colors.dart';

/// Progress bar per spec: white track with a thin gray border; the fill is a
/// row of green LEGO studs growing left → right. Remaining studs are drawn
/// as very faint outlines.
class StudProgressBar extends StatelessWidget {
  const StudProgressBar({
    super.key,
    required this.progress,
    this.height = 18,
    this.studCount,
  });

  /// 0.0 … 1.0
  final double progress;
  final double height;

  /// Fixed stud count; when null it is derived from the available width.
  final int? studCount;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _StudBarPainter(
          progress: progress.clamp(0.0, 1.0),
          studCount: studCount,
        ),
      ),
    );
  }
}

class _StudBarPainter extends CustomPainter {
  const _StudBarPainter({required this.progress, this.studCount});

  final double progress;
  final int? studCount;

  @override
  void paint(Canvas canvas, Size size) {
    final track = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(size.height * 0.35),
    );
    canvas.drawRRect(track, Paint()..color = LpColors.bgWhite);
    canvas.drawRRect(
      track.deflate(0.75),
      Paint()
        ..color = LpColors.borderGray
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    const pad = 3.5;
    final studD = size.height - pad * 2;
    if (studD <= 0) return;
    const gap = 2.5;
    final count =
        studCount ?? ((size.width - pad * 2 + gap) / (studD + gap)).floor();
    if (count <= 0) return;
    final filled = (count * progress).round().clamp(0, count);

    final fillPaint = Paint()..color = LpColors.legoGreen;
    final ringPaint = Paint()
      ..color = LpColors.darken(LpColors.legoGreen, 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    final ghostPaint = Paint()
      ..color = LpColors.borderGray.withValues(alpha: 0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final highlightPaint = Paint()
      ..color = LpColors.lighten(LpColors.legoGreen, 0.45);

    final r = studD / 2;
    final cy = size.height / 2;
    for (var i = 0; i < count; i++) {
      final cx = pad + r + i * (studD + gap);
      if (cx + r > size.width - pad + 0.5) break;
      final c = Offset(cx, cy);
      if (i < filled) {
        canvas.drawCircle(c, r, fillPaint);
        canvas.drawCircle(c, r, ringPaint);
        canvas.drawCircle(
          c.translate(-r * 0.28, -r * 0.28),
          r * 0.24,
          highlightPaint,
        );
      } else {
        canvas.drawCircle(c, r * 0.9, ghostPaint);
      }
    }
  }

  @override
  bool shouldRepaint(_StudBarPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.studCount != studCount;
}
