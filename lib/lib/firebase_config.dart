import 'package:firebase_core/firebase_core.dart';

class FirebaseConfig {
  static Future<void> initializeFirebase() async {
    // تهيئة فايربيز الأساسية للتطبيق
    await Firebase.initializeApp();
  }
}
