import 'package:flutter/material.dart';
import 'dart:math';

// ================== MAIN ==================
void main() => runApp(const PlayAndWinApp());
class PlayAndWinApp extends StatelessWidget {
  const PlayAndWinApp({super.key});
  @override Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: const Hub());
  }
}

class PlayerInfo {
  String name; String avatar; Color color;
  PlayerInfo(this.name, this.avatar, this.color);
}

final List<PlayerInfo> gamePlayers = [
  PlayerInfo("أحمد", "A", Colors.red),
  PlayerInfo("سارة", "S", Colors.green),
  PlayerInfo("علي", "O", Colors.amber),
  PlayerInfo("نور", "N", Colors.blue),
];

class Hub extends StatelessWidget {
  const Hub({super.key});
  @override Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF0F172A), Color(0xFF1E3A8A)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SafeArea(child: Column(children: [
          const Padding(padding: EdgeInsets.all(16), child: Text("العب واربح - 3D ULTRA", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold))),
          Expanded(child: GridView.count(crossAxisCount: 2, padding: const EdgeInsets.all(16), crossAxisSpacing: 16, mainAxisSpacing: 16, children: [
            _card(context, "بلياردو 3D", Icons.sports_basketball, [const Color(0xFF065F46), const Color(0xFF10B981)], const BilliardUltra()),
            _card(context, "دومينو 3D", Icons.grid_view, [const Color(0xFF78350F), const Color(0xFFF59E0B)], const DominoUltra()),
            _card(context, "سلم وثعبان 3D", Icons.show_chart, [const Color(0xFF1E40AF), const Color(0xFF60A5FA)], const SnakeUltra()),
            _card(context, "لودو 4 لاعبين 3D", Icons.casino, [const Color(0xFF6D28D9), const Color(0xFFEC4899)], const LudoUltra()),
          ])),
        ])),
      ),
    );
  }
  Widget _card(BuildContext c, String t, IconData ic, List<Color> g, Widget go){
    return InkWell(onTap: ()=> Navigator.push(c, MaterialPageRoute(builder: (_)=> go)),
      child: Container(decoration: BoxDecoration(gradient: LinearGradient(colors: g), borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: g.last.withOpacity(0.5), blurRadius: 10)]), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(ic, color: Colors.white, size: 40), const SizedBox(height: 6), Text(t, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))])));}
}

// ================== WIDGETS مشتركة ==================
Widget playerAvatar(PlayerInfo p, bool isTurn){
  return Container(padding: const EdgeInsets.all(2), decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: isTurn? Colors.amber: Colors.white24, width: isTurn? 3:1)), child: Column(children: [
    CircleAvatar(radius: 18, backgroundColor: p.color, child: Text(p.avatar, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
    const SizedBox(height: 2), Text(p.name, style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: isTurn? FontWeight.bold: FontWeight.normal)),
  ]));
}

class ChatBox extends StatefulWidget { const ChatBox({super.key}); @override State<ChatBox> createState()=> _ChatBoxState(); }
class _ChatBoxState extends State<ChatBox> {
  List<String> msgs=["أحمد: يلا نلعب","سارة: جاهزة!"]; TextEditingController ctrl=TextEditingController();
  @override Widget build(BuildContext context){
    return Container(decoration: const BoxDecoration(color: Color(0xFF111827), borderRadius: BorderRadius.vertical(top: Radius.circular(16))), child: Column(children: [
      Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), child: Row(children: [const Icon(Icons.chat_bubble, color: Colors.white54, size: 16), const Text(" الدردشة", style: TextStyle(color: Colors.white54, fontSize: 12)), const Spacer(), InkWell(onTap: ()=> ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("🎁 تم إرسال هدية!"))), child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: Colors.pink, borderRadius: BorderRadius.circular(12)), child: const Text("🎁 هدية", style: TextStyle(color: Colors.white, fontSize: 12))))])),
      SizedBox(height: 60, child: ListView(children: msgs.map((m)=> Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2), child: Text(m, style: const TextStyle(color: Colors.white70, fontSize: 12)))).toList())),
      Padding(padding: const EdgeInsets.all(6), child: Row(children: [Expanded(child: TextField(controller: ctrl, style: const TextStyle(color: Colors.white, fontSize: 12), decoration: InputDecoration(hintText: "اكتب رسالة...", hintStyle: const TextStyle(color: Colors.white24, fontSize: 12), filled: true, fillColor: Colors.white10, contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none)))), IconButton(icon: const Icon(Icons.send, color: Colors.tealAccent, size: 20), onPressed: (){ if(ctrl.text.isNotEmpty){ setState(()=> msgs.add("${gamePlayers[0].name}: ${ctrl.text}")); ctrl.clear(); }})])),
    ]));
  }
}

