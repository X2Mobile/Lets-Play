import 'dart:math';

import '../../core/theme/lp_colors.dart';
import '../models/exercise.dart';
import '../models/lesson.dart';

/// Level 2 · Lesson 1 — the fatha (design `LEVEL 2/0–21`): build the
/// ascending three-brick stroke over the Ascender line, learn the mark,
/// drill letter+fatha pronunciations, place the fatha, speak أكَلَ and match
/// the mark's position.
const Lesson lessonFatha = Lesson(
  id: 'lesson_fatha',
  titleArabic: 'فتحه',
  titleLatin: 'Fatha',
  levelNumber: 2,
  lessonNumber: 1,
  levelColor: LpColors.levelOrange,
  introChecklist: <String>[
    'Forms of Tashkeel',
    'Writing the Tashkeel',
    'Pronunciation',
  ],
  introCharacterAsset: 'characters/intro_l2.png',
  countdownCharacterAsset: 'characters/countdown_l2.png',
  pointsReward: 4060,
  accuracyLabel: '82%',
  speedLabel: '1:50',
  exercises: <Exercise>[
    TutorialStep(line1: 'Tap on the blocks', line2: 'To form the tashkeel'),
    // The rising fatha stroke: three orange 2×2 bricks stepping up over the
    // Ascender line (design LEVEL 2/4–6).
    BuildLetterExercise(
      gridColumns: 8,
      gridRows: 7,
      slots: <Point<int>>[
        Point<int>(1, 4), // bottom-left step
        Point<int>(3, 3), // middle step
        Point<int>(5, 2), // top-right step
      ],
      pieces: <BrickPiece>[
        BrickPiece(columns: 2, rows: 2, color: LpColors.levelOrange),
        BrickPiece(columns: 2, rows: 2, color: LpColors.levelOrange),
        BrickPiece(columns: 2, rows: 2, color: LpColors.levelOrange),
      ],
      timerSeconds: 30,
      maxMoves: 10,
      guideLabel: 'Ascender',
      successToast: true,
    ),
    TeachCardExercise(
      titleArabic: 'فتحه',
      titleLatin: '(FAT-HAH)',
      subtitle: 'Letter+a',
      audioFile: 'fatha.mp3',
      cardColor: LpColors.levelOrange,
    ),
    CheckpointStep(title: 'Great Job Malak!', subtitle: "now let's test you"),
    TeachCardExercise(
      heading: 'Learn',
      titleArabic: 'كَ',
      titleLatin: 'KAF+a = Ka',
      audioFile: 'ka_fatha.mp3',
      cardColor: LpColors.levelOrange,
    ),
    TeachCardExercise(
      heading: 'Learn',
      titleArabic: 'لَ',
      titleLatin: 'LAM+a = La',
      audioFile: 'la_fatha.mp3',
      cardColor: LpColors.levelOrange,
    ),
    ChoiceExercise(
      heading: 'Choose the pronunciation',
      prompt: ChoicePrompt(arabic: 'كَ', audioFile: 'ka_fatha.mp3'),
      options: <ExerciseOption>[
        ExerciseOption(label: 'Ka', isCorrect: true),
        ExerciseOption(label: 'Ki', isCorrect: false),
        ExerciseOption(label: 'Ko', isCorrect: false),
      ],
      columns: 3,
    ),
    ChoiceExercise(
      heading: 'Choose the pronunciation',
      prompt: ChoicePrompt(arabic: 'تَ'),
      options: <ExerciseOption>[
        ExerciseOption(label: 'Ti', isCorrect: false),
        ExerciseOption(label: 'To', isCorrect: false),
        ExerciseOption(label: 'Ta', isCorrect: true),
      ],
      columns: 3,
    ),
    PlaceDiacriticExercise(
      baseGlyph: 'ك',
      mark: 'ـَ',
      audioFile: 'fatha.mp3',
      slotAbove: true,
    ),
    RepeatAfterExercise(
      word: 'أكَلَ',
      meaning: 'Ate',
      imageAsset: 'illustrations/fruit_bowl.png',
      breakdown: <TeachItem>[
        TeachItem(arabic: 'أَ'),
        TeachItem(arabic: 'كَ'),
        TeachItem(arabic: 'لَ'),
      ],
    ),
    ChoiceExercise(
      heading: 'Match the diacritical mark to its correct shape',
      prompt: ChoicePrompt(
        arabic: 'فتحة',
        audioFile: 'fatha.mp3',
        caption: 'Which shows the fatha?',
      ),
      options: <ExerciseOption>[
        ExerciseOption(letter: 'كَ', isCorrect: true),
        ExerciseOption(letter: 'كِ', isCorrect: false),
      ],
      columns: 2,
    ),
  ],
);
