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
/// royal-blue rounded stroke advances along a predefined path, densified to
/// half-cell steps, so the finger has to travel the whole stroke. Straying
/// off the letter snaps the current stroke back to its start (buzz + red
/// flash). Chevron arrows along the untraced path show which way to go, and
/// a pulsing blue dot + white hand mark the next point. Fully traced →
/// pop → auto-advance. No hearts are lost; retry just resets.
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

  /// Spacing of the densified waypoints, in cells.
  static const double _stepCells = 0.5;

  /// How many waypoints ahead a fast swipe may skip (≈ 3 cells).
  static const int _lookahead = 6;

  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 850),
  )..repeat(reverse: true);

  int _reached = 0;
  Offset? _finger;
  bool _done = false;

  /// True while the finger is down and following the stroke — a touch that
  /// lands away from the path doesn't draw until it reaches the next point.
  bool _tracking = false;

  /// Brief red flash after going off the letter.
  bool _offTrack = false;
  Timer? _offTrackTimer;
  int _secondsLeft = _timerStart;
  Timer? _ticker;
  Timer? _advanceTimer;

  // Board-space data refreshed on every build (layout-derived, no setState).
  List<Offset> _points = const <Offset>[];
  List<bool> _lifts = const <bool>[];
  double _hitRadius = 24;
  double _offPathTolerance = 34;

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
    _offTrackTimer?.cancel();
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
      _tracking = false;
      _offTrack = false;
      _secondsLeft = _timerStart;
    });
    _offTrackTimer?.cancel();
    _startTicker();
  }

  /// Index of the first waypoint of the stroke containing waypoint [i].
  int _strokeStartOf(int i) {
    var s = math.min(i, _points.length - 1);
    while (s > 0 && !_lifts[s - 1]) {
      s--;
    }
    return s;
  }

  /// Last waypoint index of the stroke containing waypoint [i].
  int _strokeEndOf(int i) {
    var e = i;
    while (e < _points.length - 1 && !_lifts[e]) {
      e++;
    }
    return e;
  }

  /// Whether the next waypoint continues a stroke already under way (rather
  /// than starting a new one after a pen lift).
  bool get _midStroke => _reached > 0 && !_lifts[_reached - 1];

  /// Distance from [p] to the stretch of the path around the next waypoint.
  double _distanceToPath(Offset p) {
    final end = math.min(_reached + _lookahead, _strokeEndOf(_reached));
    var best = double.infinity;
    for (var i = _reached; i <= end; i++) {
      best = math.min(best, _distanceToSegment(p, _points[i - 1], _points[i]));
    }
    return best;
  }

  static double _distanceToSegment(Offset p, Offset a, Offset b) {
    final ab = b - a;
    final len2 = ab.distanceSquared;
    if (len2 == 0) return (p - a).distance;
    final t = (((p - a).dx * ab.dx + (p - a).dy * ab.dy) / len2).clamp(
      0.0,
      1.0,
    );
    return (p - (a + ab * t)).distance;
  }

  /// Furthest waypoint within reach of [p], at most [_lookahead] ahead and
  /// never across a pen lift; null when none is.
  int? _reachableFrom(Offset p) {
    final end = math.min(_reached + _lookahead, _strokeEndOf(_reached));
    int? hit;
    for (var i = _reached; i <= end; i++) {
      if ((p - _points[i]).distance <= _hitRadius) hit = i;
    }
    return hit;
  }

  void _handleTouch(Offset local) {
    if (_done || _offTrack || _points.isEmpty) return;
    if (!_tracking) {
      // Start (or resume) only on the path: at the next waypoint, or on the
      // part of the stroke already under way.
      _tracking =
          _reachableFrom(local) != null ||
          (_midStroke && _distanceToPath(local) <= _offPathTolerance);
      if (!_tracking) {
        setState(() => _finger = null);
        return;
      }
    } else if (_midStroke && _distanceToPath(local) > _offPathTolerance) {
      _goOffTrack();
      return;
    }
    final hit = _reachableFrom(local);
    if (hit != null) _reached = hit + 1;
    setState(() => _finger = local);
    if (_reached >= _points.length) _complete();
  }

  /// The finger left the letter: the stroke flashes red, then the current
  /// stroke starts over.
  void _goOffTrack() {
    HapticFeedback.heavyImpact();
    _offTrackTimer?.cancel();
    final restart = _strokeStartOf(_reached - 1);
    setState(() {
      _tracking = false;
      _finger = null;
      _offTrack = true;
    });
    _offTrackTimer = Timer(const Duration(milliseconds: 450), () {
      if (!mounted) return;
      setState(() {
        _reached = restart;
        _offTrack = false;
      });
    });
  }

  void _endTouch() {
    _tracking = false;
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
              _densifyPath(exercise, boardW, boardH, cell);
              // Tight enough that the finger has to follow the letter, loose
              // enough for a small finger on a small board.
              _hitRadius = math.max(20, cell * 0.6);
              _offPathTolerance = math.max(28, cell * 0.9);
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
                          if (!_done)
                            Positioned.fill(
                              child: CustomPaint(
                                painter: _GuideArrowsPainter(
                                  points: _points,
                                  lifts: _lifts,
                                  reached: _reached,
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
                                offTrack: _offTrack,
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

  /// Board-space waypoints from the exercise's normalized path, with extra
  /// points every [_stepCells] cells along each stroke, plus the pen lifts
  /// marked by `strokeStarts`. Lifts are never guessed from distance: a long
  /// straight run like ب's base is one stroke with far-apart waypoints.
  void _densifyPath(
    TraceLetterExercise exercise,
    double boardW,
    double boardH,
    double cell,
  ) {
    final raw = <Offset>[
      for (final p in exercise.path) Offset(p.dx * boardW, p.dy * boardH),
    ];
    final points = <Offset>[];
    final lifts = <bool>[];
    for (var i = 0; i < raw.length; i++) {
      if (i == 0) {
        points.add(raw[0]);
        continue;
      }
      final a = raw[i - 1];
      final b = raw[i];
      if (exercise.strokeStarts.contains(i)) {
        lifts.add(true);
        points.add(b);
        continue;
      }
      final steps = math.max(
        1,
        ((b - a).distance / (cell * _stepCells)).ceil(),
      );
      for (var k = 1; k <= steps; k++) {
        lifts.add(false);
        points.add(Offset.lerp(a, b, k / steps)!);
      }
    }
    _points = points;
    _lifts = lifts;
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
          (slot.y + piece.nudgeY) * cell,
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

/// Direction chevrons along the part of the path still to trace, one every
/// [_spacingCells] cells, pointing the way the finger should move. Arrows on
/// the stroke under way are strong; later strokes are fainter. Ink with a
/// white halo so they read on both the plate and any brick colour.
class _GuideArrowsPainter extends CustomPainter {
  const _GuideArrowsPainter({
    required this.points,
    required this.lifts,
    required this.reached,
    required this.cell,
  });

  static const double _spacingCells = 1.25;

  final List<Offset> points;
  final List<bool> lifts;
  final int reached;
  final double cell;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    final spacing = cell * _spacingCells;
    final arrowSize = cell * 0.22;
    final halo = Paint()
      ..color = LpColors.bgWhite.withValues(alpha: 0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(5.0, cell * 0.16)
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final ink = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(2.4, cell * 0.075)
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // The stroke under way is the one holding the next waypoint.
    var stroke = 0;
    var currentStroke = 0;
    for (var i = 1; i <= reached && i < points.length; i++) {
      if (lifts[i - 1]) currentStroke++;
    }

    // Start half a spacing in, so no arrow sits on a stroke's first point.
    var untilNext = spacing / 2;
    for (var i = 1; i < points.length; i++) {
      if (lifts[i - 1]) {
        stroke++;
        untilNext = spacing / 2;
        continue;
      }
      final a = points[i - 1];
      final b = points[i];
      final length = (b - a).distance;
      if (length == 0) continue;
      final dir = (b - a) / length;
      var along = 0.0;
      while (along + untilNext <= length) {
        along += untilNext;
        untilNext = spacing;
        // Skip what the finger has already covered.
        if (i < reached) continue;
        final strong = stroke == currentStroke;
        ink.color = LpColors.ink.withValues(alpha: strong ? 0.8 : 0.3);
        halo.color = LpColors.bgWhite.withValues(alpha: strong ? 0.9 : 0.5);
        final path = _chevron(a + dir * along, dir, arrowSize);
        canvas.drawPath(path, halo);
        canvas.drawPath(path, ink);
      }
      untilNext -= length - along;
    }
  }

  /// A ">" pointing along [dir], its tip at [tip].
  static Path _chevron(Offset tip, Offset dir, double size) {
    final perp = Offset(-dir.dy, dir.dx);
    final back = tip - dir * size;
    final left = back + perp * size;
    final right = back - perp * size;
    return Path()
      ..moveTo(left.dx, left.dy)
      ..lineTo(tip.dx, tip.dy)
      ..lineTo(right.dx, right.dy);
  }

  @override
  bool shouldRepaint(_GuideArrowsPainter oldDelegate) =>
      oldDelegate.reached != reached ||
      oldDelegate.cell != cell ||
      oldDelegate.points != points;
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
    this.offTrack = false,
  });

  final List<Offset> points;
  final int reached;
  final Offset? finger;
  final List<bool> lifts;
  final double strokeWidth;

  /// Tints the stroke red for a moment after the finger left the letter.
  final bool offTrack;

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

    final color = offTrack ? LpColors.crimson : LpColors.royalBlue;
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final core = Paint()
      ..color = LpColors.lighten(color, 0.35)
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
          Paint()..color = color,
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
      oldDelegate.offTrack != offTrack ||
      oldDelegate.points != points;
}
