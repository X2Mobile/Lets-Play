import 'package:flutter/material.dart';

import '../../../core/theme/lp_colors.dart';
import '../../../core/theme/lp_text_styles.dart';
import '../../../core/widgets/lp_card.dart';
import '../../../data/models/exercise.dart';
import '../widgets/lesson_ui.dart';

/// Positional-forms reference (design LEVEL 1/9 "Alef Letter Forms"):
/// a 2×2 grid of labeled cards — Initial / Isolated / Final / Medial.
class LetterFormsPage extends StatelessWidget {
  const LetterFormsPage({
    super.key,
    required this.exercise,
    required this.levelColor,
    required this.onAdvance,
  });

  final LetterFormsExercise exercise;
  final Color levelColor;
  final VoidCallback onAdvance;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 8),
        LessonHeading(text: exercise.title),
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: <Widget>[
                  for (final (label, glyph) in exercise.forms)
                    SizedBox(
                      width: 140,
                      child: PopIn(
                        child: LpCard(
                          borderWidth: 2.5,
                          shadowOffset: const Offset(0, 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 14,
                          ),
                          child: Column(
                            children: <Widget>[
                              Text(
                                glyph,
                                textDirection: TextDirection.rtl,
                                style: LpTextStyles.arabicGiant.copyWith(
                                  fontSize: 56,
                                  color: LpColors.darken(levelColor, 0.05),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(label, style: LpTextStyles.title),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        LessonContinueBar(onContinue: onAdvance),
      ],
    );
  }
}
