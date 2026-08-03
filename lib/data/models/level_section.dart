import 'package:flutter/material.dart';

/// A big tile on the Level-4/5 bands: category card with an Arabic example
/// word and an English label ("2 letter words · في", "Introduce Yourself ·
/// عرف نفسك").
@immutable
class LevelCategory {
  const LevelCategory({
    required this.id,
    required this.arabic,
    required this.english,
    this.lessonId,
  });

  final String id;
  final String arabic;
  final String english;

  /// Opens this lesson when unlocked; null tiles are locked placeholders.
  final String? lessonId;
}

/// A level band on the home screen: colored header card + tile grid.
@immutable
class LevelSection {
  const LevelSection({
    required this.id,
    required this.number,
    required this.title,
    required this.description,
    required this.color,
    this.lightForeground = false,
    this.categories = const <LevelCategory>[],
  });

  final String id;
  final int number;

  /// e.g. `Level 1 (Letters)`.
  final String title;
  final String description;

  /// Header card fill (yellow / orange / blue / green / purple).
  final Color color;

  /// Whether the header text should be white (dark card colors).
  final bool lightForeground;

  /// Big category cards (Level 4/5). Empty for glyph-grid levels.
  final List<LevelCategory> categories;
}
