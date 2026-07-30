import 'package:flutter/foundation.dart';

/// An Arabic letter (or tashkeel mark) tile in a level grid.
@immutable
class Letter {
  const Letter({
    required this.id,
    required this.glyph,
    required this.translit,
    this.lessonId,
  });

  final String id;

  /// The Arabic glyph shown big on the tile (e.g. `أ`).
  final String glyph;

  /// Latin transliteration shown under the glyph (e.g. `aa`).
  final String translit;

  /// Lesson to launch when the unlocked tile is tapped; null = no lesson yet.
  final String? lessonId;
}
