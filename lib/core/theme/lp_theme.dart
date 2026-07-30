import 'package:flutter/material.dart';

import 'lp_colors.dart';
import 'lp_text_styles.dart';

/// App-wide [ThemeData] — white scaffold, BalooBhaijaan2 everywhere,
/// no default Material ink splashes (the toy widgets animate themselves).
abstract final class LpTheme {
  static ThemeData get light {
    const colorScheme = ColorScheme.light(
      primary: LpColors.royalBlue,
      onPrimary: LpColors.bgWhite,
      secondary: LpColors.brandYellow,
      onSecondary: LpColors.ink,
      tertiary: LpColors.legoGreen,
      onTertiary: LpColors.bgWhite,
      error: LpColors.brickRed,
      onError: LpColors.bgWhite,
      surface: LpColors.bgWhite,
      onSurface: LpColors.ink,
      outline: LpColors.borderGray,
    );

    return ThemeData(
      colorScheme: colorScheme,
      fontFamily: LpTextStyles.fontFamily,
      scaffoldBackgroundColor: LpColors.bgWhite,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      textTheme: const TextTheme(
        displaySmall: LpTextStyles.display,
        headlineMedium: LpTextStyles.h1,
        headlineSmall: LpTextStyles.h2,
        titleLarge: LpTextStyles.title,
        bodyLarge: LpTextStyles.body,
        bodyMedium: LpTextStyles.body,
        bodySmall: LpTextStyles.caption,
        labelLarge: LpTextStyles.button,
      ),
      dividerTheme: const DividerThemeData(
        color: LpColors.borderGray,
        thickness: 1,
        space: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: LpColors.ink,
        behavior: SnackBarBehavior.floating,
        contentTextStyle: LpTextStyles.body.copyWith(color: LpColors.bgWhite),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: LpColors.bgWhite,
        foregroundColor: LpColors.ink,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: LpTextStyles.title,
      ),
    );
  }
}
