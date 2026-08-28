import 'package:flutter/material.dart';
import '../../data/services/wallet_service.dart';
import '../../data/models/transaction_model.dart';

class WalletProvider extends ChangeNotifier {
  WalletProvider();

  final WalletService _service = WalletService.instance;

  List<TransactionModel> _transactions = [];
  double _balance = 0.0;
  bool _isLoading = false;
  String? _error;

  List<TransactionModel> get transactions => _transactions;
  double get balance => _balance;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void loadTransactions(String userId) {
    _service.transactionsStream(userId).listen((txs) {
      _transactions = txs;
      notifyListeners();
    });
  }

  Future<void> loadBalance(String userId) async {
    try {
      _balance = await _service.getBalance(userId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
