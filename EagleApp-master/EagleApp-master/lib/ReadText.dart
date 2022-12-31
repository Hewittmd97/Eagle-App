import 'dart:async';
import 'dart:io';
import 'package:flutter_tts/flutter_tts.dart';

enum TtsState { playing, stopped }

class ReadText {
  FlutterTts flutterTts;
  dynamic languages;
  dynamic voices;
  String language;
  String voice;

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;

  get isStopped => ttsState == TtsState.stopped;

  // Needs to be initialized
  initTts() {
    flutterTts = FlutterTts();

    if (Platform.isAndroid) {
      flutterTts.ttsInitHandler(() {
        _getLanguages();
        _getVoices();
      });
    } else if (Platform.isIOS) {
      _getLanguages();
      _getVoices();
    }

    flutterTts.setStartHandler(() {
      ttsState = TtsState.playing;
    });

    flutterTts.setCompletionHandler(() {
      print("Complete");
      ttsState = TtsState.stopped;
    });

    flutterTts.setErrorHandler((msg) {
      ttsState = TtsState.stopped;
    });
  }

  Future _getLanguages() async {
    languages = await flutterTts.getLanguages;
  }

  Future _getVoices() async {
    voices = await flutterTts.getVoices;
  }

  Future speak(textToSpeech) async {
    var result = await flutterTts.speak(textToSpeech);
    if (result == 1) ttsState = TtsState.playing;
  }

  Future stop() async {
    var result = await flutterTts.stop();
    if (result == 1) ttsState = TtsState.stopped;
  }

// need to call this in dispose
//  @override
//  void dispose() {
//    super.dispose();
//    flutterTts.stop();
//  }
}
