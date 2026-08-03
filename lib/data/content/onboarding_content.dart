import '../../core/theme/lp_colors.dart';
import '../models/onboarding_question.dart';

const String onboardingTitle = 'Tell us about yourself';

/// The four "Tell us about yourself" steps per the design (LOG IN/7–10):
/// motivation → proficiency → daily goal → dialect, each with its own
/// banner color.
const List<OnboardingQuestion> onboardingContent = <OnboardingQuestion>[
  OnboardingQuestion(
    id: 'motivation',
    question: 'Why have you chosen to study Arabic?',
    bannerColor: LpColors.royalBlue,
    twoColumns: true,
    options: <OnboardingOption>[
      OnboardingOption('Get ready for future trips', emoji: '🗺'),
      OnboardingOption('Establish connections', emoji: '🌐'),
      OnboardingOption('Enhance my education', emoji: '📜'),
      OnboardingOption('Advance my career', emoji: '📊'),
      OnboardingOption('Other', emoji: '✳'),
    ],
  ),
  OnboardingQuestion(
    id: 'proficiency',
    question: 'What is your level of proficiency in Arabic?',
    bannerColor: LpColors.levelOrange,
    options: <OnboardingOption>[
      OnboardingOption("I'm a beginner in Arabic"),
      OnboardingOption('I know a few words'),
      OnboardingOption('I can hold conversations'),
      OnboardingOption('I have an intermediate or higher level'),
    ],
  ),
  OnboardingQuestion(
    id: 'daily_goal',
    question: 'What is your daily goal for learning Arabic?',
    bannerColor: LpColors.skyBlue,
    options: <OnboardingOption>[
      OnboardingOption('10 min/day', detail: 'Casual'),
      OnboardingOption('15 min/day', detail: 'Regular'),
      OnboardingOption('20 min/day', detail: 'Serious'),
      OnboardingOption('25 min/day', detail: 'Intense'),
    ],
  ),
  OnboardingQuestion(
    id: 'dialect',
    question: 'Which dialect of Arabic are you interested in?',
    bannerColor: LpColors.brandYellow,
    darkBannerText: true,
    options: <OnboardingOption>[
      OnboardingOption('Levantine'),
      OnboardingOption('Egyptian'),
      OnboardingOption('Gulf'),
      OnboardingOption('Modern standard arabic'),
    ],
  ),
];

// --- LetsPlay+ upsell (design LOG IN/11; "intteruptions" typo fixed). ---

const String upsellLaunching = 'Launching';
const String upsellContinue = 'Continue';

class UpsellBenefit {
  const UpsellBenefit(this.emoji, this.title, this.subtitle);

  final String emoji;
  final String title;
  final String subtitle;
}

const List<UpsellBenefit> upsellBenefits = <UpsellBenefit>[
  UpsellBenefit(
    '🚫',
    'AD FREE!',
    'No more interruptions with LetsPlay+',
  ),
  UpsellBenefit('❤', 'Unlimited Hearts', 'Play whenever with unlimited lives'),
  UpsellBenefit(
    '📀',
    'Personalized Lessons',
    'Customized only for you and your needs',
  ),
];

// --- "Here's what you can accomplish!" (design LOG IN/12). ---

const String accomplishTitle = "Here's what you can accomplish!";

class AccomplishItem {
  const AccomplishItem(this.emoji, this.tileColorIndex, this.title, this.subtitle);

  final String emoji;

  /// Index into the accomplish tile palette (blue / red / green).
  final int tileColorIndex;
  final String title;
  final String subtitle;
}

const List<AccomplishItem> accomplishItems = <AccomplishItem>[
  AccomplishItem(
    '💬',
    0,
    'Engage in confident conversations',
    'Interact with people with less difficulty.',
  ),
  AccomplishItem(
    '📄',
    1,
    'Expand your vocabulary significantly',
    'Learn new words that will make you express yourself better.',
  ),
  AccomplishItem(
    '📊',
    2,
    'Cultivate a consistent learning routine',
    'Build the healthy habit of learning something new everyday.',
  ),
];

// --- Placement choice (design LOG IN/13). ---

const String placementTitle = "Now let's find the best place to start!";
const String placementScratchTitle = 'Start from Scratch';
const String placementScratchSubtitle =
    'Let us take you step by step from the beginning.';
const String placementFindTitle = 'Find my starting place';
const String placementFindSubtitle = 'Jump to the level you are currently at.';
