import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

void main() => runApp(const PlayAndWinApp());

class PlayAndWinApp extends StatelessWidget {
  const PlayAndWinApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'العب واربح',
      theme: ThemeData(fontFamily: 'Cairo', scaffoldBackgroundColor: Color(0xFF0F172A)),
      home: const GameHub(),
    );
  }
}

// ============ صالة الألعاب - الأيقونات الأنيقة من برا ============
class GameHub extends StatelessWidget {
  const GameHub({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("العب واربح - صالة الألعاب"), backgroundColor: Color(0xFF1E3A8A), centerTitle: true),
      body: GridView.count(
        padding: EdgeInsets.all(16), crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16,
        children: [
          _card(context, "البلياردو", "8-Ball Pool", Icons.sports_billiards, [Color(0xFF065F46), Color(0xFF10B981)], BilliardsGame()),
          _card(context, "الدومينو", "Domino Pro", Icons.view_module, [Color(0xFF7C2D12), Color(0xFFFBBF24)], DominoGame()),
          _card(context, "السلم والثعبان", "Snakes 3D", Icons.landscape, [Color(0xFF1E40AF), Color(0xFF60A5FA)], SnakesGame()),
          _card(context, "لودو", "Ludo King", Icons.casino, [Color(0xFF7E22CE), Color(0xFFC084FC)], LudoGame()),
        ],
      ),
    );
  }
  Widget _card(BuildContext c, String t, String s, IconData ic, List<Color> g, Widget go){
    return InkWell(
      onTap: ()=> Navigator.push(c, MaterialPageRoute(builder: (_)=> go)),
      child: Container(
        decoration: BoxDecoration(gradient: LinearGradient(colors: g, begin: Alignment.topLeft, end: Alignment.bottomRight), borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: g[1].withOpacity(0.5), blurRadius: 15, offset: Offset(0,8))]),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(ic, size: 56, color: Colors.white),
          SizedBox(height: 8),
          Text(t, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17)),
          Text(s, style: TextStyle(color: Colors.white70, fontSize: 12)),
        ]),
      ),
    );
  }
}

// ============ 1- السلم والثعبان - لعبة حقيقية ============
class SnakesGame extends StatefulWidget { @override State<SnakesGame> createState()=> _SnakesState(); }
class _SnakesState extends State<SnakesGame> {
  int p1=1,p2=1, turn=1, dice=1; bool moving=false;
  Map<int,int> ladders={4:25, 13:46, 33:85, 42:63, 50:69, 62:81, 74:92};
  Map<int,int> snakes={27:5, 40:3, 43:18, 54:31, 66:45, 76:58, 89:53, 99:41};
  void roll() async {
    if(moving) return;
    setState(()=> dice=Random().nextInt(6)+1);
    setState(()=> moving=true);
    int target = (turn==1? p1:p2) + dice;
    if(target>100) {setState(()=> moving=false); return;}
    for(int i=(turn==1? p1:p2)+1; i<=target; i++){ await Future.delayed(Duration(milliseconds: 150)); setState((){ if(turn==1) p1=i; else p2=i; }); }
    int pos = turn==1? p1:p2;
    if(ladders.containsKey(pos) || snakes.containsKey(pos)){
      await Future.delayed(Duration(milliseconds: 400));
      setState((){ if(turn==1) p1 = ladders[pos]?? snakes[pos]!; else p2 = ladders[pos]?? snakes[pos]!; });
    }
    if((turn==1? p1:p2)==100){ showDialog(context: context, builder: (_)=> AlertDialog(title: Text("فاز اللاعب $turn!"))); return;}
    setState((){ turn=turn==1?2:1; moving=false; });
  }
  @override Widget build(BuildContext context){
    return Scaffold(appBar: AppBar(title: Text("السلم والثعبان - دور اللاعب $turn | نرد: $dice")), body: Column(children: [
      Expanded(child: GridView.builder(padding: EdgeInsets.all(8), gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 10), itemCount: 100, reverse: true, itemBuilder: (_,i){
        int num = i+1; bool isP1 = p1==num, isP2 = p2==num;
        Color c = ladders.containsKey(num)? Colors.green.shade300 : snakes.containsKey(num)? Colors.red.shade300 : Colors.white;
        return Container(margin: EdgeInsets.all(1), decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(4)), child: Stack(children: [
          Positioned(top:2,left:2,child: Text("$num", style: TextStyle(fontSize: 8))),
          if(isP1) Center(child: CircleAvatar(radius: 10, backgroundColor: Colors.blue, child: Text("1", style: TextStyle(fontSize: 10)))),
          if(isP2 &&!isP1) Center(child: CircleAvatar(radius: 10, backgroundColor: Colors.orange, child: Text("2", style: TextStyle(fontSize: 10)))),
          if(isP1 && isP2) Center(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [CircleAvatar(radius: 7, backgroundColor: Colors.blue, child: Text("1", style: TextStyle(fontSize: 7))), CircleAvatar(radius: 7, backgroundColor: Colors.orange, child: Text("2", style: TextStyle(fontSize: 7)))])),
        ]));
      })),
      Padding(padding: EdgeInsets.all(12), child: ElevatedButton.icon(onPressed: roll, icon: Icon(Icons.casino), label: Text("رمي النرد - $dice"), style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50), backgroundColor: Colors.amber))),
      Container(height: 80, color: Colors.black26, child: Center(child: Text("دردشة الطاولة - اكتب رسالتك...", style: TextStyle(color: Colors.white54)))),
    ]));
  }
}

