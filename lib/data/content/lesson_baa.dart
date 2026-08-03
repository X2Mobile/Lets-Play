import 'dart:math';
import 'dart:ui';

import '../../core/theme/lp_colors.dart';
import '../models/exercise.dart';
import '../models/lesson.dart';

/// Baa (ب) — a wide shallow bowl (left lip, long bottom, right riser)
/// with one dot brick below the baseline. Grid: 8 columns × 6 rows.
const Lesson lessonBaa = Lesson(
  id: 'lesson_baa',
  letterId: 'baa',
  titleArabic: 'ب',
  titleLatin: 'Baa',
  levelNumber: 1,
  lessonNumber: 2,
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
    LetterIntroExercise(
      glyph: 'ب',
      nameArabic: 'باء',
      nameLatin: 'BAA',
      translit: 'b',
      audioFile: 'baa.mp3',
    ),
    BuildLetterExercise(
      gridColumns: 8,
      gridRows: 6,
      // pieces[i] snaps onto the slot whose top-left cell is slots[i].
      slots: <Point<int>>[
        Point<int>(1, 2), // left lip (curls up)
        Point<int>(1, 3), // bowl bottom, left span
        Point<int>(5, 3), // bowl bottom, right span
        Point<int>(6, 1), // right riser
        Point<int>(3, 5), // the dot below the baseline
      ],
      pieces: <BrickPiece>[
        BrickPiece(columns: 1, rows: 1, color: LpColors.legoGreen),
        BrickPiece(columns: 4, rows: 1, color: LpColors.brickRed),
        BrickPiece(columns: 2, rows: 1, color: LpColors.orange),
        BrickPiece(columns: 1, rows: 2, color: LpColors.purple),
        BrickPiece(columns: 1, rows: 1, color: LpColors.royalBlue),
      ],
      timerSeconds: 30,
      maxMoves: 10,
      formTabs: <String>['بـ', 'ـبـ', 'ب'],
      activeFormIndex: 2,
      guideLabel: 'Baseline',
    ),
    TraceLetterExercise(
      gridColumns: 8,
      gridRows: 6,
      slots: <Point<int>>[
        Point<int>(1, 2),
        Point<int>(1, 3),
        Point<int>(5, 3),
        Point<int>(6, 1),
        Point<int>(3, 5),
      ],
      pieces: <BrickPiece>[
        BrickPiece(columns: 1, rows: 1, color: LpColors.legoGreen),
        BrickPiece(columns: 4, rows: 1, color: LpColors.brickRed),
        BrickPiece(columns: 2, rows: 1, color: LpColors.orange),
        BrickPiece(columns: 1, rows: 2, color: LpColors.purple),
        BrickPiece(columns: 1, rows: 1, color: LpColors.royalBlue),
      ],
      // Arabic stroke order: start at the right riser, sweep the bowl to
      // the left lip, then the dot below.
      path: <Offset>[
        Offset(0.82, 0.28),
        Offset(0.82, 0.48),
        Offset(0.74, 0.58),
        Offset(0.60, 0.63),
        Offset(0.44, 0.63),
        Offset(0.30, 0.60),
        Offset(0.19, 0.50),
        Offset(0.19, 0.42),
        Offset(0.44, 0.88), // lift to the dot
      ],
    ),
    MatchImageExercise(
      word: 'بطة',
      translit: 'batta',
      meaning: 'Duck',
      audioFile: 'batta_duck.mp3',
      options: <ExerciseOption>[
        ExerciseOption(emoji: '🦆', label: 'Duck', isCorrect: true),
        ExerciseOption(emoji: '🚪', label: 'Door', isCorrect: false),
        ExerciseOption(emoji: '🐄', label: 'Cow', isCorrect: false),
      ],
    ),
    ListenChooseExercise(
      // باب — door.
      audioFile: 'bab_door.mp3',
      options: <ExerciseOption>[
        ExerciseOption(emoji: '🚪', label: 'Door', isCorrect: true),
        ExerciseOption(emoji: '🦆', label: 'Duck', isCorrect: false),
        ExerciseOption(emoji: '🐄', label: 'Cow', isCorrect: false),
        ExerciseOption(letter: 'ب', isCorrect: false),
      ],
    ),
  ],
);
