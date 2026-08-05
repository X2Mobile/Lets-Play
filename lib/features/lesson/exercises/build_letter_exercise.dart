import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/lp_colors.dart';
import '../../../core/widgets/baseplate_background.dart';
import '../../../core/widgets/brick_widget.dart';
import '../../../data/models/exercise.dart';
import '../../../state/app_state.dart';
import '../widgets/lesson_ui.dart';

/// Exercise 2 — build the letter (the signature interaction).
///
/// A LEGO baseplate shows ghost outline slots forming the letter; the child
/// drags bricks from a tray onto them. A drop snaps to the nearest empty
/// slot of the same shape when close enough, otherwise the brick glides
/// back to the tray. Bottom bar: retry + cosmetic ⏱ countdown, ⚡ energy and
/// a moves counter. No fail state — filling every slot pops the letter and
/// auto-advances.
class BuildLetterPage extends StatefulWidget {
  const BuildLetterPage({
    super.key,
    required this.exercise,
    required this.onSolved,
    required this.onCompleted,
  });

  final BuildLetterExercise exercise;

  /// Fired the moment the letter is complete (fills the progress bar).
  final VoidCallback onSolved;

  /// Fired after the pop celebration (~850 ms) to advance the flow.
  final VoidCallback onCompleted;

  @override
  State<BuildLetterPage> createState() => _BuildLetterPageState();
}

class _BuildLetterPageState extends State<BuildLetterPage> {
  final GlobalKey _stackKey = GlobalKey();

  late List<int?> _placedPieceBySlot;
  late int _movesLeft;
  late int _secondsLeft;
  bool _celebrating = false;
  int? _hoverSlot;
  _ReturnFlight? _returning;
  int _returnSeq = 0;

  Timer? _ticker;
  Timer? _advanceTimer;

  BuildLetterExercise get _exercise => widget.exercise;

  bool get _isComplete => !_placedPieceBySlot.contains(null);

  @override
  void initState() {
    super.initState();
    _initRound();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _advanceTimer?.cancel();
    super.dispose();
  }

