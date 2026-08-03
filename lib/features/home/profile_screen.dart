import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/lp_colors.dart';
import '../../core/theme/lp_text_styles.dart';
import '../../core/widgets/lp_card.dart';
import '../../core/widgets/lp_icons.dart';
import '../../data/content/placeholders_content.dart';
import '../../state/app_state.dart';
import 'settings_screen.dart';

/// Profile per the design (`PROFILE /1`): avatar + Malak + joined date,
/// Following/Followers, three colored Statistics cards (live app state),
/// Review Progress and Find-your-Friends rows.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static void _showSnack(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text(profileComingSoonSnack)));
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        children: <Widget>[
          Row(
            children: <Widget>[
              const Spacer(),
              const Padding(
                padding: EdgeInsets.only(left: 30),
                child: Text(profileTitle, style: LpTextStyles.h1),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const SettingsScreen(),
                  ),
                ),
                child: const GearIcon(size: 30),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Center(
            child: Container(
              width: 112,
              height: 112,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: LpColors.ink, width: 3),
                boxShadow: const <BoxShadow>[
                  BoxShadow(color: LpColors.ink, offset: Offset(0, 4)),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/illustrations/avatar.png',
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const Center(
                    child: SmileyIcon(size: 74),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          const Center(child: Text(profileName, style: LpTextStyles.h1)),
          const Center(
            child: Text(profileJoined, style: LpTextStyles.caption),
          ),
          const SizedBox(height: 18),
          Row(
            children: const <Widget>[
              Expanded(
                child: _QuietStat(
                  value: profileFollowingValue,
                  label: profileFollowingLabel,
                ),
              ),
              SizedBox(width: 14),
              Expanded(
                child: _QuietStat(
                  value: profileFollowersValue,
                  label: profileFollowersLabel,
                ),
              ),
            ],
          ),
          const SizedBox(height: 26),
          const Center(
            child: Text(profileStatisticsTitle, style: LpTextStyles.h2),
          ),
          const SizedBox(height: 14),
          Row(
            children: <Widget>[
              Expanded(
                child: _StatCard(
                  color: LpColors.levelBlue,
                  icon: const BoltIcon(size: 30),
                  value: '${appState.energy}',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  color: LpColors.levelOrange,
                  icon: const HeartIcon(size: 30),
                  value: '${appState.hearts}',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  color: LpColors.levelPurple,
                  icon: const SparkleIcon(size: 30),
                  value: '${appState.xp}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 26),
          const Center(
            child: Text(profileReviewTitle, style: LpTextStyles.h2),
          ),
          const SizedBox(height: 14),
          _QuietRow(
            customEmoji: '🎯',
            label: profileMistakesLabel,
            onTap: () => _showSnack(context),
          ),
          const SizedBox(height: 12),
          _QuietRow(
            customEmoji: '📝',
            label: profileQuickQuizLabel,
            onTap: () => _showSnack(context),
          ),
          const SizedBox(height: 26),
          const Center(
            child: Text(profileFriendsTitle, style: LpTextStyles.h2),
          ),
          const SizedBox(height: 14),
          _QuietRow(
            customEmoji: '📷',
            label: profileConnectInstagram,
            onTap: () => _showSnack(context),
          ),
          const SizedBox(height: 12),
          _QuietRow(
            customEmoji: '✉',
            label: profileInviteFriends,
            onTap: () => _showSnack(context),
          ),
          const SizedBox(height: 12),
          _QuietRow(
            customEmoji: '👥',
            label: profileConnectContacts,
            onTap: () => _showSnack(context),
          ),
        ],
      ),
    );
  }
}

/// Quiet gray value/label card (Following / Followers).
class _QuietStat extends StatelessWidget {
  const _QuietStat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: LpColors.tileGray,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: LpColors.borderGray),
      ),
      child: Column(
        children: <Widget>[
          Text(value, style: LpTextStyles.title),
          Text(label, style: LpTextStyles.caption),
        ],
      ),
    );
  }
}

/// Colored statistics card (blue energy / orange hearts / purple points).
class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.color,
    required this.icon,
    required this.value,
  });

  final Color color;
  final Widget icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return LpCard(
      color: color,
      borderWidth: 2.5,
      shadowOffset: const Offset(0, 4),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: <Widget>[
          icon,
          const SizedBox(height: 8),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: LpTextStyles.title.copyWith(color: LpColors.bgWhite),
          ),
        ],
      ),
    );
  }
}

/// Quiet gray tappable row with a leading emoji tile.
class _QuietRow extends StatelessWidget {
  const _QuietRow({
    required this.customEmoji,
    required this.label,
    required this.onTap,
  });

  final String customEmoji;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: LpColors.tileGray,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: LpColors.borderGray),
        ),
        child: Row(
          children: <Widget>[
            Text(customEmoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 12),
            Text(
              label,
              style: LpTextStyles.body.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
