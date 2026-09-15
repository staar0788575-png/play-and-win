import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'wallet_provider.dart';

class SocialScreen extends StatefulWidget {
  const SocialScreen({Key? key}) : super(key: key);

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _chatController = TextEditingController();
  final TextEditingController _privateChatController = TextEditingController();
  
  final List<String> _messages = [
    "مرحباً بالجميع في غرفة الدردشة العامة!",
    "من يقبل تحدي لعبة لودو الآن؟",
  ];

  final List<Map<String, String>> _privateChats = [
    {"name": "أحمد", "lastMessage": "أين أنت؟ لنبدأ مباراة البلياردو"},
    {"name": "محمد", "lastMessage": "شكراً على وردة اليوم!"},
    {"name": "خالد", "lastMessage": "تم قبول طلب الصداقة"},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _chatController.dispose();
    _privateChatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final walletProvider = Provider.of<WalletProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('المجتمع والأصدقاء'),
        backgroundColor: const Color(0xFFff1fc2),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.amber,
          tabs: const [
            Tab(icon: Icon(Icons.chat), text: 'الدردشة العامة'),
            Tab(icon: Icon(Icons.lock), text: 'الدردشة الخاصة'),
            Tab(icon: Icon(Icons.card_giftcard), text: 'الورود والهدايا'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 1. تبويب الدردشة العامة
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(_messages[index], style: const TextStyle(fontSize: 16)),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                color: Colors.grey[200],
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _chatController,
                        decoration: const InputDecoration(
                          hintText: 'اكتب رسالتك في الغرفة العامة...',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send, color: Color(0xFFff1fc2)),
                      onPressed: () {
                        if (_chatController.text.trim().isNotEmpty) {
                          setState(() {
                            _messages.add(_chatController.text.trim());
                            _chatController.clear();
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),

          // 2. تبويب الدردشة الخاصة (الرسائل بين الأصدقاء)
          ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _privateChats.length,
            itemBuilder: (context, index) {
              final chat = _privateChats[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.pink.withOpacity(0.2),
                    child: Text(chat["name"]![0], style: const TextStyle(color: Colors.pink, fontWeight: FontWeight.bold)),
                  ),
                  title: Text(chat["name"]!, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(chat["lastMessage"]!),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  onTap: () {
                    // فتح نافذة المحادثة الخاصة
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('فتح المحادثة الخاصة مع ${chat["name"]}')),
                    );
                  },
                ),
              );
            },
          ),

          // 3. تبويب الورود والهدايا اليومية
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.local_florist, size: 80, color: Colors.pink),
                const SizedBox(height: 16),
                Text(
                  'الورود اليومية المتاحة: ${walletProvider.dailyRoses}',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  onPressed: () {
                    bool success = walletProvider.useRose();
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('🌹 تم إرسال وردة بنجاح!')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('⚠️ عذراً، لقد نفدت وردك اليومية!')),
                      );
                    }
                  },
                  icon: const Icon(Icons.card_giftcard, color: Colors.white),
                  label: const Text('إرسال وردة الآن', style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
