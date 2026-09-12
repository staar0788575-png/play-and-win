import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const PlayAndWinApp());
}

class PlayAndWinApp extends StatelessWidget {
  const PlayAndWinApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Play and Win Pro Max',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        fontFamily: 'Roboto',
      ),
      home: const MainMenuScreen(),
    );
  }
}

class AppSettings {
  static int userCoins = 25000;
  static int totalRecharged = 5000;
  static int freeRoses = 10;

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
  static List<String> friendsList = ['أحمد إبراهيم', 'محمود', 'يوسف'];
  static List<String> friendRequests = ['سارة علي', 'خالد مصطفى'];
}

class RoomHeaderWidget extends StatelessWidget {
  final String roomTitle;
  const RoomHeaderWidget({Key? key, required this.roomTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        border: const Border(bottom: BorderSide(color: Colors.amberAccent, width: 1)),
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
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: Colors.amber.withOpacity(0.2), borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.amber, width: 1)),
                child: const Text('👑 غرفة مقفولة ومؤمنة VIP', style: TextStyle(color: Colors.amber, fontSize: 9, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 6),
              const Text('👁️ 2.8k', style: TextStyle(color: Colors.white70, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }
}

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
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('متجر العملات وشحن الـ VIP', style: TextStyle(color: Colors.amberAccent, fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              _buildRechargeOption('باقة 500 عملة', '15 جنيه', 500),
              const SizedBox(height: 8),
              _buildRechargeOption('باقة 2000 عملة (VIP 1)', '50 جنيه', 2000),
              const SizedBox(height: 8),
              _buildRechargeOption('باقة 5000 عملة (VIP 2)', '100 جنيه', 5000),
              const SizedBox(height: 8),
              _buildRechargeOption('باقة 10000 عملة (VIP 3 ألماسي)', '200 جنيه', 10000),
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
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return DefaultTabController(
          length: 3,
          child: Container(
            height: 350,
            padding: const EdgeInsets.all(12),
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
                            title: Text(friend, style: const TextStyle(color: Colors.white, fontSize: 13)),
                            trailing: IconButton(
                              icon: const Icon(Icons.block, color: Colors.redAccent, size: 18),
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
                            title: Text(req, style: const TextStyle(color: Colors.white, fontSize: 13)),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.check, color: Colors.greenAccent, size: 18),
                                  onPressed: () {
                                    setState(() {
                                      GlobalSocialData.friendRequests.remove(req);
                                      GlobalSocialData.friendsList.add(req);
                                    });
                                    Navigator.pop(context);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close, color: Colors.redAccent, size: 18),
                                  onPressed: () {
                                    setState(() => GlobalSocialData.friendRequests.remove(req));
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
                            title: Text(blocked, style: const TextStyle(color: Colors.redAccent, fontSize: 13)),
                            trailing: TextButton(
                              child: const Text('إلغاء الحظر', style: TextStyle(color: Colors.cyanAccent, fontSize: 11)),
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

  Widget _buildRechargeOption(String title, String price, int coins) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
              const SizedBox(height: 2),
              Text(price, style: const TextStyle(color: Colors.greenAccent, fontSize: 11)),
            ],
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6)),
            onPressed: () {
              setState(() {
                AppSettings.userCoins += coins;
                AppSettings.totalRecharged += coins;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تم الشحن بنجاح! رتبتك الحالية: ${AppSettings.getVipTitle()}')));
            },
            child: const Text('شحن', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12)),
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
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.amber, width: 1.2),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.monetization_on, color: Colors.amber, size: 14),
                              const SizedBox(width: 3),
                              Text('${AppSettings.userCoins}', style: const TextStyle(color: Colors.amberAccent, fontSize: 11, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppSettings.getVipColor(), width: 1.2),
                          ),
                          child: Text(AppSettings.getVipTitle(), style: TextStyle(color: AppSettings.getVipColor(), fontSize: 9, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(icon: const Icon(Icons.people, color: Colors.greenAccent, size: 20), onPressed: _openSocialHub),
                        IconButton(icon: const Icon(Icons.chat, color: Colors.cyanAccent, size: 20), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const GlobalChatScreen()))),
                        IconButton(icon: const Icon(Icons.store, color: Colors.amberAccent, size: 20), onPressed: _openStore),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: ListView(
                    children: [
                      const Text('اختر اللعبة للبدء والتحدي:', style: TextStyle(color: Colors.amberAccent, fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      
                      CardWidget(
                        titleEn: 'Ludo Royal (4 Players)',
                        subtitleAr: 'لودو 4 لاعبين والطيارات والمربعات الآمنة والجراج',
                        icon: Icons.casino,
                        color: Colors.blueAccent,
                        targetScreen: const LudoCompleteScreen(),
                      ),
                      
                      CardWidget(
                        titleEn: 'Snakes & Ladders',
                        subtitleAr: 'لعبة السلم والثعبان والنرد الحقيقي',
                        icon: Icons.leaderboard,
                        color: Colors.green,
                        targetScreen: const SnakesLaddersCompleteScreen(),
                      ),

                      CardWidget(
                        titleEn: '8 Ball Pool',
                        subtitleAr: 'تحدي البلياردو والفتحات وقوة التسديد بدقة',
                        icon: Icons.sports_bar,
                        color: Colors.orange,
                        targetScreen: const PoolCompleteScreen(),
                      ),

                      CardWidget(
                        titleEn: 'Dominoes',
                        subtitleAr: 'لعبة الدومينو الأرقام والمكعبات الحقيقية',
                        icon: Icons.extension,
                        color: Colors.purple,
                        targetScreen: const DominoesCompleteScreen(),
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
}

class CardWidget extends StatelessWidget {
  final String titleEn;
  final String subtitleAr;
  final IconData icon;
  final Color color;
  final Widget targetScreen;

  const CardWidget({
    Key? key,
    required this.titleEn,
    required this.subtitleAr,
    required this.icon,
    required this.color,
    required this.targetScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.6), width: 1.2),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: color.withOpacity(0.2), shape: BoxShape.circle),
          child: Icon(icon, color: color, size: 22),
        ),
        title: Text(titleEn, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitleAr, style: const TextStyle(color: Colors.white70, fontSize: 10)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 14),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => targetScreen)),
      ),
    );
  }
}

class GlobalChatScreen extends StatefulWidget {
  const GlobalChatScreen({Key? key}) : super(key: key);

