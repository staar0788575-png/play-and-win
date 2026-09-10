import 'package:flutter/foundation.dart';
import 'wallet_model.dart';

class WalletProvider with ChangeNotifier {
  final WalletModel _wallet = WalletModel();

  int get coins => _wallet.coins;
  int get dailyRoses => _wallet.dailyRoses;

  WalletProvider() {
    _wallet.checkDailyRoses();
  }

  // تنفيذ عملية الشحن بناءً على القيمة بالمصري
  void rechargeWallet(double amountInEGP) {
    _wallet.recharge(amountInEGP);
    notifyListeners();
  }

  // استخدام الورد اليومي
  bool useRose() {
    _wallet.checkDailyRoses();
    if (_wallet.dailyRoses > 0) {
      _wallet.dailyRoses--;
      notifyListeners();
      return true;
    }
    return false;
  }

  // خصم عملات عند إرسال هدية أو إغلاق غرفة
  bool deductCoins(int amount) {
    if (_wallet.coins >= amount) {
      _wallet.coins -= amount;
      notifyListeners();
      return true;
    }
    return false;
  }
}
