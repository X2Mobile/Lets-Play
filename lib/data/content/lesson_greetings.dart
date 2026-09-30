import '../../core/theme/lp_colors.dart';
import '../models/exercise.dart';
import '../models/lesson.dart';

/// Level 5 · Lesson 4 — introduce yourself (design `LEVEL 5/0–12`): hear the
/// where-do-you-live dialogue, form its question, then drill the صباح الخير
/// greeting (choose what you hear, build it, fill the blank, rearrange it).
///
/// No recordings are bundled for the dialogue or the أين تعيش أنت sentence,
/// so those steps omit audio; the greeting steps reuse `sabah_alkhair.mp3`.
const Lesson lessonGreetings = Lesson(
  id: 'lesson_greetings',
  titleArabic: 'عرف نفسك',
  titleLatin: 'Introduce Yourself',
  levelNumber: 5,
  lessonNumber: 4,
  levelColor: LpColors.levelPurple,
  introChecklist: <String>[
    'Forming words',
    'Writing words',
    'Pronunciation',
    'Dialogue',
  ],
  introCharacterAsset: 'characters/intro_l5.png',
  countdownCharacterAsset: 'characters/countdown_l5.png',
  pointsReward: 9000,
  accuracyLabel: '82%',
  speedLabel: '1:50',
  exercises: <Exercise>[
    // "I live in Egypt, and you, where do you live?" / "I live in Dubai."
    // (design LEVEL 5/2).
    ListenDialogueExercise(
      lines: <DialogueLine>[
        DialogueLine(
          text: 'أنا أعيش في مصر، وأنت أين تعيش؟',
          speakerAsset: 'illustrations/dialogue_man.png',
        ),
        DialogueLine(
          text: 'أنا أعيش في دبي.',
          speakerAsset: 'illustrations/dialogue_woman.png',
          alignEnd: true,
        ),
      ],
    ),
    // Rebuild the dialogue's question: أين تعيش أنت (design LEVEL 5/3).
    FormSentenceExercise(
      heading: 'Form the sentence',
      words: <String>['أين', 'تعيش', 'أنت'],
    ),
    ChoiceExercise(
      heading: 'Choose the sentence you hear',
      audioFile: 'sabah_alkhair.mp3',
      options: <ExerciseOption>[
        ExerciseOption(letter: 'أنا اسمي سارة', isCorrect: false),
        ExerciseOption(letter: 'أنا اسمي آدم', isCorrect: false),
        ExerciseOption(letter: 'صباح الخير', isCorrect: true),
        ExerciseOption(letter: 'مساء الخير', isCorrect: false),
      ],
    ),
    // صباح الخير — the design's أهلاً صباح الخير (LEVEL 5/5–8) minus أهلاً,
    // which sabah_alkhair.mp3 doesn't say (client amends, Sep 2026).
    FormSentenceExercise(
      heading: 'Form the sentence',
      audioFile: 'sabah_alkhair.mp3',
      words: <String>['صباح', 'الخير'],
    ),
    ChoiceExercise(
      heading: 'Complete the sentence',
      prompt: ChoicePrompt(arabic: 'صباح ....'),
      options: <ExerciseOption>[
        ExerciseOption(letter: 'الخير', isCorrect: true),
        ExerciseOption(letter: 'المساء', isCorrect: false),
      ],
    ),
    ChoiceExercise(
      heading: 'Choose the sentence you hear',
      audioFile: 'sabah_alkhair.mp3',
      options: <ExerciseOption>[
        ExerciseOption(letter: 'صباح الخير', isCorrect: true),
        ExerciseOption(letter: 'مساء الخير', isCorrect: false),
      ],
    ),
    FormSentenceExercise(
      heading: 'Rearrange to form the sentence',
      audioFile: 'sabah_alkhair.mp3',
      words: <String>['صباح', 'الخير'],
    ),
  ],
);
