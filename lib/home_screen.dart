import 'package:flutter/material.dart';
import 'wallet_screen.dart';
import 'social_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        // خلفية شفافة للـ AppBar ليتناسب مع الخلفية الراقية
        backgroundColor: const Color(0xFF1f1c2c).withOpacity(0.8),
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'تطبيق العب واربح',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(width: 15),
            // عداد العملات أعلى الشاشة
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.amber.withOpacity(0.5)),
              ),
              child: Row(
                children: const [
                  Text(
                    '2,500',
                    style: TextStyle(
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.monetization_on, color: Colors.amber, size: 16),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.people, color: Colors.blueAccent),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SocialScreen()),
              );
            },
            tooltip: 'المجتمع والأصدقاء',
          ),
          IconButton(
            icon: const Icon(Icons.account_balance_wallet, color: Colors.amber),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WalletScreen()),
              );
            },
            tooltip: 'المحفظة والشحن',
          ),
        ],
      ),
      // الخلفية الراقية المتدرجة تشمل الشاشة بالكامل
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1f1c2c), Color(0xFF928dab)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Card(
              color: Colors.white.withOpacity(0.1),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.white.withOpacity(0.2)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: const [
                    Icon(Icons.info_outline, color: Colors.amberAccent),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'استخدم الأيقونات في الأعلى لفتح المحفظة والشحن أو إدارة المجتمع والأصدقاء!',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              tileColor: Colors.white.withOpacity(0.06),
              leading: const Icon(Icons.games, color: Colors.blue),
              title: const Text('لعبة لودو', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              subtitle: const Text('النقاط المستحقة: 100', style: TextStyle(color: Colors.white60)),
            ),
            const SizedBox(height: 10),
            ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              tileColor: Colors.white.withOpacity(0.06),
              leading: const Icon(Icons.games, color: Colors.green),
              title: const Text('السلم والثعبان', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              subtitle: const Text('النقاط المستحقة: 150', style: TextStyle(color: Colors.white60)),
            ),
            const SizedBox(height: 10),
            ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              tileColor: Colors.white.withOpacity(0.06),
              leading: const Icon(Icons.games, color: Colors.orange),
              title: const Text('الدومينو', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              subtitle: const Text('النقاط المستحقة: 200', style: TextStyle(color: Colors.white60)),
            ),
            const SizedBox(height: 10),
            ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              tileColor: Colors.white.withOpacity(0.06),
              leading: const Icon(Icons.games, color: Colors.red),
              title: const Text('البلياردو', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              subtitle: const Text('النقاط المستحقة: 250', style: TextStyle(color: Colors.white60)),
            ),
          ],
        ),
      ),
    );
  }
}
