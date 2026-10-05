import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';
import 'package:flutter/services.dart';

void main() {
  runApp(
    const MaterialApp(
      home: GameHub(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class SoundManager {
  static void dice() {
    HapticFeedback.mediumImpact();
  }
  static void move() {
    HapticFeedback.lightImpact();
  }
  static void capture() {
    HapticFeedback.heavyImpact();
  }
  static void win() {
    HapticFeedback.vibrate();
  }
  static void hit() {
    HapticFeedback.selectionClick();
  }
  static void pot() {
    HapticFeedback.lightImpact();
  }
}

// ================= CARROM MODELS =================
class CarromPiece {
  Offset pos;
  Color color;
  bool isWhite;
  bool isQueen;
  bool isStriker;
  Offset vel;
  CarromPiece(
    this.pos,
    this.color,
    this.isWhite, {
    this.isQueen = false,
    this.isStriker = false,
  }) : vel = Offset.zero;
}

// ================= GAME HUB =================
class GameHub extends StatefulWidget {
  const GameHub({super.key});
  @override
  State<GameHub> createState() => _GameHubState();
}

class _GameHubState extends State<GameHub> {
  int tab = 0;
  @override
  Widget build(BuildContext context) {
    Widget body;
    if (tab == 0) {
      body = const LudoRoyalFull();
    } else if (tab == 1) {
      body = const CarromProFull();
    } else {
      body = const SnakeLadderFull();
    }

    return Scaffold(
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: tab,
        onTap: (i) {
          setState(() {
            tab = i;
          });
        },
        backgroundColor: const Color(0xFF0A1931),
        selectedItemColor: const Color(0xFFFFD700),
        unselectedItemColor: Colors.white54,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.casino),
            label: "لودو",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.circle),
            label: "كيرم",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: "سلم",
          ),
        ],
      ),
    );
  }
}

// ================= LUDO FULL - ALL FEATURES =================
class LudoRoyalFull extends StatefulWidget {
  const LudoRoyalFull({super.key});
  @override
  State<LudoRoyalFull> createState() => _LudoRoyalFullState();
}

class _LudoRoyalFullState extends State<LudoRoyalFull> {
  int dice = 6;
  int turn = 0;
  int winner = -1;
  int countdown = 10;

  bool canRoll = true;
  bool gameOver = false;
  bool micOn = true;
  bool privateMode = false;

  String msg = "جبت 6";
  String flyingEmoji = "";
  String selectedGift = "";

  List<List<int>> tokens = [
    [-1, -1, -1, -1],
    [-1, -1, -1, -1],
    [-1, -1, -1, -1],
    [-1, -1, -1, -1],
  ];

  List<int> start = [0, 39, 13, 26];
  List<int> safe = [0, 8, 13, 21, 26, 34, 39, 47];

  List<List<int>> homePath = [
    [52, 53, 54, 55, 56, 57],
    [58, 59, 60, 61, 62, 63],
    [64, 65, 66, 67, 68, 69],
    [70, 71, 72, 73, 74, 75],
  ];

  List<String> publicChat = [
    "P3: عاش 💪",
    "Me: السلام عليكم",
  ];
  List<String> privateChat = [
    "P1 خاص: يلا",
  ];

  List<String> gifts = ["❤️", "🌹", "👑", "🚗", "🦁", "💎"];
  List<String> emojis = ["😂", "😡", "😍", "👏", "🎉", "🔥"];

  TextEditingController chatCtrl = TextEditingController();
  Timer? countdownTimer;

  List<Offset> path = [
    const Offset(6, 1),
    const Offset(6, 2),
    const Offset(6, 3),
    const Offset(6, 4),
    const Offset(6, 5),
    const Offset(5, 6),
    const Offset(4, 6),
    const Offset(3, 6),
    const Offset(2, 6),
    const Offset(1, 6),
    const Offset(0, 6),
    const Offset(0, 7),
    const Offset(0, 8),
    const Offset(1, 8),
    const Offset(2, 8),
    const Offset(3, 8),
    const Offset(4, 8),
    const Offset(5, 8),
    const Offset(6, 9),
    const Offset(6, 10),
    const Offset(6, 11),
    const Offset(6, 12),
    const Offset(6, 13),
    const Offset(6, 14),
    const Offset(7, 14),
    const Offset(8, 14),
    const Offset(8, 13),
    const Offset(8, 12),
    const Offset(8, 11),
    const Offset(8, 10),
    const Offset(8, 9),
    const Offset(9, 8),
    const Offset(10, 8),
    const Offset(11, 8),
    const Offset(12, 8),
    const Offset(13, 8),
    const Offset(14, 8),
    const Offset(14, 7),
    const Offset(14, 6),
    const Offset(13, 6),
    const Offset(12, 6),
    const Offset(11, 6),
    const Offset(10, 6),
    const Offset(9, 6),
    const Offset(8, 5),
    const Offset(8, 4),
    const Offset(8, 3),
    const Offset(8, 2),
    const Offset(8, 1),
    const Offset(8, 0),
    const Offset(7, 0),
    const Offset(6, 0),
  ];

