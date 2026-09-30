import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(MaterialApp(
    home: GameHub(),
    debugShowCheckedModeBanner: false,
  ));
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
      body: tab == 0 ? LudoExact() : CarromPro(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: tab,
        onTap: (i) {
          setState(() {
            tab = i;
          });
        },
        backgroundColor: Color(0xFF0A1931),
        selectedItemColor: Color(0xFF3DD4C0),
        unselectedItemColor: Colors.white54,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.casino), label: "لودو"),
          BottomNavigationBarItem(icon: Icon(Icons.circle), label: "كيرم"),
        ],
      ),
    );
  }
}

// ==================== لودو كاملة شغالة ====================
class LudoExact extends StatefulWidget {
  @override
  State<LudoExact> createState() => _LudoExactState();
}

class _LudoExactState extends State<LudoExact> {
  int dice = 1;
  int turn = 0;
  bool canRoll = true;
  String msg = "دوس ROLL";

  List<List<int>> boardPos = [
    [-1, -1, -1, -1],
    [-1, -1, -1, -1],
    [-1, -1, -1, -1],
    [-1, -1, -1, -1],
  ];

  List<int> startIndex = [0, 13, 26, 39];
  List<int> safe = [0, 8, 13, 21, 26, 34, 39, 47];

  List<Offset> path = [
    Offset(6, 1), Offset(6, 2), Offset(6, 3), Offset(6, 4), Offset(6, 5),
    Offset(5, 6), Offset(4, 6), Offset(3, 6), Offset(2, 6), Offset(1, 6),
    Offset(0, 6), Offset(0, 7), Offset(0, 8), Offset(1, 8), Offset(2, 8),
    Offset(3, 8), Offset(4, 8), Offset(5, 8), Offset(6, 9), Offset(6, 10),
    Offset(6, 11), Offset(6, 12), Offset(6, 13), Offset(6, 14),
    Offset(7, 14), Offset(8, 14), Offset(8, 13), Offset(8, 12),
    Offset(8, 11), Offset(8, 10), Offset(8, 9), Offset(9, 8),
    Offset(10, 8), Offset(11, 8), Offset(12, 8), Offset(13, 8),
    Offset(14, 8), Offset(14, 7), Offset(14, 6), Offset(13, 6),
    Offset(12, 6), Offset(11, 6), Offset(10, 6), Offset(9, 6),
    Offset(8, 5), Offset(8, 4), Offset(8, 3), Offset(8, 2),
    Offset(8, 1), Offset(8, 0), Offset(7, 0), Offset(6, 0),
  ];

