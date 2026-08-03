import 'dart:async';

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
import 'exercises/choice_exercise.dart';
import 'exercises/form_sentence_exercise.dart';
import 'exercises/interstitial_pages.dart';
import 'exercises/letter_forms_exercise.dart';
import 'exercises/letter_intro_exercise.dart';
import 'exercises/listen_choose_exercise.dart';
import 'exercises/listen_dialogue_exercise.dart';
import 'exercises/match_image_exercise.dart';
import 'exercises/multi_select_exercise.dart';
import 'exercises/place_diacritic_exercise.dart';
import 'exercises/press_reveal_exercise.dart';
import 'exercises/repeat_after_exercise.dart';
import 'exercises/teach_card_exercise.dart';
import 'exercises/trace_letter_exercise.dart';
import 'level_up_screen.dart';
import 'lesson_strings.dart';
import 'widgets/lesson_ui.dart';

/// Hosts a [Lesson]'s exercise sequence: X (confirm-quit) + live hearts +
/// stud progress bar on top, slide/fade transitions between exercises, and
/// the shared CONTINUE pattern (each page renders its own bar so the whole
/// page animates together). Build/trace show the "Awesome!" toast and
/// auto-advance; the rest gate on a correct answer. Tutorial / checkpoint
/// interstitials render full-bleed without the top bar. After the last
/// exercise → [LevelUpScreen].
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

  /// "Awesome! You nailed it!" toast shown between a completed build/trace
  /// and the next exercise.
  bool _toastVisible = false;
  Timer? _toastTimer;

  List<Exercise> get _exercises => widget.lesson.exercises;

  Color get _levelColor => widget.lesson.levelColor ?? LpColors.brandYellow;

  double get _progress => (_index + (_solved ? 1 : 0)) / _exercises.length;

  bool get _isInterstitial {
    final exercise = _exercises[_index];
    return exercise is TutorialStep || exercise is CheckpointStep;
  }

  @override
  void dispose() {
    _toastTimer?.cancel();
    AudioService.instance.stop();
    super.dispose();
  }

  void _markSolved() {
    if (!_solved) setState(() => _solved = true);
  }

  void _advance() {
    AudioService.instance.stop();
    _toastTimer?.cancel();
    setState(() => _toastVisible = false);
    if (_index + 1 >= _exercises.length) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => LevelUpScreen(lesson: widget.lesson),
        ),
      );
      return;
    }
    setState(() {
      _index++;
      _solved = false;
    });
  }

  /// Build completion: show the "Awesome!" banner only where the design has
  /// it (exercise.successToast), otherwise advance directly.
  void _advanceWithToast() {
    if (_toastVisible) return;
    final exercise = _exercises[_index];
    final wantsToast =
        exercise is BuildLetterExercise && exercise.successToast;
    if (!wantsToast) {
      _advance();
      return;
    }
    setState(() => _toastVisible = true);
    _toastTimer?.cancel();
    _toastTimer = Timer(const Duration(milliseconds: 1300), () {
      if (mounted) _advance();
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
      onCompleted: _advanceWithToast,
    ),
    final TraceLetterExercise e => TraceLetterPage(
      exercise: e,
      onSolved: _markSolved,
      onCompleted: _advanceWithToast,
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
    final TeachCardExercise e => TeachCardPage(
      exercise: e,
      levelColor: _levelColor,
      onAdvance: _advance,
    ),
    final PressRevealExercise e => PressRevealPage(
      exercise: e,
      levelColor: _levelColor,
      onAdvance: _advance,
    ),
    final LetterFormsExercise e => LetterFormsPage(
      exercise: e,
      levelColor: _levelColor,
      onAdvance: _advance,
    ),
    final ChoiceExercise e => ChoicePage(
      exercise: e,
      levelColor: _levelColor,
      onSolved: _markSolved,
      onAdvance: _advance,
    ),
    final MultiSelectExercise e => MultiSelectPage(
      exercise: e,
      onSolved: _markSolved,
      onAdvance: _advance,
    ),
    final FormSentenceExercise e => FormSentencePage(
      exercise: e,
      onSolved: _markSolved,
      onAdvance: _advance,
    ),
    final ListenDialogueExercise e => ListenDialoguePage(
      exercise: e,
      onSolved: _markSolved,
      onAdvance: _advance,
    ),
    final RepeatAfterExercise e => RepeatAfterPage(
      exercise: e,
      onSolved: _markSolved,
      onAdvance: _advance,
    ),
    final PlaceDiacriticExercise e => PlaceDiacriticPage(
      exercise: e,
      levelColor: _levelColor,
      onSolved: _markSolved,
      onAdvance: _advance,
    ),
    final TutorialStep e => TutorialPage(
      step: e,
      levelColor: _levelColor,
      onAdvance: _advance,
      onClose: _confirmQuit,
    ),
    final CheckpointStep e => CheckpointPage(
      step: e,
      levelColor: _levelColor,
      onAdvance: _advance,
      onClose: _confirmQuit,
    ),
  };

  @override
  Widget build(BuildContext context) {
    final hearts = context.watch<AppState>().hearts;
    final page = AnimatedSwitcher(
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
    );

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmQuit();
      },
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            // Interstitials paint full-bleed (they handle their own safe
            // area); exercises live under the shared top bar.
            if (_isInterstitial)
              Positioned.fill(child: page)
            else
              SafeArea(
                child: Column(
                  children: <Widget>[
                    ExerciseTopBar(
                      hearts: hearts,
                      progress: _progress,
                      onClose: _confirmQuit,
                    ),
                    Expanded(child: page),
                  ],
                ),
              ),
            if (_toastVisible)
              Align(
                alignment: const Alignment(0, -0.15),
                child: _SuccessToast(color: _levelColor),
              ),
          ],
        ),
      ),
    );
  }
}

/// "Awesome! You nailed it!" banner (design LEVEL 2/8, LEVEL 3/6):
/// full-width level-color band with a black border and hard shadow,
/// centered text, floating over the board.
class _SuccessToast extends StatelessWidget {
  const _SuccessToast({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: PopIn(
        duration: const Duration(milliseconds: 260),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 22),
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: LpColors.ink, width: 2.5),
            boxShadow: const <BoxShadow>[
              BoxShadow(color: LpColors.ink, offset: Offset(0, 4)),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                LessonStrings.toastTitle,
                textAlign: TextAlign.center,
                style: LpTextStyles.h2.copyWith(color: LpColors.bgWhite),
              ),
              Text(
                LessonStrings.toastSubtitle,
                textAlign: TextAlign.center,
                style: LpTextStyles.body.copyWith(color: LpColors.bgWhite),
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
