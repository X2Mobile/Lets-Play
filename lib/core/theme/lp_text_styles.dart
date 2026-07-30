import 'package:flutter/material.dart';

import 'lp_colors.dart';

/// Typography tokens — rounded geometric sans, bold ("neo-brutalist toy").
///
/// NOTE: never add `letterSpacing` to styles used for Arabic text —
/// tracking breaks Arabic letter joining.
abstract final class LpTextStyles {
  static const String fontFamily = 'BalooBhaijaan2';

  /// Dedicated Arabic family (Latin glyphs are NOT included — use only for
  /// Arabic-script text).
  static const String arabicFontFamily = 'NotoSansArabic';

  static const TextStyle display = TextStyle(
    fontFamily: fontFamily,
    fontSize: 34,
    fontWeight: FontWeight.w800,
    color: LpColors.ink,
    height: 1.15,
  );

  static const TextStyle h1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: LpColors.ink,
    height: 1.15,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w800,
    color: LpColors.ink,
    height: 1.2,
  );

  static const TextStyle title = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: LpColors.ink,
    height: 1.25,
  );

  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: LpColors.ink,
    height: 1.35,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: LpColors.textGray,
    height: 1.3,
  );

  /// Uppercase wide-tracking button label (`CONTINUE`).
  static const TextStyle button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w800,
    color: LpColors.ink,
    letterSpacing: 1.5,
    height: 1.2,
  );

  /// Stats bar numbers (✦ 13,500 · ❤ 6 · ⚡ 10).
  static const TextStyle statValue = TextStyle(
    fontFamily: fontFamily,
    fontSize: 17,
    fontWeight: FontWeight.w800,
    color: LpColors.ink,
    height: 1.1,
  );

  /// Huge Arabic glyph on letter-intro cards.
  static const TextStyle arabicGiant = TextStyle(
    fontFamily: arabicFontFamily,
    fontSize: 96,
    fontWeight: FontWeight.w800,
    color: LpColors.ink,
    height: 1.2,
  );

  /// Large Arabic word (match-the-image prompt, fatha card).
  static const TextStyle arabicLarge = TextStyle(
    fontFamily: arabicFontFamily,
    fontSize: 44,
    fontWeight: FontWeight.w800,
    color: LpColors.ink,
    height: 1.25,
  );

  /// Arabic glyph inside a letter grid tile.
  static const TextStyle tileLetter = TextStyle(
    fontFamily: arabicFontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: LpColors.ink,
    height: 1.2,
  );

  /// Latin transliteration under a tile glyph.
  static const TextStyle tileSub = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: LpColors.ink,
    height: 1.1,
  );
}
