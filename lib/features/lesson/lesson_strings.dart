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

  // Accessibility.
  static const String slowPlaySemantics = 'Play slowly';
  static const String retrySemantics = 'Retry';
}
