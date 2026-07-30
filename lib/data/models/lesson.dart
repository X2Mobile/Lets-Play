import 'package:flutter/foundation.dart';

import 'exercise.dart';

/// A complete letter lesson: an ordered sequence of exercises plus the
/// rewards granted on the celebration screen.
@immutable
class Lesson {
  const Lesson({
    required this.id,
    required this.letterId,
    required this.titleArabic,
    required this.titleLatin,
    required this.exercises,
    this.xpReward = 120,
    this.energyReward = 10,
  });

  final String id;

  /// The [Letter.id] this lesson teaches.
  final String letterId;

  /// e.g. `أ`.
  final String titleArabic;

  /// e.g. `Alef`.
  final String titleLatin;
  final List<Exercise> exercises;

  /// `+120 ✦` on the completion screen.
  final int xpReward;

  /// `⚡ +10` on the completion screen.
  final int energyReward;
}
