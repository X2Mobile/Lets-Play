import 'package:flutter/material.dart';

import '../../core/theme/lp_colors.dart';
import '../../core/theme/lp_text_styles.dart';
import '../../core/widgets/lp_card.dart';
import '../../core/widgets/lp_icons.dart';
import '../../data/content/placeholders_content.dart';

/// Polished on-brand Leaderboard placeholder.
class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
        children: <Widget>[
          const Row(
            children: <Widget>[
              CrownIcon(size: 32),
              SizedBox(width: 10),
              Text(leaderboardTitle, style: LpTextStyles.h1),
            ],
          ),
          const SizedBox(height: 20),
          LpCard(
            color: LpColors.royalBlue,
            borderWidth: 3,
            shadowOffset: const Offset(0, 5),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  leaderboardHeaderTitle,
                  style: LpTextStyles.h2.copyWith(color: LpColors.brandYellow),
                ),
                const SizedBox(height: 2),
                Text(
                  leaderboardHeaderBody,
                  style: LpTextStyles.body.copyWith(
                    color: LpColors.bgWhite,
                    fontSize: 14.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          for (var i = 0; i < leaderboardPlaceholder.length; i++) ...<Widget>[
            _LeaderboardRow(rank: i + 1, entry: leaderboardPlaceholder[i]),
            const SizedBox(height: 12),
          ],
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: BoxDecoration(
              color: LpColors.tileGray,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: LpColors.borderGray),
            ),
            child: Text(
              leaderboardFooter,
              textAlign: TextAlign.center,
              style: LpTextStyles.body.copyWith(color: LpColors.textGray),
            ),
          ),
        ],
      ),
    );
  }
}

class _LeaderboardRow extends StatelessWidget {
  const _LeaderboardRow({required this.rank, required this.entry});

  final int rank;
  final LeaderboardEntry entry;

  static const List<Color> _medalColors = <Color>[
    LpColors.brandYellow,
    LpColors.borderGray,
    LpColors.orange,
  ];

  @override
  Widget build(BuildContext context) {
    final medal = rank <= 3 ? _medalColors[rank - 1] : LpColors.tileGray;
    final highlighted = entry.isYou;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: highlighted
          ? BoxDecoration(
              color: LpColors.brandYellow,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: LpColors.ink, width: 2.5),
              boxShadow: const <BoxShadow>[
                BoxShadow(color: LpColors.ink, offset: Offset(0, 3)),
              ],
            )
          : BoxDecoration(
              color: LpColors.tileGray,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: LpColors.borderGray),
            ),
      child: Row(
        children: <Widget>[
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: medal,
              shape: BoxShape.circle,
              border: Border.all(
                color: rank <= 3 ? LpColors.ink : LpColors.borderGray,
                width: rank <= 3 ? 2 : 1,
              ),
            ),
            child: Text(
              '$rank',
              style: LpTextStyles.body.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              entry.name,
              style: LpTextStyles.body.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          const SparkleIcon(size: 18),
          const SizedBox(width: 4),
          Text('${entry.xp}', style: LpTextStyles.body),
        ],
      ),
    );
  }
}
