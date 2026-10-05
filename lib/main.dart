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
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFF0F172A)),
      home: const HomeScreen(),
    );
  }
}

class UserData {
  static int coins = 1200;
  static int freeRoses = 5;
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int tab = 0;
  final List<Widget> pages = const [
    LudoRoyalFull(),
    CarromProLikeImage(),
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
              child: Row(
                children: [
                  const Icon(Icons.monetization_on, color: Colors.amber, size: 20),
                  const SizedBox(width: 4),
                  Text('${UserData.coins}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.diamond, color: Colors.amber),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ShopScreen()),
              );
              setState(() {});
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
                  setState(() {
                    UserData.coins += addCoins;
                    UserData.freeRoses += addRoses;
                  });
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

class SoundManager {
  static void dice() => HapticFeedback.mediumImpact();
  static void move() => HapticFeedback.lightImpact();
  static void capture() => HapticFeedback.heavyImpact();
}

class ChatAndControlsBar extends StatefulWidget {
  final Function(String) onSendChat;
  final Function(String) onSendEmoji;
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
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      color: const Color(0xFF0F172A),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // شريط الإيموجي والمايك والورود
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                IconButton(
                  icon: Icon(isMuted ? Icons.mic_off : Icons.mic, color: isMuted ? Colors.red : Colors.green),
                  onPressed: () {
                    setState(() => isMuted = !isMuted);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(isMuted ? 'تم كتم المايك' : 'تم فتح المايك الصوتي')),
                    );
                  },
                ),
                IconButton(
                  icon: const Text("🌹", style: TextStyle(fontSize: 18)),
                  onPressed: widget.onSendRose,
                ),
                ...emojis.map((e) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      actionChip: null,
                      child: ActionChip(
                        backgroundColor: const Color(0xFF1E293B),
                        label: Text(e, style: const TextStyle(fontSize: 14)),
                        onPressed: () => widget.onSendEmoji(e),
                      ),
                    )),
              ],
            ),
          ),
          // شريط إدخال الدردشة العامة والخاصة
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: chatCtrl,
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
                onPressed: () {
                  if (chatCtrl.text.isNotEmpty) {
                    widget.onSendChat(chatCtrl.text);
                    chatCtrl.clear();
                  }
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}

// ================= LUDO =================
class LudoRoyalFull extends StatefulWidget {
  const LudoRoyalFull({super.key});

  @override
  State<LudoRoyalFull> createState() => _LudoState();
}

class _LudoState extends State<LudoRoyalFull> {
  int dice = 6, turn = 0;
  bool canRoll = true, gameOver = false;
  String msg = "غرفة الانتظار: اللاعبون متصلون (4/4)";
  List<List<int>> tokens = [
    [-1, -1, -1, -1],
    [-1, -1, -1, -1],
    [-1, -1, -1, -1],
    [-1, -1, -1, -1]
  ];
  List<int> start = [0, 39, 13, 26];
  List<List<int>> homePath = [
    [52, 53, 54, 55, 56, 57],
    [58, 59, 60, 61, 62, 63],
    [64, 65, 66, 67, 68, 69],
    [70, 71, 72, 73, 74, 75]
  ];
  List<String> publicChat = ["P3: هلا بالجميع 💪", "Me: أهلاً بكم"];

