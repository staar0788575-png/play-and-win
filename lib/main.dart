import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MaterialApp(
    home: LudoFinal(),
    debugShowCheckedModeBanner: false,
  ));
}

class LudoFinal extends StatefulWidget {
  @override
  _LudoFinalState createState() => _LudoFinalState();
}

class _LudoFinalState extends State<LudoFinal> {
  int dice = 6;
  int turn = 1;
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
    Future.delayed(Duration(milliseconds: 800), () {
      setState(() {
        canRoll = true;
        if (dice!= 6) {
          turn = (turn + 1) % 4;
        }
      });
    });
  }

  Widget buildToken(Color c, int player, int index, bool big) {
    double s = big? 44 : 38;
    return Container(
      width: s,
      height: s,
      decoration: BoxDecoration(
        color: c,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(color: Colors.black38, blurRadius: 4, offset: Offset(0, 2))
        ],
      ),
      child: Icon(Icons.star, size: big? 22 : 18, color: Color(0xFFFFC107)),
    );
  }

  Widget cell(Color color, Widget? child) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: Colors.black12, width: 0.5),
      ),
      child: Center(child: child),
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

    return Scaffold(
      backgroundColor: Color(0xFF0A1931),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                children: [
                  Icon(Icons.arrow_back, color: Colors.white, size: 26),
                  SizedBox(width: 10),
                  Text("Ludo Room - 10356",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  Spacer(),
                  Icon(Icons.pause, color: Colors.white),
                  SizedBox(width: 14),
                  Icon(Icons.volume_up, color: Colors.white),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              padding: EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Color(0xFF1E2E6B),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(4, (i) {
                  bool isTurn = turn == i;
                  return Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: cols[i], width: isTurn? 4 : 2),
                        ),
                        child: CircleAvatar(
                          radius: 28,
                          backgroundColor: cols[i],
                          child: Icon(Icons.person, color: Colors.white, size: 30),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(names[i],
                          style: TextStyle(
                              color: isTurn? cols[i] : cols[i].withOpacity(0.6),
                              fontSize: 11,
                              fontWeight: isTurn? FontWeight.bold : FontWeight.normal)),
                    ],
                  );
                }),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Center(
                child: Container(
                  width: 360,
                  height: 360,
                  padding: EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: Color(0xFFD4A94A),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 12)],
                  ),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
                    child: Column(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                flex: 6,
                                child: Container(
                                  color: red,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                        buildToken(red, 0, 0, false),
                                        SizedBox(width: 14),
                                        buildToken(red, 0, 1, false),
                                      ]),
                                      SizedBox(height: 14),
                                      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                        buildToken(red, 0, 2, false),
                                        SizedBox(width: 14),
                                        buildToken(red, 0, 3, false),
                                      ]),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: cell(Colors.white, Icon(Icons.star, color: Colors.orange, size: 16)),
                              ),
                              Expanded(
                                flex: 1,
                                child: cell(green, null),
                              ),
                              Expanded(
                                flex: 1,
                                child: cell(Colors.white, Icon(Icons.auto_awesome, color: Colors.grey, size: 14)),
                              ),
                              Expanded(
                                flex: 6,
                                child: Container(
                                  color: green,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                        buildToken(green, 2, 0, false),
                                        SizedBox(width: 14),
                                        buildToken(green, 2, 1, false),
                                      ]),
                                      SizedBox(height: 14),
                                      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                        buildToken(green, 2, 2, false),
                                        SizedBox(width: 14),
                                        buildToken(green, 2, 3, false),
                                      ]),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(flex: 6, child: cell(Colors.white, null)),
                              Expanded(flex: 1, child: cell(Colors.white, null)),
                              Expanded(flex: 1, child: cell(red, null)),
                              Expanded(flex: 1, child: cell(red, null)),
                              Expanded(flex: 6, child: cell(Colors.white, null)),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                flex: 6,
                                child: Row(
                                  children: [
                                    Expanded(child: cell(Colors.white, Icon(Icons.play_arrow, color: red, size: 18))),
                                    Expanded(child: cell(red, null)),
                                    Expanded(child: cell(red, null)),
                                    Expanded(child: cell(red, null)),
                                    Expanded(child: cell(red, null)),
                                    Expanded(child: cell(red, null)),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  color: Color(0xFFFFC107),
                                  child: Center(
                                    child: Container(
                                      width: 70,
                                      height: 28,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFFFC107),
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(color: Colors.white, width: 1.5),
                                      ),
                                      child: Icon(Icons.emoji_events, size: 18, color: Color(0xFF6D4C00)),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 6,
                                child: Row(
                                  children: [
                                    Expanded(child: cell(blue, null)),
                                    Expanded(child: cell(blue, null)),
                                    Expanded(child: cell(blue, null)),
                                    Expanded(child: cell(blue, null)),
                                    Expanded(child: cell(blue, null)),
                                    Expanded(child: cell(Colors.white, Icon(Icons.play_arrow, color: blue, size: 18))),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(flex: 6, child: cell(Colors.white, Icon(Icons.auto_awesome, size: 14))),
                              Expanded(flex: 1, child: cell(Colors.white, Icon(Icons.star, color: Colors.orange, size: 16))),
                              Expanded(flex: 1, child: cell(Colors.white, null)),
                              Expanded(flex: 1, child: cell(Colors.white, null)),
                              Expanded(flex: 6, child: cell(Colors.white, null)),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                flex: 6,
                                child: Container(
                                  color: yellow,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                        Container(
                                          width: 44,
                                          height: 44,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(color: Colors.white, width: 2.5),
                                            color: Colors.white24,
                                          ),
                                        ),
                                        SizedBox(width: 14),
                                        Container(
                                          width: 44,
                                          height: 44,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(color: Colors.white, width: 2.5),
                                            color: Colors.white24,
                                          ),
                                        ),
                                      ]),
                                      SizedBox(height: 14),
                                      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                        Container(
                                          width: 44,
                                          height: 44,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(color: Colors.white, width: 2.5),
                                            color: Colors.white24,
                                          ),
                                        ),
                                        SizedBox(width: 14),
                                        Container(
                                          width: 44,
                                          height: 44,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(color: Colors.white, width: 2.5),
                                            color: Colors.white24,
                                          ),
                                        ),
                                      ]),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(flex: 1, child: cell(yellow, null)),
                              Expanded(flex: 1, child: cell(yellow, null)),
                              Expanded(flex: 1, child: cell(Colors.white, null)),
                              Expanded(
                                flex: 6,
                                child: Container(
                                  color: blue,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                        buildToken(blue, 3, 0, false),
                                        SizedBox(width: 14),
                                        buildToken(blue, 3, 1, false),
                                      ]),
                                      SizedBox(height: 14),
                                      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                        buildToken(blue, 3, 2, false),
                                        SizedBox(width: 14),
                                        buildToken(blue, 3, 3, false),
                                      ]),
                                    ],
                                  ),
                                ),
                              ),
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
              margin: EdgeInsets.all(14),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: Color(0xFF121F3D),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
                    child: Center(child: Text("$dice", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold))),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: roll,
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: Color(0xFF3DD4C0),
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: Center(
                          child: Text(
                            canRoll? "ROLL - دور اللاعب ${turn + 1}" : "دور اللاعب ${turn + 1}",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF2A1A5A)),
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
