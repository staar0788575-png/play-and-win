8import 'package:flutter/material.dart';
import 'dart:math';

/*
  =============================================================================
  اسم المشروع: تطبيق Play and Win الملكي (كامل متكامل)
  أوامر البناء والنشر على GitHub Pages:
  1. للتجربة محلياً:
     flutter run -d chrome
  2. لأمر البناء للويب (مع استبدال "play-and-win" باسم مستودعك على جيت هاب):
     flutter build web --release --base-href "/play-and-win/"
  =============================================================================
*/

void main() {
  runApp(const PlayAndWinApp());
}

class PlayAndWinApp extends StatelessWidget {
  const PlayAndWinApp({Key? key}) : super(key: key);

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
  static int totalRecharged = 0; 
  static int freeRoses = 5; 

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

class GlobalSocialData {
  static List<String> blockedUsers = [];
  static List<String> friendsList = ['أحمد إبراهيم', 'محمود'];
  static List<String> friendRequests = ['سارة علي', 'خالد مصطفى'];
}

// 👑 نموذج غرفة المشاهدة العلنية الموحد لأعلى الشاشة في كل الألعاب
class SpectatorHeaderWidget extends StatelessWidget {
  final String roomTitle;
  const SpectatorHeaderWidget({Key? key, required this.roomTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        border: const Border(bottom: BorderSide(color: Colors.amberAccent, width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.live_tv, color: Colors.redAccent, size: 16),
              const SizedBox(width: 6),
              Text(roomTitle, style: const TextStyle(color: Colors.amberAccent, fontSize: 11, fontWeight: FontWeight.bold)),
            ],
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(color: Colors.amber.withOpacity(0.2), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.amber, width: 1)),
                child: const Text('👑 ملك الغرفة', style: TextStyle(color: Colors.amber, fontSize: 9, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(color: Colors.cyan.withOpacity(0.2), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.cyanAccent, width: 1)),
                child: const Text('🎙️ المتحدث', style: TextStyle(color: Colors.cyanAccent, fontSize: 9, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 6),
              const Text('👁️ 1.2k', style: TextStyle(color: Colors.white70, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }
}

// 🏠 الشاشة الرئيسية (القائمة)
class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({Key? key}) : super(key: key);

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  void _openStore() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0F172A),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('متجر شحن العملات وترقية الـ VIP', style: TextStyle(color: Colors.amberAccent, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text('كلما شحنت أكثر زاد مستواك وحصلت على لوجو VIP مميز!', style: TextStyle(color: Colors.white70, fontSize: 12), textAlign: TextAlign.center),
              const SizedBox(height: 20),
              _buildRechargeOption('باقة 500 عملة', '15 جنيه', 500),
              const SizedBox(height: 10),
              _buildRechargeOption('باقة 2000 عملة (ترقية VIP 1)', '50 جنيه', 2000),
              const SizedBox(height: 10),
              _buildRechargeOption('باقة 5000 عملة (ترقية VIP 2)', '100 جنيه', 5000),
              const SizedBox(height: 10),
              _buildRechargeOption('باقة 10000 عملة (ترقية VIP 3 ألماسي)', '200 جنيه', 10000),
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
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
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
                  tabs: [Tab(text: 'الأصدقاء'), Tab(text: 'الطلبات'), Tab(text: 'المحظورون')],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
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
                              },
                            ),
                          );
                        },
                      ),
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
                        IconButton(icon: const Icon(Icons.people, color: Colors.greenAccent, size: 24), onPressed: _openSocialHub, tooltip: 'الأصدقاء والحظر'),
                        IconButton(icon: const Icon(Icons.settings, color: Colors.white70, size: 22), onPressed: _openSettingsDialog),
                        IconButton(icon: const Icon(Icons.chat, color: Colors.cyanAccent, size: 22), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const GlobalChatScreen()))),
                        IconButton(icon: const Icon(Icons.store, color: Colors.amberAccent, size: 24), onPressed: _openStore),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ListView(
                    children: [
                      const Text('اختر اللعبة للبدء:', style: TextStyle(color: Colors.amberAccent, fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 15),
                      _buildGameCard(context, 'Ludo Royal', 'غرفة ملكية فاخرة + طائرات + مايك + شات + ورد وهدايا', Icons.casino, Colors.blueAccent, const LudoExactScreen()),
                      _buildGameCard(context, 'Snakes & Ladders', 'لعبة السلم والثعبان التنافسية بمربعات حقيقية', Icons.leaderboard, Colors.green, const SnakesLaddersScreen()),
                      _buildGameCard(context, '8 Ball Pool', 'تحدي البلياردو الواقعي مع طاولة حقيقية وعصا تفاعلية', Icons.sports_bar, Colors.orange, const PoolGameScreen()),
                      _buildGameCard(context, 'Dominoes', 'لعبة الدومينو الكلاسيكية الاستراتيجية وقطع الطاولة', Icons.extension, Colors.purple, const DominoesGameScreen()),
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

  Widget _buildGameCard(BuildContext context, {required String titleEn, required String subtitleAr, required IconData icon, required Color color, required Widget targetScreen}) {
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
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => targetScreen)),
      ),
    );
  }
}

