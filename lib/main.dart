import 'package:flutter/material.dart';
import 'dart:math';
void main() => runApp(MaterialApp(home: FinalApp(), debugShowCheckedModeBanner: false));

class FinalApp extends StatefulWidget { @override _FinalAppState createState() => _FinalAppState(); }
class _FinalAppState extends State<FinalApp> {
  int idx = 0;
  var pages = [LudoGame(), CarromBattle(), DominoBattle(), SnakeLadderPro()];
  @override Widget build(BuildContext context) {
    return Scaffold(
      body: pages[idx],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: idx, onTap: (i)=>setState(()=>idx=i),
        type: BottomNavigationBarType.fixed, backgroundColor: Color(0xFF16213E),
        selectedItemColor: Colors.amber, unselectedItemColor: Colors.white54,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.casino), label: "لودو"),
          BottomNavigationBarItem(icon: Icon(Icons.circle), label: "كيرم"),
          BottomNavigationBarItem(icon: Icon(Icons.view_module), label: "دومينو"),
          BottomNavigationBarItem(icon: Icon(Icons.stairs), label: "السلم"),
        ],
      ),
    );
  }
}

// 1- LUDO
class LudoGame extends StatefulWidget { @override _LudoGameState createState() => _LudoGameState(); }
class _LudoGameState extends State<LudoGame> {
  int dice=1, turn=0;
  List<List<int>> tokens = List.generate(4, (_) => List.filled(4, -1));
  List<int> safeSpots = [0,8,13,21,26,34,39,47];
  void roll(){ setState((){
    dice=Random().nextInt(6)+1;
    int startPos=turn*13;
    for(int i=0;i<4;i++){
      if(tokens[turn][i]==-1 && dice==6){ tokens[turn][i]=startPos; break; }
      else if(tokens[turn][i]>=0){ int np=tokens[turn][i]+dice; if(np>51) np-=52;
        if(!safeSpots.contains(np)){ for(int p=0;p<4;p++) for(int t=0;t<4;t++) if(p!=turn && tokens[p][t]==np) tokens[p][t]=-1; }
        tokens[turn][i]=np; break;
      }
    }
    turn=(turn+1)%4;
  });}
  @override Widget build(BuildContext context){
    return Container(color: Color(0xFF1A1A2E), child: SafeArea(child: Column(children:[
      AppBar(title: Text("LUDO - 52 Cell, 8 SAFE, Need 6"), backgroundColor: Color(0xFF16213E), automaticallyImplyLeading: false),
      Row(children: List.generate(4, (p)=> Expanded(child: Column(children: List.generate(4, (t)=> Container(margin: EdgeInsets.all(2), width: 20, height: 20, decoration: BoxDecoration(color: tokens[p][t]==-1?Colors.grey:[Colors.red,Colors.green,Colors.yellow,Colors.blue][p], shape: BoxShape.circle))))))),
      ElevatedButton(onPressed: roll, child: Text("🎲 رمي النرد: $dice - دور اللاعب ${turn+1}")),
      Text("8 خانات آمنة لا يمكن الأكل فيها", style: TextStyle(color: Colors.white54))
    ])));
  }
}

