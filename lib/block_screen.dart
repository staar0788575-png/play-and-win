import 'package:flutter/material.dart';

class BlockScreen extends StatefulWidget {
  const BlockScreen({super.key});

  @override
  State<BlockScreen> createState() => _BlockScreenState();
}

class _BlockScreenState extends State<BlockScreen> {
  // قائمة افتراضية للمستخدمين المحظورين
  final List<String> _blockedUsers = [
    'مستخدم مزعج 1',
    'حساب مشبوه 2',
  ];

  void _unblockUser(String name) {
    setState(() {
      _blockedUsers.remove(name);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم إلغاء حظر $name بنجاح')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المستخدمون المحظورون'),
        centerTitle: true,
      ),
      body: _blockedUsers.isEmpty
          ? const Center(
              child: Text(
                'لا توجد قائمة حظر فارغة',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: _blockedUsers.length,
              itemBuilder: (context, index) {
                final user = _blockedUsers[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.redAccent,
                      child: Icon(Icons.block, color: Colors.white),
                    ),
                    title: Text(user, style: const TextStyle(fontWeight: FontWeight.bold)),
                    trailing: TextButton(
                      style: TextButton.styleFrom(foregroundColor: Colors.blue),
                      onPressed: () => _unblockUser(user),
                      child: const Text('إلغاء الحظر'),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
