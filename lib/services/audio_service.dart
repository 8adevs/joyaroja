import 'dart:async';

import 'package:audioplayers/audioplayers.dart';

/// Plays the ambient sound bed during a mantra session: fade in on
/// start, loop quietly, fade out on stop.
///
/// The asset itself is not bundled yet — see assets/audio/README.md.
class AudioService {
  AudioService() : _player = AudioPlayer();

  static const _ambientAssetPath = 'audio/ambient_bowl.mp3';
  static const _targetVolume = 0.35;
  static const _fadeStepDuration = Duration(milliseconds: 80);
  static const _fadeSteps = 12;

  final AudioPlayer _player;
  Timer? _fadeTimer;

  Future<void> playAmbientLoop() async {
    _fadeTimer?.cancel();
    await _player.setReleaseMode(ReleaseMode.loop);
    await _player.setVolume(0);
    await _player.play(AssetSource(_ambientAssetPath));
    _fadeVolume(from: 0, to: _targetVolume);
  }

  Future<void> stopWithFadeOut() async {
    _fadeTimer?.cancel();
    final completer = Completer<void>();
    _fadeVolume(
      from: _targetVolume,
      to: 0,
      onDone: () async {
        await _player.stop();
        completer.complete();
      },
    );
    return completer.future;
  }

  void _fadeVolume({
    required double from,
    required double to,
    Future<void> Function()? onDone,
  }) {
    var step = 0;
    final delta = (to - from) / _fadeSteps;
    _fadeTimer = Timer.periodic(_fadeStepDuration, (timer) async {
      step++;
      final volume = (from + delta * step).clamp(0.0, 1.0);
      await _player.setVolume(volume);
      if (step >= _fadeSteps) {
        timer.cancel();
        await onDone?.call();
      }
    });
  }

  Future<void> dispose() async {
    _fadeTimer?.cancel();
    await _player.dispose();
  }
}
