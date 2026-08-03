/// Copy used by the lesson flow. Lives inside the feature because
/// `data/content/ui_strings.dart` is frozen for this task — fold these into
/// the shared content file when it reopens.
abstract final class LessonStrings {
  // Exercise headings.
  static const String matchHeading = 'Match the image';
  static const String listenHeading = 'Choose what you heard';

  // Build / trace bottom bar.
  static const String movesLabel = 'Moves:';

  // Quit-lesson confirm dialog.
  static const String quitTitle = "Wait, don't go!";
  static const String quitBody =
      "If you quit now, you'll lose this lesson's progress.";
  static const String keepGoing = 'Keep learning';
  static const String quitLesson = 'Quit lesson';

  // Celebration screen.
  static const String completeTitle = 'Lesson complete!';
  static const String completeSubtitlePrefix = 'You learned the letter ';
  static const String completeSubtitleSuffix = '!';

  // Level chrome (2026-07 design drop). Design typos fixed deliberately
  // ("You''ll learn" → "You'll learn", "Congratutlations" → congratulations).
  static const String youWillLearn = "You'll learn";
  static const String levelLabel = 'Level';
  static const String lessonLabel = 'Lesson';
  static const String letsPlayButton = 'LETS PLAY';
  static const String checkpointTitle = 'Great Job Malak!';
  static const String checkpointSubtitle = "now let's test you";
  static const String outstandingTitle = 'Outstanding Job!';
  static const String outstandingSubtitle = 'You crushed it';
  static const String toastTitle = 'Awesome!';
  static const String toastSubtitle = 'You nailed it!';
  static const String congratsPrefix = 'Congratulations ';
  static const String learnerName = 'Malak';
  static const String leveledUp = "You've just leveled up!";
  static const String pointsSuffix = 'pt';
  static const String accuracyLabel = 'Accuracy';
  static const String speedLabel = 'Speed';
  static const String shareLabel = 'Share';

  // Accessibility.
  static const String slowPlaySemantics = 'Play slowly';
  static const String retrySemantics = 'Retry';
  static const String micSemantics = 'Hold to speak';
}
