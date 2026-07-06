import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/audio_service.dart';
import 'settings_provider.dart';

enum MantraSessionStatus { idle, running }

class MantraSessionState {
  const MantraSessionState(this.status);

  final MantraSessionStatus status;

  bool get isRunning => status == MantraSessionStatus.running;
}

final audioServiceProvider = Provider<AudioService>((ref) {
  final service = AudioService();
  ref.onDispose(service.dispose);
  return service;
});

final mantraSessionProvider =
    StateNotifierProvider<MantraSessionNotifier, MantraSessionState>((ref) {
  return MantraSessionNotifier(
    audioService: ref.watch(audioServiceProvider),
    durationMinutes: () => ref.read(settingsProvider).durationMinutes,
  );
});

/// Drives the active mantra session: starts the ambient audio and a
/// timer for the configured duration, and stops both (cleanly, with a
/// fade-out) either when the timer elapses or the user cancels early.
/// The jewel animation listens to [MantraSessionState.status] rather
/// than to the timer directly.
class MantraSessionNotifier extends StateNotifier<MantraSessionState> {
  MantraSessionNotifier({
    required AudioService audioService,
    required int Function() durationMinutes,
  })  : _audioService = audioService,
        _durationMinutes = durationMinutes,
        super(const MantraSessionState(MantraSessionStatus.idle));

  final AudioService _audioService;
  final int Function() _durationMinutes;
  Timer? _sessionTimer;

  Future<void> start() async {
    if (state.isRunning) return;
    state = const MantraSessionState(MantraSessionStatus.running);
    await _audioService.playAmbientLoop();
    _sessionTimer = Timer(Duration(minutes: _durationMinutes()), stop);
  }

  Future<void> stop() async {
    if (!state.isRunning) return;
    _sessionTimer?.cancel();
    _sessionTimer = null;
    await _audioService.stopWithFadeOut();
    state = const MantraSessionState(MantraSessionStatus.idle);
  }

  @override
  void dispose() {
    _sessionTimer?.cancel();
    super.dispose();
  }
}
