import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/lp_colors.dart';
import '../theme/lp_text_styles.dart';

/// Visual state of an [OptionTile].
enum OptionTileStatus {
  /// Quiet gray tile — 1 px gray border, gray text, no shadow.
  idle,

  /// Picked answer — yellow fill, black border, hard shadow.
  selected,

  /// Correct answer flash — green border.
  correct,

  /// Wrong answer flash — red border + shake (loses a heart in exercises).
  wrong,
}

/// Tappable answer tile used in onboarding and (later) in exercises.
///
/// Provide [label] for a text row, or a custom [child] (e.g. a big emoji
/// illustration) for exercise option cards.
class OptionTile extends StatefulWidget {
  const OptionTile({
    super.key,
    required this.status,
    this.onTap,
    this.label,
    this.child,
    this.height,
    this.padding = const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
  }) : assert(label != null || child != null, 'Provide a label or a child');

  final OptionTileStatus status;
  final VoidCallback? onTap;
  final String? label;
  final Widget? child;
  final double? height;
  final EdgeInsetsGeometry padding;

  @override
  State<OptionTile> createState() => _OptionTileState();
}

class _OptionTileState extends State<OptionTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shakeController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
  );

  @override
  void didUpdateWidget(OptionTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.status == OptionTileStatus.wrong &&
        oldWidget.status != OptionTileStatus.wrong) {
      _shakeController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final (
      Color fill,
      Border border,
      bool shadow,
      Color textColor,
    ) = switch (widget.status) {
      OptionTileStatus.idle => (
        LpColors.tileGray,
        Border.all(color: LpColors.borderGray),
        false,
        LpColors.textGray,
      ),
      OptionTileStatus.selected => (
        LpColors.brandYellow,
        Border.all(color: LpColors.ink, width: 2.5),
        true,
        LpColors.ink,
      ),
      OptionTileStatus.correct => (
        LpColors.lighten(LpColors.legoGreen, 0.82),
        Border.all(color: LpColors.legoGreen, width: 3),
        false,
        LpColors.ink,
      ),
      OptionTileStatus.wrong => (
        LpColors.lighten(LpColors.brickRed, 0.86),
        Border.all(color: LpColors.brickRed, width: 3),
        false,
        LpColors.ink,
      ),
    };

    final tile = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      height: widget.height,
      width: double.infinity,
      padding: widget.padding,
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(10),
        border: border,
        boxShadow: shadow
            ? const <BoxShadow>[
                BoxShadow(color: LpColors.ink, offset: Offset(0, 3)),
              ]
            : null,
      ),
      child:
          widget.child ??
          Text(
            widget.label!,
            style: LpTextStyles.body.copyWith(
              color: textColor,
              fontWeight: FontWeight.w700,
            ),
          ),
    );

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _shakeController,
        builder: (context, child) {
          final t = _shakeController.value;
          final dx = math.sin(t * math.pi * 4) * 7 * (1 - t);
          return Transform.translate(offset: Offset(dx, 0), child: child);
        },
        child: tile,
      ),
    );
  }
}
