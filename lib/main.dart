import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(const PlayAndWinApp());

class PlayAndWinApp extends StatelessWidget {
  const PlayAndWinApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'العب واربح',
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFF0F172A)),
      home: const GameHub(),
    );
  }
}

class GameHub extends StatelessWidget {
  const GameHub({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("العب واربح - صالة الألعاب"), backgroundColor: const Color(0xFF1E3A8A), centerTitle: true),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16,
        children: [
          _card(context, "البلياردو", "Pool", Icons.circle, [const Color(0xFF065F46), const Color(0xFF10B981)], const BilliardsGame()),
          _card(context, "الدومينو", "Domino", Icons.view_module, [const Color(0xFF7C2D12), const Color(0xFFFBBF24)], const DominoGame()),
          _card(context, "السلم والثعبان", "S&L", Icons.map, [const Color(0xFF1E40AF), const Color(0xFF60A5FA)], const SnakesGame()),
          _card(context, "لودو", "Ludo", Icons.casino, [const Color(0xFF7E22CE), const Color(0xFFC084FC)], const LudoGame()),
        ],
      ),
    );
  }
  Widget _card(BuildContext c, String t, String s, IconData ic, List<Color> g, Widget go){
    return InkWell(
      onTap: () => Navigator.push(c, MaterialPageRoute(builder: (_) => go)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: g, begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(ic, size: 56, color: Colors.white),
          const SizedBox(height: 8),
          Text(t, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17)),
          Text(s, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ]),
      ),
    );
  }
}

// ===== السلم والثعبان شغال =====
class SnakesGame extends StatefulWidget { const SnakesGame({super.key}); @override State<SnakesGame> createState()=> _SnakesState(); }
class _SnakesState extends State<SnakesGame> {
  int p1=1,p2=1, turn=1, dice=1; bool moving=false;
  Map<int,int> ladders={4:25, 13:46, 33:85, 50:69, 62:81, 74:92};
  Map<int,int> snakes={27:5, 40:3, 43:18, 54:31, 66:45, 89:53, 99:41};
  void roll() async {
    if(moving) return;
    setState(()=> dice=Random().nextInt(6)+1);
    setState(()=> moving=true);
    int cur = turn==1? p1:p2;
    int target = cur + dice; if(target>100){ setState(()=> moving=false); return; }
    for(int i=cur+1; i<=target; i++){ await Future.delayed(const Duration(milliseconds: 150)); setState((){ if(turn==1) p1=i; else p2=i; }); }
    int pos = turn==1? p1:p2;
    if(ladders.containsKey(pos) || snakes.containsKey(pos)){ await Future.delayed(const Duration(milliseconds: 400)); setState((){ if(turn==1) p1=ladders[pos]??snakes[pos]!; else p2=ladders[pos]??snakes[pos]!; }); }
    if((turn==1? p1:p2)>=100){ if(!mounted) return; showDialog(context: context, builder: (_)=> AlertDialog(title: Text("فاز اللاعب $turn!"))); }
    else{ setState((){ turn=turn==1?2:1; moving=false; }); }
  }
  @override Widget build(BuildContext context){
    return Scaffold(appBar: AppBar(title: Text("السلم والثعبان - دور $turn - نرد $dice")), body: Column(children: [
      Expanded(child: GridView.builder(padding: const EdgeInsets.all(8), gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 10), itemCount: 100, reverse: true, itemBuilder: (_,i){
        int num=i+1; bool isP1=p1==num, isP2=p2==num; Color c=ladders.containsKey(num)? Colors.green.shade300 : snakes.containsKey(num)? Colors.red.shade300 : Colors.white;
        return Container(margin: const EdgeInsets.all(1), decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(4)), child: Stack(children: [
          Text(" $num", style: const TextStyle(fontSize: 8)),
          if(isP1 && isP2) const Center(child: Text("🔵🟠", style: TextStyle(fontSize: 10))),
          if(isP1 &&!isP2) const Center(child: Text("🔵")),
          if(isP2 &&!isP1) const Center(child: Text("🟠")),
        ]));
      })),
      Padding(padding: const EdgeInsets.all(12), child: ElevatedButton(onPressed: roll, style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50), backgroundColor: Colors.amber), child: Text("رمي النرد $dice"))),
    ]));
  }
}

