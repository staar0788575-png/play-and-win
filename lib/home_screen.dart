import 'package:flutter/material.dart';
import 'wallet_screen.dart';
import 'social_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تطبيق العب واربح'),
        centerTitle: true,
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
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            color: Colors.blue[50],
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: const [
                  Icon(Icons.info_outline, color: Colors.blue),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'استخدم الأيقونات في الأعلى لفتح المحفظة والشحن أو إدارة المجتمع والأصدقاء!',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const ListTile(
            leading: Icon(Icons.games, color: Colors.blue),
            title: Text('لعبة لودو', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('النقاط المستحقة: 100'),
          ),
          const ListTile(
            leading: Icon(Icons.games, color: Colors.green),
            title: Text('السلم والثعبان', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('النقاط المستحقة: 150'),
          ),
          const ListTile(
            leading: Icon(Icons.games, color: Colors.orange),
            title: Text('الدومينو', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('النقاط المستحقة: 200'),
          ),
          const ListTile(
            leading: Icon(Icons.games, color: Colors.red),
            title: Text('البلياردو', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('النقاط المستحقة: 250'),
          ),
        ],
      ),
    );
  }
}
