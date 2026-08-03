import 'package:flutter/material.dart';

import '../../core/theme/lp_colors.dart';
import '../../core/theme/lp_text_styles.dart';
import '../../core/widgets/lp_button.dart';
import '../../core/widgets/lp_card.dart';
import '../../core/widgets/mascot_image.dart';
import '../../data/models/lesson.dart';
import 'lesson_countdown_screen.dart';
import 'lesson_strings.dart';

/// Level intro popup (design `LEVEL N/0`): solid level-color screen, mascot
/// above a white "Level N — You'll learn …" checklist card, CONTINUE.
class LevelIntroScreen extends StatelessWidget {
  const LevelIntroScreen({super.key, required this.lesson});

  final Lesson lesson;

  /// Entry point for a full lesson run: intro → countdown → exercises.
  static void start(BuildContext context, Lesson lesson) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => LevelIntroScreen(lesson: lesson)),
    );
  }

  Color get _color => lesson.levelColor ?? LpColors.brandYellow;

  bool get _lightForeground => lesson.levelNumber != 1;

  @override
  Widget build(BuildContext context) {
    final closeColor = _lightForeground ? LpColors.bgWhite : LpColors.ink;
    // No swipe-back mid-flow — leaving is only via the X (which pops
    // directly).
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: _color,
        body: SafeArea(
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
                      color: closeColor,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: lesson.introCharacterAsset == null
                      ? const SizedBox.shrink()
                      : MascotImage(asset: lesson.introCharacterAsset!),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: LpCard(
                  borderWidth: 3,
                  radius: 14,
                  shadowOffset: const Offset(0, 5),
                  padding: const EdgeInsets.fromLTRB(24, 22, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            LessonStrings.levelLabel,
                            style: LpTextStyles.display.copyWith(fontSize: 38),
                          ),
                          const SizedBox(width: 14),
                          Container(
                            width: 44,
                            height: 44,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: _color,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: LpColors.ink, width: 2),
                            ),
                            child: Text(
                              '${lesson.levelNumber}',
                              style: LpTextStyles.h1.copyWith(
                                color: _lightForeground
                                    ? LpColors.bgWhite
                                    : LpColors.ink,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Center(
                        child: Text(
                          LessonStrings.youWillLearn,
                          style: LpTextStyles.h2.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      for (final item in lesson.introChecklist)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.done_all_rounded,
                                size: 22,
                                color: _color,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(item, style: LpTextStyles.body),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: LpButton(
                  label: 'Continue',
                  style: LpButtonStyle.neutral,
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute<void>(
                        builder: (_) => LessonCountdownScreen(lesson: lesson),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