// ================== 1- BILLIARD ULTRA ==================
class BallData { Offset pos; Offset vel; Color color; bool gone=false; BallData(this.pos,this.vel,this.color); }
class BilliardUltra extends StatefulWidget { const BilliardUltra({super.key}); @override State<BilliardUltra> createState()=> _BilliardUltraState(); }
class _BilliardUltraState extends State<BilliardUltra> with SingleTickerProviderStateMixin {
  late AnimationController anim; BallData cue=BallData(const Offset(80,150), Offset.zero, Colors.white); List<BallData> balls=[]; double angle=0, power=35; int turn=0;
  @override void initState(){ super.initState(); anim=AnimationController(vsync: this, duration: const Duration(days: 1))..addListener(_tick)..repeat(); _reset(); }
  void _reset(){ cue=BallData(const Offset(80,150), Offset.zero, Colors.white); balls=[BallData(const Offset(200,140), Offset.zero, Colors.red), BallData(const Offset(200,160), Offset.zero, Colors.blue), BallData(const Offset(220,150), Offset.zero, Colors.yellow), BallData(const Offset(220,130), Offset.zero, Colors.purple)]; }
  void _tick(){
    setState((){
      for(var b in [cue,...balls]){ if(b.gone) continue; b.pos+=b.vel; b.vel*=0.983; if(b.vel.distance<0.08) b.vel=Offset.zero;
        if(b.pos.dx<14||b.pos.dx>306){ b.vel=Offset(-b.vel.dx*0.85, b.vel.dy); b.pos=Offset(b.pos.dx.clamp(14,306), b.pos.dy); }
        if(b.pos.dy<14||b.pos.dy>286){ b.vel=Offset(b.vel.dx, -b.vel.dy*0.85); b.pos=Offset(b.pos.dx, b.pos.dy.clamp(14,286)); }
        for(var pk in [const Offset(8,8), const Offset(160,8), const Offset(312,8), const Offset(8,292), const Offset(160,292), const Offset(312,292)]){ if((b.pos-pk).distance<18){ if(b==cue){ b.pos=const Offset(80,150); b.vel=Offset.zero; } else b.gone=true; } }
      }
      var all=[cue,...balls].where((b)=>!b.gone).toList();
      for(int i=0;i<all.length;i++) for(int j=i+1;j<all.length;j++){ double d=(all[i].pos-all[j].pos).distance; if(d<18 && d>0){ Offset n=(all[i].pos-all[j].pos)/d; double p=2*(all[i].vel.dx*n.dx+all[i].vel.dy*n.dy - all[j].vel.dx*n.dx - all[j].vel.dy*n.dy)/2; all[i].vel-=n*p; all[j].vel+=n*p; all[i].pos+=n*0.5; all[j].pos-=n*0.5; } }
    });
  }
  void shoot(){ double rad=angle*pi/180; cue.vel=Offset(cos(rad), sin(rad))*power*0.4; setState(()=> turn=(turn+1)%4); }
  @override void dispose(){ anim.dispose(); super.dispose();}
  @override Widget build(BuildContext context){
    return Scaffold(appBar: AppBar(title: const Text("بلياردو 3D - 4 لاعبين"), backgroundColor: const Color(0xFF065F46), foregroundColor: Colors.white),
      body: Column(children: [
        SizedBox(height: 80, child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: List.generate(4, (i)=> playerAvatar(gamePlayers[i], turn==i)))),
        Expanded(flex: 5, child: Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF0A5C36), Color(0xFF10B981)]), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFF8B4513), width: 6)), child: CustomPaint(painter: BilliardUltraPainter(cue,balls,angle), child: const SizedBox.expand()))),
        Container(padding: const EdgeInsets.all(8), color: const Color(0xFF111827), child: Column(children: [
          Row(children: [const Icon(Icons.rotate_right, color: Colors.white54, size: 18), Expanded(child: Slider(value: angle, min: -180, max: 180, onChanged: (v)=> setState(()=> angle=v))), Text("${angle.toInt()}°", style: const TextStyle(color: Colors.white, fontSize: 12))]),
          Row(children: [const Icon(Icons.bolt, color: Colors.amber, size: 18), Expanded(child: Slider(value: power, min: 5, max: 100, activeColor: Colors.amber, onChanged: (v)=> setState(()=> power=v))), ElevatedButton(onPressed: shoot, style: ElevatedButton.styleFrom(backgroundColor: Colors.teal), child: const Text("إضرب بعصاية"))]),
        ])),
        const Expanded(flex: 4, child: ChatBox()),
      ]),
    );
  }
}
class BilliardUltraPainter extends CustomPainter {
  BallData cue; List<BallData> balls; double ang; BilliardUltraPainter(this.cue,this.balls,this.ang);
  @override void paint(Canvas c, Size s){
    final pk=Paint()..color=Colors.black; for(var p in [Offset(8,8), Offset(s.width/2,8), Offset(s.width-8,8), Offset(8,s.height-8), Offset(s.width/2,s.height-8), Offset(s.width-8,s.height-8)]){ c.drawCircle(p, 12, pk); }
    // aiming line + stick
    double rad=ang*pi/180; Offset dir=Offset(cos(rad), sin(rad));
    Paint linePaint=Paint()..color=Colors.white38..strokeWidth=1..style=PaintingStyle.stroke;
    Path dash=Path(); for(double i=0;i<80;i+=10){ dash.moveTo(cue.pos.dx+dir.dx*i, cue.pos.dy+dir.dy*i); dash.lineTo(cue.pos.dx+dir.dx*(i+5), cue.pos.dy+dir.dy*(i+5)); } c.drawPath(dash, linePaint);
    // stick
    Offset stickStart=cue.pos - dir*60; Paint stickPaint=Paint()..color=const Color(0xFFD2B48C)..strokeWidth=6..strokeCap=StrokeCap.round; c.drawLine(stickStart, cue.pos - dir*8, stickPaint);
    if(!cue.gone) c.drawCircle(cue.pos, 8, Paint()..color=Colors.white);
    for(var b in balls){ if(!b.gone) c.drawCircle(b.pos, 8, Paint()..color=b.color); }
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate)=> true;
}

