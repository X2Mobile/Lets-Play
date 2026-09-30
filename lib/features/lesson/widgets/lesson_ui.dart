/// Small shared pieces of the lesson flow: CONTINUE bar, the build/trace
/// stat bar (retry + ⏱/⚡/moves pill), option cards and entrance/celebration
/// animations. Everything follows the "neo-brutalist toy" design language.
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/lp_colors.dart';
import '../../../core/theme/lp_text_styles.dart';
import '../../../core/widgets/brick_widget.dart';
import '../../../core/widgets/lp_button.dart';
import '../../../core/widgets/lp_icons.dart';
import '../../../core/widgets/option_tile.dart';
import '../../../data/content/ui_strings.dart';
import '../../../data/models/exercise.dart';
import '../../../state/app_state.dart';
import '../lesson_strings.dart';

/// Wrong answers cost a heart, but the count never drops below one —
/// the demo must never block the flow.
void loseHeartForgiving(BuildContext context) {
  final appState = context.read<AppState>();
  if (appState.hearts > 1) appState.loseHeart();
}

/// Centered bold exercise heading ("Match the image", …).
class LessonHeading extends StatelessWidget {
  const LessonHeading({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: LpTextStyles.h1.copyWith(fontSize: 24, letterSpacing: 0.2),
      ),
    );
  }
}

/// Bottom CONTINUE pattern: quiet gray while unsolved, yellow once enabled.
class LessonContinueBar extends StatelessWidget {
  const LessonContinueBar({super.key, this.onContinue});

  /// Null renders the disabled gray state.
  final VoidCallback? onContinue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 8, 28, 20),
      child: LpButton(label: UiStrings.continueLabel, onPressed: onContinue),
    );
  }
}

/// Build/trace bottom chrome per the XD frames: a retry square on the left
/// and a white pill with ⏱ seconds, ⚡ energy and (build only) a moves
/// counter on the right. Everything here is cosmetic — no fail state.
class LessonStatBar extends StatelessWidget {
  const LessonStatBar({
    super.key,
    required this.seconds,
    required this.energy,
    this.moves,
    this.onRetry,
  });

  final int seconds;
  final int energy;

  /// Shown as `Moves: n` when non-null (build exercise only).
  final int? moves;
  final VoidCallback? onRetry;

  static final TextStyle _valueStyle = LpTextStyles.statValue.copyWith(
    color: LpColors.textGray,
    fontSize: 16,
  );

  static BoxDecoration get _quietCard => BoxDecoration(
    color: LpColors.bgWhite,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: LpColors.borderGray, width: 1.5),
    boxShadow: const <BoxShadow>[
      BoxShadow(color: LpColors.borderGray, offset: Offset(0, 3)),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Semantics(
          label: LessonStrings.retrySemantics,
          button: true,
          child: GestureDetector(
            onTap: onRetry,
            child: Opacity(
              opacity: onRetry == null ? 0.55 : 1,
              child: Container(
                width: 52,
                height: 52,
                decoration: _quietCard,
                child: const Icon(
                  Icons.refresh_rounded,
                  size: 26,
                  color: LpColors.textGray,
                ),
              ),
            ),
          ),
        ),
        const Spacer(),
        Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: _quietCard,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const LessonStopwatchIcon(size: 20),
              const SizedBox(width: 5),
              Text('$seconds', style: _valueStyle),
              const SizedBox(width: 14),
              const BoltIcon(size: 19),
              const SizedBox(width: 5),
              Text('$energy', style: _valueStyle),
              if (moves != null) ...<Widget>[
                const SizedBox(width: 14),
                Container(width: 1.4, height: 20, color: LpColors.borderGray),
                const SizedBox(width: 14),
                Text('${LessonStrings.movesLabel} $moves', style: _valueStyle),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// Small yellow stopwatch for the cosmetic countdown.
class LessonStopwatchIcon extends StatelessWidget {
  const LessonStopwatchIcon({super.key, this.size = 20});

  final double size;

  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size.square(size), painter: const _StopwatchPainter());
}

class _StopwatchPainter extends CustomPainter {
  const _StopwatchPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final stroke = Paint()
      ..color = LpColors.ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1.5, w * 0.09)
      ..strokeCap = StrokeCap.round;
    final fill = Paint()..color = LpColors.brandYellow;

    // Winding button on top.
    final crown = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(w * 0.5, h * 0.10),
        width: w * 0.26,
        height: h * 0.16,
      ),
      const Radius.circular(1.5),
    );
    canvas.drawRRect(crown, fill);
    canvas.drawRRect(crown, stroke);

    // Body + hand.
    final center = Offset(w * 0.5, h * 0.58);
    final r = w * 0.38;
    canvas.drawCircle(center, r, fill);
    canvas.drawCircle(center, r, stroke);
    canvas.drawLine(center, center.translate(0, -r * 0.55), stroke);
  }

  @override
  bool shouldRepaint(_StopwatchPainter oldDelegate) => false;
}

