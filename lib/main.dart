import 'package:flutter/material.dart';
import 'dart:math';

// ==================== APP ====================
void main() => runApp(const PlayAndWinApp());
class PlayAndWinApp extends StatelessWidget {
  const PlayAndWinApp({super.key});
  @override Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, title: 'العب واربح',
      theme: ThemeData(useMaterial3: true, scaffoldBackgroundColor: const Color(0xFF0F172A)),
      home: const GameHub());
  }
}

class GameHub extends StatelessWidget {
  const GameHub({super.key});
  @override Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(title: const Text("العب واربح - النسخة النهائية", style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: const Color(0xFF1E3A8A), foregroundColor: Colors.white, centerTitle: true),
      body: GridView.count(crossAxisCount: 2, padding: const EdgeInsets.all(16), crossAxisSpacing: 16, mainAxisSpacing: 16, children: [
        _card(context, "بلياردو PRO", Icons.sports_basketball, [const Color(0xFF065F46), const Color(0xFF10B981)], const BilliardReal()),
        _card(context, "دومينو PRO", Icons.grid_view, [const Color(0xFF7C2D12), const Color(0xFFF59E0B)], const DominoReal()),
        _card(context, "سلم وثعبان PRO", Icons.show_chart, [const Color(0xFF1E40AF), const Color(0xFF60A5FA)], const SnakeReal()),
        _card(context, "لودو 4 لاعبين", Icons.casino, [const Color(0xFF6D28D9), const Color(0xFFEC4899)], const LudoReal4()),
      ]),
    );
  }
  Widget _card(BuildContext c, String t, IconData ic, List<Color> g, Widget go) {
    return InkWell(onTap: () => Navigator.push(c, MaterialPageRoute(builder: (_) => go)),
      child: Container(decoration: BoxDecoration(gradient: LinearGradient(colors: g, begin: Alignment.topLeft, end: Alignment.bottomRight), borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: g.last.withOpacity(0.4), blurRadius: 12, offset: const Offset(0,6))]), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(ic, size: 48, color: Colors.white), const SizedBox(height: 8), Text(t, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))])));}
}

// ==================== 1- LUDO 4 PLAYERS REAL ====================
class LudoReal4 extends StatefulWidget { const LudoReal4({super.key}); @override State<LudoReal4> createState()=> _Ludo4State(); }
class _Ludo4State extends State<LudoReal4> {
  // -1 = home, 0..51 = main track, 100..105 = home path, 200 = finished
  List<List<int>> players = List.generate(4, (_) => List.filled(4, -1));
  int turn = 0; int dice = 1; List<String> names = ["أحمر","أخضر","أصفر","أزرق"]; List<Color> colors = [Colors.red, Colors.green, Colors.amber, Colors.blue];
  final List<int> startPos = [0,13,26,39]; // start positions on main track
  final Set<int> safeSpots = {0,8,13,21,26,34,39,47};

  void roll(){ setState(()=> dice = Random().nextInt(6)+1); }

  void movePiece(int p, int pieceIdx){
    int pos = players[p][pieceIdx];
    if(pos==-1 && dice!=6) return;
    if(pos==-1 && dice==6){ setState((){ players[p][pieceIdx]=startPos[p]; if(dice!=6) turn=(turn+1)%4; }); return; }
    if(pos>=100){ // home path
      int newPos = pos + dice;
      if(newPos>105) return;
      if(newPos==105) newPos=200;
      setState(()=> players[p][pieceIdx]=newPos);
    } else {
      int newPos = (pos + dice) % 52;
      // check enter home path
      int homeEntry = (startPos[p] + 50) % 52;
      // if crossed home entry
      bool passedHome = false;
      for(int i=1;i<=dice;i++){ if((pos+i)%52 == homeEntry) passedHome=true; }
      if(passedHome && p==turn){ // enter home
        int stepsPast = (pos+dice) - homeEntry;
        if(stepsPast<0) stepsPast+=52;
        if(stepsPast>0 && stepsPast<=5){ setState(()=> players[p][pieceIdx]=100+stepsPast); }
        else if(stepsPast==0){ setState(()=> players[p][pieceIdx]=homeEntry); }
        else { // normal move
          setState(()=> players[p][pieceIdx]=newPos);
          _checkCapture(p, newPos);
        }
      } else {
        setState(()=> players[p][pieceIdx]=newPos);
        _checkCapture(p, newPos);
      }
    }
    if(players[p].every((e)=> e==200)){
      showDialog(context: context, builder: (_)=> AlertDialog(title: Text("فاز ${names[p]} 🏆")));
    }
    if(dice!=6) setState(()=> turn=(turn+1)%4);
  }

