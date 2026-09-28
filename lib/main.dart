import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(MaterialApp(home: GameHub(), debugShowCheckedModeBanner: false));

class GameHub extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A1A2E),
      appBar: AppBar(title: Text("4 Players Cafe"), backgroundColor: Color(0xFF16213E)),
      body: Column(
        children: [
          Expanded(child: LudoGame()),
          Divider(color: Colors.white24),
          Expanded(child: CarromBattle()),
          Divider(color: Colors.white24),
          Expanded(child: DominoBattle()),
        ],
      ),
    );
  }
}

// --- 1. LUDO - 52 cell, 8 SAFE, 4 tokens, need 6 to out ---
class LudoGame extends StatefulWidget { @override _LudoGameState createState() => _LudoGameState(); }
class _LudoGameState extends State<LudoGame> {
  int dice = 1; int turn = 0;
  List<List<int>> tokens = List.generate(4, (_) => List.filled(4, -1)); // -1 = home, 0-51 path, 100+ home column
  List<int> safeSpots = [0,8,13,21,26,34,39,47];
  void roll() {
    setState(() {
      dice = Random().nextInt(6)+1;
      // لوجيك الخروج: لو 6 طلع قطعة من البيت للبداية
      int startPos = turn * 13;
      for(int i=0;i<4;i++){
        if(tokens[turn][i]==-1 && dice==6){ tokens[turn][i]=startPos; break; }
        else if(tokens[turn][i]>=0 && tokens[turn][i]<100){
          int newPos = tokens[turn][i]+dice;
          if(newPos>51) newPos-=52;
          // أكل الخصم لو مش في SAFE
          if(!safeSpots.contains(newPos)){
            for(int p=0;p<4;p++) for(int t=0;t<4;t++) if(p!=turn && tokens[p][t]==newPos) tokens[p][t]=-1;
          }
          tokens[turn][i]=newPos; break;
        }
      }
      turn = (turn+1)%4;
    });
  }
  @override Widget build(BuildContext context) {
    return Column(children:[
      Text("LUDO - 4 Players | SAFE: ${safeSpots.length} spots | Need 6 to out", style: TextStyle(color: Colors.white)),
      Row(children: List.generate(4, (p) => Expanded(child: Row(children: List.generate(4, (t) => Container(margin: EdgeInsets.all(2), width: 12, height: 12, color: tokens[p][t]==-1?Colors.grey:[Colors.red,Colors.green,Colors.yellow,Colors.blue][p])))))),
      ElevatedButton(onPressed: roll, child: Text("Roll Dice: $dice - Player ${turn+1}")),
    ]);
  }
}

// --- 2. CARROM BATTLE - Striker drag, 9+9+Queen ---
class CarromBattle extends StatefulWidget { @override _CarromBattleState createState() => _CarromBattleState(); }
class _CarromBattleState extends State<CarromBattle> {
  Offset striker = Offset(150, 350);
  List<Offset> whites = List.generate(9, (i) => Offset(100+Random().nextInt(100).toDouble(), 100+Random().nextInt(100).toDouble()));
  List<Offset> blacks = List.generate(9, (i) => Offset(100+Random().nextInt(100).toDouble(), 100+Random().nextInt(100).toDouble()));
  Offset queen = Offset(150, 150);
  void onDrag(DragUpdateDetails d){ setState(()=> striker+=d.delta); }
  @override Widget build(BuildContext context){
    return GestureDetector(
      onPanUpdate: onDrag,
      child: Container(color: Color(0xFFDEB887), child: Stack(children:[
        Text("CARROM BATTLE - Drag Striker", style: TextStyle(color: Colors.black)),
        Positioned(left: queen.dx, top: queen.dy, child: Container(width: 14, height: 14, decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle))),
       ...whites.map((p)=> Positioned(left: p.dx, top: p.dy, child: Container(width: 12, height: 12, decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all())))),
       ...blacks.map((p)=> Positioned(left: p.dx, top: p.dy, child: Container(width: 12, height: 12, decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle)))),
        Positioned(left: striker.dx, top: striker.dy, child: Container(width: 20, height: 20, decoration: BoxDecoration(color: Colors.brown, shape: BoxShape.circle))),
      ])),
    );
  }
}

// --- 3. DOMINO BATTLE - 7 tiles, match left/right ---
class DominoBattle extends StatefulWidget { @override _DominoBattleState createState() => _DominoBattleState(); }
class _DominoBattleState extends State<DominoBattle> {
  List<List<int>> myTiles = List.generate(7, (_) => [Random().nextInt(7), Random().nextInt(7)]);
  List<List<int>> board = [[3,3]];
  int leftEnd=3, rightEnd=3;
  void playTile(int index){
    setState((){
      var t = myTiles[index];
      if(t[0]==leftEnd){ board.insert(0, t); leftEnd=t[1]; myTiles.removeAt(index); }
      else if(t[1]==leftEnd){ board.insert(0, [t[1],t[0]]); leftEnd=t[0]; myTiles.removeAt(index); }
      else if(t[0]==rightEnd){ board.add(t); rightEnd=t[1]; myTiles.removeAt(index); }
      else if(t[1]==rightEnd){ board.add([t[1],t[0]]); rightEnd=t[0]; myTiles.removeAt(index); }
    });
  }
  @override Widget build(BuildContext context){
    return Column(children:[
      Text("DOMINO BATTLE - Match ${leftEnd} | ${rightEnd}", style: TextStyle(color: Colors.white)),
      SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: board.map((t)=> Container(margin: EdgeInsets.all(2), padding: EdgeInsets.all(6), color: Colors.white, child: Text("${t[0]}|${t[1]}", style: TextStyle(color: Colors.black)))).toList())),
      SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: List.generate(myTiles.length, (i)=> GestureDetector(onTap: ()=>playTile(i), child: Container(margin: EdgeInsets.all(2), padding: EdgeInsets.all(8), color: Colors.amber, child: Text("${myTiles[i][0]}|${myTiles[i][1]}")))))),
    ]);
  }
}
