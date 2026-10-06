import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';
import 'package:flutter/services.dart';

void main() {
  runApp(const PlayAndWinApp());
}

class PlayAndWinApp extends StatelessWidget {
  const PlayAndWinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Play and Win',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFF1E0524)),
      home: const HomeScreen(),
    );
  }
}

// ================= بيانات المستخدم =================
class UserData {
  static int coins = 1200;
  static int freeRoses = 5;

  /// يتغير كلما تغير الرصيد ليتحدث الشريط العلوي فوراً
  static final ValueNotifier<int> tick = ValueNotifier<int>(0);

  static void _notify() => tick.value = tick.value + 1;

  static void addCoins(int n) {
    coins += n;
    _notify();
  }

  static void addRoses(int n) {
    freeRoses += n;
    _notify();
  }

  static bool useRose() {
    if (freeRoses <= 0) return false;
    freeRoses--;
    _notify();
    return true;
  }
}

void showRoseFeedback(BuildContext context) {
  final ok = UserData.useRose();
  final m = ScaffoldMessenger.of(context);
  m.hideCurrentSnackBar();
  m.showSnackBar(SnackBar(
    duration: const Duration(milliseconds: 1500),
    content: Text(ok ? '🌹 تم إرسال وردة يومية بنجاح!' : 'نفدت الوردات المجانية'),
  ));
}

class BotChat {
  static final math.Random _r = math.Random();
  static const List<String> replies = [
    'لعبة حلوة 👏',
    'حظ موفق 🍀',
    'يا سلام على الحركة 🔥',
    'ما شاء الله عليك 👑',
    'هههه 😂',
    'جاي عليك الدور 😎',
  ];
  static String random() => replies[_r.nextInt(replies.length)];
}

// ================= الشاشة الرئيسية =================
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int tab = 0;
  final List<Widget> pages = const [
    LudoRoyalFull(),
    CarromProScreen(),
    SnakeLadderRoyal(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Play & Win - منصة الألعاب'),
        backgroundColor: const Color(0xFF1E293B),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ValueListenableBuilder<int>(
                valueListenable: UserData.tick,
                builder: (context, _, __) => Row(
                  children: [
                    const Text('🌹', style: TextStyle(fontSize: 14)),
                    const SizedBox(width: 2),
                    Text('${UserData.freeRoses}',
                        style: const TextStyle(color: Colors.white70, fontSize: 12)),
                    const SizedBox(width: 10),
                    const Icon(Icons.monetization_on, color: Colors.amber, size: 20),
                    const SizedBox(width: 4),
                    Text('${UserData.coins}',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.diamond, color: Colors.amber),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ShopScreen()),
              );
            },
          ),
        ],
      ),
      body: pages[tab],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: tab,
        onTap: (i) => setState(() => tab = i),
        backgroundColor: const Color(0xFF0A1931),
        selectedItemColor: const Color(0xFFFFD700),
        unselectedItemColor: Colors.white54,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.casino), label: "لودو"),
          BottomNavigationBarItem(icon: Icon(Icons.circle), label: "كيرم"),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: "سلم"),
        ],
      ),
    );
  }
}

// ================= المتجر =================
class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('متجر العملات والورود'),
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'اختر الباقة المناسبة لشحن رصيدك:',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _card('باقة المبتدئين: 500 عملة + 10 وردات مجانية', 500, 10, '4.99\$'),
          _card('باقة المحترفين: 1500 عملة + 30 وردة مجانية', 1500, 30, '9.99\$'),
          _card('باقة النخبة: 5000 عملة + 100 وردة مجانية', 5000, 100, '24.99\$'),
        ],
      ),
    );
  }

  Widget _card(String title, int addCoins, int addRoses, String price) => Card(
        color: const Color(0xFF1E293B),
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(title, style: const TextStyle(color: Colors.amber, fontSize: 14)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                onPressed: () {
                  UserData.addCoins(addCoins);
                  UserData.addRoses(addRoses);
                  setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('تم الشحن بنجاح! رصيدك الحالي: ${UserData.coins} عملة')),
                  );
                },
                child: Text(price, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      );
}

// ================= الصوت والاهتزاز =================
class SoundManager {
  static bool enabled = true;
  static void dice() {
    if (enabled) HapticFeedback.mediumImpact();
  }

  static void move() {
    if (enabled) HapticFeedback.lightImpact();
  }

  static void capture() {
    if (enabled) HapticFeedback.heavyImpact();
  }
}

// ================= شريط الدردشة =================
class ChatAndControlsBar extends StatefulWidget {
  final ValueChanged<String> onSendChat;
  final ValueChanged<String> onSendEmoji;
  final VoidCallback onSendRose;

  const ChatAndControlsBar({
    super.key,
    required this.onSendChat,
    required this.onSendEmoji,
    required this.onSendRose,
  });

  @override
  State<ChatAndControlsBar> createState() => _ChatAndControlsBarState();
}

class _ChatAndControlsBarState extends State<ChatAndControlsBar> {
  final TextEditingController chatCtrl = TextEditingController();
  final List<String> emojis = ["❤️", "🌹", "👑", "🔥", "😂", "👍"];
  bool isMuted = false;

  @override
  void dispose() {
    chatCtrl.dispose();
    super.dispose();
  }

  void _send() {
    final text = chatCtrl.text.trim();
    if (text.isEmpty) return;
    widget.onSendChat(text);
    chatCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      color: const Color(0xFF0F172A),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                IconButton(
                  icon: Icon(isMuted ? Icons.mic_off : Icons.mic, color: isMuted ? Colors.red : Colors.green),
                  onPressed: () {
                    setState(() => isMuted = !isMuted);
                    final m = ScaffoldMessenger.of(context);
                    m.hideCurrentSnackBar();
                    m.showSnackBar(
                      SnackBar(
                        duration: const Duration(milliseconds: 1200),
                        content: Text(isMuted ? 'تم كتم المايك' : 'تم فتح المايك الصوتي'),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Text("🌹", style: TextStyle(fontSize: 18)),
                  onPressed: widget.onSendRose,
                ),
                ...emojis.map((e) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: ActionChip(
                        backgroundColor: const Color(0xFF1E293B),
                        label: Text(e, style: const TextStyle(fontSize: 14)),
                        onPressed: () => widget.onSendEmoji(e),
                      ),
                    )),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: chatCtrl,
                  onSubmitted: (_) => _send(),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                  decoration: InputDecoration(
                    hintText: "اكتب رسالة عامة أو خاصة...",
                    hintStyle: const TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: const Color(0xFF1E293B),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send, color: Colors.amber, size: 20),
                onPressed: _send,
              )
            ],
          ),
        ],
      ),
    );
  }
}

// ================= عناصر مشتركة =================

/// شريط يعرض آخر رسالة دردشة
class ChatTicker extends StatelessWidget {
  final List<String> messages;
  const ChatTicker({super.key, required this.messages});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(8)),
      child: Text(
        messages.isEmpty ? '💬 الدردشة العامة' : messages.last,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Colors.white70, fontSize: 11),
      ),
    );
  }
}

/// بطاقة لاعب (صورة + اسم + شارة)
class PlayerBadge extends StatelessWidget {
  final String name;
  final Color color;
  final String badge;
  final bool active;

  const PlayerBadge({
    super.key,
    required this.name,
    required this.color,
    required this.badge,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: active ? Colors.greenAccent : Colors.transparent, width: 2.5),
                boxShadow: active
                    ? [BoxShadow(color: Colors.greenAccent.withOpacity(0.6), blurRadius: 10, spreadRadius: 1)]
                    : const [],
              ),
              child: Padding(
                padding: const EdgeInsets.all(3),
                child: CircleAvatar(
                  backgroundColor: color,
                  child: const Icon(Icons.person, color: Colors.white, size: 20),
                ),
              ),
            ),
            Positioned(
              top: -2,
              right: -6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(6)),
                child: Text(badge,
                    style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.black)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(name, style: TextStyle(color: active ? Colors.white : Colors.white60, fontSize: 10)),
      ],
    );
  }
}

/// وجه النرد بالنقاط
class DiceFace extends StatelessWidget {
  final int value;
  final double size;
  final Color accent;
  final bool active;
  final bool rolling;
  final VoidCallback? onTap;

