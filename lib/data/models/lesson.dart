import 'package:flutter/material.dart';

import 'exercise.dart';

/// A complete lesson: an ordered sequence of exercises plus the rewards
/// granted on the level-up screen, wrapped in the level chrome from the
/// 2026-07 design drop (intro card → countdown → exercises → level-up).
@immutable
class Lesson {
  const Lesson({
    required this.id,
    this.letterId,
    required this.titleArabic,
    required this.titleLatin,
    required this.exercises,
    this.levelNumber = 1,
    this.lessonNumber = 1,
    this.levelColor,
    this.introChecklist = const <String>[],
    this.introCharacterAsset,
    this.countdownCharacterAsset,
    this.xpReward = 120,
    this.energyReward = 10,
    this.pointsReward = 5000,
    this.accuracyLabel = '90%',
    this.speedLabel = '1:00',
  });

  final String id;

  /// The [Letter.id] this lesson teaches (letter lessons only).
  final String? letterId;

  /// e.g. `أ`.
  final String titleArabic;

  /// e.g. `Alef`.
  final String titleLatin;
  final List<Exercise> exercises;

  /// 1–5 — drives the "Lesson N / Level N" chrome.
  final int levelNumber;
  final int lessonNumber;

  /// Level brand color (intro bg, teach cards); defaults per level number.
  final Color? levelColor;

  /// "You'll learn" bullet list on the level intro card.
  final List<String> introChecklist;

  /// Character crop for the level intro (path under `assets/images/`).
  final String? introCharacterAsset;

  /// Character crop for the ٣٢١ countdown screen.
  final String? countdownCharacterAsset;

  /// `+120 ✦` on the completion screen.
  final int xpReward;

  /// `⚡ +10` on the completion screen.
  final int energyReward;

  /// Big "5000 pt" plaque on the level-up screen.
  final int pointsReward;

  /// Stat cards on the level-up screen (cosmetic, per design).
  final String accuracyLabel;
  final String speedLabel;
}
