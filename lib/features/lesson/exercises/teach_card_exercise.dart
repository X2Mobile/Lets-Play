import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/services/audio_service.dart';
import '../../../core/theme/lp_colors.dart';
import '../../../core/theme/lp_text_styles.dart';
import '../../../core/widgets/audio_button.dart';
import '../../../core/widgets/lp_card.dart';
import '../../../data/models/exercise.dart';
import '../widgets/lesson_ui.dart';

/// "Learn" card (design: fatha card, word-type / verb-type grammar cards):
/// colored card with Arabic title + gloss, optional example rows with their
/// own audio, optional illustration. CONTINUE enabled immediately.
class TeachCardPage extends StatefulWidget {
  const TeachCardPage({
    super.key,
    required this.exercise,
    required this.levelColor,
    required this.onAdvance,
  });

  final TeachCardExercise exercise;
  final Color levelColor;
  final VoidCallback onAdvance;

  @override
  State<TeachCardPage> createState() => _TeachCardPageState();
}

class _TeachCardPageState extends State<TeachCardPage> {
  Timer? _autoplayTimer;

  @override
  void initState() {
    super.initState();
    final audio = widget.exercise.audioFile;
    if (audio != null) {
      _autoplayTimer = Timer(const Duration(milliseconds: 380), () {
        AudioService.instance.playAsset(audio);
      });
    }
  }

  @override
  void dispose() {
    _autoplayTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final exercise = widget.exercise;
    final color = exercise.cardColor ?? widget.levelColor;
    final lightText =
        ThemeData.estimateBrightnessForColor(color) == Brightness.dark;
    final textColor = lightText ? LpColors.bgWhite : LpColors.ink;

    return Column(
      children: <Widget>[
        const SizedBox(height: 8),
        if (exercise.heading != null) LessonHeading(text: exercise.heading!),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(28, 16, 28, 8),
            child: Column(
              children: <Widget>[
                PopIn(
                  child: LpCard(
                    color: color,
                    borderWidth: 3,
                    shadowOffset: const Offset(0, 5),
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 22,
                    ),
                    child: Column(
                      children: <Widget>[
                        Text(
                          exercise.titleArabic,
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
                          style: LpTextStyles.arabicLarge.copyWith(
                            color: textColor,
                          ),
                        ),
                        if (exercise.titleLatin != null)
                          Text(
                            exercise.titleLatin!,
                            textAlign: TextAlign.center,
                            style: LpTextStyles.h2.copyWith(color: textColor),
                          ),
                        if (exercise.subtitle != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              exercise.subtitle!,
                              textAlign: TextAlign.center,
                              style: LpTextStyles.title.copyWith(
                                color: textColor,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                if (exercise.imageAsset != null) ...<Widget>[
                  const SizedBox(height: 18),
                  Image.asset(
                    'assets/images/${exercise.imageAsset}',
                    height: 140,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => const SizedBox.shrink(),
                  ),
                ],
                if (exercise.audioFile != null) ...<Widget>[
                  const SizedBox(height: 20),
                  AudioButton(audioFile: exercise.audioFile!),
                ],
                if (exercise.items.isNotEmpty) ...<Widget>[
                  const SizedBox(height: 18),
                  for (final item in exercise.items)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: LpCard(
                        borderColor: LpColors.borderGray,
                        borderWidth: 1.2,
                        shadowOffset: const Offset(0, 2),
                        shadowColor: LpColors.borderGray,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        child: Row(
                          children: <Widget>[
                            if (item.audioFile != null) ...<Widget>[
                              AudioButton(
                                audioFile: item.audioFile!,
                                variant: AudioButtonVariant.small,
                              ),
                              const SizedBox(width: 12),
                            ],
                            if (item.gloss != null)
                              Expanded(
                                child: Text(
                                  item.gloss!,
                                  style: LpTextStyles.body.copyWith(
                                    color: LpColors.textGray,
                                  ),
                                ),
                              ),
                            const SizedBox(width: 12),
                            Text(
                              item.arabic,
                              textDirection: TextDirection.rtl,
                              style: LpTextStyles.arabicLarge.copyWith(
                                fontSize: 24,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
        LessonContinueBar(onContinue: widget.onAdvance),
      ],
    );
  }
}