  const DiceFace({
    super.key,
    required this.value,
    required this.size,
    required this.accent,
    this.active = false,
    this.rolling = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final face = AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size * 0.2),
        border: Border.all(color: accent, width: 3),
        boxShadow: [
          BoxShadow(
            color: active ? const Color(0xFFFFD700).withOpacity(0.85) : Colors.black45,
            blurRadius: active ? 14 : 5,
            spreadRadius: active ? 2 : 0,
          ),
        ],
      ),
      child: CustomPaint(painter: _PipsPainter(value, Colors.black87)),
    );
    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        scale: rolling ? 1.14 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Transform.rotate(angle: rolling ? value * 0.45 : 0, child: face),
      ),
    );
  }
}

class _PipsPainter extends CustomPainter {
  final int v;
  final Color color;
  _PipsPainter(this.v, this.color);

  static const Map<int, List<Offset>> layout = {
    1: [Offset(.5, .5)],
    2: [Offset(.28, .28), Offset(.72, .72)],
    3: [Offset(.28, .28), Offset(.5, .5), Offset(.72, .72)],
    4: [Offset(.28, .28), Offset(.72, .28), Offset(.28, .72), Offset(.72, .72)],
    5: [Offset(.28, .28), Offset(.72, .28), Offset(.5, .5), Offset(.28, .72), Offset(.72, .72)],
    6: [Offset(.28, .25), Offset(.72, .25), Offset(.28, .5), Offset(.72, .5), Offset(.28, .75), Offset(.72, .75)],
  };

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final pips = layout[v] ?? layout[1]!;
    for (final o in pips) {
      canvas.drawCircle(Offset(o.dx * size.width, o.dy * size.height), size.width * 0.085, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _PipsPainter old) => old.v != v;
}

/// نجمة صغيرة تستخدم لتعليم المربعات الآمنة
Path starPath(Offset c, double r) {
  final path = Path();
  for (int i = 0; i < 10; i++) {
    final rad = i.isEven ? r : r * 0.45;
    final a = -math.pi / 2 + i * math.pi / 5;
    final p = Offset(c.dx + rad * math.cos(a), c.dy + rad * math.sin(a));
    if (i == 0) {
      path.moveTo(p.dx, p.dy);
    } else {
      path.lineTo(p.dx, p.dy);
    }
  }
  path.close();
  return path;
}

Future<void> showWinDialog(BuildContext context, String title, String body, VoidCallback onAgain) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      backgroundColor: const Color(0xFF1E293B),
      title: Text(title, style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
      content: Text(body, style: const TextStyle(color: Colors.white)),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(ctx).pop();
            onAgain();
          },
          child: const Text('العب مرة أخرى', style: TextStyle(color: Colors.amber)),
        ),
      ],
    ),
  );
}

// ================= LUDO =================
const List<Color> kLudoColors = [
  Color(0xFFE53935), // أحمر (أعلى اليسار)
  Color(0xFF43A047), // أخضر (أعلى اليمين)
  Color(0xFF1E88E5), // أزرق (أسفل اليمين)
  Color(0xFFFBC02D), // أصفر (أسفل اليسار)
];

/// مسار اللعب الرئيسي: 52 خانة، كل عنصر [صف، عمود]
const List<List<int>> kLudoPath = [
  [6, 1], [6, 2], [6, 3], [6, 4], [6, 5],
  [5, 6], [4, 6], [3, 6], [2, 6], [1, 6], [0, 6],
  [0, 7], [0, 8],
  [1, 8], [2, 8], [3, 8], [4, 8], [5, 8],
  [6, 9], [6, 10], [6, 11], [6, 12], [6, 13], [6, 14],
  [7, 14], [8, 14],
  [8, 13], [8, 12], [8, 11], [8, 10], [8, 9],
  [9, 8], [10, 8], [11, 8], [12, 8], [13, 8], [14, 8],
  [14, 7], [14, 6],
  [13, 6], [12, 6], [11, 6], [10, 6], [9, 6],
  [8, 5], [8, 4], [8, 3], [8, 2], [8, 1], [8, 0],
  [7, 0], [6, 0],
];

/// ممرات المنزل الخمسة لكل لاعب [صف، عمود]
const List<List<List<int>>> kLudoHome = [
  [[7, 1], [7, 2], [7, 3], [7, 4], [7, 5]],
  [[1, 7], [2, 7], [3, 7], [4, 7], [5, 7]],
  [[7, 13], [7, 12], [7, 11], [7, 10], [7, 9]],
  [[13, 7], [12, 7], [11, 7], [10, 7], [9, 7]],
];

class LudoBoardPainter extends CustomPainter {
  const LudoBoardPainter();

  static const List<int> starts = [0, 13, 26, 39];
  static const List<int> stars = [8, 21, 34, 47];
  static const List<Offset> yards = [Offset(0, 0), Offset(9, 0), Offset(9, 9), Offset(0, 9)];

  @override
  void paint(Canvas canvas, Size size) {
    final ce = size.width / 15;
    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xFFFFF8E1));

    // الزوايا (بيوت اللاعبين)
    for (int p = 0; p < 4; p++) {
      final o = yards[p];
      canvas.drawRect(Rect.fromLTWH(o.dx * ce, o.dy * ce, 6 * ce, 6 * ce), Paint()..color = kLudoColors[p]);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH((o.dx + 1) * ce, (o.dy + 1) * ce, 4 * ce, 4 * ce),
          Radius.circular(ce * 0.6),
        ),
        Paint()..color = Colors.white,
      );
      for (final dx in [2.0, 4.0]) {
        for (final dy in [2.0, 4.0]) {
          final c = Offset((o.dx + dx) * ce, (o.dy + dy) * ce);
          canvas.drawCircle(c, ce * 0.5, Paint()..color = kLudoColors[p].withOpacity(0.25));
          canvas.drawCircle(
            c,
            ce * 0.5,
            Paint()
              ..color = kLudoColors[p].withOpacity(0.7)
              ..style = PaintingStyle.stroke
              ..strokeWidth = 1.5,
          );
        }
      }
    }

    final border = Paint()
      ..color = Colors.black26
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.7;

    // خانات ممرات المنزل
    for (int p = 0; p < 4; p++) {
      for (final h in kLudoHome[p]) {
        final r = Rect.fromLTWH(h[1] * ce, h[0] * ce, ce, ce);
        canvas.drawRect(r, Paint()..color = kLudoColors[p].withOpacity(0.85));
        canvas.drawRect(r, border);
      }
    }

    // المسار الرئيسي
    for (int i = 0; i < 52; i++) {
      final cell = kLudoPath[i];
      final r = Rect.fromLTWH(cell[1] * ce, cell[0] * ce, ce, ce);
      final sp = starts.indexOf(i);
      canvas.drawRect(r, Paint()..color = sp >= 0 ? kLudoColors[sp] : const Color(0xFFFFFDF5));
      canvas.drawRect(r, border);
      if (stars.contains(i) || sp >= 0) {
        canvas.drawPath(
          starPath(r.center, ce * 0.32),
          Paint()..color = sp >= 0 ? Colors.white70 : const Color(0xFFFFB300),
        );
      }
    }

    // المثلثات في المنتصف
    final c = Offset(7.5 * ce, 7.5 * ce);
    final tl = Offset(6 * ce, 6 * ce);
    final tr = Offset(9 * ce, 6 * ce);
    final bl = Offset(6 * ce, 9 * ce);
    final br = Offset(9 * ce, 9 * ce);
    void tri(Offset a, Offset b, Color col) {
      final path = Path()
        ..moveTo(a.dx, a.dy)
        ..lineTo(b.dx, b.dy)
        ..lineTo(c.dx, c.dy)
        ..close();
      canvas.drawPath(path, Paint()..color = col);
      canvas.drawPath(path, border);
    }

    tri(tl, bl, kLudoColors[0]); // يسار: أحمر
    tri(tl, tr, kLudoColors[1]); // أعلى: أخضر
    tri(tr, br, kLudoColors[2]); // يمين: أزرق
    tri(bl, br, kLudoColors[3]); // أسفل: أصفر
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LudoToken {
  final int p, i;
  final Offset pos;
  final bool movable;
  _LudoToken(this.p, this.i, this.pos, this.movable);
}

class LudoRoyalFull extends StatefulWidget {
  const LudoRoyalFull({super.key});

  @override
  State<LudoRoyalFull> createState() => _LudoState();
}

class _LudoState extends State<LudoRoyalFull> with SingleTickerProviderStateMixin {
  static const List<int> startIdx = [0, 13, 26, 39];
  static const Set<int> safeCells = {0, 13, 26, 39, 8, 21, 34, 47};
  static const List<String> names = ['أنت', 'سلطان', 'نورة', 'ليث'];
  static const List<Offset> yard = [Offset(0, 0), Offset(9, 0), Offset(9, 9), Offset(0, 9)];