// 2- CARROM BATTLE
class CarromBattle extends StatefulWidget { @override _CarromBattleState createState() => _CarromBattleState(); }
class _CarromBattleState extends State<CarromBattle> {
  Offset striker=Offset(150,350);
  List<Offset> whites=List.generate(9, (_)=> Offset(80+Random().nextInt(150).toDouble(), 80+Random().nextInt(150).toDouble()));
  List<Offset> blacks=List.generate(9, (_)=> Offset(80+Random().nextInt(150).toDouble(), 80+Random().nextInt(150).toDouble()));
  Offset queen=Offset(150,150);
  @override Widget build(BuildContext context){
    return Container(color: Color(0xFF1A1A2E), child: SafeArea(child: Column(children:[
      AppBar(title: Text("CARROM BATTLE - اسحب المضرب"), backgroundColor: Color(0xFF16213E), automaticallyImplyLeading: false),
      Expanded(child: GestureDetector(onPanUpdate: (d)=> setState(()=> striker+=d.delta), child: Container(color: Color(0xFFDEB887), child: Stack(children:[
        Positioned(left: queen.dx, top: queen.dy, child: Container(width: 16, height: 16, decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle))),
      ...whites.map((p)=> Positioned(left: p.dx, top: p.dy, child: Container(width: 14, height: 14, decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all())))),
      ...blacks.map((p)=> Positioned(left: p.dx, top: p.dy, child: Container(width: 14, height: 14, decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle)))),
        Positioned(left: striker.dx, top: striker.dy, child: Container(width: 22, height: 22, decoration: BoxDecoration(color: Colors.brown, shape: BoxShape.circle))),
      ])))),
    ])));
  }
}

// 3- DOMINO BATTLE
class DominoBattle extends StatefulWidget { @override _DominoBattleState createState() => _DominoBattleState(); }
class _DominoBattleState extends State<DominoBattle> {
  List<List<int>> myTiles=List.generate(7, (_)=> [Random().nextInt(7), Random().nextInt(7)]);
  List<List<int>> board=[[3,3]]; int leftEnd=3, rightEnd=3;
  void playTile(int index){ setState((){
    var t=myTiles[index];
    if(t[0]==leftEnd){ board.insert(0,t); leftEnd=t[1]; myTiles.removeAt(index); }
    else if(t[1]==leftEnd){ board.insert(0,[t[1],t[0]]); leftEnd=t[0]; myTiles.removeAt(index); }
    else if(t[0]==rightEnd){ board.add(t); rightEnd=t[1]; myTiles.removeAt(index); }
    else if(t[1]==rightEnd){ board.add([t[1],t[0]]); rightEnd=t[0]; myTiles.removeAt(index); }
  });}
  @override Widget build(BuildContext context){
    return Container(color: Color(0xFF1A1A2E), child: SafeArea(child: Column(children:[
      AppBar(title: Text("DOMINO BATTLE - طابق $leftEnd | $rightEnd"), backgroundColor: Color(0xFF16213E), automaticallyImplyLeading: false),
      SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: board.map((t)=> Container(margin: EdgeInsets.all(3), padding: EdgeInsets.all(8), color: Colors.white, child: Text("${t[0]}|${t[1]}", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)))).toList())),
      SizedBox(height: 20), Text("أوراقك (دوس عشان تلعب):", style: TextStyle(color: Colors.white)),
      Wrap(children: List.generate(myTiles.length, (i)=> GestureDetector(onTap: ()=>playTile(i), child: Container(margin: EdgeInsets.all(4), padding: EdgeInsets.all(12), color: Colors.amber, child: Text("${myTiles[i][0]}|${myTiles[i][1]}", style: TextStyle(fontWeight: FontWeight.bold)))))),
    ])));
  }
}