// ================== 2- LUDO ULTRA ==================
class LudoUltra extends StatefulWidget { const LudoUltra({super.key}); @override State<LudoUltra> createState()=> _LudoUltraState(); }
class _LudoUltraState extends State<LudoUltra> {
  List<List<int>> pos=List.generate(4, (_)=> List.filled(4, -1)); int turn=0,dice=1;
  void roll(){ setState(()=> dice=Random().nextInt(6)+1); }
  void move(int p, int idx){ if(pos[p][idx]==-1 && dice!=6) return; setState((){ if(pos[p][idx]==-1) pos[p][idx]=0; else { pos[p][idx]+=dice; if(pos[p][idx]>57) pos[p][idx]=57; } if(dice!=6) turn=(turn+1)%4; }); }
  @override Widget build(BuildContext context){
    return Scaffold(appBar: AppBar(title: Text("لودو 3D - دور ${gamePlayers[turn].name} نرد $dice"), backgroundColor: gamePlayers[turn].color),
      body: Column(children: [
        SizedBox(height: 70, child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: List.generate(4, (i)=> playerAvatar(gamePlayers[i], turn==i)))),
        Expanded(flex: 6, child: Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF1F2937), Color(0xFF374151)], begin: Alignment.topLeft, end: Alignment.bottomRight), borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 15)]), child: Stack(children: [
          Center(child: Container(width: 280, height: 280, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.black12, width: 2)), child: GridView.count(crossAxisCount: 15, children: List.generate(225, (i){ bool isPath = (i%15==6||i%15==8||i~/15==6||i~/15==8); return Container(margin: const EdgeInsets.all(0.5), decoration: BoxDecoration(color: isPath? Colors.white: Colors.transparent, border: isPath? Border.all(color: Colors.black12):null)); }))),
          Center(child: InkWell(onTap: roll, child: Container(width: 60, height: 60, decoration: BoxDecoration(color: Colors.amber, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 3), boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 8)]), child: Center(child: Text("$dice", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)))))),
          // homes
          Positioned(top: 10, left: 10, child: _homeBox(0)), Positioned(top: 10, right: 10, child: _homeBox(1)),
          Positioned(bottom: 10, left: 10, child: _homeBox(2)), Positioned(bottom: 10, right: 10, child: _homeBox(3)),
        ]))),
        Expanded(flex: 4, child: ChatBox()),
      ]),
    );
  }
  Widget _homeBox(int p){
    return Container(width: 110, height: 110, decoration: BoxDecoration(color: gamePlayers[p].color.withOpacity(0.25), borderRadius: BorderRadius.circular(14), border: Border.all(color: gamePlayers[p].color, width: 2)), child: Column(children: [
      Text(gamePlayers[p].name, style: TextStyle(color: gamePlayers[p].color, fontWeight: FontWeight.bold, fontSize: 10)),
      Expanded(child: GridView.count(crossAxisCount: 2, children: List.generate(4, (i)=> InkWell(onTap: ()=> turn==p? move(p,i):null, child: Container(margin: const EdgeInsets.all(3), decoration: BoxDecoration(color: pos[p][i]==-1? Colors.black45: Colors.white, shape: BoxShape.circle), child: Center(child: Text(pos[p][i]==-1? "🏠": "${pos[p][i]}", style: const TextStyle(fontSize: 9)))))))),
    ]));
  }
}

