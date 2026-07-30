import 'package:flutter/foundation.dart';

import '../data/content/letters_content.dart';
import '../data/models/user_progress.dart';

/// Global demo state: XP, hearts, energy, unlocked letters and onboarding
/// answers. Purely in-memory (no persistence — concept demo).
class AppState extends ChangeNotifier {
  UserProgress _progress = const UserProgress(
    xp: 13500,
    hearts: 6,
    energy: 10,
    unlockedLetterIds: defaultUnlockedLetterIds,
    completedLessonIds: <String>{},
    onboardingAnswers: <String, String>{},
  );

  UserProgress get progress => _progress;

  int get xp => _progress.xp;
  int get hearts => _progress.hearts;
  int get energy => _progress.energy;
  Set<String> get unlockedLetterIds => _progress.unlockedLetterIds;
  Set<String> get completedLessonIds => _progress.completedLessonIds;
  Map<String, String> get onboardingAnswers => _progress.onboardingAnswers;

  bool isLetterUnlocked(String letterId) =>
      _progress.unlockedLetterIds.contains(letterId);

  bool isLessonCompleted(String lessonId) =>
      _progress.completedLessonIds.contains(lessonId);

  /// Records the option chosen for an onboarding question.
  void answerOnboarding(String questionId, String answer) {
    _progress = _progress.copyWith(
      onboardingAnswers: <String, String>{
        ..._progress.onboardingAnswers,
        questionId: answer,
      },
    );
    notifyListeners();
  }

  /// Wrong answer in an exercise: lose one heart (never below zero).
  void loseHeart() {
    if (_progress.hearts <= 0) return;
    _progress = _progress.copyWith(hearts: _progress.hearts - 1);
    notifyListeners();
  }

  /// Grants the lesson rewards and unlocks the next locked letter in
  /// alphabet order.
  void completeLesson(String lessonId, int earnedXp, {int earnedEnergy = 10}) {
    final unlocked = Set<String>.of(_progress.unlockedLetterIds);
    for (final letter in lettersContent) {
      if (unlocked.add(letter.id)) break;
    }
    _progress = _progress.copyWith(
      xp: _progress.xp + earnedXp,
      energy: _progress.energy + earnedEnergy,
      unlockedLetterIds: unlocked,
      completedLessonIds: <String>{..._progress.completedLessonIds, lessonId},
    );
    notifyListeners();
  }
}
