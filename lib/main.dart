import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(MaterialApp(home: LudoFinalWorking(), debugShowCheckedModeBanner: false));

class LudoFinalWorking extends StatefulWidget {
  @override _LudoFinalWorkingState createState() => _LudoFinalWorkingState();
}

class _LudoFinalWorkingState extends State<LudoFinalWorking> {
  int dice = 5;
  int turn = 0;
  bool canRoll = true;
  List<List<int>> tokens = [[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1]];
  List<int> safe = [0,8,13,21,26,34,39,47];
  List<List<double>> pathPos = [
    [0.08,0.37], [0.13,0.37], [0.13,0.41], [0.13,0.45], [0.13,0.49], [0.18,0.53], [0.23,0.53], [0.28,0.53], [0.33,0.53], [0.38,0.53], [0.43,0.53], [0.43,0.48], [0.43,0.43],
    [0.48,0.43], [0.53,0.43], [0.58,0.43], [0.63,0.43], [0.68,0.43], [0.73,0.48], [0.73,0.53], [0.73,0.58], [0.73,0.63], [0.73,0.68], [0.73,0.73], [0.68,0.73], [0.63,0.73],
    [0.63,0.68], [0.63,0.63], [0.63,0.58], [0.63,0.53], [0.68,0.49], [0.73,0.49], [0.78,0.49], [0.83,0.49], [0.88,0.49], [0.93,0.49], [0.93,0.54], [0.93,0.59],
    [0.88,0.59], [0.83,0.59], [0.78,0.59], [0.73,0.59], [0.68,0.59], [0.63,0.63], [0.63,0.68], [0.63,0.73], [0.63,0.78], [0.63,0.83], [0.63,0.88], [0.58,0.88], [0.53,0.88],
  ];

  void rollDice() {
    if (!canRoll) return;
    setState(() { dice = Random().nextInt(6) + 1; canRoll = false; });
    bool hasMove = false;
    for (int i = 0; i < 4; i++) { if (tokens[turn][i] == -1 && dice == 6) hasMove = true; if (tokens[turn][i] >= 0) hasMove = true; }
    if (!hasMove) Future.delayed(Duration(seconds: 1), () { setState(() { turn = (turn + 1) % 4; canRoll = true; }); });
  }

  void moveToken(int t) {
    if (canRoll) return;
    setState(() {
      int pos = tokens[turn][t];
      if (pos == -1 && dice == 6) tokens[turn][t] = turn * 13;
      else if (pos >= 0) {
        int np = pos + dice; if (np >= 52) np -= 52;
        if (!safe.contains(np)) { for (int p = 0; p < 4; p++) for (int k = 0; k < 4; k++) if (p!= turn && tokens[p][k] == np) tokens[p][k] = -1; }
        tokens[turn][t] = np;
      }
      if (dice!= 6) turn = (turn + 1) % 4;
      canRoll = true;
    });
  }

  Widget avatar(Color border, String name, bool isTurn) {
    return Column(children: [Container(padding: EdgeInsets.all(3), decoration: BoxDecoration(border: Border.all(color: border, width: isTurn? 4 : 2), borderRadius: BorderRadius.circular(30)), child: Container(width: 62, height: 78, decoration: BoxDecoration(color: Color(0xFF1A2A5A), borderRadius: BorderRadius.circular(26)), child: Icon(Icons.person, size: 44, color: Colors.white))), SizedBox(height: 4), Text(name, style: TextStyle(color: border, fontWeight: FontWeight.bold, fontSize: 12))]);
  }

  Widget homeToken(Color c, int player, int index) {
    bool isOut = tokens[player][index]!= -1;
    return Opacity(opacity: isOut? 0.3 : 1.0, child: GestureDetector(onTap: () { if (player == turn &&!canRoll && dice == 6 && tokens[player][index] == -1) moveToken(index); }, child: Container(width: 44, height: 44, decoration: BoxDecoration(shape: BoxShape.circle, color: c, border: Border.all(color: Colors.black26, width: 2)), child: Icon(Icons.star, color: Color(0xFFFFB300), size: 20))));
  }