// ================== 3- SNAKE ULTRA 4 PLAYERS ==================
class SnakeUltra extends StatefulWidget { const SnakeUltra({super.key}); @override State<SnakeUltra> createState()=> _SnakeUltraState(); }
class _SnakeUltraState extends State<SnakeUltra> {
  List<int> poses=[1,1,1,1]; int turn=0,dice=1; bool busy=false;
  Map<int,int> ladders={4:25,13:46,33:85,50:69,62:81,74:92}; Map<int,int> snakes={99:41,89:53,76:58,66:45,54:31,43:18,27:5,40:3};
  Future<void> roll() async { if(busy) return; setState((){busy=true; dice=Random().nextInt(6)+1;}); int cur=poses[turn]; int tgt=cur+dice; if(tgt>100){ setState(()=>busy=false); return;} for(int i=cur+1;i<=tgt;i++){ await Future.delayed(const Duration(milliseconds: 120)); if(!mounted) return; setState(()=> poses[turn]=i);} int pos=poses[turn]; if(ladders.containsKey(pos)||snakes.containsKey(pos)){ await Future.delayed(const Duration(milliseconds: 300)); setState(()=> poses[turn]=ladders[pos]??snakes[pos]!);} setState((){turn=(turn+1)%4; busy=false;});}
  @override Widget build(BuildContext context){
    return Scaffold(appBar: AppBar(title: Text("سلم وثعبان 3D - دور ${gamePlayers[turn].name}"), backgroundColor: const Color(0xFF1E3A8A), foregroundColor: Colors.white),
      body: Column(children: [
        SizedBox(height: 60, child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: List.generate(4, (i)=> playerAvatar(gamePlayers[i], turn==i)))),
        Expanded(flex: 6, child: Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF0F172A), Color(0xFF1E293B)]), borderRadius: BorderRadius.circular(16)), child: CustomPaint(painter: SnakeUltraPainter(poses,ladders,snakes), child: const SizedBox.expand()))),
        Padding(padding: const EdgeInsets.all(8), child: ElevatedButton(onPressed: roll, style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, minimumSize: const Size(double.infinity, 48)), child: Text("رمي النرد - $dice", style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)))),
        const Expanded(flex: 4, child: ChatBox()),
      ]),
    );
  }
}
class SnakeUltraPainter extends CustomPainter {
  List<int> poses; Map<int,int> ladders,snakes; SnakeUltraPainter(this.poses,this.ladders,this.snakes);
  @override void paint(Canvas c, Size s){
    double cw=s.width/10, ch=s.height/10;
    List<Offset> cellCenter(int n){ int r=(n-1)~/10; int col=(n-1)%10; int actualCol = r%2==0? col: 9-col; double x=actualCol*cw+cw/2; double y=(9-r)*ch+ch/2; return [Offset(x,y)]; }
    // board
    for(int n=1;n<=100;n++){ int r=(n-1)~/10; int col=(n-1)%10; int ac=r%2==0? col:9-col; double x=ac*cw, y=(9-r)*ch; Paint p=Paint()..color=Colors.white..style=PaintingStyle.fill; c.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(x+2,y+2,cw-4,ch-4), const Radius.circular(6)), p); TextPainter tp=TextPainter(text: TextSpan(text: "$n", style: const TextStyle(fontSize: 7, color: Colors.black45)), textDirection: TextDirection.ltr)..layout(); tp.paint(c, Offset(x+3,y+3)); }
    // snakes
    Paint snakePaint=Paint()..color=Colors.redAccent..strokeWidth=4..style=PaintingStyle.stroke;
    snakes.forEach((head,tail){ var h=cellCenter(head)[0]; var t=cellCenter(tail)[0]; Path path=Path()..moveTo(h.dx,h.dy)..quadraticBezierTo((h.dx+t.dx)/2+20, (h.dy+t.dy)/2, t.dx, t.dy); c.drawPath(path, snakePaint); c.drawCircle(h, 8, Paint()..color=Colors.red); c.drawCircle(t, 6, Paint()..color=Colors.redAccent.withOpacity(0.6)); });
    // ladders
    Paint ladderPaint=Paint()..color=Colors.green..strokeWidth=3..style=PaintingStyle.stroke;
    ladders.forEach((bot,top){ var b=cellCenter(bot)[0]; var t=cellCenter(top)[0]; c.drawLine(Offset(b.dx-6,b.dy), Offset(t.dx-6,t.dy), ladderPaint); c.drawLine(Offset(b.dx+6,b.dy), Offset(t.dx+6,t.dy), ladderPaint); for(double i=0;i<1;i+=0.2){ double x1=b.dx-6+(t.dx-b.dx)*i; double y1=b.dy+(t.dy-b.dy)*i; double x2=b.dx+6+(t.dx-b.dx)*i; double y2=y1; c.drawLine(Offset(x1,y1), Offset(x2,y2), ladderPaint); }});
    // players 4
    List<Color> pc=[Colors.red, Colors.green, Colors.orange, Colors.blue];
    for(int pi=0;pi<4;pi++){ int n=poses[pi]; var cc=cellCenter(n)[0]; double off=(pi-1.5)*8; c.drawCircle(Offset(cc.dx+off, cc.dy+10), 6, Paint()..color=pc[pi]); }
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate)=> true;
}

