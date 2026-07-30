/// All user-facing chrome copy lives here (spec rule: content strings in
/// `data/content/`, never inline in widgets).
abstract final class UiStrings {
  // Brand.
  static const String appName = "LET'S PLAY!";
  static const String appNameArabic = 'يلا نلعب';

  // Login (visual only — copy matches the XD prototype).
  static const String loginTitle = 'Login';
  static const String loginSubtitle =
      "You don't think you should login first\nand behave like human not robot.";
  static const String emailHint = 'Email address';
  static const String passwordHint = 'Password';
  static const String rememberMe = 'Remember me';
  static const String forgotPassword = 'Forgot your password?';
  static const String signIn = 'Sign in';
  static const String loginWithFacebook = 'Login with Facebook';
  static const String noAccount = "Don't have an account? ";
  static const String signUp = 'Sign up';

  // Plan loading.
  static const String planLoadingMessage = 'Finishing up your custom plan';

  // Home.
  static const String lockedLetterSnack =
      'Finish the previous letters to unlock this one!';
  static const String lockedTashkeelSnack =
      'Finish Level 1 to start learning tashkeel!';
  static const String lessonComingSoonSnack = 'This lesson is coming soon!';
  static const String settingsComingSoonSnack = 'Settings are coming soon!';

  // Shared buttons.
  static const String continueLabel = 'Continue';

  // Lesson stub.
  static const String lessonComingSoonTitle = 'Lesson coming soon';
  static const String lessonComingSoonBody =
      'The brick builders are hard at work on this lesson!';
  static const String backToHome = 'Back to home';

  // Bottom navigation (semantic labels).
  static const String tabHome = 'Home';
  static const String tabQuests = 'Quests';
  static const String tabLeaderboard = 'Leaderboard';
  static const String tabProfile = 'Profile';
}
