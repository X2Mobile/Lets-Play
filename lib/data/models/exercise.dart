import 'dart:math';

import 'package:flutter/material.dart';

/// One answer choice in match / listen exercises.
///
/// Exactly one of [emoji] (illustration placeholder), [imageAsset]
/// (bundled illustration) or [letter] (Arabic letter card) should be set.
@immutable
class ExerciseOption {
  const ExerciseOption({
    this.emoji,
    this.imageAsset,
    this.letter,
    this.label,
    required this.isCorrect,
  });

  /// Big emoji illustration (e.g. `🦁`) rendered ~64–80 px on a white card.
  final String? emoji;

  /// Bundled illustration cropped from the design SVGs
  /// (path under `assets/images/`, e.g. `illustrations/lion.png`).
  final String? imageAsset;

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
    this.formTabs = const <String>[],
    this.activeFormIndex = 0,
    this.guideLabel,
    this.successToast = false,
  });

  final int gridColumns;
  final int gridRows;

  /// Top-left grid cell of each slot; same length/order as [pieces].
  final List<Point<int>> slots;
  final List<BrickPiece> pieces;
  final int timerSeconds;
  final int maxMoves;

  /// Positional-form tabs above the board (design LEVEL 1/3: ا ا أ with the
  /// active one green). Empty hides the row.
  final List<String> formTabs;
  final int activeFormIndex;

  /// Draws a dotted green guide line under the board with this label
  /// (`Baseline`, `Ascender`).
  final String? guideLabel;

  /// Shows the "Awesome! You nailed it!" banner on completion. Only where
  /// the design has it (LEVEL 2/8, LEVEL 3/6) — Level 1 advances silently.
  final bool successToast;
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

// --- Variants added for the 2026-07 design drop (all five levels). ---

/// A row inside a [TeachCardExercise]: an Arabic example with its gloss
/// (e.g. `خرج · (Past) He went out`).
@immutable
class TeachItem {
  const TeachItem({required this.arabic, this.gloss, this.audioFile});

  final String arabic;

  /// Latin/English annotation shown under or next to [arabic].
  final String? gloss;
  final String? audioFile;
}

/// 6. "Learn" card: colored card with an Arabic title, Latin gloss and
/// optional example items ("انواع الكلمات (Word Types)" etc.). CONTINUE is
/// enabled immediately; audio (if any) auto-plays.
final class TeachCardExercise extends Exercise {
  const TeachCardExercise({
    this.heading,
    required this.titleArabic,
    this.titleLatin,
    this.subtitle,
    this.audioFile,
    this.cardColor,
    this.items = const <TeachItem>[],
    this.imageAsset,
  });

  /// Optional heading above the card (e.g. `Learn`).
  final String? heading;
  final String titleArabic;

  /// e.g. `(FAT-HAH)` or `Word Types`.
  final String? titleLatin;

  /// Extra formula line, e.g. `Letter+a`.
  final String? subtitle;
  final String? audioFile;

  /// Card fill; defaults to the lesson's level color when null.
  final Color? cardColor;
  final List<TeachItem> items;
  final String? imageAsset;
}

/// 7. Press-to-reveal flashcard: tapping the big glyph toggles between the
/// printed glyph and its LEGO-brick rendering, replaying the audio
/// ("Press on the letter").
final class PressRevealExercise extends Exercise {
  const PressRevealExercise({
    required this.glyph,
    required this.nameArabic,
    required this.nameLatin,
    this.audioFile,
    required this.gridColumns,
    required this.gridRows,
    required this.slots,
    required this.pieces,
  });

  final String glyph;
  final String nameArabic;
  final String nameLatin;
  final String? audioFile;

  /// Brick layout of the LEGO rendering — same convention as
  /// [BuildLetterExercise].
  final int gridColumns;
  final int gridRows;
  final List<Point<int>> slots;
  final List<BrickPiece> pieces;
}

/// 8. Positional-forms reference: `Alef Letter Forms` — Initial / Isolated /
/// Final / Medial glyph cards. CONTINUE enabled immediately.
final class LetterFormsExercise extends Exercise {
  const LetterFormsExercise({required this.title, required this.forms});

  final String title;

  /// label → glyph, in display order (e.g. `Initial` → `أ`).
  final List<(String, String)> forms;
}

/// What the prompt card of a [ChoiceExercise] shows.
@immutable
class ChoicePrompt {
  const ChoicePrompt({
    this.arabic,
    this.latin,
    this.caption,
    this.imageAsset,
    this.emoji,
    this.brickCount,
    this.cardColor,
    this.audioFile,
  });

  /// Arabic text on the prompt card (word, letter or sentence with `....`
  /// for a blank).
  final String? arabic;

