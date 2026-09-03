// room_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class RoomService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // قفل أو فتح الغرفة
  Future<void> toggleRoomLock(String roomId, bool isLocked) async {
    await _firestore.collection('rooms').doc(roomId).update({
      'isLocked': isLocked,
    });
  }

  // إضافة مستخدم إلى قائمة الانتظار الخاصة بالغرفة
  Future<void> joinWaitingRoom(String roomId, String userId) async {
    await _firestore.collection('rooms').doc(roomId).update({
      'waitingList': FieldValue.arrayUnion([userId]),
    });
  }

  // إزالة مستخدم من قائمة الانتظار
  Future<void> leaveWaitingRoom(String roomId, String userId) async {
    await _firestore.collection('rooms').doc(roomId).update({
      'waitingList': FieldValue.arrayRemove([userId]),
    });
  }
}
