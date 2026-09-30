import 'dart:math';
import 'dart:ui';

import '../../core/theme/lp_colors.dart';
import '../models/exercise.dart';
import '../models/lesson.dart';

// Baa (ب) — a symmetric bowl: two equal risers on a single long base, one
// dot below the Baseline (client amends, Sep 2026: each side and the base
// are one piece each, both sides the same height). Grid: 9 columns × 6 rows.
//
//     . ▉ . . . . . ▉ .    rows 1–2  1×2 left riser, 1×2 right riser
//     . ▉ ▉ ▉ ▉ ▉ ▉ ▉ .    row 3     7×1 base
//     ─────────────────    Baseline (top of row 4)
//     . . . . ▉ . . . .    row 5     the dot

/// Baa's bricks in slot order: right riser, left riser, base, dot.
const List<BrickPiece> _baaPieces = <BrickPiece>[
  BrickPiece(columns: 1, rows: 2, color: LpColors.royalBlue),
  BrickPiece(columns: 1, rows: 2, color: LpColors.royalBlue),
  BrickPiece(columns: 7, rows: 1, color: LpColors.legoGreen),
  BrickPiece(columns: 1, rows: 1, color: LpColors.orange),
];

/// Top-left cells matching [_baaPieces].
const List<Point<int>> _baaSlots = <Point<int>>[
  Point<int>(7, 1),
  Point<int>(1, 1),
  Point<int>(1, 3),
  Point<int>(4, 5),
];

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
      gridColumns: 9,
      gridRows: 6,
      // pieces[i] snaps onto the slot whose top-left cell is slots[i]; the
      // two risers are the same brick, so either fits either side.
      slots: _baaSlots,
      pieces: _baaPieces,
      timerSeconds: 30,
      maxMoves: 10,
      // RTL row — index 0 is the rightmost tab, so the form being built leads
      // and is the green one; then initial, medial, and the final form ـب as
      // the leftmost tab.
      formTabs: <String>['ب', 'بـ', 'ـبـ', 'ـب'],
      activeFormIndex: 0,
      guides: <LetterGuide>[LetterGuide(GuideKind.baseline, row: 4)],
    ),
    // Same reference screen as alef's, after the letter is built.
    LetterFormsExercise(
      title: 'Baa Letter Forms',
      forms: <(String, String)>[
        ('Initial', 'بـ'),
        ('Isolated', 'ب'),
        ('Final', 'ـب'),
        ('Medial', 'ـبـ'),
      ],
    ),
    TraceLetterExercise(
      gridColumns: 9,
      gridRows: 6,
      slots: _baaSlots,
      pieces: _baaPieces,
      // Arabic stroke order: down the right riser, along the base to the
      // left riser and up it, then the dot below. Normalized to the 9 × 6
      // board: x = (col + 0.5) / 9, y = (row + 0.5) / 6.
      path: <Offset>[
        Offset(0.83, 0.25),
        Offset(0.83, 0.58),
        Offset(0.50, 0.58),
        Offset(0.17, 0.58),
        Offset(0.17, 0.25),
        Offset(0.50, 0.92), // lift to the dot
      ],
      strokeStarts: <int>{5},
    ),
    MatchImageExercise(
      word: 'بطة',
      translit: 'batta',
      meaning: 'Duck',
      audioFile: 'batta_duck.mp3',
      options: <ExerciseOption>[
        ExerciseOption(
          imageAsset: 'illustrations/duck.png',
          emoji: '🦆',
          label: 'Duck',
          isCorrect: true,
        ),
        ExerciseOption(
          imageAsset: 'illustrations/door.png',
          emoji: '🚪',
          label: 'Door',
          isCorrect: false,
        ),
        ExerciseOption(
          imageAsset: 'illustrations/cow.png',
          emoji: '🐄',
          label: 'Cow',
          isCorrect: false,
        ),
      ],
    ),
    ListenChooseExercise(
      // باب — door.
      audioFile: 'bab_door.mp3',
      options: <ExerciseOption>[
        ExerciseOption(
          imageAsset: 'illustrations/door.png',
          emoji: '🚪',
          label: 'Door',
          isCorrect: true,
        ),
        ExerciseOption(
          imageAsset: 'illustrations/duck.png',
          emoji: '🦆',
          label: 'Duck',
          isCorrect: false,
        ),
        ExerciseOption(
          imageAsset: 'illustrations/cow.png',
          emoji: '🐄',
          label: 'Cow',
          isCorrect: false,
        ),
        ExerciseOption(letter: 'ب', isCorrect: false),
      ],
    ),
  ],
);
