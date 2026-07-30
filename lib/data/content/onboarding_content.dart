import '../models/onboarding_question.dart';

const String onboardingTitle = 'Tell us about yourself';

/// The four "Tell us about yourself" steps (spec 5.3).
const List<OnboardingQuestion> onboardingContent = <OnboardingQuestion>[
  OnboardingQuestion(
    id: 'dialect',
    question: 'Which dialect of Arabic are you interested in?',
    options: <String>[
      'Levantine',
      'Egyptian',
      'Gulf',
      'Modern standard arabic',
    ],
  ),
  OnboardingQuestion(
    id: 'age',
    question: 'How old is the learner?',
    options: <String>['Under 6', '6–9', '10–12', 'Teen+'],
  ),
  OnboardingQuestion(
    id: 'level',
    question: 'How much Arabic do they know?',
    options: <String>[
      'Nothing yet',
      'Some letters',
      'Words & phrases',
      'Can read a little',
    ],
  ),
  OnboardingQuestion(
    id: 'goal',
    question: "What's your daily goal?",
    options: <String>['5 min', '10 min', '15 min', '20 min'],
  ),
];