  void _checkCapture(int attacker, int pos){
    if(safeSpots.contains(pos)) return;
    for(int p=0;p<4;p++){ if(p==attacker) continue;
      for(int i=0;i<4;i++){ if(players[p][i]==pos){ setState(()=> players[p][i]=-1); } }
    }
  }

  @override Widget build(BuildContext context){
    return Scaffold(appBar: AppBar(title: Text("لودو - دور ${names[turn]} - نرد $dice"), backgroundColor: colors[turn], foregroundColor: Colors.white),
      body: Column(children: [
        Padding(padding: const EdgeInsets.all(10), child: Row(children: [Chip(label: Text("النرد: $dice")), const Spacer(), ElevatedButton.icon(onPressed: roll, icon: const Icon(Icons.casino), label: const Text("ارمي النرد"))])),
        Expanded(child: CustomPaint(painter: LudoBoardPainter(players, startPos), child: Container())),
        Container(height: 160, padding: const EdgeInsets.all(6), child: GridView.count(crossAxisCount: 4, childAspectRatio: 1.8, children: List.generate(4, (p)=> Container(margin: const EdgeInsets.all(4), decoration: BoxDecoration(color: colors[p].withOpacity(0.2), borderRadius: BorderRadius.circular(12), border: Border.all(color: colors[p], width: turn==p? 3:1)), child: Column(children: [
          Text(names[p], style: TextStyle(color: colors[p], fontWeight: FontWeight.bold, fontSize: 11)),
          Expanded(child: GridView.count(crossAxisCount: 2, children: List.generate(4, (i)=> InkWell(onTap: ()=> turn==p? movePiece(p,i):null, child: Container(margin: const EdgeInsets.all(2), decoration: BoxDecoration(color: players[p][i]==-1? Colors.black54: players[p][i]==200? Colors.green: Colors.white, shape: BoxShape.circle, border: Border.all(color: colors[p])), child: Center(child: Text(players[p][i]==-1? "🏠": players[p][i]==200? "✓": "${players[p][i]}", style: const TextStyle(fontSize: 9)))))))),
        ]))))),
      ]),
    );
  }
}

class LudoBoardPainter extends CustomPainter {
  final List<List<int>> players; final List<int> starts;
  LudoBoardPainter(this.players, this.starts);
  @override void paint(Canvas c, Size s){
    // simple 15x15 grid board background
    final bg = Paint()..color=Colors.white;
    c.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(0,0,s.width,s.height), const Radius.circular(12)), bg);
    // draw track as 52 small squares
    List<Offset> path = [];
    double w=s.width/15, h=s.height/15;
    // create path around
    for(int i=0;i<6;i++) path.add(Offset(6*w, i*h)); // left side up
    for(int i=0;i<6;i++) path.add(Offset((6+i)*w, 0)); // top
    for(int i=0;i<6;i++) path.add(Offset(14*w, (i)*h));
    for(int i=0;i<6;i++) path.add(Offset((14-i)*w, 6*h));
    for(int i=0;i<6;i++) path.add(Offset(14*w, (6+i)*h));
    for(int i=0;i<6;i++) path.add(Offset((14-i)*w, 14*h));
    for(int i=0;i<6;i++) path.add(Offset(6*w, (14-i)*h));
    for(int i=0;i<6;i++) path.add(Offset((6-i)*w, 8*h));
    // we need 52, truncate
    path = path.take(52).toList();
    for(int i=0;i<path.length;i++){
      c.drawRect(Rect.fromCenter(center: path[i], width: w*0.9, height: h*0.9), Paint()..color= i%8==0? Colors.grey.shade300: Colors.white..style=PaintingStyle.fill);
      c.drawRect(Rect.fromCenter(center: path[i], width: w*0.9, height: h*0.9), Paint()..color=Colors.black26..style=PaintingStyle.stroke);
    }
    List<Color> cols=[Colors.red, Colors.green, Colors.orange, Colors.blue];
    for(int p=0;p<4;p++){ for(int pi=0;pi<4;pi++){ int pos=players[p][pi]; if(pos>=0 && pos<52 && pos<path.length){ c.drawCircle(path[pos], 7, Paint()..color=cols[p]); } } }
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate)=> true;
}

// ==================== 2- BILLIARD REAL PHYSICS ====================
class Ball { Offset pos; Offset vel; Color color; bool gone=false; Ball(this.pos, this.vel, this.color); }