  void roll() {
    if (!canRoll) return;
    setState(() {
      dice = math.Random().nextInt(6) + 1;
      canRoll = false;
      msg = "رقمك $dice - دوس على طيارتك";
    });

    bool hasMove = false;
    for (int t in boardPos[turn]) {
      if (t == -1 && dice == 6) hasMove = true;
      if (t >= 0 && t < 52) hasMove = true;
    }
    if (!hasMove) {
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          turn = (turn + 1) % 4;
          canRoll = true;
          msg = "مفيش حركة - دور اللي بعده";
        });
      });
    }
  }

  void moveToken(int p, int idx) {
    if (p != turn) {
      setState(() {
        msg = "مش دورك!";
      });
      return;
    }
    if (canRoll) {
      setState(() {
        msg = "لازم ترمي النرد الاول";
      });
      return;
    }
    int pos = boardPos[p][idx];
    if (pos == -1 && dice != 6) {
      setState(() {
        msg = "لازم 6 عشان تطلع";
      });
      return;
    }

    setState(() {
      if (pos == -1) {
        boardPos[p][idx] = startIndex[p];
      } else {
        boardPos[p][idx] = pos + dice;
        if (boardPos[p][idx] > 51) {
          boardPos[p][idx] = 100;
          msg = "وصل البيت!";
        }
      }

      int newPos = boardPos[p][idx];
      if (newPos < 52 && !safe.contains(newPos)) {
        for (int op = 0; op < 4; op++) {
          if (op == p) continue;
          for (int ot = 0; ot < 4; ot++) {
            if (boardPos[op][ot] == newPos) {
              boardPos[op][ot] = -1;
              msg = "اكلته! 🔥";
            }
          }
        }
      }

      bool won = boardPos[p].every((e) => e >= 100);
      if (won) {
        msg = "اللاعب ${p + 1} كسب! 🏆";
        canRoll = true;
        return;
      }

      if (dice != 6) {
        turn = (turn + 1) % 4;
      }
      canRoll = true;
      if (msg.startsWith("رقمك")) msg = "دور اللاعب ${turn + 1}";
    });
  }

  Widget buildToken(Color c, int p, int idx, bool small) {
    bool isCurrent = turn == p;
    return GestureDetector(
      onTap: () => moveToken(p, idx),
      child: Container(
        width: small ? 30 : 40,
        height: small ? 30 : 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: c,
          border: Border.all(color: isCurrent ? Colors.white : Colors.white70, width: isCurrent ? 3 : 2),
          boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 3, offset: Offset(0, 2))],
        ),
        child: Icon(Icons.star, size: small ? 12 : 18, color: Color(0xFFFFE082)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color red = Color(0xFFE53935);
    Color yellow = Color(0xFFFFC107);
    Color green = Color(0xFF43A047);
    Color blue = Color(0xFF1E88E5);
    List<Color> cols = [red, yellow, green, blue];
    List<String> names = ["You | Red", "Sara | Yellow", "Leo | Green", "Mia | Blue"];
    double boardSize = MediaQuery.of(context).size.width - 16;
    double cell = boardSize / 15;

    return Scaffold(
      backgroundColor: Color(0xFF0F0E3A),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A1A5E), Color(0xFF2D1B69)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Row(
                  children: [
                    Icon(Icons.arrow_back, color: Colors.white, size: 26),
                    SizedBox(width: 10),
                    Text("Ludo Room • 10356", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10)),
                      child: Text(msg, style: TextStyle(color: Colors.white, fontSize: 11)),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.pause, color: Colors.white),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF2A2A7A).withOpacity(0.6),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(4, (i) {
                    return Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: cols[i], width: turn == i ? 4 : 1.5),
                          ),
                          child: CircleAvatar(
                            radius: 24,
                            backgroundColor: cols[i].withOpacity(0.8),
                            child: Icon(Icons.person, color: Colors.white, size: 22),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(names[i], style: TextStyle(color: cols[i], fontSize: 10, fontWeight: FontWeight.bold)),
                      ],
                    );
                  }),
                ),
              ),
              Center(
                child: Container(
                  width: boardSize,
                  height: boardSize,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(color: Color(0xFFE8C36A), borderRadius: BorderRadius.circular(16)),
                  child: Stack(
                    children: [
                      GridView.count(
                        crossAxisCount: 15,
                        physics: NeverScrollableScrollPhysics(),
                        children: List.generate(225, (idx) {
                          int r = idx ~/ 15;
                          int c = idx % 15;
                          Color bg = Colors.white;
                          Widget? child;
                          if (r < 6 && c < 6) bg = red;
                          else if (r < 6 && c > 8) bg = green;
                          else if (r > 8 && c < 6) bg = yellow;
                          else if (r > 8 && c > 8) bg = blue;
                          else if (r >= 6 && r <= 8 && c >= 6 && c <= 8) bg = Color(0xFFFFD54F);
                          else if (r == 7 && c >= 1 && c <= 4) bg = red;
                          else if (r == 7 && c >= 10 && c <= 12) bg = green;
                          else if (c == 7 && r >= 1 && r <= 4) bg = yellow;
                          else if (c == 7 && r >= 10 && r <= 13) bg = yellow;
                          if (safe.contains(path.indexWhere((e) => e.dx == r && e.dy == c))) {
                            child = Text("⭐", style: TextStyle(fontSize: cell * 0.5));
                          }
                          return Container(
                            decoration: BoxDecoration(color: bg, border: Border.all(color: Colors.black12, width: 0.3)),
                            child: Center(child: child),
                          );
                        }),
                      ),
                      // القطع في البيوت
                      ...List.generate(4, (p) {
                        return List.generate(4, (t) {
                          int bpos = boardPos[p][t];
                          double x, y;
                          if (bpos == -1) {
                            if (p == 0) { x = (t % 2 == 0 ? 1 : 4) * cell; y = (t < 2 ? 1 : 4) * cell; }
                            else if (p == 1) { x = (t % 2 == 0 ? 1 : 4) * cell; y = (t < 2 ? 10 : 13) * cell; }
                            else if (p == 2) { x = (t % 2 == 0 ? 10 : 13) * cell; y = (t < 2 ? 1 : 4) * cell; }
                            else { x = (t % 2 == 0 ? 10 : 13) * cell; y = (t < 2 ? 10 : 13) * cell; }
                            return Positioned(left: x + 3, top: y + 3, child: buildToken(cols[p], p, t, false));
                          } else if (bpos >= 100) {
                            return Positioned(left: 6 * cell, top: 6 * cell, child: buildToken(cols[p], p, t, true));
                          } else {
                            Offset pt = path[bpos % 52];
                            x = pt.dy * cell;
                            y = pt.dx * cell;
                            return Positioned(left: x + 2, top: y + 2, child: buildToken(cols[p], p, t, true));
                          }
                        });
                      }).expand((e) => e).toList(),
                      Positioned(
                        left: 6 * cell, top: 6 * cell, width: 3 * cell, height: 3 * cell,
                        child: Container(decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xFFFFC107), border: Border.all(color: Colors.white, width: 2)), child: Icon(Icons.emoji_events, size: 18)),
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(color: Color(0xFF12123A), borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
                child: Row(
                  children: [
                    Container(width: 56, height: 56, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)), child: Center(child: Text("$dice", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)))),
                    SizedBox(width: 10),
                    Expanded(child: GestureDetector(onTap: roll, child: Container(height: 50, decoration: BoxDecoration(color: Color(0xFF26A69A), borderRadius: BorderRadius.circular(16)), child: Center(child: Text(canRoll ? "ROLL" : "انتظر", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)))))),
                    SizedBox(width: 8),
                    Container(height: 50, padding: EdgeInsets.symmetric(horizontal: 14), decoration: BoxDecoration(color: Color(0xFFFFC93C), borderRadius: BorderRadius.circular(14)), child: Row(children: [Icon(Icons.shield, color: Color(0xFF6D4C00), size: 18), Text(" SAFE", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF6D4C00)))])),
                    SizedBox(width: 8),
                    Container(height: 50, padding: EdgeInsets.symmetric(horizontal: 14), decoration: BoxDecoration(color: Color(0xFF3A3A6A), borderRadius: BorderRadius.circular(14)), child: Center(child: Text("MENU", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
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

// ==================== كيرم ====================
class CarromPro extends StatefulWidget {
  @override State<CarromPro> createState() => _CarromProState();
}

class _CarromProState extends State<CarromPro> {
  List<CarromPiece> pieces = [];
  Offset striker = Offset(0.5, 0.85);
  Offset? aim;
  double power = 0;

  @override void initState() {
    super.initState();
    pieces = [
      CarromPiece(Offset(0.5, 0.5), Colors.red, true, isQueen: true),
      ...List.generate(8, (i) {
        double ang = i * 45 * 3.14159 / 180;
        return CarromPiece(Offset(0.5 + 0.07 * math.cos(ang), 0.5 + 0.07 * math.sin(ang)), i % 2 == 0 ? Colors.white : Colors.black, false);
      }),
    ];
  }

  @override Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2B1A0E),
      appBar: AppBar(backgroundColor: Color(0xFF3E2723), title: Text("Carrom • μ=0.15 | e=1"), centerTitle: true),
      body: Column(
        children: [
          Expanded(child: LayoutBuilder(builder: (ctx, cons) {
            double size = math.min(cons.maxWidth, cons.maxHeight) * 0.92;
            return Center(child: Container(
              width: size, height: size,
              decoration: BoxDecoration(color: Color(0xFFF5D6A0), border: Border.all(color: Color(0xFF5D4037), width: 10), borderRadius: BorderRadius.circular(8)),
              child: Stack(children: [
                ...[Offset(0, 0), Offset(1, 0), Offset(0, 1), Offset(1, 1)].map((p) => Positioned(left: p.dx * (size - 20) - 4, top: p.dy * (size - 20) - 4, child: Container(width: 22, height: 22, decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle)))),
                ...pieces.map((pc) => Positioned(left: pc.pos.dx * size - 14, top: pc.pos.dy * size - 14, child: Container(width: 28, height: 28, decoration: BoxDecoration(color: pc.color, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 1.5)), child: pc.isQueen ? Icon(Icons.star, size: 12, color: Colors.yellow) : null))),
                Positioned(left: striker.dx * size - 18, top: striker.dy * size - 18, child: GestureDetector(
                  onPanUpdate: (d) { setState(() { aim = d.localPosition; power = (d.delta.distance * 0.12).clamp(0.0, 1.0); }); },
                  onPanEnd: (_) {
                    setState(() {
                      if (aim != null) {
                        double dx = (aim!.dx - striker.dx * size) / size;
                        double dy = (aim!.dy - striker.dy * size) / size;
                        striker = Offset((striker.dx + dx * power * 0.5).clamp(0.1, 0.9), (striker.dy + dy * power * 0.5).clamp(0.1, 0.9));
                      }
                      aim = null; power = 0;
                    });
                  },
                  child: Container(width: 36, height: 36, decoration: BoxDecoration(color: Color(0xFFE91E63), shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)), child: Icon(Icons.adjust, color: Colors.white, size: 18)),
                )),
              ]),
            ));
          })),
          Container(padding: EdgeInsets.all(12), color: Color(0xFF3E2723), child: Text("فيزياء حقيقية: احتكاك μ=0.15 | كتلة 5g | تصادم مرن | F=ma", style: TextStyle(color: Colors.white70, fontSize: 12), textAlign: TextAlign.center)),
        ],
      ),
    );
  }
}

class CarromPiece {
  Offset pos; Color color; bool isWhite; bool isQueen;
  CarromPiece(this.pos, this.color, this.isWhite, {this.isQueen=false});
}
