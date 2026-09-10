import 'package:flutter/material.dart';

class VipScreen extends StatefulWidget {
  const VipScreen({super.key});

  @override
  State<VipScreen> createState() => _VipScreenState();
}

class _VipScreenState extends State<VipScreen> {
  bool _isVipActive = false;

  void _subscribeVip() {
    setState(() {
      _isVipActive = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('مبروك! تم تفعيل اشتراك الـ VIP بنجاح وتميز حسابك.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('عضوية الـ VIP المميزة'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.workspace_premium, size: 100, color: Colors.amber),
            const SizedBox(height: 16),
            const Text(
              'ارتقِ بتجربتك واحصل على صلاحيات الملكية والتميز!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: const [
                    ListTile(
                      leading: Icon(Icons.star, color: Colors.amber),
                      title: Text('إطار ذهبي متحرك وصارخ داخل الغرف'),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.flash_on, color: Colors.orange),
                      title: Text('دخول مميز ومرئي عند دخولك لأي غرفة'),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.card_giftcard, color: Colors.pink),
                      title: Text('خصم خاص بنسبة 20% على جميع الهدايا'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber[700],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _isVipActive ? null : _subscribeVip,
                child: Text(
                  _isVipActive ? 'عضوية VIP مفعلة حالياً' : 'اشترك في VIP الآن',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