// 4- SNAKE & LADDER PRO - 2 Players + Avatar + Chat + Waiting Room + Gifts + Mic
class SnakeLadderPro extends StatefulWidget { @override _SnakeLadderProState createState() => _SnakeLadderProState(); }
class _SnakeLadderProState extends State<SnakeLadderPro> {
  int p1=1, p2=1, turn=1, dice=1; bool micOn=true, musicOn=false;
  List<String> chat=["يلا نبدأ"]; TextEditingController ctrl=TextEditingController();
  Map<int,int> snakes={99:54, 70:55, 52:42, 56:8, 43:17}; Map<int,int> ladders={3:22, 5:8, 11:26, 20:29, 27:56, 33:49, 51:67, 80:99, 71:92};
  void roll(){ setState((){
    dice=Random().nextInt(6)+1;
    if(turn==1){ if(p1+dice<=100){ p1+=dice; if(snakes.containsKey(p1)) p1=snakes[p1]!; if(ladders.containsKey(p1)) p1=ladders[p1]!; } turn=2; }
    else { if(p2+dice<=100){ p2+=dice; if(snakes.containsKey(p2)) p2=snakes[p2]!; if(ladders.containsKey(p2)) p2=ladders[p2]!; } turn=1; }
  });}
  @override Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color(0xFF0F3460),
      appBar: AppBar(backgroundColor: Color(0xFF16213E), title: Row(children:[
        CircleAvatar(backgroundImage: NetworkImage("https://i.pravatar.cc/100?img=1")), SizedBox(width:4), Text("انت"),
        Spacer(),
        IconButton(icon: Icon(micOn?Icons.mic:Icons.mic_off, color: micOn?Colors.green:Colors.red), onPressed: ()=>setState(()=>micOn=!micOn)),
        IconButton(icon: Icon(Icons.music_note, color: musicOn?Colors.purple:Colors.white), onPressed: ()=>setState(()=>musicOn=!musicOn)),
        CircleAvatar(backgroundImage: NetworkImage("https://i.pravatar.cc/100?img=2")), SizedBox(width:4), Text("خصم"),
      ])),
      body: Column(children:[
        Container(height: 45, color: Colors.black26, child: ListView(scrollDirection: Axis.horizontal, children: [
          Padding(padding: EdgeInsets.all(6), child: Chip(label: Text("غرفة انتظار"), backgroundColor: Colors.amber)),
        ...List.generate(3, (i)=> Padding(padding: EdgeInsets.all(4), child: CircleAvatar(backgroundImage: NetworkImage("https://i.pravatar.cc/100?img=${i+5}")))),
          ElevatedButton(onPressed: (){}, child: Text("+ دعوة")),
        ])),
        Expanded(flex: 3, child: GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 10), itemCount: 100, itemBuilder: (c,i){
          int num=100-i; bool isP1=p1==num; bool isP2=p2==num;
          return Container(decoration: BoxDecoration(border: Border.all(color: Colors.white12), color: snakes.containsKey(num)?Colors.red.withOpacity(0.3): ladders.containsKey(num)?Colors.green.withOpacity(0.3): Colors.white10),
            child: Stack(children:[
              Text("$num", style: TextStyle(color: Colors.white38, fontSize: 7)),
              if(snakes.containsKey(num)) Icon(Icons.bug_report, size: 10, color: Colors.red),
              if(ladders.containsKey(num)) Icon(Icons.trending_up, size: 10, color: Colors.green),
              if(isP1) CircleAvatar(radius: 9, backgroundImage: NetworkImage("https://i.pravatar.cc/100?img=1")),
              if(isP2) Positioned(right: 0, child: CircleAvatar(radius: 9, backgroundImage: NetworkImage("https://i.pravatar.cc/100?img=2"))),
            ]));
        })),
        Expanded(child: Column(children:[
          Expanded(child: ListView(children: chat.map((m)=> Text(m, style: TextStyle(color: Colors.white))).toList())),
          Row(children:[
            IconButton(icon: Icon(Icons.card_giftcard, color: Colors.pink), onPressed: ()=> setState(()=> chat.add("🎁 هدية!"))),
            IconButton(icon: Icon(Icons.emoji_emotions, color: Colors.yellow), onPressed: ()=> setState(()=> chat.add("😂🔥"))),
            Expanded(child: TextField(controller: ctrl, style: TextStyle(color: Colors.white), decoration: InputDecoration(hintText: "شات...", hintStyle: TextStyle(color: Colors.white38)))),
            IconButton(icon: Icon(Icons.send, color: Colors.white), onPressed: (){ setState(()=> chat.add(ctrl.text)); ctrl.clear(); }),
            ElevatedButton(onPressed: roll, style: ElevatedButton.styleFrom(backgroundColor: Colors.amber), child: Text("🎲 $dice\nدور $turn", style: TextStyle(color: Colors.black))),
          ]),
        ])),
      ]),
    );
  }
}
