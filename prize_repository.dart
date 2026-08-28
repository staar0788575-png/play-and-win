import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../services/reloadly_service.dart';
import '../services/wallet_service.dart';
import '../models/prize_model.dart';
import '../models/transaction_model.dart';
import '../../core/constants/app_constants.dart';

class PrizeRepository {
  PrizeRepository._();

  static final PrizeRepository instance = PrizeRepository._();

  final ReloadlyService _reloadly = ReloadlyService.instance;
  final WalletService _wallet = WalletService.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _uuid = const Uuid();

  Stream<List<PrizeModel>> prizesStream() {
    return _db
        .collection(AppConstants.prizesCollection)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snap) => snap.docs.map(PrizeModel.fromFirestore).toList());
  }

  Future<List<PrizeModel>> getPrizes() async {
    final snap = await _db
        .collection(AppConstants.prizesCollection)
        .where('isActive', isEqualTo: true)
        .get();
    return snap.docs.map(PrizeModel.fromFirestore).toList();
  }

  Future<Map<String, dynamic>> redeemGiftCard({
    required String userId,
    required int productId,
    required String recipientEmail,
    required double amount,
    required int pointsCost,
  }) async {
    final result = await _reloadly.redeemGiftCard(
      productId: productId,
      recipientEmail: recipientEmail,
      amount: amount,
    );

    final txId = _uuid.v4();
    final now = DateTime.now();

    await _wallet.createTransaction(TransactionModel(
      id: txId,
      userId: userId,
      type: TransactionType.prizeRedemption,
      status: TransactionStatus.completed,
      amount: amount,
      description: 'Gift card redemption - ${result['product']?['name'] ?? 'Unknown'}',
      createdAt: now,
      reference: result['transactionId']?.toString(),
      metadata: result,
    ));

    return result;
  }

  Future<Map<String, dynamic>> mobileTopUp({
    required String userId,
    required String operatorId,
    required String recipientPhone,
    required double amount,
    String? senderPhone,
  }) async {
    final result = await _reloadly.mobileTopUp(
      operatorId: operatorId,
      recipientPhone: recipientPhone,
      amount: amount,
      senderPhone: senderPhone,
    );

    final txId = _uuid.v4();
    final now = DateTime.now();

    await _wallet.createTransaction(TransactionModel(
      id: txId,
      userId: userId,
      type: TransactionType.prizeRedemption,
      status: TransactionStatus.completed,
      amount: amount,
      description: 'Mobile top-up to $recipientPhone',
      createdAt: now,
      reference: result['transactionId']?.toString(),
      metadata: result,
    ));

    return result;
  }

  Future<List<Map<String, dynamic>>> getAvailableGiftCards() async {
    return _reloadly.getGiftCards();
  }

  Future<List<Map<String, dynamic>>> getMobileOperators() async {
    return _reloadly.getOperators();
  }
}