// ================== 4- DOMINO ULTRA ==================
class DominoUltra extends StatefulWidget { const DominoUltra({super.key}); @override State<DominoUltra> createState()=> _DominoUltraState(); }
class _DominoUltraState extends State<DominoUltra> {
  List<List<int>> board=[[3,2]]; List<List<int>> hand=[[0,6],[6,1],[2,5],[1,4]]; int left=3,right=2; int turn=0;
  void play(int idx){ var d=hand[idx]; bool cl=d[0]==left||d[1]==left, cr=d[0]==right||d[1]==right; if(!cl&&!cr) return; setState((){ if(cl){ board.insert(0, d[0]==left? [d[1],d[0]]:d); left=board.first[0]; } else { board.add(d[0]==right? d: [d[1],d[0]]); right=board.last[1]; } hand.removeAt(idx); turn=(turn+1)%4; });}
  @override Widget build(BuildContext context){
    return Scaffold(appBar: AppBar(title: Text("دومينو 3D [$left|$right] دور ${gamePlayers[turn].name}"), backgroundColor: const Color(0xFF451A03), foregroundColor: Colors.white),
      body: Column(children: [
        SizedBox(height: 70, child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: List.generate(4, (i)=> playerAvatar(gamePlayers[i], turn==i)))),
        Expanded(flex: 5, child: Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF3E2723), Color(0xFF5D4037)]), borderRadius: BorderRadius.circular(16)), child: Center(child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: board.map((d)=> Container(margin: const EdgeInsets.all(4), width: 48, height: 80, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 4)]), child: Column(children: [Expanded(child: CustomPaint(painter: DotPainter(d[0]))), Container(height: 2, color: Colors.black), Expanded(child: CustomPaint(painter: DotPainter(d[1])))]))).toList()))))),
        Container(padding: const EdgeInsets.all(8), color: Colors.black87, child: Wrap(spacing: 8, children: List.generate(hand.length, (i)=> InkWell(onTap: ()=> play(i), child: Container(width: 54, height: 80, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: gamePlayers[turn].color, width: 2)), child: Column(children: [Expanded(child: CustomPaint(painter: DotPainter(hand[i][0]))), Container(height: 2, color: Colors.black), Expanded(child: CustomPaint(painter: DotPainter(hand[i][1])))])))))),
        const Expanded(flex: 4, child: ChatBox()),
      ]),
    );
  }
}
class DotPainter extends CustomPainter {
  int v; DotPainter(this.v);
  @override void paint(Canvas c, Size s){ Paint p=Paint()..color=Colors.black; void dot(double x,double y)=> c.drawCircle(Offset(s.width*x,s.height*y), 3.5, p);
    if(v==1) dot(0.5,0.5);
    if(v==2){ dot(0.25,0.25); dot(0.75,0.75); }
    if(v==3){ dot(0.25,0.25); dot(0.5,0.5); dot(0.75,0.75); }
    if(v==4){ dot(0.25,0.25); dot(0.75,0.25); dot(0.25,0.75); dot(0.75,0.75); }
    if(v==5){ dot(0.25,0.25); dot(0.75,0.25); dot(0.5,0.5); dot(0.25,0.75); dot(0.75,0.75); }
    if(v==6){ dot(0.25,0.2); dot(0.25,0.5); dot(0.25,0.8); dot(0.75,0.2); dot(0.75,0.5); dot(0.75,0.8); }
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate)=> false;
}
