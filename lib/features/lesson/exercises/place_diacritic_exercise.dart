import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/lp_colors.dart';
import '../../../core/theme/lp_text_styles.dart';
import '../../../data/models/exercise.dart';
import '../widgets/lesson_ui.dart';

/// "Place the Fatha in the correct location" (design LEVEL 2/16): the mark
/// sits in a tray and must be dragged (or tapped) onto the correct dotted
/// slot above/below the base letter. Wrong slot flashes red and costs a
/// heart.
class PlaceDiacriticPage extends StatefulWidget {
  const PlaceDiacriticPage({
    super.key,
    required this.exercise,
    required this.levelColor,
    required this.onSolved,
    required this.onAdvance,
  });

  final PlaceDiacriticExercise exercise;
  final Color levelColor;
  final VoidCallback onSolved;
  final VoidCallback onAdvance;

  @override
  State<PlaceDiacriticPage> createState() => _PlaceDiacriticPageState();
}

class _PlaceDiacriticPageState extends State<PlaceDiacriticPage> {
  bool _solved = false;
  bool _wrongAbove = false;
  bool _wrongBelow = false;
  Timer? _wrongTimer;

  // No audio here: the screen has no speaker button, and sound should only ever
  // come from pressing one.

  @override
  void dispose() {
    _wrongTimer?.cancel();
    super.dispose();
  }

  void _drop(bool above) {
    if (_solved) return;
    if (above == widget.exercise.slotAbove) {
      HapticFeedback.lightImpact();
      setState(() => _solved = true);
      widget.onSolved();
    } else {
      HapticFeedback.heavyImpact();
      loseHeartForgiving(context);
      setState(() {
        _wrongAbove = above;
        _wrongBelow = !above;
      });
      _wrongTimer?.cancel();
      _wrongTimer = Timer(const Duration(milliseconds: 700), () {
        if (mounted) {
          setState(() {
            _wrongAbove = false;
            _wrongBelow = false;
          });
        }
      });
    }
  }

  Widget _slot({required bool above}) {
    final exercise = widget.exercise;
    final isCorrect = above == exercise.slotAbove;
    final showMark = _solved && isCorrect;
    final wrong = above ? _wrongAbove : _wrongBelow;
    return DragTarget<bool>(
      onAcceptWithDetails: (_) => _drop(above),
      builder: (context, candidates, rejected) {
        final hovering = candidates.isNotEmpty;
        return GestureDetector(
          onTap: () => _drop(above),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 74,
            height: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: showMark
                  ? LpColors.lighten(LpColors.legoGreen, 0.82)
                  : wrong
                  ? LpColors.lighten(LpColors.brickRed, 0.86)
                  : hovering
                  ? LpColors.lighten(widget.levelColor, 0.8)
                  : LpColors.bgWhite,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: showMark
                    ? LpColors.legoGreen
                    : wrong
                    ? LpColors.brickRed
                    : LpColors.borderGray,
                width: 2,
              ),
            ),
            child: showMark
                ? Text(
                    exercise.mark,
                    textDirection: TextDirection.rtl,
                    style: LpTextStyles.arabicLarge.copyWith(fontSize: 30),
                  )
                : CustomPaint(
                    size: const Size(50, 3),
                    painter: _DottedLinePainter(),
                  ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final exercise = widget.exercise;
    return Column(
      children: <Widget>[
        const SizedBox(height: 8),
        LessonHeading(
          text: 'Place the ${_markName(exercise)} in the correct location',
        ),
        const Spacer(),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 40),
          padding: const EdgeInsets.symmetric(vertical: 26),
          width: double.infinity,
          decoration: BoxDecoration(
            color: widget.levelColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: LpColors.ink, width: 3),
            boxShadow: const <BoxShadow>[
              BoxShadow(color: LpColors.ink, offset: Offset(0, 5)),
            ],
          ),
          child: Column(
            children: <Widget>[
              _slot(above: true),
              Text(
                exercise.baseGlyph,
                textDirection: TextDirection.rtl,
                style: LpTextStyles.arabicGiant.copyWith(
                  fontSize: 110,
                  height: 1.1,
                  color: LpColors.foregroundOn(widget.levelColor),
                ),
              ),
              _slot(above: false),
            ],
          ),
        ),
        const Spacer(),
        if (!_solved)
          Draggable<bool>(
            data: true,
            feedback: Material(
              color: Colors.transparent,
              child: _MarkTile(mark: exercise.mark),
            ),
            childWhenDragging: Opacity(
              opacity: 0.3,
              child: _MarkTile(mark: exercise.mark),
            ),
            child: _MarkTile(mark: exercise.mark),
          )
        else
          const SizedBox(height: 74),
        const Spacer(),
        LessonContinueBar(onContinue: _solved ? widget.onAdvance : null),
      ],
    );
  }

  static String _markName(PlaceDiacriticExercise exercise) => 'Fatha';
}

/// The draggable tashkeel tile in the tray.
class _MarkTile extends StatelessWidget {
  const _MarkTile({required this.mark});

  final String mark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 74,
      height: 74,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: LpColors.brandYellow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: LpColors.ink, width: 2.5),
        boxShadow: const <BoxShadow>[
          BoxShadow(color: LpColors.ink, offset: Offset(0, 4)),
        ],
      ),
      child: Text(
        mark,
        textDirection: TextDirection.rtl,
        style: LpTextStyles.arabicLarge.copyWith(fontSize: 34),
      ),
    );
  }
}

class _DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = LpColors.textGray
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;
    const dash = 5.0;
    const gapWidth = 5.0;
    var x = 0.0;
    while (x < size.width) {
      canvas.drawLine(
        Offset(x, size.height / 2),
        Offset((x + dash).clamp(0, size.width), size.height / 2),
        paint,
      );
      x += dash + gapWidth;
    }
  }

  @override
  bool shouldRepaint(_DottedLinePainter oldDelegate) => false;
}