  @override
  State<GlobalChatScreen> createState() => _GlobalChatScreenState();
}

class _GlobalChatScreenState extends State<GlobalChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [
    {'name': 'أحمد إبراهيم', 'text': 'مرحباً بكم في التطبيق الشامل!'},
  ];

  void _sendMessage() {
    if (_controller.text.trim().isNotEmpty) {
      setState(() {
        _messages.add({'name': 'أنت', 'text': _controller.text.trim()});
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الدردشة العامة', style: TextStyle(color: Colors.amberAccent, fontSize: 16)),
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
                padding: const EdgeInsets.all(10),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 3),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.06), borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(msg['name']!, style: const TextStyle(color: Colors.cyanAccent, fontSize: 11, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 2),
                        Text(msg['text']!, style: const TextStyle(color: Colors.white, fontSize: 13)),
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              color: const Color(0xFF0F172A),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      decoration: const InputDecoration(hintText: 'اكتب رسالة...', hintStyle: TextStyle(color: Colors.white38), border: InputBorder.none),
                    ),
                  ),
                  IconButton(icon: const Icon(Icons.send, color: Colors.cyanAccent, size: 20), onPressed: _sendMessage),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 1. LUDO COMPLETE GAME SCREEN (4 Players, Planes, Dice control, Garage, Safe spots)
class LudoCompleteScreen extends StatefulWidget {
  const LudoCompleteScreen({Key? key}) : super(key: key);

  @override
  State<LudoCompleteScreen> createState() => _LudoCompleteScreenState();
}

class _LudoCompleteScreenState extends State<LudoCompleteScreen> {
  int _diceValue = 6;
  bool _isRolling = false;
  bool _isMicActive = false;
  
  // 4 Players token positions (0 = in garage/base, 1 to 50 = path, 52 = final home garage)
  final List<int> _playerTokens = [0, 0, 0, 0];
  int _activePlayerIndex = 0;
  bool _isSafeSpot = false;

  final TextEditingController _chatController = TextEditingController();
  final List<Map<String, String>> _roomMessages = [
    {'name': 'المضيف', 'text': 'أهلاً بكم في غرفة اللودو الملكية لـ 4 لاعبين!'}
  ];

  void _rollDiceForLudo() {
    setState(() => _isRolling = true);
    Future.delayed(const Duration(milliseconds: 400), () {
      setState(() {
        _diceValue = Random().nextInt(6) + 1;
        _isRolling = false;

        int currentPos = _playerTokens[_activePlayerIndex];

        if (currentPos == 0) {
          if (_diceValue == 6) {
            _playerTokens[_activePlayerIndex] = 1; // Exit garage
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('اللاعب ${_activePlayerIndex + 1} رمى 6 وخرجت طيارته من الجراج!')));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('اللاعب ${_activePlayerIndex + 1} يحتاج لرمي 6 للخروج من الجراج!')));
          }
        } else {
          currentPos += _diceValue;
          if (currentPos >= 52) {
            _playerTokens[_activePlayerIndex] = 52;
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تهانينا! طائرة اللاعب ${_activePlayerIndex + 1} وصلت لجراجها النهائي بنجاح!')));
          } else {
            _playerTokens[_activePlayerIndex] = currentPos;
            _isSafeSpot = (currentPos % 8 == 0); // Safe spots check
          }
        }

        // Switch to next player
        _activePlayerIndex = (_activePlayerIndex + 1) % 4;
      });
    });
  }

  void _sendRoomMsg() {
    if (_chatController.text.trim().isNotEmpty) {
      setState(() {
        _roomMessages.add({'name': 'أنت', 'text': _chatController.text.trim()});
        _chatController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFF3B82F6), Color(0xFF1E1B4B), Color(0xFF0F172A)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const RoomHeaderWidget(roomTitle: 'غرفة لودو 4 لاعبين والطيارات والجراج'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(onTap: () => Navigator.pop(context), child: const Icon(Icons.arrow_back, color: Colors.white, size: 18)),
                    Row(
                      children: [
                        Text('دور اللاعب: ${_activePlayerIndex + 1}', style: const TextStyle(color: Colors.amberAccent, fontSize: 11, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.local_florist, color: Colors.pinkAccent, size: 18),
                          onPressed: () {
                            if (AppSettings.freeRoses > 0) {
                              setState(() => AppSettings.freeRoses--);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تم إرسال وردة للمضيف! المتبقي: ${AppSettings.freeRoses}')));
                            }
                          },
                        ),
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
                      margin: const EdgeInsets.all(6),
                      decoration: BoxDecoration(color: const Color(0xFF1E1B4B), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.blueAccent, width: 1.5)),
                      child: Stack(
                        children: [
                          Positioned(top: 6, left: 6, child: _buildPlaneBase('أخضر (1)', Colors.green, _playerTokens[0])),
                          Positioned(top: 6, right: 6, child: _buildPlaneBase('أصفر (2)', Colors.amber, _playerTokens[1])),
                          Positioned(bottom: 6, left: 6, child: _buildPlaneBase('أحمر (3)', Colors.red, _playerTokens[2])),
                          Positioned(bottom: 6, right: 6, child: _buildPlaneBase('أزرق (4)', Colors.blue, _playerTokens[3])),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (_isSafeSpot)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(color: Colors.cyan.withOpacity(0.3), borderRadius: BorderRadius.circular(4)),
                                    child: const Text('🛡️ منطقة آمنة تماماً', style: TextStyle(color: Colors.cyanAccent, fontSize: 9, fontWeight: FontWeight.bold)),
                                  ),
                                const SizedBox(height: 4),
                                GestureDetector(
                                  onTap: _isRolling ? null : _rollDiceForLudo,
                                  child: Container(
                                    width: 55, height: 55,
                                    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red[700], border: Border.all(color: Colors.greenAccent, width: 2.5)),
                                    child: Center(child: Text(_isRolling ? '...' : '$_diceValue', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))),
                                  ),
                                ),
                              ],
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
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(color: Color(0xFF0F172A), borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: _roomMessages.length,
                          itemBuilder: (context, index) {
                            final m = _roomMessages[index];
                            return Text('${m['name']}: ${m['text']}', style: const TextStyle(color: Colors.white70, fontSize: 10));
                          },
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _chatController,
                              style: const TextStyle(color: Colors.white, fontSize: 11),
                              decoration: const InputDecoration(hintText: 'اكتب رسالة الغرفة...', hintStyle: TextStyle(color: Colors.white38), border: InputBorder.none),
                            ),
                          ),
                          IconButton(icon: Icon(_isMicActive ? Icons.mic : Icons.mic_off, color: _isMicActive ? Colors.greenAccent : Colors.white, size: 16), onPressed: () => setState(() => _isMicActive = !_isMicActive)),
                          IconButton(icon: const Icon(Icons.send, color: Colors.cyanAccent, size: 16), onPressed: _sendRoomMsg),
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

  Widget _buildPlaneBase(String name, Color color, int pos) {
    return Container(
      width: 52, height: 52,
      decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(8), border: Border.all(color: color, width: 1.5)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.airplanemode_active, color: color, size: 18),
          const SizedBox(height: 2),
          Text('موقع: $pos', style: TextStyle(color: color, fontSize: 8, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// 2. SNAKES AND LADDERS COMPLETE GAME SCREEN
class SnakesLaddersCompleteScreen extends StatefulWidget {
  const SnakesLaddersCompleteScreen({Key? key}) : super(key: key);

  @override
  State<SnakesLaddersCompleteScreen> createState() => _SnakesLaddersCompleteScreenState();
}

class _SnakesLaddersCompleteScreenState extends State<SnakesLaddersCompleteScreen> {
  int playerPos = 1;
  int diceVal = 1;
  bool rolling = false;
  String actionLog = 'اضغط لرمي النرد والتحرك عبر المربعات!';

  final Map<int, int> snakesAndLaddersMap = {
    3: 22,   // سلم صعود
    11: 28,  // سلم صعود
    20: 45,  // سلم صعود
    36: 72,  // سلم صعود
    48: 80,  // سلم صعود
    27: 5,   // ثعبان نزول
    54: 31,  // ثعبان نزول
    66: 42,  // ثعبان نزول
    88: 50,  // ثعبان نزول
  };

  void rollDice() {
    setState(() => rolling = true);
    Future.delayed(const Duration(milliseconds: 400), () {
      setState(() {
        diceVal = Random().nextInt(6) + 1;
        int nextPos = playerPos + diceVal;
        if (nextPos > 100) nextPos = 100;

        if (snakesAndLaddersMap.containsKey(nextPos)) {
          int destination = snakesAndLaddersMap[nextPos]!;
          if (destination > nextPos) {
            actionLog = 'ممتاز! صعدت سلماً من $nextPos إلى $destination!';
          } else {
            actionLog = 'عفواً! أكلت ثعبان وهبطت من $nextPos إلى $destination!';
          }
          playerPos = destination;
        } else {
          playerPos = nextPos;
          actionLog = 'تقدمت وتحركت إلى المربع $playerPos';
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
              const RoomHeaderWidget(roomTitle: 'غرفة السلم والثعبان والنرد الحقيقي'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(onTap: () => Navigator.pop(context), child: const Icon(Icons.arrow_back, color: Colors.white, size: 18)),
                    Text(actionLog, style: const TextStyle(color: Colors.greenAccent, fontSize: 11, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(color: const Color(0xFF01211A), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.greenAccent, width: 1.5)),
                  child: GridView.builder(
                    itemCount: 100,
                    reverse: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 10, crossAxisSpacing: 1.5, mainAxisSpacing: 1.5),
                    itemBuilder: (context, index) {
                      int sqNum = index + 1;
                      bool isHere = (sqNum == playerPos);
                      bool hasLadder = snakesAndLaddersMap.containsKey(sqNum) && snakesAndLaddersMap[sqNum]! > sqNum;
                      bool hasSnake = snakesAndLaddersMap.containsKey(sqNum) && snakesAndLaddersMap[sqNum]! < sqNum;

                      Color boxColor = Colors.white.withOpacity(0.06);
                      if (hasLadder) boxColor = Colors.blue.withOpacity(0.3);
                      if (hasSnake) boxColor = Colors.red.withOpacity(0.3);
                      if (isHere) boxColor = Colors.amber;

                      return Container(
                        decoration: BoxDecoration(color: boxColor, borderRadius: BorderRadius.circular(2)),
                        child: Center(
                          child: Text(
                            isHere ? '🧑' : (hasLadder ? '📈' : (hasSnake ? '🐍' : '$sqNum')),
                            style: TextStyle(color: isHere ? Colors.black : Colors.white70, fontSize: isHere ? 10 : 7, fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, minimumSize: const Size(160, 36)),
                  onPressed: rolling ? null : rollDice,
                  child: Text(rolling ? 'جاري رمي النرد...' : 'رمي النرد ($diceVal)', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 3. 8 BALL POOL COMPLETE GAME SCREEN (Cue stick, Power and Holes)
class PoolCompleteScreen extends StatefulWidget {
  const PoolCompleteScreen({Key? key}) : super(key: key);

  @override
  State<PoolCompleteScreen> createState() => _PoolCompleteScreenState();
}

class _PoolCompleteScreenState extends State<PoolCompleteScreen> {
  bool shotInProgress = false;
  double cuePower = 60.0;
  String poolStatus = 'اضبط قوة العصا ووجه الكرة البيضاء لفتحة الطاولة!';
  int pocketedGoals = 0;

  void shootCueBall() {
    setState(() {
      shotInProgress = true;
      if (cuePower > 70) {
        pocketedGoals++;
        poolStatus = 'تسديدة قوية ومحترفة! دخلت الكرة في الفتحة الركنية بنجاح 🎯';
      } else if (cuePower > 40) {
        poolStatus = 'تسديدة متوسطة اصطدمت بالحافة ولم تنزل!';
      } else {
        poolStatus = 'القوة ضعيفة للغاية ولم تتحرك الكرة بالشكل المطلوب!';
      }
    });
    Future.delayed(const Duration(seconds: 1), () => setState(() => shotInProgress = false));
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
              const RoomHeaderWidget(roomTitle: 'تحدي البلياردو والفتحات وقوة العصا'),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(onTap: () => Navigator.pop(context), child: const Icon(Icons.arrow_back, color: Colors.white, size: 18)),
                    Text('الأهداف الناجحة: $pocketedGoals', style: const TextStyle(color: Colors.amberAccent, fontSize: 11, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: Container(
                    width: 300, height: 170,
                    decoration: BoxDecoration(color: const Color(0xFF065F46), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.amber, width: 4)),
                    child: Stack(
                      children: [
                        const Positioned(top: 4, left: 4, child: CircleAvatar(radius: 8, backgroundColor: Colors.black)),
                        const Positioned(top: 4, right: 4, child: CircleAvatar(radius: 8, backgroundColor: Colors.black)),
                        const Positioned(bottom: 4, left: 4, child: CircleAvatar(radius: 8, backgroundColor: Colors.black)),
                        const Positioned(bottom: 4, right: 4, child: CircleAvatar(radius: 8, backgroundColor: Colors.black)),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(width: 16, height: 16, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                              const SizedBox(height: 8),
                              Text(poolStatus, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Text('مقياس قوة التسديد: ${cuePower.toInt()}%', style: const TextStyle(color: Colors.orangeAccent, fontSize: 11)),
                    Slider(value: cuePower, min: 10, max: 100, activeColor: Colors.orangeAccent, onChanged: (v) => setState(() => cuePower = v)),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8)),
                      onPressed: shotInProgress ? null : shootCueBall,
                      child: const Text('تسديد العصا الآن', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
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

// 4. DOMINOES COMPLETE GAME SCREEN (Real Domino pieces & numbers)
class DominoesCompleteScreen extends StatefulWidget {
  const DominoesCompleteScreen({Key? key}) : super(key: key);

  @override
  State<DominoesCompleteScreen> createState() => _DominoesCompleteScreenState();
}

class _DominoesCompleteScreenState extends State<DominoesCompleteScreen> {
  String dominoStatus = 'اختر قطعة دومينو متطابقة للوضع على الطاولة';
  final List<String> tablePiecesList = ['[ 6 | 6 ]', '[ 6 | 3 ]', '[ 3 | 4 ]'];

  void placeDominoPiece(String piece) {
    setState(() {
      tablePiecesList.add(piece);
      dominoStatus = 'تم وضع القطعة $piece على الطاولة بنجاح!';
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
              const RoomHeaderWidget(roomTitle: 'غرفة الدومينو بالأرقام ومكعبات الطاولة'),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(children: [GestureDetector(onTap: () => Navigator.pop(context), child: const Icon(Icons.arrow_back, color: Colors.white, size: 18))]),
              ),
              Expanded(
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: const Color(0xFF2E1065).withOpacity(0.6), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.purpleAccent, width: 1.5)),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: tablePiecesList.map((p) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
                          child: Text(p, style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold)),
                        )).toList(),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Text(dominoStatus, style: const TextStyle(color: Colors.white70, fontSize: 11)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.purpleAccent),
                          onPressed: () => placeDominoPiece('[ 4 | 2 ]'),
                          child: const Text('[ 4 | 2 ]', style: TextStyle(color: Colors.white, fontSize: 12)),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.purpleAccent),
                          onPressed: () => placeDominoPiece('[ 3 | 5 ]'),
                          child: const Text('[ 3 | 5 ]', style: TextStyle(color: Colors.white, fontSize: 12)),
                        ),
                      ],
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
