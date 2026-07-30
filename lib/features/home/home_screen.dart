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
import '../../data/models/letter.dart';
import '../../data/models/level_section.dart';
import '../../state/app_state.dart';
import '../lesson/lesson_flow_screen.dart';
import 'fatha_info_screen.dart';

/// Home: stats bar + the five level bands (letter grid, tashkeel row and
/// locked future levels).
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _onLetterTap(BuildContext context, Letter letter, bool unlocked) {
    if (!unlocked) {
      _showSnack(context, UiStrings.lockedLetterSnack);
      return;
    }
    final lesson = lessonById(letter.lessonId);
    if (lesson == null) {
      _showSnack(context, UiStrings.lessonComingSoonSnack);
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => LessonFlowScreen(lesson: lesson)),
    );
  }

  void _onTashkeelTap(BuildContext context, Letter mark, bool unlocked) {
    if (!unlocked) {
      _showSnack(context, UiStrings.lockedTashkeelSnack);
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) => const FathaInfoScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final letters = levelsContent[0];
    final tashkeel = levelsContent[1];

    return SafeArea(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
            child: StatsBar(
              xp: appState.xp,
              hearts: appState.hearts,
              energy: appState.energy,
              onSettingsTap: () =>
                  _showSnack(context, UiStrings.settingsComingSoonSnack),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
              children: <Widget>[
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
                        onTap: (unlocked) =>
                            _onLetterTap(context, letter, unlocked),
                      ),
                  ],
                ),
                const SizedBox(height: 30),
                _LevelHeader(section: tashkeel),
                const SizedBox(height: 18),
                _TileGrid(
                  tiles: <Widget>[
                    for (final mark in tashkeelContent)
                      _GlyphTile(
                        glyph: mark.glyph,
                        translit: mark.translit,
                        unlocked: defaultUnlockedTashkeelIds.contains(mark.id),
                        color: LpColors.orange,
                        onTap: (unlocked) =>
                            _onTashkeelTap(context, mark, unlocked),
                      ),
                  ],
                ),
                for (final section in levelsContent.skip(2)) ...<Widget>[
                  const SizedBox(height: 30),
                  _LevelHeader(section: section),
                  const SizedBox(height: 18),
                  _TileGrid(
                    tiles: List<Widget>.generate(
                      5,
                      (_) => _LockedTile(
                        onTap: () =>
                            _showSnack(context, UiStrings.lockedLetterSnack),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Colored level header card (yellow / orange / blue / purple / green).
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

/// Letter / tashkeel tile: colored + black border when unlocked, quiet gray
/// when locked (locked taps shake playfully).
class _GlyphTile extends StatefulWidget {
  const _GlyphTile({
    required this.glyph,
    required this.translit,
    required this.unlocked,
    required this.color,
    required this.onTap,
  });

  final String glyph;
  final String translit;
  final bool unlocked;
  final Color color;
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
          Text(
            widget.glyph,
            textDirection: TextDirection.rtl,
            style: LpTextStyles.tileLetter.copyWith(
              color: widget.unlocked ? LpColors.ink : LpColors.textGray,
            ),
          ),
          Text(
            widget.translit,
            textDirection: TextDirection.ltr,
            style: LpTextStyles.tileSub.copyWith(
              color: widget.unlocked ? LpColors.ink : LpColors.textGray,
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

/// Quiet locked tile with a small padlock (levels 3–5 rows).
class _LockedTile extends StatelessWidget {
  const _LockedTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: LpColors.tileGray,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: LpColors.borderGray),
        ),
        child: const Icon(
          Icons.lock_rounded,
          color: LpColors.textGray,
          size: 22,
        ),
      ),
    );
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
