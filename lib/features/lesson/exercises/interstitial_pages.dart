import 'package:flutter/material.dart';

import '../../../core/theme/lp_colors.dart';
import '../../../core/theme/lp_text_styles.dart';
import '../../../core/widgets/lp_button.dart';
import '../../../core/widgets/mascot_image.dart';
import '../../../data/models/exercise.dart';
import '../lesson_strings.dart';

/// Tutorial interstitial (design LEVEL N/2, /9, /10): full-bleed level-color
/// screen, mascot holding a banner with the instruction written on it,
/// LETS PLAY button.
class TutorialPage extends StatelessWidget {
  const TutorialPage({
    super.key,
    required this.step,
    required this.levelColor,
    required this.onAdvance,
    required this.onClose,
  });

  final TutorialStep step;
  final Color levelColor;
  final VoidCallback onAdvance;

  /// X button — same confirm-quit as the exercise top bar.
  final VoidCallback onClose;

  /// tutorial_banner.png geometry (1056×1629): the blank banner's interior
  /// as fractions of the asset, measured from the shipped file.
  static const double _assetAspect = 1056 / 1629;
  static const Rect _bannerFraction = Rect.fromLTRB(0.02, 0.015, 0.98, 0.26);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: levelColor,
      child: SafeArea(
        child: Column(
          children: <Widget>[
            _InterstitialCloseButton(
              onClose: onClose,
              color: LpColors.foregroundOn(levelColor),
            ),
            const Spacer(),
            Expanded(
              flex: 8,
              child: Center(
                child: AspectRatio(
                  aspectRatio: _assetAspect,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final w = constraints.maxWidth;
                      final h = constraints.maxHeight;
                      return Stack(
                        children: <Widget>[
                          Positioned.fill(
                            child: Image.asset(
                              'assets/images/characters/tutorial_banner.png',
                              fit: BoxFit.contain,
                              errorBuilder: (_, _, _) =>
                                  const SizedBox.expand(),
                            ),
                          ),
                          // The instruction, written on the asset's blank
                          // banner.
                          Positioned(
                            left: _bannerFraction.left * w,
                            top: _bannerFraction.top * h,
                            width: _bannerFraction.width * w,
                            height: _bannerFraction.height * h,
                            child: Center(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      step.line1,
                                      textAlign: TextAlign.center,
                                      style: LpTextStyles.h1.copyWith(
                                        fontSize: 26,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      step.line2,
                                      textAlign: TextAlign.center,
                                      style: LpTextStyles.title,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: LpButton(
                label: LessonStrings.letsPlayButton,
                style: LpButtonStyle.neutral,
                onPressed: onAdvance,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Top-left X on the full-bleed interstitials (design shows the exercise
/// top bar behind the overlay; here the X carries the exit affordance).
class _InterstitialCloseButton extends StatelessWidget {
  const _InterstitialCloseButton({required this.onClose, required this.color});

  final VoidCallback onClose;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: GestureDetector(
          onTap: onClose,
          child: Icon(Icons.close_rounded, size: 30, color: color),
        ),
      ),
    );
  }
}

/// Checkpoint interstitial (design "Great Job Malak! / now let's test you"
/// and "Outstanding Job! / You crushed it"): full-bleed gradient screen,
/// big praise text, mascot, CONTINUE.
class CheckpointPage extends StatelessWidget {
  const CheckpointPage({
    super.key,
    required this.step,
    required this.levelColor,
    required this.onAdvance,
    required this.onClose,
  });

  final CheckpointStep step;
  final Color levelColor;
  final VoidCallback onAdvance;

  /// X button — same confirm-quit as the exercise top bar.
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final onColor = LpColors.foregroundOn(levelColor);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            levelColor,
            Color.lerp(levelColor, Colors.white, 0.55)!,
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: <Widget>[
            _InterstitialCloseButton(onClose: onClose, color: onColor),
            const Spacer(),
            Text(
              step.title,
              textAlign: TextAlign.center,
              style: LpTextStyles.display.copyWith(color: onColor),
            ),
            const SizedBox(height: 4),
            Text(
              step.subtitle,
              textAlign: TextAlign.center,
              style: LpTextStyles.h2.copyWith(color: onColor),
            ),
            Expanded(
              flex: 3,
              child: MascotImage(asset: 'characters/checkpoint.png'),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: LpButton(
                label: 'Continue',
                style: LpButtonStyle.neutral,
                onPressed: onAdvance,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