  /// Latin line under [arabic] (e.g. `Means "Two"`).
  final String? latin;

  /// Caption below the card.
  final String? caption;
  final String? imageAsset;
  final String? emoji;

  /// Renders N 2×2 bricks to count ("How many legos?").
  final int? brickCount;
  final Color? cardColor;
  final String? audioFile;
}

/// 9. Generic single-choice exercise: heading + optional prompt card +
/// optional audio (with snail) + a column/grid of answers. Covers
/// true/false, choose-the-pronunciation, fill-the-blank, classify,
/// choose-the-sentence-you-hear, form-the-word and count-the-legos.
final class ChoiceExercise extends Exercise {
  const ChoiceExercise({
    required this.heading,
    this.prompt,
    this.audioFile,
    required this.options,
    this.columns = 1,
    this.letterTiles = false,
  });

  final String heading;
  final ChoicePrompt? prompt;

  /// Auto-plays on entry and renders speaker + snail buttons when set.
  final String? audioFile;
  final List<ExerciseOption> options;

  /// 1 = full-width rows (sentences), 2/3 = compact tiles.
  final int columns;

  /// Renders options as small square Arabic letter tiles (form-the-word).
  final bool letterTiles;
}

/// 10. Multi-select: "Choose all the Nouns" — tap every correct tile.
final class MultiSelectExercise extends Exercise {
  const MultiSelectExercise({
    required this.heading,
    this.prompt,
    required this.options,
    this.columns = 2,
  });

  final String heading;
  final ChoicePrompt? prompt;
  final List<ExerciseOption> options;
  final int columns;
}

/// 11. "Form the sentence": drag/tap shuffled word tiles onto the dotted
/// answer line in the right (RTL) order.
final class FormSentenceExercise extends Exercise {
  const FormSentenceExercise({
    required this.heading,
    this.audioFile,
    required this.words,
    this.distractors = const <String>[],
  });

  final String heading;
  final String? audioFile;

  /// The correct sentence, first word first (rendered right-to-left).
  final List<String> words;

  /// Extra wrong tiles mixed into the tray.
  final List<String> distractors;
}

/// One line of a [ListenDialogueExercise].
@immutable
class DialogueLine {
  const DialogueLine({
    required this.text,
    this.audioFile,
    this.speakerAsset,
    this.alignEnd = false,
  });

  final String text;
  final String? audioFile;

  /// Character illustration (path under `assets/images/`).
  final String? speakerAsset;

  /// Second speaker: bubble and portrait on the trailing side.
  final bool alignEnd;
}

/// 12. "Listen to the dialogue": two characters, each with a speech bubble
/// and its own play button. CONTINUE enables after any bubble is played
/// (or immediately when no audio is bundled).
final class ListenDialogueExercise extends Exercise {
  const ListenDialogueExercise({required this.lines});

  final List<DialogueLine> lines;
}

/// 13. "Repeat what you heard": picture + Arabic word + speaker button and a
/// microphone. Holding/tapping the mic animates a fake sound wave and then
/// marks the exercise solved (concept demo — no real speech recognition).
final class RepeatAfterExercise extends Exercise {
  const RepeatAfterExercise({
    required this.word,
    this.meaning,
    this.imageAsset,
    this.emoji,
    this.audioFile,
    this.breakdown = const <TeachItem>[],
  });

  final String word;
  final String? meaning;
  final String? imageAsset;
  final String? emoji;
  final String? audioFile;

  /// Optional per-syllable tiles shown above the picture (أَ كَ لَ …).
  final List<TeachItem> breakdown;
}

/// 14. "Place the Fatha in the correct location": the mark must be dropped
/// on the correct dotted slot around the base letter.
final class PlaceDiacriticExercise extends Exercise {
  const PlaceDiacriticExercise({
    required this.baseGlyph,
    required this.mark,
    this.audioFile,
    this.slotAbove = true,
  });

  final String baseGlyph;

  /// The tashkeel mark being placed (e.g. `ـَ`).
  final String mark;
  final String? audioFile;

  /// Whether the correct slot is above the letter (fatha/damma) or below
  /// (kasra).
  final bool slotAbove;
}

/// 15. Tutorial interstitial: mascot holding a banner ("Tap on the blocks /
/// To form the letter") with a LETS PLAY button.
final class TutorialStep extends Exercise {
  const TutorialStep({required this.line1, required this.line2});

  final String line1;
  final String line2;
}

/// 16. Checkpoint interstitial: "Great Job Malak! / now let's test you".
final class CheckpointStep extends Exercise {
  const CheckpointStep({required this.title, required this.subtitle});

  final String title;
  final String subtitle;
}