  void _initRound() {
    _placedPieceBySlot = List<int?>.filled(_exercise.slots.length, null);
    _movesLeft = _exercise.maxMoves;
    _secondsLeft = _exercise.timerSeconds;
    _celebrating = false;
    _hoverSlot = null;
    _returning = null;
    _advanceTimer?.cancel();
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_secondsLeft > 0 && !_celebrating) {
        setState(() => _secondsLeft--);
      }
    });
  }

  void _retry() => setState(_initRound);

  bool _dimsMatch(int pieceIndex, int slotIndex) {
    final a = _exercise.pieces[pieceIndex];
    final b = _exercise.pieces[slotIndex];
    return a.columns == b.columns && a.rows == b.rows;
  }

  bool _pieceIsPlaced(int pieceIndex) =>
      _placedPieceBySlot.contains(pieceIndex);

  Offset? _globalToStack(Offset global) {
    final box = _stackKey.currentContext?.findRenderObject() as RenderBox?;
    return box?.globalToLocal(global);
  }

  /// Nearest empty slot with the same brick shape, or null when the drop
  /// point (feedback top-left in global coords) is not close enough.
  int? _nearestSlot(int pieceIndex, Offset feedbackGlobal, _BuildGeometry g) {
    final local = _globalToStack(feedbackGlobal);
    if (local == null) return null;
    final piece = _exercise.pieces[pieceIndex];
    final center =
        local + Offset(piece.columns * g.cell / 2, piece.rows * g.cell / 2);
    int? best;
    var bestDistance = double.infinity;
    for (var i = 0; i < _exercise.slots.length; i++) {
      if (_placedPieceBySlot[i] != null || !_dimsMatch(pieceIndex, i)) {
        continue;
      }
      final d = (g.slotRects[i].center - center).distance;
      if (d < bestDistance) {
        bestDistance = d;
        best = i;
      }
    }
    return bestDistance <= g.cell * 1.6 ? best : null;
  }

  void _handleDrop(int pieceIndex, Offset feedbackGlobal, _BuildGeometry g) {
    final slot = _nearestSlot(pieceIndex, feedbackGlobal, g);
    if (slot != null) {
      HapticFeedback.lightImpact();
      setState(() {
        _placedPieceBySlot[slot] = pieceIndex;
        _hoverSlot = null;
      });
      if (_isComplete) _celebrate();
    } else {
      _startReturn(pieceIndex, feedbackGlobal, g);
    }
  }

  /// Gentle bounce-back: the brick glides from the failed drop point back
  /// to its tray spot.
  void _startReturn(int pieceIndex, Offset feedbackGlobal, _BuildGeometry g) {
    final local = _globalToStack(feedbackGlobal);
    if (local == null) return;
    final piece = _exercise.pieces[pieceIndex];
    setState(() {
      _hoverSlot = null;
      _returning = _ReturnFlight(
        id: _returnSeq++,
        pieceIndex: pieceIndex,
        from: local & Size(piece.columns * g.cell, piece.rows * g.cell),
      );
    });
  }

  void _celebrate() {
    _ticker?.cancel();
    HapticFeedback.mediumImpact();
    setState(() => _celebrating = true);
    widget.onSolved();
    _advanceTimer = Timer(
      const Duration(milliseconds: 850),
      widget.onCompleted,
    );
  }

  @override
  Widget build(BuildContext context) {
    final energy = context.watch<AppState>().energy;
    return Column(
      children: <Widget>[
        if (_exercise.formTabs.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 2, 20, 8),
            child: _FormTabsRow(
              tabs: _exercise.formTabs,
              activeIndex: _exercise.activeFormIndex,
            ),
          ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final g = _BuildGeometry(_exercise, constraints.biggest);
              return Stack(
                key: _stackKey,
                clipBehavior: Clip.none,
                children: <Widget>[
                  const Positioned.fill(child: BaseplateBackground()),
                  if (_exercise.guideLabel != null)
                    Positioned(
                      left: 0,
                      right: 0,
                      top: g.baselineY - _GuideLine.height / 2,
                      child: _GuideLine(label: _exercise.guideLabel!),
                    ),
                  // The letter: ghost slots + placed bricks (pops on finish).
                  Positioned.fromRect(
                    rect: g.boardRect,
                    child: CelebrationPop(
                      play: _celebrating,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: <Widget>[
                          Positioned.fill(
                            child: CustomPaint(
                              painter: _GhostSlotsPainter(
                                exercise: _exercise,
                                cell: g.cell,
                                placed: List<int?>.of(_placedPieceBySlot),
                                hoverSlot: _hoverSlot,
                              ),
                            ),
                          ),
                          for (var i = 0; i < _exercise.slots.length; i++)
                            if (_placedPieceBySlot[i] != null)
                              Positioned.fromRect(
                                rect: g.slotRects[i].shift(
                                  -g.boardRect.topLeft,
                                ),
                                child: _SettleBrick(
                                  key: ValueKey<int>(i),
                                  piece:
                                      _exercise.pieces[_placedPieceBySlot[i]!],
                                  unit: g.cell,
                                ),
                              ),
                        ],
                      ),
                    ),
                  ),
                  // One drop zone around the whole letter; the nearest
                  // matching slot wins, anything else bounces back.
                  Positioned.fromRect(
                    rect: g.boardRect.inflate(g.cell * 1.2),
                    child: DragTarget<int>(
                      onWillAcceptWithDetails: (_) => !_celebrating,
                      onMove: (details) {
                        final slot = _nearestSlot(
                          details.data,
                          details.offset,
                          g,
                        );
                        if (slot != _hoverSlot) {
                          setState(() => _hoverSlot = slot);
                        }
                      },
                      onLeave: (_) {
                        if (_hoverSlot != null) {
                          setState(() => _hoverSlot = null);
                        }
                      },
                      onAcceptWithDetails: (details) =>
                          _handleDrop(details.data, details.offset, g),
                      builder: (context, candidates, rejected) =>
                          const SizedBox.expand(),
                    ),
                  ),
                  // Brick tray.
                  for (var i = 0; i < _exercise.pieces.length; i++)
                    if (!_pieceIsPlaced(i) && _returning?.pieceIndex != i)
                      Positioned.fromRect(
                        rect: g.trayRects[i],
                        child: _TrayDraggable(
                          pieceIndex: i,
                          piece: _exercise.pieces[i],
                          geometry: g,
                          onDragEnd: () {
                            if (_movesLeft > 0) {
                              setState(() => _movesLeft--);
                            }
                          },
                          onCanceled: (offset) => _startReturn(i, offset, g),
                        ),
                      ),
                  // Bounce-back flight after a missed drop.
                  if (_returning != null)
                    _ReturningBrick(
                      key: ValueKey<int>(_returning!.id),
                      flight: _returning!,
                      piece: _exercise.pieces[_returning!.pieceIndex],
                      to: g.trayRects[_returning!.pieceIndex],
                      onDone: () => setState(() => _returning = null),
                    ),
                ],
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 14),
          child: LessonStatBar(
            seconds: _secondsLeft,
            energy: energy,
            moves: _movesLeft,
            onRetry: _celebrating ? null : _retry,
          ),
        ),
      ],
    );
  }
}

