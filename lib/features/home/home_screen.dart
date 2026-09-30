import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/lp_colors.dart';
import '../../core/theme/lp_text_styles.dart';
import '../../core/widgets/lp_card.dart';
import '../../core/widgets/stats_bar.dart';
import '../../data/content/lessons_content.dart';
import '../../data/content/letters_content.dart';
import '../../data/content/levels_content.dart';
import '../../data/content/ui_strings.dart';
import '../../data/models/level_section.dart';
import '../../state/app_state.dart';
import '../lesson/level_intro_screen.dart';
import 'settings_screen.dart';

/// Home: stats bar + the five level bands per the 2026-07 design —
/// 1 Letters (yellow grid) · 2 Tashkeel (orange row) · 3 Numbers (blue
/// grid) · 4 Words (green category cards) · 5 Sentences (purple category
/// cards). Unlocked tiles open their lesson through the level-intro flow.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _openLesson(BuildContext context, String? lessonId, bool unlocked) {
    if (!unlocked) {
      _showSnack(context, UiStrings.lockedLetterSnack);
      return;
    }
    final lesson = lessonById(lessonId);
    if (lesson == null) {
      _showSnack(context, UiStrings.lessonComingSoonSnack);
      return;
    }
    LevelIntroScreen.start(context, lesson);
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final letters = levelsContent[0];
    final tashkeel = levelsContent[1];
    final numbers = levelsContent[2];
    final words = levelsContent[3];
    final sentences = levelsContent[4];

    return SafeArea(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
            child: StatsBar(
              xp: appState.xp,
              hearts: appState.hearts,
              energy: appState.energy,
              onSettingsTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const SettingsScreen()),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
              children: <Widget>[
                // Level 1 — Letters.
                _LevelHeader(section: letters),
                const SizedBox(height: 18),
                _TileGrid(
                  tiles: <Widget>[
                    for (final letter in lettersContent)
                      _GlyphTile(
                        glyph: letter.glyph,
                        translit: letter.translit,
                        unlocked: appState.isLetterUnlocked(letter.id),
                        color: LpColors.brandYellow,
                        onTap: (unlocked) => _openLesson(
                          context,
                          letter.lessonId,
                          unlocked,
                        ),
                      ),
                    for (final letter in lettersExtraContent)
                      _GlyphTile(
                        glyph: letter.glyph,
                        translit: letter.translit,
                        unlocked: false,
                        color: LpColors.brandYellow,
                        onTap: (_) =>
                            _showSnack(context, UiStrings.lockedLetterSnack),
                      ),
                  ],
                ),
                const SizedBox(height: 30),

                // Level 2 — Tashkeel.
                _LevelHeader(section: tashkeel),
                const SizedBox(height: 18),
                _TileGrid(
                  tiles: <Widget>[
                    for (final mark in tashkeelContent)
                      _GlyphTile(
                        glyph: mark.glyph,
                        translit: mark.translit,
                        unlocked: defaultUnlockedTashkeelIds.contains(mark.id),
                        color: LpColors.levelOrange,
                        onTap: (unlocked) {
                          if (!unlocked) {
                            _showSnack(
                              context,
                              UiStrings.lockedTashkeelSnack,
                            );
                            return;
                          }
                          _openLesson(context, mark.lessonId, true);
                        },
                      ),
                  ],
                ),
                const SizedBox(height: 30),

                // Level 3 — Numbers.
                _LevelHeader(section: numbers),
                const SizedBox(height: 18),
                _TileGrid(
                  tiles: <Widget>[
                    for (final number in numbersContent)
                      _GlyphTile(
                        glyph: number.glyph,
                        translit: number.translit,
                        unlocked: defaultUnlockedNumberIds.contains(number.id),
                        color: LpColors.levelBlue,
                        lightGlyph: true,
                        onTap: (unlocked) => _openLesson(
                          context,
                          number.lessonId,
                          unlocked,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 30),

                // Levels 4/5 — category cards.
                for (final section in <LevelSection>[words, sentences]) ...[
                  _LevelHeader(section: section),
                  const SizedBox(height: 18),
                  _CategoryGrid(
                    section: section,
                    onTap: (category, unlocked) => _openLesson(
                      context,
                      category.lessonId,
                      unlocked,
                    ),
                  ),
                  if (section.number != 5) const SizedBox(height: 30),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Colored level header card (yellow / orange / blue / green / purple).
class _LevelHeader extends StatelessWidget {
  const _LevelHeader({required this.section});

  final LevelSection section;

  @override
  Widget build(BuildContext context) {
    final textColor = section.lightForeground ? LpColors.bgWhite : LpColors.ink;
    return LpCard(
      color: section.color,
      borderWidth: 3,
      shadowOffset: const Offset(0, 5),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            section.title,
            style: LpTextStyles.h2.copyWith(color: textColor),
          ),
          const SizedBox(height: 2),
          Text(
            section.description,
            style: LpTextStyles.body.copyWith(
              color: textColor,
              fontSize: 14.5,
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}

/// 5-column right-to-left grid so أ sits top-right like the prototype.
class _TileGrid extends StatelessWidget {
  const _TileGrid({required this.tiles});

  final List<Widget> tiles;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GridView.count(
        crossAxisCount: 5,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 12,
        crossAxisSpacing: 10,
        childAspectRatio: 0.88,
        children: tiles,
      ),
    );
  }
}

/// Level-4/5 band: two category cards per row (design `PROFILE /0`,
/// y≈1100–1700 — "2 letter words · في", "Introduce Yourself · عرف نفسك").
class _CategoryGrid extends StatelessWidget {
  const _CategoryGrid({required this.section, required this.onTap});

  final LevelSection section;
  final void Function(LevelCategory, bool unlocked) onTap;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.55,
        children: <Widget>[
          for (final category in section.categories)
            _CategoryTile(
              category: category,
              color: section.color,
              unlocked: defaultUnlockedCategoryIds.contains(category.id),
              onTap: (unlocked) => onTap(category, unlocked),
            ),
        ],
      ),
    );
  }
}

class _CategoryTile extends StatefulWidget {
  const _CategoryTile({
    required this.category,
    required this.color,
    required this.unlocked,
    required this.onTap,
  });

  final LevelCategory category;
  final Color color;
  final bool unlocked;
  final ValueChanged<bool> onTap;

  @override
  State<_CategoryTile> createState() => _CategoryTileState();
}

class _CategoryTileState extends State<_CategoryTile> {
  int _shakeSeed = 0;

  void _handleTap() {
    if (!widget.unlocked) setState(() => _shakeSeed++);
    widget.onTap(widget.unlocked);
  }

  @override
  Widget build(BuildContext context) {
    final unlocked = widget.unlocked;
    Widget tile = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: unlocked
          ? BoxDecoration(
              color: widget.color,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: LpColors.ink, width: 2.5),
              boxShadow: const <BoxShadow>[
                BoxShadow(color: LpColors.ink, offset: Offset(0, 3)),
              ],
            )
          : BoxDecoration(
              color: LpColors.tileGray,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: LpColors.borderGray),
            ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            widget.category.arabic,
            textDirection: TextDirection.rtl,
            style: LpTextStyles.arabicLarge.copyWith(
              fontSize: 24,
              height: 1.3,
              color: unlocked ? LpColors.bgWhite : LpColors.textGray,
            ),
          ),
          Text(
            widget.category.english,
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.center,
            style: LpTextStyles.tileSub.copyWith(
              fontSize: 13,
              color: unlocked ? LpColors.bgWhite : LpColors.textGray,
            ),
          ),
        ],
      ),
    );

    if (_shakeSeed > 0) {
      tile = _Shake(key: ValueKey<int>(_shakeSeed), child: tile);
    }
    return GestureDetector(onTap: _handleTap, child: tile);
  }
}