  List<Offset> path = [
    const Offset(6, 1), const Offset(6, 2), const Offset(6, 3), const Offset(6, 4), const Offset(6, 5),
    const Offset(5, 6), const Offset(4, 6), const Offset(3, 6), const Offset(2, 6), const Offset(1, 6), const Offset(0, 6),
    const Offset(0, 7), const Offset(0, 8), const Offset(1, 8), const Offset(2, 8), const Offset(3, 8), const Offset(4, 8), const Offset(5, 8),
    const Offset(6, 9), const Offset(6, 10), const Offset(6, 11), const Offset(6, 12), const Offset(6, 13), const Offset(6, 14),
    const Offset(7, 14), const Offset(8, 14), const Offset(8, 13), const Offset(8, 12), const Offset(8, 11), const Offset(8, 10), const Offset(8, 9),
    const Offset(9, 8), const Offset(10, 8), const Offset(11, 8), const Offset(12, 8), const Offset(13, 8), const Offset(14, 8),
    const Offset(14, 7), const Offset(14, 6), const Offset(13, 6), const Offset(12, 6), const Offset(11, 6), const Offset(10, 6), const Offset(9, 6),
    const Offset(8, 5), const Offset(8, 4), const Offset(8, 3), const Offset(8, 2), const Offset(8, 1), const Offset(8, 0),
    const Offset(7, 0), const Offset(6, 0)
  ];
  Map<int, Offset> homeC = {
    52: const Offset(7, 1), 53: const Offset(7, 2), 54: const Offset(7, 3), 55: const Offset(7, 4), 56: const Offset(7, 5), 57: const Offset(7, 6),
    58: const Offset(13, 7), 59: const Offset(12, 7), 60: const Offset(11, 7), 61: const Offset(10, 7), 62: const Offset(9, 7), 63: const Offset(8, 7),
    64: const Offset(1, 7), 65: const Offset(2, 7), 66: const Offset(3, 7), 67: const Offset(4, 7), 68: const Offset(5, 7), 69: const Offset(6, 7),
    70: const Offset(7, 13), 71: const Offset(7, 12), 72: const Offset(7, 11), 73: const Offset(7, 10), 74: const Offset(7, 9), 75: const Offset(7, 8)
  };

  void roll() {
    if (!canRoll || gameOver) return;
    setState(() {
      dice = math.Random().nextInt(6) + 1;
      canRoll = false;
    });
    SoundManager.dice();
    bool can = tokens[turn].any((e) => e >= 0 || (e == -1 && dice == 6));
    if (!can) {
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          setState(() {
            turn = (turn + 1) % 4;
            canRoll = true;
          });
        }
      });
    }
  }

  void moveToken(int p, int idx) {
    if (p != turn || canRoll || gameOver) return;
    int cur = tokens[p][idx];
    if (cur == -1 && dice != 6) return;
    setState(() {
      if (cur == -1) {
        tokens[p][idx] = start[p];
      } else if (cur >= 0 && cur < 52) {
        int entry = (start[p] + 51) % 52;
        int next = cur + dice;
        if (cur <= entry && next > entry) {
          int h = next - entry - 1;
          tokens[p][idx] = h < 6 ? homePath[p][h] : h == 6 ? 100 : next % 52;
        } else {
          tokens[p][idx] = next % 52;
        }
      } else if (cur >= 52) {
        int hi = homePath[p].indexOf(cur);
        if (hi != -1 && hi + dice <= 6) {
          tokens[p][idx] = hi + dice == 6 ? 100 : homePath[p][hi + dice];
        }
      }
      if (dice != 6) turn = (turn + 1) % 4;
      canRoll = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Color> cols = [
      const Color(0xFFE53935),
      const Color(0xFFFBC02D),
      const Color(0xFF43A047),
      const Color(0xFF1E88E5)
    ];
    double boardSize = MediaQuery.of(context).size.width - 16;
    return Column(
      children: [
        // غرفة الانتظار مباشرة في الأعلى
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(8)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(msg, style: const TextStyle(color: Colors.amber, fontSize: 11, fontWeight: FontWeight.bold)),
              Text('الدور: لاعب ${turn + 1}', style: const TextStyle(color: Colors.white, fontSize: 11)),
            ],
          ),
        ),
        // لوحة اللعب الرئيسية
        Expanded(
          child: Center(
            child: Container(
              width: boardSize,
              height: boardSize,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFFFD700), width: 3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: LayoutBuilder(builder: (c, cons) {
                double ce = cons.maxWidth / 15;
                List<Widget> tw = [];
                for (int p = 0; p < 4; p++) {
                  for (int t = 0; t < 4; t++) {
                    int bp = tokens[p][t];
                    Offset pt;
                    if (bp == -1) {
                      // توزيع قطع الـ 4 لكل قاعدة لونية
                      double dx = (t == 0 || t == 2) ? 1.5 : 3.5;
                      double dy = (t < 2) ? (p == 0 ? 1.5 : (p == 2 ? 1.5 : 10.5)) : (p == 0 ? 3.5 : 12.5);
                      if (p == 1) dx += 9;
                      if (p == 2) { dx += 9; dy += 9; }
                      if (p == 3) { dy += 9; }
                      pt = Offset(dx, dy);
                    } else if (bp >= 100) {
                      pt = const Offset(7.5, 7.5);
                    } else if (homeC.containsKey(bp)) {
                      pt = Offset(homeC[bp]!.dy, homeC[bp]!.dx);
                    } else {
                      var o = path[bp % 52];
                      pt = Offset(o.dy, o.dx);
                    }
                    double sz = ce * 0.7;
                    tw.add(Positioned(
                      left: pt.dx * ce + ce / 2 - sz / 2,
                      top: pt.dy * ce + ce / 2 - sz / 2,
                      child: GestureDetector(
                        onTap: () => moveToken(p, t),
                        child: Container(
                          width: sz,
                          height: sz,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: cols[p],
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                          child: const Center(
                            child: Text("✈", style: TextStyle(color: Colors.white, fontSize: 8)),
                          ),
                        ),
                      ),
                    ));
                  }
                }
                List<Widget> grid = List.generate(225, (i) {
                  int r = i ~/ 15, co = i % 15;
                  Color bg = const Color(0xFFFFF8E1);
                  if (r < 6 && co < 6) bg = cols[0];
                  if (r < 6 && co > 8) bg = cols[2];
                  if (r > 8 && co < 6) bg = cols[1];
                  if (r > 8 && co > 8) bg = cols[3];
                  return Container(decoration: BoxDecoration(color: bg, border: Border.all(color: Colors.black12, width: 0.2)));
                });
                return Stack(
                  children: [
                    GridView.count(crossAxisCount: 15, physics: const NeverScrollableScrollPhysics(), padding: EdgeInsets.zero, children: grid),
                    ...tw,
                    if (canRoll)
                      Center(
                        child: GestureDetector(
                          onTap: roll,
                          child: Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const RadialGradient(colors: [Color(0xFFFFD700), Color(0xFFFF6F00)]),
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("$dice", style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
                                const Text("نرد", style: TextStyle(color: Colors.white, fontSize: 9)),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              }),
            ),
          ),
        ),
        // شريط الشات والإيموجي والمايك والورود في الأسفل
        ChatAndControlsBar(
          onSendChat: (txt) => setState(() => publicChat.add("Me: $txt")),
          onSendEmoji: (em) => setState(() => publicChat.add("Me: $em")),
          onSendRose: () {
            if (UserData.freeRoses > 0) {
              setState(() => UserData.freeRoses--);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('🌹 تم إرسال وردة يومية بنجاح!')));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('نفدت الوردات المجانية')));
            }
          },
        ),
      ],
    );
  }
}

