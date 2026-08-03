import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/services/audio_service.dart';
import '../../../core/theme/lp_colors.dart';
import '../../../core/theme/lp_text_styles.dart';
import '../../../core/widgets/audio_button.dart';
import '../../../core/widgets/lp_card.dart';
import '../../../data/models/exercise.dart';
import '../lesson_strings.dart';
import '../widgets/lesson_ui.dart';

/// "Repeat what you heard" (design LEVEL 1/18, LEVEL 2/15–18, LEVEL 3/19):
/// picture + Arabic word + speaker/snail buttons and a big microphone.
/// Tapping the mic animates a fake sound wave for ~1.6 s, then marks the
/// exercise solved — concept demo, no real speech recognition.
class RepeatAfterPage extends StatefulWidget {
  const RepeatAfterPage({
    super.key,
    required this.exercise,
    required this.onSolved,
    required this.onAdvance,
  });

  final RepeatAfterExercise exercise;
  final VoidCallback onSolved;
  final VoidCallback onAdvance;

  @override
  State<RepeatAfterPage> createState() => _RepeatAfterPageState();
}

class _RepeatAfterPageState extends State<RepeatAfterPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _wave = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  );

  bool _recording = false;
  bool _solved = false;
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
    _wave.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        setState(() {
          _recording = false;
          if (!_solved) {
            _solved = true;
            widget.onSolved();
          }
        });
        HapticFeedback.lightImpact();
      }
    });
  }

  @override
  void dispose() {
    _autoplayTimer?.cancel();
    _wave.dispose();
    super.dispose();
  }

  void _startRecording() {
    if (_recording) return;
    HapticFeedback.selectionClick();
    setState(() => _recording = true);
    _wave.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final exercise = widget.exercise;
    return Column(
      children: <Widget>[
        const SizedBox(height: 8),
        const LessonHeading(text: 'Repeat what you heard'),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(28, 18, 28, 8),
            child: Column(
              children: <Widget>[
                if (exercise.breakdown.isNotEmpty) ...<Widget>[
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Wrap(
                      spacing: 10,
                      children: <Widget>[
                        for (final tile in exercise.breakdown)
                          LpCard(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            shadowOffset: const Offset(0, 3),
                            child: Text(
                              tile.arabic,
                              textDirection: TextDirection.rtl,
                              style: LpTextStyles.arabicLarge.copyWith(
                                fontSize: 30,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                ],
                if (exercise.imageAsset != null || exercise.emoji != null)
                  LpCard(
                    borderWidth: 2.5,
                    shadowOffset: const Offset(0, 4),
                    padding: const EdgeInsets.all(14),
                    child: exercise.imageAsset != null
                        ? Image.asset(
                            'assets/images/${exercise.imageAsset}',
                            height: 130,
                            fit: BoxFit.contain,
                            errorBuilder: (_, _, _) => Text(
                              exercise.emoji ?? '🧱',
                              style: const TextStyle(fontSize: 64),
                            ),
                          )
                        : Text(
                            exercise.emoji!,
                            style: const TextStyle(fontSize: 64),
                          ),
                  ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    if (exercise.audioFile != null) ...<Widget>[
                      AudioButton(
                        audioFile: exercise.audioFile!,
                        variant: AudioButtonVariant.small,
                      ),
                      const SizedBox(width: 12),
                    ],
                    Text(
                      exercise.word,
                      textDirection: TextDirection.rtl,
                      style: LpTextStyles.arabicLarge,
                    ),
                  ],
                ),
                if (exercise.meaning != null)
                  Text(
                    exercise.meaning!,
                    style: LpTextStyles.body.copyWith(
                      color: LpColors.textGray,
                    ),
                  ),
                const SizedBox(height: 24),
                _MicButton(
                  recording: _recording,
                  solved: _solved,
                  wave: _wave,
                  onTap: _startRecording,
                ),
              ],
            ),
          ),
        ),
        LessonContinueBar(onContinue: _solved ? widget.onAdvance : null),
      ],
    );
  }
}

/// Big round mic button; animates concentric sound-wave arcs while
/// "recording" and turns green when done.
class _MicButton extends StatelessWidget {
  const _MicButton({
    required this.recording,
    required this.solved,
    required this.wave,
    required this.onTap,
  });

  final bool recording;
  final bool solved;
  final Animation<double> wave;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: LessonStrings.micSemantics,
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 26,
              child: recording
                  ? AnimatedBuilder(
                      animation: wave,
                      builder: (context, _) => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List<Widget>.generate(7, (i) {
                          final t = (wave.value * 6 + i) % 3;
                          final h = 6.0 + 16 * (t < 1.5 ? t / 1.5 : (3 - t) / 1.5);
                          return Container(
                            width: 4,
                            height: h,
                            margin: const EdgeInsets.symmetric(horizontal: 2.5),
                            decoration: BoxDecoration(
                              color: LpColors.legoGreen,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          );
                        }),
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: 6),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                color: solved
                    ? LpColors.legoGreen
                    : recording
                    ? LpColors.brickRed
                    : LpColors.bgWhite,
                shape: BoxShape.circle,
                border: Border.all(color: LpColors.ink, width: 3),
                boxShadow: const <BoxShadow>[
                  BoxShadow(color: LpColors.ink, offset: Offset(0, 4)),
                ],
              ),
              child: Icon(
                solved ? Icons.check_rounded : Icons.mic_rounded,
                size: 40,
                color: solved || recording ? LpColors.bgWhite : LpColors.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
