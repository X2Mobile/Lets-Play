import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A vector icon exported from the design drop.
///
/// [asset] is a path under `assets/images/` (e.g. `icons/motivation_trips.svg`).
/// The artwork keeps its own aspect ratio inside a [size] × [size] box, so the
/// onboarding tiles — whose coloured square and hard shadow are part of the
/// drawing — land at the same footprint as the bare icons.
class SvgIcon extends StatelessWidget {
  const SvgIcon({super.key, required this.asset, required this.size});

  final String asset;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: SvgPicture.asset(
        'assets/images/$asset',
        fit: BoxFit.contain,
      ),
    );
  }
}
