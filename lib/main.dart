import 'package:flutter/material.dart';

void main() {
  runApp(StaarApp());
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
                              'اختر لعبتك المفضلة وابدأ التحدي الآن',
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

// 1. شاشة لعبة لودو
class LudoGameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('لعبة لودو', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF1E293B),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.casino, size: 100, color: Colors.orange),
            SizedBox(height: 20),
            Text('مرحباً بك في ساحة لودو', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('اختر اللاعبين وابدأ رمي النرد!', style: TextStyle(color: Colors.white70, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

// 2. شاشة لعبة السلم والثعبان
class SnakesGameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('لعبة السلم والثعبان', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF1E293B),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.straighten, size: 100, color: Colors.green),
            SizedBox(height: 20),
            Text('مرحباً بك في السلم والثعبان', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('اصعد السلالم وتجنب الثعابين للفوز!', style: TextStyle(color: Colors.white70, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

// 3. شاشة لعبة البلياردو
class BilliardsGameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('لعبة البلياردو', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF1E293B),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.sports_bar, size: 100, color: Colors.blueAccent),
            SizedBox(height: 20),
            Text('طاولة البلياردو جاهزة', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('صوب بدقة وأدخل الكرات في الجيوب!', style: TextStyle(color: Colors.white70, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

// 4. شاشة لعبة الدومينو
class DominoGameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('لعبة الدومينو', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF1E293B),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.dashboard, size: 100, color: Colors.purple),
            SizedBox(height: 20),
            Text('تحدي الدومينو الذكي', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('طابق القطع واهزم الخصم!', style: TextStyle(color: Colors.white70, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

class WalletScreenNode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('المحفظة والأصوات', style: TextStyle(color: Colors.white)),
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
                color: Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text('رصيدي الحالي', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  SizedBox(height: 8),
                  Text('\$ 1,250.00', style: TextStyle(color: Colors.amber, fontSize: 32, fontWeight: FontWeight.bold)),
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
              onPressed: () {},
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
                ChatBubble(message: 'تم تجهيز الألعاب الأربعة بنجاح!', isMe: true),
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
