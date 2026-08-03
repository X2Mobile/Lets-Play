import 'dart:math';
import 'dart:ui';

import '../../core/theme/lp_colors.dart';
import '../models/exercise.dart';
import '../models/lesson.dart';

/// Level 3 · Lesson 1 — the number ٢ / اثنان (design `LEVEL 3/0–20`): build
/// the brick numeral, learn it, rebuild it, then run the test battery
/// (true/false, match, listen, count, trace, pronounce).
const Lesson lessonIthnan = Lesson(
  id: 'lesson_ithnan',
  titleArabic: '٢',
  titleLatin: 'Ithnan',
  levelNumber: 3,
  lessonNumber: 1,
  levelColor: LpColors.levelBlue,
  introChecklist: <String>[
    'Forming the number',
    'Writing the number',
    'Pronunciation',
  ],
  introCharacterAsset: 'characters/intro_l3.png',
  countdownCharacterAsset: 'characters/countdown_l3.png',
  pointsReward: 5380,
  accuracyLabel: '82%',
  speedLabel: '1:50',
  exercises: <Exercise>[
    TutorialStep(line1: 'Tap on the blocks', line2: 'To form the number'),
    // The LEGO stylization of ٢: horizontal orange bar with the purple stem
    // descending from its left end (design LEVEL 3/3 and /10).
    BuildLetterExercise(
      gridColumns: 9,
      gridRows: 9,
      slots: <Point<int>>[
        Point<int>(2, 1), // horizontal bar
        Point<int>(2, 3), // vertical stem below the bar's left end
      ],
      pieces: <BrickPiece>[
        BrickPiece(columns: 6, rows: 2, color: LpColors.orange),
        BrickPiece(columns: 2, rows: 5, color: LpColors.purple),
      ],
      timerSeconds: 30,
      maxMoves: 10,
    ),
    TeachCardExercise(
      titleArabic: 'اثنان',
      titleLatin: 'Two',
      audioFile: 'ithnan_two.mp3',
      cardColor: LpColors.levelBlue,
    ),
    PressRevealExercise(
      glyph: '٢',
      nameArabic: 'إثنان',
      nameLatin: 'Ithnan',
      audioFile: 'ithnan_two.mp3',
      gridColumns: 9,
      gridRows: 9,
      slots: <Point<int>>[Point<int>(2, 1), Point<int>(2, 3)],
      pieces: <BrickPiece>[
        BrickPiece(columns: 6, rows: 2, color: LpColors.orange),
        BrickPiece(columns: 2, rows: 5, color: LpColors.purple),
      ],
    ),
    TutorialStep(line1: 'Form the number', line2: 'Using the blocks'),
    BuildLetterExercise(
      gridColumns: 9,
      gridRows: 9,
      slots: <Point<int>>[Point<int>(2, 1), Point<int>(2, 3)],
      pieces: <BrickPiece>[
        BrickPiece(columns: 6, rows: 2, color: LpColors.orange),
        BrickPiece(columns: 2, rows: 5, color: LpColors.purple),
      ],
      timerSeconds: 30,
      maxMoves: 10,
    ),
    CheckpointStep(title: 'Great Job Malak!', subtitle: "now let's test you"),
    ChoiceExercise(
      heading: 'True or False',
      prompt: ChoicePrompt(arabic: 'أثنان', latin: 'Means "Two"'),
      options: <ExerciseOption>[
        ExerciseOption(label: 'True', isCorrect: true),
        ExerciseOption(label: 'False', isCorrect: false),
      ],
      columns: 2,
    ),
    ChoiceExercise(
      heading: 'True or False',
      prompt: ChoicePrompt(arabic: '٢', latin: 'Means "Two"'),
      options: <ExerciseOption>[
        ExerciseOption(label: 'True', isCorrect: true),
        ExerciseOption(label: 'False', isCorrect: false),
      ],
      columns: 2,
    ),
    ChoiceExercise(
      heading: 'Match the image',
      prompt: ChoicePrompt(arabic: '٢', audioFile: 'ithnan_two.mp3'),
      options: <ExerciseOption>[
        ExerciseOption(emoji: '🧱🧱', isCorrect: true),
        ExerciseOption(emoji: '🧱', isCorrect: false),
      ],
      columns: 2,
    ),
    ChoiceExercise(
      heading: 'Listen & choose the number',
      audioFile: 'ithnan_two.mp3',
      options: <ExerciseOption>[
        ExerciseOption(letter: '١', isCorrect: false),
        ExerciseOption(letter: '٢', isCorrect: true),
        ExerciseOption(letter: '٣', isCorrect: false),
      ],
      columns: 3,
      letterTiles: true,
    ),
    ChoiceExercise(
      heading: 'How many legos?',
      prompt: ChoicePrompt(brickCount: 2),
      options: <ExerciseOption>[
        ExerciseOption(letter: '١', isCorrect: false),
        ExerciseOption(letter: '٢', isCorrect: true),
      ],
      columns: 2,
      letterTiles: true,
    ),
    // "Write the number": trace the brick numeral (bar right→left, then the
    // stem top→bottom).
    TraceLetterExercise(
      gridColumns: 9,
      gridRows: 9,
      slots: <Point<int>>[Point<int>(2, 1), Point<int>(2, 3)],
      pieces: <BrickPiece>[
        BrickPiece(columns: 6, rows: 2, color: LpColors.orange),
        BrickPiece(columns: 2, rows: 5, color: LpColors.purple),
      ],
      path: <Offset>[
        Offset(0.82, 0.22),
        Offset(0.62, 0.22),
        Offset(0.42, 0.22),
        Offset(0.33, 0.30),
        Offset(0.33, 0.45),
        Offset(0.33, 0.60),
        Offset(0.33, 0.75),
        Offset(0.33, 0.86),
      ],
    ),
    RepeatAfterExercise(
      word: '٢',
      meaning: 'Ithnan · Two',
      imageAsset: 'illustrations/rabbits_two.png',
      audioFile: 'ithnan_two.mp3',
    ),
  ],
);