  final math.Random rnd = math.Random();
  late final AnimationController pulse;

  /// -1 = في البيت ، 0..50 = على المسار (نسبةً لخانة البداية) ، 51..55 = ممر المنزل ، 56 = وصلت
  List<List<int>> tokens = List.generate(4, (_) => List.filled(4, -1));
  int dice = 1, turn = 0, sixes = 0, gen = 0;
  bool rolling = false, busy = false, waitingMove = false, gameOver = false;
  String msg = 'اضغط على النرد لتبدأ';
  List<int> movable = [];
  final List<String> publicChat = ['سلطان: هلا بالجميع 💪'];

  @override
  void initState() {
    super.initState();
    pulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    gen++;
    pulse.dispose();
    super.dispose();
  }

  bool get canRoll => turn == 0 && !rolling && !busy && !waitingMove && !gameOver;

  int homeCount(int p) => tokens[p].where((r) => r == 56).length;

  // ---------- الرمي ----------
  void roll() {
    if (turn != 0) return;
    _doRoll();
  }

  void _doRoll() {
    if (rolling || busy || waitingMove || gameOver) return;
    final g = gen;
    setState(() {
      rolling = true;
      msg = turn == 0 ? 'جاري رمي النرد...' : '${names[turn]} يرمي النرد...';
    });
    SoundManager.dice();
    int ticks = 0;
    Timer.periodic(const Duration(milliseconds: 70), (t) {
      if (!mounted || g != gen) {
        t.cancel();
        return;
      }
      ticks++;
      if (ticks < 9) {
        setState(() => dice = rnd.nextInt(6) + 1);
      } else {
        t.cancel();
        setState(() {
          dice = rnd.nextInt(6) + 1;
          rolling = false;
        });
        _afterRoll();
      }
    });
  }

  bool _canMove(int p, int i, int d) {
    final r = tokens[p][i];
    if (r == 56) return false;
    if (r == -1) return d == 6;
    return r + d <= 56;
  }

  List<int> _movable(int p, int d) {
    final res = <int>[];
    for (int i = 0; i < 4; i++) {
      if (_canMove(p, i, d)) res.add(i);
    }
    return res;
  }

  Future<void> _afterRoll() async {
    final g = gen;
    if (dice == 6) {
      sixes++;
    } else {
      sixes = 0;
    }
    if (sixes >= 3) {
      setState(() => msg = 'ثلاث ستات متتالية! ضاع الدور');
      _endTurn(false);
      return;
    }
    final opts = _movable(turn, dice);
    if (opts.isEmpty) {
      setState(() => msg = 'لا توجد حركة متاحة');
      _endTurn(false);
      return;
    }
    if (turn == 0) {
      setState(() {
        movable = opts;
        waitingMove = true;
        msg = 'اختر قطعة للتحريك';
      });
      if (opts.length == 1) {
        await Future.delayed(const Duration(milliseconds: 450));
        if (!mounted || g != gen || !waitingMove) return;
        _move(0, opts.first);
      }
    } else {
      await Future.delayed(const Duration(milliseconds: 650));
      if (!mounted || g != gen) return;
      _move(turn, _botPick(turn, opts));
    }
  }

  // ---------- الحركة ----------
  void _tapToken(int p, int i) {
    if (p != 0 || turn != 0 || !waitingMove || !movable.contains(i)) return;
    _move(0, i);
  }

  Future<void> _move(int p, int i) async {
    final g = gen;
    setState(() {
      busy = true;
      waitingMove = false;
      movable = [];
    });
    final r = tokens[p][i];
    if (r == -1) {
      setState(() => tokens[p][i] = 0);
      SoundManager.move();
      await Future.delayed(const Duration(milliseconds: 250));
      if (!mounted || g != gen) return;
    } else {
      for (int s = 0; s < dice; s++) {
        await Future.delayed(const Duration(milliseconds: 150));
        if (!mounted || g != gen) return;
        setState(() => tokens[p][i] = tokens[p][i] + 1);
        if (p == 0) SoundManager.move();
      }
    }

    bool bonus = false;
    final rel = tokens[p][i];

    // الأكل
    if (rel >= 0 && rel <= 50) {
      final cell = (startIdx[p] + rel) % 52;
      if (!safeCells.contains(cell)) {
        for (int q = 0; q < 4; q++) {
          if (q == p) continue;
          for (int j = 0; j < 4; j++) {
            final rq = tokens[q][j];
            if (rq >= 0 && rq <= 50 && (startIdx[q] + rq) % 52 == cell) {
              setState(() {
                tokens[q][j] = -1;
                msg = '${names[p]} أكل قطعة ${names[q]}! 🔥';
              });
              SoundManager.capture();
              bonus = true;
            }
          }
        }
      }
    }

    if (rel == 56) {
      bonus = true;
      setState(() => msg = '${names[p]} أوصل قطعة للمنزل! 🏠');
    }

    // الفوز
    if (tokens[p].every((x) => x == 56)) {
      setState(() {
        gameOver = true;
        busy = false;
        msg = 'فاز ${names[p]}!';
      });
      if (p == 0) UserData.addCoins(100);
      if (!mounted) return;
      showWinDialog(
        context,
        p == 0 ? '🏆 مبروك، لقد فزت!' : 'انتهت اللعبة',
        p == 0 ? 'ربحت 100 عملة. هل تلعب مرة أخرى؟' : 'الفائز هو ${names[p]}. حظاً أوفر في المرة القادمة!',
        _reset,
      );
      return;
    }

    _endTurn(bonus || dice == 6);
  }

