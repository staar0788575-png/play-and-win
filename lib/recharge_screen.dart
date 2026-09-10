import 'package:flutter/material.dart';

class RechargeScreen extends StatefulWidget {
  final int currentCoins;
  final Function(int) onCoinsAdded;

  const RechargeScreen({
    super.key,
    required this.currentCoins,
    required this.onCoinsAdded,
  });

  @override
  State<RechargeScreen> createState() => _RechargeScreenState();
}

class _RechargeScreenState extends State<RechargeScreen> {
  final TextEditingController _cardController = TextEditingController();
  bool _isLoading = false;

  // فئات الشحن (المبلغ بالجنيه المصري وما يعادله من العملات مع بونص إضافي للدعم)
  final List<Map<String, dynamic>> rechargePackages = [
    {'price': 16, 'coins': 500, 'bonus': 0},
    {'price': 50, 'coins': 1600, 'bonus': 100},
    {'price': 100, 'coins': 3300, 'bonus': 300},
    {'price': 200, 'coins': 7000, 'bonus': 800},
  ];

  void _rechargeWithCard() {
    if (_cardController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء إدخال رقم كروت الشحن بشكل صحيح')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // محاكاة عملية التحقق من الكود والشحن
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
        _cardController.clear();
      });

      // إضافة 500 عملة افتراضية عند شحن الكروت العادية بناءً على المعيار المذكور
      int addedCoins = 500;
      widget.onCoinsAdded(addedCoins);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم شحن الكارت بنجاح وإضافة $addedCoins عملة لرصيدك!')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('شحن العملات عبر كروت الرصيد'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // رصيد المستخدم الحالي
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.amber[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.account_balance_wallet, color: Colors.amber, size: 30),
                  const SizedBox(width: 10),
                  Text(
                    'رصيدك الحالي: ${widget.currentCoins} عملة',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'أدخل كارت شحن الرصيد العادي (حسب بلدك):',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _cardController,
              decoration: InputDecoration(
                hintText: 'اكتب رقم الكارت هنا...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.credit_card),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _isLoading ? null : _rechargeWithCard,
                child: _isLoading
                    .toString()
                    .contains('true') // مؤشر تحميل
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('تأكيد وشحن الكارت', style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'باقات الدعم وعروض الشحن (كل 16 جنيه = 500 عملة):',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...rechargePackages.map((pkg) => Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading: const Icon(Icons.star, color: Colors.amber),
                    title: Text('شحن بقيمة ${pkg['price']} جنيه مصري'),
                    subtitle: Text('تحصل على ${pkg['coins']} عملة ${pkg['bonus'] > 0 ? '+ ${pkg['bonus']} هدية دعم' : ''}'),
                    trailing: ElevatedButton(
                      onPressed: () {
                        int total = pkg['coins'] + (pkg['bonus'] as int);
                        widget.onCoinsAdded(total);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('تمت إضافة $total عملة بنجاح!')),
                        );
                      },
                      child: const Text('اختيار'),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
