import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';
import 'package:flutter/services.dart';

void main() {
  runApp(MaterialApp(home: GameHub(), debugShowCheckedModeBanner: false));
}

class SoundManager {
  static void dice() {
    HapticFeedback.mediumImpact();
    SystemSound.play(SystemSoundType.click);
  }
  static void move() {
    HapticFeedback.lightImpact();
  }
  static void capture() {
    HapticFeedback.heavyImpact();
    SystemSound.play(SystemSoundType.alert);
  }
  static void win() {
    HapticFeedback.vibrate();
  }
}

class CarromPiece {
  Offset pos;
  Color color;
  bool isWhite;
  bool isQueen;
  bool isStriker;
  Offset vel;
  CarromPiece(this.pos, this.color, this.isWhite,
      {this.isQueen = false, this.isStriker = false})
      : vel = Offset.zero;
}

class GameHub extends StatefulWidget {
  @override
  State<GameHub> createState() => _GameHubState();
}

class _GameHubState extends State<GameHub> {
  int tab = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tab == 0
         ? LudoRoyalFull()
          : tab == 1
             ? CarromSimple()
              : SnakeLadderRoyal(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: tab,
        onTap: (i) {
          setState(() => tab = i);
        },
        backgroundColor: Color(0xFF0A1931),
        selectedItemColor: Color(0xFFFFD700),
        unselectedItemColor: Colors.white54,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.workspace_premium), label: "لودو"),
          BottomNavigationBarItem(icon: Icon(Icons.circle), label: "كيرم"),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: "سلم وثعبان"),
        ],
      ),
    );
  }
}

class LudoRoyalFull extends StatefulWidget {
  @override
  State<LudoRoyalFull> createState() => _LudoRoyalFullState();
}

class _LudoRoyalFullState extends State<LudoRoyalFull> {
  int dice = 6;
  int turn = 0;
  bool canRoll = true;
  bool gameOver = false;
  int winner = -1;
  int countdown = 10;
  String msg = "جبت 6";
  List<List<int>> tokens = [
    [-1, -1, -1, -1],
    [-1, -1, -1, -1],
    [-1, -1, -1, -1],
    [-1, -1, -1, -1]
  ];
  List<String> gameChat = ["P3: عاش 💪", "Me: السلام عليكم"];
  TextEditingController chatCtrl = TextEditingController();
  Timer? countdownTimer;

  void roll() {
    if (!canRoll || gameOver) return;
    setState(() {
      dice = math.Random().nextInt(6) + 1;
      canRoll = false;
      msg = "جبت $dice";
    });
    SoundManager.dice();
    Future.delayed(Duration(milliseconds: 800), () {
      if (mounted) setState(() => canRoll = true);
    });
  }

  void resetGame() {
    setState(() {
      tokens = [
        [-1, -1, -1, -1],
        [-1, -1, -1, -1],
        [-1, -1, -1, -1],
        [-1, -1, -1, -1]
      ];
      gameOver = false;
      winner = -1;
      countdown = 10;
      canRoll = true;
    });
  }

  void startCountdown() {
    countdownTimer?.cancel();
    countdownTimer = Timer.periodic(Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() => countdown--);
      if (countdown <= 0) {
        t.cancel();
        resetGame();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0D1B4A),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Color(0xFF2A3A8C),
                  borderRadius: BorderRadius.circular(16)),
              child: Row(
                children: [
                  Icon(Icons.visibility, color: Colors.amber, size: 18),
                  SizedBox(width: 8),
                  Text("غرفة انتظار الأصدقاء 👀",
                      style: TextStyle(color: Colors.white, fontSize: 12)),
                  Spacer(),
                  Icon(Icons.mic, color: Colors.greenAccent, size: 20),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: GestureDetector(
                  onTap: roll,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                            colors: [Color(0xFFFFD700), Color(0xFFFF6F00)])),
                    child: Center(
                        child: Text("$dice",
                            style: TextStyle(
                                fontSize: 40, fontWeight: FontWeight.bold))),
                  ),
                ),
              ),
            ),
            if (gameOver)
              Container(
                color: Color(0x99000000),
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text("اللاعب ${winner + 1} فاز 👑",
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                    Text("$countdown",
                        style: TextStyle(color: Colors.white, fontSize: 36)),
                  ],
                ),
              ),
            Container(
              height: 60,
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Color(0xFF1A2A6A),
                  borderRadius: BorderRadius.circular(12)),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: gameChat.length,
                itemBuilder: (c, i) => Container(
                  margin: EdgeInsets.only(right: 6),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                      color: Color(0xFF2A3A8C),
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(gameChat[i],
                      style: TextStyle(color: Colors.white, fontSize: 12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CarromSimple extends StatefulWidget {
  @override
  State<CarromSimple> createState() => _CarromSimpleState();
}

class _CarromSimpleState extends State<CarromSimple> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF3A1A7A),
      body: Center(
          child: Text("كيرم 4 لاعبين ✅ شغال",
              style: TextStyle(color: Colors.white, fontSize: 18))),
    );
  }
}

