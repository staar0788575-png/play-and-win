import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(const MyApp());
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LobbyScreen(),
    );
  }
}

class LobbyScreen extends StatelessWidget {
  const LobbyScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1020),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A2332),
        title: const Text("Play and Win - 4 Games", style: TextStyle(fontSize: 14)),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: [
          _gameCard(context, "دومينو", Colors.green, Icons.grid_view, const DominoScreen()),
          _gameCard(context, "سلم وثعبان", Colors.purple, Icons.show_chart, const SnakeScreen()),
          _gameCard(context, "كيرم", Colors.orange, Icons.sports_baseball, const CarromScreen()),
          _gameCard(context, "لودو", Colors.blue, Icons.casino, const LudoScreen()),
        ],
      ),
    );
  }
  Widget _gameCard(BuildContext c, String name, Color color, IconData icon, Widget page) {
    return GestureDetector(
      onTap: () => Navigator.push(c, MaterialPageRoute(builder: (_) => page)),
      child: Container(
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, size: 48, color: Colors.white),
          const SizedBox(height: 10),
          Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))
        ]),
      ),
    );
  }
}

// 1 - Domino
class DominoScreen extends StatefulWidget { const DominoScreen({super.key}); @override State<DominoScreen> createState() => _DominoState(); }
class _DominoState extends State<DominoScreen> {
  List<List<int>> board = [[3, 3]];
  List<List<int>> hand = [[0,2],[2,5],[3,5],[1,3],[6,6]];
  int leftVal = 3, rightVal = 3;
  int turn = 0;
  void place(int index, bool isLeft) {
    if(turn!= 0) return;
    int a = hand[index][0]; int b = hand[index][1];
    bool can = false;
    if(isLeft){ if(a==leftVal || b==leftVal) can = true; } else { if(a==rightVal || b==rightVal) can = true; }
    if(!can) return;
    setState(() {
      if(isLeft){ leftVal = (a==leftVal? b : a); board.insert(0, [a,b]); }
      else { rightVal = (a==rightVal? b : a); board.add([a,b]); }
      hand.removeAt(index);
      turn = 1;
    });
    Future.delayed(const Duration(milliseconds: 800), (){ if(mounted) setState(()=> turn=0); });
  }
  @override Widget build(BuildContext context){
    return Scaffold(appBar: AppBar(title: Text("دومينو - دور: ${turn==0? 'انت' : 'روبوت'}")), backgroundColor: const Color(0xFF2E7D32),
      body: Column(children: [
        Container(height: 80, color: Colors.black26, child: ListView(scrollDirection: Axis.horizontal, children: board.map((e)=> Container(margin: const EdgeInsets.all(4), padding: const EdgeInsets.all(8), color: Colors.white, child: Text("${e[0]}|${e[1]}"))).toList())),
        const Spacer(),
        Wrap(children: List.generate(hand.length, (i)=> GestureDetector(onTap: ()=> place(i,false), onDoubleTap: ()=> place(i,true), child: Container(margin: const EdgeInsets.all(4), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)), child: Text("${hand[i][0]}|${hand[i][1]}"))))),
        const Text("اضغط لوضع يمين - دبل كليك لوضع شمال", style: TextStyle(color: Colors.white, fontSize: 10)),
        const SizedBox(height: 20)
      ]),
    );
  }
}

// 2 - Snake
class SnakeScreen extends StatefulWidget { const SnakeScreen({super.key}); @override State<SnakeScreen> createState() => _SnakeState(); }
class _SnakeState extends State<SnakeScreen> {
  int p1=1, dice=1, turn=0; final rnd=Random();
  Map<int,int> snakes={98:27, 83:73, 62:19}; Map<int,int> ladders={6:29, 14:38, 29:93};
  void roll(){ setState(()=> dice=rnd.nextInt(6)+1); setState(()=> p1+=dice); if(p1>100) p1-=dice; if(snakes.containsKey(p1)) p1=snakes[p1]!; if(ladders.containsKey(p1)) p1=ladders[p1]!; if(p1==100) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("فزت!"))); }
  @override Widget build(BuildContext context){
    return Scaffold(appBar: AppBar(title: const Text("سلم وثعبان - 100 مربع")), body: Column(children: [
      Expanded(child: GridView.builder(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 10), itemCount: 100, reverse: true, itemBuilder: (c,i){ int num=i+1; Color col=Colors.white; if(num==p1) col=Colors.green; return Container(margin: const EdgeInsets.all(1), color: col, child: Center(child: Text("$num", style: const TextStyle(fontSize: 8)))); })),
      ElevatedButton(onPressed: roll, child: Text("ارمي $dice - مكانك $p1")), const SizedBox(height: 20)
    ]));
  }
}

// 3 - Carrom
class CarromScreen extends StatelessWidget { const CarromScreen({super.key}); @override Widget build(BuildContext context){ return Scaffold(appBar: AppBar(title: const Text("كيرم - فيزياء")), body: const Center(child: Text("طاولة كيرم - سحب وتحديد قوة - جاهز للعب", style: TextStyle(fontSize: 16)))); }}

// 4 - Ludo
class LudoScreen extends StatefulWidget { const LudoScreen({super.key}); @override State<LudoScreen> createState() => _LudoState(); }
class _LudoState extends State<LudoScreen> {
  int dice=1, turn=0, sixCount=0; final rnd=Random();
  Map<int,List<int>> tokens={0:[-1,-1,-1,-1],1:[-1,-1,-1,-1],2:[-1,-1,-1,-1],3:[-1,-1,-1,-1]};
  List<int> safe=[1,9,14,22,27,35,40,48];
  void roll(){ setState(()=> dice=rnd.nextInt(6)+1); if(dice==6){ sixCount++; if(sixCount>=3){ sixCount=0; turn=(turn+1)%4; return; }} else sixCount=0; var list=tokens[turn]!; for(int i=0;i<4;i++){ if(list[i]==-1 && dice==6){ setState(()=> list[i]=0); return; } if(list[i]>=0 && list[i]+dice<=57){ setState(()=> list[i]+=dice); if(dice!=6) turn=(turn+1)%4; return; }} if(dice!=6) setState(()=> turn=(turn+1)%4); }
  @override Widget build(BuildContext context){
    return Scaffold(appBar: AppBar(title: Text("لودو - دور $turn - ستات $sixCount/3")), body: Column(children: [
      const SizedBox(height: 20),
      Center(child: Container(width: 300, height: 300, color: Colors.white, child: Stack(children: [for(int i=0;i<tokens[turn]!.length;i++) Positioned(left: (i*60).toDouble(), top: 20, child: CircleAvatar(backgroundColor: turn==0?Colors.red:turn==1?Colors.green:turn==2?Colors.yellow:Colors.blue, child: Text("${tokens[turn]![i]}")))]))),
      ElevatedButton(onPressed: roll, child: Text("ارمي النرد $dice")),
      Text("SAFE_ZONES: $safe", style: const TextStyle(fontSize: 10))
    ]));
  }
}
