import 'package:cloud_firestore/cloud_firestore.dart';

class FriendService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 1. إرسال طلب صداقة
  Future<void> sendFriendRequest(String currentUid, String targetUid) async {
    await _firestore
        .collection('users')
        .doc(currentUid)
        .collection('friends')
        .doc(targetUid)
        .set({'status': 'pending_sent', 'updatedAt': Timestamp.now()});

    await _firestore
        .collection('users')
        .doc(targetUid)
        .collection('friends')
        .doc(currentUid)
        .set({'status': 'pending_received', 'updatedAt': Timestamp.now()});
  }

  // 2. قبول طلب الصداقة
  Future<void> acceptFriendRequest(String currentUid, String targetUid) async {
    await _firestore
        .collection('users')
        .doc(currentUid)
        .collection('friends')
        .doc(targetUid)
        .update({'status': 'accepted'});

    await _firestore
        .collection('users')
        .doc(targetUid)
        .collection('friends')
        .doc(currentUid)
        .update({'status': 'accepted'});
  }

  // 3. حظر مستخدم
  Future<void> blockUser(String currentUid, String targetUid) async {
    await _firestore
        .collection('users')
        .doc(currentUid)
        .collection('blockedUsers')
        .doc(targetUid)
        .set({'blockedAt': Timestamp.now()});

    await _firestore
        .collection('users')
        .doc(currentUid)
        .collection('friends')
        .doc(targetUid)
        .delete();
        
    await _firestore
        .collection('users')
        .doc(targetUid)
        .collection('friends')
        .doc(currentUid)
        .delete();
  }

  // 4. إلغاء الحظر
  Future<void> unblockUser(String currentUid, String targetUid) async {
    await _firestore
        .collection('users')
        .doc(currentUid)
        .collection('blockedUsers')
        .doc(targetUid)
        .delete();
  }
}