  Map<int, Offset> homeC = {
    52: const Offset(7, 1),
    53: const Offset(7, 2),
    54: const Offset(7, 3),
    55: const Offset(7, 4),
    56: const Offset(7, 5),
    57: const Offset(7, 6),
    58: const Offset(13, 7),
    59: const Offset(12, 7),
    60: const Offset(11, 7),
    61: const Offset(10, 7),
    62: const Offset(9, 7),
    63: const Offset(8, 7),
    64: const Offset(1, 7),
    65: const Offset(2, 7),
    66: const Offset(3, 7),
    67: const Offset(4, 7),
    68: const Offset(5, 7),
    69: const Offset(6, 7),
    70: const Offset(7, 13),
    71: const Offset(7, 12),
    72: const Offset(7, 11),
    73: const Offset(7, 10),
    74: const Offset(7, 9),
    75: const Offset(7, 8),
  };

  void checkWin() {
    for (int p = 0; p < 4; p++) {
      if (tokens[p].every((e) => e == 100)) {
        setState(() {
          gameOver = true;
          winner = p;
          countdown = 10;
        });
        SoundManager.win();
        startCountdown();
        break;
      }
    }
  }

  void startCountdown() {
    countdownTimer?.cancel();
    countdownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (t) {
        if (!mounted) return;
        setState(() {
          countdown--;
        });
        if (countdown <= 0) {
          t.cancel();
          resetGame();
        }
      },
    );
  }

  void resetGame() {
    setState(() {
      tokens = [
        [-1, -1, -1, -1],
        [-1, -1, -1, -1],
        [-1, -1, -1, -1],
        [-1, -1, -1, -1],
      ];
      turn = 0;
      dice = 6;
      canRoll = true;
      msg = "جيم جديد 👑";
      gameOver = false;
      winner = -1;
      countdown = 10;
    });
  }

  void roll() {
    if (!canRoll || gameOver) return;
    setState(() {
      dice = math.Random().nextInt(6) + 1;
      canRoll = false;
      msg = "جبت $dice";
    });
    SoundManager.dice();
    bool can = false;
    for (int tt in tokens[turn]) {
      if (tt == -1 && dice == 6) can = true;
      if (tt >= 0) can = true;
    }
    if (!can) {
      Future.delayed(
        const Duration(milliseconds: 800),
        () {
          if (mounted) {
            setState(() {
              turn = (turn + 1) % 4;
              canRoll = true;
            });
          }
        },
      );
    }
  }

  void moveToken(int p, int idx) {
    if (p!= turn || canRoll || gameOver) return;
    int cur = tokens[p][idx];
    if (cur == -1 && dice!= 6) return;
    bool cap = false;
    setState(() {
      if (cur == -1) {
        tokens[p][idx] = start[p];
      } else if (cur >= 0 && cur < 52) {
        int entry = (start[p] + 51) % 52;
        int next = cur + dice;
        if (cur <= entry && next > entry) {
          int h = next - entry - 1;
          if (h < 6) {
            tokens[p][idx] = homePath[p][h];
          } else if (h == 6) {
            tokens[p][idx] = 100;
          } else {
            tokens[p][idx] = next % 52;
          }
        } else {
          tokens[p][idx] = next % 52;
        }
      } else if (cur >= 52) {
        int hi = homePath[p].indexOf(cur);
        if (hi!= -1) {
          if (hi + dice < 6) {
            tokens[p][idx] = homePath[p][hi + dice];
          } else if (hi + dice == 6) {
            tokens[p][idx] = 100;
          }
        }
      }
      int pos = tokens[p][idx];
      if (pos >= 0 && pos < 52 &&!safe.contains(pos)) {
        for (int op = 0; op < 4; op++) {
          if (op == p) continue;
          for (int oi = 0; oi < 4; oi++) {
            if (tokens[op][oi] == pos) {
              tokens[op][oi] = -1;
              cap = true;
            }
          }
        }
      }
      if (dice!= 6) {
        turn = (turn + 1) % 4;
      }
      canRoll = true;
    });
    if (cap) {
      SoundManager.capture();
    } else {
      SoundManager.move();
    }
    checkWin();
  }

  void sendChat() {
    if (chatCtrl.text.trim().isEmpty) return;
    setState(() {
      if (privateMode) {
        privateChat.add("Me خاص: ${chatCtrl.text.trim()}");
      } else {
        publicChat.add("Me: ${chatCtrl.text.trim()}");
      }
      chatCtrl.clear();
    });
  }

  void sendEmoji(String e) {
    setState(() {
      flyingEmoji = e;
    });
    Future.delayed(
      const Duration(seconds: 2),
      () {
        if (mounted) {
          setState(() {
            flyingEmoji = "";
          });
        }
      },
    );
  }

  void sendGift(String g) {
    setState(() {
      selectedGift = g;
    });
    SoundManager.win();
    Future.delayed(
      const Duration(seconds: 2),
      () {
        if (mounted) {
          setState(() {
            selectedGift = "";
          });
        }
      },
    );
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    chatCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color red = const Color(0xFFE53935);
    Color green = const Color(0xFF43A047);
    Color yellow = const Color(0xFFFBC02D);
    Color blue = const Color(0xFF1E88E5);
    List<Color> cols = [red, yellow, green, blue];
    double boardSize = MediaQuery.of(context).size.width - 8;

    List<Widget> giftWidgets = List.generate(
      gifts.length,
      (index) {
        return GestureDetector(
          onTap: () {
            sendGift(gifts[index]);
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0x33FFFFFF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              gifts[index],
              style: const TextStyle(fontSize: 14),
            ),
          ),
        );
      },
    );

    List<Widget> emojiWidgets = List.generate(
      emojis.length,
      (index) {
        return GestureDetector(
          onTap: () {
            sendEmoji(emojis[index]);
          },
          child: Container(
            margin: const EdgeInsets.only(right: 4),
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: Color(0xFF2A3A8C),
              shape: BoxShape.circle,
            ),
            child: Text(
              emojis[index],
              style: const TextStyle(fontSize: 16),
            ),
          ),
        );
      },
    );

    return Scaffold(
      backgroundColor: const Color(0xFF0D1B4A),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF2A3A8C),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.visibility, color: Colors.amber, size: 18),
                  const SizedBox(width: 8),
                  const Text(
                    "غرفة انتظار الأصدقاء - لودو 👀",
                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        micOn =!micOn;
                      });
                    },
                    child: Icon(
                      micOn? Icons.mic : Icons.mic_off,
                      color: micOn? Colors.greenAccent : Colors.redAccent,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Container(
                  width: boardSize,
                  height: boardSize,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFFFD700), width: 5),
                    color: const Color(0xFF3E2723),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: LayoutBuilder(
                    builder: (c, cons) {
                      double s = cons.maxWidth;
                      double ce = s / 15;
                      List<Widget> tW = [];
                      for (int p = 0; p < 4; p++) {
                        for (int t = 0; t < 4; t++) {
                          int bp = tokens[p][t];
                          double cx;
                          double cy;
                          double sz = ce * 0.78;
                          if (bp == -1) {
                            cx = (t % 2 == 0? 1.5 : 3.5) * ce;
                            cy = (t < 2? 1.5 : 3.5) * ce;
                            if (p == 1) cy = (t < 2? 10.5 : 12.5) * ce;
                            if (p == 2) cx = (t % 2 == 0? 10.5 : 12.5) * ce;
                            if (p == 3) {
                              cx = (t % 2 == 0? 10.5 : 12.5) * ce;
                              cy = (t < 2? 10.5 : 12.5) * ce;
                            }
                          } else if (bp >= 100) {
                            cx = 7.5 * ce;
                            cy = 7.5 * ce;
                          } else if (homeC.containsKey(bp)) {
                            var pt = homeC[bp]!;
                            cx = pt.dy * ce + ce / 2;
                            cy = pt.dx * ce + ce / 2;
                          } else {
                            var pt = path[bp % 52];
                            cx = pt.dy * ce + ce / 2;
                            cy = pt.dx * ce + ce / 2;
                          }
                          tW.add(
                            Positioned(
                              left: cx - sz / 2,
                              top: cy - sz / 2,
                              child: GestureDetector(
                                onTap: () {
                                  moveToken(p, t);
                                },
                                child: Container(
                                  width: sz,
                                  height: sz,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: cols[p],
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "♔",
                                      style: TextStyle(color: Colors.white, fontSize: sz * 0.6),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                      }
                      List<Widget> gridCells = List.generate(
                        225,
                        (i) {
                          int r = i ~/ 15;
                          int co = i % 15;
                          Color bg = const Color(0xFFFFF8E1);
                          if (r < 6 && co < 6) bg = red;
                          else if (r < 6 && co > 8) bg = green;
                          else if (r > 8 && co < 6) bg = yellow;
                          else if (r > 8 && co > 8) bg = blue;
                          else if (r == 7 && co >= 1 && co <= 5) bg = red.withOpacity(0.85);
                          else if (r == 7 && co >= 9 && co <= 13) bg = green.withOpacity(0.65);
                          else if (co == 7 && r >= 1 && r <= 5) bg = yellow.withOpacity(0.65);
                          else if (co == 7 && r >= 9 && r <= 13) bg = blue.withOpacity(0.65);
                          else if (r >= 6 && r <= 8 && co >= 6 && co <= 8) bg = const Color(0xFFFFD54F);
                          Widget? ch;
                          int pIdx = path.indexWhere((e) => e.dx == r && e.dy == co);
                          if (safe.contains(pIdx)) {
                            ch = Text("★", style: TextStyle(fontSize: ce * 0.50));
                          }
                          return Container(
                            decoration: BoxDecoration(
                              color: bg,
                              border: Border.all(color: Colors.black12, width: 0.3),
                            ),
                            child: Center(child: ch),
                          );
                        },
                      );
                      return Stack(
                        children: [
                          GridView.count(
                            crossAxisCount: 15,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            children: gridCells,
                          ),
                         ...tW,
                          if (flyingEmoji.isNotEmpty)
                            Center(
                              child: Text(flyingEmoji, style: const TextStyle(fontSize: 70)),
                            ),
                          if (selectedGift.isNotEmpty)
                            Center(
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xCC000000),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(selectedGift, style: const TextStyle(fontSize: 50)),
                              ),
                            ),
                          if (canRoll &&!gameOver)
                            Center(
                              child: GestureDetector(
                                onTap: roll,
                                child: Container(
                                  width: 106,
                                  height: 106,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: const RadialGradient(
                                      colors: [Color(0xFFFFD700), Color(0xFFFF6F00)],
                                    ),
                                    border: Border.all(color: Colors.white, width: 3),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("$dice", style: const TextStyle(fontSize: 38, fontWeight: FontWeight.bold)),
                                      const Text("ROLL", style: TextStyle(fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          if (gameOver)
                            Container(
                              color: const Color(0x99000000),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.emoji_events, color: Color(0xFFFFD700), size: 70),
                                    Text("اللاعب ${winner + 1} فاز 👑", style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 20),
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        SizedBox(
                                          width: 90,
                                          height: 90,
                                          child: CircularProgressIndicator(value: countdown / 10, strokeWidth: 8, color: const Color(0xFFFFD700)),
                                        ),
                                        Text("$countdown", style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
            Container(
              height: 100,
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: const Color(0xFF1A2A6A), borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            privateMode = false;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color:!privateMode? const Color(0xFFFFD700) : const Color(0xFF2A3A8C),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text("عام", style: TextStyle(color:!privateMode? Colors.black : Colors.white, fontSize: 11)),
                        ),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            privateMode = true;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: privateMode? const Color(0xFFFFD700) : const Color(0xFF2A3A8C),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text("خاص", style: TextStyle(color: privateMode? Colors.black : Colors.white, fontSize: 11)),
                        ),
                      ),
                      const Spacer(),
                      Row(children: giftWidgets),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: privateMode? privateChat.length : publicChat.length
