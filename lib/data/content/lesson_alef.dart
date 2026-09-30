import 'dart:math';
import 'dart:ui';

import '../../core/theme/lp_colors.dart';
import '../models/exercise.dart';
import '../models/lesson.dart';

// Alef is 2 cells wide × 10 tall: a one-cell-wide orange stem standing on the
// Baseline, with the red hamza hook floating above it, stepping up and to the
// left. The hamza is written separately, so a one-row gap splits it from the
// stem (client amends, Sep 2026) —
//
//     . ▉        row 0     1×1 hamza tip (right cell), drawn a quarter cell
//                          low so it joins the elbow instead of touching
//                          it only at a corner
//     ▉ .        row 1     1×1 hamza elbow (left cell)
//     ▉ ▉        row 2     2×1 hamza base
//     . .        row 3     gap
//     . ▉        rows 4–9  1×6 stem, right cell, down to the Baseline
//
// All four bricks are placed by the child.

/// Alef's bricks in slot order: hamza tip, hamza elbow, hamza base, stem.
const List<BrickPiece> _alefPieces = <BrickPiece>[
  BrickPiece(columns: 1, rows: 1, color: LpColors.crimson, nudgeY: 0.25),
  BrickPiece(columns: 1, rows: 1, color: LpColors.crimson),
  BrickPiece(columns: 2, rows: 1, color: LpColors.crimson),
  BrickPiece(columns: 1, rows: 6, color: LpColors.orange),
];

/// The whole letter on a tight 2 × 10 grid (press-reveal glyph, trace board),
/// ordered to match [_alefPieces].
const List<Point<int>> _alefTightSlots = <Point<int>>[
  Point<int>(1, 0),
  Point<int>(0, 1),
  Point<int>(0, 2),
  Point<int>(1, 4),
];

/// Level 1 · Lesson 1 — the letter Alef (design `LEVEL 1/0–29`): build the
/// brick letter over the Baseline, press-to-reveal it, study its positional
/// forms, trace it, then run the test battery (listen, true/false, speak,
/// picture↔word matches and form-the-word).
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
    // The stem and the hamza hook dragged out of the tray, with the
    // positional-form tabs and the Baseline guide (design LEVEL 1/3–6).
    // The letter sits centred on cols 4–5, low on the plate: the stem's foot
    // rests on row 11 so the Baseline (row 12) runs right along it.
    BuildLetterExercise(
      gridColumns: 11,
      gridRows: 13,
      // pieces[i] snaps onto the slot whose top-left cell is slots[i].
      slots: <Point<int>>[
        Point<int>(5, 2), // hamza tip
        Point<int>(4, 3), // hamza elbow
        Point<int>(4, 4), // hamza base
        Point<int>(5, 6), // stem — row 5 is the gap under the hamza
      ],
      pieces: _alefPieces,
      timerSeconds: 30,
      maxMoves: 10,
      // RTL row — index 0 is the rightmost tab, so أ leads and is the green one.
      formTabs: <String>['أ', 'ا', 'ـا'],
      activeFormIndex: 0,
      guides: <LetterGuide>[LetterGuide(GuideKind.baseline, row: 12)],
    ),
    PressRevealExercise(
      glyph: 'أ',
      nameArabic: 'ألف',
      nameLatin: 'Alef',
      audioFile: 'alef.mp3',
      gridColumns: 2,
      gridRows: 10,
      slots: _alefTightSlots,
      pieces: _alefPieces,
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
      gridColumns: 2,
      gridRows: 10,
      slots: _alefTightSlots,
      pieces: _alefPieces,
      // Hamza hook first (tip → elbow → base), then the stem top → bottom.
      // Normalized to the 2 × 10 board: y = (row + 0.5) / 10.
      path: <Offset>[
        Offset(0.75, 0.05),
        Offset(0.25, 0.15),
        Offset(0.30, 0.25),
        Offset(0.75, 0.25),
        Offset(0.75, 0.45), // pen lift over the gap to the stem
        Offset(0.75, 0.60),
        Offset(0.75, 0.75),
        Offset(0.75, 0.95),
      ],
      strokeStarts: <int>{4},
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