class BilliardReal extends StatefulWidget { const BilliardReal({super.key}); @override State<BilliardReal> createState()=> _BillRealState(); }
class _BillRealState extends State<BilliardReal> with SingleTickerProviderStateMixin {
  late AnimationController ctrl;
  List<Ball> balls=[]; Ball cue=Ball(const Offset(100,200), Offset.zero, Colors.white);
  double angle=0, power=40;
  @override void initState(){
    super.initState();
    ctrl=AnimationController(vsync: this, duration: const Duration(seconds: 10))..addListener(_update)..repeat();
    _reset();
  }
  void _reset(){ setState((){
    cue=Ball(const Offset(80,200), Offset.zero, Colors.white);
    balls=[Ball(const Offset(240,190), Offset.zero, Colors.red), Ball(const Offset(240,210), Offset.zero, Colors.blue), Ball(const Offset(260,200), Offset.zero, Colors.yellow), Ball(const Offset(260,180), Offset.zero, Colors.purple), Ball(const Offset(260,220), Offset.zero, Colors.black)];
  });}
  void _update(){
    setState((){
      for(var b in [cue,...balls]){ if(b.gone) continue; b.pos+=b.vel; b.vel*=0.985; if(b.vel.distance<0.1) b.vel=Offset.zero;
        if(b.pos.dx<16||b.pos.dx>334){ b.vel=Offset(-b.vel.dx*0.8, b.vel.dy); b.pos=Offset(b.pos.dx.clamp(16,334), b.pos.dy); }
        if(b.pos.dy<16||b.pos.dy>384){ b.vel=Offset(b.vel.dx, -b.vel.dy*0.8); b.pos=Offset(b.pos.dx, b.pos.dy.clamp(16,384)); }
        // pockets
        List<Offset> pockets=[const Offset(10,10), const Offset(170,10), const Offset(330,10), const Offset(10,390), const Offset(170,390), const Offset(330,390)];
        for(var pk in pockets){ if((b.pos-pk).distance<18){ if(b!=cue) b.gone=true; else { b.pos=const Offset(80,200); b.vel=Offset.zero; } } }
      }
      // ball-ball collision simple
      List<Ball> all=[cue,...balls].where((b)=>!b.gone).toList();
      for(int i=0;i<all.length;i++){ for(int j=i+1;j<all.length;j++){
        double d=(all[i].pos-all[j].pos).distance; if(d<20 && d>0){ Offset n=(all[i].pos-all[j].pos)/d; double p=2*(all[i].vel.dx*n.dx+all[i].vel.dy*n.dy - all[j].vel.dx*n.dx - all[j].vel.dy*n.dy)/2;
          all[i].vel-=n*p; all[j].vel+=n*p; // separate
          all[i].pos+=n*1; all[j].pos-=n*1;
        }
      }}
    });
  }
  void shoot(){
    double rad=angle*pi/180; cue.vel=Offset(cos(rad), sin(rad))*power*0.35;
  }
  @override void dispose(){ ctrl.dispose(); super.dispose();}
  @override Widget build(BuildContext context){
    return Scaffold(appBar: AppBar(title: const Text("بلياردو PRO - فيزياء حقيقية"), backgroundColor: const Color(0xFF065F46), foregroundColor: Colors.white, actions: [IconButton(onPressed: _reset, icon: const Icon(Icons.refresh))]),
      body: Column(children: [
        Expanded(child: Container(margin: const EdgeInsets.all(10), decoration: BoxDecoration(color: const Color(0xFF0F6A4A), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFF8B4513), width: 8)), child: CustomPaint(painter: RealPoolPainter(cue,balls), child: const SizedBox.expand()))),
        Container(padding: const EdgeInsets.all(12), color: const Color(0xFF111827), child: Column(children: [
          Row(children: [const Text("زاوية", style: TextStyle(color: Colors.white54)), Expanded(child: Slider(value: angle, min: -180, max: 180, onChanged: (v)=> setState(()=> angle=v))), Text("${angle.toInt()}°", style: const TextStyle(color: Colors.white))]),
          Row(children: [const Text("قوة", style: TextStyle(color: Colors.white54)), Expanded(child: Slider(value: power, min: 5, max: 100, activeColor: Colors.amber, onChanged: (v)=> setState(()=> power=v))), Text("${power.toInt()}%", style: const TextStyle(color: Colors.white))]),
          ElevatedButton(onPressed: shoot, style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, minimumSize: const Size(double.infinity, 50)), child: const Text("اضرب!", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
        ])),
      ]),
    );
  }
}
class RealPoolPainter extends CustomPainter {
  Ball cue; List<Ball> balls; RealPoolPainter(this.cue,this.balls);
  @override void paint(Canvas c, Size s){
    final pk=Paint()..color=Colors.black; c.drawCircle(const Offset(10,10), 14, pk); c.drawCircle(Offset(s.width/2,10), 12, pk); c.drawCircle(Offset(s.width-10,10), 14, pk);
    c.drawCircle(const Offset(10,390), 14, pk); c.drawCircle(Offset(s.width/2,390), 12, pk); c.drawCircle(Offset(s.width-10,390), 14, pk);
    if(!cue.gone) c.drawCircle(cue.pos, 9, Paint()..color=Colors.white);
    for(var b in balls){ if(!b.gone) c.drawCircle(b.pos, 9, Paint()..color=b.color); }
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate)=> true;
}

