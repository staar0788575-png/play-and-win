// المسار: lib/main.dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'تطبيق العب واربح',
      home: const HomeScreen(),
    );
  }
}

// الشاشة الرئيسية للتطبيق
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // متغير لتخزين رصيد النقاط الإجمالي للمستخدم
  int userPoints = 500;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // خلفية راقية جداً بتدرج داكن فخم
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0B0F19), Color(0xFF1E1B4B), Color(0xFF0F172A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // الهيدر العلوي
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'تطبيق العب واربح',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // زر المحفظة التفاعلي الذي يعرض الرصيد الحقيقي
                    GestureDetector(
                      onTap: () async {
                        // الانتقال إلى صفحة المحفظة عند الضغط عليها
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WalletScreen(currentPoints: userPoints),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.amberAccent.withOpacity(0.5)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.account_balance_wallet, color: Colors.amberAccent, size: 20),
                            const SizedBox(width: 6),
                            Text(
                              '$userPoints نقطة',
                              style: const TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),

                // بطاقة الإرشادات
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.lightBlueAccent, size: 28),
                      SizedBox(width: 15),
                      Expanded(
                        child: Text(
                          'اضغط على زر المحفظة في الأعلى لعرض رصيدك، أو اختر لعبة لاكتساب النقاط!',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                const Text(
                  'الألعاب المتاحة',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),

                // قائمة الألعاب
                Expanded(
                  child: ListView(
                    children: [
                      _buildGameCard(context, 'لعبة لودو', 100, Colors.blueAccent, Icons.sports_esports),
                      _buildGameCard(context, 'السلم والثعبان', 150, Colors.greenAccent, Icons.alt_route),
                      _buildGameCard(context, 'الدومينو', 200, Colors.amber, Icons.dashboard_customize),
                      _buildGameCard(context, 'البلياردو', 250, Colors.redAccent, Icons.fiber_manual_record),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // تصميم بطاقة اللعبة الواحدة
  Widget _buildGameCard(BuildContext context, String title, int points, Color color, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text('النقاط المستحقة: $points', style: const TextStyle(color: Colors.white60, fontSize: 14)),
        ),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () async {
            // الانتقال إلى شاشة اللعبة وانتظار عودة النقاط المكتسبة
            final earnedPoints = await Navigator.push<int>(
              context,
              MaterialPageRoute(
                builder: (context) => GameScreen(gameName: title, rewardPoints: points),
              ),
            );

            // إذا ربح نقاطاً، يتم تحديث رصيده الإجمالي في الصفحة الرئيسية
            if (earnedPoints != null) {
              setState(() {
                userPoints += earnedPoints;
              });
              
              // إظهار رسالة نجاح أنيقة للمستخدم
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('مبروك! تم إضافة $earnedPoints نقطة إلى محفظتك بنجاح 🪙'),
                  backgroundColor: Colors.green.shade700,
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          },
          child: const Text('العب الآن', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}

// شاشة اللعبة الداخلية
class GameScreen extends StatelessWidget {
  final String gameName;
  final int rewardPoints;

  const GameScreen({Key? key, required this.gameName, required this.rewardPoints}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(gameName),
        backgroundColor: const Color(0xFF0F172A),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0B0F19), Color(0xFF0F172A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.sports_esports, size: 80, color: Colors.amberAccent),
                const SizedBox(height: 20),
                Text(
                  'جاري لعب $gameName...',
                  style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  'ستحصل على $rewardPoints نقطة عند إنهاء الجولة!',
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 30),
                const CircularProgressIndicator(color: Colors.amberAccent),
                const SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    // العودة وإرسال النقاط المكتسبة معها
                    Navigator.pop(context, rewardPoints);
                  },
                  child: const Text(
                    'إنهاء اللعب واكتساب النقاط',
                    style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// صفحة المحفظة الراقية الجديدة
class WalletScreen extends StatelessWidget {
  final int currentPoints;

  const WalletScreen({Key? key, required this.currentPoints}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('محفظتي وأرباحي'),
        backgroundColor: const Color(0xFF0F172A),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0B0F19), Color(0xFF1E1B4B), Color(0xFF0F172A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // بطاقة الرصيد الفاخرة
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.amber.shade700, Colors.amber.shade900],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(Icons.account_balance_wallet, size: 50, color: Colors.white),
                    const SizedBox(height: 10),
                    const Text(
                      'رصيدك الحالي',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '$currentPoints نقطة',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // خيارات المحفظة (شحن / سحب)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.showContext(context); // سيتم تفعيلها لاحقاً
                      },
                      icon: const Icon(Icons.add_circle, color: Colors.white),
                      label: const Text('شحن رصيد', style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {},
                      icon: const Icon(Icons.money, color: Colors.white),
                      label: const Text('سحب الأرباح', style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // سجل المعاملات أو نص إرشادي
              const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'سجل الأنشطة الأخيرة',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: ListView(
                  children: const [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.green,
                        child: Icon(Icons.sports_esports, color: Colors.white),
                      ),
                      title: Text('مكافأة اللعب والأنشطة', style: TextStyle(color: Colors.white)),
                      subtitle: Text('تمت إضافة النقاط بنجاح', style: TextStyle(color: Colors.white60)),
                      trailing: Text('+ نقاط', style: TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold)),
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
