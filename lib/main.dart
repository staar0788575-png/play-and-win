import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(MaterialApp(home: LudoReal(), debugShowCheckedModeBanner: false));

class LudoReal extends StatefulWidget {
  @override
  State<LudoReal> createState() => _LudoRealState();
}

class _LudoRealState extends State<LudoReal> {
  int dice = 6;
  int turn = 0; // 0: Red, 1: Yellow, 2: Green, 3: Blue
  bool canRoll = true;
  TextEditingController chatCtrl = TextEditingController();
  List<String> messages = ["Sara: يلا دورك 😂", "Leo: هات 6 بقى!", "Mia: 😍😍"];
  bool showEmoji = false;
  
  // -1 في البيت, 0-51 في المسار الرئيسي, 100+ في بيت الفوز
  List<List<int>> tokens = [
    [-1, -1, -1, -1], // Red
    [-1, -1, -1, -1], // Yellow
    [-1, -1, -1, -1], // Green
    [-1, -1, -1, -1], // Blue
  ];

  // مسار اللودو 52 خانة
  final List<Point<int>> path = [
    Point(6,1), Point(6,2), Point(6,3), Point(6,4), Point(6,5),
    Point(5,6), Point(4,6), Point(3,6), Point(2,6), Point(1,6), Point(0,6), Point(0,7), Point(0,8), Point(1,8), Point(2,8), Point(3,8), Point(4,8), Point(5,8),
    Point(6,9), Point(6,10), Point(6,11), Point(6,12), Point(6,13), Point(6,14), Point(7,14), Point(8,14),
    Point(8,13), Point(8,12), Point(8,11), Point(8,10), Point(8,9),
    Point(9,8), Point(10,8), Point(11,8), Point(12,8), Point(13,8), Point(14,8), Point(14,7), Point(14,6), Point(13,6), Point(12,6), Point(11,6), Point(10,6), Point(9,6),
    Point(8,5), Point(8,4), Point(8,3), Point(8,2), Point(8,1), Point(8,0), Point(7,0), Point(6,0),
  ];

  // نقاط البداية الصحيحة لكل لون أمام بيته مباشرة على المسار
  final List<int> startIndex = [0, 26, 39, 13]; // Red: 0, Yellow: 26, Green: 39, Blue: 13

