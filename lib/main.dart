import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voice_chat_app/speech_screen.dart';
import 'package:voice_chat_app/text_to_speech.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  TextToSpeech.initTTS();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SpeechScreen(),
      debugShowCheckedModeBanner: false,
      title: 'Speech To Text',
    );
  }
}
