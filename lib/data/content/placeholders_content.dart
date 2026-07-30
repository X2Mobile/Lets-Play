/// Content for the polished Quests / Leaderboard / Profile placeholder tabs.
library;

import 'package:flutter/foundation.dart';

@immutable
class QuestItem {
  const QuestItem({
    required this.label,
    required this.progress,
    required this.progressLabel,
  });

  final String label;

  /// 0.0 … 1.0
  final double progress;

  /// e.g. `30 / 50`.
  final String progressLabel;
}

const String questsTitle = 'Quests';
const String questsHeaderTitle = 'Daily Quests';
const String questsHeaderBody = 'Complete quests every day to earn bonus ✦!';
const String questsFooter = 'Friend quests are coming soon — stay tuned! 🎁';

const List<QuestItem> questsPlaceholder = <QuestItem>[
  QuestItem(label: 'Earn 50 ✦', progress: 0.6, progressLabel: '30 / 50'),
  QuestItem(label: 'Finish 1 lesson', progress: 0, progressLabel: '0 / 1'),
  QuestItem(label: 'Practice 5 minutes', progress: 0.4, progressLabel: '2 / 5'),
];

@immutable
class LeaderboardEntry {
  const LeaderboardEntry({
    required this.name,
    required this.xp,
    this.isYou = false,
  });

  final String name;
  final int xp;
  final bool isYou;
}

const String leaderboardTitle = 'Leaderboard';
const String leaderboardHeaderTitle = 'Yellow League';
const String leaderboardHeaderBody = 'Top builders this week';
const String leaderboardFooter =
    'Leagues unlock soon — keep earning ✦ to stay on top!';

const List<LeaderboardEntry> leaderboardPlaceholder = <LeaderboardEntry>[
  LeaderboardEntry(name: 'Layla', xp: 4200),
  LeaderboardEntry(name: 'Omar', xp: 3980),
  LeaderboardEntry(name: 'You', xp: 3675, isYou: true),
  LeaderboardEntry(name: 'Sara', xp: 2100),
  LeaderboardEntry(name: 'Adam', xp: 1450),
];

const String profileTitle = 'Profile';
const String profileName = 'Little Builder';
const String profileSubtitle = 'Learning Arabic · Level 1 builder';
const String profileStreakValue = '3';
const String profileStreakLabel = 'day streak';
const String profileXpLabel = 'Total ✦';
const String profileHeartsLabel = 'Hearts';
const String profileEnergyLabel = 'Energy';
const String profileFooter = 'Settings & parental controls are coming soon!';
