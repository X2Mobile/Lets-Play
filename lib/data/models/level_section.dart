import 'package:flutter/material.dart';

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
  });

  final String id;
  final int number;

  /// e.g. `Level 1 (Letters)`.
  final String title;
  final String description;

  /// Header card fill (yellow / orange / blue / purple / green).
  final Color color;

  /// Whether the header text should be white (dark card colors).
  final bool lightForeground;
}
