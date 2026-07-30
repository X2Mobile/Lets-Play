import 'package:audioplayers/audioplayers.dart';

/// Thin wrapper around a single shared [AudioPlayer].
///
/// All bundled clips live under `assets/audio/` — callers pass just the file
/// name, e.g. `AudioService.instance.playAsset('alef.mp3')`.
/// The snail button in listen exercises replays the same clip at a slower
/// [rate] (e.g. `rate: 0.6`).
class AudioService {
  AudioService._();

  static final AudioService instance = AudioService._();

  final AudioPlayer _player = AudioPlayer();

  Future<void> playAsset(String file, {double rate = 1.0}) async {
    try {
      await _player.stop();
      await _player.setPlaybackRate(rate);
      await _player.play(AssetSource('audio/$file'));
    } catch (_) {
      // Audio must never crash the demo (e.g. simulator without audio out).
    }
  }

  Future<void> stop() async {
    try {
      await _player.stop();
    } catch (_) {
      // Ignore — see playAsset.
    }
  }
}
