import 'package:flutter/material.dart';

/// Character / illustration crop from the design SVGs.
///
/// [asset] is a path under `assets/images/` (e.g. `characters/intro_l1.png`).
/// Falls back to an empty box if the asset is missing so a failed crop can
/// never break the demo.
class MascotImage extends StatelessWidget {
  const MascotImage({
    super.key,
    required this.asset,
    this.height,
    this.width,
    this.alignment = Alignment.bottomCenter,
  });

  final String asset;
  final double? height;
  final double? width;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/$asset',
      height: height,
      width: width,
      alignment: alignment,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) =>
          SizedBox(height: height, width: width),
    );
  }
}
