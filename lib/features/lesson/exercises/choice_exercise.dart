import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/services/audio_service.dart';
import '../../../core/theme/lp_colors.dart';
import '../../../core/theme/lp_text_styles.dart';
import '../../../core/widgets/audio_button.dart';
import '../../../core/widgets/brick_widget.dart';
import '../../../core/widgets/lp_card.dart';
import '../../../core/widgets/option_tile.dart';
import '../../../data/models/exercise.dart';
import '../widgets/lesson_ui.dart';

/// Generic single-choice exercise (design: true/false, choose the
/// pronunciation, complete the sentence, classify, choose the sentence you
/// hear, form the word, how many legos). Heading + optional prompt card +
/// optional audio row + options; wrong picks flash red and cost a heart.
class ChoicePage extends StatefulWidget {
  const ChoicePage({
    super.key,
    required this.exercise,
    required this.levelColor,
    required this.onSolved,
    required this.onAdvance,
  });

  final ChoiceExercise exercise;
  final Color levelColor;
  final VoidCallback onSolved;
  final VoidCallback onAdvance;

  @override
  State<ChoicePage> createState() => _ChoicePageState();
}

class _ChoicePageState extends State<ChoicePage> {
  bool _solved = false;
  int? _wrongIndex;
  Timer? _autoplayTimer;
  Timer? _wrongTimer;

  @override
  void initState() {
    super.initState();
    // Only play what the child can see a speaker button for. A prompt showing
    // an Arabic glyph draws no button (see _Prompt), and on "Choose the
    // pronunciation" that audio would just read the answer out loud.
    final prompt = widget.exercise.prompt;
    final audio =
        widget.exercise.audioFile ??
        (prompt?.arabic == null ? prompt?.audioFile : null);
    if (audio != null) {
      _autoplayTimer = Timer(const Duration(milliseconds: 380), () {
        AudioService.instance.playAsset(audio);
      });
    }
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
    if (_solved && widget.exercise.options[index].isCorrect) {
      return OptionTileStatus.correct;
    }
    if (_wrongIndex == index) return OptionTileStatus.wrong;
    return OptionTileStatus.idle;
  }

