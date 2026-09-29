import 'dart:math';

import 'package:flutter/material.dart';

import '../../data/models/exercise.dart';
import 'brick_widget.dart';

/// A letter / numeral built from LEGO bricks, laid out on the same cell-grid
/// convention as [BuildLetterExercise]: `pieces[i]` sits at top-left cell
/// `slots[i]` spanning `columns × rows` cells.
class BrickGlyph extends StatelessWidget {
  const BrickGlyph({
    super.key,
    required this.gridColumns,
    required this.gridRows,
    required this.slots,
    required this.pieces,
    this.height = 200,
  });

  final int gridColumns;
  final int gridRows;
  final List<Point<int>> slots;
  final List<BrickPiece> pieces;
  final double height;

  @override
  Widget build(BuildContext context) {
    final unit = height / gridRows;
    return SizedBox(
      width: unit * gridColumns,
      height: height,
      child: CustomPaint(
        painter: _BrickGlyphPainter(
          gridColumns: gridColumns,
          gridRows: gridRows,
          slots: slots,
          pieces: pieces,
        ),
      ),
    );
  }
}

class _BrickGlyphPainter extends CustomPainter {
  const _BrickGlyphPainter({
    required this.gridColumns,
    required this.gridRows,
    required this.slots,
    required this.pieces,
  });

  final int gridColumns;
  final int gridRows;
  final List<Point<int>> slots;
  final List<BrickPiece> pieces;

  @override
  void paint(Canvas canvas, Size size) {
    final unit = size.height / gridRows;
    for (var i = 0; i < pieces.length && i < slots.length; i++) {
      final piece = pieces[i];
      final slot = slots[i];
      BrickPainter.paintBrick(
        canvas,
        Rect.fromLTWH(
          slot.x * unit,
          (slot.y + piece.nudgeY) * unit,
          piece.columns * unit,
          piece.rows * unit,
        ),
        color: piece.color,
        columns: piece.columns,
        rows: piece.rows,
        // No black toy outline (matches the design): outlined bricks that
        // only meet at a corner, like alef's hamza tip and elbow, read as
        // two separate pieces with a gap between them.
        outlined: false,
      );
    }
  }

  @override
  bool shouldRepaint(_BrickGlyphPainter oldDelegate) =>
      oldDelegate.slots != slots || oldDelegate.pieces != pieces;
}
