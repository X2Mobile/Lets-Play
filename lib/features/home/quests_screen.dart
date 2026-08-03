import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/lp_colors.dart';
import '../../core/theme/lp_text_styles.dart';
import '../../core/widgets/lp_card.dart';
import '../../core/widgets/lp_icons.dart';
import '../../data/content/placeholders_content.dart';
import '../../state/app_state.dart';

/// Total Points tab per the design (`PROFILE /8`): sparkle + giant green
/// points number over the LEGO castle world, then "Look what your points
/// got you!" physical rewards with progress bars.
class QuestsScreen extends StatelessWidget {
  const QuestsScreen({super.key});

  static String _format(int value) {
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
    final xp = context.watch<AppState>().xp;
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        children: <Widget>[
          const Center(child: Text(pointsTitle, style: LpTextStyles.h1)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SparkleIcon(size: 34),
              const SizedBox(width: 10),
              Text(
                _format(xp),
                style: LpTextStyles.display.copyWith(
                  fontSize: 46,
                  color: LpColors.legoGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Image.asset(
            'assets/images/illustrations/castle.png',
            height: 240,
            fit: BoxFit.contain,
            errorBuilder: (_, _, _) => const SizedBox(height: 40),
          ),
          const SizedBox(height: 22),
          const Center(
            child: Text(pointsRewardsTitle, style: LpTextStyles.h2),
          ),
          const SizedBox(height: 14),
          for (final reward in pointsRewards)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _RewardCard(reward: reward),
            ),
        ],
      ),
    );
  }
}

/// Physical reward card: illustration + title + progress bar (+ lock).
class _RewardCard extends StatelessWidget {
  const _RewardCard({required this.reward});

  final PointsReward reward;

  @override
  Widget build(BuildContext context) {
    return LpCard(
      borderWidth: 2.5,
      shadowOffset: const Offset(0, 4),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: <Widget>[
          Image.asset(
            'assets/images/${reward.imageAsset}',
            width: 86,
            height: 86,
            fit: BoxFit.contain,
            errorBuilder: (_, _, _) => const Text(
              '🎁',
              style: TextStyle(fontSize: 44),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(reward.title, style: LpTextStyles.title),
                    ),
                    if (!reward.unlocked)
                      const Icon(
                        Icons.lock_rounded,
                        size: 18,
                        color: LpColors.textGray,
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: reward.progress,
                    minHeight: 10,
                    backgroundColor: LpColors.tileGray,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      LpColors.legoGreen,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(reward.progressLabel, style: LpTextStyles.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
