import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/lp_colors.dart';
import '../../core/theme/lp_text_styles.dart';
import '../../core/widgets/lp_card.dart';
import '../../core/widgets/lp_icons.dart';
import '../../data/content/placeholders_content.dart';
import '../../state/app_state.dart';

/// Polished on-brand Profile placeholder (stats come from live app state).
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
        children: <Widget>[
          const Row(
            children: <Widget>[
              SmileyIcon(size: 32),
              SizedBox(width: 10),
              Text(profileTitle, style: LpTextStyles.h1),
            ],
          ),
          const SizedBox(height: 24),
          Center(
            child: Container(
              width: 108,
              height: 108,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: LpColors.bgWhite,
                shape: BoxShape.circle,
                border: Border.all(color: LpColors.ink, width: 3),
                boxShadow: const <BoxShadow>[
                  BoxShadow(color: LpColors.ink, offset: Offset(0, 4)),
                ],
              ),
              child: const SmileyIcon(size: 74),
            ),
          ),
          const SizedBox(height: 14),
          const Center(child: Text(profileName, style: LpTextStyles.h1)),
          Center(child: Text(profileSubtitle, style: LpTextStyles.caption)),
          const SizedBox(height: 24),
          Row(
            children: <Widget>[
              Expanded(
                child: _StatCard(
                  icon: const SparkleIcon(size: 26),
                  value: '${appState.xp}',
                  label: profileXpLabel,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _StatCard(
                  icon: const HeartIcon(size: 26),
                  value: '${appState.hearts}',
                  label: profileHeartsLabel,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: <Widget>[
              Expanded(
                child: _StatCard(
                  icon: const BoltIcon(size: 26),
                  value: '${appState.energy}',
                  label: profileEnergyLabel,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: const _StatCard(
                  icon: Text('🔥', style: TextStyle(fontSize: 22)),
                  value: profileStreakValue,
                  label: profileStreakLabel,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: BoxDecoration(
              color: LpColors.tileGray,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: LpColors.borderGray),
            ),
            child: Text(
              profileFooter,
              textAlign: TextAlign.center,
              style: LpTextStyles.body.copyWith(color: LpColors.textGray),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  final Widget icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return LpCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      shadowOffset: const Offset(0, 3),
      child: Row(
        children: <Widget>[
          icon,
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  value,
                  style: LpTextStyles.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  label,
                  style: LpTextStyles.caption.copyWith(fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
