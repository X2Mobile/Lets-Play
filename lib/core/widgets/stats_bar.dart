import 'package:flutter/material.dart';

import '../theme/lp_text_styles.dart';
import 'heart_counter.dart';
import 'lp_icons.dart';

/// Home-screen stats row: `✦ 13,500 · ❤ 6 · ⚡ 10 · green gear`.
class StatsBar extends StatelessWidget {
  const StatsBar({
    super.key,
    required this.xp,
    required this.hearts,
    required this.energy,
    this.onSettingsTap,
  });

  final int xp;
  final int hearts;
  final int energy;
  final VoidCallback? onSettingsTap;

  static String _formatXp(int value) {
    final digits = value.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      buffer.write(digits[i]);
      final remaining = digits.length - 1 - i;
      if (remaining > 0 && remaining % 3 == 0) buffer.write(',');
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            const SparkleIcon(size: 26),
            const SizedBox(width: 6),
            Text(_formatXp(xp), style: LpTextStyles.statValue),
          ],
        ),
        HeartCounter(hearts: hearts),
        Row(
          children: <Widget>[
            const BoltIcon(size: 26),
            const SizedBox(width: 6),
            Text('$energy', style: LpTextStyles.statValue),
          ],
        ),
        GestureDetector(onTap: onSettingsTap, child: const GearIcon(size: 30)),
      ],
    );
  }
}
