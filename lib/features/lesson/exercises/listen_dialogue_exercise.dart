import 'package:flutter/material.dart';

import '../../../core/services/audio_service.dart';
import '../../../core/theme/lp_colors.dart';
import '../../../core/theme/lp_text_styles.dart';
import '../../../core/widgets/mascot_image.dart';
import '../../../data/models/exercise.dart';
import '../widgets/lesson_ui.dart';

/// "Listen to the dialogue" (design LEVEL 5/2): two characters converse,
/// each speech bubble has its own play button. CONTINUE enables after any
/// bubble was played (or immediately when a line has no bundled audio).
class ListenDialoguePage extends StatefulWidget {
  const ListenDialoguePage({
    super.key,
    required this.exercise,
    required this.onSolved,
    required this.onAdvance,
  });

  final ListenDialogueExercise exercise;
  final VoidCallback onSolved;
  final VoidCallback onAdvance;

  @override
  State<ListenDialoguePage> createState() => _ListenDialoguePageState();
}

class _ListenDialoguePageState extends State<ListenDialoguePage> {
  bool _played = false;

  @override
  void initState() {
    super.initState();
    if (widget.exercise.lines.every((l) => l.audioFile == null)) {
      _played = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => widget.onSolved());
    }
  }

  void _play(DialogueLine line) {
    if (line.audioFile != null) {
      AudioService.instance.playAsset(line.audioFile!);
    }
    if (!_played) {
      setState(() => _played = true);
      widget.onSolved();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 8),
        const LessonHeading(text: 'Listen to the dialogue'),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
            children: <Widget>[
              for (final line in widget.exercise.lines)
                Padding(
                  padding: const EdgeInsets.only(bottom: 26),
                  child: _DialogueRow(line: line, onPlay: () => _play(line)),
                ),
            ],
          ),
        ),
        LessonContinueBar(onContinue: _played ? widget.onAdvance : null),
      ],
    );
  }
}

class _DialogueRow extends StatelessWidget {
  const _DialogueRow({required this.line, required this.onPlay});

  final DialogueLine line;
  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) {
    final portrait = line.speakerAsset == null
        ? const SizedBox(width: 64)
        : MascotImage(asset: line.speakerAsset!, height: 120, width: 90);

    final bubble = Expanded(
      child: GestureDetector(
        onTap: onPlay,
        child: Container(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          decoration: BoxDecoration(
            color: LpColors.tileGray,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(14),
              topRight: const Radius.circular(14),
              bottomLeft: Radius.circular(line.alignEnd ? 14 : 2),
              bottomRight: Radius.circular(line.alignEnd ? 2 : 14),
            ),
            border: Border.all(color: LpColors.borderGray),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                line.text,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                style: LpTextStyles.arabicLarge.copyWith(
                  fontSize: 20,
                  height: 1.6,
                ),
              ),
              if (line.audioFile != null)
                Align(
                  alignment: Alignment.centerLeft,
                  child: _MiniPlayButton(onTap: onPlay),
                ),
            ],
          ),
        ),
      ),
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: line.alignEnd
          ? <Widget>[bubble, const SizedBox(width: 8), portrait]
          : <Widget>[portrait, const SizedBox(width: 8), bubble],
    );
  }
}

/// Small yellow round play button inside a speech bubble.
class _MiniPlayButton extends StatelessWidget {
  const _MiniPlayButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: LpColors.brandYellow,
          shape: BoxShape.circle,
          border: Border.all(color: LpColors.ink, width: 2),
        ),
        child: const Icon(Icons.volume_up_rounded, size: 19, color: LpColors.ink),
      ),
    );
  }
}
