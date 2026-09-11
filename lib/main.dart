import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(StaarApp());
}

// نموذج بيانات عام لمشاركة رصيد المحفظة عبر التطبيق
class WalletData {
  static double balance = 1250.00;

  static void addEarnings(double amount) {
    balance += amount;
  }
}

class StaarApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Play and Win',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Color(0xFF1E293B),
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    MainDashboard(),
    WalletScreenNode(),
    ChatScreenNode(),
    VipScreenNode(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF1E293B),
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.white70,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet),
            label: 'المحفظة',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'المحادثة',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'VIP',
          ),
        ],
      ),
    );
  }
}

class MainDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('العب واربح', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF1E293B),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.indigo, Colors.blueAccent],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.asset(
                          'assets/icon/logo.png',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'مرحباً بك في تطبيق العب واربح',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'العب الآن واكسب أرباحاً حقيقية لمحفظتك!',
                              style: TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                GameCard(
                  title: 'لودو',
                  icon: Icons.casino,
                  color: Colors.orange,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LudoGameScreen()),
                    );
                  },
                ),
                GameCard(
                  title: 'السلم والثعبان',
                  icon: Icons.straighten,
                  color: Colors.green,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SnakesGameScreen()),
                    );
                  },
                ),
                GameCard(
                  title: 'البلياردو',
                  icon: Icons.sports_bar,
                  color: Colors.blueAccent,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BilliardsGameScreen()),
                    );
                  },
                ),
                GameCard(
                  title: 'الدومينو',
                  icon: Icons.dashboard,
                  color: Colors.purple,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DominoGameScreen()),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class GameCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  GameCard({required this.title, required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3), width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.2),
              radius: 30,
              child: Icon(icon, color: color, size: 30),
            ),
            SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 1. شاشة لودو (مرتبطة بالمحفظة)
class LudoGameScreen extends StatefulWidget {
  @override
  _LudoGameScreenState createState() => _LudoGameScreenState();
}

class _LudoGameScreenState extends State<LudoGameScreen> {
  int _diceValue = 1;
  int _score = 0;
  bool _isRolling = false;

