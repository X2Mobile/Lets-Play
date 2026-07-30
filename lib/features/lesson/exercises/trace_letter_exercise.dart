import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/lp_colors.dart';
import '../../../core/widgets/brick_widget.dart';
import '../../../data/models/exercise.dart';
import '../../../state/app_state.dart';
import '../widgets/lesson_ui.dart';

/// Exercise 3 — trace the letter. The letter is rendered from bricks; a
/// royal-blue rounded stroke advances along a predefined path while the
/// finger stays within a generous radius of the next waypoint. A pulsing
/// blue dot + white hand show where to go. Fully traced → pop →
/// auto-advance. No fail state; retry just resets.
class TraceLetterPage extends StatefulWidget {
  const TraceLetterPage({
    super.key,
    required this.exercise,
    required this.onSolved,
    required this.onCompleted,
  });

  final TraceLetterExercise exercise;
  final VoidCallback onSolved;
  final VoidCallback onCompleted;

  @override
  State<TraceLetterPage> createState() => _TraceLetterPageState();
}

class _TraceLetterPageState extends State<TraceLetterPage>
    with SingleTickerProviderStateMixin {
  /// Cosmetic countdown, mirroring the build exercise chrome.
  static const int _timerStart = 30;

  /// A jump longer than this (normalized) is a pen lift — e.g. hopping to
  /// the dot of ب — and is not drawn as a connecting stroke.
  static const double _liftThreshold = 0.3;

  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 850),
  )..repeat(reverse: true);

  late final List<bool> _lifts = <bool>[
    for (var i = 0; i < widget.exercise.path.length - 1; i++)
      (widget.exercise.path[i + 1] - widget.exercise.path[i]).distance >
          _liftThreshold,
  ];

  int _reached = 0;
  Offset? _finger;
  bool _done = false;
  int _secondsLeft = _timerStart;
  Timer? _ticker;
  Timer? _advanceTimer;

  // Board-space data refreshed on every build (layout-derived, no setState).
  List<Offset> _points = const <Offset>[];
  double _hitRadius = 40;

  @override
  void initState() {
    super.initState();
    _startTicker();
  }

  @override
  void dispose() {
    _pulse.dispose();
    _ticker?.cancel();
    _advanceTimer?.cancel();
    super.dispose();
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_secondsLeft > 0 && !_done) setState(() => _secondsLeft--);
    });
  }

  void _retry() {
    _advanceTimer?.cancel();
    setState(() {
      _reached = 0;
      _finger = null;
      _done = false;
      _secondsLeft = _timerStart;
    });
    _startTicker();
  }

  void _handleTouch(Offset local) {
    if (_done || _points.isEmpty) return;
    var advanced = false;
    while (_reached < _points.length &&
        (local - _points[_reached]).distance <= _hitRadius) {
      _reached++;
      advanced = true;
    }
    setState(() => _finger = local);
    if (advanced && _reached >= _points.length) _complete();
  }

  void _endTouch() {
    if (_finger != null) setState(() => _finger = null);
  }

  void _complete() {
    setState(() {
      _done = true;
      _finger = null;
    });
    _ticker?.cancel();
    _pulse.stop();
    HapticFeedback.mediumImpact();
    widget.onSolved();
    _advanceTimer = Timer(
      const Duration(milliseconds: 850),
      widget.onCompleted,
    );
  }

  @override
  Widget build(BuildContext context) {
    final energy = context.watch<AppState>().energy;
    final exercise = widget.exercise;
    return Column(
      children: <Widget>[
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final cols = exercise.gridColumns;
              final rows = exercise.gridRows;
              final cell = math
                  .min(
                    (constraints.maxWidth - 56) / cols,
                    (constraints.maxHeight - 24) / rows,
                  )
                  .clamp(18.0, 46.0);
              final boardW = cols * cell;
              final boardH = rows * cell;
              _points = <Offset>[
                for (final p in exercise.path)
                  Offset(p.dx * boardW, p.dy * boardH),
              ];
              // Generous but below the waypoint spacing, so the finger has
              // to actually travel the stroke (no single-touch skips).
              _hitRadius = math.max(36, cell * 0.95);
              final strokeWidth = math.min(16.0, math.max(12.0, cell * 0.35));
              final hint = _done
                  ? null
                  : _points[math.min(_reached, _points.length - 1)];

              return Center(
                child: SizedBox(
                  width: boardW,
                  height: boardH,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onPanDown: (d) => _handleTouch(d.localPosition),
                    onPanUpdate: (d) => _handleTouch(d.localPosition),
                    onPanEnd: (_) => _endTouch(),
                    onPanCancel: _endTouch,
                    child: CelebrationPop(
                      play: _done,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: <Widget>[
                          Positioned.fill(
                            child: CustomPaint(
                              painter: _LetterBricksPainter(
                                exercise: exercise,
                                cell: cell,
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: CustomPaint(
                              painter: _TraceStrokePainter(
                                points: _points,
                                reached: _reached,
                                finger: _finger,
                                lifts: _lifts,
                                strokeWidth: strokeWidth,
                              ),
                            ),
                          ),
                          if (hint != null) ..._buildHint(hint),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 14),
          child: LessonStatBar(
            seconds: _secondsLeft,
            energy: energy,
            onRetry: _done ? null : _retry,
          ),
        ),
      ],
    );
  }

  /// Pulsing royal-blue dot on the next waypoint + a clean white hand chip.
  List<Widget> _buildHint(Offset target) {
    return <Widget>[
      Positioned(
        left: target.dx - 14,
        top: target.dy - 14,
        child: IgnorePointer(
          child: AnimatedBuilder(
            animation: _pulse,
            builder: (context, child) => Transform.scale(
              scale: 0.75 + 0.45 * _pulse.value,
              child: child,
            ),
            child: Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: LpColors.lighten(LpColors.royalBlue, 0.65),
                shape: BoxShape.circle,
              ),
              child: Container(
                width: 14,
                height: 14,
                decoration: const BoxDecoration(
                  color: LpColors.royalBlue,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ),
      Positioned(
        left: target.dx + 8,
        top: target.dy + 10,
        child: IgnorePointer(
          child: Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: LpColors.bgWhite,
              shape: BoxShape.circle,
              border: Border.all(color: LpColors.ink, width: 2),
              boxShadow: const <BoxShadow>[
                BoxShadow(color: LpColors.ink, offset: Offset(0, 3)),
              ],
            ),
            child: const Text('👆', style: TextStyle(fontSize: 19)),
          ),
        ),
      ),
    ];
  }
}

/// Paints the finished letter out of bricks (soft, non-outlined toy look).
class _LetterBricksPainter extends CustomPainter {
  const _LetterBricksPainter({required this.exercise, required this.cell});

  final TraceLetterExercise exercise;
  final double cell;

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < exercise.slots.length; i++) {
      final slot = exercise.slots[i];
      final piece = exercise.pieces[i];
      BrickPainter.paintBrick(
        canvas,
        Rect.fromLTWH(
          slot.x * cell,
          slot.y * cell,
          piece.columns * cell,
          piece.rows * cell,
        ),
        color: piece.color,
        columns: piece.columns,
        rows: piece.rows,
        outlined: false,
      );
    }
  }

  @override
  bool shouldRepaint(_LetterBricksPainter oldDelegate) =>
      oldDelegate.cell != cell || oldDelegate.exercise != exercise;
}

/// The royal-blue tracing stroke: smoothed polyline through the reached
/// waypoints, a live segment following the finger, and round blobs for
/// single-point sub-strokes (e.g. the dot of ب). Pen lifts break the line.
class _TraceStrokePainter extends CustomPainter {
  const _TraceStrokePainter({
    required this.points,
    required this.reached,
    required this.finger,
    required this.lifts,
    required this.strokeWidth,
  });

  final List<Offset> points;
  final int reached;
  final Offset? finger;
  final List<bool> lifts;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    if (reached <= 0) return;

    // Split the reached waypoints into pen-lift-separated runs.
    final runs = <List<Offset>>[];
    var current = <Offset>[];
    for (var i = 0; i < reached; i++) {
      if (i > 0 && lifts[i - 1] && current.isNotEmpty) {
        runs.add(current);
        current = <Offset>[];
      }
      current.add(points[i]);
    }
    if (current.isNotEmpty) runs.add(current);

    // Live segment easing toward the next waypoint while the finger moves.
    final touch = finger;
    if (touch != null && reached < points.length && !lifts[reached - 1]) {
      final a = points[reached - 1];
      final b = points[reached];
      final ab = b - a;
      final len2 = ab.distanceSquared;
      if (len2 > 0) {
        final t = (((touch - a).dx * ab.dx + (touch - a).dy * ab.dy) / len2)
            .clamp(0.0, 0.95);
        if (t > 0.02) runs.last.add(a + ab * t);
      }
    }

    final stroke = Paint()
      ..color = LpColors.royalBlue
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final core = Paint()
      ..color = LpColors.lighten(LpColors.royalBlue, 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth * 0.34
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    for (final run in runs) {
      if (run.length == 1) {
        // A single reached point — draw a round blob (the dot of ب).
        canvas.drawCircle(
          run.first,
          strokeWidth * 0.55,
          Paint()..color = LpColors.royalBlue,
        );
        canvas.drawCircle(
          run.first,
          strokeWidth * 0.24,
          Paint()..color = core.color,
        );
        continue;
      }
      final path = _smoothPath(run);
      canvas.drawPath(path, stroke);
      canvas.drawPath(path, core);
    }
  }

  /// Midpoint-smoothed path through [pts] (round, kid-drawn feel).
  Path _smoothPath(List<Offset> pts) {
    final path = Path()..moveTo(pts.first.dx, pts.first.dy);
    if (pts.length == 2) {
      path.lineTo(pts[1].dx, pts[1].dy);
      return path;
    }
    for (var i = 1; i < pts.length - 1; i++) {
      final mid = (pts[i] + pts[i + 1]) / 2;
      path.quadraticBezierTo(pts[i].dx, pts[i].dy, mid.dx, mid.dy);
    }
    path.lineTo(pts.last.dx, pts.last.dy);
    return path;
  }

  @override
  bool shouldRepaint(_TraceStrokePainter oldDelegate) =>
      oldDelegate.reached != reached ||
      oldDelegate.finger != finger ||
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.points != points;
}
