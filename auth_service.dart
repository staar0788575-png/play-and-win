import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../../core/constants/app_constants.dart';

class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserModel> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user!;
    final now = DateTime.now();

    final userModel = UserModel(
      id: user.uid,
      email: email,
      username: username,
      displayName: username,
      createdAt: now,
      updatedAt: now,
    );

    await _db
        .collection(AppConstants.usersCollection)
        .doc(user.uid)
        .set(userModel.toMap());

    await user.updateDisplayName(username);

    return userModel;
  }

  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final doc = await _db
        .collection(AppConstants.usersCollection)
        .doc(credential.user!.uid)
        .get();

    if (!doc.exists) {
      throw Exception('User profile not found. Please contact support.');
    }

    await _db
        .collection(AppConstants.usersCollection)
        .doc(credential.user!.uid)
        .update({'isOnline': true, 'updatedAt': Timestamp.now()});

    return UserModel.fromFirestore(doc);
  }

  Future<void> signOut() async {
    final uid = currentUser?.uid;
    if (uid != null) {
      await _db
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .update({'isOnline': false, 'updatedAt': Timestamp.now()});
    }
    await _auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<UserModel?> getCurrentUserModel() async {
    final user = currentUser;
    if (user == null) return null;

    final doc = await _db
        .collection(AppConstants.usersCollection)
        .doc(user.uid)
        .get();

    if (!doc.exists) return null;

    return UserModel.fromFirestore(doc);
  }

  Stream<UserModel?> userStream(String userId) {
    return _db
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .snapshots()
        .map((doc) => doc.exists ? UserModel.fromFirestore(doc) : null);
  }
}
