import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MaterialApp(
    home: LudoPro(),
    debugShowCheckedModeBanner: false,
  ));
}

class LudoPro extends StatefulWidget {
  @override
  _LudoProState createState() => _LudoProState();
}

class _LudoProState extends State<LudoPro> {
  int dice = 6;
  int turn = 0;
  bool canRoll = true;

  List<List<int>> tokens = [
    [-1, -1, -1, -1],
    [-1, -1, -1, -1],
    [-1, -1, -1, -1],
    [-1, -1, -1, -1],
  ];

  void roll() {
    if (!canRoll) return;
    setState(() {
      dice = Random().nextInt(6) + 1;
      canRoll = false;
    });
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        turn = (turn + 1) % 4;
        canRoll = true;
      });
    });
  }

  void moveToken(int p, int t) {
    if (p!= turn) return;
    if (canRoll) return;
    setState(() {
      if (tokens[p][t] == -1 && dice == 6) {
        tokens[p][t] = 0;
      }
      if (canRoll == false) {
        canRoll = true;
      }
    });
  }

  Widget token(Color c, int p, int t) {
    bool out = tokens[p][t]!= -1;
    return GestureDetector(
      onTap: () {
        moveToken(p, t);
      },
      child: Opacity(
        opacity: out? 0.3 : 1.0,
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: c,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Icon(Icons.star, size: 18, color: Color(0xFFFFC107)),
        ),
      ),
    );
  }

  Widget home(Color c, int player) {
    return Container(
      color: c,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                token(c, player, 0),
                SizedBox(width: 12),
                token(c, player, 1),
              ],
            ),
            SizedBox(height: 12),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                token(c, player, 2),
                SizedBox(width: 12),
                token(c, player, 3),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Color> cols = [
      Color(0xFFE53935),
      Color(0xFFFBC02D),
      Color(0xFF43A047),
      Color(0xFF1E88E5),
    ];

    return Scaffold(
      backgroundColor: Color(0xFF0A1931),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(Icons.arrow_back, color: Colors.white),
                  SizedBox(width: 10),
                  Text(
                    "Ludo Room - 10356",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Icon(Icons.pause, color: Colors.white),
                  SizedBox(width: 10),
                  Icon(Icons.volume_up, color: Colors.white),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(0xFF1E2E6B),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      CircleAvatar(backgroundColor: cols[0], radius: 28, child: Icon(Icons.person, color: Colors.white)),
                      Text("You | Red", style: TextStyle(color: cols[0], fontSize: 11)),
                    ],
                  ),
                  Column(
                    children: [
                      CircleAvatar(backgroundColor: cols[1], radius: 28, child: Icon(Icons.person, color: Colors.white)),
                      Text("Sara | Yellow", style: TextStyle(color: cols[1], fontSize: 11)),
                    ],
                  ),
                  Column(
                    children: [
                      CircleAvatar(backgroundColor: cols[2], radius: 28, child: Icon(Icons.person, color: Colors.white)),
                      Text("Leo | Green", style: TextStyle(color: cols[2], fontSize: 11)),
                    ],
                  ),
                  Column(
                    children: [
                      CircleAvatar(backgroundColor: cols[3], radius: 28, child: Icon(Icons.person, color: Colors.white)),
                      Text("Mia | Blue", style: TextStyle(color: cols[3], fontSize: 11)),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Container(
                  width: 360,
                  height: 360,
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Color(0xFFE5C06A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(child: home(cols[0], 0)),
                              Expanded(child: Container(color: Colors.white, child: Icon(Icons.star, color: Colors.orange))),
                              Expanded(child: home(cols[2], 2)),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(child: Container(color: Colors.white)),
                              Expanded(
                                child: Container(
                                  color: Color(0xFFFFC107),
                                  child: Icon(Icons.emoji_events),
                                ),
                              ),
                              Expanded(child: Container(color: Colors.white)),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(child: home(cols[1], 1)),
                              Expanded(child: Container(color: Colors.white)),
                              Expanded(child: home(cols[3], 3)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(12),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xFF101E3C),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        "$dice",
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: roll,
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: Color(0xFF2EC4B6),
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: Center(
                          child: Text(
                            "ROLL - دور اللاعب ${turn + 1}",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
