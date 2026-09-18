// ====================================================================
// (Firebase Chat Service) - خدمة الدردشة الفورية عبر Firebase
// ====================================================================

import 'package:firebase_database/firebase_database.dart';

class ChatService {
  // مرجع قاعدة البيانات المخصص لغرفة اللعبة
  final DatabaseReference _chatRef = FirebaseDatabase.instance.ref().child('rooms/game_chat');

  // إرسال رسالة جديدة مع اسم اللاعب والنص
  Future<void> sendMessage(String playerName, String messageText) async {
    if (messageText.trim().isEmpty) return;

    try {
      await _chatRef.push().set({
        'sender': playerName,
        'message': messageText,
        'timestamp': ServerValue.timestamp,
      });
    } catch (e) {
      // التعامل مع أخطاء الإرسال في حال انقطاع الاتصال
      print("خطأ في إرسال الرسالة: $e");
    }
  }

  // الحصول على مرجع الاستماع للرسائل (يستخدم مع StreamBuilder لعرض الرسائل لحظياً)
  DatabaseReference getChatStream() {
    return _chatRef;
  }
}