// ==================== 3- SNAKE REAL ====================
class SnakeReal extends StatefulWidget { const SnakeReal({super.key}); @override State<SnakeReal> createState()=> _SnakeRealState(); }
class _SnakeRealState extends State<SnakeReal> {
  int p1=1,p2=1,turn=1,dice=1; bool busy=false;
  final Map<int,int> ladders={4:25,13:46,33:85,50:69,62:81,74:92}; final Map<int,int> snakes={99:41,89:53,76:58,66:45,54:31,43:18,27:5,40:3};
  Future<void> roll() async {
    if(busy) return; setState((){busy=true; dice=Random().nextInt(6)+1;});
    int cur=turn==1?p1:p2; int tgt=cur+dice; if(tgt>100){ setState(()=>busy=false); return;}
    for(int i=cur+1;i<=tgt;i++){ await Future.delayed(const Duration(milliseconds: 150)); if(!mounted) return; setState(()=> turn==1? p1=i: p2=i); }
    int pos=turn==1?p1:p2;
    if(ladders.containsKey(pos) || snakes.containsKey(pos)){ await Future.delayed(const Duration(milliseconds: 300)); setState(()=> turn==1? p1=(ladders[pos]??snakes[pos])!: p2=(ladders[pos]??snakes[pos])!); }
    if((turn==1?p1:p2)==100) showDialog(context: context, builder: (_)=> AlertDialog(title: Text("فاز اللاعب $turn")));
    setState((){turn=turn==1?2:1; busy=false;});
  }
  @override Widget build(BuildContext context){
    return Scaffold(appBar: AppBar(title: Text("سلم وثعبان PRO - دور $turn نرد $dice"), backgroundColor: const Color(0xFF1E3A8A), foregroundColor: Colors.white),
      body: Column(children: [
        Expanded(child: Padding(padding: const EdgeInsets.all(8), child: CustomPaint(painter: SnakeBoardPainter(p1,p2,ladders,snakes), child: Container()))),
        Padding(padding: const EdgeInsets.all(12), child: ElevatedButton(onPressed: roll, style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, minimumSize: const Size(double.infinity, 58)), child: Text("رمي النرد - $dice", style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)))),
      ]),
    );
  }
}
class SnakeBoardPainter extends CustomPainter {
  int p1,p2; Map<int,int> ladders,snakes; SnakeBoardPainter(this.p1,this.p2,this.ladders,this.snakes);
  @override void paint(Canvas c, Size s){
    double cw=s.width/10, ch=s.height/10;
    // cells
    for(int r=9;r>=0;r--){ for(int col=0;col<10;col++){
      int num = r%2==0? r*10+col+1: r*10+(9-col)+1;
      double x = col*cw, y=(9-r)*ch;
      Paint paint=Paint()..color= ladders.containsKey(num)? const Color(0xFFBBF7D0): snakes.containsKey(num)? const Color(0xFFFECACA): Colors.white;
      c.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(x+2,y+2,cw-4,ch-4), const Radius.circular(6)), paint);
      TextPainter tp=TextPainter(text: TextSpan(text: "$num", style: const TextStyle(fontSize: 8, color: Colors.black54)), textDirection: TextDirection.ltr)..layout(); tp.paint(c, Offset(x+4,y+2));
      if(ladders.containsKey(num)){ TextPainter tp2=TextPainter(text: const TextSpan(text: "🪜", style: TextStyle(fontSize: 14)), textDirection: TextDirection.ltr)..layout(); tp2.paint(c, Offset(x+cw/2-7, y+ch/2-7)); }
      if(snakes.containsKey(num)){ TextPainter tp2=TextPainter(text: const TextSpan(text: "🐍", style: TextStyle(fontSize: 14)), textDirection: TextDirection.ltr)..layout(); tp2.paint(c, Offset(x+cw/2-7, y+ch/2-7)); }
      if(p1==num) c.drawCircle(Offset(x+cw*0.3, y+ch*0.75), 6, Paint()..color=Colors.blue);
      if(p2==num) c.drawCircle(Offset(x+cw*0.7, y+ch*0.75), 6, Paint()..color=Colors.orange);
    }}
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate)=> true;
}