  void roll() {
    if (!canRoll) return;
    setState(() {
      dice = Random().nextInt(6) + 1;
      canRoll = false;
    });

    // التحقق مما إذا كانت هناك حركة ممكنة لهذا اللاعب
    bool canMove = false;
    for (int t in tokens[turn]) {
      if (t == -1 && dice == 6) canMove = true;
      if (t >= 0 && t < 100) canMove = true;
    }

    if (!canMove) {
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          turn = (turn + 1) % 4;
          canRoll = true;
        });
      });
    }
  }

  void moveToken(int p, int i) {
    if (p != turn || canRoll) return;
    if (tokens[p][i] == -1 && dice != 6) return;

    setState(() {
      if (tokens[p][i] == -1) {
        tokens[p][i] = startIndex[p];
      } else {
        tokens[p][i] += dice;
        if (tokens[p][i] >= 52) {
          tokens[p][i] = 100; // الوصول لبيت الفوز
        }
      }
      
      // إذا لم يرم 6، ينتقل الدور للاعب التالي
      if (dice != 6) {
        turn = (turn + 1) % 4;
      }
      canRoll = true;
    });
  }

  void sendMsg() {
    if (chatCtrl.text.trim().isEmpty) return;
    setState(() {
      messages.add("You: ${chatCtrl.text}");
      chatCtrl.clear();
      showEmoji = false;
    });
  }

  void sendGift(String gift) {
    setState(() {
      messages.add("You sent $gift to ${["You|Red", "Sara|Yellow", "Leo|Green", "Mia|Blue"][turn]}");
    });
  }

  @override
  Widget build(BuildContext context) {
    Color red = Color(0xFFE53935);
    Color yellow = Color(0xFFFFC107);
    Color green = Color(0xFF43A047);
    Color blue = Color(0xFF1E88E5);
    List<Color> cols = [red, yellow, green, blue];
    List<String> names = ["You", "Sara", "Leo", "Mia"];

    double boardSize = MediaQuery.of(context).size.width * 0.88;
    double cell = boardSize / 15;

    return Scaffold(
      backgroundColor: Color(0xFF0A1931),
      body: SafeArea(
        child: Column(
          children: [
            // غرفة الانتظار في الأعلى مع تمييز الدور الحالي بوضوح تام
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              decoration: BoxDecoration(
                color: Color(0xFF1E2E6B),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(4, (i) {
                  bool isCurrentTurn = turn == i;
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    padding: EdgeInsets.all(isCurrentTurn ? 4 : 2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isCurrentTurn ? Colors.cyanAccent : cols[i],
                        width: isCurrentTurn ? 4 : 1.5,
                      ),
                      boxShadow: isCurrentTurn
                          ? [BoxShadow(color: Colors.cyanAccent.withOpacity(0.6), blurRadius: 10, spreadRadius: 2)]
                          : [],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: isCurrentTurn ? 26 : 22,
                          backgroundColor: cols[i],
                          child: Icon(Icons.person, color: Colors.white, size: isCurrentTurn ? 28 : 22),
                        ),
                        SizedBox(height: 4),
                        Text(
                          names[i],
                          style: TextStyle(
                            color: isCurrentTurn ? Colors.cyanAccent : cols[i],
                            fontSize: isCurrentTurn ? 12 : 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),

            // لوحة اللعب (Board)
            Container(
              width: boardSize,
              height: boardSize,
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Color(0xFFD4A94A),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 8, spreadRadius: 2)],
              ),
              child: Stack(
                children: [
                  Container(
                    color: Colors.white,
                    child: GridView.count(
                      crossAxisCount: 15,
                      physics: NeverScrollableScrollPhysics(),
                      children: List.generate(225, (idx) {
                        int r = idx ~/ 15;
                        int c = idx % 15;
                        Color bg = Colors.white;
                        if (r < 6 && c < 6)
                          bg = red;
                        else if (r < 6 && c > 8)
                          bg = green;
                        else if (r > 8 && c < 6)
                          bg = yellow;
                        else if (r > 8 && c > 8)
                          bg = blue;
                        else if (r >= 6 && r <= 8 && c >= 6 && c <= 8)
                          bg = yellow;
                        else if (r == 7 && c >= 1 && c <= 5)
                          bg = red;
                        else if (r == 7 && c >= 9 && c <= 13)
                          bg = blue;
                        else if (c == 7 && r >= 1 && r <= 5)
                          bg = green;
                        else if (c == 7 && r >= 9 && r <= 13)
                          bg = yellow;

                        Widget? icon;
                        if ((r == 2 && c == 6) || (r == 6 && c == 2) || (r == 8 && c == 12) || (r == 12 && c == 8)) {
                          icon = Icon(Icons.star, size: 10, color: Colors.orange.shade300);
                        }
                        return Container(
                          decoration: BoxDecoration(
                            color: bg,
                            border: Border.all(color: Colors.black12, width: 0.2),
                          ),
                          child: Center(child: icon),
                        );
                      }),
                    ),
                  ),

                  // قطع الطيارات بتصميم "ملك الشطرنج" (Crown/King)
                  ...List.generate(4, (p) => List.generate(4, (t) {
                        int pos = tokens[p][t];
                        double x = 0, y = 0;
                        if (pos == -1) {
                          // في البيت
                          if (p == 0) {
                            x = (t % 2 == 0 ? 1 : 4) * cell;
                            y = (t < 2 ? 1 : 4) * cell;
                          } else if (p == 1) {
                            x = (t % 2 == 0 ? 1 : 4) * cell;
                            y = (t < 2 ? 10 : 13) * cell;
                          } else if (p == 2) {
                            x = (t % 2 == 0 ? 10 : 13) * cell;
                            y = (t < 2 ? 1 : 4) * cell;
                          } else {
                            x = (t % 2 == 0 ? 10 : 13) * cell;
                            y = (t < 2 ? 10 : 13) * cell;
                          }
                        } else if (pos >= 100) {
                          x = 7 * cell;
                          y = 7 * cell;
                        } else {
                          var pt = path[pos % path.length];
                          x = pt.y * cell;
                          y = pt.x * cell;
                        }
                        return Positioned(
                          left: x + 2,
                          top: y + 2,
                          child: GestureDetector(
                            onTap: () => moveToken(p, t),
                            child: Container(
                              width: cell - 4,
                              height: cell - 4,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: cols[p],
                                border: Border.all(color: Colors.white, width: 2),
                                boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 3, spreadRadius: 1)],
                              ),
                              child: Center(
                                // شكل ملك الشطرنج (Crown)
                                child: Icon(Icons.king_bed, size: cell * 0.5, color: Colors.white),
                              ),
                            ),
                          ),
                        );
                      })).expand((e) => e).toList(),

                  // كأس الفوز في المنتصف
                  Positioned(
                    left: 6 * cell,
                    top: 6 * cell,
                    width: 3 * cell,
                    height: 3 * cell,
                    child: Container(
                      color: yellow.withOpacity(0.9),
                      child: Center(child: Icon(Icons.emoji_events, size: 22, color: Colors.brown.shade800)),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),

            // لوحة الدردشة وأدوات التحكم التحتية
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF162554),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: messages
                            .map((m) => Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2),
                                  child: Text(m, style: TextStyle(color: Colors.white70, fontSize: 13)),
                                ))
                            .toList(),
                      ),
                    ),
                    if (showEmoji)
                      Container(
                        height: 80,
                        child: GridView.count(
                          crossAxisCount: 6,
                          children: ["😂", "😍", "😭", "😎", "🔥", "❤️", "👏", "😅", "🤣", "😘", "🥰", "🎉"]
                              .map((e) => GestureDetector(
                                    onTap: () {
                                      chatCtrl.text += e;
                                    },
                                    child: Center(child: Text(e, style: TextStyle(fontSize: 20))),
                                  ))
                              .toList(),
                        ),
                      ),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          decoration: BoxDecoration(
                            color: Color(0xFF0F1E42),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              GestureDetector(onTap: () => sendGift("🎁"), child: Text("🎁", style: TextStyle(fontSize: 18))),
                              SizedBox(width: 8),
                              GestureDetector(onTap: () => sendGift("🏆"), child: Icon(Icons.emoji_events, color: Colors.amber, size: 18)),
                              SizedBox(width: 8),
                              GestureDetector(onTap: () => sendGift("❤️"), child: Icon(Icons.favorite, color: Colors.red, size: 18)),
                            ],
                          ),
                        ),
                        Spacer(),
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(color: Color(0xFF2E3A6B), shape: BoxShape.circle),
                          child: Icon(Icons.mic, color: Colors.white, size: 20),
                        ),
                        SizedBox(width: 8),
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                          child: Center(child: Text("$dice", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: cols[turn]))),
                        ),
                        SizedBox(width: 8),
                        GestureDetector(
                          onTap: roll,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: canRoll ? Color(0xFF3DD4C0) : Colors.grey,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Text(canRoll ? "ROLL" : "انتظر", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 38,
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Color(0xFF0F1E42),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: chatCtrl,
                                    onSubmitted: (_) => sendMsg(),
                                    style: TextStyle(color: Colors.white, fontSize: 13),
                                    decoration: InputDecoration(
                                      hintText: "اكتب رسالة...",
                                      hintStyle: TextStyle(color: Colors.white38, fontSize: 12),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() => showEmoji = !showEmoji);
                                  },
                                  child: Icon(Icons.emoji_emotions_outlined, color: Colors.white38, size: 20),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        GestureDetector(
                          onTap: sendMsg,
                          child: Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(color: Color(0xFF3DD4C0), shape: BoxShape.circle),
                            child: Icon(Icons.send, size: 16, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