// ================= CARROM =================
class CarromProLikeImage extends StatefulWidget {
  const CarromProLikeImage({super.key});

  @override
  State<CarromProLikeImage> createState() => _CarromState();
}

class _CarromState extends State<CarromProLikeImage> {
  List<CarromPiece> pieces = [];
  CarromPiece striker = CarromPiece(const Offset(0.5, 0.82), const Color(0xFFFF1744), false, isStriker: true);
  Offset? ds, de;
  Timer? t;
  bool over = false;
  List<String> publicChat = [];

  @override
  void initState() {
    super.initState();
    reset();
    t = Timer.periodic(const Duration(milliseconds: 16), (x) => phys());
  }

  void reset() {
    pieces = [
      CarromPiece(const Offset(0.5, 0.5), Colors.black, false, isQueen: true),
      CarromPiece(const Offset(0.5, 0.42), Colors.white, true),
      CarromPiece(const Offset(0.45, 0.45), Colors.white, true),
      CarromPiece(const Offset(0.55, 0.45), Colors.white, true),
      CarromPiece(const Offset(0.42, 0.50), Colors.white, true),
      CarromPiece(const Offset(0.58, 0.50), Colors.white, true),
      CarromPiece(const Offset(0.5, 0.58), Colors.brown, false),
    ];
    over = false;
  }

