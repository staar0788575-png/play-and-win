import 'package:flutter/material.dart';

class FriendRequestsScreen extends StatefulWidget {
  const FriendRequestsScreen({super.key});

  @override
  State<FriendRequestsScreen> createState() => _FriendRequestsScreenState();
}

class _FriendRequestsScreenState extends State<FriendRequestsScreen> {
  // قائمة افتراضية لطلبات الصداقة الواردة
  final List<String> _friendRequests = [
    'محمد علي',
    'يوسف خالد',
    'إبراهيم محمود',
  ];

  final List<String> _friendsList = [
    'أحمد حسن',
    'سارة أحمد',
  ];

  void _acceptRequest(String name) {
    setState(() {
      _friendRequests.remove(name);
      _friendsList.add(name);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم قبول طلب الصداقة من $name')),
    );
  }

  void _rejectRequest(String name) {
    setState(() {
      _friendRequests.remove(name);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم رفض طلب الصداقة من $name')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الأصدقاء وطلبات الصداقة'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'الطلبات الواردة'),
              Tab(text: 'قائمة الأصدقاء'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // تبويب الطلبات الواردة
            _friendRequests.isEmpty
                ? const Center(child: Text('لا توجد طلبات صداقة جديدة'))
                : ListView.builder(
                    itemCount: _friendRequests.length,
                    itemBuilder: (context, index) {
                      final name = _friendRequests[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: ListTile(
                          leading: const CircleAvatar(child: Icon(Icons.person)),
                          title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.check, color: Colors.green),
                                onPressed: () => _acceptRequest(name),
                                tooltip: 'قبول',
                              ),
                              IconButton(
                                icon: const Icon(Icons.close, color: Colors.red),
                                onPressed: () => _rejectRequest(name),
                                tooltip: 'رفض',
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
            // تبويب قائمة الأصدقاء
            _friendsList.isEmpty
                ? const Center(child: Text('قائمة أصدقائك فارغة حالياً'))
                : ListView.builder(
                    itemCount: _friendsList.length,
                    itemBuilder: (context, index) {
                      final friend = _friendsList[index];
                      return ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        title: Text(friend),
                        subtitle: const Text('متصل الآن', style: TextStyle(color: Colors.green)),
                        trailing: IconButton(
                          icon: const Icon(Icons.chat, color: Colors.blue),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('فتح محادثة خاصة مع $friend')),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
