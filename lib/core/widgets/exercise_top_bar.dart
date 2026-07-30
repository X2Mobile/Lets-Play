import 'package:flutter/material.dart';

import '../theme/lp_colors.dart';
import 'heart_counter.dart';
import 'stud_progress_bar.dart';

/// Lesson chrome: X (exit) + hearts + stud progress bar.
/// Reused by the fatha info screen and the lesson flow.
class ExerciseTopBar extends StatelessWidget {
  const ExerciseTopBar({
    super.key,
    required this.hearts,
    required this.progress,
    this.onClose,
  });

  final int hearts;
  final double progress;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: onClose,
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(
                Icons.close_rounded,
                size: 30,
                color: LpColors.textGray,
              ),
            ),
          ),
          const SizedBox(width: 10),
          HeartCounter(hearts: hearts, iconSize: 28),
          const SizedBox(width: 14),
          Expanded(child: StudProgressBar(progress: progress)),
        ],
      ),
    );
  }
}
