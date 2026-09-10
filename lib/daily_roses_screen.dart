import 'package:flutter/material.dart';

class DailyRosesScreen extends StatefulWidget {
  final Function(int) onClaimRoses;

  const DailyRosesScreen({super.key, required this.onClaimRoses});

  @override
  State<DailyRosesScreen> createState() => _DailyRosesScreenState();
}

class _DailyRosesScreenState extends State<DailyRosesScreen> {
  bool _isClaimedToday = false;

  void _claimDailyGift() {
    if (_isClaimedToday) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لقد استلمت ورودك اليومية بالفعل، عُد غداً!')),
      );
      return;
    }

    setState(() {
      _isClaimedToday = true;
    });

    // منح المستخدم 10 ورود مجانية يومياً
    widget.onClaimRoses(10);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('مبروك! تم إضافة 10 ورود يومية إلى حسابك بنجاح.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الورود اليومية المجانية'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.local_florist, size: 100, color: Colors.pink),
              const SizedBox(height: 20),
              const Text(
                'هدية الورود اليومية تتجدد كل 24 ساعة!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'احصل الآن على ورودك المجانية لدعم أصدقائك والغرف.',
                style: TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isClaimedToday ? Colors.grey : Colors.pink,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: _isClaimedToday ? null : _claimDailyGift,
                icon: const Icon(Icons.card_giftcard),
                label: Text(
                  _isClaimedToday ? 'تم الاستلام اليوم' : 'استلم 10 ورود الآن',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
