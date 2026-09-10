import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تطبيق العب واربح'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          ListTile(
            leading: Icon(Icons.games, color: Colors.blue),
            title: Text('لعبة لودو', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('النقاط المستحقة: 100'),
          ),
          ListTile(
            leading: Icon(Icons.games, color: Colors.green),
            title: Text('السلم والثعبان', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('النقاط المستحقة: 150'),
          ),
          ListTile(
            leading: Icon(Icons.games, color: Colors.orange),
            title: Text('الدومينو', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('النقاط المستحقة: 200'),
          ),
          ListTile(
            leading: Icon(Icons.games, color: Colors.red),
            title: Text('البلياردو', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('النقاط المستحقة: 250'),
          ),
        ],
      ),
    );
  }
}
