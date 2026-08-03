import 'dart:math';
import 'dart:ui';

import '../../core/theme/lp_colors.dart';
import '../models/exercise.dart';
import '../models/lesson.dart';

/// Level 1 · Lesson 1 — the letter Alef (design `LEVEL 1/0–29`): build the
/// brick letter over the Baseline, press-to-reveal it, study its positional
/// forms, trace it, then run the test battery (listen, true/false, speak,
/// picture↔word matches and form-the-word). The letter is a tall vertical
/// bar of stacked bricks with a hamza hook at the top-left, on a
/// 6 columns × 8 rows grid.
const Lesson lessonAlef = Lesson(
  id: 'lesson_alef',
  letterId: 'alef',
  titleArabic: 'أ',
  titleLatin: 'Alef',
  levelNumber: 1,
  lessonNumber: 1,
  levelColor: LpColors.brandYellow,
  introChecklist: <String>[
    'Forming the letter',
    'Writing the letter',
    'Letter inside words',
    'Letter medials',
  ],
  introCharacterAsset: 'characters/intro_l1.png',
  countdownCharacterAsset: 'characters/countdown_l1.png',
  pointsReward: 5000,
  accuracyLabel: '90%',
  speedLabel: '1:00',
  exercises: <Exercise>[
    TutorialStep(line1: 'Tap on the blocks', line2: 'To form the letter'),
    // The hamza hook assembled on top of the stem, with the positional-form
    // tabs and the Baseline guide (design LEVEL 1/3–6).
    BuildLetterExercise(
      gridColumns: 6,
      gridRows: 8,
      // pieces[i] snaps onto the slot whose top-left cell is slots[i].
      slots: <Point<int>>[
        Point<int>(1, 1), // hamza hook, upper-left of the bar
        Point<int>(2, 2), // bar top
        Point<int>(2, 4), // bar middle
        Point<int>(2, 6), // bar bottom
      ],
      pieces: <BrickPiece>[
        BrickPiece(columns: 2, rows: 1, color: LpColors.royalBlue),
        BrickPiece(columns: 2, rows: 2, color: LpColors.brickRed),
        BrickPiece(columns: 2, rows: 2, color: LpColors.orange),
        BrickPiece(columns: 2, rows: 2, color: LpColors.legoGreen),
      ],
      timerSeconds: 30,
      maxMoves: 8,
      formTabs: <String>['ا', 'ا', 'أ'],
      activeFormIndex: 2,
      guideLabel: 'Baseline',
    ),
    PressRevealExercise(
      glyph: 'أ',
      nameArabic: 'ألف',
      nameLatin: 'Alef',
      audioFile: 'alef.mp3',
      gridColumns: 6,
      gridRows: 8,
      slots: <Point<int>>[
        Point<int>(1, 1),
        Point<int>(2, 2),
        Point<int>(2, 4),
        Point<int>(2, 6),
      ],
      pieces: <BrickPiece>[
        BrickPiece(columns: 2, rows: 1, color: LpColors.royalBlue),
        BrickPiece(columns: 2, rows: 2, color: LpColors.brickRed),
        BrickPiece(columns: 2, rows: 2, color: LpColors.orange),
        BrickPiece(columns: 2, rows: 2, color: LpColors.legoGreen),
      ],
    ),
    // Alef doesn't connect forward, so initial = isolated and
    // medial = final (design LEVEL 1/9).
    LetterFormsExercise(
      title: 'Alef Letter Forms',
      forms: <(String, String)>[
        ('Initial', 'أ'),
        ('Isolated', 'أ'),
        ('Final', 'ـأ'),
        ('Medial', 'ـأ'),
      ],
    ),
    TutorialStep(line1: 'Drag the hand', line2: 'To form the letter'),
    TraceLetterExercise(
      gridColumns: 6,
      gridRows: 8,
      slots: <Point<int>>[
        Point<int>(1, 1),
        Point<int>(2, 2),
        Point<int>(2, 4),
        Point<int>(2, 6),
      ],
      pieces: <BrickPiece>[
        BrickPiece(columns: 2, rows: 1, color: LpColors.royalBlue),
        BrickPiece(columns: 2, rows: 2, color: LpColors.brickRed),
        BrickPiece(columns: 2, rows: 2, color: LpColors.orange),
        BrickPiece(columns: 2, rows: 2, color: LpColors.legoGreen),
      ],
      // Hamza flick first, then the bar drawn top → bottom.
      path: <Offset>[
        Offset(0.38, 0.12),
        Offset(0.48, 0.16),
        Offset(0.50, 0.24),
        Offset(0.50, 0.38),
        Offset(0.50, 0.52),
        Offset(0.50, 0.66),
        Offset(0.50, 0.80),
        Offset(0.50, 0.90),
      ],
    ),
    CheckpointStep(title: 'Great Job Malak!', subtitle: "now let's test you"),
    ChoiceExercise(
      heading: 'Listen and choose',
      audioFile: 'alef.mp3',
      options: <ExerciseOption>[
        ExerciseOption(letter: 'أ', isCorrect: true),
        ExerciseOption(letter: 'ج', isCorrect: false),
      ],
      columns: 2,
      letterTiles: true,
    ),
    ChoiceExercise(
      heading: 'True or False',
      prompt: ChoicePrompt(
        arabic: 'ب',
        latin: 'Means "Alif"',
        cardColor: LpColors.crimson,
      ),
      options: <ExerciseOption>[
        ExerciseOption(label: 'True', isCorrect: false),
        ExerciseOption(label: 'False', isCorrect: true),
      ],
      columns: 2,
    ),
    RepeatAfterExercise(
      word: 'أب',
      meaning: 'Father',
      imageAsset: 'illustrations/father_son.png',
      audioFile: 'ab_father.mp3',
    ),
    ChoiceExercise(
      heading: 'Choose the correct answer',
      prompt: ChoicePrompt(imageAsset: 'illustrations/father_son.png'),
      audioFile: 'ab_father.mp3',
      options: <ExerciseOption>[
        ExerciseOption(letter: 'أب', isCorrect: true),
        ExerciseOption(letter: 'أسد', isCorrect: false),
        ExerciseOption(letter: 'حصان', isCorrect: false),
      ],
      columns: 3,
    ),
    ChoiceExercise(
      heading: 'Listen and choose',
      audioFile: 'ab_father.mp3',
      options: <ExerciseOption>[
        ExerciseOption(letter: 'أب', isCorrect: true),
        ExerciseOption(letter: 'أسد', isCorrect: false),
      ],
      columns: 2,
    ),
    ChoiceExercise(
      heading: 'Choose the correct answer',
      prompt: ChoicePrompt(arabic: 'أب', audioFile: 'ab_father.mp3'),
      options: <ExerciseOption>[
        ExerciseOption(imageAsset: 'illustrations/lion.png', isCorrect: false),
        ExerciseOption(
          imageAsset: 'illustrations/father_son.png',
          isCorrect: true,
        ),
      ],
      columns: 2,
    ),
    CheckpointStep(title: 'Outstanding Job!', subtitle: 'You crushed it'),
    RepeatAfterExercise(
      word: 'أسد',
      meaning: 'Lion',
      imageAsset: 'illustrations/lion.png',
      audioFile: 'asad_lion.mp3',
    ),
    ChoiceExercise(
      heading: 'Form the word',
      prompt: ChoicePrompt(
        imageAsset: 'illustrations/lion.png',
        arabic: '...سد',
      ),
      audioFile: 'asad_lion.mp3',
      options: <ExerciseOption>[
        ExerciseOption(letter: 'أ', isCorrect: true),
        ExerciseOption(letter: 'ط', isCorrect: false),
        ExerciseOption(letter: 'ب', isCorrect: false),
        ExerciseOption(letter: 'ت', isCorrect: false),
      ],
      columns: 4,
      letterTiles: true,
    ),
    RepeatAfterExercise(
      word: 'أرنب',
      meaning: 'Rabbit',
      imageAsset: 'illustrations/rabbits.png',
      audioFile: 'arnab_rabbit.mp3',
    ),
  ],
);
