import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/services/audio_service.dart';
import '../../../core/theme/lp_colors.dart';
import '../../../core/theme/lp_text_styles.dart';
import '../../../core/widgets/audio_button.dart';
import '../../../core/widgets/lp_card.dart';
import '../../../data/models/exercise.dart';
import '../widgets/lesson_ui.dart';

/// Exercise 1 — letter intro: big yellow card with the huge Arabic glyph,
/// its name + transliteration, and an audio button. The letter sound
/// auto-plays on entry and replays on tap. CONTINUE is enabled immediately.
class LetterIntroPage extends StatefulWidget {
  const LetterIntroPage({
    super.key,
    required this.exercise,
    required this.onAdvance,
  });

  final LetterIntroExercise exercise;
  final VoidCallback onAdvance;

  @override
  State<LetterIntroPage> createState() => _LetterIntroPageState();
}

class _LetterIntroPageState extends State<LetterIntroPage> {
  Timer? _autoplayTimer;

  @override
  void initState() {
    super.initState();
    // Wait for the page transition to settle, then say the letter.
    _autoplayTimer = Timer(const Duration(milliseconds: 380), () {
      AudioService.instance.playAsset(widget.exercise.audioFile);
    });
  }

  @override
  void dispose() {
    _autoplayTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final exercise = widget.exercise;
    return Column(
      children: <Widget>[
        const Spacer(flex: 2),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: PopIn(
            child: LpCard(
              color: LpColors.brandYellow,
              borderWidth: 3,
              shadowOffset: const Offset(0, 5),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
              child: Column(
                children: <Widget>[
                  Text(
                    exercise.glyph,
                    textDirection: TextDirection.rtl,
                    style: LpTextStyles.arabicGiant,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    exercise.nameArabic,
                    textDirection: TextDirection.rtl,
                    style: LpTextStyles.arabicLarge.copyWith(
                      fontSize: 26,
                      height: 1.15,
                    ),
                  ),
                  Text(
                    '${exercise.nameLatin} · ${exercise.translit}',
                    style: LpTextStyles.h2.copyWith(letterSpacing: 1.2),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 28),
        AudioButton(audioFile: exercise.audioFile),
        const Spacer(flex: 3),
        LessonContinueBar(onContinue: widget.onAdvance),
      ],
    );
  }
}
