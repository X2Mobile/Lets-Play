/// Content for the Profile / Leaderboard / Total Points tabs and Settings
/// (design `PROFILE /1–8`).
library;

import 'package:flutter/foundation.dart';

// --- Profile (design PROFILE/1). ---

const String profileTitle = 'Profile';
const String profileName = 'Malak';
const String profileJoined = 'Joined February 2023';
const String profileFollowingValue = '60';
const String profileFollowingLabel = 'Following';
const String profileFollowersValue = '150';
const String profileFollowersLabel = 'Followers';
const String profileStatisticsTitle = 'Statistics';
const String profileReviewTitle = 'Review Progress';
const String profileMistakesLabel = 'Mistakes';
const String profileQuickQuizLabel = 'Quick Quiz';
const String profileFriendsTitle = 'Find your Friends';
const String profileConnectInstagram = 'Connect to Instagram';
const String profileInviteFriends = 'Invite Friends';
const String profileConnectContacts = 'Connect to Contacts';
const String profileComingSoonSnack = 'This is coming soon!';

// --- Leaderboard (design PROFILE/5–6). ---

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
const String leaderboardTabLeadership = 'Leadership';
const String leaderboardTabTournaments = 'Tournaments';

const List<LeaderboardEntry> leaderboardPlaceholder = <LeaderboardEntry>[
  LeaderboardEntry(name: 'Malak Hossam', xp: 4970, isYou: true),
  LeaderboardEntry(name: 'Mohamed Hossam', xp: 3870),
  LeaderboardEntry(name: 'Mohamed Hossam', xp: 3070),
  LeaderboardEntry(name: 'Mohamed Hossam', xp: 2007),
  LeaderboardEntry(name: 'Mohamed Hossam', xp: 1509),
];

// --- Total Points / rewards (design PROFILE/8). ---

const String pointsTitle = 'Total Points';
const String pointsRewardsTitle = 'Look what your points got you!';

@immutable
class PointsReward {
  const PointsReward({
    required this.title,
    required this.imageAsset,
    required this.progress,
    required this.progressLabel,
    required this.unlocked,
  });

  final String title;
  final String imageAsset;

  /// 0.0 … 1.0
  final double progress;

  /// e.g. `500 / 2000`.
  final String progressLabel;
  final bool unlocked;
}

const List<PointsReward> pointsRewards = <PointsReward>[
  PointsReward(
    title: 'Arabic Alphabet Book',
    imageAsset: 'illustrations/reward_book.png',
    progress: 0.25,
    progressLabel: '500 / 2000',
    unlocked: false,
  ),
  PointsReward(
    title: "Let's Play Card Game",
    imageAsset: 'illustrations/reward_game.png',
    progress: 1,
    progressLabel: 'Unlocked!',
    unlocked: true,
  ),
];

// --- Settings (design PROFILE/2). ---

const String settingsTitle = 'Settings';
const String settingsChangePhoto = 'Change photo';
const String settingsUsernameLabel = 'Username';
const String settingsUsernameValue = 'Malak';
const String settingsPasswordLabel = 'Password';
const String settingsPasswordValue = '••••••';
const String settingsEmailLabel = 'Email';
const String settingsEmailValue = 'Malak11@hotmail.com';
const String settingsTerms = 'Terms';
const String settingsPrivacy = 'Privacy Policy';
const String settingsDeleteAccount = 'Delete Account';
const String settingsSoundEffects = 'Sound Effects';
const String settingsHelpCenter = 'Help Center';
const String settingsFeedback = 'Feedback';
const String settingsSignOut = 'Sign Out';
