import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/lp_text_styles.dart';
import '../../../core/widgets/option_tile.dart';
import '../../../data/models/exercise.dart';
import '../widgets/lesson_ui.dart';

/// Multi-select drill (design LEVEL 4/3 "Choose all the Nouns"): tap every
/// correct tile; wrong taps flash red and cost a heart. Solved when all
/// correct tiles are selected.
class MultiSelectPage extends StatefulWidget {
  const MultiSelectPage({
    super.key,
    required this.exercise,
    required this.onSolved,
    required this.onAdvance,
  });

  final MultiSelectExercise exercise;
  final VoidCallback onSolved;
  final VoidCallback onAdvance;

  @override
  State<MultiSelectPage> createState() => _MultiSelectPageState();
}

class _MultiSelectPageState extends State<MultiSelectPage> {
  final Set<int> _picked = <int>{};
  int? _wrongIndex;
  bool _solved = false;
  Timer? _wrongTimer;

  @override
  void dispose() {
    _wrongTimer?.cancel();
    super.dispose();
  }

  void _onTap(int index) {
    if (_solved || _picked.contains(index)) return;
    final option = widget.exercise.options[index];
    if (option.isCorrect) {
      HapticFeedback.lightImpact();
      setState(() => _picked.add(index));
      final allCorrectPicked = <int>[
        for (var i = 0; i < widget.exercise.options.length; i++)
          if (widget.exercise.options[i].isCorrect) i,
      ].every(_picked.contains);
      if (allCorrectPicked) {
        setState(() => _solved = true);
        widget.onSolved();
      }
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
    if (_picked.contains(index)) {
      return _solved ? OptionTileStatus.correct : OptionTileStatus.selected;
    }
    if (_wrongIndex == index) return OptionTileStatus.wrong;
    return OptionTileStatus.idle;
  }

  @override
  Widget build(BuildContext context) {
    final exercise = widget.exercise;
    final columns = exercise.columns;
    return Column(
      children: <Widget>[
        const SizedBox(height: 8),
        LessonHeading(text: exercise.heading),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 22, 24, 8),
            child: LayoutBuilder(
              builder: (context, constraints) {
                const gap = 12.0;
                final width =
                    (constraints.maxWidth - gap * (columns - 1)) / columns;
                return Wrap(
                  spacing: gap,
                  runSpacing: gap,
                  children: <Widget>[
                    for (var i = 0; i < exercise.options.length; i++)
                      SizedBox(
                        width: width,
                        height: 74,
                        child: OptionTile(
                          status: _statusFor(i),
                          onTap: () => _onTap(i),
                          padding: EdgeInsets.zero,
                          child: Center(
                            child: Text(
                              exercise.options[i].letter ??
                                  exercise.options[i].label ??
                                  '',
                              textDirection:
                                  exercise.options[i].letter != null
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                              style: exercise.options[i].letter != null
                                  ? LpTextStyles.arabicLarge.copyWith(
                                      fontSize: 24,
                                    )
                                  : LpTextStyles.body,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
        LessonContinueBar(onContinue: _solved ? widget.onAdvance : null),
      ],
    );
  }
}