  @override Widget build(BuildContext context) {
    List<Color> cols = [Color(0xFFE53935), Color(0xFFFBC02D), Color(0xFF43A047), Color(0xFF1E88E5)];
    return Scaffold(body: Container(decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF0A1931), Color(0xFF1A0A4A)])), child: SafeArea(child: Column(children: [
      Padding(padding: EdgeInsets.all(10), child: Row(children: [Icon(Icons.arrow_back, color: Colors.white), SizedBox(width: 10), Text("Ludo Room - 10356", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), Spacer(), Icon(Icons.pause, color: Colors.white), SizedBox(width: 12), Icon(Icons.volume_up, color: Colors.white)])),
      Container(margin: EdgeInsets.all(10), padding: EdgeInsets.all(10), decoration: BoxDecoration(color: Color(0xFF1E2E6B), borderRadius: BorderRadius.circular(20)), child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [avatar(cols[0], "You | Red", turn==0), avatar(cols[1], "Sara | Yellow", turn==1), avatar(cols[2], "Leo | Green", turn==2), avatar(cols[3], "Mia | Blue", turn==3)])),
      Expanded(child: LayoutBuilder(builder: (context, constraints) {
        double size = 350; return Center(child: Container(width: size, height: size, padding: EdgeInsets.all(8), decoration: BoxDecoration(color: Color(0xFFE5C06A), borderRadius: BorderRadius.circular(18)), child: Stack(children: [
          Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)), child: Column(children: [
            Expanded(flex:6, child: Row(children: [Expanded(flex:6, child: Container(color: Color(0xFFE53935), child: Container(margin: EdgeInsets.all(10), decoration: BoxDecoration(color: Color(0xFFC62828), borderRadius: BorderRadius.circular(8)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Row(mainAxisAlignment: MainAxisAlignment.center, children: [homeToken(cols[0],0,0), SizedBox(width:12), homeToken(cols[0],0,1)]), SizedBox(height:12), Row(mainAxisAlignment: MainAxisAlignment.center, children: [homeToken(cols[0],0,2), SizedBox(width:12), homeToken(cols[0],0,3)])])))), Expanded(flex:3, child: Container(color: Colors.white)), Expanded(flex:6, child: Container(color: Color(0xFF43A047), child: Container(margin: EdgeInsets.all(10), decoration: BoxDecoration(color: Color(0xFF2E7D32), borderRadius: BorderRadius.circular(8)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Row(mainAxisAlignment: MainAxisAlignment.center, children: [homeToken(cols[2],2,0), SizedBox(width:12), homeToken(cols[2],2,1)]), SizedBox(height:12), Row(mainAxisAlignment: MainAxisAlignment.center, children: [homeToken(cols[2],2,2), SizedBox(width:12), homeToken(cols[2],2,3)])])))) ])),
            Expanded(flex:3, child: Row(children: [Expanded(flex:6, child: Container(color: Colors.white)), Expanded(flex:3, child: Container(color: Color(0xFFFFC107), child: Center(child: Container(width: 40, height: 40, decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xFFFFC107), border: Border.all(color: Colors.white, width: 2)), child: Icon(Icons.emoji_events, size: 20))))), Expanded(flex:6, child: Container(color: Colors.white))])),
            Expanded(flex:6, child: Row(children: [Expanded(flex:6, child: Container(color: Color(0xFFFBC02D), child: Container(margin: EdgeInsets.all(10), decoration: BoxDecoration(color: Color(0xFFF9A825), borderRadius: BorderRadius.circular(8)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Row(mainAxisAlignment: MainAxisAlignment.center, children: [homeToken(cols[1],1,0), SizedBox(width:12), homeToken(cols[1],1,1)]), SizedBox(height:12), Row(mainAxisAlignment: MainAxisAlignment.center, children: [homeToken(cols[1],1,2), SizedBox(width:12), homeToken(cols[1],1,3)])])))), Expanded(flex:3, child: Container(color: Colors.white)), Expanded(flex:6, child: Container(color: Color(0xFF1E88E5), child: Container(margin: EdgeInsets.all(10), decoration: BoxDecoration(color: Color(0xFF1565C0), borderRadius: BorderRadius.circular(8)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Row(mainAxisAlignment: MainAxisAlignment.center, children: [homeToken(cols[3],3,0), SizedBox(width:12), homeToken(cols[3],3,1)]), SizedBox(height:12), Row(mainAxisAlignment: MainAxisAlignment.center, children: [homeToken(cols[3],3,2), SizedBox(width:12), homeToken(cols[3],3,3)])])))) ])),
          ])),
          for (int p = 0; p < 4; p++) for (int t = 0; t < 4; t++) if (tokens[p][t] >= 0) Positioned(left: pathPos[tokens[p][t]][0] * size, top: pathPos[tokens[p][t]][1] * size, child: GestureDetector(onTap: () { if (p == turn) moveToken(t); }, child: Container(width: 32, height: 32, decoration: BoxDecoration(shape: BoxShape.circle, color: cols[p], border: Border.all(color: Colors.white, width: 2.5)), child: Icon(Icons.star, size: 16, color: Colors.yellow)))),
        ])))),
      Container(margin: EdgeInsets.all(10), padding: EdgeInsets.all(10), decoration: BoxDecoration(color: Color(0xFF0F1E42), borderRadius: BorderRadius.circular(20)), child: Row(children: [
        Container(width: 56, height: 56, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)), child: Center(child: Icon(Icons.casino, size: 32))),
        SizedBox(width: 8), Container(width: 56, height: 56, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)), child: Center(child: Text("$dice", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)))),
        SizedBox(width: 10), Expanded(child: GestureDetector(onTap: rollDice, child: Container(height: 52, decoration: BoxDecoration(color: canRoll? Color(0xFF2EC4B6) : Colors.grey, borderRadius: BorderRadius.circular(14)), child: Center(child: Text(canRoll? "ROLL" : "حرك", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)))))),
      ])),
    ])))));
  }
}
