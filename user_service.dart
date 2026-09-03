// user_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'user_model.dart'; 

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // جلب بيانات المستخدم الحالي كـ Stream لتحديث الواجهة تلقائياً
  Stream<UserModel> getUserStream(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return UserModel.fromMap(snapshot.data()!, snapshot.id);
      } else {
        throw Exception("User not found");
      }
    });
  }

  // تجديد الورود اليومية تلقائياً (عادي 10، وللـ VIP 30 وردة)
  Future<void> checkAndResetDailyRoses(UserModel currentUser) async {
    final now = DateTime.now();
    final lastReset = currentUser.lastRoseReset;

    if (lastReset == null ||
        now.year > lastReset.year ||
        now.month > lastReset.month ||
        now.day > lastReset.day) {
          
      int rosesToAdd = currentUser.isVip ? 30 : 10;

      await _firestore.collection('users').doc(currentUser.uid).update({
        'dailyRoses': rosesToAdd,
        'lastRoseReset': FieldValue.serverTimestamp(),
      });
    }
  }

  // إضافة مستخدم إلى قائمة الحظر
  Future<void> blockUser(String targetUserId) async {
    final currentUid = _auth.currentUser?.uid;
    if (currentUid == null) return;

    await _firestore.collection('users').doc(currentUid).update({
      'blockedUsers': FieldValue.arrayUnion([targetUserId]),
    });
  }

  // إزالة المستخدم من قائمة الحظر
  Future<void> unblockUser(String targetUserId) async {
    final currentUid = _auth.currentUser?.uid;
    if (currentUid == null) return;

    await _firestore.collection('users').doc(currentUid).update({
      'blockedUsers': FieldValue.arrayRemove([targetUserId]),
    });
  }
}
