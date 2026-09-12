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

// 🌐 الإعدادات العامة للصوت والمحفظة
class AppSettings {
  static bool soundEnabled = true;
}

// 🏠 الشاشة الرئيسية (القائمة) مع المحفظة ونظام الشحن والشات العام وزر الترس
class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({Key? key}) : super(key: key);

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  int userCoins = 12500;
  int userLevel = 1;
  int kickValue = 200; // قيمة الطرد تبدأ من 200

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
                'متجر شحن العملات (كروت الرصيد العادي)',
                style: TextStyle(color: Colors.amberAccent, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'اشحن رصيدك حسب بلدك (مثال: 500 عملة بـ 15 جنيه)',
                style: TextStyle(color: Colors.white70, fontSize: 12),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              _buildRechargeOption('باقة 500 عملة ذهبية', '15 جنيه / يعادلها محلياً', 500),
              const SizedBox(height: 10),
              _buildRechargeOption('باقة 2000 عملة ذهبية', '50 جنيه / يعادلها محلياً', 2000),
              const SizedBox(height: 10),
              _buildRechargeOption('باقة 5000 عملة ذهبية', '100 جنيه / يعادلها محلياً', 5000),
              const SizedBox(height: 20),
            ],
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
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SwitchListTile(
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
                ],
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
              Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 4),
              Text(price, style: const TextStyle(color: Colors.greenAccent, fontSize: 12)),
            ],
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
            onPressed: () {
              setState(() {
                userCoins += coins;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('تمت إضافة $coins عملة بنجاح!', textAlign: TextAlign.right)),
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
              // 💰 شريط المحفظة والعملات والليفل وزر الإعدادات (الترس)
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
                              Text('$userCoins', style: const TextStyle(color: Colors.amberAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.purpleAccent, width: 1.5),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star, color: Colors.purpleAccent, size: 16),
                              const SizedBox(width: 4),
                              Text('Lvl $userLevel (طرد: $kickValue)', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        // زر الترس (⚙️) للإعدادات
                        IconButton(
                          icon: const Icon(Icons.settings, color: Colors.white70, size: 24),
                          onPressed: _openSettingsDialog,
                        ),
                        // زر الشات العام
                        IconButton(
                          icon: const Icon(Icons.chat, color: Colors.cyanAccent, size: 24),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const GlobalChatScreen()),
                            );
                          },
                        ),
                        // زر المتجر
                        IconButton(
                          icon: const Icon(Icons.store, color: Colors.amberAccent, size: 26),
                          onPressed: _openStore,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // قائمة الألعاب الأربع المهيكلة بالكامل
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
                      
                      // 1. Ludo Royal
                      _buildGameCard(
                        context,
                        titleEn: 'Ludo Royal',
                        subtitleAr: 'غرفة ملكية فاخرة + طائرات + مايك + شات',
                        icon: Icons.casino,
                        color: Colors.blueAccent,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LudoExactScreen()),
                          );
                        },
                      ),
                      
                      // 2. Snakes & Ladders
                      _buildGameCard(
                        context,
                        titleEn: 'Snakes & Ladders',
                        subtitleAr: 'لعبة السلم والثعبان التنافسية الهادئة',
                        icon: Icons.leaderboard,
                        color: Colors.green,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SnakesLaddersScreen()),
                          );
                        },
                      ),

                      // 3. 8 Ball Pool
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

                      // 4. Dominoes
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
        _globalMessages.add({'name': 'أنت', 'text': _controller.text.trim()});
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
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
                    ),
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

// 🎲 1. شاشة لعبة Ludo Royal الفاخرة الكاملة
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
    {'name': 'ابن الاكابر', 'text': 'مرحباً بالجميع في غرفة اللودو الملكية!'},
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
          _roomGroupMessages.add({'name': 'أنت', 'text': _chatController.text.trim()});
        }
        _chatController.clear();
      });
    }
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
                title: const Text('تشغيل أصوات النرد والألعاب', style: TextStyle(color: Colors.white, fontSize: 14)),
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
              // 🎛️ الشريط العلوي مع زر الترس
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
                        IconButton(
                          icon: const Icon(Icons.settings, color: Colors.white70, size: 20),
                          onPressed: _openSettingsDialog,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.wifi, color: Colors.greenAccent, size: 12),
                              SizedBox(width: 4),
                              Text('20ms', style: TextStyle(color: Colors.greenAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 💰 معلومات المحفظة
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                child: Row(
                  children: [
                    const Text('المحفظة: \$1,250.00', style: TextStyle(color: Colors.amberAccent, fontSize: 13, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    Text(AppSettings.soundEnabled ? '🔊 الصوت مفعل' : '🔇 الصوت صامت', style: const TextStyle(color: Colors.white54, fontSize: 11)),
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

// 🐍 2. شاشة لعبة Snakes & Ladders (السلم والثعبان) المهيكلة بالكامل
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

// 🎱 3. شاشة لعبة 8 Ball Pool (البلياردو) المهيكلة بالكامل
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

// 🀄 4. شاشة لعبة Dominoes (الدومينو) المهيكلة بالكامل
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
