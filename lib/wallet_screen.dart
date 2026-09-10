import 'package:flutter/material.dart';
import 'wallet_provider.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final WalletProvider _walletProvider = WalletProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المحفظة والشحن'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // بطاقة الرصيد والورد
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Icon(Icons.monetization_on, color: Colors.amber, size: 36),
                        const SizedBox(height: 8),
                        const Text('العملات الذهبية', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('${_walletProvider.coins}', style: const TextStyle(fontSize: 18, color: Colors.green)),
                      ],
                    ),
                    Column(
                      children: [
                        const Icon(Icons.local_florist, color: Colors.pink, size: 36),
                        const SizedBox(height: 8),
                        const Text('الورد اليومي', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('${_walletProvider.dailyRoses} / 10', style: const TextStyle(fontSize: 18, color: Colors.pink)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'اختر باقة الشحن المناسبة (16 جنيه = 500 عملة):',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            // أزرار باقات الشحن
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[700], foregroundColor: Colors.white),
              onPressed: () {
                setState(() {
                  _walletProvider.rechargeWallet(16);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم شحن 500 عملة بنجاح!')),
                );
              },
              icon: const Icon(Icons.payment),
              label: const Text('شحن 16 جنيه (500 عملة)'),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[800], foregroundColor: Colors.white),
              onPressed: () {
                setState(() {
                  _walletProvider.rechargeWallet(80);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم شحن 80 جنيه + مكافأة بنجاح!')),
                );
              },
              icon: const Icon(Icons.payment),
              label: const Text('شحن 80 جنيه (مع مكافأة 10%)'),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber[800], foregroundColor: Colors.white),
              onPressed: () {
                setState(() {
                  _walletProvider.rechargeWallet(160);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم شحن 160 جنيه + مكافأة كبرى بنجاح!')),
                );
              },
              icon: const Icon(Icons.star),
              label: const Text('شحن 160 جنيه (مع مكافأة 20% كبرى)'),
            ),
          ],
        ),
      ),
    );
  }
}
