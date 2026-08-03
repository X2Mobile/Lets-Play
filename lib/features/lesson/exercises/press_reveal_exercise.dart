import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/services/audio_service.dart';
import '../../../core/theme/lp_colors.dart';
import '../../../core/theme/lp_text_styles.dart';
import '../../../core/widgets/brick_glyph.dart';
import '../../../core/widgets/lp_card.dart';
import '../../../data/models/exercise.dart';
import '../widgets/lesson_ui.dart';

/// Press-to-reveal flashcard (design LEVEL 1/7–8, LEVEL 3/7–8): tapping the
/// big glyph toggles between the printed form and the LEGO-brick rendering,
/// replaying the audio each time ("Press on the letter").
class PressRevealPage extends StatefulWidget {
  const PressRevealPage({
    super.key,
    required this.exercise,
    required this.levelColor,
    required this.onAdvance,
  });

  final PressRevealExercise exercise;
  final Color levelColor;
  final VoidCallback onAdvance;

  @override
  State<PressRevealPage> createState() => _PressRevealPageState();
}

class _PressRevealPageState extends State<PressRevealPage> {
  bool _showBricks = false;
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

  void _toggle() {
    HapticFeedback.selectionClick();
    setState(() => _showBricks = !_showBricks);
    final audio = widget.exercise.audioFile;
    if (audio != null) AudioService.instance.playAsset(audio);
  }

  @override
  Widget build(BuildContext context) {
    final exercise = widget.exercise;
    final lightText =
        ThemeData.estimateBrightnessForColor(widget.levelColor) ==
        Brightness.dark;
    final textColor = lightText ? LpColors.bgWhite : LpColors.ink;
    return Column(
      children: <Widget>[
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: PopIn(
            child: LpCard(
              color: widget.levelColor,
              borderWidth: 3,
              shadowOffset: const Offset(0, 5),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 18,
              ),
              child: Column(
                children: <Widget>[
                  Text(
                    exercise.nameLatin,
                    style: LpTextStyles.h1.copyWith(color: textColor),
                  ),
                  Text(
                    exercise.nameArabic,
                    textDirection: TextDirection.rtl,
                    style: LpTextStyles.arabicLarge.copyWith(
                      fontSize: 26,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 26),
        GestureDetector(
          onTap: _toggle,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 260),
            transitionBuilder: (child, animation) =>
                ScaleTransition(scale: animation, child: child),
            child: _showBricks
                ? BrickGlyph(
                    key: const ValueKey<bool>(true),
                    gridColumns: exercise.gridColumns,
                    gridRows: exercise.gridRows,
                    slots: exercise.slots,
                    pieces: exercise.pieces,
                    height: 210,
                  )
                : SizedBox(
                    key: const ValueKey<bool>(false),
                    height: 210,
                    child: Center(
                      child: Text(
                        exercise.glyph,
                        textDirection: TextDirection.rtl,
                        style: LpTextStyles.arabicGiant.copyWith(
                          fontSize: 150,
                          height: 1.05,
                        ),
                      ),
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'Press on the letter',
          style: LpTextStyles.body.copyWith(color: LpColors.textGray),
        ),
        const Spacer(),
        LessonContinueBar(onContinue: widget.onAdvance),
      ],
    );
  }
}
