import 'package:speech_to_text/speech_to_text.dart';

class SpeechToTextService {
  final SpeechToText _speech = SpeechToText();

  bool _isInitialized = false;

  Future<bool> init() async {
    _isInitialized = await _speech.initialize();
    return _isInitialized;
  }

  Future<void> startListening({
    required Function(String text) onResult,
  }) async {
    if (!_isInitialized) {
      await init();
    }

    await _speech.listen(
      onResult: (result) {
        onResult(result.recognizedWords);
      },
    );
  }

  Future<void> stopListening() async {
    await _speech.stop();
  }

  bool get isListening => _speech.isListening;
}