/// Letter / tashkeel / number tile: colored + black border when unlocked,
/// quiet gray when locked (locked taps shake playfully).
class _GlyphTile extends StatefulWidget {
  const _GlyphTile({
    required this.glyph,
    required this.translit,
    required this.unlocked,
    required this.color,
    required this.onTap,
    this.lightGlyph = false,
  });

  final String glyph;
  final String translit;
  final bool unlocked;
  final Color color;

  /// White glyph/text on dark tile colors (Level-3 blue).
  final bool lightGlyph;
  final ValueChanged<bool> onTap;

  @override
  State<_GlyphTile> createState() => _GlyphTileState();
}

class _GlyphTileState extends State<_GlyphTile> {
  int _shakeSeed = 0;

  void _handleTap() {
    if (!widget.unlocked) setState(() => _shakeSeed++);
    widget.onTap(widget.unlocked);
  }

  @override
  Widget build(BuildContext context) {
    final glyphColor = widget.unlocked
        ? (widget.lightGlyph ? LpColors.bgWhite : LpColors.ink)
        : LpColors.textGray;
    Widget tile = Container(
      decoration: widget.unlocked
          ? BoxDecoration(
              color: widget.color,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: LpColors.ink, width: 2.5),
              boxShadow: const <BoxShadow>[
                BoxShadow(color: LpColors.ink, offset: Offset(0, 3)),
              ],
            )
          : BoxDecoration(
              color: LpColors.tileGray,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: LpColors.borderGray),
            ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // A taller line than tileLetter's so descending dots (ي, ج) clear
          // the transliteration instead of printing over it — "y" under ي
          // read as a different letter (client amends, Sep 2026).
          Text(
            widget.glyph,
            textDirection: TextDirection.rtl,
            style: LpTextStyles.tileLetter.copyWith(
              color: glyphColor,
              height: 1.5,
            ),
          ),
          Text(
            widget.translit,
            textDirection: TextDirection.ltr,
            style: LpTextStyles.tileSub.copyWith(color: glyphColor),
          ),
        ],
      ),
    );

    if (_shakeSeed > 0) {
      tile = _Shake(key: ValueKey<int>(_shakeSeed), child: tile);
    }

    return GestureDetector(onTap: _handleTap, child: tile);
  }
}

/// One-shot horizontal shake; retriggered by swapping the key.
class _Shake extends StatelessWidget {
  const _Shake({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 420),
      builder: (context, t, child) {
        final dx = math.sin(t * math.pi * 4) * 7 * (1 - t);
        return Transform.translate(offset: Offset(dx, 0), child: child);
      },
      child: child,
    );
  }
}
