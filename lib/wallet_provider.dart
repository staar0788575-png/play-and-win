import 'package:flutter/foundation.dart';
import 'wallet_model.dart';

class WalletProvider with ChangeNotifier {
  final WalletModel _wallet = WalletModel();

  int get coins => _wallet.coins;
  int get dailyRoses => _wallet.dailyRoses;

  WalletProvider() {
    _wallet.checkDailyRoses();
  }

  // انشئ شحن النقود بناء على القيمه المصرى //
  void rechargeWallet(double amountInEGP) {
    _wallet.recharge(amountInEGP);
    notifyListeners();
  }

  // استخدام الورود اليومى //
  bool useRose() {
    _wallet.checkDailyRoses();
    if (_wallet.dailyRoses > 0) {
      _wallet.dailyRoses--;
      notifyListeners();
      return true;
    }
    return false;
  }

  // خصم عملات عند إرسال هدية أو إلقاء غرفه //
  bool deductCoins(int amount) {
    if (_wallet.coins >= amount) {
      _wallet.coins -= amount;
      notifyListeners();
      return true;
    }
    return false;
  }

  // === (الدوال الجديدة المضافة لنتائج الألعاب) ===
  
  // إضافة 20 نقطة/عملة عند الفوز في أي لعبة
  void addWinReward() {
    _wallet.coins += 20;
    notifyListeners();
  }

  // خصم 10 نقاط/عملات عند الخسارة (مع التأكد من عدم نزول الرصيد تحت الصفر)
  void applyLossPenalty() {
    if (_wallet.coins >= 10) {
      _wallet.coins -= 10;
    } else {
      _wallet.coins = 0;
    }
    notifyListeners();
  }
}
