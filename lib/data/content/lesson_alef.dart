import 'dart:math';
import 'dart:ui';

import '../../core/theme/lp_colors.dart';
import '../models/exercise.dart';
import '../models/lesson.dart';

/// Alef (أ) — a tall vertical bar of stacked bricks with a small
/// hamza-like hook at the top-left. Grid: 6 columns × 8 rows.
const Lesson lessonAlef = Lesson(
  id: 'lesson_alef',
  letterId: 'alef',
  titleArabic: 'أ',
  titleLatin: 'Alef',
  exercises: <Exercise>[
    LetterIntroExercise(
      glyph: 'أ',
      nameArabic: 'ألف',
      nameLatin: 'ALEF',
      translit: 'aa',
      audioFile: 'alef.mp3',
    ),
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
    ),
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
    MatchImageExercise(
      word: 'أب',
      translit: 'ab',
      meaning: 'Father',
      audioFile: 'ab_father.mp3',
      options: <ExerciseOption>[
        ExerciseOption(emoji: '👨', label: 'Father', isCorrect: true),
        ExerciseOption(emoji: '🐰', label: 'Rabbit', isCorrect: false),
        ExerciseOption(emoji: '🦁', label: 'Lion', isCorrect: false),
      ],
    ),
    ListenChooseExercise(
      // أسد — lion.
      audioFile: 'asad_lion.mp3',
      options: <ExerciseOption>[
        ExerciseOption(emoji: '🦁', label: 'Lion', isCorrect: true),
        ExerciseOption(emoji: '👨', label: 'Father', isCorrect: false),
        ExerciseOption(emoji: '🐰', label: 'Rabbit', isCorrect: false),
        ExerciseOption(letter: 'أ', isCorrect: false),
      ],
    ),
  ],
);
