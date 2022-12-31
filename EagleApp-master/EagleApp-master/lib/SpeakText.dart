import 'package:speech_recognition/speech_recognition.dart';

class SpeakText {
  SpeechRecognition speechRecognition;
  bool _isAvailable = false;
  bool _isListening = false;

  String resultText = "";

  void setResultText(String text) {
    resultText = text;
  }

  void setListening(bool listening){
    _isListening  = listening;
  }

  void initSpeechRecognizer() {
    speechRecognition = SpeechRecognition();

    speechRecognition.setAvailabilityHandler(
      (bool result) => _isAvailable = result,
    );

    speechRecognition.setRecognitionStartedHandler(
      () => _isListening = true,
    );

    speechRecognition.setRecognitionResultHandler(
      (String speech) => this.setResultText(speech),
    );

    speechRecognition.activate().then(
          (result) => _isAvailable = result,
        );
  }
}
