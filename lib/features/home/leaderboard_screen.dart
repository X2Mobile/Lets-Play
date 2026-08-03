import 'package:flutter/material.dart';

import '../../core/theme/lp_colors.dart';
import '../../core/theme/lp_text_styles.dart';
import '../../data/content/placeholders_content.dart';

/// Leaderboard per the design (`PROFILE /5–6`): LEGO-brick podium with the
/// top-3 avatars, Leadership | Tournaments segmented control (contents
/// identical — concept demo) and the ranked list with the user highlighted.
class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  bool _tournaments = true;

  static const List<Color> _rankColors = <Color>[
    LpColors.brandYellow,
    LpColors.levelBlue,
    LpColors.levelOrange,
    LpColors.brandYellow,
    LpColors.tileGray,
  ];

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
    return SafeArea(
      child: Column(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Center(
              child: Text(leaderboardTitle, style: LpTextStyles.h1),
            ),
          ),
          const SizedBox(height: 8),
          Image.asset(
            'assets/images/illustrations/podium.png',
            height: 216,
            fit: BoxFit.contain,
            errorBuilder: (_, _, _) => const SizedBox(height: 40),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _SegmentedTabs(
              tournaments: _tournaments,
              onChanged: (value) => setState(() => _tournaments = value),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 6, 20, 20),
              itemCount: leaderboardPlaceholder.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) => _EntryRow(
                entry: leaderboardPlaceholder[index],
                rank: index + 1,
                color: _rankColors[index % _rankColors.length],
                xpLabel: _formatXp(leaderboardPlaceholder[index].xp),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// One ranked row; the user's row gets the white bordered card treatment.
class _EntryRow extends StatelessWidget {
  const _EntryRow({
    required this.entry,
    required this.rank,
    required this.color,
    required this.xpLabel,
  });

  final LeaderboardEntry entry;
  final int rank;
  final Color color;
  final String xpLabel;

  bool get _darkBadgeText => color == LpColors.brandYellow;

  bool get _grayBadge => color == LpColors.tileGray;

  @override
  Widget build(BuildContext context) {
    final badgeTextColor = _grayBadge
        ? LpColors.textGray
        : _darkBadgeText
        ? LpColors.ink
        : LpColors.bgWhite;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: entry.isYou
          ? BoxDecoration(
              color: LpColors.bgWhite,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: LpColors.ink, width: 2.5),
              boxShadow: const <BoxShadow>[
                BoxShadow(color: LpColors.ink, offset: Offset(0, 3)),
              ],
            )
          : null,
      child: Row(
        children: <Widget>[
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: entry.isYou
                ? ClipOval(
                    child: Image.asset(
                      'assets/images/illustrations/avatar.png',
                      width: 42,
                      height: 42,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Text(
                        entry.name.substring(0, 1),
                        style: LpTextStyles.title,
                      ),
                    ),
                  )
                : Text(
                    entry.name.substring(0, 1),
                    style: LpTextStyles.title.copyWith(color: badgeTextColor),
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  entry.name,
                  style: LpTextStyles.body.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Row(
                  children: <Widget>[
                    const Text(
                      '✦',
                      style: TextStyle(
                        fontSize: 13,
                        color: LpColors.brandYellow,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(xpLabel, style: LpTextStyles.caption),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Text(
              '$rank',
              style: LpTextStyles.body.copyWith(
                fontWeight: FontWeight.w800,
                color: badgeTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Leadership | Tournaments segmented control (white active pill).
class _SegmentedTabs extends StatelessWidget {
  const _SegmentedTabs({required this.tournaments, required this.onChanged});

  final bool tournaments;
  final ValueChanged<bool> onChanged;

  Widget _tab(String label, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? LpColors.bgWhite : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: active ? Border.all(color: LpColors.borderGray) : null,
            boxShadow: active
                ? const <BoxShadow>[
                    BoxShadow(
                      color: LpColors.borderGray,
                      offset: Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            style: LpTextStyles.body.copyWith(
              fontWeight: FontWeight.w700,
              color: active ? LpColors.ink : LpColors.textGray,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: LpColors.tileGray,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: LpColors.borderGray),
      ),
      child: Row(
        children: <Widget>[
          _tab(leaderboardTabLeadership, !tournaments, () => onChanged(false)),
          _tab(leaderboardTabTournaments, tournaments, () => onChanged(true)),
        ],
      ),
    );
  }
}
