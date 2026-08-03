import 'package:flutter/material.dart';

import '../../core/theme/lp_colors.dart';
import '../../core/theme/lp_text_styles.dart';
import '../../core/widgets/lp_button.dart';
import '../../core/widgets/lp_card.dart';
import '../../core/widgets/mascot_image.dart';
import '../../data/models/lesson.dart';
import 'lesson_flow_screen.dart';
import 'lesson_strings.dart';

/// "Lesson N / Level N" countdown splash (design `LEVEL N/1`): gradient
/// level-color background, mascot with a ٣٢١ speech bubble standing on a
/// brick, banner card, CONTINUE into the exercises.
class LessonCountdownScreen extends StatelessWidget {
  const LessonCountdownScreen({super.key, required this.lesson});

  final Lesson lesson;

  Color get _color => lesson.levelColor ?? LpColors.brandYellow;

  bool get _lightForeground => lesson.levelNumber != 1;

  @override
  Widget build(BuildContext context) {
    final onColor = _lightForeground ? LpColors.bgWhite : LpColors.ink;
    // No swipe-back mid-flow — leaving is only via the X (which pops
    // directly).
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[_color, Color.lerp(_color, Colors.white, 0.55)!],
            ),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Icon(
                        Icons.close_rounded,
                        size: 30,
                        color: onColor,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: lesson.countdownCharacterAsset == null
                      ? _FallbackCountdown(color: _color)
                      : MascotImage(asset: lesson.countdownCharacterAsset!),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: LpCard(
                    color: _color,
                    borderWidth: 3,
                    radius: 14,
                    shadowOffset: const Offset(0, 5),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              LessonStrings.lessonLabel,
                              style: LpTextStyles.display.copyWith(
                                fontSize: 36,
                                color: onColor,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Container(
                              width: 42,
                              height: 42,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: LpColors.bgWhite,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: LpColors.ink,
                                  width: 2,
                                ),
                              ),
                              child: Text(
                                '${lesson.lessonNumber}',
                                style: LpTextStyles.h1,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${LessonStrings.levelLabel} ${lesson.levelNumber}',
                          style: LpTextStyles.h2.copyWith(color: onColor),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 16),
                  child: LpButton(
                    label: 'Continue',
                    style: LpButtonStyle.neutral,
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute<void>(
                          builder: (_) => LessonFlowScreen(lesson: lesson),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// ٣٢١ speech bubble drawn in code when no character crop is bundled.
class _FallbackCountdown extends StatelessWidget {
  const _FallbackCountdown({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LpCard(
        radius: 18,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        child: Text(
          '٣٢١',
          textDirection: TextDirection.rtl,
          style: LpTextStyles.arabicLarge.copyWith(
            color: LpColors.darken(color, 0.1),
            fontSize: 40,
          ),
        ),
      ),
    );
  }
}
