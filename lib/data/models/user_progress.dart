import 'package:flutter/foundation.dart';

/// Immutable snapshot of the learner's progress; [AppState] swaps snapshots
/// via [copyWith] and notifies listeners.
@immutable
class UserProgress {
  const UserProgress({
    required this.xp,
    required this.hearts,
    required this.energy,
    required this.unlockedLetterIds,
    required this.completedLessonIds,
    required this.onboardingAnswers,
  });

  final int xp;
  final int hearts;
  final int energy;
  final Set<String> unlockedLetterIds;
  final Set<String> completedLessonIds;

  /// question id → chosen option.
  final Map<String, String> onboardingAnswers;

  UserProgress copyWith({
    int? xp,
    int? hearts,
    int? energy,
    Set<String>? unlockedLetterIds,
    Set<String>? completedLessonIds,
    Map<String, String>? onboardingAnswers,
  }) {
    return UserProgress(
      xp: xp ?? this.xp,
      hearts: hearts ?? this.hearts,
      energy: energy ?? this.energy,
      unlockedLetterIds: unlockedLetterIds ?? this.unlockedLetterIds,
      completedLessonIds: completedLessonIds ?? this.completedLessonIds,
      onboardingAnswers: onboardingAnswers ?? this.onboardingAnswers,
    );
  }
}
