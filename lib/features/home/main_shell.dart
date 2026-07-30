import 'package:flutter/material.dart';

import '../../core/theme/lp_colors.dart';
import '../../core/widgets/lp_icons.dart';
import '../../data/content/ui_strings.dart';
import 'home_screen.dart';
import 'leaderboard_screen.dart';
import 'profile_screen.dart';
import 'quests_screen.dart';

/// Bottom-nav shell: Home · Quests (✦) · Leaderboard (crown) · Profile.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  static const List<Widget> _tabs = <Widget>[
    HomeScreen(),
    QuestsScreen(),
    LeaderboardScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _tabs),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: LpColors.bgWhite,
          border: Border(top: BorderSide(color: LpColors.borderGray)),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 62,
            child: Row(
              children: <Widget>[
                _NavItem(
                  icon: const HouseIcon(size: 32),
                  label: UiStrings.tabHome,
                  active: _index == 0,
                  onTap: () => setState(() => _index = 0),
                ),
                _NavItem(
                  icon: const SparkleIcon(size: 30),
                  label: UiStrings.tabQuests,
                  active: _index == 1,
                  onTap: () => setState(() => _index = 1),
                ),
                _NavItem(
                  icon: const CrownIcon(size: 32),
                  label: UiStrings.tabLeaderboard,
                  active: _index == 2,
                  onTap: () => setState(() => _index = 2),
                ),
                _NavItem(
                  icon: const SmileyIcon(size: 32),
                  label: UiStrings.tabProfile,
                  active: _index == 3,
                  onTap: () => setState(() => _index = 3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final Widget icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Semantics(
        label: label,
        button: true,
        selected: active,
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Center(
            child: AnimatedScale(
              scale: active ? 1.12 : 1,
              duration: const Duration(milliseconds: 150),
              child: AnimatedOpacity(
                opacity: active ? 1 : 0.4,
                duration: const Duration(milliseconds: 150),
                child: icon,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