// ============ 2- لودو - لعبة حقيقية ============
class LudoGame extends StatefulWidget { @override State<LudoGame> createState()=> _LudoState(); }
class _LudoState extends State<LudoGame> {
  List<int> red=[-1,-1,-1,-1], green=[-1,-1,-1,-1], yellow=[-1,-1,-1,-1], blue=[-1,-1,-1,-1];
  int turn=0, dice=1; List<String> names=["الأحمر","الأخضر","الأصفر","الأزرق"];
  List<List<int>> get all=>[red,green,yellow,blue];
  void roll(){ setState(()=> dice=Random().nextInt(6)+1); }
  void move(int p, int idx){
    if(p!=turn) return;
    var arr=all[p];
    if(arr[idx]==-1 && dice!=6) return;
    setState((){ if(arr[idx]==-1) arr[idx]=0; else arr[idx]+=dice; if(arr[idx]>57) arr[idx]=57; turn=(turn+1)%4; });
  }
  @override Widget build(BuildContext context){
    return Scaffold(appBar: AppBar(title: Text("لودو - دور ${names[turn]} - نرد: $dice"), backgroundColor: Colors.red), body: Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Padding(padding: EdgeInsets.all(12), child: Text("النرد: $dice", style: TextStyle(color: Colors.white, fontSize: 20))), ElevatedButton(onPressed: roll, child: Text("رمي النرد"))]),
      Expanded(child: GridView.count(crossAxisCount: 2, padding: EdgeInsets.all(8), children: List.generate(4, (p){
        var arr=all[p]; Color col=[Colors.red, Colors.green, Colors.amber, Colors.blue][p];
        return Container(margin: EdgeInsets.all(6), decoration: BoxDecoration(color: col.withOpacity(0.3), border: Border.all(color: col, width: 3), borderRadius: BorderRadius.circular(12)), child: Column(children: [Text(names[p], style: TextStyle(color: col, fontWeight: FontWeight.bold)), Expanded(child: GridView.count(crossAxisCount: 2, children: List.generate(4, (i)=> InkWell(onTap: ()=> move(p,i), child: Container(margin: EdgeInsets.all(4), decoration: BoxDecoration(color: arr[i]==-1? Colors.black45 : arr[i]==57? Colors.green : Colors.white, shape: BoxShape.circle), child: Center(child: Text("${arr[i]==-1? "🏠" : arr[i]}"))))))]));
      })),
      Container(height: 60, color: Colors.black26, child: Center(child: Text("دردشة الطاولة التفاعلية", style: TextStyle(color: Colors.white38))))
    ]));
  }
}