  void _rollDice() {
    setState(() {
      _isRolling = true;
    });

    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        _diceValue = Random().nextInt(6) + 1;
        int earnedPoints = _diceValue * 5;
        _score += earnedPoints;
        
        // اضافة جزء من الأرباح للمحفظة فوراً
        WalletData.addEarnings(earnedPoints * 0.1);

        _isRolling = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('لعبة لودو (تربح للمحفظة)', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF1E293B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFF334155),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('نقاط اللعبة:', style: TextStyle(color: Colors.white70, fontSize: 16)),
                  Text('$_score نقطة', style: TextStyle(color: Colors.amber, fontSize: 22, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            SizedBox(height: 40),
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.orange, width: 2),
              ),
              child: Center(
                child: Text(
                  _isRolling ? '...' : '$_diceValue',
                  style: TextStyle(color: Colors.orange, fontSize: 50, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 30),
            Text(
              _isRolling ? 'جاري رمي النرد...' : 'كل رمية تحول أرباحاً لمحفظتك!',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _isRolling ? null : _rollDice,
              child: Text('ارمِ النرد واربح', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

// 2. شاشة السلم والثعبان (مرتبطة بالمحفظة)
class SnakesGameScreen extends StatefulWidget {
  @override
  _SnakesGameScreenState createState() => _SnakesGameScreenState();
}

class _SnakesGameScreenState extends State<SnakesGameScreen> {
  int _position = 1;
  int _diceValue = 1;
  bool _isRolling = false;
  String _message = 'اصعد السلالم واكسب أرباحاً!';

  void _rollAndMove() {
    setState(() {
      _isRolling = true;
    });

    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        _diceValue = Random().nextInt(6) + 1;
        _position += _diceValue;

        if (_position == 10) {
          _position = 25;
          _message = 'سلم ممتاز! ربحت \$5.00 إضافية لمحفظتك!';
          WalletData.addEarnings(5.00);
        } else if (_position == 30) {
          _position = 12;
          _message = 'هبطت مع الثعبان، حاول مرة أخرى!';
        } else if (_position >= 50) {
          _message = 'تهانينا الفوز الكبير! أُضيفت \$10 للمحفظة!';
          WalletData.addEarnings(10.00);
          _position = 50;
        } else {
          _message = 'تقدمت للخانة: $_position (تمت إضافة أرباح تفاعلية)';
          WalletData.addEarnings(1.50);
        }

        _isRolling = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('لعبة السلم والثعبان', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF1E293B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFF334155),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text('الخانة الحالية', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  SizedBox(height: 8),
                  Text('$_position / 50', style: TextStyle(color: Colors.greenAccent, fontSize: 28, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            SizedBox(height: 30),
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.green, width: 2),
              ),
              child: Center(
                child: Text(
                  _isRolling ? '...' : '$_diceValue',
                  style: TextStyle(color: Colors.green, fontSize: 40, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              _message,
              style: TextStyle(color: Colors.amber, fontSize: 15, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _isRolling ? null : _rollAndMove,
              child: Text('ارمِ النرد وتحرك', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

// 3. شاشة البلياردو (مرتبطة بالمحفظة)
class BilliardsGameScreen extends StatefulWidget {
  @override
  _BilliardsGameScreenState createState() => _BilliardsGameScreenState();
}

class _BilliardsGameScreenState extends State<BilliardsGameScreen> {
  int _ballsPocketed = 0;
  String _status = 'صوب وأدخل الكرات لتربح رصيداً!';
  bool _isShooting = false;

  void _shootBall() {
    setState(() {
      _isShooting = true;
    });

    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        bool success = Random().nextBool();
        if (success) {
          _ballsPocketed += 1;
          _status = 'دخلت الكرة! أُضيفت \$3 للمحفظة.';
          WalletData.addEarnings(3.00);
        } else {
          _status = 'خطأ في التصويب، حاول مرة أخرى!';
        }
        _isShooting = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('لعبة البلياردو', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF1E293B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFF334155),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('الكرات المسجلة:', style: TextStyle(color: Colors.white70, fontSize: 16)),
                  Text('$_ballsPocketed كرات', style: TextStyle(color: Colors.blueAccent, fontSize: 22, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            SizedBox(height: 40),
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.blueAccent, width: 2),
              ),
              child: Center(
                child: Icon(Icons.sports_bar, color: Colors.blueAccent, size: 50),
              ),
            ),
            SizedBox(height: 25),
            Text(
              _status,
              style: TextStyle(color: Colors.amber, fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _isShooting ? null : _shootBall,
              child: Text('صوب وادخل الكرة', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

// 4. شاشة الدومينو (مرتبطة بالمحفظة)
class DominoGameScreen extends StatefulWidget {
  @override
  _DominoGameScreenState createState() => _DominoGameScreenState();
}

class _DominoGameScreenState extends State<DominoGameScreen> {
  int _dominoScore = 0;
  String _dominoStatus = 'طابق القطع واربح مكافآت فورية!';
  bool _isPlaying = false;

  void _playDomino() {
    setState(() {
      _isPlaying = true;
    });

    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        int earned = (Random().nextInt(4) + 1) * 10;
        _dominoScore += earned;
        WalletData.addEarnings(earned * 0.2);
        _dominoStatus = 'تمت المطابقة! ربحت أرباحاً أضيفت لمحفظتك.';
        _isPlaying = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('لعبة الدومينو الذكية', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF1E293B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFF334155),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('مجموع النقاط:', style: TextStyle(color: Colors.white70, fontSize: 16)),
                  Text('$_dominoScore نقطة', style: TextStyle(color: Colors.purpleAccent, fontSize: 22, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            SizedBox(height: 40),
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.purple, width: 2),
              ),
              child: Center(
                child: Icon(Icons.dashboard, color: Colors.purple, size: 50),
              ),
            ),
            SizedBox(height: 25),
            Text(
              _dominoStatus,
              style: TextStyle(color: Colors.amber, fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _isPlaying ? null : _playDomino,
              child: Text('العب قطعة دومينو', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

// شاشة المحفظة المحدثة والتي تعرض الرصيد المتجدد
class WalletScreenNode extends StatefulWidget {
  @override
  _WalletScreenNodeState createState() => _WalletScreenNodeState();
}

class _WalletScreenNodeState extends State<WalletScreenNode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('المحفظة والأرباح', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF1E293B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Color(0xFF334155),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text('رصيدي الحالي المكتسب من الألعاب', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  SizedBox(height: 8),
                  Text('\$ ${WalletData.balance.toStringAsFixed(2)}', style: TextStyle(color: Colors.amber, fontSize: 32, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                setState(() {
                  WalletData.balance += 50.0; // شحن تجريبي إضافي
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('تم شحن الرصيد بنجاح!')),
                );
              },
              child: Text('شحن الرصيد', style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatScreenNode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('المحادثة العامة', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF1E293B),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                ChatBubble(message: 'أهلاً بك في الدردشة!', isMe: false),
                ChatBubble(message: 'تم ربط أرباح جميع الألعاب بالمحفظة بنجاح!', isMe: true),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'اكتب رسالتك...',
                      hintStyle: TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Color(0xFF1E293B),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isMe;

  ChatBubble({required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? Colors.blueAccent : Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(message, style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

class VipScreenNode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('عضوية VIP', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF1E293B),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star, size: 80, color: Colors.amber),
            SizedBox(height: 16),
            Text('ترقية إلى VIP قريباً', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('احصل على مزايا حصرية ومضاعفة الأرباح!', style: TextStyle(color: Colors.white70, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