/// Positional-form tabs per the design (LEVEL 1/3): gray tabs with the
/// letter's other forms, the form being built highlighted green.
class _FormTabsRow extends StatelessWidget {
  const _FormTabsRow({required this.tabs, required this.activeIndex});

  final List<String> tabs;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        children: <Widget>[
          for (var i = 0; i < tabs.length; i++) ...<Widget>[
            if (i > 0) const SizedBox(width: 10),
            Expanded(
              child: Container(
                height: 46,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: i == activeIndex
                      ? LpColors.legoGreen
                      : LpColors.tileGray,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: i == activeIndex
                        ? LpColors.darken(LpColors.legoGreen, 0.2)
                        : LpColors.borderGray,
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: i == activeIndex
                          ? LpColors.darken(LpColors.legoGreen, 0.25)
                          : LpColors.borderGray,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  tabs[i],
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: 'NotoSansArabic',
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                    color: i == activeIndex
                        ? LpColors.bgWhite
                        : LpColors.textGray,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// The letter's writing guide: a small dark label ("Baseline" / "Ascender")
/// followed by a hairline rule running out to the edge of the plate. The rule
/// is centred vertically in [height] so the caller can hang it off a grid row.
class _GuideLine extends StatelessWidget {
  const _GuideLine({required this.label});

  static const double height = 18;

  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Row(
          children: <Widget>[
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'BalooBhaijaan2',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: LpColors.ink,
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Container(
                height: 1.4,
                color: LpColors.darken(LpColors.borderGray, 0.15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A tray brick the child can pick up. The drag feedback is rendered at
/// board size so it visually matches the slot it is about to fill.
class _TrayDraggable extends StatelessWidget {
  const _TrayDraggable({
    required this.pieceIndex,
    required this.piece,
    required this.geometry,
    required this.onDragEnd,
    required this.onCanceled,
  });

  final int pieceIndex;
  final BrickPiece piece;
  final _BuildGeometry geometry;
  final VoidCallback onDragEnd;
  final ValueChanged<Offset> onCanceled;

  @override
  Widget build(BuildContext context) {
    final trayBrick = BrickWidget(
      color: piece.color,
      columns: piece.columns,
      rows: piece.rows,
      unit: geometry.trayUnit,
    );
    return Draggable<int>(
      data: pieceIndex,
      maxSimultaneousDrags: 1,
      feedback: BrickWidget(
        color: piece.color,
        columns: piece.columns,
        rows: piece.rows,
        unit: geometry.cell,
      ),
      childWhenDragging: Opacity(opacity: 0.35, child: trayBrick),
      onDragEnd: (_) => onDragEnd(),
      onDraggableCanceled: (velocity, offset) => onCanceled(offset),
      child: trayBrick,
    );
  }
}

/// A freshly placed brick settling into its slot with a springy bounce.
class _SettleBrick extends StatelessWidget {
  const _SettleBrick({super.key, required this.piece, required this.unit});

  final BrickPiece piece;
  final double unit;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
      builder: (context, t, child) =>
          Transform.scale(scale: 0.6 + 0.4 * t, child: child),
      child: BrickWidget(
        color: piece.color,
        columns: piece.columns,
        rows: piece.rows,
        unit: unit,
        outlined: false,
      ),
    );
  }
}

/// Data for one bounce-back animation (missed drop → tray).
class _ReturnFlight {
  const _ReturnFlight({
    required this.id,
    required this.pieceIndex,
    required this.from,
  });

  final int id;
  final int pieceIndex;

  /// Stack-local rect of the feedback at the moment the drag was released.
  final Rect from;
}

class _ReturningBrick extends StatelessWidget {
  const _ReturningBrick({
    super.key,
    required this.flight,
    required this.piece,
    required this.to,
    required this.onDone,
  });

  final _ReturnFlight flight;
  final BrickPiece piece;
  final Rect to;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      onEnd: onDone,
      builder: (context, t, child) {
        final rect = Rect.lerp(flight.from, to, t)!;
        return Positioned.fromRect(
          rect: rect,
          child: BrickWidget(
            color: piece.color,
            columns: piece.columns,
            rows: piece.rows,
            unit: rect.width / piece.columns,
          ),
        );
      },
    );
  }
}

/// Ghost outline slots: each uncovered cell of an unplaced slot is a white
/// square with a thin gray border (royal-blue when a matching brick hovers).
class _GhostSlotsPainter extends CustomPainter {
  const _GhostSlotsPainter({
    required this.exercise,
    required this.cell,
    required this.placed,
    required this.hoverSlot,
  });

  final BuildLetterExercise exercise;
  final double cell;
  final List<int?> placed;
  final int? hoverSlot;

  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()..color = LpColors.bgWhite;
    final hoverFill = Paint()
      ..color = LpColors.lighten(LpColors.brandYellow, 0.6);
    final stroke = Paint()
      ..color = LpColors.borderGray
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;
    final hoverStroke = Paint()
      ..color = LpColors.royalBlue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (var i = 0; i < exercise.slots.length; i++) {
      if (placed[i] != null) continue;
      final slot = exercise.slots[i];
      final piece = exercise.pieces[i];
      final hovered = hoverSlot == i;
      for (var cy = 0; cy < piece.rows; cy++) {
        for (var cx = 0; cx < piece.columns; cx++) {
          final rect = Rect.fromLTWH(
            (slot.x + cx) * cell,
            (slot.y + cy) * cell,
            cell,
            cell,
          ).deflate(1);
          final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(3));
          canvas.drawRRect(rrect, hovered ? hoverFill : fill);
          canvas.drawRRect(rrect, hovered ? hoverStroke : stroke);
        }
      }
    }
  }

  @override
  bool shouldRepaint(_GhostSlotsPainter oldDelegate) =>
      oldDelegate.cell != cell ||
      oldDelegate.hoverSlot != hoverSlot ||
      !listEquals(oldDelegate.placed, placed);
}

/// All layout math for the build exercise, derived from the viewport so it
/// fits any portrait phone without overflow.
class _BuildGeometry {
  _BuildGeometry(BuildLetterExercise exercise, Size size) {
    const sidePad = 20.0;
    const trayGap = 10.0;
    final cols = exercise.gridColumns;
    final rows = exercise.gridRows;
    final maxPieceRows = exercise.pieces
        .map((p) => p.rows)
        .reduce(math.max)
        .toDouble();

    final cellW = (size.width - sidePad * 2) / cols;
    final cellH = (size.height - 44) / (rows + maxPieceRows * 0.78);
    cell = math.min(cellW, cellH).clamp(16.0, 40.0);

    var unit = (cell * 0.78).clamp(14.0, 28.0);
    final totalCols = exercise.pieces.fold<int>(0, (s, p) => s + p.columns);
    final gaps = (exercise.pieces.length - 1) * trayGap;
    final maxTrayW = size.width - 16;
    if (totalCols * unit + gaps > maxTrayW) {
      unit = (maxTrayW - gaps) / totalCols;
    }
    trayUnit = unit;

    final trayH = maxPieceRows * trayUnit;
    final trayTop = size.height - trayH - 14;
    final boardW = cols * cell;
    final boardH = rows * cell;
    final boardLeft = (size.width - boardW) / 2;
    final boardTop = math.max(8.0, (trayTop - 18 - boardH) / 2);
    boardRect = Rect.fromLTWH(boardLeft, boardTop, boardW, boardH);

    final trayW = totalCols * trayUnit + gaps;
    var x = (size.width - trayW) / 2;
    trayRects = <Rect>[];
    for (final piece in exercise.pieces) {
      final w = piece.columns * trayUnit;
      final h = piece.rows * trayUnit;
      trayRects.add(Rect.fromLTWH(x, trayTop + (trayH - h) / 2, w, h));
      x += w + trayGap;
    }

    slotRects = <Rect>[
      for (var i = 0; i < exercise.slots.length; i++)
        Rect.fromLTWH(
          boardLeft + exercise.slots[i].x * cell,
          boardTop + exercise.slots[i].y * cell,
          exercise.pieces[i].columns * cell,
          exercise.pieces[i].rows * cell,
        ),
    ];

    final baselineRow = exercise.baselineRow;
    baselineY = baselineRow != null
        ? boardRect.top + baselineRow * cell
        : boardRect.bottom + 2;
  }

  late final double cell;
  late final double trayUnit;
  late final Rect boardRect;
  late final List<Rect> trayRects;
  late final List<Rect> slotRects;

  /// Y of the Baseline / Ascender rule, in stack coordinates.
  late final double baselineY;
}
