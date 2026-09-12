import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Play and Win',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF1E1B4B),
        fontFamily: 'Roboto',
      ),
      home: const MainMenuScreen(),
    );
  }
}

// 🌐 الإعدادات العامة ونظام المستخدم (VIP، الشحن، الورد اليومي، الحظر، والأصدقاء)
class AppSettings {
  static bool soundEnabled = true;
  static int userCoins = 12500;
  static int totalRecharged = 0; // إجمالي ما تم شحنه لتحديد الـ VIP واللوجو
  static int freeRoses = 5; // 5 وردات مجانية يومياً

  // نظام الـ VIP واللوجو بناءً على إجمالي الشحن
  static String getVipTitle() {
    if (totalRecharged >= 10000) return 'VIP 3 (ألماسي 💎)';
    if (totalRecharged >= 5000) return 'VIP 2 (ذهبي 👑)';
    if (totalRecharged >= 1000) return 'VIP 1 (فضي ⭐)';
    return 'مستخدم عادي';
  }

  static Color getVipColor() {
    if (totalRecharged >= 10000) return Colors.cyanAccent;
    if (totalRecharged >= 5000) return Colors.amberAccent;
    if (totalRecharged >= 1000) return Colors.purpleAccent;
    return Colors.white70;
  }
}

// قائمة المستخدمين المحظورين والأصدقاء العامين
class GlobalSocialData {
  static List<String> blockedUsers = [];
  static List<String> friendsList = ['أحمد إبراهيم', 'محمود'];
  static List<String> friendRequests = ['سارة علي', 'خالد مصطفى'];
}

