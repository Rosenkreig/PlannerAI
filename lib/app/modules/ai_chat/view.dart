import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:taskmanager/app/core/utils/extensions.dart'; // Assuming this provides .wp and .sp extensions

class AIChat extends StatefulWidget {
  const AIChat({super.key});

  @override
  State<AIChat> createState() => _AIChatState();
}

class _AIChatState extends State<AIChat> {
  final Gemini gemini = Gemini.instance;
  List<ChatMessage> messages = [];
  ChatUser currentUser = ChatUser(id: '0', firstName: 'User');
  ChatUser geminiUser = ChatUser(id: '1', firstName: 'Gemini');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(4.0.wp), // Using extension
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'AI Chat',
                style: TextStyle(
                  fontSize: 20.0.sp, // Using extension
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              Expanded(
                child: DashChat(
                  currentUser: currentUser,
                  messageOptions: const MessageOptions(
                    showOtherUsersAvatar: false,
                    currentUserContainerColor: Colors.blueGrey,
                    currentUserTextColor: Colors.white,
                    containerColor: Color.fromARGB(255, 218, 198, 197),
                    textColor: Colors.black,
                  ),
                  onSend: _sendMessage,
                  messages: messages,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _sendMessage(ChatMessage chatMessage) {
    setState(() {
      messages = [chatMessage, ...messages];
    });

    try {
      String question = chatMessage.text;
      gemini.streamGenerateContent(question).listen((event) {
        String responsePart = "";
        if (event.content?.parts != null) {
          // Iterate through each part of the content
          for (final part in event.content!.parts!) {
            // Check if the part is a TextPart (contains actual text)
            if (part is TextPart) {
              responsePart += part.text ?? ""; // Append the text, handling potential null
            }
            // If there were other types of parts (e.g., DataPart for images),
            // you would handle them here if you wanted to display them.
          }
        }

        ChatMessage? lastMessage = messages.firstOrNull;

        // If the last message was from Gemini, append to it
        if (lastMessage != null && lastMessage.user == geminiUser) {
          lastMessage = messages.removeAt(0); // Remove the old message
          lastMessage.text += responsePart; // Append new content
          setState(() {
            messages = [lastMessage!, ...messages]; // Add the updated message back
          });
        } else {
          // Otherwise, create a new message from Gemini
          ChatMessage message = ChatMessage(
              user: geminiUser, createdAt: DateTime.now(), text: responsePart);
          setState(() {
            messages = [message, ...messages];
          });
        }
      }).onError((error) {
        // Handle any errors during content generation
        print("Gemini API Error: $error");
        // Optionally, display an error message to the user
        ChatMessage errorMessage = ChatMessage(
          user: geminiUser,
          createdAt: DateTime.now(),
          text: "Üzgünüm, bir hata oluştu: $error",
        );
        setState(() {
          messages = [errorMessage, ...messages];
        });
      });
    } catch (e) {
      print("Sending message error: $e");
      ChatMessage errorMessage = ChatMessage(
        user: geminiUser,
        createdAt: DateTime.now(),
        text: "Mesaj gönderirken bir hata oluştu: $e",
      );
      setState(() {
        messages = [errorMessage, ...messages];
      });
    }
  }
}