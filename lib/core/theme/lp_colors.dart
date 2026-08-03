import 'package:flutter/material.dart';

/// Brand palette sampled from the Adobe XD prototypes.
/// See DESIGN_SPEC.md section 3 — do not invent new tokens in feature code.
abstract final class LpColors {
  /// Login bg, blue exercise cards, brand.
  static const Color royalBlue = Color(0xFF1B2CFF);

  /// Plan-loading screen bg.
  static const Color skyBlue = Color(0xFF2CA9E1);

  /// Question cards, unlocked tiles, primary buttons, Level-1 header.
  static const Color brandYellow = Color(0xFFFFD800);

  /// Level-2 header, bricks, tashkeel card.
  static const Color orange = Color(0xFFF7941D);

  /// Bricks, hearts.
  static const Color brickRed = Color(0xFFEF4046);

  /// Progress-bar studs, settings gear, success.
  static const Color legoGreen = Color(0xFF43C330);

  /// Speech-exercise card, Level-4 accents.
  static const Color purple = Color(0xFF6B2CF5);

  /// Borders, text, hard shadows.
  static const Color ink = Color(0xFF111111);

  /// Screen background.
  static const Color bgWhite = Color(0xFFFFFFFF);

  /// Locked tiles, disabled buttons, option tiles.
  static const Color tileGray = Color(0xFFF2F2F2);

  /// Thin borders on gray tiles.
  static const Color borderGray = Color(0xFFE0E0E0);

  /// Secondary / disabled text.
  static const Color textGray = Color(0xFF9B9B9B);

  // --- Level colors sampled from the 2026-07 design drop (design/…). ---

  /// Level-3 (Numbers) headers, tiles and intro screens.
  static const Color levelBlue = Color(0xFF16A2FF);

  /// Level-4 (Words) headers, tiles and intro screens.
  static const Color levelGreen = Color(0xFF00D035);

  /// Level-5 (Sentences) headers, tiles and intro screens.
  static const Color levelPurple = Color(0xFF5D00FF);

  /// Level-2 header / intro background per the new design.
  static const Color levelOrange = Color(0xFFFD7E01);

  /// Logo splash frame background (LOG IN/4).
  static const Color crimson = Color(0xFFFF2D55);

  /// Splash / login yellow per the new design (slightly warmer than
  /// [brandYellow]).
  static const Color splashYellow = Color(0xFFFEDD05);

  /// Splash cascade brick colors (body fills from LOG IN/0–3).
  static const List<Color> splashBrickColors = <Color>[
    Color(0xFF2641FF), // blue
    Color(0xFFED7703), // orange
    Color(0xFFFF5F7D), // pink-red
    Color(0xFF00D035), // green
  ];

  /// Brick colors used by build / trace exercises and decorations.
  static const List<Color> brickColors = <Color>[
    brickRed,
    orange,
    legoGreen,
    royalBlue,
    purple,
  ];

  /// Foreground for text/icons sitting on a level color: white everywhere
  /// except the yellows (Level 1), which need ink — the brand rule from the
  /// design, NOT a computed brightness (orange/blue read as "bright" to
  /// estimators but the design still puts white on them).
  static Color foregroundOn(Color color) =>
      color == brandYellow || color == splashYellow ? ink : bgWhite;

  /// Shifts [color] towards black — used for brick bottom edges & stud rings.
  static Color darken(Color color, [double amount = 0.2]) =>
      Color.lerp(color, const Color(0xFF000000), amount)!;

  /// Shifts [color] towards white — used for stud tops & highlights.
  static Color lighten(Color color, [double amount = 0.2]) =>
      Color.lerp(color, bgWhite, amount)!;
}
