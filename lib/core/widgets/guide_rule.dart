import 'package:flutter/material.dart';

import '../../data/models/exercise.dart';
import '../theme/lp_colors.dart';

/// A handwriting guide rule (design LEVEL 2/6, LEVEL 3/3): a small dark label
/// ("Ascender" / "Baseline" / "Descender") followed by a coloured rule running
/// out to the edge of the plate. The rule is centred vertically in [height] so
/// the caller can hang it off a grid row edge.
class GuideRule extends StatelessWidget {
  const GuideRule({super.key, required this.kind});

  static const double height = 18;

  final GuideKind kind;

  static Color colorOf(GuideKind kind) => switch (kind) {
    GuideKind.ascender => LpColors.legoGreen,
    GuideKind.baseline => LpColors.skyBlue,
    GuideKind.descender => LpColors.crimson,
  };

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Row(
          children: <Widget>[
            Text(
              kind.label,
              style: const TextStyle(
                fontFamily: 'BalooBhaijaan2',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: LpColors.ink,
              ),
            ),
            const SizedBox(width: 6),
            Expanded(child: Container(height: 1.6, color: colorOf(kind))),
          ],
        ),
      ),
    );
  }
}
