import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/lp_colors.dart';
import '../../core/theme/lp_text_styles.dart';
import '../../core/widgets/lp_card.dart';
import '../../core/widgets/lp_icons.dart';
import '../../data/models/lesson.dart';
import '../../state/app_state.dart';
import 'lesson_strings.dart';
import 'widgets/lesson_ui.dart';

/// Lesson celebration: brick confetti raining in brand colors, the learned
/// letter on a yellow badge, "Lesson complete!" and animated ✦/⚡ reward
/// tallies. CONTINUE grants the rewards via [AppState.completeLesson]
/// (unlocking the next letter) and pops back to home.
class LessonCompleteScreen extends StatefulWidget {
  const LessonCompleteScreen({super.key, required this.lesson});

  final Lesson lesson;

  @override
  State<LessonCompleteScreen> createState() => _LessonCompleteScreenState();
}

class _LessonCompleteScreenState extends State<LessonCompleteScreen>
    with TickerProviderStateMixin {
  late final AnimationController _confetti = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2600),
  )..forward();

  late final AnimationController _tally = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  bool _canContinue = false;
  Timer? _tallyTimer;
  Timer? _continueTimer;

  @override
  void initState() {
    super.initState();
    _tallyTimer = Timer(const Duration(milliseconds: 400), _tally.forward);
    _continueTimer = Timer(const Duration(milliseconds: 1400), () {
      if (mounted) setState(() => _canContinue = true);
    });
  }

  @override
  void dispose() {
    _confetti.dispose();
    _tally.dispose();
    _tallyTimer?.cancel();
    _continueTimer?.cancel();
    super.dispose();
  }

  void _finish() {
    context.read<AppState>().completeLesson(
      widget.lesson.id,
      widget.lesson.xpReward,
      earnedEnergy: widget.lesson.energyReward,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final lesson = widget.lesson;
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: LpColors.bgWhite,
        body: Stack(
          children: <Widget>[
            Positioned.fill(
              child: IgnorePointer(
                child: AnimatedBuilder(
                  animation: _confetti,
                  builder: (context, child) => CustomPaint(
                    painter: _BrickConfettiPainter(_confetti.value),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: <Widget>[
                  const Spacer(flex: 2),
                  PopIn(
                    child: LpCard(
                      color: LpColors.brandYellow,
                      borderWidth: 3,
                      shadowOffset: const Offset(0, 5),
                      width: 128,
                      height: 128,
                      padding: EdgeInsets.zero,
                      child: Center(
                        child: Text(
                          lesson.titleArabic,
                          textDirection: TextDirection.rtl,
                          style: LpTextStyles.arabicGiant.copyWith(
                            fontSize: 68,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 26),
                  const Text(
                    LessonStrings.completeTitle,
                    textAlign: TextAlign.center,
                    style: LpTextStyles.display,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${LessonStrings.completeSubtitlePrefix}'
                    '${lesson.titleLatin}'
                    '${LessonStrings.completeSubtitleSuffix}',
                    textAlign: TextAlign.center,
                    style: LpTextStyles.body.copyWith(color: LpColors.textGray),
                  ),
                  const SizedBox(height: 26),
                  AnimatedBuilder(
                    animation: _tally,
                    builder: (context, child) {
                      final t = Curves.easeOutCubic.transform(_tally.value);
                      return Transform.scale(
                        scale: 0.8 + 0.2 * t,
                        child: Opacity(
                          opacity: t.clamp(0.0, 1.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              _RewardCard(
                                icon: const SparkleIcon(size: 26),
                                value: (t * lesson.xpReward).round(),
                              ),
                              const SizedBox(width: 14),
                              _RewardCard(
                                icon: const BoltIcon(size: 26),
                                value: (t * lesson.energyReward).round(),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const Spacer(flex: 3),
                  LessonContinueBar(onContinue: _canContinue ? _finish : null),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// White toy card with a brand icon and an animated `+n` tally.
class _RewardCard extends StatelessWidget {
  const _RewardCard({required this.icon, required this.value});

  final Widget icon;
  final int value;

  @override
  Widget build(BuildContext context) {
    return LpCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          icon,
          const SizedBox(width: 8),
          Text('+$value', style: LpTextStyles.h1.copyWith(fontSize: 26)),
        ],
      ),
    );
  }
}

class _ConfettiParticle {
  const _ConfettiParticle({
    required this.x,
    required this.delay,
    required this.speed,
    required this.size,
    required this.color,
    required this.rotation,
    required this.rotationSpeed,
    required this.sway,
    required this.swayFrequency,
  });

  final double x;
  final double delay;
  final double speed;
  final double size;
  final Color color;
  final double rotation;
  final double rotationSpeed;
  final double sway;
  final double swayFrequency;
}

/// Tiny LEGO bricks raining in the five brand brick colors.
class _BrickConfettiPainter extends CustomPainter {
  const _BrickConfettiPainter(this.t);

  /// Animation progress 0..1.
  final double t;

  static final List<_ConfettiParticle> _particles = _generateParticles();

  static List<_ConfettiParticle> _generateParticles() {
    final random = math.Random(1971);
    return List<_ConfettiParticle>.generate(46, (i) {
      return _ConfettiParticle(
        x: random.nextDouble(),
        delay: random.nextDouble() * 0.35,
        speed: 0.8 + random.nextDouble() * 0.55,
        size: 6.5 + random.nextDouble() * 6.5,
        color: LpColors.brickColors[i % LpColors.brickColors.length],
        rotation: random.nextDouble() * math.pi * 2,
        rotationSpeed: (random.nextDouble() - 0.5) * 7,
        sway: 10 + random.nextDouble() * 26,
        swayFrequency: 2 + random.nextDouble() * 3,
      );
    });
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in _particles) {
      final local = (t - p.delay) / (1 - p.delay);
      if (local <= 0) continue;
      final y = (-0.06 + local * p.speed * 1.3) * size.height;
      if (y > size.height + 24) continue;
      final x =
          p.x * size.width +
          math.sin(local * p.swayFrequency * math.pi) * p.sway;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(p.rotation + p.rotationSpeed * local);

      final body = RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset.zero, width: p.size * 2, height: p.size),
        const Radius.circular(2.5),
      );
      canvas.drawRRect(body, Paint()..color = p.color);
      // Darker bottom edge + two studs for the toy look.
      canvas.drawRect(
        Rect.fromLTWH(-p.size, p.size * 0.24, p.size * 2, p.size * 0.26),
        Paint()..color = LpColors.darken(p.color, 0.25),
      );
      final stud = Paint()..color = LpColors.lighten(p.color, 0.3);
      canvas.drawCircle(
        Offset(-p.size * 0.48, -p.size * 0.06),
        p.size * 0.2,
        stud,
      );
      canvas.drawCircle(
        Offset(p.size * 0.48, -p.size * 0.06),
        p.size * 0.2,
        stud,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_BrickConfettiPainter oldDelegate) => oldDelegate.t != t;
}