// 🏠 الشاشة الرئيسية (القائمة) مع المحفظة ونظام الشحن والـ VIP
class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({Key? key}) : super(key: key);

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  int userLevel = 1;
  int kickValue = 200;

  void _openStore() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0F172A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'متجر شحن العملات وترقية الـ VIP',
                style: TextStyle(color: Colors.amberAccent, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'كلما شحنت أكثر زاد مستواك وحصلت على لوجو VIP مميز!',
                style: TextStyle(color: Colors.white70, fontSize: 12),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              _buildRechargeOption('باقة 500 عملة', '15 جنيه', 500),
              const SizedBox(height: 10),
              _buildRechargeOption('باقة 2000 عملة (ترقية VIP 1)', '50 جنيه', 2000),
              const SizedBox(height: 10),
              _buildRechargeOption('باقة 5000 عملة (ترقية VIP 2)', '100 جنيه', 5000),
              const SizedBox(height: 10),
              _buildRechargeOption('باقة 10000 عملة (ترقية VIP 3 ألماسي)', '200 جنيه', 10000),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _openSocialHub() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0F172A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DefaultTabController(
          length: 3,
          child: Container(
            height: 400,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const TabBar(
                  labelColor: Colors.amberAccent,
                  unselectedLabelColor: Colors.white60,
                  indicatorColor: Colors.amberAccent,
                  tabs: [
                    Tab(text: 'الأصدقاء'),
                    Tab(text: 'الطلبات'),
                    Tab(text: 'المحظورون'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      // قائمة الأصدقاء
                      ListView.builder(
                        itemCount: GlobalSocialData.friendsList.length,
                        itemBuilder: (context, index) {
                          final friend = GlobalSocialData.friendsList[index];
                          return ListTile(
                            title: Text(friend, style: const TextStyle(color: Colors.white)),
                            trailing: IconButton(
                              icon: const Icon(Icons.block, color: Colors.redAccent, size: 20),
                              onPressed: () {
                                setState(() {
                                  GlobalSocialData.friendsList.remove(friend);
                                  GlobalSocialData.blockedUsers.add(friend);
                                });
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('تم حظر المستخدم $friend بنجاح')),
                                );
                              },
                            ),
                          );
                        },
                      ),
                      // طلبات الصداقة
                      ListView.builder(
                        itemCount: GlobalSocialData.friendRequests.length,
                        itemBuilder: (context, index) {
                          final req = GlobalSocialData.friendRequests[index];
                          return ListTile(
                            title: Text(req, style: const TextStyle(color: Colors.white)),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.check, color: Colors.greenAccent),
                                  onPressed: () {
                                    setState(() {
                                      GlobalSocialData.friendRequests.remove(req);
                                      GlobalSocialData.friendsList.add(req);
                                    });
                                    Navigator.pop(context);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close, color: Colors.redAccent),
                                  onPressed: () {
                                    setState(() {
                                      GlobalSocialData.friendRequests.remove(req);
                                    });
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      // قائمة المحظورين
                      ListView.builder(
                        itemCount: GlobalSocialData.blockedUsers.length,
                        itemBuilder: (context, index) {
                          final blocked = GlobalSocialData.blockedUsers[index];
                          return ListTile(
                            title: Text(blocked, style: const TextStyle(color: Colors.redAccent)),
                            trailing: TextButton(
                              child: const Text('إلغاء الحظر', style: TextStyle(color: Colors.cyanAccent)),
                              onPressed: () {
                                setState(() {
                                  GlobalSocialData.blockedUsers.remove(blocked);
                                  GlobalSocialData.friendsList.add(blocked);
                                });
                                Navigator.pop(context);
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF0F172A),
              title: const Text('إعدادات اللعبة', style: TextStyle(color: Colors.amberAccent)),
              content: SwitchListTile(
                title: const Text('تشغيل أصوات الألعاب والمؤثرات', style: TextStyle(color: Colors.white, fontSize: 14)),
                value: AppSettings.soundEnabled,
                activeColor: Colors.cyanAccent,
                onChanged: (val) {
                  setDialogState(() {
                    AppSettings.soundEnabled = val;
                  });
                  setState(() {});
                },
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('إغلاق', style: TextStyle(color: Colors.cyanAccent)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildRechargeOption(String title, String price, int coins) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.amber.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 4),
              Text(price, style: const TextStyle(color: Colors.greenAccent, fontSize: 12)),
            ],
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
            onPressed: () {
              setState(() {
                AppSettings.userCoins += coins;
                AppSettings.totalRecharged += coins;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('تم الشحن بنجاح! رتبة الـ VIP الحالية: ${AppSettings.getVipTitle()}')),
              );
            },
            child: const Text('شحن', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3B82F6), Color(0xFF1E1B4B), Color(0xFF0F172A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // شريط المحفظة والـ VIP واللوجو والأزرار
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.amber, width: 1.5),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.monetization_on, color: Colors.amber, size: 16),
                              const SizedBox(width: 4),
                              Text('${AppSettings.userCoins}', style: const TextStyle(color: Colors.amberAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppSettings.getVipColor(), width: 1.5),
                          ),
                          child: Text(
                            AppSettings.getVipTitle(),
                            style: TextStyle(color: AppSettings.getVipColor(), fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.people, color: Colors.greenAccent, size: 24),
                          onPressed: _openSocialHub,
                          tooltip: 'الأصدقاء والحظر',
                        ),
                        IconButton(
                          icon: const Icon(Icons.settings, color: Colors.white70, size: 22),
                          onPressed: _openSettingsDialog,
                        ),
                        IconButton(
                          icon: const Icon(Icons.chat, color: Colors.cyanAccent, size: 22),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const GlobalChatScreen()),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.store, color: Colors.amberAccent, size: 24),
                          onPressed: _openStore,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // الألعاب الأربع
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ListView(
                    children: [
                      const Text(
                        'اختر اللعبة للبدء:',
                        style: TextStyle(color: Colors.amberAccent, fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.right,
                      ),
                      const SizedBox(height: 15),
                      _buildGameCard(
                        context,
                        titleEn: 'Ludo Royal',
                        subtitleAr: 'غرفة ملكية فاخرة + طائرات + مايك + شات + ورد وهدايا',
                        icon: Icons.casino,
                        color: Colors.blueAccent,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LudoExactScreen()),
                          );
                        },
                      ),
                      _buildGameCard(
                        context,
                        titleEn: 'Snakes & Ladders',
                        subtitleAr: 'لعبة السلم والثعبان التنافسية',
                        icon: Icons.leaderboard,
                        color: Colors.green,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SnakesLaddersScreen()),
                          );
                        },
                      ),
                      _buildGameCard(
                        context,
                        titleEn: '8 Ball Pool',
                        subtitleAr: 'تحدي البلياردو الواقعي والمهاري',
                        icon: Icons.sports_bar,
                        color: Colors.orange,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const PoolGameScreen()),
                          );
                        },
                      ),
                      _buildGameCard(
                        context,
                        titleEn: 'Dominoes',
                        subtitleAr: 'لعبة الدومينو الكلاسيكية الاستراتيجية',
                        icon: Icons.extension,
                        color: Colors.purple,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const DominoesGameScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameCard(BuildContext context, {required String titleEn, required String subtitleAr, required IconData icon, required Color color, required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.6), width: 1.5),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: color.withOpacity(0.2), shape: BoxShape.circle),
          child: Icon(icon, color: color, size: 26),
        ),
        title: Text(titleEn, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitleAr, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
        onTap: onTap,
      ),
    );
  }
}