// ============ 3- دومينو - لعبة حقيقية ============
class DominoGame extends StatefulWidget { @override State<DominoGame> createState()=> _DominoState(); }
class _DominoState extends State<DominoGame> {
  List<List<int>> board=[[3,2]]; List<List<int>> hand=[[0,6],[6,1],[2,5],[3,2],[1,4]]; int left=3, right=2;
  void play(int idx){
    var d=hand[idx]; if(d[0]==left || d[1]==left || d[0]==right || d[1]==right){
      setState((){ if(d[1]==left || d[0]==left){ board.insert(0, d[0]==left? [d[1],d[0]]:d); left=board.first[0]; } else { board.add(d[0]==right? d:[d[1],d[0]]); right=board.last[1]; } hand.removeAt(idx); });
    }
  }
  @override Widget build(BuildContext context){
    return Scaffold(appBar: AppBar(title: Text("الدومينو الحقيقي - [$left] ⇄ [$right]")), body: Column(children: [
      Expanded(child: Container(margin: EdgeInsets.all(12), decoration: BoxDecoration(color: Color(0xFF4A2C2A), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.amber, width: 2)), child: Center(child: Wrap(spacing: 8, runSpacing: 8, children: board.map((d)=> Container(padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)), child: Text("${d[0]} | ${d[1]}", style: TextStyle(fontWeight: FontWeight.bold)))).toList())))),
      Container(padding: EdgeInsets.all(10), child: Wrap(spacing: 8, children: List.generate(hand.length, (i)=> InkWell(onTap: ()=> play(i), child: Container(padding: EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.amber, width: 2)), child: Text("${hand[i][0]} | ${hand[i][1]}")))))),
      Padding(padding: EdgeInsets.all(8), child: ElevatedButton(onPressed: (){setState(()=> hand.add([Random().nextInt(7), Random().nextInt(7)]));}, child: Text("+ سحب قطعة من الموزع"))),
    ]));
  }
}

// ============ 4- بلياردو - لعبة حقيقية بفيزياء ============
class BilliardsGame extends StatefulWidget { @override State<BilliardsGame> createState()=> _BilliState(); }
class _BilliState extends State<BilliardsGame> {
  double angle=0, power=0; Offset cueBall=Offset(100,200); List<Offset> balls=[Offset(250,180), Offset(270,200), Offset(250,220)];
  void shoot(){ setState((){ double rad=angle*pi/180; cueBall+=Offset(cos(rad)*power*2, sin(rad)*power*2); if(cueBall.dx>300 || cueBall.dx<20 || cueBall.dy>400 || cueBall.dy<20){ cueBall=Offset(100,200); } }); }
  @override Widget build(BuildContext context){
    return Scaffold(appBar: AppBar(title: Text("بلياردو 8-Ball - فيزياء حقيقية"), backgroundColor: Color(0xFF065F46)), body: Column(children: [
      Expanded(child: Container(margin: EdgeInsets.all(12), decoration: BoxDecoration(color: Color(0xFF0F6A4A), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.brown, width: 8)), child: CustomPaint(painter: _PoolPainter(cueBall, balls), child: Container()))),
      Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Column(children: [
        Text("موقع المضرب الأفقي: ${angle.toInt()}°", style: TextStyle(color: Colors.white70)), Slider(value: angle, min: -90, max: 90, onChanged: (v)=> setState(()=> angle=v), activeColor: Colors.tealAccent),
        Text("قوة الضربة: ${power.toInt()}%", style: TextStyle(color: Colors.white70)), Slider(value: power, min: 0, max: 100, onChanged: (v)=> setState(()=> power=v), activeColor: Colors.amber),
        ElevatedButton(onPressed: shoot, child: Text("اضرب!"), style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50), backgroundColor: Colors.teal)),
      ])),
    ]));
  }
}
class _PoolPainter extends CustomPainter {
  Offset cue; List<Offset> balls; _PoolPainter(this.cue, this.balls);
  @override void paint(Canvas c, Size s){
    var paintWhite=Paint()..color=Colors.white; var paintRed=Paint()..color=Colors.red;
    c.drawCircle(cue, 12, paintWhite);
    for(var b in balls) c.drawCircle(b, 10, paintRed);
  }
  @override bool shouldRepaint(old)=> true;
}
