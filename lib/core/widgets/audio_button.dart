import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../services/audio_service.dart';
import '../theme/lp_colors.dart';

/// Size variants for [AudioButton].
enum AudioButtonVariant { big, small }

/// White bordered square with a yellow speaker icon and hard shadow.
/// Tapping plays [audioFile] through [AudioService] (optionally slowed via
/// [rate] — e.g. 0.6 for the snail button).
class AudioButton extends StatefulWidget {
  const AudioButton({
    super.key,
    required this.audioFile,
    this.variant = AudioButtonVariant.big,
    this.rate = 1.0,
    this.onPlayed,
  });

  final String audioFile;
  final AudioButtonVariant variant;
  final double rate;

  /// Called after the tap triggered playback (e.g. to enable CONTINUE).
  final VoidCallback? onPlayed;

  @override
  State<AudioButton> createState() => _AudioButtonState();
}

class _AudioButtonState extends State<AudioButton> {
  bool _pressed = false;

  double get _size => widget.variant == AudioButtonVariant.big ? 76 : 48;

  void _play() {
    AudioService.instance.playAsset(widget.audioFile, rate: widget.rate);
    widget.onPlayed?.call();
  }

  @override
  Widget build(BuildContext context) {
    final big = widget.variant == AudioButtonVariant.big;
    final shadowOffset = Offset(0, big ? 4 : 3);
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) {
        setState(() => _pressed = false);
        _play();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        width: _size,
        height: _size,
        transform: Matrix4.translationValues(
          0,
          _pressed ? shadowOffset.dy : 0,
          0,
        ),
        decoration: BoxDecoration(
          color: LpColors.bgWhite,
          borderRadius: BorderRadius.circular(big ? 12 : 10),
          border: Border.all(color: LpColors.ink, width: big ? 3 : 2.5),
          boxShadow: _pressed
              ? null
              : <BoxShadow>[
                  BoxShadow(color: LpColors.ink, offset: shadowOffset),
                ],
        ),
        child: Center(
          child: CustomPaint(
            size: Size.square(_size * 0.55),
            painter: const _SpeakerPainter(),
          ),
        ),
      ),
    );
  }
}

class _SpeakerPainter extends CustomPainter {
  const _SpeakerPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final strokeW = math.max(1.8, w * 0.07);
    final stroke = Paint()
      ..color = LpColors.ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeW
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    // Speaker body + cone (yellow with ink outline).
    final body = Path()
      ..moveTo(w * 0.06, h * 0.38)
      ..lineTo(w * 0.26, h * 0.38)
      ..lineTo(w * 0.50, h * 0.16)
      ..lineTo(w * 0.50, h * 0.84)
      ..lineTo(w * 0.26, h * 0.62)
      ..lineTo(w * 0.06, h * 0.62)
      ..close();
    canvas.drawPath(body, Paint()..color = LpColors.brandYellow);
    canvas.drawPath(body, stroke);

    // Sound waves.
    for (final r in <double>[w * 0.18, w * 0.32]) {
      canvas.drawArc(
        Rect.fromCircle(center: Offset(w * 0.56, h * 0.5), radius: r),
        -math.pi * 0.32,
        math.pi * 0.64,
        false,
        stroke,
      );
    }
  }

  @override
  bool shouldRepaint(_SpeakerPainter oldDelegate) => false;
}