// 💬 شاشة الشات العام مع حظر المستخدمين
class GlobalChatScreen extends StatefulWidget {
  const GlobalChatScreen({Key? key}) : super(key: key);

  @override
  State<GlobalChatScreen> createState() => _GlobalChatScreenState();
}

class _GlobalChatScreenState extends State<GlobalChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _globalMessages = [
    {'name': 'أحمد إبراهيم', 'text': 'أهلاً بالجميع في تطبيق Play and Win!'},
    {'name': 'محمود', 'text': 'من يوافقني في دور لودو الآن؟'},
  ];

  void _sendGlobalMessage() {
    if (_controller.text.trim().isNotEmpty) {
      setState(() {
        _globalMessages.add({'name': 'أنت (${AppSettings.getVipTitle()})', 'text': _controller.text.trim()});
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الدردشة الجماعية العامة', style: TextStyle(color: Colors.amberAccent)),
        backgroundColor: const Color(0xFF0F172A),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1E1B4B), Color(0xFF0F172A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: _globalMessages.length,
                itemBuilder: (context, index) {
                  final msg = _globalMessages[index];
                  if (GlobalSocialData.blockedUsers.contains(msg['name'])) {
                    return const SizedBox.shrink(); // إخفاء رسائل المحظورين
                  }
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(msg['name']!, style: const TextStyle(color: Colors.cyanAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text(msg['text']!, style: const TextStyle(color: Colors.white, fontSize: 14)),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.block, color: Colors.white38, size: 16),
                          onPressed: () {
                            setState(() {
                              GlobalSocialData.blockedUsers.add(msg['name']!);
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('تم حظر المستخدم وإخفاء رسائله')),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              color: const Color(0xFF0F172A),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'اكتب رسالتك للجميع هنا...',
                        hintStyle: TextStyle(color: Colors.white38),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.cyanAccent),
                    onPressed: _sendGlobalMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 🎲 1. شاشة Ludo Royal مع نظام الورد المجاني والهدايا المتدرجة (10 إلى 5000 عملة)
class LudoExactScreen extends StatefulWidget {
  const LudoExactScreen({Key? key}) : super(key: key);

  @override
  State<LudoExactScreen> createState() => _LudoExactScreenState();
}

class _LudoExactScreenState extends State<LudoExactScreen> {
  int _diceValue = 6;
  bool _isRolling = false;
  bool _isMicActive = false;
  bool _isPrivateChat = false;
  
  final TextEditingController _chatController = TextEditingController();
  final List<Map<String, String>> _roomGroupMessages = [
    {'name': 'ابن الاكابر (VIP 2)', 'text': 'مرحباً بالجميع في غرفة اللودو الملكية!'},
  ];
  final List<Map<String, String>> _roomPrivateMessages = [
    {'name': 'صديقي (خاص)', 'text': 'هل نلعب كفريق؟'},
  ];

  void _rollDice() {
    setState(() => _isRolling = true);
    Future.delayed(const Duration(milliseconds: 400), () {
      setState(() {
        _diceValue = Random().nextInt(6) + 1;
        _isRolling = false;
      });
    });
  }

  void _sendMessage() {
    if (_chatController.text.trim().isNotEmpty) {
      setState(() {
        if (_isPrivateChat) {
          _roomPrivateMessages.add({'name': 'أنت (خاص)', 'text': _chatController.text.trim()});
        } else {
          _roomGroupMessages.add({'name': 'أنت (${AppSettings.getVipTitle()})', 'text': _chatController.text.trim()});
        }
        _chatController.clear();
      });
    }
  }

  // 🌹 ميزة الورد المجاني (5 وردات تتجدد يومياً)
  void _sendFreeRose() {
    if (AppSettings.freeRoses > 0) {
      setState(() {
        AppSettings.freeRoses--;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم إرسال وردة مجانية بنجاح! المتبقي اليوم: ${AppSettings.freeRoses} وردات')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لقد استنفذت الوردات المجانية الـ 5 اليومية! تتجدد غداً')),
      );
    }
  }

  // 🎁 متجر الهدايا القيمة (من 10 عملات إلى 5000 عملة)
  void _openGiftsModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0F172A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'متجر الهدايا القيمة',
                style: TextStyle(color: Colors.amberAccent, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'أرسل هدايا مذهلة للاعبين داخل الغرفة',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const SizedBox(height: 20),
              _buildGiftItem('☕ فنجان قهوة أنيق', 10),
              const SizedBox(height: 8),
              _buildGiftItem('🚗 سيارة رياضية', 500),
              const SizedBox(height: 8),
              _buildGiftItem('🏰 قصر ملكي فاخر', 5000),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGiftItem(String name, int cost) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purpleAccent.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.purpleAccent),
            onPressed: () {
              if (AppSettings.userCoins >= cost) {
                setState(() {
                  AppSettings.userCoins -= cost;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('تم إرسال هدية ($name) بتكلفة $cost عملة بنجاح!')),
                );
              } else {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('رصيدك من العملات لا يكفي لشراء هذه الهدية!')),
                );
              }
            },
            child: Text('إرسال ($cost عملة)', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentMessages = _isPrivateChat ? _roomPrivateMessages : _roomGroupMessages;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3B82F6), Color(0xFF1E1B4B), Color(0xFF0F172A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // الشريط العلوي مع إرسال الورد والهدايا
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.arrow_back, color: Colors.white, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Text(AppSettings.getVipTitle(), style: TextStyle(color: AppSettings.getVipColor(), fontSize: 11, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Row(
                      children: [
                        // زر الورد المجاني
                        IconButton(
                          icon: const Icon(Icons.local_florist, color: Colors.pinkAccent, size: 22),
                          onPressed: _sendFreeRose,
                          tooltip: 'إرسال وردة مجانية (${AppSettings.freeRoses} متبقية)',
                        ),
                        // زر متجر الهدايا
                        IconButton(
                          icon: const Icon(Icons.card_giftcard, color: Colors.amberAccent, size: 22),
                          onPressed: _openGiftsModal,
                          tooltip: 'هدايا قيمة',
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // لوحة لودو المركزية
              Expanded(
                flex: 5,
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1B4B),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.blueAccent.withOpacity(0.6), width: 3),
                      ),
                      child: Stack(
                        children: [
                          Positioned(top: 8, left: 8, child: _buildBigBaseHouse(Colors.green, true)),
                          Positioned(top: 8, right: 8, child: _buildBigBaseHouse(Colors.amber, true)),
                          Positioned(bottom: 8, left: 8, child: _buildBigBaseHouse(Colors.red, true)),
                          Positioned(bottom: 8, right: 8, child: _buildBigBaseHouse(Colors.blue, true)),
                          Center(
                            child: GestureDetector(
                              onTap: _isRolling ? null : _rollDice,
                              child: Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFFEF4444), Color(0xFFB91C1C)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  border: Border.all(color: const Color(0xFF4ADE80), width: 7),
                                ),
                                child: Center(
                                  child: Text(
                                    _isRolling ? '$_diceValue' : 'اضغط',
                                    style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // صندوق الشات والمايك
              Expanded(
                flex: 4,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(12, 6, 12, 8),
                  decoration: const BoxDecoration(
                    color: Color(0xFF0F172A),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ChoiceChip(
                            label: const Text('شات جماعي', style: TextStyle(fontSize: 11)),
                            selected: !_isPrivateChat,
                            onSelected: (val) => setState(() => _isPrivateChat = false),
                            selectedColor: Colors.cyan,
                            backgroundColor: Colors.white10,
                            labelStyle: TextStyle(color: !_isPrivateChat ? Colors.black : Colors.white),
                          ),
                          const SizedBox(width: 10),
                          ChoiceChip(
                            label: const Text('شات خاص', style: TextStyle(fontSize: 11)),
                            selected: _isPrivateChat,
                            onSelected: (val) => setState(() => _isPrivateChat = true),
                            selectedColor: Colors.purpleAccent,
                            backgroundColor: Colors.white10,
                            labelStyle: TextStyle(color: _isPrivateChat ? Colors.white : Colors.white70),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Expanded(
                        child: ListView.builder(
                          itemCount: currentMessages.length,
                          itemBuilder: (context, index) {
                            final msg = currentMessages[index];
                            if (GlobalSocialData.blockedUsers.contains(msg['name'])) {
                              return const SizedBox.shrink();
                            }
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 2),
                              child: Row(
                                children: [
                                  Text('${msg['name']}: ', style: const TextStyle(color: Colors.cyanAccent, fontSize: 11, fontWeight: FontWeight.bold)),
                                  Expanded(child: Text(msg['text']!, style: const TextStyle(color: Colors.white70, fontSize: 11))),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _chatController,
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                              decoration: const InputDecoration(
                                hintText: 'اكتب رسالتك...',
                                hintStyle: TextStyle(color: Colors.white38),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(_isMicActive ? Icons.mic : Icons.mic_off, color: _isMicActive ? Colors.greenAccent : Colors.white70, size: 20),
                            onPressed: () => setState(() => _isMicActive = !_isMicActive),
                          ),
                          IconButton(
                            icon: const Icon(Icons.send_rounded, color: Colors.cyanAccent, size: 20),
                            onPressed: _sendMessage,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBigBaseHouse(Color color, bool hasAirplanes) {
    return Container(
      width: 74,
      height: 74,
      decoration: BoxDecoration(
        color: color.withOpacity(0.25),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 2),
      ),
      child: Center(
        child: hasAirplanes
            ? Wrap(
                spacing: 4,
                runSpacing: 4,
                alignment: WrapAlignment.center,
                children: List.generate(4, (index) => Container(
                  width: 22, height: 22,
                  decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                  child: const Center(child: Icon(Icons.airplanemode_active, color: Colors.white, size: 12)),
                )),
              )
            : Icon(Icons.airplanemode_active, color: color, size: 26),
      ),
    );
  }
}

// 🐍 2. شاشة Snakes & Ladders
class SnakesLaddersScreen extends StatefulWidget {
  const SnakesLaddersScreen({Key? key}) : super(key: key);

  @override
  State<SnakesLaddersScreen> createState() => _SnakesLaddersScreenState();
}

class _SnakesLaddersScreenState extends State<SnakesLaddersScreen> {
  int playerPos = 1;
  int diceVal = 1;
  bool rolling = false;

  void rollTheDice() {
    setState(() => rolling = true);
    Future.delayed(const Duration(milliseconds: 400), () {
      setState(() {
        diceVal = Random().nextInt(6) + 1;
        playerPos += diceVal;
        if (playerPos > 100) playerPos = 100;
        rolling = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Snakes & Ladders (السلم والثعبان)', style: TextStyle(color: Colors.greenAccent, fontSize: 16)),
        backgroundColor: const Color(0xFF0F172A),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF064E3B), Color(0xFF022C22), Color(0xFF0F172A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('موقعك الحالي على اللوحة: مربع رقم $playerPos', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.greenAccent, width: 2),
              ),
              child: Column(
                children: [
                  const Text('رمية النرد الهادئة', style: TextStyle(color: Colors.greenAccent, fontSize: 14)),
                  const SizedBox(height: 10),
                  Text(rolling ? '...' : '$diceVal', style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: rolling ? null : rollTheDice,
                    child: const Text('رمي النرد والتقدم', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 🎱 3. شاشة 8 Ball Pool
class PoolGameScreen extends StatefulWidget {
  const PoolGameScreen({Key? key}) : super(key: key);

  @override
  State<PoolGameScreen> createState() => _PoolGameScreenState();
}

class _PoolGameScreenState extends State<PoolGameScreen> {
  bool shotTaken = false;
  String message = 'اضغط لتوجيه العصا وضرب الكرة البيضاء بدقة!';

  void shootCue() {
    setState(() {
      shotTaken = true;
      message = 'تمت ضربة البلياردو بنجاح! أسقطت الكرة في الحفرة!';
    });
    Future.delayed(const Duration(seconds: 2), () {
      setState(() => shotTaken = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('8 Ball Pool (تحدي البلياردو)', style: TextStyle(color: Colors.orangeAccent, fontSize: 16)),
        backgroundColor: const Color(0xFF0F172A),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF7C2D12), Color(0xFF451A03), Color(0xFF0F172A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 300,
                height: 180,
                decoration: BoxDecoration(
                  color: const Color(0xFF065F46),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.amber, width: 4),
                ),
                child: Center(
                  child: Text(message, style: const TextStyle(color: Colors.white, fontSize: 13), textAlign: TextAlign.center),
                ),
              ),
              const SizedBox(height: 25),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                icon: const Icon(Icons.sports_bar, color: Colors.white),
                label: const Text('ضرب الكرة الآن', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                onPressed: shotTaken ? null : shootCue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 🀄 4. شاشة Dominoes
class DominoesGameScreen extends StatefulWidget {
  const DominoesGameScreen({Key? key}) : super(key: key);

  @override
  State<DominoesGameScreen> createState() => _DominoesGameScreenState();
}

class _DominoesGameScreenState extends State<DominoesGameScreen> {
  String status = 'دورك للعب قطعة الدومينو المناسبة';

  void playDominoPiece() {
    setState(() {
      status = 'تم وضع القطعة [6|6] على الطاولة بنجاح!';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dominoes (لعبة الدومينو)', style: TextStyle(color: Colors.purpleAccent, fontSize: 16)),
        backgroundColor: const Color(0xFF0F172A),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF581C87), Color(0xFF3B0764), Color(0xFF0F172A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 10)],
                ),
                child: const Text('[ 6 | 6 ]', style: TextStyle(color: Colors.black, fontSize: 28, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 20),
              Text(status, style: const TextStyle(color: Colors.white70, fontSize: 14)),
              const SizedBox(height: 25),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.purpleAccent),
                onPressed: playDominoPiece,
                child: const Text('وضع القطعة على الطاولة', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
