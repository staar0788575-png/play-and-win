import 'package:flutter/material.dart';
import 'chat_model.dart';

class ChatScreen extends StatefulWidget {
  final String currentUserName;
  const ChatScreen({super.key, required this.currentUserName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  
  final List<ChatMessage> _messages = [
    ChatMessage(
      senderId: '1',
      senderName: 'أحمد',
      message: 'أهلاً بالجميع في الغرفة!',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    ChatMessage(
      senderId: '2',
      senderName: 'سارة',
      message: 'مرحباً، من يبدأ التحدي؟',
      timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
    ),
  ];

  bool _isPublicChat = true;

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(
          senderId: 'me',
          senderName: widget.currentUserName,
          message: _messageController.text.trim(),
          timestamp: DateTime.now(),
          isPrivate: !_isPublicChat,
        ),
      );
      _messageController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ChoiceChip(
              label: const Text('الشات العام'),
              selected: _isPublicChat,
              onSelected: (selected) {
                setState(() {
                  _isPublicChat = true;
                });
              },
            ),
            const SizedBox(width: 10),
            ChoiceChip(
              label: const Text('الشات الخاص'),
              selected: !_isPublicChat,
              onSelected: (selected) {
                setState(() {
                  _isPublicChat = false;
                });
              },
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                if (_isPublicChat && msg.isPrivate) return const SizedBox.shrink();
                if (!_isPublicChat && !msg.isPrivate) return const SizedBox.shrink();

                final bool isMe = msg.senderId == 'me';

                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.blue[100] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!isMe)
                          Text(
                            msg.senderName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Colors.blue,
                            ),
                          ),
                        const SizedBox(height: 4),
                        Text(msg.message, style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: _isPublicChat ? 'اكتب رسالة عامة...' : 'اكتب رسالة خاصة...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
