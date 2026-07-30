import 'package:flutter/material.dart';

import '../theme/lp_colors.dart';
import '../theme/lp_text_styles.dart';

/// Visual style of an enabled [LpButton].
enum LpButtonStyle {
  /// Brand-yellow fill — the main CTA (`CONTINUE`).
  primary,

  /// Light neutral fill with black border (`Sign in`).
  neutral,
}

/// Chunky toy button: solid fill, black border, hard shadow that the button
/// "presses into" on tap. Pass `onPressed: null` for the quiet gray
/// disabled state (no black border, no shadow).
class LpButton extends StatefulWidget {
  const LpButton({
    super.key,
    required this.label,
    this.onPressed,
    this.style = LpButtonStyle.primary,
    this.uppercase = true,
    this.expand = true,
    this.leading,
    this.height = 56,
  });

  final String label;
  final VoidCallback? onPressed;
  final LpButtonStyle style;

  /// Uppercases the label and applies wide tracking (buttons per spec).
  final bool uppercase;

  /// Stretches to the parent's width.
  final bool expand;

  /// Optional widget before the label (e.g. a Facebook badge).
  final Widget? leading;
  final double height;

  @override
  State<LpButton> createState() => _LpButtonState();
}

class _LpButtonState extends State<LpButton> {
  bool _pressed = false;

  bool get _enabled => widget.onPressed != null;

  static const Offset _shadowOffset = Offset(0, 4);

  @override
  Widget build(BuildContext context) {
    final Color fill;
    final Color textColor;
    if (!_enabled) {
      fill = LpColors.tileGray;
      textColor = LpColors.textGray;
    } else {
      fill = widget.style == LpButtonStyle.primary
          ? LpColors.brandYellow
          : LpColors.bgWhite;
      textColor = LpColors.ink;
    }

    final label = Text(
      widget.uppercase ? widget.label.toUpperCase() : widget.label,
      textAlign: TextAlign.center,
      style: LpTextStyles.button.copyWith(
        color: textColor,
        letterSpacing: widget.uppercase ? 1.5 : 0.4,
      ),
    );

    final showShadow = _enabled && !_pressed;

    return GestureDetector(
      onTapDown: _enabled ? (_) => setState(() => _pressed = true) : null,
      onTapCancel: _enabled ? () => setState(() => _pressed = false) : null,
      onTapUp: _enabled
          ? (_) {
              setState(() => _pressed = false);
              widget.onPressed?.call();
            }
          : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        height: widget.height,
        width: widget.expand ? double.infinity : null,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        transform: Matrix4.translationValues(
          0,
          _pressed ? _shadowOffset.dy : 0,
          0,
        ),
        decoration: BoxDecoration(
          color: fill,
          borderRadius: BorderRadius.circular(12),
          border: _enabled
              ? Border.all(color: LpColors.ink, width: 2.5)
              : Border.all(color: LpColors.borderGray),
          boxShadow: showShadow
              ? const <BoxShadow>[
                  BoxShadow(color: LpColors.ink, offset: _shadowOffset),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: widget.expand ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (widget.leading != null) ...<Widget>[
              widget.leading!,
              const SizedBox(width: 10),
            ],
            Flexible(child: label),
          ],
        ),
      ),
    );
  }
}
