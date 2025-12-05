import 'dart:math';

import 'package:flutter_core/core/enums/speech_status.dart';
import 'package:my_logger_metrics/logger.dart';
import 'package:speech_to_text/speech_to_text.dart';

typedef ResultCallback = void Function(String text, bool isListening);
typedef SoundLevelCallback =
    void Function(double min, double max, double level);
typedef ErrorCallback = void Function(String error);
typedef StatusCallback = void Function(SpeechStatus status);

class SpeechLogic {
  final SpeechToText _speech = SpeechToText();
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  String _finalText = '';
  bool _isListening = false;
  var speechFinalTimeout = 5;

  final Map<String, ResultCallback> _onResults = {};
  final Map<String, SoundLevelCallback> _onSoundLevel = {};
  final Map<String, ErrorCallback> _onError = {};
  final Map<String, StatusCallback> _onStatusChange = {};
  final listenOptions = SpeechListenOptions(
    listenMode: ListenMode.dictation,
    onDevice: false,
    partialResults: true,
  );

  bool get isListening => _speech.isListening;

  bool get isAvailable => _speech.isAvailable;

  Future<bool> initialize() async {
    $logger.d('SpeechService initializes');
    return await _speech.initialize(
      onError: (error) {
        _onError.forEach((key, value) => value.call(error.toString()));
      },
      onStatus: (status) => _onStatusChange.forEach(
        (key, value) => value.call(speechStatus(status)),
      ),
      finalTimeout: Duration(seconds: speechFinalTimeout),
    );
  }

  void addListener(
    String subscriptionKey, {
    required ResultCallback onResult,
    required SoundLevelCallback onSoundLevel,
    required ErrorCallback onError,
    required StatusCallback onStatusChange,
  }) {
    $logger.d('SpeechService addListener $subscriptionKey');
    _onResults[subscriptionKey] = onResult;
    _onSoundLevel[subscriptionKey] = onSoundLevel;
    _onError[subscriptionKey] = onError;
    _onStatusChange[subscriptionKey] = onStatusChange;
  }

  void removeListener(String subscriptionKey) {
    $logger.d('SpeechService removeListener $subscriptionKey');
    _onResults.remove(subscriptionKey);
    _onSoundLevel.remove(subscriptionKey);
    _onError.remove(subscriptionKey);
    _onStatusChange.remove(subscriptionKey);
  }

  SpeechStatus speechStatus(String status) {
    switch (status) {
      case 'listening':
        return SpeechStatus.listening;
      case 'notListening':
        return SpeechStatus.notListening;
      case 'done':
        return SpeechStatus.done;
      default:
        return SpeechStatus.unknown;
    }
  }

  Future<void> listen() async {
    $logger.d('SpeechService starting listen');
    _isListening = true;
    try {
      await _speech.listen(
        onResult: (result) {
          // Emitting live text
          _onResult('${result.recognizedWords} ', '');

          // Emitting the final text
          if (result.finalResult) {
            _onResult('', '${result.recognizedWords} ');
          }

          if (!_isListening) {
            return;
          }

          // Restart listening if it was interrupted
          if (!_speech.isListening && result.finalResult) {
            listen();
          }
        },
        listenOptions: listenOptions,
        onSoundLevelChange: (level) {
          minSoundLevel = min(minSoundLevel, level);
          maxSoundLevel = max(maxSoundLevel, level);
          _onSoundLevel.forEach(
            (key, value) => value.call(minSoundLevel, maxSoundLevel, level),
          );
        },
      );
    } catch (e) {
      $logger.d('SpeechService exception thrown on listen $e');
    }
  }

  void _onResult(String liveText, String finalText) {
    _finalText += finalText;
    _onResults.forEach(
      (key, value) => value.call(_finalText + liveText, _isListening),
    );
  }

  void setText(String text) {
    _finalText = text;
  }

  void clearText() => setText('');

  Future<void> stop() {
    $logger.d('SpeechService stopping listen');
    _isListening = false;
    return _speech.stop();
  }

  void dispose() {
    _isListening = false;
    _speech.stop();
    _speech.cancel();
  }
}
