import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/services/audio_service.dart';
import '../../../core/theme/lp_colors.dart';
import '../../../core/widgets/audio_button.dart';
import '../../../core/widgets/option_tile.dart';
import '../../../data/models/exercise.dart';
import '../lesson_strings.dart';
import '../widgets/lesson_ui.dart';

/// Exercise 5 — "Choose what you heard": big audio button (auto-plays on
/// entry) + snail slow-play button (same clip at 0.6×), then a 2×2 grid of
/// emoji / letter option cards with the shared right/wrong behavior.
class ListenChoosePage extends StatefulWidget {
  const ListenChoosePage({
    super.key,
    required this.exercise,
    required this.onSolved,
    required this.onAdvance,
  });

  final ListenChooseExercise exercise;
  final VoidCallback onSolved;
  final VoidCallback onAdvance;

  @override
  State<ListenChoosePage> createState() => _ListenChoosePageState();
}

class _ListenChoosePageState extends State<ListenChoosePage> {
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

  Widget _tile(int index, double side) {
    return SizedBox(
      width: side,
      height: side,
      child: ExerciseOptionCard(
        option: widget.exercise.options[index],
        status: _statusFor(index),
        onTap: () => _onOptionTap(index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final exercise = widget.exercise;
    return Column(
      children: <Widget>[
        const SizedBox(height: 8),
        const LessonHeading(text: LessonStrings.listenHeading),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            AudioButton(audioFile: exercise.audioFile),
            const SizedBox(width: 16),
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: _SnailButton(audioFile: exercise.audioFile),
            ),
          ],
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              const gap = 14.0;
              final side = math
                  .min(
                    (constraints.maxWidth - 40 - gap) / 2,
                    (constraints.maxHeight - gap - 24) / 2,
                  )
                  .clamp(64.0, 180.0);
              final count = exercise.options.length;
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    for (var row = 0; row * 2 < count; row++) ...<Widget>[
                      if (row > 0) const SizedBox(height: gap),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          for (
                            var i = row * 2;
                            i < math.min(row * 2 + 2, count);
                            i++
                          ) ...<Widget>[
                            if (i.isOdd) const SizedBox(width: gap),
                            _tile(i, side),
                          ],
                        ],
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
        LessonContinueBar(onContinue: _solved ? widget.onAdvance : null),
      ],
    );
  }
}

/// Small white bordered square with a 🐌 — replays the clip at 0.6×.
class _SnailButton extends StatefulWidget {
  const _SnailButton({required this.audioFile});

  final String audioFile;

  @override
  State<_SnailButton> createState() => _SnailButtonState();
}

class _SnailButtonState extends State<_SnailButton> {
  static const Offset _shadowOffset = Offset(0, 3);

  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: LessonStrings.slowPlaySemantics,
      button: true,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) {
          setState(() => _pressed = false);
          AudioService.instance.playAsset(widget.audioFile, rate: 0.6);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 80),
          width: 52,
          height: 52,
          alignment: Alignment.center,
          transform: Matrix4.translationValues(
            0,
            _pressed ? _shadowOffset.dy : 0,
            0,
          ),
          decoration: BoxDecoration(
            color: LpColors.bgWhite,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: LpColors.ink, width: 2.5),
            boxShadow: _pressed
                ? null
                : const <BoxShadow>[
                    BoxShadow(color: LpColors.ink, offset: _shadowOffset),
                  ],
          ),
          child: const Text('🐌', style: TextStyle(fontSize: 24, height: 1)),
        ),
      ),
    );
  }
}