  Future<void> _endTurn(bool extra) async {
    final g = gen;
    setState(() {
      busy = true;
      waitingMove = false;
      movable = [];
    });
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted || g != gen) return;
    setState(() {
      if (!extra) {
        turn = (turn + 1) % 4;
        sixes = 0;
      }
      busy = false;
      msg = turn == 0 ? 'دورك! اضغط على النرد' : 'دور ${names[turn]}';
    });
    if (turn != 0 && !gameOver) {
      await Future.delayed(const Duration(milliseconds: 600));
      if (!mounted || g != gen) return;
      _doRoll();
    }
  }

  // ---------- ذكاء اللاعب الآلي ----------
  bool _danger(int p, int rel) {
    if (rel < 0 || rel > 50) return false;
    final cell = (startIdx[p] + rel) % 52;
    if (safeCells.contains(cell)) return false;
    for (int q = 0; q < 4; q++) {
      if (q == p) continue;
      for (final rq in tokens[q]) {
        if (rq < 0 || rq > 50) continue;
        final a = (startIdx[q] + rq) % 52;
        final dist = (cell - a + 52) % 52;
        if (dist >= 1 && dist <= 6) return true;
      }
    }
    return false;
  }

  int _capturesAt(int p, int rel) {
    if (rel < 0 || rel > 50) return 0;
    final cell = (startIdx[p] + rel) % 52;
    if (safeCells.contains(cell)) return 0;
    int n = 0;
    for (int q = 0; q < 4; q++) {
      if (q == p) continue;
      for (final rq in tokens[q]) {
        if (rq >= 0 && rq <= 50 && (startIdx[q] + rq) % 52 == cell) n++;
      }
    }
    return n;
  }

  int _botPick(int p, List<int> opts) {
    int best = opts.first;
    double bestScore = -1e9;
    for (final i in opts) {
      final r = tokens[p][i];
      final nr = r == -1 ? 0 : r + dice;
      double s = 0;
      if (nr == 56) s += 100;
      if (r == -1) s += 40;
      s += _capturesAt(p, nr) * 80;
      if (nr >= 51 && nr < 56) s += 20;
      if (r >= 0 && _danger(p, r)) s += 18;
      if (_danger(p, nr)) s -= 14;
      if (nr <= 50 && safeCells.contains((startIdx[p] + nr) % 52)) s += 8;
      s += nr * 0.3;
      s += rnd.nextDouble() * 3;
      if (s > bestScore) {
        bestScore = s;
        best = i;
      }
    }
    return best;
  }

  void _reset() {
    gen++;
    setState(() {
      tokens = List.generate(4, (_) => List.filled(4, -1));
      dice = 1;
      turn = 0;
      sixes = 0;
      rolling = false;
      busy = false;
      waitingMove = false;
      gameOver = false;
      movable = [];
      msg = 'اضغط على النرد لتبدأ';
    });
  }

  // ---------- الرسم ----------
  Offset _tokenUnit(int p, int i) {
    final r = tokens[p][i];
    if (r == -1) {
      final o = yard[p];
      return Offset(o.dx + (i % 2 == 0 ? 2 : 4), o.dy + (i < 2 ? 2 : 4));
    }
    if (r <= 50) {
      final cell = kLudoPath[(startIdx[p] + r) % 52];
      return Offset(cell[1] + 0.5, cell[0] + 0.5);
    }
    final h = kLudoHome[p][r - 51];
    return Offset(h[1] + 0.5, h[0] + 0.5);
  }

  List<Widget> _buildTokens(double ce) {
    final entries = <_LudoToken>[];
    for (int p = 0; p < 4; p++) {
      for (int i = 0; i < 4; i++) {
        if (tokens[p][i] == 56) continue;
        final mv = p == 0 && turn == 0 && waitingMove && movable.contains(i);
        entries.add(_LudoToken(p, i, _tokenUnit(p, i), mv));
      }
    }
    final groups = <String, List<_LudoToken>>{};
    for (final e in entries) {
      final key = '${e.pos.dx.toStringAsFixed(2)},${e.pos.dy.toStringAsFixed(2)}';
      groups.putIfAbsent(key, () => <_LudoToken>[]).add(e);
    }
    final placed = <Widget>[];
    final sorted = [...entries]..sort((a, b) => (a.movable ? 1 : 0).compareTo(b.movable ? 1 : 0));
    for (final e in sorted) {
      final key = '${e.pos.dx.toStringAsFixed(2)},${e.pos.dy.toStringAsFixed(2)}';
      final grp = groups[key]!;
      final k = grp.indexOf(e);
      final n = grp.length;
      double ox = 0, oy = 0;
      if (n > 1) {
        ox = ((k % 2) - 0.5) * 0.42;
        oy = (((k ~/ 2) % 2) - 0.5) * 0.42;
      }
      final sz = ce * (n > 1 ? 0.52 : 0.76);
      final col = kLudoColors[e.p];
      placed.add(AnimatedPositioned(
        key: ValueKey('tk${e.p}_${e.i}'),
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        left: (e.pos.dx + ox) * ce - sz / 2,
        top: (e.pos.dy + oy) * ce - sz / 2,
        width: sz,
        height: sz,
        child: GestureDetector(
          onTap: () => _tapToken(e.p, e.i),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                center: const Alignment(-0.3, -0.3),
                colors: [Colors.white.withOpacity(0.85), col, Color.lerp(col, Colors.black, 0.35)!],
                stops: const [0.0, 0.45, 1.0],
              ),
              border: Border.all(
                color: e.movable ? const Color(0xFFFFD700) : Colors.white,
                width: e.movable ? 2.5 : 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: e.movable
                      ? const Color(0xFFFFD700).withOpacity(0.4 + 0.5 * pulse.value)
                      : Colors.black38,
                  blurRadius: e.movable ? 8 + 6 * pulse.value : 3,
                  spreadRadius: e.movable ? 1 + 2 * pulse.value : 0,
                ),
              ],
            ),
          ),
        ),
      ));
    }
    return placed;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(8)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(msg,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.amber, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 8),
              Text('الدور: ${names[turn]}', style: const TextStyle(color: Colors.white, fontSize: 11)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              4,
              (p) => PlayerBadge(
                name: names[p],
                color: kLudoColors[p],
                badge: '${homeCount(p)}/4',
                active: turn == p && !gameOver,
              ),
            ),
          ),
        ),
        Expanded(
          child: LayoutBuilder(builder: (context, cons) {
            final bs = math.min(cons.maxWidth - 16, cons.maxHeight - 8);
            if (bs <= 0) return const SizedBox.shrink();
            return Center(
              child: Container(
                width: bs,
                height: bs,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFFFD700), width: 3),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 10)],
                ),
                child: LayoutBuilder(builder: (c, inner) {
                  final ce = inner.maxWidth / 15;
                  return AnimatedBuilder(
                    animation: pulse,
                    builder: (context, _) => Stack(
                      children: [
                        const Positioned.fill(child: CustomPaint(painter: LudoBoardPainter())),
                        ..._buildTokens(ce),
                        Positioned(
                          left: 6 * ce,
                          top: 6 * ce,
                          width: 3 * ce,
                          height: 3 * ce,
                          child: Center(
                            child: DiceFace(
                              value: dice,
                              size: ce * 2.0,
                              accent: kLudoColors[turn],
                              active: canRoll,
                              rolling: rolling,
                              onTap: roll,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            );
          }),
        ),
        ChatTicker(messages: publicChat),
        ChatAndControlsBar(
          onSendChat: (txt) {
            setState(() => publicChat.add('أنت: $txt'));
            Future.delayed(const Duration(milliseconds: 1200), () {
              if (!mounted) return;
              setState(() => publicChat.add('${names[1 + rnd.nextInt(3)]}: ${BotChat.random()}'));
            });
          },
          onSendEmoji: (em) => setState(() => publicChat.add('أنت: $em')),
          onSendRose: () => showRoseFeedback(context),
        ),
      ],
    );
  }
}

// ================= CARROM : المحرك الفيزيائي =================
// كل الإحداثيات مقيسة على لوحة مربعة طولها 1.0

enum CKind { white, black, queen, striker }

class CPiece {
  Offset pos;
  Offset vel = Offset.zero;
  final CKind kind;
  final double r;
  final double mass;
  bool out = false;

  CPiece(this.pos, CKind k)
      : kind = k,
        r = k == CKind.striker ? 0.036 : 0.027,
        mass = k == CKind.striker ? 1.8 : 1.0;

  bool get moving => vel != Offset.zero;
}

class AimInfo {
  Offset dir = Offset.zero;
  double power = 0;
  bool visible = false;
}

class BotShot {
  final double x;
  final Offset dir;
  final double speed;
  BotShot(this.x, this.dir, this.speed);
}

class CarromEngine {
  static const double wallMin = 0.06;
  static const double wallMax = 0.94;
  static const double captureDist = 0.052;
  static const double drag = 1.3;
  static const double stopSpeed = 0.02;
  static const double wallE = 0.8;
  static const double pieceE = 0.92;
  static const List<Offset> pockets = [
    Offset(0.07, 0.07),
    Offset(0.93, 0.07),
    Offset(0.07, 0.93),
    Offset(0.93, 0.93),
  ];

  final List<CPiece> pieces = [];
  late CPiece striker;
  double lastImpact = 0;

  CarromEngine() {
    reset();
  }

  List<CPiece> get all => [...pieces, striker];

  bool get anyMoving => all.any((p) => !p.out && p.moving);

  void reset() {
    pieces.clear();
    const c = Offset(0.5, 0.5);
    pieces.add(CPiece(c, CKind.queen));
    final d = 0.027 * 2 * 1.03;
    for (int k = 0; k < 6; k++) {
      final a = k * math.pi / 3 + math.pi / 2;
      // الحلقة الداخلية: أسود وأبيض بالتناوب
      pieces.add(CPiece(
        c + Offset(math.cos(a), math.sin(a)) * d,
        k.isEven ? CKind.black : CKind.white,
      ));
      // الحلقة الخارجية: بيضاء على نفس الزاوية
      pieces.add(CPiece(
        c + Offset(math.cos(a), math.sin(a)) * (2 * d),
        CKind.white,
      ));
      // الحلقة الخارجية: سوداء بين كل قطعتين
      final b = a + math.pi / 6;
      pieces.add(CPiece(
        c + Offset(math.cos(b), math.sin(b)) * (math.sqrt(3) * d),
        CKind.black,
      ));
    }
    striker = CPiece(const Offset(0.5, 0.80), CKind.striker);
  }

  // ---------- الفيزياء ----------
  /// يحرّك المحاكاة ويرجع القطع التي سقطت في الجيوب أثناء هذه الخطوة
  List<CPiece> step(double dt) {
    final newly = <CPiece>[];
    lastImpact = 0;
    const sub = 4;
    final h = dt / sub;
    final items = all;
    for (int s = 0; s < sub; s++) {
      for (final p in items) {
        if (p.out) continue;
        if (p.moving) p.pos = p.pos + p.vel * h;
        _wall(p);
      }
      for (int a = 0; a < items.length; a++) {
        final pa = items[a];
        if (pa.out) continue;
        for (int b = a + 1; b < items.length; b++) {
          final pb = items[b];
          if (pb.out) continue;
          _collide(pa, pb);
        }
      }
      final damp = math.exp(-drag * h);
      for (final p in items) {
        if (p.out || !p.moving) continue;
        p.vel = p.vel * damp;
        if (p.vel.distance < stopSpeed) p.vel = Offset.zero;
        for (final pk in pockets) {
          if ((p.pos - pk).distance < captureDist) {
            p.out = true;
            p.vel = Offset.zero;
            newly.add(p);
            break;
          }
        }
      }
    }
    return newly;
  }

