import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/services/audio_service.dart';
import '../../core/theme/lp_colors.dart';
import '../../core/theme/lp_text_styles.dart';
import '../../core/widgets/exercise_top_bar.dart';
import '../../core/widgets/lp_button.dart';
import '../../core/widgets/lp_card.dart';
import '../../data/models/exercise.dart';
import '../../data/models/lesson.dart';
import '../../state/app_state.dart';
import 'exercises/build_letter_exercise.dart';
import 'exercises/letter_intro_exercise.dart';
import 'exercises/listen_choose_exercise.dart';
import 'exercises/match_image_exercise.dart';
import 'exercises/trace_letter_exercise.dart';
import 'lesson_complete_screen.dart';
import 'lesson_strings.dart';

/// Hosts a [Lesson]'s exercise sequence: X (confirm-quit) + live hearts +
/// stud progress bar on top, slide/fade transitions between exercises, and
/// the shared CONTINUE pattern (each page renders its own bar so the whole
/// page animates together). Build/trace auto-advance; the rest gate on a
/// correct answer. After the last exercise → [LessonCompleteScreen].
class LessonFlowScreen extends StatefulWidget {
  const LessonFlowScreen({super.key, required this.lesson});

  final Lesson lesson;

  @override
  State<LessonFlowScreen> createState() => _LessonFlowScreenState();
}

class _LessonFlowScreenState extends State<LessonFlowScreen> {
  int _index = 0;

  /// Whether the current exercise has been solved — bumps the progress bar
  /// one stud-segment ahead of [_index] (letter intros never set this, so
  /// the bar starts empty and ends full on the last correct answer).
  bool _solved = false;

  List<Exercise> get _exercises => widget.lesson.exercises;

  double get _progress => (_index + (_solved ? 1 : 0)) / _exercises.length;

  @override
  void dispose() {
    AudioService.instance.stop();
    super.dispose();
  }

  void _markSolved() {
    if (!_solved) setState(() => _solved = true);
  }

  void _advance() {
    AudioService.instance.stop();
    if (_index + 1 >= _exercises.length) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => LessonCompleteScreen(lesson: widget.lesson),
        ),
      );
      return;
    }
    setState(() {
      _index++;
      _solved = false;
    });
  }

  Future<void> _confirmQuit() async {
    final quit = await showDialog<bool>(
      context: context,
      builder: (_) => const _QuitDialog(),
    );
    if ((quit ?? false) && mounted) Navigator.of(context).pop();
  }

  Widget _pageFor(Exercise exercise) => switch (exercise) {
    final LetterIntroExercise e => LetterIntroPage(
      exercise: e,
      onAdvance: _advance,
    ),
    final BuildLetterExercise e => BuildLetterPage(
      exercise: e,
      onSolved: _markSolved,
      onCompleted: _advance,
    ),
    final TraceLetterExercise e => TraceLetterPage(
      exercise: e,
      onSolved: _markSolved,
      onCompleted: _advance,
    ),
    final MatchImageExercise e => MatchImagePage(
      exercise: e,
      onSolved: _markSolved,
      onAdvance: _advance,
    ),
    final ListenChooseExercise e => ListenChoosePage(
      exercise: e,
      onSolved: _markSolved,
      onAdvance: _advance,
    ),
  };

  @override
  Widget build(BuildContext context) {
    final hearts = context.watch<AppState>().hearts;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmQuit();
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: <Widget>[
              ExerciseTopBar(
                hearts: hearts,
                progress: _progress,
                onClose: _confirmQuit,
              ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 320),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.12, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  ),
                  child: KeyedSubtree(
                    key: ValueKey<int>(_index),
                    child: _pageFor(_exercises[_index]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Brand-style confirm-quit dialog ("Wait, don't go!").
class _QuitDialog extends StatelessWidget {
  const _QuitDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      child: LpCard(
        borderWidth: 3,
        radius: 16,
        shadowOffset: const Offset(0, 5),
        padding: const EdgeInsets.fromLTRB(22, 24, 22, 22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              LessonStrings.quitTitle,
              textAlign: TextAlign.center,
              style: LpTextStyles.h2,
            ),
            const SizedBox(height: 6),
            Text(
              LessonStrings.quitBody,
              textAlign: TextAlign.center,
              style: LpTextStyles.body.copyWith(color: LpColors.textGray),
            ),
            const SizedBox(height: 20),
            LpButton(
              label: LessonStrings.keepGoing,
              onPressed: () => Navigator.of(context).pop(false),
            ),
            const SizedBox(height: 12),
            LpButton(
              label: LessonStrings.quitLesson,
              style: LpButtonStyle.neutral,
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        ),
      ),
    );
  }
}
