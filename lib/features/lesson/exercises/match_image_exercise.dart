import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/services/audio_service.dart';
import '../../../core/theme/lp_colors.dart';
import '../../../core/theme/lp_text_styles.dart';
import '../../../core/widgets/audio_button.dart';
import '../../../core/widgets/lp_card.dart';
import '../../../core/widgets/option_tile.dart';
import '../../../data/models/exercise.dart';
import '../lesson_strings.dart';
import '../widgets/lesson_ui.dart';

/// Exercise 4 — "Match the image": white word card (Arabic word + small
/// audio button, auto-plays on entry) above a row of three illustration
/// cards. Correct → green flash + CONTINUE enables; wrong → red flash,
/// shake and one heart lost (never below one).
class MatchImagePage extends StatefulWidget {
  const MatchImagePage({
    super.key,
    required this.exercise,
    required this.onSolved,
    required this.onAdvance,
  });

  final MatchImageExercise exercise;
  final VoidCallback onSolved;
  final VoidCallback onAdvance;

  @override
  State<MatchImagePage> createState() => _MatchImagePageState();
}

class _MatchImagePageState extends State<MatchImagePage> {
  bool _solved = false;
  int? _wrongIndex;
  Timer? _autoplayTimer;
  Timer? _wrongTimer;

  @override
  void initState() {
    super.initState();
    _autoplayTimer = Timer(const Duration(milliseconds: 380), () {
      AudioService.instance.playAsset(widget.exercise.audioFile);
    });
  }

  @override
  void dispose() {
    _autoplayTimer?.cancel();
    _wrongTimer?.cancel();
    super.dispose();
  }

  void _onOptionTap(int index) {
    if (_solved) return;
    final option = widget.exercise.options[index];
    if (option.isCorrect) {
      HapticFeedback.lightImpact();
      AudioService.instance.playAsset(widget.exercise.audioFile);
      setState(() {
        _solved = true;
        _wrongIndex = null;
      });
      widget.onSolved();
    } else {
      HapticFeedback.heavyImpact();
      loseHeartForgiving(context);
      setState(() => _wrongIndex = index);
      _wrongTimer?.cancel();
      _wrongTimer = Timer(const Duration(milliseconds: 700), () {
        if (mounted) setState(() => _wrongIndex = null);
      });
    }
  }

  OptionTileStatus _statusFor(int index) {
    final option = widget.exercise.options[index];
    if (_solved && option.isCorrect) return OptionTileStatus.correct;
    if (_wrongIndex == index) return OptionTileStatus.wrong;
    return OptionTileStatus.idle;
  }

  @override
  Widget build(BuildContext context) {
    final exercise = widget.exercise;
    return Column(
      children: <Widget>[
        const SizedBox(height: 8),
        const LessonHeading(text: LessonStrings.matchHeading),
        const Spacer(flex: 3),
        Center(child: _WordCard(exercise: exercise)),
        const Spacer(flex: 4),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: <Widget>[
              for (var i = 0; i < exercise.options.length; i++) ...<Widget>[
                if (i > 0) const SizedBox(width: 12),
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: ExerciseOptionCard(
                      option: exercise.options[i],
                      status: _statusFor(i),
                      onTap: () => _onOptionTap(i),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        const Spacer(flex: 2),
        LessonContinueBar(onContinue: _solved ? widget.onAdvance : null),
      ],
    );
  }
}

/// White soft-bordered card with the big Arabic word, a small audio button
/// and the blue tab peeking from below (prototype detail).
class _WordCard extends StatelessWidget {
  const _WordCard({required this.exercise});

  final MatchImageExercise exercise;

  @override
  Widget build(BuildContext context) {
    return PopIn(
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          LpCard(
            borderColor: LpColors.borderGray,
            borderWidth: 1.5,
            radius: 8,
            shadowColor: LpColors.borderGray,
            shadowOffset: const Offset(0, 5),
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  exercise.word,
                  textDirection: TextDirection.rtl,
                  style: LpTextStyles.arabicLarge.copyWith(fontSize: 54),
                ),
                const SizedBox(width: 20),
                AudioButton(
                  audioFile: exercise.audioFile,
                  variant: AudioButtonVariant.small,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: -17,
            child: Container(
              width: 10,
              height: 30,
              decoration: BoxDecoration(
                color: LpColors.royalBlue,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