// ===== لودو مبسط شغال =====
class LudoGame extends StatefulWidget { const LudoGame({super.key}); @override State<LudoGame> createState()=> _LudoState(); }
class _LudoState extends State<LudoGame> {
  List<int> red=[-1,-1,-1,-1]; int turn=0, dice=1;
  void roll()=> setState(()=> dice=Random().nextInt(6)+1);
  @override Widget build(BuildContext context){
    return Scaffold(appBar: AppBar(title: Text("لودو - نرد $dice - دور ${turn+1}")), body: Column(children: [
      Padding(padding: const EdgeInsets.all(12), child: ElevatedButton(onPressed: roll, child: Text("رمي النرد: $dice"))),
      Expanded(child: GridView.count(crossAxisCount: 2, padding: const EdgeInsets.all(12), children: List.generate(4, (p){
        var arr=p==0?red:red; Color col=[Colors.red, Colors.green, Colors.amber, Colors.blue][p];
        return Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(border: Border.all(color: col, width: 3), borderRadius: BorderRadius.circular(12)), child: GridView.count(crossAxisCount: 2, children: List.generate(4, (i)=> InkWell(onTap: (){ if(p==turn && (red[i]==-1 && dice==6 || red[i]!=-1)){ setState((){ if(red[i]==-1) red[i]=0; else red[i]+=dice; turn=(turn+1)%4; }); } }, child: Container(margin: const EdgeInsets.all(6), decoration: BoxDecoration(color: red[i]==-1? Colors.black45: Colors.white, shape: BoxShape.circle), child: Center(child: Text(red[i]==-1? "🏠":"${red[i]}")))))));
      }))),
    ]));
  }
}

// ===== دومينو شغال =====
class DominoGame extends StatefulWidget { const DominoGame({super.key}); @override State<DominoGame> createState()=> _DominoState(); }
class _DominoState extends State<DominoGame> {
  List<List<int>> board=[[3,2]]; List<List<int>> hand=[[0,6],[6,1],[2,5],[1,4]]; int left=3, right=2;
  void play(int idx){
    var d=hand[idx]; if(d[0]==left || d[1]==left || d[0]==right || d[1]==right){
      setState((){ if(d[0]==left || d[1]==left){ board.insert(0, d[0]==left? [d[1],d[0]]:d); left=board.first[0]; } else { board.add(d[0]==right? d:[d[1],d[0]]); right=board.last[1]; } hand.removeAt(idx); });
    }
  }
  @override Widget build(BuildContext context){
    return Scaffold(appBar: AppBar(title: Text("دومينو [$left - $right]")), body: Column(children: [
      Expanded(child: Container(margin: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFF4A2C2A), borderRadius: BorderRadius.circular(20)), child: Center(child: Wrap(spacing: 8, children: board.map((d)=> Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)), child: Text("${d[0]}|${d[1]}"))).toList())))),
      Wrap(spacing: 8, children: List.generate(hand.length, (i)=> InkWell(onTap: ()=> play(i), child: Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)), child: Text("${hand[i][0]}|${hand[i][1]}"))))),
    ]));
  }
}

// ===== بلياردو شغال =====
class BilliardsGame extends StatefulWidget { const BilliardsGame({super.key}); @override State<BilliardsGame> createState()=> _BilliState(); }
class _BilliState extends State<BilliardsGame> {
  double angle=0, power=20; Offset cue=const Offset(100,200); List<Offset> balls=[const Offset(250,200)];
  void shoot(){ setState((){ double r=angle*3.1416/180; cue+=Offset(cos(r)*power, sin(r)*power); if(cue.dx>320 || cue.dx<0 || cue.dy>500 || cue.dy<0) cue=const Offset(100,200); }); }
  @override Widget build(BuildContext context){
    return Scaffold(appBar: AppBar(title: const Text("بلياردو")), body: Column(children: [
      Expanded(child: Container(margin: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFF0F6A4A), borderRadius: BorderRadius.circular(20)), child: CustomPaint(painter: _PoolPainter(cue, balls), child: Container()))),
      Slider(value: angle, min: -90, max: 90, onChanged: (v)=> setState(()=> angle=v)),
      Slider(value: power, min: 0, max: 100, onChanged: (v)=> setState(()=> power=v)),
      ElevatedButton(onPressed: shoot, child: const Text("اضرب!")),
    ]));
  }
}
class _PoolPainter extends CustomPainter {
  Offset cue; List<Offset> balls; _PoolPainter(this.cue, this.balls);
  @override void paint(Canvas c, Size s){ c.drawCircle(cue, 12, Paint()..color=Colors.white); for(var b in balls) c.drawCircle(b, 10, Paint()..color=Colors.red); }
  @override bool shouldRepaint(old)=> true;
}
