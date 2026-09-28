import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(MaterialApp(home: LudoPro(), debugShowCheckedModeBanner: false));

class LudoPro extends StatefulWidget { @override _LudoProState createState() => _LudoProState(); }

class _LudoProState extends State<LudoPro> with TickerProviderStateMixin {
  int dice = 1, turn = 0;
  bool canRoll = true;
  List<List<int>> tokens = List.generate(4, (_) => List.filled(4, -1)); // -1 home, 0-51 path, 100+ win
  List<int> safeCells = [0, 8, 13, 21, 26, 34, 39, 47];

  // احداثيات الـ 52 خانة على البورد 15x15
  List<Point<int>> pathCoords = [
    Point(6,1), Point(6,2), Point(6,3), Point(6,4), Point(6,5), Point(5,6), Point(4,6), Point(3,6), Point(2,6), Point(1,6), Point(0,6), Point(0,7), Point(0,8),
    Point(1,8), Point(2,8), Point(3,8), Point(4,8), Point(5,8), Point(6,9), Point(6,10), Point(6,11), Point(6,12), Point(6,13), Point(6,14), Point(7,14), Point(8,14),
    Point(8,13), Point(8,12), Point(8,11), Point(8,10), Point(8,9), Point(9,8), Point(10,8), Point(11,8), Point(12,8), Point(13,8), Point(14,8), Point(14,7), Point(14,6),
    Point(13,6), Point(12,6), Point(11,6), Point(10,6), Point(9,6), Point(8,5), Point(8,4), Point(8,3), Point(8,2), Point(8,1), Point(8,0), Point(7,0), Point(6,0),
  ];

  void rollDice() {
    if (!canRoll) return;
    setState(() {
      dice = Random().nextInt(6) + 1;
      canRoll = false;
      // شوف لو ليه حركة
      bool hasMove = false;
      for (int i = 0; i < 4; i++) {
        if (tokens[turn][i] == -1 && dice == 6) hasMove = true;
        if (tokens[turn][i] >= 0 && tokens[turn][i] < 100) hasMove = true;
      }
      if (!hasMove) {
        Future.delayed(Duration(seconds: 1), () {
          setState(() { turn = (turn + 1) % 4; canRoll = true; });
        });
      }
    });
  }

  void moveToken(int tokenIndex) {
    if (canRoll) return;
    setState(() {
      int pos = tokens[turn][tokenIndex];
      if (pos == -1 && dice == 6) {
        tokens[turn][tokenIndex] = turn * 13; // بداية كل لاعب
      } else if (pos >= 0 && pos < 52) {
        int newPos = pos + dice;
        if (newPos >= 52) newPos -= 52;
        // اكل الخصم لو مش في الامان
        if (!safeCells.contains(newPos)) {
          for (int p = 0; p < 4; p++) {
            for (int t = 0; t < 4; t++) {
              if (p!= turn && tokens[p][t] == newPos) tokens[p][t] = -1;
            }
          }
        }
        tokens[turn][tokenIndex] = newPos;
      }
      if (dice!= 6) turn = (turn + 1) % 4;
      canRoll = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Color> playerColors = [Colors.red, Colors.green, Colors.yellow.shade700, Colors.blue];
    return Scaffold(
      backgroundColor: Color(0xFF0F0F2D),
      appBar: AppBar(backgroundColor: Color(0xFF16213E), title: Text("LUDO PRO - دور اللاعب ${turn + 1} 🎲 $dice"), centerTitle: true),
      body: Column(children: [
        AspectRatio(
          aspectRatio: 1,
          child: Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(border: Border.all(color: Colors.white, width: 3), color: Colors.white),
            child: Stack(children: [
              // رسم البورد
              GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 15),
                itemCount: 225,
                itemBuilder: (c, i) {
                  int r = i ~/ 15, col = i % 15;
                  Color bg = Colors.white;
                  if (r < 6 && col < 6) bg = Colors.red.shade400;
                  else if (r < 6 && col > 8) bg = Colors.green.shade400;
                  else if (r > 8 && col < 6) bg = Colors.yellow.shade700;
                  else if (r > 8 && col > 8) bg = Colors.blue.shade400;
                  else if (pathCoords.any((p) => p.x == r && p.y == col)) bg = Colors.white;
                  else bg = Color(0xFF16213E);
                  bool isSafe = false;
                  for (var s in safeCells) { var p = pathCoords[s]; if (p.x == r && p.y == col) isSafe = true; }
                  return Container(decoration: BoxDecoration(color: bg, border: Border.all(color: Colors.black26, width: 0.3)),
                    child: isSafe? Icon(Icons.star, size: 12, color: Colors.black87) : null);
                },
              ),
              // رسم القطع
             ...List.generate(4, (p) {
                return...List.generate(4, (t) {
                  int pos = tokens[p][t];
                  double x, y;
                  if (pos == -1) { // في البيت
                    x = (p < 2? 0.5 + t % 2 * 1.5 : 9.5 + t % 2 * 1.5) * 20;
                    y = (p % 2 == 0? 0.5 + t ~/ 2 * 1.5 : 9.5 + t ~/ 2 * 1.5) * 20;
                    x = p % 2 == 0? (p == 0? 20 + t % 2 * 40 : 260 + t % 2 * 40) : (p == 1? 260 + t % 2 * 40 : 20 + t % 2 * 40);
                    y = p < 2? 20 + t ~/ 2 * 40 : 260 + t ~/ 2 * 40;
                  } else if (pos < 52) {
                    var c = pathCoords[pos];
                    x = c.y * 23.3 + 5; y = c.x * 23.3 + 5;
                  } else { x = 160; y = 160; }
                  return Positioned(left: x, top: y, child: GestureDetector(onTap: () => p == turn? moveToken(t) : null,
                    child: Container(width: 18, height: 18, decoration: BoxDecoration(color: playerColors[p], shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2), boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 3)]))));
                });
              }),
            ]),
          ),
        ),
        SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(padding: EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)), child: Text("$dice", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold))),
          SizedBox(width: 20),
          ElevatedButton(onPressed: rollDice, style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15)), child: Text(canRoll? "ارمي النرد" : "حرك قطعة", style: TextStyle(color: Colors.black, fontSize: 18))),
        ]),
        SizedBox(height: 10),
        Text("8 خانات آمنة ⭐ لا يمكن الأكل فيها - لازم تجيب 6 عشان تطلع", style: TextStyle(color: Colors.white70)),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: List.generate(4, (i) => Container(width: 12, height: 12, decoration: BoxDecoration(color: playerColors[i], shape: BoxShape.circle, border: turn == i? Border.all(color: Colors.white, width: 2) : null)))),
      ]),
    );
  }
}
