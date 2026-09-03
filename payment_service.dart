// payment_service.dart

class PaymentService {
  // دالة حساب العملات بناءً على المبلغ المدفوع (مثال: 16 جنيه مصري = 500 عملة ذهبية)
  int calculateCoinsWithBonus(double amountPaidInEGP) {
    if (amountPaidInEGP <= 0) return 0;

    // القاعدة الأساسية: كل 16 جنيه تعطي 500 عملة
    int baseCoins = (amountPaidInEGP / 16).floor() * 500;

    // بونص ومكافأة دعم إضافية للمشتري كلما زاد مبلغ الشحن
    double bonusMultiplier = 1.0; // بدون بونص للمبالغ الصغيرة الأساسية
    
    if (amountPaidInEGP >= 50 && amountPaidInEGP < 150) {
      bonusMultiplier = 1.10; // 10% بونص إضافي
    } else if (amountPaidInEGP >= 150 && amountPaidInEGP < 300) {
      bonusMultiplier = 1.15; // 15% بونص إضافي
    } else if (amountPaidInEGP >= 300) {
      bonusMultiplier = 1.25; // 25% بونص دعم كهدية للمشترين الكبار
    }

    // حساب إجمالي العملات بعد إضافة البونص
    int totalCoins = (baseCoins * bonusMultiplier).toInt();
    return totalCoins;
  }
}
