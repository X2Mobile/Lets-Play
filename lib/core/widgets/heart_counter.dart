import 'package:flutter/material.dart';

import '../theme/lp_text_styles.dart';
import 'lp_icons.dart';

/// Red outlined heart + remaining lives count.
class HeartCounter extends StatelessWidget {
  const HeartCounter({super.key, required this.hearts, this.iconSize = 26});

  final int hearts;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        HeartIcon(size: iconSize),
        const SizedBox(width: 6),
        Text('$hearts', style: LpTextStyles.statValue),
      ],
    );
  }
}