// ==================== 4- DOMINO REAL DOTS ====================
class DominoReal extends StatefulWidget { const DominoReal({super.key}); @override State<DominoReal> createState()=> _DominoRealState(); }
class _DominoRealState extends State<DominoReal> {
  List<List<int>> board=[[3,2]]; List<List<int>> hand=[[0,6],[6,1],[2,5],[1,4],[4,4],[3,3]]; List<List<int>> bot=[[1,2],[5,3]];
  int left=3,right=2; String status="دورك";
  void play(int idx){ var d=hand[idx]; bool cl=d[0]==left||d[1]==left, cr=d[0]==right||d[1]==right; if(!cl&&!cr){ setState(()=>status="لا تناسب"); return;} setState((){ if(cl){ board.insert(0, d[0]==left? [d[1],d[0]]:d); left=board.first[0]; } else { board.add(d[0]==right? d: [d[1],d[0]]); right=board.last[1]; } hand.removeAt(idx); status="دور البوت";}); Future.delayed(const Duration(seconds: 1), botPlay); }
  void botPlay(){ for(int i=0;i<bot.length;i++){ var d=bot[i]; if(d[0]==left||d[1]==left||d[0]==right||d[1]==right){ setState((){ if(d[0]==left||d[1]==left){ board.insert(0, d[0]==left? [d[1],d[0]]:d); left=board.first[0];} else { board.add(d[0]==right? d:[d[1],d[0]]); right=board.last[1];} bot.removeAt(i); status="دورك";}); return;}} setState((){ bot.add([Random().nextInt(7), Random().nextInt(7)]); status="دورك";});}
  @override Widget build(BuildContext context){
    return Scaffold(appBar: AppBar(title: Text("دومينو [$left|$right] $status"), backgroundColor: const Color(0xFF451A03), foregroundColor: Colors.white),
      body: Column(children: [
        Expanded(child: Container(margin: const EdgeInsets.all(10), decoration: BoxDecoration(color: const Color(0xFF3E2723), borderRadius: BorderRadius.circular(16)), child: Center(child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: board.map((d)=> Container(margin: const EdgeInsets.all(5), width: 52, height: 90, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)), child: Column(children: [Expanded(child: CustomPaint(painter: DotPainter(d[0]))), Container(height: 2, color: Colors.black), Expanded(child: CustomPaint(painter: DotPainter(d[1])))]))).toList()))))),
        Container(padding: const EdgeInsets.all(12), color: Colors.black87, child: Wrap(spacing: 8, children: List.generate(hand.length, (i)=> InkWell(onTap: ()=>play(i), child: Container(width: 60, height: 90, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.amber, width: 2)), child: Column(children: [Expanded(child: CustomPaint(painter: DotPainter(hand[i][0]))), Container(height: 2, color: Colors.black), Expanded(child: CustomPaint(painter: DotPainter(hand[i][1])))])))))),
      ]),
    );
  }
}
class DotPainter extends CustomPainter {
  int v; DotPainter(this.v);
  @override void paint(Canvas c, Size s){
    Paint p=Paint()..color=Colors.black;
    void dot(double x,double y)=> c.drawCircle(Offset(s.width*x, s.height*y), 4, p);
    if(v==1) dot(0.5,0.5);
    if(v==2){ dot(0.25,0.25); dot(0.75,0.75); }
    if(v==3){ dot(0.25,0.25); dot(0.5,0.5); dot(0.75,0.75); }
    if(v==4){ dot(0.25,0.25); dot(0.75,0.25); dot(0.25,0.75); dot(0.75,0.75); }
    if(v==5){ dot(0.25,0.25); dot(0.75,0.25); dot(0.5,0.5); dot(0.25,0.75); dot(0.75,0.75); }
    if(v==6){ dot(0.25,0.2); dot(0.25,0.5); dot(0.25,0.8); dot(0.75,0.2); dot(0.75,0.5); dot(0.75,0.8); }
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate)=> false;
}