  void phys() {
    if (!mounted || over) return;
    setState(() {
      for (var p in [...pieces, striker]) {
        if (p.vel == Offset.zero) continue;
        p.pos += p.vel * 0.016;
        p.vel *= 0.985;
        if (p.vel.distance < 0.002) p.vel = Offset.zero;
        if (p.pos.dx < 0.08 || p.pos.dx > 0.92) {
          p.vel = Offset(-p.vel.dx, p.vel.dy);
          p.pos = Offset(p.pos.dx.clamp(0.08, 0.92), p.pos.dy);
        }
        if (p.pos.dy < 0.08 || p.pos.dy > 0.92) {
          p.vel = Offset(p.vel.dx, -p.vel.dy);
          p.pos = Offset(p.pos.dx, p.pos.dy.clamp(0.08, 0.92));
        }
      }
      // 6 جيوب في الأركان والمنتصف
      pieces.removeWhere((p) =>
          (p.pos - const Offset(0.09, 0.09)).distance < 0.05 ||
          (p.pos - const Offset(0.91, 0.09)).distance < 0.05 ||
          (p.pos - const Offset(0.09, 0.91)).distance < 0.05 ||
          (p.pos - const Offset(0.91, 0.91)).distance < 0.05 ||
          (p.pos - const Offset(0.09, 0.5)).distance < 0.05 ||
          (p.pos - const Offset(0.91, 0.5)).distance < 0.05);
    });
  }

  @override
  void dispose() {
    t?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(8)),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("غرفة كيرم المحترفين (الجيوب الستة مفعلة)", style: TextStyle(color: Colors.amber, fontSize: 11, fontWeight: FontWeight.bold)),
              Text("الدور: أنت", style: TextStyle(color: Colors.white, fontSize: 11)),
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: LayoutBuilder(builder: (c, cons) {
              double boardSize = math.min(cons.maxWidth - 16, cons.maxHeight * 0.75);
              return GestureDetector(
                onPanStart: (d) => ds = Offset(d.localPosition.dx / boardSize, d.localPosition.dy / boardSize),
                onPanUpdate: (d) => setState(() => de = Offset(d.localPosition.dx / boardSize, d.localPosition.dy / boardSize)),
                onPanEnd: (_) {
                  if (ds != null && de != null) {
                    var dir = de! - ds!;
                    striker.vel = dir * 22;
                  }
                  ds = null;
                  de = null;
                },
                child: Container(
                  width: boardSize,
                  height: boardSize,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDEB887),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFFFD700), width: 3),
                  ),
                  child: Stack(
                    children: [
                      CustomPaint(size: Size(boardSize, boardSize), painter: CarromImagePainter()),
                      ...pieces.map((p) {
                        // تصغير حجم الكور بنسبة 30% (القطر الأصلي 28 أصبح ~20)
                        double size = 20.0;
                        return Positioned(
                          left: p.pos.dx * boardSize - size / 2,
                          top: p.pos.dy * boardSize - size / 2,
                          child: Container(
                            width: size,
                            height: size,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: p.isQueen ? Colors.black : p.isWhite ? Colors.white : Colors.brown,
                              border: Border.all(color: Colors.black26, width: 1),
                            ),
                          ),
                        );
                      }),
                      Positioned(
                        left: striker.pos.dx * boardSize - 14,
                        top: striker.pos.dy * boardSize - 14,
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.pink,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                      if (ds != null && de != null) CustomPaint(size: Size(boardSize, boardSize), painter: AimPainter(ds! * boardSize, de! * boardSize)),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4)),
            onPressed: () => setState(reset),
            icon: const Icon(Icons.refresh, color: Colors.black, size: 16),
            label: const Text("إعادة تعيين الكيرم", style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ),
        ChatAndControlsBar(
          onSendChat: (txt) => setState(() => publicChat.add("Me: $txt")),
          onSendEmoji: (em) => setState(() => publicChat.add("Me: $em")),
          onSendRose: () {
            if (UserData.freeRoses > 0) {
              setState(() => UserData.freeRoses--);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('🌹 تم إرسال وردة يومية!')));
            }
          },
        ),
      ],
    );
  }
}