  void _wall(CPiece p) {
    final lo = wallMin + p.r;
    final hi = wallMax - p.r;
    double x = p.pos.dx, y = p.pos.dy, vx = p.vel.dx, vy = p.vel.dy;
    if (x < lo) {
      x = lo;
      if (vx < 0) vx = -vx * wallE;
    } else if (x > hi) {
      x = hi;
      if (vx > 0) vx = -vx * wallE;
    }
    if (y < lo) {
      y = lo;
      if (vy < 0) vy = -vy * wallE;
    } else if (y > hi) {
      y = hi;
      if (vy > 0) vy = -vy * wallE;
    }
    p.pos = Offset(x, y);
    p.vel = Offset(vx, vy);
  }

  void _collide(CPiece a, CPiece b) {
    final d = b.pos - a.pos;
    final dist = d.distance;
    final minD = a.r + b.r;
    if (dist >= minD) return;
    final Offset n = dist < 1e-9 ? const Offset(1, 0) : d / dist;
    final overlap = minD - dist;
    final tm = a.mass + b.mass;
    a.pos = a.pos - n * (overlap * b.mass / tm);
    b.pos = b.pos + n * (overlap * a.mass / tm);
    final rv = (b.vel.dx - a.vel.dx) * n.dx + (b.vel.dy - a.vel.dy) * n.dy;
    if (rv >= 0) return;
    final j = -(1 + pieceE) * rv / (1 / a.mass + 1 / b.mass);
    a.vel = a.vel - n * (j / a.mass);
    b.vel = b.vel + n * (j / b.mass);
    if (-rv > lastImpact) lastImpact = -rv;
  }

  // ---------- أدوات مساعدة ----------
  /// المسافة التي يقطعها القاطع من نقطة o باتجاه dir حتى أول قطعة أو جدار
  double rayDistance(Offset o, Offset dir) {
    double best = 2.0;
    final lo = wallMin + striker.r;
    final hi = wallMax - striker.r;
    if (dir.dx > 1e-9) best = math.min(best, (hi - o.dx) / dir.dx);
    if (dir.dx < -1e-9) best = math.min(best, (lo - o.dx) / dir.dx);
    if (dir.dy > 1e-9) best = math.min(best, (hi - o.dy) / dir.dy);
    if (dir.dy < -1e-9) best = math.min(best, (lo - o.dy) / dir.dy);
    for (final p in pieces) {
      if (p.out) continue;
      final rr = p.r + striker.r;
      final oc = p.pos - o;
      final tca = oc.dx * dir.dx + oc.dy * dir.dy;
      if (tca <= 0) continue;
      final d2 = oc.dx * oc.dx + oc.dy * oc.dy - tca * tca;
      if (d2 > rr * rr) continue;
      final t = tca - math.sqrt(rr * rr - d2);
      if (t > 0 && t < best) best = t;
    }
    return best < 0 ? 0 : best;
  }

  double _segDist(Offset p, Offset a, Offset b) {
    final ab = b - a;
    final l2 = ab.dx * ab.dx + ab.dy * ab.dy;
    if (l2 < 1e-12) return (p - a).distance;
    final t = (((p.dx - a.dx) * ab.dx + (p.dy - a.dy) * ab.dy) / l2).clamp(0.0, 1.0).toDouble();
    return (p - (a + ab * t)).distance;
  }

  bool _pathClear(Offset a, Offset b, double radius, CPiece ignore) {
    for (final p in pieces) {
      if (p.out || identical(p, ignore)) continue;
      if (_segDist(p.pos, a, b) < p.r + radius + 0.004) return false;
    }
    return true;
  }

  bool _free(Offset c, double r, CPiece self) {
    for (final q in all) {
      if (identical(q, self) || q.out) continue;
      if ((q.pos - c).distance < q.r + r + 0.002) return false;
    }
    return true;
  }

  /// يعيد قطعة سقطت (أو الملكة) إلى منتصف اللوحة في أقرب مكان فارغ
  void respawn(CPiece p) {
    p.out = false;
    p.vel = Offset.zero;
    const c = Offset(0.5, 0.5);
    for (int ring = 0; ring < 6; ring++) {
      final n = ring == 0 ? 1 : ring * 8;
      for (int k = 0; k < n; k++) {
        final a = 2 * math.pi * k / n;
        final cand = ring == 0 ? c : c + Offset(math.cos(a), math.sin(a)) * (ring * 0.06);
        if (_free(cand, p.r, p)) {
          p.pos = cand;
          return;
        }
      }
    }
    p.pos = c;
  }

  // ---------- ذكاء اللاعب الآلي (يلعب من الأعلى) ----------
  BotShot planBotShot(CKind own, math.Random rnd) {
    const y = 0.20;
    BotShot? best;
    double bestScore = -1e9;
    final targets = pieces.where((p) => !p.out && (p.kind == own || p.kind == CKind.queen)).toList();
    for (int xi = 0; xi < 9; xi++) {
      final x = 0.24 + xi * 0.06;
      final from = Offset(x, y);
      for (final t in targets) {
        for (final pk in pockets) {
          final toPocket = pk - t.pos;
          final dp = toPocket.distance;
          if (dp < 1e-6) continue;
          final u = toPocket / dp;
          final ghost = t.pos - u * (t.r + striker.r);
          final sv = ghost - from;
          final ds = sv.distance;
          if (ds < 1e-6) continue;
          final dir = sv / ds;
          final cosA = dir.dx * u.dx + dir.dy * u.dy;
          if (cosA < 0.35) continue;
          if (!_pathClear(from, ghost, striker.r, t)) continue;
          if (!_pathClear(t.pos, pk, t.r, t)) continue;
          final score = cosA * 3 - ds - dp * 1.2 + (t.kind == CKind.queen ? 0.3 : 0.0) + rnd.nextDouble() * 0.4;
          if (score > bestScore) {
            bestScore = score;
            final sp = ((ds + dp) * drag * 1.6).clamp(1.4, 3.3).toDouble();
            best = BotShot(x, dir, sp);
          }
        }
      }
    }
    if (best != null) return best;

    // لا توجد تصويبة جيدة: اضرب أقرب قطعة
    final from = Offset(0.5, y);
    CPiece? nearest;
    double nd = 9;
    final pool = pieces.where((p) => !p.out).toList();
    for (final p in pool) {
      final d = (p.pos - from).distance;
      if (d < nd) {
        nd = d;
        nearest = p;
      }
    }
    final target = nearest == null ? const Offset(0.5, 0.5) : nearest.pos;
    final v = target - from;
    final dist = v.distance;
    final dir = dist < 1e-6 ? const Offset(0, 1) : v / dist;
    return BotShot(0.5, dir, 2.0);
  }
}

// ================= CARROM : الواجهة والقواعد =================
class CarromProScreen extends StatefulWidget {
  const CarromProScreen({super.key});

  @override
  State<CarromProScreen> createState() => _CarromProScreenState();
}

class _CarromProScreenState extends State<CarromProScreen> {
  final CarromEngine eng = CarromEngine();
  final math.Random rnd = math.Random();
  Timer? timer;

  bool myTurn = true, over = false, shotActive = false, shotByMe = true;
  int gen = 0;
  int queenBy = 0; // 0 لا أحد ، 1 أنت ، 2 الخصم
  double sliderX = 0.5;
  double boardPx = 300;
  Offset? pullStart, pullNow;
  List<CPiece> shotPocketed = [];
  String msg = 'دورك! اسحب للخلف ثم اترك للتصويب';

  final List<Map<String, String>> messages = [
    {"user": "ابن الاكابر", "text": "مرحباً بالجميع، سأنضم اليكم!"},
    {"user": "رحيل", "text": "بالتوفيق للجميع 🍀"},
  ];

  @override
  void initState() {
    super.initState();
    _placeStriker();
    timer = Timer.periodic(const Duration(milliseconds: 16), (_) => _tick());
  }

  @override
  void dispose() {
    gen++;
    timer?.cancel();
    super.dispose();
  }

  // ---------- حالة اللعبة ----------
  int _count(CKind k, {bool out = false}) =>
      eng.pieces.where((p) => p.kind == k && (!out || p.out)).length;

