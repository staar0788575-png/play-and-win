import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/transaction_model.dart';
import '../../core/constants/app_constants.dart';

class WalletService {
  WalletService._();

  static final WalletService instance = WalletService._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<TransactionModel>> transactionsStream(String userId) {
    return _db
        .collection(AppConstants.transactionsCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(TransactionModel.fromFirestore).toList());
  }

  Future<List<TransactionModel>> getTransactions(String userId) async {
    final snap = await _db
        .collection(AppConstants.transactionsCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();
    return snap.docs.map(TransactionModel.fromFirestore).toList();
  }

  Future<void> createTransaction(TransactionModel transaction) async {
    await _db
        .collection(AppConstants.transactionsCollection)
        .doc(transaction.id)
        .set(transaction.toMap());

    if (transaction.status == TransactionStatus.completed) {
      await _updateWalletBalance(transaction.userId, transaction);
    }
  }

  Future<void> _updateWalletBalance(String userId, TransactionModel tx) async {
    final userRef = _db.collection(AppConstants.usersCollection).doc(userId);
    final delta = tx.isCredit ? tx.amount : -tx.amount;

    await _db.runTransaction((txn) async {
      final doc = await txn.get(userRef);
      if (!doc.exists) return;

      final currentBalance =
          (doc.data()?['walletBalance'] as num?)?.toDouble() ?? 0.0;
      final newBalance = currentBalance + delta;

      if (newBalance < 0) throw Exception('Insufficient balance');

      txn.update(userRef, {
        'walletBalance': newBalance,
        'updatedAt': Timestamp.now(),
      });
    });
  }

  Future<double> getBalance(String userId) async {
    final doc = await _db
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .get();
    return (doc.data()?['walletBalance'] as num?)?.toDouble() ?? 0.0;
  }
}