  @override
  Widget build(BuildContext context) {
    final exercise = widget.exercise;
    final prompt = exercise.prompt;
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
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
            child: Column(
              children: <Widget>[
                if (prompt != null) ...<Widget>[
                  _PromptCard(prompt: prompt, levelColor: widget.levelColor),
                  const SizedBox(height: 22),
                ],
                _OptionsGrid(
                  exercise: exercise,
                  statusFor: _statusFor,
                  onTap: _onOptionTap,
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

/// Prompt card: Arabic text / image / emoji / brick count, with optional
/// caption and inline audio.
class _PromptCard extends StatelessWidget {
  const _PromptCard({required this.prompt, required this.levelColor});

  final ChoicePrompt prompt;
  final Color levelColor;

  @override
  Widget build(BuildContext context) {
    final color = prompt.cardColor ?? levelColor;
    final textColor = LpColors.foregroundOn(color);

    Widget? content;
    if (prompt.brickCount != null) {
      content = Wrap(
        spacing: 14,
        runSpacing: 12,
        alignment: WrapAlignment.center,
        children: List<Widget>.generate(
          prompt.brickCount!,
          (i) => BrickWidget(
            color: LpColors
                .brickColors[i % LpColors.brickColors.length],
            unit: 26,
          ),
        ),
      );
    } else if (prompt.imageAsset != null) {
      content = Image.asset(
        'assets/images/${prompt.imageAsset}',
        height: 130,
        fit: BoxFit.contain,
        errorBuilder: (_, _, _) => const SizedBox(height: 60),
      );
    } else if (prompt.emoji != null) {
      content = Text(prompt.emoji!, style: const TextStyle(fontSize: 72));
    }

    final hasCard = prompt.arabic != null || content != null;
    return Column(
      children: <Widget>[
        if (hasCard)
          PopIn(
            child: LpCard(
              color: prompt.arabic != null ? color : LpColors.bgWhite,
              borderWidth: 3,
              shadowOffset: const Offset(0, 5),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 20,
              ),
              child: Column(
                children: <Widget>[
                  ?content,
                  if (prompt.arabic != null) ...<Widget>[
                    if (content != null) const SizedBox(height: 10),
                    Text(
                      prompt.arabic!,
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                      style: LpTextStyles.arabicLarge.copyWith(
                        color: prompt.arabic != null ? textColor : LpColors.ink,
                        fontSize: prompt.arabic!.length > 8 ? 30 : 44,
                      ),
                    ),
                  ],
                  if (prompt.latin != null)
                    Text(
                      prompt.latin!,
                      textAlign: TextAlign.center,
                      style: LpTextStyles.h2.copyWith(
                        color: prompt.arabic != null ? textColor : LpColors.ink,
                      ),
                    ),
                ],
              ),
            ),
          ),
        if (prompt.caption != null) ...<Widget>[
          const SizedBox(height: 10),
          Text(
            prompt.caption!,
            style: LpTextStyles.body.copyWith(color: LpColors.textGray),
          ),
        ],
        if (prompt.audioFile != null && prompt.arabic == null)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: AudioButton(
              audioFile: prompt.audioFile!,
              variant: AudioButtonVariant.small,
            ),
          ),
      ],
    );
  }
}

class _OptionsGrid extends StatelessWidget {
  const _OptionsGrid({
    required this.exercise,
    required this.statusFor,
    required this.onTap,
  });

  final ChoiceExercise exercise;
  final OptionTileStatus Function(int) statusFor;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final options = exercise.options;

    if (exercise.letterTiles) {
      return Wrap(
        spacing: 12,
        runSpacing: 12,
        alignment: WrapAlignment.center,
        children: <Widget>[
          for (var i = 0; i < options.length; i++)
            SizedBox(
              width: 76,
              height: 76,
              child: OptionTile(
                status: statusFor(i),
                onTap: () => onTap(i),
                padding: EdgeInsets.zero,
                child: Center(
                  child: Text(
                    options[i].letter ?? options[i].label ?? '',
                    textDirection: TextDirection.rtl,
                    style: LpTextStyles.tileLetter.copyWith(fontSize: 30),
                  ),
                ),
              ),
            ),
        ],
      );
    }

    if (exercise.columns <= 1) {
      return Column(
        children: <Widget>[
          for (var i = 0; i < options.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: OptionTile(
                status: statusFor(i),
                onTap: () => onTap(i),
                child: _optionContent(options[i], center: true),
              ),
            ),
        ],
      );
    }

    final columns = exercise.columns;
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 12.0;
        final width =
            (constraints.maxWidth - gap * (columns - 1)) / columns;
        final hasVisual = options.any(
          (o) => o.imageAsset != null || o.emoji != null,
        );
        final height = hasVisual ? math.max(width * 0.92, 120.0) : 76.0;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: <Widget>[
            for (var i = 0; i < options.length; i++)
              SizedBox(
                width: width,
                height: height,
                child: OptionTile(
                  status: statusFor(i),
                  onTap: () => onTap(i),
                  padding: const EdgeInsets.all(8),
                  child: Center(child: _optionContent(options[i])),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _optionContent(ExerciseOption option, {bool center = false}) {
    if (option.brickCount != null) {
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.center,
        children: List<Widget>.generate(
          option.brickCount!,
          (_) => const BrickWidget(color: LpColors.brandYellow, unit: 20),
        ),
      );
    }
    if (option.imageAsset != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Image.asset(
              'assets/images/${option.imageAsset}',
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) =>
                  Text(option.emoji ?? '🧱', style: const TextStyle(fontSize: 44)),
            ),
          ),
          if (option.label != null)
            Text(option.label!, style: LpTextStyles.caption),
        ],
      );
    }
    if (option.emoji != null) {
      return Text(option.emoji!, style: const TextStyle(fontSize: 48));
    }
    final text = option.letter ?? option.label ?? '';
    final isArabic = option.letter != null;
    return SizedBox(
      width: center ? double.infinity : null,
      child: Text(
        text,
        textAlign: TextAlign.center,
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        style: isArabic
            ? LpTextStyles.arabicLarge.copyWith(fontSize: 24, height: 1.4)
            : LpTextStyles.body.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}