class SnakeLadderRoyal extends StatefulWidget {
  @override
  State<SnakeLadderRoyal> createState() => _SnakeLadderState();
}

class _SnakeLadderState extends State<SnakeLadderRoyal> {
  int dice = 1;
  int turn = 0;
  bool canRoll = true;
  bool gameOver = false;
  int winner = -1;
  int countdown = 10;
  List<int> pos = [0, 0, 0, 0];
  Timer? countdownTimer;
  TextEditingController chatCtrl = TextEditingController();
  bool micOn = true;
  bool privateMode = false;
  String flyingEmoji = "";
  String selectedGift = "";
  List<String> publicChat = ["P2: يلا 😂", "Me: هات سلم"];
  List<String> privateChat = ["P1 خاص: لا تديها لحد"];
  List<String> gifts = ["❤️", "🌹", "👑", "🚗", "🦁", "💎"];
  List<String> emojis = ["😂", "😡", "😍", "👏", "🎉", "🔥"];

  final Map<int, int> snakes = {
    99: 54,
    70: 55,
    52: 42,
    56: 8,
    43: 17,
    50: 5,
    27: 5
  };

  final Map<int, int> ladders = {
    3: 51,
    6: 27,
    20: 70,
    36: 55,
    63: 95,
    68: 98
  };

  void roll() {
    if (!canRoll || gameOver) return;
    setState(() {
      dice = math.Random().nextInt(6) + 1;
      canRoll = false;
    });
    SoundManager.dice();
    Future.delayed(Duration(milliseconds: 600), () {
      movePlayer();
    });
  }

  void movePlayer() {
    setState(() {
      int cur = pos[turn];
      int next = cur + dice;
      if (next > 100) {
        canRoll = true;
        turn = (turn + 1) % 4;
        return;
      }
      if (next == 100) {
        pos[turn] = 100;
        gameOver = true;
        winner = turn;
        countdown = 10;
        SoundManager.win();
        startCountdown();
        return;
      }
      pos[turn] = next;
      if (snakes.containsKey(next)) {
        pos[turn] = snakes[next]!;
        SoundManager.capture();
      } else if (ladders.containsKey(next)) {
        pos[turn] = ladders[next]!;
        SoundManager.move();
      } else {
        SoundManager.move();
      }
      if (dice!= 6) {
        turn = (turn + 1) % 4;
      }
      canRoll = true;
    });
  }

