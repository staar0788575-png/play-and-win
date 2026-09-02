import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const PlayAndWinApp());
}

class PlayAndWinApp extends StatelessWidget {
  const PlayAndWinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'العب واربح',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        primaryColor: const Color(0xFF6366F1),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.dark,
          secondary: const Color(0xFFF59E0B),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.sports_esports, color: Color(0xFFF59E0B), size: 28),
            SizedBox(width: 10),
            Text(
              'العب واربح',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white70),
            onPressed: () {
              _showSettingsModal(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4F46E5), Color(0xFF9333EA)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4F46E5).withOpacity(0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'رصيدك الحالي',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '0 نقطة',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Color(0xFFF59E0B),
                    child: Icon(Icons.monetization_on, color: Colors.white, size: 30),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              'الألعاب المتاحة',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 15),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 1.1,
              children: [
                // زر لعبة لودو مرتبطة مباشرة
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LudoGameScreen()),
                    );
                  },
                  child: const GameCard(title: 'لعبة لودو', icon: Icons.casino, color: Colors.redAccent),
                ),
                const GameCard(title: 'بلياردو', icon: Icons.sports_bar, color: Colors.blueAccent),
                // زر لعبة السلم والثعبان المرتبطة مسبقاً
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SnakesAndLaddersGame()),
                    );
                  },
                  child: const GameCard(title: 'السلم والثعبان', icon: Icons.leaderboard, color: Colors.greenAccent),
                ),
                const GameCard(title: 'الدومينو', icon: Icons.grid_view, color: Colors.amberAccent),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1E293B),
        selectedItemColor: const Color(0xFFF59E0B),
        unselectedItemColor: Colors.white54,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
          BottomNavigationBarItem(icon: Icon(Icons.leaderboard), label: 'المتصدرين'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'حسابي'),
        ],
      ),
    );
  }

  void _showSettingsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'إعدادات التطبيق',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.volume_up, color: Color(0xFFF59E0B)),
                title: const Text('المؤثرات الصوتية والموسيقى', style: TextStyle(color: Colors.white)),
                trailing: Switch(value: true, onChanged: (val) {}, activeColor: const Color(0xFFF59E0B)),
              ),
              ListTile(
                leading: const Icon(Icons.notifications, color: Color(0xFFF59E0B)),
                title: const Text('الإشعارات والتنبيهات', style: TextStyle(color: Colors.white)),
                trailing: Switch(value: true, onChanged: (val) {}, activeColor: const Color(0xFFF59E0B)),
              ),
              ListTile(
                leading: const Icon(Icons.support_agent, color: Color(0xFFF59E0B)),
                title: const Text('الدعم الفني والاتصال', style: TextStyle(color: Colors.white)),
                onTap: () {},
              ),
            ],
          ),
        );
      },
    );
  }
}

class GameCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const GameCard({super.key, required this.title, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: color.withOpacity(0.2),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

// شاشة لعبة لودو الجديدة كلياً
class LudoGameScreen extends StatefulWidget {
  const LudoGameScreen({super.key});

  @override
  State<LudoGameScreen> createState() => _LudoGameScreenState();
}

class _LudoGameScreenState extends State<LudoGameScreen> {
  int _diceValue = 6;
  bool _isRolling = false;
  int _tokenPosition = 0; // 0 تعني في القاعدة

  void _rollLudoDice() {
    if (_isRolling) return;
    setState(() {
      _isRolling = true;
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      setState(() {
        _diceValue = Random().nextInt(6) + 1;
        _isRolling = false;

        if (_tokenPosition == 0) {
          if (_diceValue == 6) {
            _tokenPosition = 1; // الخروج من القاعدة عند الحصول على 6
          }
        } else {
          _tokenPosition += _diceValue;
          if (_tokenPosition > 50) {
            _tokenPosition = 50; // نهاية المسار الفوز
            _showLudoWinDialog();
          }
        }
      });
    });
  }

  void _showLudoWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('مبروك الفوز!', style: TextStyle(color: Colors.redAccent)),
        content: const Text('لقد أتممت مسار لودو بنجاح وحصلت على 20 نقطة!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _tokenPosition = 0;
                _diceValue = 6;
              });
            },
            child: const Text('إعادة اللعبة'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لعبة لودو التنافسية'),
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F172A), Color(0xFF1E1B4B)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'حلبة لودو الملكية',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.amber),
            ),
            const SizedBox(height: 20),
            // لوحة اللعب التخيلية المبسطة
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              height: 220,
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.redAccent.withOpacity(0.5), width: 2),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _tokenPosition == 0 ? 'القطعة داخل القاعدة (اظهر رقم 6 للخروج)' : 'موقع القطعة الحالي: المسار رقم $_tokenPosition',
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: _tokenPosition > 0 ? Colors.redAccent : Colors.grey.withOpacity(0.3),
                          shape: BoxShape.circle,
                          boxShadow: [
                            if (_tokenPosition > 0)
                              const BoxShadow(color: Colors.redAccent, blurRadius: 10, spreadRadius: 2)
                          ],
                        ),
                        child: const Center(
                          child: Icon(Icons.star, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            // النرد والتحكم
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Text('نتيجة النرد', style: TextStyle(color: Colors.white60)),
                      const SizedBox(height: 5),
                      _isRolling
                          ? const SizedBox(width: 30, height: 30, child: CircularProgressIndicator(strokeWidth: 2))
                          : Text('$_diceValue', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.amber)),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: _rollLudoDice,
                    icon: const Icon(Icons.casino),
                    label: const Text('رمي النرد', style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
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

// شاشة لعبة السلم والثعبان
class SnakesAndLaddersGame extends StatefulWidget {
  const SnakesAndLaddersGame({super.key});

  @override
  State<SnakesAndLaddersGame> createState() => _SnakesAndLaddersGameState();
}

class _SnakesAndLaddersGameState extends State<SnakesAndLaddersGame> {
  int _playerPos = 1;
  int _currentDice = 1;
  bool _isRolling = false;

  final Map<int, int> _snakesAndLadders = {
    3: 20,
    6: 14,
    11: 28,
    17: 38,
    25: 5,
    34: 22,
    40: 19,
    47: 26,
    55: 36,
    62: 43,
    73: 51,
    89: 70,
    95: 75,
    99: 80,
  };

  void _rollDice() {
    if (_isRolling) return;

    setState(() {
      _isRolling = true;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _currentDice = Random().nextInt(6) + 1;
        _playerPos += _currentDice;

        if (_playerPos > 100) {
          _playerPos = 100;
        }

        if (_snakesAndLadders.containsKey(_playerPos)) {
          int newPos = _snakesAndLadders[_playerPos]!;
          Future.delayed(const Duration(milliseconds: 300), () {
            setState(() {
              _playerPos = newPos;
              _isRolling = false;
            });
          });
        } else {
          _isRolling = false;
        }

        if (_playerPos == 100) {
          _showWinDialog();
        }
      });
    });
  }

  void _resetGame() {
    setState(() {
      _playerPos = 1;
      _currentDice = 1;
    });
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('تهانينا!', style: TextStyle(color: Colors.greenAccent)),
        content: const Text('لقد وصلت إلى الخلية 100 وفزت بـ 10 نقاط!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetGame();
            },
            child: const Text('اللعب مرة أخرى'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('السلم والثعبان'),
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F172A), Color(0xFF334155)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      reverse: true,
                      itemCount: 100,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 10,
                      ),
                      itemBuilder: (context, index) {
                        int number = index + 1;
                        bool isPlayerHere = (number == _playerPos);
                        bool hasFeature = _snakesAndLadders.containsKey(number);
                        Color cellColor = Colors.transparent;
                        IconData? featureIcon;

                        if (hasFeature) {
                          if (_snakesAndLadders[number]! > number) {
                            cellColor = Colors.greenAccent.withOpacity(0.2);
                            featureIcon = Icons.trending_up;
                          } else {
                            cellColor = Colors.redAccent.withOpacity(0.2);
                            featureIcon = Icons.trending_down;
                          }
                        }

                        return Container(
                          decoration: BoxDecoration(
                            color: cellColor,
                            border: Border.all(color: Colors.white.withOpacity(0.05), width: 0.5),
                          ),
                          child: Stack(
                            children: [
                              Center(
                                child: Text(
                                  '$number',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(isPlayerHere ? 1.0 : 0.3),
                                    fontSize: 12,
                                    fontWeight: isPlayerHere ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                              ),
                              if (featureIcon != null)
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Icon(featureIcon, size: 14, color: Colors.white.withOpacity(0.3)),
                                ),
                              if (isPlayerHere)
                                const Center(
                                  child: Icon(Icons.person, color: Colors.amber, size: 30),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10)],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Text('الخلية الحالية', style: TextStyle(color: Colors.white70, fontSize: 12)),
                      Text('$_playerPos', style: const TextStyle(color: Colors.amber, fontSize: 32, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Column(
                    children: [
                      const Text('النرد', style: TextStyle(color: Colors.white70, fontSize: 12)),
                      _isRolling
                          ? const SizedBox(width: 32, height: 32, child: CircularProgressIndicator(strokeWidth: 2))
                          : Text('$_currentDice', style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: _rollDice,
                    icon: const Icon(Icons.casino),
                    label: const Text('رمي النرد', style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF59E0B),
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
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