  int get myScore => _count(CKind.white, out: true) + (queenBy == 1 ? 3 : 0);
  int get botScore => _count(CKind.black, out: true) + (queenBy == 2 ? 3 : 0);

  bool get canShoot => myTurn && !shotActive && !over;

  void _placeStriker() {
    eng.striker.out = false;
    eng.striker.vel = Offset.zero;
    eng.striker.pos = myTurn ? Offset(sliderX, 0.80) : const Offset(0.5, 0.20);
    eng.step(0);
  }

  void _launch(Offset vel, bool byMe) {
    shotByMe = byMe;
    shotPocketed = [];
    eng.striker.vel = vel;
    shotActive = true;
  }

  void _tick() {
    if (!mounted || !shotActive) return;
    final out = eng.step(0.016);
    if (out.isNotEmpty) {
      shotPocketed.addAll(out);
      SoundManager.capture();
    } else if (shotByMe && eng.lastImpact > 1.2) {
      SoundManager.move();
    }
    if (!eng.anyMoving) {
      shotActive = false;
      _resolve();
    }
    setState(() {});
  }

  void _resolve() {
    final mineKind = shotByMe ? CKind.white : CKind.black;
    final who = shotByMe ? 'أنت' : 'الخصم';
    final foul = shotPocketed.any((p) => p.kind == CKind.striker);
    bool gotOwn = false;
    bool queenIn = false;
    for (final p in shotPocketed) {
      if (p.kind == CKind.queen) {
        queenIn = true;
        gotOwn = true;
      } else if (p.kind == mineKind) {
        gotOwn = true;
      }
    }
    String m;
    if (foul) {
      m = 'خطأ! القاطع سقط في الجيب';
      final pen = eng.pieces.where((p) => p.out && p.kind == mineKind).toList();
      if (pen.isNotEmpty) {
        eng.respawn(pen.last);
        m += ' وأُعيدت قطعة للوحة';
      }
      if (queenIn) {
        eng.respawn(eng.pieces.first);
        queenIn = false;
      }
    } else if (gotOwn) {
      m = '$who أسقط قطعة! يلعب مرة أخرى';
    } else if (shotPocketed.isNotEmpty) {
      m = 'سقطت قطعة الخصم، ينتقل الدور';
    } else {
      m = 'لم تسقط أي قطعة';
    }
    if (queenIn) {
      queenBy = shotByMe ? 1 : 2;
      m = '$who أسقط الملكة 👑 +3';
    }

    final whiteLeft = eng.pieces.where((p) => p.kind == CKind.white && !p.out).length;
    final blackLeft = eng.pieces.where((p) => p.kind == CKind.black && !p.out).length;
    if (whiteLeft == 0 || blackLeft == 0) {
      over = true;
      final iWon = whiteLeft == 0;
      msg = iWon ? 'فزت بالمباراة! 🏆' : 'فاز الخصم بالمباراة';
      if (iWon) UserData.addCoins(100);
      eng.striker.out = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        showWinDialog(
          context,
          iWon ? '🏆 مبروك، لقد فزت!' : 'انتهت المباراة',
          iWon ? 'أسقطت كل قطعك البيضاء وربحت 100 عملة.' : 'أسقط الخصم كل قطعه. حاول مرة أخرى!',
          _reset,
        );
      });
      return;
    }

    final extra = gotOwn && !foul;
    myTurn = extra ? shotByMe : !shotByMe;
    _placeStriker();
    msg = '$m — ${myTurn ? 'دورك' : 'دور الخصم'}';
    if (!myTurn) _botTurn();
  }

  Future<void> _botTurn() async {
    final g = gen;
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted || g != gen || over || myTurn) return;
    final shot = eng.planBotShot(CKind.black, rnd);
    eng.striker.pos = Offset(shot.x, 0.20);
    eng.step(0);
    setState(() {});
    await Future.delayed(const Duration(milliseconds: 650));
    if (!mounted || g != gen || over || myTurn) return;
    final a = (rnd.nextDouble() - 0.5) * 0.06;
    final d = shot.dir;
    final rd = Offset(d.dx * math.cos(a) - d.dy * math.sin(a), d.dx * math.sin(a) + d.dy * math.cos(a));
    setState(() {
      _launch(rd * shot.speed, false);
    });
  }

  void _reset() {
    gen++;
    setState(() {
      eng.reset();
      myTurn = true;
      over = false;
      shotActive = false;
      queenBy = 0;
      pullStart = null;
      pullNow = null;
      sliderX = 0.5;
      shotPocketed = [];
      msg = 'دورك! اسحب للخلف ثم اترك للتصويب';
      _placeStriker();
    });
  }

  // ---------- التحكم ----------
  void _panStart(DragStartDetails d) {
    if (!canShoot) return;
    final p = d.localPosition / boardPx;
    setState(() {
      pullStart = p;
      pullNow = p;
    });
  }

  void _panUpdate(DragUpdateDetails d) {
    if (pullStart == null) return;
    setState(() => pullNow = d.localPosition / boardPx);
  }

  void _panEnd(DragEndDetails _) {
    final s = pullStart, n = pullNow;
    setState(() {
      pullStart = null;
      pullNow = null;
    });
    if (s == null || n == null || !canShoot) return;
    final v = s - n;
    final len = v.distance;
    if (len < 0.03) return;
    final power = (len / 0.30).clamp(0.0, 1.0).toDouble();
    final dir = v / len;
    SoundManager.dice();
    setState(() {
      _launch(dir * (0.9 + power * 2.9), true);
      msg = 'تم التصويب...';
    });
  }

  // ---------- الواجهة ----------
  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() => SoundManager.enabled = !SoundManager.enabled);
                },
                child: _topBtn(SoundManager.enabled ? Icons.vibration : Icons.volume_off),
              ),
              const SizedBox(width: 8),
              GestureDetector(onTap: _reset, child: _topBtn(Icons.refresh)),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(12)),
                  child: Text(
                    msg,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 5,
          child: Center(
            child: LayoutBuilder(builder: (c, cons) {
              final bs = math.min(screenW - 24, cons.maxHeight);
              if (bs <= 0) return const SizedBox.shrink();
              boardPx = bs;
              return GestureDetector(
                onPanStart: _panStart,
                onPanUpdate: _panUpdate,
                onPanEnd: _panEnd,
                onPanCancel: () => setState(() {
                  pullStart = null;
                  pullNow = null;
                }),
                child: Container(
                  width: bs,
                  height: bs,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDEB887),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFFFFD700), width: 3.5),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 10, spreadRadius: 2)],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      children: [
                        const Positioned.fill(child: CustomPaint(painter: CarromBoardPainter())),
                        ...eng.pieces.where((p) => !p.out).map((p) => _pieceWidget(p, bs)),
                        if (!eng.striker.out) _pieceWidget(eng.striker, bs),
                        if (_aim(bs) != null) Positioned.fill(child: CustomPaint(painter: _aim(bs))),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        // شريط تحريك القاطع
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 0),
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 14,
              activeTrackColor: const Color(0xFF883344),
              inactiveTrackColor: const Color(0xFF883344),
              disabledActiveTrackColor: const Color(0xFF55303A),
              disabledInactiveTrackColor: const Color(0xFF55303A),
              thumbColor: Colors.pinkAccent,
              disabledThumbColor: Colors.pink.shade200.withOpacity(0.4),
              overlayShape: SliderComponentShape.noOverlay,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
            ),
            child: Slider(
              value: sliderX,
              min: 0.22,
              max: 0.78,
              onChanged: canShoot
                  ? (v) => setState(() {
                        sliderX = v;
                        _placeStriker();
                      })
                  : null,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              PlayerBadge(name: 'أنت ⚪', color: Colors.blueGrey, badge: '$myScore', active: myTurn && !over),
              Text('${_count(CKind.white, out: true)} / ${_count(CKind.white)}   ·   ${_count(CKind.black, out: true)} / ${_count(CKind.black)}',
                  style: const TextStyle(color: Colors.white54, fontSize: 11)),
              PlayerBadge(name: 'الخصم ⚫', color: Colors.deepPurple, badge: '$botScore', active: !myTurn && !over),
            ],
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.25), borderRadius: BorderRadius.circular(12)),
            child: ListView(
              reverse: true,
              children: messages.reversed
                  .map((m) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2D1B36),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Text(
                                  "${m['user']}: ${m['text']}",
                                  style: const TextStyle(color: Colors.white, fontSize: 12),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.white54,
                              child: Icon(Icons.person, size: 14, color: Colors.black),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),
        ),
        ChatAndControlsBar(
          onSendChat: (txt) {
            setState(() => messages.add({"user": "أنت", "text": txt}));
            Future.delayed(const Duration(milliseconds: 1200), () {
              if (!mounted) return;
              setState(() => messages.add({"user": "رحيل", "text": BotChat.random()}));
            });
          },
          onSendEmoji: (em) => setState(() => messages.add({"user": "أنت", "text": em})),
          onSendRose: () => showRoseFeedback(context),
        ),
      ],
    );
  }

  Widget _topBtn(IconData i) => Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(8)),
        child: Icon(i, color: Colors.white70, size: 18),
      );

  _CarromAimPainter? _aim(double bs) {
    final s = pullStart, n = pullNow;
    if (s == null || n == null || !canShoot) return null;
    final v = s - n;
    final len = v.distance;
    if (len < 0.015) return null;
    final dir = v / len;
    final from = eng.striker.pos;
    final dist = eng.rayDistance(from, dir);
    final power = (len / 0.30).clamp(0.0, 1.0).toDouble();
    return _CarromAimPainter(from * bs, (from + dir * dist) * bs, eng.striker.r * bs, power);
  }

  Widget _pieceWidget(CPiece p, double bs) {
    final d = p.r * 2 * bs;
    late List<Color> cols;
    Color border;
    switch (p.kind) {
      case CKind.white:
        cols = [Colors.white, const Color(0xFFEFE6D2)];
        border = Colors.black38;
        break;
      case CKind.black:
        cols = [const Color(0xFF555555), const Color(0xFF111111)];
        border = Colors.black87;
        break;
      case CKind.queen:
        cols = [const Color(0xFFFF6B6B), const Color(0xFFC62828)];
        border = Colors.white70;
        break;
      case CKind.striker:
        cols = [const Color(0xFFFF9EC0), const Color(0xFFE91E63)];
        border = Colors.white;
        break;
    }
    final isStriker = p.kind == CKind.striker;
    return Positioned(
      left: p.pos.dx * bs - d / 2,
      top: p.pos.dy * bs - d / 2,
      width: d,
      height: d,
      child: IgnorePointer(
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(center: const Alignment(-0.3, -0.3), colors: cols),
            border: Border.all(color: border, width: isStriker ? 2 : 1),
            boxShadow: [
              BoxShadow(
                color: isStriker ? const Color(0xFFFFD700).withOpacity(0.8) : Colors.black38,
                blurRadius: isStriker ? 8 : 2,
                spreadRadius: isStriker ? 1.5 : 0,
                offset: isStriker ? Offset.zero : const Offset(0, 1),
              ),
            ],
          ),
          child: p.kind == CKind.striker || p.kind == CKind.queen
              ? null
              : Center(
                  child: Container(
                    width: d * 0.55,
                    height: d * 0.55,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: border.withOpacity(0.35), width: 1),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

class _CarromAimPainter extends CustomPainter {
  final Offset from, to;
  final double r, power;
  _CarromAimPainter(this.from, this.to, this.r, this.power);

  @override
  void paint(Canvas canvas, Size size) {
    final col = Color.lerp(Colors.greenAccent, Colors.redAccent, power)!;
    final paint = Paint()
      ..color = col.withOpacity(0.9)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    final total = (to - from).distance;
    if (total < 1) return;
    final dir = (to - from) / total;
    double t = r;
    while (t < total) {
      final a = from + dir * t;
      final b = from + dir * math.min(t + 7, total);
      canvas.drawLine(a, b, paint);
      t += 14;
    }
    canvas.drawCircle(
      to,
      r,
      Paint()
        ..color = col.withOpacity(0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    // مؤشر القوة خلف القاطع
    final back = from - dir * (r + 8 + power * 40);
    canvas.drawLine(from - dir * (r + 4), back, paint..strokeWidth = 4);
  }

  @override
  bool shouldRepaint(covariant _CarromAimPainter old) => true;
}

class CarromBoardPainter extends CustomPainter {
  const CarromBoardPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final gold = const Color(0xFFD4AF37);

    // سطح اللعب
    final play = Rect.fromLTRB(w * 0.06, h * 0.06, w * 0.94, h * 0.94);
    canvas.drawRect(play, Paint()..color = const Color(0xFFF2D9A6));
    canvas.drawRect(
      play,
      Paint()
        ..color = const Color(0xFF8B5A2B)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );

    final line = Paint()
      ..color = gold.withOpacity(0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final dot = Paint()..color = gold;

    // مستطيل داخلي
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.15, h * 0.15, w * 0.7, h * 0.7), const Radius.circular(16)),
      line,
    );

    // خطوط التصويب العلوية والسفلية
    for (final y in [0.20, 0.80]) {
      canvas.drawLine(Offset(w * 0.22, h * y), Offset(w * 0.78, h * y), line);
      for (final x in [0.22, 0.78]) {
        canvas.drawCircle(Offset(w * x, h * y), 5, line);
        canvas.drawCircle(Offset(w * x, h * y), 1.8, dot);
      }
    }
    // خطوط جانبية
    for (final x in [0.20, 0.80]) {
      canvas.drawLine(Offset(w * x, h * 0.22), Offset(w * x, h * 0.78), line);
    }

    // الدائرة المركزية
    canvas.drawCircle(Offset(w / 2, h / 2), w * 0.12, line);
    canvas.drawCircle(Offset(w / 2, h / 2), w * 0.035, line);

    // الجيوب
    for (final pk in CarromEngine.pockets) {
      final c = Offset(pk.dx * w, pk.dy * h);
      canvas.drawCircle(c, w * 0.052, Paint()..color = const Color(0xFF111111));
      canvas.drawCircle(
        c,
        w * 0.052,
        Paint()
          ..color = const Color(0xFF5D4037)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ================= SNAKE & LADDER =================
const Map<int, int> kSnakes = {99: 54, 70: 55, 52: 42, 56: 8, 43: 17};
const Map<int, int> kLadders = {3: 51, 6: 27, 20: 70, 36: 55, 63: 95};
const List<Color> kSnakeColors = [Color(0xFFE53935), Color(0xFFFBC02D), Color(0xFF43A047), Color(0xFF1E88E5)];

/// مركز الخانة بوحدات الخانة (0..10)
Offset snakeCellCenter(int n) {
  if (n <= 0) return const Offset(0.5, 10.4);
  final idx = n - 1;
  final row = idx ~/ 10;
  int col = idx % 10;
  if (row.isOdd) col = 9 - col;
  return Offset(col + 0.5, (9 - row) + 0.5);
}

class SnakeBoardPainter extends CustomPainter {
  const SnakeBoardPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final ce = size.width / 10;
    for (int n = 1; n <= 100; n++) {
      final c = snakeCellCenter(n);
      final r = Rect.fromLTWH((c.dx - 0.5) * ce, (c.dy - 0.5) * ce, ce, ce);
      Color bg = (n % 2 == 0) ? const Color(0xFFFFF8E1) : const Color(0xFFFFECB3);
      if (kSnakes.containsKey(n)) bg = const Color(0xFFFFCDD2);
      if (kLadders.containsKey(n)) bg = const Color(0xFFC8E6C9);
      if (n == 100) bg = const Color(0xFFFFD54F);
      canvas.drawRect(r, Paint()..color = bg);
      canvas.drawRect(
        r,
        Paint()
          ..color = Colors.black12
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.4,
      );
      final tp = TextPainter(
        text: TextSpan(text: '$n', style: const TextStyle(fontSize: 8, color: Colors.black54)),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(r.left + 2, r.top + 1));
    }

    // السلالم
    kLadders.forEach((a, b) {
      final p1 = snakeCellCenter(a) * ce;
      final p2 = snakeCellCenter(b) * ce;
      final v = p2 - p1;
      final len = v.distance;
      final d = v / len;
      final nrm = Offset(-d.dy, d.dx) * (ce * 0.16);
      final rail = Paint()
        ..color = const Color(0xFF6D4C41)
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(p1 + nrm, p2 + nrm, rail);
      canvas.drawLine(p1 - nrm, p2 - nrm, rail);
      final rung = Paint()
        ..color = const Color(0xFF8D6E63)
        ..strokeWidth = 2.5;
      for (double t = ce * 0.4; t < len; t += ce * 0.45) {
        final c = p1 + d * t;
        canvas.drawLine(c + nrm, c - nrm, rung);
      }
    });

    // الثعابين
    int k = 0;
    kSnakes.forEach((a, b) {
      final head = snakeCellCenter(a) * ce;
      final tail = snakeCellCenter(b) * ce;
      final v = tail - head;
      final len = v.distance;
      final d = v / len;
      final nrm = Offset(-d.dy, d.dx);
      final sign = k.isEven ? 1.0 : -1.0;
      k++;
      final amp = ce * 0.9 * sign;
      final path = Path()..moveTo(head.dx, head.dy);
      const seg = 24;
      for (int i = 1; i <= seg; i++) {
        final t = i / seg;
        final off = math.sin(t * math.pi * 3) * amp * (1 - 0.3 * t);
        final pt = head + v * t + nrm * off;
        path.lineTo(pt.dx, pt.dy);
      }
      canvas.drawPath(
        path,
        Paint()
          ..color = const Color(0xFF2E7D32)
          ..style = PaintingStyle.stroke
          ..strokeWidth = ce * 0.22
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
      canvas.drawPath(
        path,
        Paint()
          ..color = const Color(0xFF81C784)
          ..style = PaintingStyle.stroke
          ..strokeWidth = ce * 0.08
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
      canvas.drawCircle(head, ce * 0.2, Paint()..color = const Color(0xFF1B5E20));
      canvas.drawCircle(head + const Offset(-3, -2), 2, Paint()..color = Colors.white);
      canvas.drawCircle(head + const Offset(3, -2), 2, Paint()..color = Colors.white);
      canvas.drawCircle(head + const Offset(-3, -2), 1, Paint()..color = Colors.black);
      canvas.drawCircle(head + const Offset(3, -2), 1, Paint()..color = Colors.black);
      canvas.drawCircle(tail, ce * 0.07, Paint()..color = const Color(0xFF2E7D32));
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class SnakeLadderRoyal extends StatefulWidget {
  const SnakeLadderRoyal({super.key});

  @override
  State<SnakeLadderRoyal> createState() => _SnakeState();
}

class _SnakeState extends State<SnakeLadderRoyal> {
  static const List<String> names = ['أنت', 'سلطان', 'نورة', 'ليث'];
  final math.Random rnd = math.Random();

  int dice = 1, turn = 0, gen = 0;
  bool rolling = false, busy = false, gameOver = false;
  List<int> pos = [0, 0, 0, 0];
  String msg = 'اضغط على النرد لتبدأ';
  final List<String> publicChat = ['نورة: بالتوفيق للجميع 🍀'];

  bool get canRoll => turn == 0 && !rolling && !busy && !gameOver;

  @override
  void dispose() {
    gen++;
    super.dispose();
  }

  void roll() {
    if (turn != 0) return;
    _doRoll();
  }

  Future<void> _doRoll() async {
    if (rolling || busy || gameOver) return;
    final g = gen;
    setState(() {
      rolling = true;
      msg = turn == 0 ? 'جاري رمي النرد...' : '${names[turn]} يرمي النرد...';
    });
    SoundManager.dice();
    for (int i = 0; i < 8; i++) {
      await Future.delayed(const Duration(milliseconds: 70));
      if (!mounted || g != gen) return;
      setState(() => dice = rnd.nextInt(6) + 1);
    }
    final value = rnd.nextInt(6) + 1;
    setState(() {
      dice = value;
      rolling = false;
      busy = true;
    });
    await _play(value);
  }

  Future<void> _play(int value) async {
    final g = gen;
    final p = turn;
    bool extra = value == 6;
    if (pos[p] + value > 100) {
      setState(() => msg = '${names[p]} يحتاج رقماً أقل للوصول إلى 100');
      extra = false;
    } else {
      for (int s = 0; s < value; s++) {
        await Future.delayed(const Duration(milliseconds: 170));
        if (!mounted || g != gen) return;
        setState(() => pos[p] = pos[p] + 1);
        if (p == 0) SoundManager.move();
      }
      final here = pos[p];
      if (kLadders.containsKey(here)) {
        await Future.delayed(const Duration(milliseconds: 350));
        if (!mounted || g != gen) return;
        setState(() {
          pos[p] = kLadders[here]!;
          msg = '${names[p]} صعد سلماً 🪜 إلى ${pos[p]}';
        });
        SoundManager.capture();
      } else if (kSnakes.containsKey(here)) {
        await Future.delayed(const Duration(milliseconds: 350));
        if (!mounted || g != gen) return;
        setState(() {
          pos[p] = kSnakes[here]!;
          msg = '${names[p]} لدغه ثعبان 🐍 إلى ${pos[p]}';
        });
        SoundManager.capture();
        extra = false;
      } else {
        setState(() => msg = '${names[p]} وصل إلى $here');
      }
    }

    if (pos[p] == 100) {
      setState(() {
        gameOver = true;
        busy = false;
        msg = 'فاز ${names[p]}!';
      });
      if (p == 0) UserData.addCoins(100);
      if (!mounted) return;
      showWinDialog(
        context,
        p == 0 ? '🏆 مبروك، لقد فزت!' : 'انتهت اللعبة',
        p == 0 ? 'ربحت 100 عملة. هل تلعب مرة أخرى؟' : 'الفائز هو ${names[p]}. حظاً أوفر!',
        _reset,
      );
      return;
    }

    await Future.delayed(const Duration(milliseconds: 650));
    if (!mounted || g != gen) return;
    setState(() {
      if (!extra) turn = (turn + 1) % 4;
      busy = false;
    });
    if (turn != 0) {
      await Future.delayed(const Duration(milliseconds: 400));
      if (!mounted || g != gen) return;
      _doRoll();
    } else {
      setState(() => msg = 'دورك! اضغط على النرد');
    }
  }

  void _reset() {
    gen++;
    setState(() {
      pos = [0, 0, 0, 0];
      turn = 0;
      dice = 1;
      rolling = false;
      busy = false;
      gameOver = false;
      msg = 'اضغط على النرد لتبدأ';
    });
  }

  List<Widget> _tokens(double ce) {
    final res = <Widget>[];
    for (int p = 0; p < 4; p++) {
      final c = snakeCellCenter(pos[p]);
      final ox = ((p % 2) - 0.5) * 0.34;
      final oy = ((p ~/ 2) - 0.5) * 0.34;
      final sz = ce * 0.34;
      res.add(AnimatedPositioned(
        key: ValueKey('sl$p'),
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        left: (c.dx + ox) * ce - sz / 2,
        top: (c.dy + oy) * ce - sz / 2,
        width: sz,
        height: sz,
        child: IgnorePointer(
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: kSnakeColors[p],
              border: Border.all(color: turn == p ? const Color(0xFFFFD700) : Colors.white, width: turn == p ? 2.5 : 1.5),
              boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 3)],
            ),
          ),
        ),
      ));
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(8)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(msg,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.amber, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 8),
              Text('الدور: ${names[turn]}', style: const TextStyle(color: Colors.white, fontSize: 11)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              4,
              (p) => PlayerBadge(
                name: names[p],
                color: kSnakeColors[p],
                badge: '${pos[p]}',
                active: turn == p && !gameOver,
              ),
            ),
          ),
        ),
        Expanded(
          child: LayoutBuilder(builder: (context, cons) {
            final bs = math.min(cons.maxWidth - 16, cons.maxHeight - 8);
            if (bs <= 0) return const SizedBox.shrink();
            return Center(
              child: Container(
                width: bs,
                height: bs,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFFFD700), width: 3),
                  boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 10)],
                ),
                child: LayoutBuilder(builder: (c, inner) {
                  final ce = inner.maxWidth / 10;
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Positioned.fill(child: CustomPaint(painter: SnakeBoardPainter())),
                      ..._tokens(ce),
                    ],
                  );
                }),
              ),
            );
          }),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: DiceFace(
            value: dice,
            size: 54,
            accent: kSnakeColors[turn],
            active: canRoll,
            rolling: rolling,
            onTap: roll,
          ),
        ),
        ChatTicker(messages: publicChat),
        ChatAndControlsBar(
          onSendChat: (txt) {
            setState(() => publicChat.add('أنت: $txt'));
            Future.delayed(const Duration(milliseconds: 1200), () {
              if (!mounted) return;
              setState(() => publicChat.add('${names[1 + rnd.nextInt(3)]}: ${BotChat.random()}'));
            });
          },
          onSendEmoji: (em) => setState(() => publicChat.add('أنت: $em')),
          onSendRose: () => showRoseFeedback(context),
        ),
      ],
    );
  }
}
