import 'package:flutter/material.dart';

/// Displays the brand wordmark from the oversized logo PNGs.
///
/// The source assets are 1921×1081 canvases where the wordmark only occupies
/// the central ~18% × ~46%, so this widget scales the image up and crops to
/// just the visible mark.
class LpLogo extends StatelessWidget {
  const LpLogo({
    super.key,
    this.asset = 'assets/images/logo/logo_yellow.png',
    this.height = 200,
  });

  final String asset;
  final double height;

  // Measured fractions of the wordmark inside the 1921×1081 canvas.
  static const double _visibleWidthFraction = 0.184;
  static const double _visibleHeightFraction = 0.455;

  @override
  Widget build(BuildContext context) {
    // Visible wordmark aspect ratio (width / height).
    const aspect =
        (1921 * _visibleWidthFraction) / (1081 * _visibleHeightFraction);
    final width = height * aspect;
    return SizedBox(
      width: width,
      height: height,
      child: ClipRect(
        child: OverflowBox(
          maxWidth: double.infinity,
          maxHeight: double.infinity,
          child: Image.asset(
            asset,
            height: height / _visibleHeightFraction,
            filterQuality: FilterQuality.medium,
          ),
        ),
      ),
    );
  }
}
