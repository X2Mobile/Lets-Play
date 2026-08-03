import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/lp_colors.dart';
import '../../core/widgets/brick_widget.dart';
import '../../core/widgets/lp_logo.dart';
import '../auth/login_screen.dart';

/// Two-stage splash per the design (LOG IN/0–4): colored LEGO bricks
/// cascade down over the yellow screen until it is tiled full, then a
/// crimson frame reveals the yellow LET'S PLAY brick logo, then Login.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _cascade = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2000),
  )..forward();

  bool _showLogo = false;
  Timer? _logoTimer;
  Timer? _advanceTimer;

  @override
  void initState() {
    super.initState();
    _logoTimer = Timer(const Duration(milliseconds: 2250), () {
      if (mounted) setState(() => _showLogo = true);
    });
    _advanceTimer = Timer(const Duration(milliseconds: 3900), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
      );
    });
  }

  @override
  void dispose() {
    _cascade.dispose();
    _logoTimer?.cancel();
    _advanceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_showLogo) {
      return Scaffold(
        backgroundColor: LpColors.crimson,
        body: Center(
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.85, end: 1),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutBack,
            builder: (context, scale, child) =>
                Transform.scale(scale: scale, child: child),
            child: const LpLogo(height: 200),
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: LpColors.splashYellow,
      body: AnimatedBuilder(
        animation: _cascade,
        builder: (context, _) => CustomPaint(
          size: Size.infinite,
          painter: _BrickCascadePainter(_cascade.value),
        ),
      ),
    );
  }
}

/// One brick in the cascade: column index, order within the column, stud
/// rows, and color.
class _CascadeBrick {
  const _CascadeBrick({
    required this.column,
    required this.order,
    required this.rows,
    required this.color,
    required this.startFraction,
  });

  final int column;
  final int order;
  final int rows;
  final Color color;

  /// When (0..1 of the animation) this brick starts dropping in.
  final double startFraction;
}

/// Columns of 2-stud-wide bricks growing down from the top edge until the
/// screen is tiled (design LOG IN/0→3). Deterministic layout (seeded).
class _BrickCascadePainter extends CustomPainter {
  _BrickCascadePainter(this.t);

  /// Animation progress 0..1.
  final double t;

  static const int _columns = 7;
  static final List<_CascadeBrick> _bricks = _generate();

  static List<_CascadeBrick> _generate() {
    final random = math.Random(2026);
    final bricks = <_CascadeBrick>[];
    for (var c = 0; c < _columns; c++) {
      // Each column gets enough bricks to overfill the tallest screen.
      var order = 0;
      var filledRows = 0;
      // Stagger columns so they never finish at the same moment.
      final columnDelay = random.nextDouble() * 0.25;
      while (filledRows < 22) {
        final rows = 2 + random.nextInt(4); // 2–5 stud rows per brick
        bricks.add(
          _CascadeBrick(
            column: c,
            order: order,
            rows: rows,
            color: LpColors.splashBrickColors[random.nextInt(
              LpColors.splashBrickColors.length,
            )],
            startFraction:
                (columnDelay + order * (0.62 / 8)).clamp(0.0, 0.72),
          ),
        );
        filledRows += rows;
        order++;
      }
    }
    return bricks;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final colWidth = size.width / _columns;
    final unit = colWidth / 2; // 2 studs per column width

    // Track how far each column has been filled so bricks stack.
    final columnTops = List<double>.filled(_columns, 0);
    for (final brick in _bricks) {
      final height = brick.rows * unit;
      final top = columnTops[brick.column];
      if (top > size.height) continue;

      // Drop-in: the brick slides down to its resting slot.
      final local =
          ((t - brick.startFraction) / 0.28).clamp(0.0, 1.0);
      if (local <= 0) continue;
      // Slide down from just above the resting slot.
      final eased = Curves.easeOutCubic.transform(local);
      final y = top - height * 1.4 * (1 - eased);

      BrickPainter.paintBrick(
        canvas,
        Rect.fromLTWH(brick.column * colWidth, y, colWidth, height),
        color: brick.color,
        columns: 2,
        rows: brick.rows,
        outlined: false,
      );
      columnTops[brick.column] = top + height;
    }
  }

  @override
  bool shouldRepaint(_BrickCascadePainter oldDelegate) => oldDelegate.t != t;
}
