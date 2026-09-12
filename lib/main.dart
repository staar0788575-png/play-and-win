import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class WalletData {
  static double balance = 1250.00;
  static void addEarnings(double amount) {
    balance += amount;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Play and Win',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF1E293B),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('العب واربح - المنصة الجماعية', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildGameButton(
              context,
              'غرفة لودو الملكية (4 لاعبين + مايك + شات + انتظار)',
              Icons.casino,
              Colors.orange,
              const LudoRoomScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameButton(BuildContext context, String title, IconData icon, Color color, Widget screen) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF334155),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color, width: 2),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 35),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 🎲 شاشة غرفة لودو المتكاملة (4 لاعبين + مايك + شات + غرفة انتظار)
class LudoRoomScreen extends StatefulWidget {
  const LudoRoomScreen({Key? key}) : super(key: key);

  @override
  State<LudoRoomScreen> createState() => _LudoRoomScreenState();
}

class _LudoRoomScreenState extends State<LudoRoomScreen> {
  int _diceValue = 6;
  int _playerPosition = 0;
  bool _isRolling = false;
  bool _isMicActive = false; // حالة المايك للدردشة الصوتية
  final TextEditingController _chatController = TextEditingController();
  final List<String> _messages = ['أحمد: أهلاً بالجميع في الغرفة!', 'محمد: بالتوفيق للجميع!'];

  void _rollDice() {
    setState(() => _isRolling = true);
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _diceValue = Random().nextInt(6) + 1;
        if (_playerPosition == 0 && _diceValue == 6) {
          _playerPosition = 1;
          WalletData.addEarnings(20);
        } else if (_playerPosition > 0) {
          _playerPosition += _diceValue;
          if (_playerPosition >= 15) {
            _playerPosition = 15;
            WalletData.addEarnings(100);
          } else {
            WalletData.addEarnings(10);
          }
        }
        _isRolling = false;
      });
    });
  }

  void _sendMessage() {
    if (_chatController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add('أنت: ${_chatController.text.trim()}');
        _chatController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('غرفة لودو - 4 لاعبين ومشاهدين', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1E293B),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          // زر المايك للدردشة الصوتية للـ 4 لاعبين
          IconButton(
            icon: Icon(_isMicActive ? Icons.mic : Icons.mic_off, color: _isMicActive ? Colors.greenAccent : Colors.white70),
            onPressed: () {
              setState(() => _isMicActive = !_isMicActive);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(_isMicActive ? 'تم فتح المايك (الدردشة الصوتية نشطة)' : 'تم إغلاق المايك')),
              );
            },
            tooltip: 'الدردشة الصوتية للاربعة لاعبين',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            // معلومات المحفظة وغرفة الانتظار
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('المشاهدون في الانتظار: 3 أصدقاء 👁️', style: TextStyle(color: Colors.cyanAccent, fontSize: 12)),
                Text('المحفظة: \$${WalletData.balance.toStringAsFixed(2)}', style: const TextStyle(color: Colors.amber, fontSize: 15, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),

            // لوحة لودو المرئية
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.orange, width: 2),
              ),
              child: Stack(
                children: [
                  Positioned(top: 8, left: 8, child: _buildBase('أحمر (أنت)', Colors.red)),
                  Positioned(top: 8, right: 8, child: _buildBase('أخضر', Colors.green)),
                  Positioned(bottom: 8, left: 8, child: _buildBase('أزرق', Colors.blue)),
                  Positioned(bottom: 8, right: 8, child: _buildBase('أصفر', Colors.amber)),
                  Center(
                    child: SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 15,
                        itemBuilder: (context, index) {
                          bool hasToken = _playerPosition == (index + 1);
                          return Container(
                            width: 28,
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            decoration: BoxDecoration(
                              color: hasToken ? Colors.red : const Color(0xFF334155),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: Text(hasToken ? '🔴' : '${index + 1}', style: TextStyle(color: Colors.white, fontSize: hasToken ? 14 : 10)),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // النرد وزر التحريك
            Row(
              children: [
                Container(
                  width: 60, height: 60,
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.orange),
                  ),
                  child: Center(child: Text(_isRolling ? '...' : '$_diceValue', style: const TextStyle(color: Colors.orange, fontSize: 26, fontWeight: FontWeight.bold))),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, minimumSize: const Size(double.infinity, 45)),
                    onPressed: _isRolling ? null : _rollDice,
                    child: Text(_isRolling ? 'جاري اللعب...' : 'ارمِ النرد وحرك القطعة', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // شات أسفل اللعبة (بين اللاعبين ومشاهدين غرفة الانتظار)
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF334155),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('💬 شات الغرفة (لاعبون + مشاهدون في الانتظار)', style: TextStyle(color: Colors.amber, fontSize: 13, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text(_messages[index], style: const TextStyle(color: Colors.white70, fontSize: 12)),
                        );
                      },
                    ),
                  ),
                  const Divider(color: Colors.white24),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _chatController,
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                          decoration: const InputDecoration(
                            hintText: 'اكتب رسالتك هنا...',
                            hintStyle: TextStyle(color: Colors.white38),
                            isDense: true,
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send, color: Colors.orange, size: 20),
                        onPressed: _sendMessage,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBase(String name, Color color) {
    return Container(
      width: 48, height: 48,
      decoration: BoxDecoration(
        color: color.withOpacity(0.3),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color),
      ),
      child: Center(child: Text(name, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
    );
  }
}
