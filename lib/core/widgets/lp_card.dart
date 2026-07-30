import 'package:flutter/material.dart';

import '../theme/lp_colors.dart';

/// Neo-brutalist toy card: solid fill, thick black border, hard zero-blur
/// offset shadow. The building block of every branded surface.
class LpCard extends StatelessWidget {
  const LpCard({
    super.key,
    this.color = LpColors.bgWhite,
    this.borderColor = LpColors.ink,
    this.borderWidth = 2.5,
    this.radius = 12,
    this.shadowOffset = const Offset(0, 4),
    this.shadowColor = LpColors.ink,
    this.padding = const EdgeInsets.all(16),
    this.width,
    this.height,
    this.child,
  });

  final Color color;
  final Color borderColor;
  final double borderWidth;
  final double radius;

  /// Hard shadow offset. Use [Offset.zero] for no shadow.
  final Offset shadowOffset;
  final Color shadowColor;
  final EdgeInsetsGeometry padding;
  final double? width;
  final double? height;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: borderColor, width: borderWidth),
        boxShadow: shadowOffset == Offset.zero
            ? null
            : <BoxShadow>[
                BoxShadow(
                  color: shadowColor,
                  offset: shadowOffset,
                  // Hard toy shadow: NEVER blurred.
                  blurRadius: 0,
                ),
              ],
      ),
      child: child,
    );
  }
}
