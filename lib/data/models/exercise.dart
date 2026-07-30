import 'dart:math';

import 'package:flutter/material.dart';

/// One answer choice in match / listen exercises.
///
/// Exactly one of [emoji] (illustration placeholder) or [letter]
/// (Arabic letter card) should be set.
@immutable
class ExerciseOption {
  const ExerciseOption({
    this.emoji,
    this.letter,
    this.label,
    required this.isCorrect,
  });

  /// Big emoji illustration (e.g. `🦁`) rendered ~64–80 px on a white card.
  final String? emoji;

  /// Arabic letter alternative (e.g. `أ`) rendered as a letter card.
  final String? letter;

  /// Optional English caption (e.g. `Lion`).
  final String? label;
  final bool isCorrect;
}

/// A colored brick shape: [columns] × [rows] studs.
@immutable
class BrickPiece {
  const BrickPiece({
    required this.columns,
    required this.rows,
    required this.color,
  });

  final int columns;
  final int rows;
  final Color color;
}

/// Base of every lesson step. Sealed so the lesson flow can exhaustively
/// `switch` on the variant and render the matching exercise page.
@immutable
sealed class Exercise {
  const Exercise();
}

/// 1. Big yellow card with the letter; audio auto-plays; CONTINUE.
final class LetterIntroExercise extends Exercise {
  const LetterIntroExercise({
    required this.glyph,
    required this.nameArabic,
    required this.nameLatin,
    required this.translit,
    required this.audioFile,
  });

  /// The letter itself, e.g. `أ`.
  final String glyph;

  /// e.g. `ألف`.
  final String nameArabic;

  /// e.g. `ALEF`.
  final String nameLatin;

  /// e.g. `aa`.
  final String translit;
  final String audioFile;
}

/// 2. Drag bricks from the tray onto ghost outline slots on the baseplate.
///
/// The letter shape is described on a cell grid of [gridColumns] ×
/// [gridRows]. `pieces[i]` belongs on the slot whose **top-left cell** is
/// `slots[i]` and spans `pieces[i].columns × pieces[i].rows` cells.
/// [timerSeconds] and [maxMoves] are cosmetic — there is no fail state.
final class BuildLetterExercise extends Exercise {
  const BuildLetterExercise({
    required this.gridColumns,
    required this.gridRows,
    required this.slots,
    required this.pieces,
    this.timerSeconds = 30,
    this.maxMoves = 8,
  });

  final int gridColumns;
  final int gridRows;

  /// Top-left grid cell of each slot; same length/order as [pieces].
  final List<Point<int>> slots;
  final List<BrickPiece> pieces;
  final int timerSeconds;
  final int maxMoves;
}

/// 3. The letter is shown built from bricks; the child drags a finger along
/// [path] (normalized 0..1 coordinates over the tracing canvas, in drawing
/// order). Hit-testing should be forgiving (generous radius).
final class TraceLetterExercise extends Exercise {
  const TraceLetterExercise({
    required this.gridColumns,
    required this.gridRows,
    required this.slots,
    required this.pieces,
    required this.path,
  });

  final int gridColumns;
  final int gridRows;

  /// Brick layout of the finished letter — same convention as
  /// [BuildLetterExercise].
  final List<Point<int>> slots;
  final List<BrickPiece> pieces;

  /// Normalized waypoints (x, y in 0..1) along the stroke, in order.
  final List<Offset> path;
}

/// 4. "Match the image": Arabic word + audio, pick the right illustration.
final class MatchImageExercise extends Exercise {
  const MatchImageExercise({
    required this.word,
    required this.translit,
    required this.meaning,
    required this.audioFile,
    required this.options,
  });

  /// Arabic prompt, e.g. `أب`.
  final String word;

  /// e.g. `ab`.
  final String translit;

  /// English meaning, e.g. `Father`.
  final String meaning;
  final String audioFile;
  final List<ExerciseOption> options;
}

/// 5. "Choose what you heard": big audio button + snail slow-play (0.6×),
/// 2×2 grid of emoji/letter cards.
final class ListenChooseExercise extends Exercise {
  const ListenChooseExercise({required this.audioFile, required this.options});

  final String audioFile;
  final List<ExerciseOption> options;
}
