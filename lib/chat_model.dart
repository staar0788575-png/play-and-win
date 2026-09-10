class ChatMessage {
  final String senderId;
  final String senderName;
  final String message;
  final DateTime timestamp;
  final bool isPrivate;
  final String? receiverId;

  ChatMessage({
    required this.senderId,
    required this.senderName,
    required this.message,
    required this.timestamp,
    this.isPrivate = false,
    this.receiverId,
  });
}
