class WalletModel {
  int coins;
  int dailyRoses;
  DateTime? lastRoseClaimDate;

  WalletModel({
    this.coins = 500, // رصيد تجريبي مبدئي
    this.dailyRoses = 10,
    this.lastRoseClaimDate,
  });

  // التحقق من تجديد الورد اليومي تلقائياً
  void checkDailyRoses() {
    final now = DateTime.now();
    if (lastRoseClaimDate == null ||
        now.difference(lastRoseClaimDate!).inHours >= 24) {
      dailyRoses = 10;
      lastRoseClaimDate = now;
    }
  }

  // حساب العملات عند الشحن بناءً على 16 جنيه = 500 عملة مع مكافأة تصاعدية
  void recharge(double amountInEGP) {
    int baseCoins = (amountInEGP / 16 * 500).round();
    int bonusCoins = 0;

    // مكافأة دعم للشحن بمبالغ أكبر
    if (amountInEGP >= 160) {
      bonusCoins = (baseCoins * 0.2).round(); // 20% هدية للمبالغ الكبيرة
    } else if (amountInEGP >= 80) {
      bonusCoins = (baseCoins * 0.1).round(); // 10% هدية
    }

    coins += baseCoins + bonusCoins;
  }
}
