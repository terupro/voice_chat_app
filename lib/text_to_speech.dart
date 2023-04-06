import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeech {
  static FlutterTts tts = FlutterTts();
  static initTTS() {
    tts.setLanguage("en-EN"); // 言語
  }

  static speak(String text) async {
    tts.setStartHandler(() {
      print("TTS STARTED");
    });
    tts.setCompletionHandler(() {
      print("COMPLETED");
    });
    tts.setErrorHandler((message) {
      print(message);
    });
    await tts.setSpeechRate(1.0); // 速度
    await tts.setVolume(1.0); // 音量
    await tts.setPitch(1.0); // ピッチ
    await tts.awaitSpeakCompletion(true);
    await tts.speak(text);
  }
}
