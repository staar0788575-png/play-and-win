// ====================================================================
// (Main Lobby Screen) - الشاشة الرئيسية المحدثة لتطبيق العب واربح 🎮
// تحتوي على الألعاب الأربع، شريط الـ VIP، بحث الأيدي، زر الشات العام، وترس الإعدادات
// ====================================================================

import 'package:flutter/material.dart';
import 'game_social_bar.dart'; // استيراد شريط الميزات الاجتماعية والـ VIP

class MainLobbyScreen extends StatefulWidget {
  const MainLobbyScreen({Key? key}) : super(key: key);

  @override
  State<MainLobbyScreen> createState() => _MainLobbyScreenState();
}

class _MainLobbyScreenState extends State<MainLobbyScreen> {
  // وحدة تحكم حقل البحث بالأيدي
  final TextEditingController _playerIdController = TextEditingController();

  // نافذة البحث بالـ ID
  void _openPlayerIdSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF172A45),
          title: const Text('بحث عن لاعب بالـ ID 🔍', style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _playerIdController,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'أدخل رقم الأيدي الخاص باللاعب...',
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.black26,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: Border.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                onPressed: () {
                  String playerId = _playerIdController.text.trim();
                  if (playerId.isNotEmpty) {
                    Navigator.of(context).pop();
                    debugPrint("جاري البحث عن اللاعب رقم: $playerId");
                    // أضف هنا كود استعلام الـ Firebase للبحث عن اللاعب
                  }
                },
                child: const Text('بحث الآن', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      },
    );
  }

  // نافذة الدردشة العامة (Global Chat)
  void _openGlobalChatDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF172A45),
          title: const Text('💬 الدردشة العامة للتطبيق', style: TextStyle(color: Colors.white)),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const ListView(
                      children: [
                        Text('مدحت: أهلاً بالجميع في تطبيق العب واربح!', style: TextStyle(color: Colors.white70)),
                        Text('سارة: منقذ التحدي في لعبة اللودو؟', style: TextStyle(color: Colors.amberAccent)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'اكتب رسالة عامة...',
                          hintStyle: const TextStyle(color: Colors.white54),
                          filled: true,
                          fillColor: Colors.black38,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: Border.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.send, color: Colors.amber),
                      onPressed: () {
                        debugPrint("تم إرسال الرسالة في الشات العام");
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // نافذة الإعدادات (ترس الإعدادات ⚙️)
  void _openSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF172A45),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('إعدادات التطبيق ⚙️', style: TextStyle(color: Colors.white)),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white54),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.volume_up, color: Colors.amber),
                title: const Text('الصوت والموسيقى', style: TextStyle(color: Colors.white70)),
                trailing: Switch(
                  value: true,
                  onChanged: (val) {},
                  activeColor: Colors.amber,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.notifications, color: Colors.amber),
                title: const Text('الإشعارات والورود', style: TextStyle(color: Colors.white70)),
                trailing: Switch(
                  value: true,
                  onChanged: (val) {},
                  activeColor: Colors.amber,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎮 العب واربح - الرئيسية', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF0F0F19),
        actions: [
          // 🔍 زر البحث بالأيدي
          IconButton(
            icon: const Icon(Icons.person_search, color: Colors.amberAccent),
            tooltip: 'بحث بالـ ID',
            onPressed: () => _openPlayerIdSearchDialog(context),
          ),
          // 💬 زر الدردشة العامة
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline, color: Colors.amberAccent),
            tooltip: 'الدردشة العامة',
            onPressed: () => _openGlobalChatDialog(context),
          ),
          // ⚙️ زر ترس الإعدادات
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.amberAccent),
            tooltip: 'الإعدادات',
            onPressed: () => _openSettingsDialog(context),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F0F19), Color(0xFF172A45)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // 🌟 شريط الـ VIP والورود اليومية
            GameSocialBar(
              isVip: true,
              dailyFlowersCount: 10,
              onMicToggle: (isMicOn) {
                debugPrint(isMicOn ? "تم فتح المايك العام" : "تم كتم المايك العام");
              },
              onSendGift: () {
                debugPrint("تم فتح متجر الهدايا والورود اليومية");
              },
            ),

            const Padding(
              padding: EdgeInsets.all(12.0),
              TText(
                'اختر لعبتك المفضلة وابدأ التحدي:',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),

            // شبكة الألعاب الأربع
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.all(16),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildGameCard(context, title: 'لعبة البلياردو 🎱', color: Colors.green[800]!, icon: Icons.sports_bar, onTap: () {}),
                  _buildGameCard(context, title: 'لعبة الدومينو 🀄', color: Colors.brown[800]!, icon: Icons.casino, onTap: () {}),
                  _buildGameCard(context, title: 'لعبة لودو 🎲', color: Colors.indigo[800]!, icon: Icons.extension, onTap: () {}),
                  _buildGameCard(context, title: 'السلم والثعبان 🐍', color: Colors.blue[800]!, icon: Icons.ladder, onTap: () {}),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameCard(BuildContext context, {required String title, required Color color, required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.amberAccent, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.amberAccent),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