/// Springy scale + fade entrance (easeOutBack) for cards and badges.
class PopIn extends StatelessWidget {
  const PopIn({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 420),
  });

  final Widget child;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: duration,
      curve: Curves.easeOutBack,
      builder: (context, t, child) => Opacity(
        opacity: t.clamp(0.0, 1.0),
        child: Transform.scale(scale: 0.82 + 0.18 * t, child: child),
      ),
      child: child,
    );
  }
}

/// One-shot scale pulse used when a letter is fully built / traced.
/// Idle while [play] is false; pulses once when it flips to true.
class CelebrationPop extends StatelessWidget {
  const CelebrationPop({super.key, required this.play, required this.child});

  final bool play;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: play ? 1 : 0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      builder: (context, t, child) => Transform.scale(
        scale: 1 + 0.12 * math.sin(math.pi * t),
        child: child,
      ),
      child: child,
    );
  }
}

/// White option card showing LEGO bricks, an illustration (or its emoji
/// placeholder) or an Arabic letter, including the correct/wrong flash + shake states from
/// [OptionTile].
class ExerciseOptionCard extends StatelessWidget {
  const ExerciseOptionCard({
    super.key,
    required this.option,
    required this.status,
    this.onTap,
    this.emojiSize = 64,
  });

  final ExerciseOption option;
  final OptionTileStatus status;
  final VoidCallback? onTap;
  final double emojiSize;

  @override
  Widget build(BuildContext context) {
    final image = option.imageAsset;
    if (image != null) {
      return OptionTile(
        status: status,
        onTap: onTap,
        padding: const EdgeInsets.all(12),
        child: Center(
          child: Image.asset(
            'assets/images/$image',
            fit: BoxFit.contain,
            // Falls back to the emoji placeholder if the asset is missing.
            errorBuilder: (_, _, _) => Text(
              option.emoji ?? '',
              style: TextStyle(fontSize: emojiSize, height: 1.25),
            ),
          ),
        ),
      );
    }
    final Widget content = option.brickCount != null
        ? Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: List<Widget>.generate(
              option.brickCount!,
              (_) => const BrickWidget(color: LpColors.brandYellow, unit: 20),
            ),
          )
        : option.emoji != null
        ? Text(
            option.emoji!,
            style: TextStyle(fontSize: emojiSize, height: 1.25),
          )
        : Text(
            option.letter ?? '',
            textDirection: TextDirection.rtl,
            style: LpTextStyles.arabicGiant.copyWith(
              fontSize: emojiSize * 0.95,
            ),
          );
    return OptionTile(
      status: status,
      onTap: onTap,
      padding: const EdgeInsets.all(10),
      child: Center(
        child: FittedBox(fit: BoxFit.scaleDown, child: content),
      ),
    );
  }
}