// 💬 شاشة الشات العام
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
          gradient: LinearGradient(colors: [Color(0xFF1E1B4B), Color(0xFF0F172A)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: _globalMessages.length,
                itemBuilder: (context, index) {
                  final msg = _globalMessages[index];
                  if (GlobalSocialData.blockedUsers.contains(msg['name'])) return const SizedBox.shrink();
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.06), borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(msg['name']!, style: const TextStyle(color: Colors.cyanAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(msg['text']!, style: const TextStyle(color: Colors.white, fontSize: 14)),
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
                      decoration: const InputDecoration(hintText: 'اكتب رسالتك للجميع...', hintStyle: TextStyle(color: Colors.white38), border: InputBorder.none),
                    ),
                  ),
                  IconButton(icon: const Icon(Icons.send, color: Colors.cyanAccent), onPressed: _sendGlobalMessage),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 🎲 1. شاشة Ludo Royal متكاملة
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

  void _sendFreeRose() {
    if (AppSettings.freeRoses > 0) {
      setState(() => AppSettings.freeRoses--);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تم إرسال وردة مجانية! المتبقي اليوم: ${AppSettings.freeRoses}')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('نفدت الوردات المجانية الـ 5 اليومية!')));
    }
  }

  void _openGiftsModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0F172A),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('متجر الهدايا القيمة', style: TextStyle(color: Colors.amberAccent, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              _buildGiftItem('☕ فنجان قهوة', 10),
              const SizedBox(height: 8),
              _buildGiftItem('🚗 سيارة رياضية', 500),
              const SizedBox(height: 8),
              _buildGiftItem('🏰 قصر ملكي', 5000),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGiftItem(String name, int cost) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.08), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.purpleAccent.withOpacity(0.5))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.purpleAccent),
            onPressed: () {
              if (AppSettings.userCoins >= cost) {
                setState(() => AppSettings.userCoins -= cost);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تم إرسال ($name) بتكلفة $cost عملة!')));
              } else {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('رصيدك لا يكفي!')));
              }
            },
            child: Text('إرسال ($cost)', style: const TextStyle(color: Colors.white, fontSize: 11)),
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
          gradient: LinearGradient(colors: [Color(0xFF3B82F6), Color(0xFF1E1B4B), Color(0xFF0F172A)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SpectatorHeaderWidget(roomTitle: 'غرفة لودو رويال الملكية'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(onTap: () => Navigator.pop(context), child: const Icon(Icons.arrow_back, color: Colors.white, size: 20)),
                    Row(
                      children: [
                        IconButton(icon: const Icon(Icons.local_florist, color: Colors.pinkAccent, size: 20), onPressed: _sendFreeRose, tooltip: 'وردة مجانية'),
                        IconButton(icon: const Icon(Icons.card_giftcard, color: Colors.amberAccent, size: 20), onPressed: _openGiftsModal, tooltip: 'هدايا'),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 5,
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: const Color(0xFF1E1B4B), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.blueAccent, width: 2)),
                      child: Stack(
                        children: [
                          Positioned(top: 8, left: 8, child: _buildBigBaseHouse(Colors.green)),
                          Positioned(top: 8, right: 8, child: _buildBigBaseHouse(Colors.amber)),
                          Positioned(bottom: 8, left: 8, child: _buildBigBaseHouse(Colors.red)),
                          Positioned(bottom: 8, right: 8, child: _buildBigBaseHouse(Colors.blue)),
                          Center(
                            child: GestureDetector(
                              onTap: _isRolling ? null : _rollDice,
                              child: Container(
                                width: 80, height: 80,
                                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red[700], border: Border.all(color: Colors.greenAccent, width: 4)),
                                child: Center(child: Text(_isRolling ? '...' : '$_diceValue', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold))),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(color: Color(0xFF0F172A), borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ChoiceChip(label: const Text('شات جماعي', style: TextStyle(fontSize: 10)), selected: !_isPrivateChat, onSelected: (val) => setState(() => _isPrivateChat = false)),
                          const SizedBox(width: 8),
                          ChoiceChip(label: const Text('شات خاص', style: TextStyle(fontSize: 10)), selected: _isPrivateChat, onSelected: (val) => setState(() => _isPrivateChat = true)),
                        ],
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: currentMessages.length,
                          itemBuilder: (context, index) {
                            final msg = currentMessages[index];
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
                              decoration: const InputDecoration(hintText: 'اكتب رسالتك...', hintStyle: TextStyle(color: Colors.white38), border: InputBorder.none),
                            ),
                          ),
                          IconButton(icon: Icon(_isMicActive ? Icons.mic : Icons.mic_off, color: _isMicActive ? Colors.greenAccent : Colors.white, size: 18), onPressed: () => setState(() => _isMicActive = !_isMicActive)),
                          IconButton(icon: const Icon(Icons.send_rounded, color: Colors.cyanAccent, size: 18), onPressed: _sendMessage),
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

  Widget _buildBigBaseHouse(Color color) {
    return Container(
      width: 65, height: 65,
      decoration: BoxDecoration(color: color.withOpacity(0.25), borderRadius: BorderRadius.circular(10), border: Border.all(color: color, width: 2)),
      child: Center(
        child: Wrap(
          spacing: 2, runSpacing: 2, alignment: WrapAlignment.center,
          children: List.generate(4, (index) => Container(
            width: 18, height: 18,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: const Center(child: Icon(Icons.airplanemode_active, color: Colors.white, size: 10)),
          )),
        ),
      ),
    );
  }
}

// 🐍 2. شاشة Snakes & Ladders متكاملة
class SnakesLaddersScreen extends StatefulWidget {
  const SnakesLaddersScreen({Key? key}) : super(key: key);

  @override
  State<SnakesLaddersScreen> createState() => _SnakesLaddersScreenState();
}

class _SnakesLaddersScreenState extends State<SnakesLaddersScreen> {
  int playerPos = 1;
  int diceVal = 1;
  bool rolling = false;

  final Map<int, int> snakesAndLadders = {
    3: 22, 11: 28, 20: 45, 36: 72, 48: 80, 61: 95, 
    27: 5, 54: 31, 66: 42, 89: 50, 98: 12 
  };

  void rollTheDice() {
    setState(() => rolling = true);
    Future.delayed(const Duration(milliseconds: 400), () {
      setState(() {
        diceVal = Random().nextInt(6) + 1;
        playerPos += diceVal;
        if (playerPos > 100) playerPos = 100;
        if (snakesAndLadders.containsKey(playerPos)) {
          playerPos = snakesAndLadders[playerPos]!;
        }
        rolling = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFF022C22), Color(0xFF064E3B), Color(0xFF0F172A)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SpectatorHeaderWidget(roomTitle: 'غرفة السلم والثعبان التنافسية'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  children: [
                    GestureDetector(onTap: () => Navigator.pop(context), child: const Icon(Icons.arrow_back, color: Colors.white, size: 20)),
                    const SizedBox(width: 12),
                    Text('موقعك: مربع ($playerPos)', style: const TextStyle(color: Colors.greenAccent, fontSize: 13, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(color: const Color(0xFF01211A), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.greenAccent, width: 2)),
                  child: GridView.builder(
                    itemCount: 100,
                    reverse: true,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 10, crossAxisSpacing: 2, mainAxisSpacing: 2),
                    itemBuilder: (context, index) {
                      int sqNum = index + 1;
                      bool isHere = (sqNum == playerPos);
                      bool isLadder = snakesAndLadders.containsKey(sqNum) && snakesAndLadders[sqNum]! > sqNum;
                      bool isSnake = snakesAndLadders.containsKey(sqNum) && snakesAndLadders[sqNum]! < sqNum;

                      Color boxCol = Colors.white.withOpacity(0.06);
                      if (isHere) boxCol = Colors.amber;
                      else if (isLadder) boxCol = Colors.greenAccent.withOpacity(0.4);
                      else if (isSnake) boxCol = Colors.redAccent.withOpacity(0.4);

                      return Container(
                        decoration: BoxDecoration(color: boxCol, borderRadius: BorderRadius.circular(3)),
                        child: Center(
                          child: Text(
                            isHere ? '🧑‍🦱' : '$sqNum',
                            style: TextStyle(color: isHere ? Colors.black : Colors.white70, fontSize: isHere ? 13 : 9, fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, minimumSize: const Size(200, 42)),
                  onPressed: rolling ? null : rollTheDice,
                  child: Text(rolling ? 'جاري الرمي...' : 'رمي النرد ($diceVal)', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 🎱 3. شاشة 8 Ball Pool متكاملة
class PoolGameScreen extends StatefulWidget {
  const PoolGameScreen({Key? key}) : super(key: key);

  @override
  State<PoolGameScreen> createState() => _PoolGameScreenState();
}

class _PoolGameScreenState extends State<PoolGameScreen> {
  bool shotTaken = false;
  double power = 50.0;
  String message = 'وجّه العصا واضبط القوة لتسديد الكرة البيضاء!';

  void shootCue() {
    setState(() {
      shotTaken = true;
      message = 'تمت التسديدة بقوة ${power.toInt()}% بنجاح!';
    });
    Future.delayed(const Duration(seconds: 2), () {
      setState(() => shotTaken = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFF451A03), Color(0xFF7C2D12), Color(0xFF0F172A)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SpectatorHeaderWidget(roomTitle: 'غرفة البلياردو الملكية'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  children: [
                    GestureDetector(onTap: () => Navigator.pop(context), child: const Icon(Icons.arrow_back, color: Colors.white, size: 20)),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: Container(
                    width: 320, height: 190,
                    decoration: BoxDecoration(
                      color: const Color(0xFF065F46),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.amber, width: 6),
                    ),
                    child: Stack(
                      children: [
                        Positioned(top: 4, left: 4, child: _buildPocket()),
                        Positioned(top: 4, right: 4, child: _buildPocket()),
                        Positioned(bottom: 4, left: 4, child: _buildPocket()),
                        Positioned(bottom: 4, right: 4, child: _buildPocket()),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(width: 16, height: 16, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                              const SizedBox(height: 8),
                              Text(message, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text('قوة التسديد: ${power.toInt()}%', style: const TextStyle(color: Colors.orangeAccent, fontSize: 12)),
                    Slider(value: power, min: 10, max: 100, activeColor: Colors.orangeAccent, onChanged: (val) => setState(() => power = val)),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                      icon: const Icon(Icons.sports_bar, color: Colors.white, size: 18),
                      label: const Text('تسديد الكرة الآن', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      onPressed: shotTaken ? null : shootCue,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPocket() {
    return Container(width: 14, height: 14, decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle));
  }
}

// 🀄 4. شاشة Dominoes متكاملة
class DominoesGameScreen extends StatefulWidget {
  const DominoesGameScreen({Key? key}) : super(key: key);

  @override
  State<DominoesGameScreen> createState() => _DominoesGameScreenState();
}

class _DominoesGameScreenState extends State<DominoesGameScreen> {
  String status = 'دورك للعب قطعة الدومينو المناسبة';
  final List<String> tablePieces = ['[ 6 | 6 ]', '[ 6 | 3 ]'];

  void playPiece() {
    setState(() {
      tablePieces.add('[ 3 | 1 ]');
      status = 'تم وضع القطعة [ 3 | 1 ] على الطاولة!';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFF3B0764), Color(0xFF581C87), Color(0xFF0F172A)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SpectatorHeaderWidget(roomTitle: 'غرفة الدومينو الاستراتيجية'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  children: [
                    GestureDetector(onTap: () => Navigator.pop(context), child: const Icon(Icons.arrow_back, color: Colors.white, size: 20)),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E1065).withOpacity(0.6),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.purpleAccent, width: 2),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: tablePieces.map((piece) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                        child: Text(piece, style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
                      )).toList(),
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(status, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.purpleAccent),
                      onPressed: playPiece,
                      child: const Text('لعب قطعة جديدة على الطاولة', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