class CarromImagePainter extends CustomPainter {
  @override
  void paint(Canvas c, Size s) {
    final p = Paint()
      ..color = const Color(0xFF8D6E63).withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    c.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(s.width * 0.14, s.width * 0.14, s.width * 0.72, s.height * 0.72),
        const Radius.circular(20),
      ),
      p,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class AimPainter extends CustomPainter {
  final Offset from, to;
  AimPainter(this.from, this.to);

  @override
  void paint(Canvas c, Size s) {
    c.drawLine(from, to, Paint()..color = Colors.white..strokeWidth = 2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ================= SNAKE =================
class SnakeLadderRoyal extends StatefulWidget {
  const SnakeLadderRoyal({super.key});

  @override
  State<SnakeLadderRoyal> createState() => _SnakeState();
}

class _SnakeState extends State<SnakeLadderRoyal> {
  int dice = 1, turn = 0;
  bool canRoll = true;
  List<int> pos = [0, 0, 0, 0];
  Map<int, int> snakes = {99: 54, 70: 55, 52: 42, 56: 8, 43: 17};
  Map<int, int> ladders = {3: 51, 6: 27, 20: 70, 36: 55, 63: 95};
  List<String> publicChat = [];

  void roll() {
    if (!canRoll) return;
    setState(() {
      dice = math.Random().nextInt(6) + 1;
      canRoll = false;
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      setState(() {
        int n = pos[turn] + dice;
        if (n <= 100) {
          pos[turn] = snakes[n] ?? ladders[n] ?? n;
          if (n == 100) pos = [0, 0, 0, 0];
        }
        turn = (turn + 1) % 4;
        canRoll = true;
      });
    });
  }

  Widget cell(int num) {
    bool sn = snakes.containsKey(num), lad = ladders.containsKey(num);
    Color bg = sn ? const Color(0xFFFFCDD2) : lad ? const Color(0xFFC8E6C9) : const Color(0xFFFFF8E1);
    List<int> here = [];
    for (int i = 0; i < 4; i++) {
      if (pos[i] == num) here.add(i);
    }
    return Container(
      decoration: BoxDecoration(color: bg, border: Border.all(color: Colors.black12, width: 0.3)),
      child: Stack(
        children: [
          Positioned(top: 1, left: 2, child: Text("$num", style: const TextStyle(fontSize: 8))),
          // تكبير حجم أيقونات السلالم والثعابين لتكون واضحة جداً
          if (sn) const Center(child: Text("🐍", style: TextStyle(fontSize: 18))),
          if (lad) const Center(child: Text("🪜", style: TextStyle(fontSize: 18))),
          if (here.isNotEmpty)
            Positioned(
              bottom: 1,
              right: 1,
              child: Row(
                children: here
                    .map((p) => Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 0.5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: [Colors.red, Colors.amber, Colors.green, Colors.blue][p],
                          ),
                        ))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double size = math.min(MediaQuery.of(context).size.width - 16, MediaQuery.of(context).size.height * 0.65);
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(8)),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("غرفة سلم والثعبان الملكية (السلالم مكبرة)", style: TextStyle(color: Colors.amber, fontSize: 11, fontWeight: FontWeight.bold)),
              Text("الدور: لاعب 1", style: TextStyle(color: Colors.white, fontSize: 11)),
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(border: Border.all(color: const Color(0xFFFFD700), width: 3)),
              child: Stack(
                children: [
                  GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 10),
                    physics: const NeverScrollableScrollPhysics(),
                    reverse: true,
                    itemCount: 100,
                    itemBuilder: (c, i) {
                      int r = i ~/ 10, co = i % 10;
                      int num = r % 2 == 0 ? 100 - r * 10 - co : 100 - r * 10 - (9 - co);
                      return cell(num);
                    },
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: roll,
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const RadialGradient(colors: [Color(0xFFFFD700), Color(0xFFFF6F00)]),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("$dice", style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
                            const Text("نرد", style: TextStyle(color: Colors.white, fontSize: 9)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        ChatAndControlsBar(
          onSendChat: (txt) => setState(() => publicChat.add("Me: $txt")),
          onSendEmoji: (em) => setState(() => publicChat.add("Me: $em")),
          onSendRose: () {
            if (UserData.freeRoses > 0) {
              setState(() => UserData.freeRoses--);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('🌹 تم إرسال وردة يومية!')));
            }
          },
        ),
      ],
    );
  }
}
