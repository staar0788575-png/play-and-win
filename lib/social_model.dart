class UserModel {
  final String id;
  final String name;
  bool isBlocked;

  UserModel({
    required this.id,
    required this.name,
    this.isBlocked = false,
  });
}

class ChatMessage {
  final String senderId;
  final String senderName;
  final String message;
  final DateTime timestamp;
  final bool isPrivate;

  ChatMessage({
    required this.senderId,
    required this.senderName,
    required this.message,
    required this.timestamp,
    this.isPrivate = false,
  });
}

class SocialManager {
  // قائمة تجريبية للمستخدمين والأصدقاء
  final List<UserModel> friends = [
    UserModel(id: '1', name: 'أحمد محمد'),
    UserModel(id: '2', name: 'محمود علي'),
    UserModel(id: '3', name: 'سارة خالد'),
  ];

  final List<UserModel> pendingRequests = [
    UserModel(id: '4', name: 'خالد عمر'),
  ];

  final List<UserModel> blockedUsers = [];

  final List<ChatMessage> publicMessages = [];
  final List<ChatMessage> privateMessages = [];

  // إرسال طلب صداقة أو قبول
  void acceptFriendRequest(UserModel user) {
    pendingRequests.remove(user);
    if (!friends.contains(user)) {
      friends.add(user);
    }
  }

  // حظر مستخدم
  void blockUser(UserModel user) {
    user.isBlocked = true;
    friends.remove(user);
    pendingRequests.remove(user);
    if (!blockedUsers.contains(user)) {
      blockedUsers.add(user);
    }
  }

  // إلغاء الحظر
  void unblockUser(UserModel user) {
    user.isBlocked = false;
    blockedUsers.remove(user);
    friends.add(user);
  }

  // إرسال رسالة عامة
  void sendPublicMessage(String senderName, String text) {
    publicMessages.add(ChatMessage(
      senderId: 'me',
      senderName: senderName,
      message: text,
      timestamp: DateTime.now(),
      isPrivate: false,
    ));
  }

  // إرسال رسالة خاصة
  void sendPrivateMessage(String senderName, String text) {
    privateMessages.add(ChatMessage(
      senderId: 'me',
      senderName: senderName,
      message: text,
      timestamp: DateTime.now(),
      isPrivate: true,
    ));
  }
}
