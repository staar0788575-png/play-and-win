import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MaterialApp(home: LudoGame(), debugShowCheckedModeBanner: false));
}

class LudoGame extends StatefulWidget {
  @override
  State<LudoGame> createState() => _LudoGameState();
}

class _LudoGameState extends State<LudoGame> {
  int dice = 5;
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
        canRoll = true;
        turn = (turn + 1) % 4;
      });
    });
  }

  void moveToken(int player, int index) {
    if (player!= turn) return;
    if (canRoll) return;
    setState(() {
      if (tokens[player][index] == -1 && dice == 6) {
        tokens[player][index] = 0;
      } else if (tokens[player][index] >= 0) {
        tokens[player][index] = tokens[player][index] + dice;
        if (tokens[player][index] > 51) tokens[player][index] = 51;
      }
      if (dice!= 6) turn = (turn + 1) % 4;
      canRoll = true;
    });
  }

  Widget buildToken(Color c) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: c,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Icon(Icons.star, size: 18, color: Color(0xFFFFC107)),
    );
  }

  Widget buildHome(Color c, int player) {
    return Container(
      color: c,
      padding: EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          color: c.withOpacity(0.7),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(onTap: () => moveToken(player, 0), child: buildToken(c)),
                SizedBox(width: 10),
                GestureDetector(onTap: () => moveToken(player, 1), child: buildToken(c)),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(onTap: () => moveToken(player, 2), child: buildToken(c)),
                SizedBox(width: 10),
                GestureDetector(onTap: () => moveToken(player, 3), child: buildToken(c)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Color> colors = [
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
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Icon(Icons.arrow_back, color: Colors.white),
                  SizedBox(width: 10),
                  Text("Ludo Room - 10356", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
              decoration: BoxDecoration(color: Color(0xFF1E2E6B), borderRadius: BorderRadius.circular(16)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(children: [CircleAvatar(backgroundColor: colors[0], radius: 28, child: Icon(Icons.person, color: Colors.white)), Text("You | Red", style: TextStyle(color: colors[0], fontSize: 11))]),
                  Column(children: [CircleAvatar(backgroundColor: colors[1], radius: 28, child: Icon(Icons.person, color: Colors.white)), Text("Sara | Yellow", style: TextStyle(color: colors[1], fontSize: 11))]),
                  Column(children: [CircleAvatar(backgroundColor: colors[2], radius: 28, child: Icon(Icons.person, color: Colors.white)), Text("Leo | Green", style: TextStyle(color: colors[2], fontSize: 11))]),
                  Column(children: [CircleAvatar(backgroundColor: colors[3], radius: 28, child: Icon(Icons.person, color: Colors.white)), Text("Mia | Blue", style: TextStyle(color: colors[3], fontSize: 11))]),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Container(
                  width: 360,
                  height: 360,
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(color: Color(0xFFE5C06A), borderRadius: BorderRadius.circular(12)),
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(child: buildHome(colors[0], 0)),
                              Expanded(child: Container(color: Colors.white, child: Center(child: Icon(Icons.star, color: Colors.orange)))),
                              Expanded(child: buildHome(colors[2], 2)),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(child: Container(color: Colors.white)),
                              Expanded(child: Container(color: Color(0xFFFFC107), child: Icon(Icons.emoji_events, color: Colors.brown))),
                              Expanded(child: Container(color: Colors.white)),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(child: buildHome(colors[1], 1)),
                              Expanded(child: Container(color: Colors.white)),
                              Expanded(child: buildHome(colors[3], 3)),
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
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(color: Color(0xFF0F1E42), borderRadius: BorderRadius.circular(16)),
              child: Row(
                children: [
                  Container(width: 50, height: 50, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)), child: Center(child: Text("$dice", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)))),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: roll,
                      style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF2EC4B6), padding: EdgeInsets.symmetric(vertical: 14)),
                      child: Text(canRoll? "ROLL - دور اللاعب ${turn + 1}" : "دوس على قطعة", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
