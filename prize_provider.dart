import 'package:flutter/material.dart';
import '../../data/repositories/prize_repository.dart';
import '../../data/models/prize_model.dart';

class PrizeProvider extends ChangeNotifier {
  PrizeProvider() {
    _loadPrizes();
  }

  final PrizeRepository _repo = PrizeRepository.instance;

  List<PrizeModel> _prizes = [];
  bool _isLoading = false;
  String? _error;

  List<PrizeModel> get prizes => _prizes;
  List<PrizeModel> get giftCards =>
      _prizes.where((p) => p.type == PrizeType.giftCard).toList();
  List<PrizeModel> get mobileTopUps =>
      _prizes.where((p) => p.type == PrizeType.mobileTopUp).toList();
  bool get isLoading => _isLoading;
  String? get error => _error;

  void _loadPrizes() {
    _repo.prizesStream().listen((prizes) {
      _prizes = prizes;
      notifyListeners();
    });
  }

  Future<Map<String, dynamic>?> redeemGiftCard({
    required String userId,
    required int productId,
    required String recipientEmail,
    required double amount,
    required int pointsCost,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _repo.redeemGiftCard(
        userId: userId,
        productId: productId,
        recipientEmail: recipientEmail,
        amount: amount,
        pointsCost: pointsCost,
      );
      _isLoading = false;
      notifyListeners();
      return result;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<Map<String, dynamic>?> mobileTopUp({
    required String userId,
    required String operatorId,
    required String recipientPhone,
    required double amount,
    String? senderPhone,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _repo.mobileTopUp(
        userId: userId,
        operatorId: operatorId,
        recipientPhone: recipientPhone,
        amount: amount,
        senderPhone: senderPhone,
      );
      _isLoading = false;
      notifyListeners();
      return result;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
