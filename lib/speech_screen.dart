import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:voice_chat_app/api_services.dart';
import 'package:voice_chat_app/chat_model.dart';
import 'package:voice_chat_app/colors.dart';
import 'package:voice_chat_app/text_to_speech.dart';

class SpeechScreen extends StatefulWidget {
  const SpeechScreen({super.key});

  @override
  State<SpeechScreen> createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  SpeechToText speechToText = SpeechToText();
  var text = "Hold the button and start speaking";
  var isListening = false;

  final List<ChatMessage> messages = [];

  var scrollController = ScrollController();

  scrollMethod() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: AvatarGlow(
        endRadius: 75.0,
        animate: isListening,
        duration: const Duration(milliseconds: 2000),
        glowColor: bgColor,
        repeatPauseDuration: const Duration(milliseconds: 100),
        showTwoGlows: true,
        child: GestureDetector(
          onTapDown: (details) async {
            if (!isListening) {
              var available = await speechToText.initialize();
              if (available) {
                setState(() {
                  isListening = true;
                  speechToText.listen(onResult: (result) {
                    setState(() {
                      text = result.recognizedWords;
                    });
                  });
                });
              }
            }
          },
          onTapUp: (details) async {
            setState(() {
              isListening = false;
            });
            await speechToText.stop();
            if (text.isNotEmpty &&
                text != "Hold the button and start speaking") {
              messages.add(ChatMessage(text: text, type: ChatMessageType.user));
              var msg = await ApiServices.sendMessage(text);
              msg = msg?.trim();
              setState(() {
                messages.add(ChatMessage(text: msg, type: ChatMessageType.bot));
              });
              Future.delayed(const Duration(milliseconds: 500), () {
                TextToSpeech.speak(msg!);
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Failed to process. Tly again!"),
                ),
              );
            }
          },
          child: CircleAvatar(
            backgroundColor: bgColor,
            radius: 35,
            child: Icon(
              isListening ? Icons.mic : Icons.mic_none,
              color: Colors.white,
            ),
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: bgColor,
        leading: const Icon(Icons.sort_rounded, color: Colors.white),
        title: const Text(
          'Voice Assistant',
          style: TextStyle(fontWeight: FontWeight.w600, color: textColor),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: Column(
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 20,
                color: isListening ? Colors.black87 : Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: chatBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var chat = messages[index];
                    return chatBubble(
                      chatText: chat.text,
                      type: chat.type,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget chatBubble({required chatText, required ChatMessageType? type}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: bgColor,
          child: type == ChatMessageType.bot
              ? const Icon(Icons.android, color: Colors.white)
              : const Icon(
                  Icons.face,
                  color: Colors.white,
                ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: type == ChatMessageType.bot ? bgColor : Colors.white,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
            child: Text(
              "$chatText",
              style: TextStyle(
                  color: type == ChatMessageType.bot ? textColor : chatBgColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}
