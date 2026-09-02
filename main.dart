import 'package:flutter/material.dart';

void main() {
  runApp(const PlayAndWinApp());
}

class PlayAndWinApp extends StatelessWidget {
  const PlayAndWinApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'العب واربح',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0E1A),
        primaryColor: const Color(0xFFD4AF37),
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFFD4AF37),
          secondary: const Color(0xFF00E5FF),
          background: const Color(0xFF0A0E1A),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0A0E1A), Color(0xFF1A1F35), Color(0xFF0A0E1A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFD4AF37), width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFD4AF37).withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const CircleAvatar(
                  radius: 70,
                  backgroundColor: Color(0xFF141A29),
                  child: Icon(
                    Icons.sports_esports,
                    size: 70,
                    color: Color(0xFFD4AF37),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'العب واربح',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD4AF37),
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 15),
              const CircularProgressIndicator(
                color: Color(0xFFD4AF37),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> games = [
      {'title': 'لودو الملكية', 'icon': Icons.casino, 'color': Colors.amber},
      {'title': 'السلم والثعبان', 'icon': Icons.trending_up, 'color': Colors.greenAccent},
      {'title': 'البلياردو الاحترافي', 'icon': Icons.sports_bar, 'color': Colors.blueAccent},
      {'title': 'الدومينو الكلاسيكية', 'icon': Icons.grid_view, 'color': Colors.orangeAccent},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('العب واربح - الرئيسية', style: TextStyle(color: Color(0xFFD4AF37))),
        backgroundColor: const Color(0xFF141A29),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1A1F35), Color(0xFF141A29)],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.star, color: Color(0xFFD4AF37), size: 40),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'أهلاً بك يا قهرمان الألعاب',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'اختر لعبتك المفضلة وابدأ المنافسة الآن!',
                          style: TextStyle(fontSize: 14, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'الألعاب المتاحة',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFD4AF37)),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 1.1,
                ),
                itemCount: games.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF141A29),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: games[index]['color'].withOpacity(0.3)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(games[index]['icon'], size: 50, color: games[index]['color']),
                        const SizedBox(height: 12),
                        Text(
                          games[index]['title'],
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
