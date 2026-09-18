// ====================================================================
// (Game Chat Widget) - ويدجت الدردشة الفورية المشترك للألعاب 💬
// ====================================================================

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'chat_service.dart';

class GameChatWidget extends StatefulWidget {
  final String playerName;
  const GameChatWidget({Key? key, required this.playerName}) : super(key: key);

  @override
  State<GameChatWidget> createState() => _GameChatWidgetState();
}

class _GameChatWidgetState extends State<GameChatWidget> {
  final ChatService _chatService = ChatService();
  final TextEditingController _messageController = TextEditingController();

  void _sendUserMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      _chatService.sendMessage(widget.playerName, _messageController.text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder(
            stream: _chatService.getChatStream().onValue,
            builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
              if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
                return const Center(
                  child: Text(
                    'لا توجد رسائل بعد، ابدأ الدردشة!',
                    style: TextStyle(color: Colors.white54, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                );
              }

              Map<dynamic, dynamic> values = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
              List<dynamic> messagesList = values.values.toList();

              return ListView.builder(
                itemCount: messagesList.length,
                itemBuilder: (context, index) {
                  var msg = messagesList[index];
                  String sender = msg['sender'] ?? 'مستخدم';
                  String text = msg['message'] ?? '';

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$sender: ',
                          style: const TextStyle(
                            color: Colors.amberAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            text,
                            style: const TextStyle(color: Colors.white, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: const InputDecoration(
                    hintText: 'اكتب رسالتك...',
                    hintStyle: TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: Color(0xFF0F0F19),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  onSubmitted: (_) => _sendUserMessage(),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  icon: const Icon(Icons.send, color: Colors.black, size: 20),
                  onPressed: _sendUserMessage,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
