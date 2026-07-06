/// A voice available for text-to-speech narration (future feature).
class MantraVoice {
  const MantraVoice({required this.id, required this.displayName});

  final String id;
  final String displayName;
}

/// Narrates mantra text out loud. Abstracted behind an interface so a
/// real TTS engine (e.g. flutter_tts) can be plugged in later without
/// touching the UI or providers that depend on this contract.
abstract class MantraVoiceService {
  Future<List<MantraVoice>> availableVoices();
  Future<void> speak(String text, {String? voiceId});
  Future<void> stop();
}

/// Placeholder implementation used until a real TTS engine is wired in.
class NoopVoiceService implements MantraVoiceService {
  @override
  Future<List<MantraVoice>> availableVoices() async => const [];

  @override
  Future<void> speak(String text, {String? voiceId}) async {}

  @override
  Future<void> stop() async {}
}
