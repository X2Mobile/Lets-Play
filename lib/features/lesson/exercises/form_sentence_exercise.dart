import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/services/audio_service.dart';
import '../../../core/theme/lp_colors.dart';
import '../../../core/theme/lp_text_styles.dart';
import '../../../core/widgets/audio_button.dart';
import '../../../data/models/exercise.dart';
import '../widgets/lesson_ui.dart';

/// "Form the sentence" (design LEVEL 5/3, 5–8, 11): tap shuffled word tiles
/// to move them onto the dotted answer line in the right RTL order. Tapping
/// a placed word returns it to the tray. Solved when the line reads the
/// correct sentence.
class FormSentencePage extends StatefulWidget {
  const FormSentencePage({
    super.key,
    required this.exercise,
    required this.onSolved,
    required this.onAdvance,
  });

  final FormSentenceExercise exercise;
  final VoidCallback onSolved;
  final VoidCallback onAdvance;

  @override
  State<FormSentencePage> createState() => _FormSentencePageState();
}

class _FormSentencePageState extends State<FormSentencePage> {
  late final List<String> _tray;
  final List<String> _placed = <String>[];
  bool _solved = false;
  bool _wrongFlash = false;
  Timer? _autoplayTimer;
  Timer? _wrongTimer;

  @override
  void initState() {
    super.initState();
    // Deterministic shuffle: reversed + distractors interleaved, so the tray
    // never starts in the solved order.
    _tray = <String>[
      ...widget.exercise.words.reversed,
      ...widget.exercise.distractors,
    ];
    if (_trayIsSolvedOrder()) _tray.shuffle();
    final audio = widget.exercise.audioFile;
    if (audio != null) {
      _autoplayTimer = Timer(const Duration(milliseconds: 380), () {
        AudioService.instance.playAsset(audio);
      });
    }
  }

  bool _trayIsSolvedOrder() {
    final words = widget.exercise.words;
    if (_tray.length < words.length) return false;
    for (var i = 0; i < words.length; i++) {
      if (_tray[i] != words[i]) return false;
    }
    return true;
  }

  @override
  void dispose() {
    _autoplayTimer?.cancel();
    _wrongTimer?.cancel();
    super.dispose();
  }

  void _place(String word) {
    if (_solved) return;
    HapticFeedback.selectionClick();
    setState(() {
      _tray.remove(word);
      _placed.add(word);
    });
    _check();
  }

  void _takeBack(String word) {
    if (_solved) return;
    setState(() {
      _placed.remove(word);
      _tray.add(word);
    });
  }

  void _check() {
    final words = widget.exercise.words;
    if (_placed.length != words.length) return;
    var correct = true;
    for (var i = 0; i < words.length; i++) {
      if (_placed[i] != words[i]) {
        correct = false;
        break;
      }
    }
    if (correct) {
      HapticFeedback.lightImpact();
      setState(() => _solved = true);
      widget.onSolved();
    } else {
      HapticFeedback.heavyImpact();
      loseHeartForgiving(context);
      setState(() => _wrongFlash = true);
      _wrongTimer?.cancel();
      _wrongTimer = Timer(const Duration(milliseconds: 800), () {
        if (!mounted) return;
        setState(() {
          _wrongFlash = false;
          _tray.addAll(_placed);
          _placed.clear();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final exercise = widget.exercise;
    return Column(
      children: <Widget>[
        const SizedBox(height: 8),
        LessonHeading(text: exercise.heading),
        if (exercise.audioFile != null) ...<Widget>[
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              AudioButton(audioFile: exercise.audioFile!),
              const SizedBox(width: 16),
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: AudioButton(
                  audioFile: exercise.audioFile!,
                  variant: AudioButtonVariant.small,
                  rate: 0.6,
                ),
              ),
            ],
          ),
        ],
        const Spacer(),
        // Answer line (RTL like the design).
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: <Widget>[
              Directionality(
                textDirection: TextDirection.rtl,
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  children: <Widget>[
                    for (final word in _placed)
                      _WordTile(
                        word: word,
                        state: _solved
                            ? _WordTileState.correct
                            : _wrongFlash
                            ? _WordTileState.wrong
                            : _WordTileState.placed,
                        onTap: () => _takeBack(word),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: 2,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: LpColors.borderGray,
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        // Tray.
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: <Widget>[
                for (final word in _tray)
                  _WordTile(
                    word: word,
                    state: _WordTileState.tray,
                    onTap: () => _place(word),
                  ),
              ],
            ),
          ),
        ),
        const Spacer(),
        LessonContinueBar(onContinue: _solved ? widget.onAdvance : null),
      ],
    );
  }
}

enum _WordTileState { tray, placed, correct, wrong }

/// Gray word tile per the design; green/red flash on submit.
class _WordTile extends StatelessWidget {
  const _WordTile({required this.word, required this.state, this.onTap});

  final String word;
  final _WordTileState state;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final (Color fill, Color border, Color text) = switch (state) {
      _WordTileState.tray => (
        LpColors.tileGray,
        LpColors.borderGray,
        LpColors.ink,
      ),
      _WordTileState.placed => (
        LpColors.bgWhite,
        LpColors.ink,
        LpColors.ink,
      ),
      _WordTileState.correct => (
        LpColors.lighten(LpColors.legoGreen, 0.82),
        LpColors.legoGreen,
        LpColors.ink,
      ),
      _WordTileState.wrong => (
        LpColors.lighten(LpColors.brickRed, 0.86),
        LpColors.brickRed,
        LpColors.ink,
      ),
    };
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: fill,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: border,
            width: state == _WordTileState.tray ? 1 : 2,
          ),
          boxShadow: const <BoxShadow>[
            BoxShadow(color: LpColors.borderGray, offset: Offset(0, 3)),
          ],
        ),
        child: Text(
          word,
          textDirection: TextDirection.rtl,
          style: LpTextStyles.arabicLarge.copyWith(fontSize: 22, color: text),
        ),
      ),
    );
  }
}
