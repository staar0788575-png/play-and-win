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
  // بيانات المستخدم والخصائص الجديدة المتقدمة
  int userPoints = 500;
  int activeDays = 1; // عدد أيام اللعب الفعلية
  int userLevel = 1; // الليفل الحالي (يصل حتى 99)
  double totalSpentUSD = 0.0; // إجمالي الشحنات التراكمية بالدولار لعضوية الـ VIP
  int vipLevel = 0; // مستوى الـ VIP (0 يعني عايدي، 1 يعني VIP 1 عند بلوغ 50 دولار)

  // دالة لتحديث الليفل بناءً على أيام اللعب (كل 5 أيام ليفل جديد، بحد أقصى 99)
  void addActiveDay() {
    setState(() {
      activeDays++;
      userLevel = ((activeDays / 5).floor() + 1);
      if (userLevel > 99) userLevel = 99;
    });
  }

  // دالة لتحديث الشحن وعضوية الـ VIP تراكمياً
  void addRecharge(double usdAmount, int earnedCoins) {
    setState(() {
      totalSpentUSD += usdAmount;
      userPoints += earnedCoins;
      
      // ترقية الـ VIP تلقائياً إذا بلغ إجمالي الشحن 50 دولار أو أكثر لـ VIP 1
      if (totalSpentUSD >= 50.0) {
        vipLevel = 1;
      }
    });
  }

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
                // الهيدر العلوي المطور مع شارة الليفل والـ VIP
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'تطبيق العب واربح',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.purple.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.purpleAccent),
                              ),
                              child: Text(
                                'ليفل $userLevel (أيام اللعب: $activeDays)',
                                style: const TextStyle(color: Colors.purpleAccent, fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 6),
                            if (vipLevel > 0)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.amber.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.amberAccent),
                                ),
                                child: Text(
                                  'VIP $vipLevel',
                                  style: const TextStyle(color: Colors.amberAccent, fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                    // زر المحفظة التفاعلي
                    GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WalletScreen(
                              currentPoints: userPoints,
                              totalSpentUSD: totalSpentUSD,
                              vipLevel: vipLevel,
                            ),
                          ),
                        );
                        
                        // إذا تم العودة من صفحة الشحن وتمرير شحنة جديدة
                        if (result != null && result is Map<String, dynamic>) {
                          addRecharge(result['usd'] as double, result['coins'] as int);
                        }
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
                          'العب يومياً لرفع مستواك (حتى ليفل 99)، واشحن عبر كروت بلدك لتصل لعضوية الـ VIP!',
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
            final earnedPoints = await Navigator.push<int>(
              context,
              MaterialPageRoute(
                builder: (context) => GameScreen(gameName: title, rewardPoints: points),
              ),
            );

            if (earnedPoints != null) {
              setState(() {
                userPoints += earnedPoints;
                addActiveDay(); // تسجيل يوم لعب جديد لرفع الليفل
              });
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('مبروك! تم إضافة $earnedPoints نقطة وزيادة يوم لعب في رصيدك 🪙'),
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

// صفحة المحفظة ونظام الشحن المتقدم بحسب الدولة وكروت الشحن
class WalletScreen extends StatelessWidget {
  final int currentPoints;
  final double totalSpentUSD;
  final int vipLevel;

  const WalletScreen({
    Key? key,
    required this.currentPoints,
    required this.totalSpentUSD,
    required this.vipLevel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('محفظتي والشحن وعضوية الـ VIP'),
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
          child: ListView(
            children: [
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
                    const Text('رصيد العملات الحالي', style: TextStyle(color: Colors.white70, fontSize: 16)),
                    const SizedBox(height: 5),
                    Text(
                      '$currentPoints نقطة',
                      style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'إجمالي الشحن التراكمي: \$${totalSpentUSD.toStringAsFixed(2)} (VIP Level: $vipLevel)',
                      style: const TextStyle(color: Colors.white90, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // زر فتح نافذة شحن كروت الموبايل واختيار الدولة
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () {
                  // فتح نافذة اختيار الدولة وكروت الشحن
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: const Color(0xFF1E293B),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (context) => const RechargeCountrySheet(),
                  );
                },
                icon: const Icon(Icons.phone_android, color: Colors.white),
                label: const Text(
                  'شحن الرصيد عبر كروت الموبايل (حسب دولتك)',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 30),

              const Text(
                'مزايا نظام الـ VIP والشحن',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('• كل 500 عملة ذهبية = 15 جنيهاً مصرياً أو ما يعادلها بعملة دولتك.', style: TextStyle(color: Colors.white70, fontSize: 13)),
                    SizedBox(height: 6),
                    Text('• يمكنك الشحن على دفعات متقطعة (حتى 10 مرات أو أكثر) للوصول إلى 50 دولار وترقية الحساب لـ VIP 1.', style: TextStyle(color: Colors.white70, fontSize: 13)),
                    SizedBox(height: 6),
                    Text('• مستويات النشاط ترتفع تلقائياً كل 5 أيام لعب وتصل حتى ليفل 99.', style: TextStyle(color: Colors.white70, fontSize: 13)),
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

// نافذة اختيار الدولة وكروت الشحن المحلية والعملات
class RechargeCountrySheet extends StatefulWidget {
  const RechargeCountrySheet({Key? key}) : super(key: key);

  @override
  State<RechargeCountrySheet> createState() => _RechargeCountrySheetState();
}

class _RechargeCountrySheetState extends State<RechargeCountrySheet> {
  String selectedCountry = 'مصر';
  String selectedNetwork = 'فودافون كاش / كارت شحن';
  final TextEditingController pinController = TextEditingController();

  // خريطة الدول والعملات وكروت الشحن المتاحة
  final Map<String, Map<String, dynamic>> countriesData = {
    'مصر': {
      'currency': 'جنيه مصري (EGP)',
      'rateText': '15 جنيه = 500 عملة ذهبية',
      'networks': ['فودافون كاش', 'اتصالات كاش', 'أورانج كاش', 'كارت شحن عادي'],
    },
    'السعودية': {
      'currency': 'ريال سعودي (SAR)',
      'rateText': '3.5 ريال = 500 عملة ذهبية',
      'networks': ['سوا (STC)', 'موبايلي', 'زين'],
    },
    'الإمارات': {
      'currency': 'درهم إماراتي (AED)',
      'rateText': '3.5 درهم = 500 عملة ذهبية',
      'networks': ['اتصالات (Etisalat)', 'دو (Du)'],
    },
    'المغرب': {
      'currency': 'درهم مغربي (MAD)',
      'rateText': '10 درهم = 500 عملة ذهبية',
      'networks': ['اتصالات المغرب', 'اورانج', 'إنوي'],
    },
    'العراق': {
      'currency': 'دينار عراقي (IQD)',
      'rateText': '2000 دينار = 500 عملة ذهبية',
      'networks': ['آسياسيل', 'زين العراق', 'كورك'],
    },
    'دول أخرى': {
      'currency': 'دولار أمريكي (USD)',
      'rateText': '1 دولار = 500 عملة ذهبية',
      'networks': ['بطاقة ائتمان / باي بال', 'كارت عالمي'],
    },
  };

  @override
  Widget build(BuildContext context) {
    final currentCountryData = countriesData[selectedCountry]!;
    List<String> networks = List<String>.from(currentCountryData['networks']);

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'اختر دولتك وطريقة الشحن',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            // قائمة اختيار الدولة
            const Text('الدولة:', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: selectedCountry,
              dropdownColor: const Color(0xFF0F172A),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              items: countriesData.keys.map((String country) {
                return DropdownMenuItem<String>(
                  value: country,
                  child: Text(country),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedCountry = newValue!;
                  selectedNetwork = countriesData[selectedCountry]!['networks'][0];
                });
              },
            ),
            const SizedBox(height: 15),

            // عرض العملة وسعر الصرف
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.amberAccent.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('العملة: ${currentCountryData['currency']}', style: const TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold)),
                  Text(currentCountryData['rateText'], style: const TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 15),

            // اختيار شبكة أو نوع الكارت
            const Text('طريقة الشحن / شبكة الاتصال:', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: selectedNetwork,
              dropdownColor: const Color(0xFF0F172A),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              items: networks.map((String net) {
                return DropdownMenuItem<String>(
                  value: net,
                  child: Text(net),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedNetwork = newValue!;
                });
              },
            ),
            const SizedBox(height: 15),

            // إدخال كود الكارت أو رقم العملية
            const Text('أدخل رقم كارت الشحن أو رقم الحوالة:', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 6),
            TextField(
              controller: pinController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'أدخل الكود هنا...',
                hintStyle: const TextStyle(color: Colors.white38),
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 25),

            // زر تأكيد الشحن
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  if (pinController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('الرجاء إدخال كود الشحن أولاً!')),
                    );
                    return;
                  }

                  // افتراضياً سنضيف شحنة بقيمة 5 دولار (تعادل تقريباً 500 عملة ذهبية أو حسب الدولة)
                  double addedUSD = 5.0; 
                  int addedCoins = 500;

                  Navigator.pop(context); // إغلاق النافذة
                  Navigator.pop(context, {'usd': addedUSD, 'coins': addedCoins}); // العودة للمحفظة وتحديث البيانات

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('تم الشحن بنجاح عبر $selectedCountry ($selectedNetwork)! تمت إضافة $addedCoins عملة.'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                child: const Text(
                  'تأكيد وشحن الرصيد',
                  style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