  void startCountdown() {
    countdownTimer?.cancel();
    countdownTimer = Timer.periodic(Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() => countdown--);
      if (countdown <= 0) {
        t.cancel();
        resetGame();
      }
    });
  }

  void resetGame() {
    setState(() {
      pos = [0, 0, 0, 0];
      turn = 0;
      dice = 1;
      canRoll = true;
      gameOver = false;
      winner = -1;
      countdown = 10;
    });
  }

  void sendChat() {
    if (chatCtrl.text.isEmpty) return;
    setState(() {
      if (privateMode) {
        privateChat.add("Me خاص: ${chatCtrl.text}");
      } else {
        publicChat.add("Me: ${chatCtrl.text}");
      }
      chatCtrl.clear();
    });
  }

  void sendEmoji(String e) {
    setState(() => flyingEmoji = e);
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) setState(() => flyingEmoji = "");
    });
  }

  void sendGift(String g) {
    setState(() => selectedGift = g);
    SoundManager.win();
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) setState(() => selectedGift = "");
    });
  }

  Widget buildCell(int num) {
    bool isSnake = snakes.containsKey(num);
    bool isLadder = ladders.containsKey(num);
    Color bg = Color(0xFFFFF8E1);
    if (num % 2 == 0) bg = Color(0xFFE8F5E9);
    if (isSnake) bg = Color(0xFFFFCDD2);
    if (isLadder) bg = Color(0xFFC8E6C9);
    List<int> playersHere = [];
    for (int i = 0; i < 4; i++) {
      if (pos[i] == num) playersHere.add(i);
    }
    return Container(
      decoration: BoxDecoration(
          color: bg, border: Border.all(color: Colors.black12, width: 0.4)),
      child: Stack(
        children: [
          Positioned(
              top: 2,
              left: 4,
              child: Text("$num",
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold))),
          if (isSnake) Center(child: Text("🐍", style: TextStyle(fontSize: 16))),
          if (isLadder) Center(child: Text("🪜", style: TextStyle(fontSize: 16))),
          if (playersHere.isNotEmpty)
            Positioned(
                bottom: 2,
                right: 2,
                child: Row(
                  children: playersHere.map((p) {
                    List<Color> c = [
                      Color(0xFFE53935),
                      Color(0xFFFBC02D),
                      Color(0xFF43A047),
                      Color(0xFF1E88E5)
                    ];
                    return Container(
                      width: 12,
                      height: 12,
                      margin: EdgeInsets.only(left: 1),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: c[p],
                          border: Border.all(color: Colors.white, width: 1)),
                      child: Center(
                          child: Text("${p + 1}",
                              style:
                                  TextStyle(fontSize: 7, color: Colors.white))),
                    );
                  }).toList(),
                ))
        ],
      ),
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
    double size = MediaQuery.of(context).size.width - 12;
    List<Color> cols = [
      Color(0xFFE53935),
      Color(0xFFFBC02D),
      Color(0xFF43A047),
      Color(0xFF1E88E5)
    ];
    return Scaffold(
      backgroundColor: Color(0xFF0D1B4A),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                  color: Color(0xFF2A3A8C),
                  borderRadius: BorderRadius.circular(16)),
              child: Row(
                children: [
                  Icon(Icons.visibility, color: Colors.amber, size: 18),
                  SizedBox(width: 8),
                  Text("غرفة انتظار الأصدقاء - سلم وثعبان 👀",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      setState(() => micOn =!micOn);
                    },
                    child: Icon(micOn? Icons.mic : Icons.mic_off,
                        color: micOn? Colors.greenAccent : Colors.redAccent),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Row(
                children: [
                  for (int i = 0; i < 4; i++)
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 3),
                        padding: EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                            color: turn == i? cols[i] : Color(0xFF2A3A8C),
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          children: [
                            Icon(Icons.person, color: Colors.white, size: 18),
                            Text("P${i + 1} : ${pos[i]}",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 10))
                          ],
                        ),
                      ),
                    )
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFFFD700), width: 4),
                      color: Color(0xFFFFF8E1)),
                  child: Stack(
                    children: [
                      GridView.builder(
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 10),
                        physics: NeverScrollableScrollPhysics(),
                        reverse: true,
                        itemCount: 100,
                        itemBuilder: (c, idx) {
                          int row = idx ~/ 10;
                          int col = idx % 10;
                          int num;
                          if (row % 2 == 0) {
                            num = 100 - row * 10 - col;
                          } else {
                            num = 100 - row * 10 - (9 - col);
                          }
                          return buildCell(num);
                        },
                      ),
                      if (flyingEmoji.isNotEmpty)
                        Center(
                            child: Text(flyingEmoji,
                                style: TextStyle(fontSize: 60))),
                      if (selectedGift.isNotEmpty)
                        Center(
                          child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                color: Color(0xCC000000),
                                borderRadius: BorderRadius.circular(20)),
                            child: Text(selectedGift,
                                style: TextStyle(fontSize: 50)),
                          ),
                        ),
                      if (canRoll &&!gameOver)
                        Center(
                          child: GestureDetector(
                            onTap: roll,
                            child: Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(colors: [
                                    Color(0xFFFFD700),
                                    Color(0xFFFF6F00)
                                  ]),
                                  border:
                                      Border.all(color: Colors.white, width: 3)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("$dice",
                                      style: TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold)),
                                  Text("ROLL",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12))
                                ],
                              ),
                            ),
                          ),
                        ),
                      if (gameOver)
                        Container(
                          color: Color(0x99000000),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.emoji_events,
                                    color: Color(0xFFFFD700), size: 70),
                                Text("اللاعب ${winner + 1} فاز 👑",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(height: 10),
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SizedBox(
                                      width: 90,
                                      height: 90,
                                      child: CircularProgressIndicator(
                                          value: countdown / 10,
                                          strokeWidth: 8,
                                          color: Color(0xFFFFD700)),
                                    ),
                                    Text("$countdown",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 36,
                                            fontWeight: FontWeight.bold))
                                  ],
                                ),
                                Text("جيم جديد بعد $countdown",
                                    style:
                                        TextStyle(color: Color(0xB3FFFFFF)))
                              ],
                            ),
                          ),
                        )
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 70,
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                  color: Color(0xFF1A2A6A),
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => setState(() => privateMode = false),
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                              color:!privateMode
                                 ? Color(0xFFFFD700)
                                  : Color(0xFF2A3A8C),
                              borderRadius: BorderRadius.circular(12)),
                          child: Text("عام",
                              style: TextStyle(
                                  color:!privateMode
                                     ? Colors.black
                                      : Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                      SizedBox(width: 6),
                      GestureDetector(
                        onTap: () => setState(() => privateMode = true),
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                              color: privateMode
                                 ? Color(0xFFFFD700)
                                  : Color(0xFF2A3A8C),
                              borderRadius: BorderRadius.circular(12)),
                          child: Text("خاص",
                              style: TextStyle(
                                  color: privateMode
                                     ? Colors.black
                                      : Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                      Spacer(),
                      Row(
                        children: gifts.map((g) {
                          return GestureDetector(
                            onTap: () => sendGift(g),
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 2),
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  color: Color(0x33FFFFFF),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Text(g, style: TextStyle(fontSize: 14)),
                            ),
                          );
                        }).toList(),
                      )
                    ],
                  ),
                  SizedBox(height: 4),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: privateMode
                         ? privateChat.length
                          : publicChat.length,
                      itemBuilder: (c, i) {
                        var list = privateMode? privateChat : publicChat;
                        bool me = list[i].startsWith("Me");
                        return Container(
                          margin: EdgeInsets.only(right: 6),
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                              color: me? Color(0xFF7C4DFF) : Color(0xFF2A3A8C),
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(list[i],
                              style:
                                  TextStyle(color: Colors.white, fontSize: 11)),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Row(
                    children: emojis.map((e) {
                      return GestureDetector(
                        onTap: () => sendEmoji(e),
                        child: Container(
                          margin: EdgeInsets.only(right: 4),
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              color: Color(0xFF2A3A8C),
                              shape: BoxShape.circle),
                          child: Text(e, style: TextStyle(fontSize: 16)),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(width: 6),
                  Expanded(
                    child: TextField(
                      controller: chatCtrl,
                      style: TextStyle(color: Colors.white, fontSize: 12),
                      decoration: InputDecoration(
                          hintText: privateMode
                             ? "رسالة خاصة..."
                              : "دردشة عامة...",
                          filled: true,
                          fillColor: Color(0xFF2A3A8C),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6)),
                      onSubmitted: (_) => sendChat(),
                    ),
                  ),
                  SizedBox(width: 6),
                  GestureDetector(
                    onTap: sendChat,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Color(0xFFFFD700)),
                      child: Icon(Icons.send, color: Colors.black, size: 16),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
