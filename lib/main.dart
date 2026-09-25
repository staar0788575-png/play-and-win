import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'dart:math';

void main() => runApp(const PlayAndWinApp());
class PlayAndWinApp extends StatelessWidget {
  const PlayAndWinApp({super.key});
  @override Widget build(BuildContext context) => MaterialApp(debugShowCheckedModeBanner: false, home: const LobbyScreen());
}

// اللوبي زي ما هو
class LobbyScreen extends StatelessWidget {
  const LobbyScreen({super.key});
  @override Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1020),
      body: SafeArea(child: Column(children: [
        Container(padding: const EdgeInsets.all(12), color: const Color(0xFF1A2332), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Row(children: [const CircleAvatar(backgroundImage: NetworkImage('https://i.pravatar.cc/100?img=12')), const SizedBox(width:8), Container(padding: const EdgeInsets.symmetric(horizontal:12,vertical:6), decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(20)), child: const Text("🪙 1500 LV.0", style: TextStyle(color: Colors.white)))]), Row(children: [Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(20)), child: const Text("👑"))])])),
        Expanded(child: GridView.count(crossAxisCount: 2, padding: const EdgeInsets.all(14), childAspectRatio: 1.2, mainAxisSpacing:12, crossAxisSpacing:12, children: [
          _card(context, "كيرم / بلياردو", [const Color(0xFF8B5A2B), const Color(0xFF4A2C0A)], const BilliardScreen()),
          _card(context, "دومينو 50", [const Color(0xFF4CAF50), const Color(0xFF1B5E20)], const DominoScreen()),
          _card(context, "لودو", [const Color(0xFF2979FF), const Color(0xFF0D47A1)], const LudoScreen()),
          _card(context, "السلم والثعبان", [const Color(0xFFAB47BC), const Color(0xFF4A148C)], const SnakeScreen()),
        ]))
      ])),
    );
  }
  Widget _card(BuildContext c, String t, List<Color> col, Widget p) => GestureDetector(onTap: ()=>Navigator.push(c, MaterialPageRoute(builder: (_)=>p)), child: Container(decoration: BoxDecoration(gradient: LinearGradient(colors: col), borderRadius: BorderRadius.circular(20)), child: Center(child: Text(t, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))));
}
class WaitingMini extends StatelessWidget { const WaitingMini({super.key}); @override Widget build(BuildContext c)=>Row(children: const [CircleAvatar(radius:12, backgroundImage: NetworkImage('https://i.pravatar.cc/100?img=8')), SizedBox(width:4), Text("غرفة الانتظار (4)", style: TextStyle(color: Colors.white70, fontSize:12))]); }

// ================= 1- بلياردو شغال 100% =================
class BilliardScreen extends StatefulWidget { const BilliardScreen({super.key}); @override State<BilliardScreen> createState()=>_BilliardState(); }
class _BilliardState extends State<BilliardScreen> with SingleTickerProviderStateMixin {
  Offset? dragStart, dragCurrent;
  Offset striker = const Offset(200, 320);
  Offset vel = Offset.zero;
  List<Map<String,dynamic>> balls = [];
  late Ticker ticker;
  int score=0;
  @override void initState(){ super.initState(); balls = [ {"pos":const Offset(200,180),"out":false}, {"pos":const Offset(180,160),"out":false}, {"pos":const Offset(220,160),"out":false}, {"pos":const Offset(200,200),"out":false}, ]; ticker = createTicker((_) { if(vel!=Offset.zero){ setState((){ striker+=vel; vel*=0.96; if(vel.distance<0.2) vel=Offset.zero; if(striker.dx<20||striker.dx>380) vel=Offset(-vel.dx, vel.dy); if(striker.dy<20||striker.dy>380) vel=Offset(vel.dx, -vel.dy); for(var b in balls){ if(b["out"]) continue; var p=b["pos"] as Offset; var d=(striker-p).distance; if(d<28){ var dir=(p-striker).normalized; b["pos"]=p+dir*5; } if(p.dx<18||p.dx>382||p.dy<18||p.dy>382){ b["out"]=true; score++; } } }); } }); ticker.start(); }
  @override void dispose(){ ticker.dispose(); super.dispose(); }
  @override Widget build(BuildContext context){ return Scaffold(backgroundColor: const Color(0xFF0A1020), appBar: AppBar(backgroundColor: const Color(0xFF1A2332), title: const WaitingMini(), leading: BackButton(onPressed: ()=>Navigator.pop(context))), body: Column(children: [LinearProgressIndicator(value: dragStart==null?0: (dragStart!- (dragCurrent??dragStart!)).distance.clamp(0,100)/100, color: Colors.amber), Expanded(child: GestureDetector(onPanStart: (d)=>dragStart=d.localPosition, onPanUpdate: (d)=>setState(()=>dragCurrent=d.localPosition), onPanEnd: (_){ if(dragStart!=null&&dragCurrent!=null){ var dir=dragStart!-dragCurrent!; vel=dir*0.15; } dragStart=null; dragCurrent=null; setState((){}); }, child: CustomPaint(size: const Size(400,600), painter: BilliardPainter(striker, balls, dragStart, dragCurrent)))), Container(padding: const EdgeInsets.all(10), color: const Color(0xFF1A2332), child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: List.generate(4, (i)=> Column(children: [const CircleAvatar(backgroundImage: NetworkImage('https://i.pravatar.cc/100?img=1')), Text("$score", style: const TextStyle(color: Colors.white))]))))]))); }
}
extension Norm on Offset{ Offset get normalized{ var d=distance; return d==0?Offset.zero: this/d; } }
class BilliardPainter extends CustomPainter{
  final Offset striker; final List<Map<String,dynamic>> balls; final Offset? s,c;
  BilliardPainter(this.striker, this.balls, this.s, this.c);
  @override void paint(Canvas canvas, Size size){ canvas.drawRect(Rect.fromLTWH(0,0,size.width,size.height), Paint()..color=const Color(0xFFE8C49A)); canvas.drawRect(Rect.fromLTWH(0,0,size.width,size.height), Paint()..color=const Color(0xFF8B5A2B)..style=PaintingStyle.stroke..strokeWidth=12); for(var p in [Offset.zero, Offset(size.width,0), Offset(0,size.height), Offset(size.width,size.height)]) canvas.drawCircle(p, 18, Paint()..color=Colors.black); for(var b in balls){ if(b["out"]) continue; canvas.drawCircle(b["pos"], 12, Paint()..color=Colors.white); canvas.drawCircle(b["pos"], 12, Paint()..color=Colors.black..style=PaintingStyle.stroke); } canvas.drawCircle(striker, 14, Paint()..color=Colors.white); canvas.drawCircle(striker, 14, Paint()..color=Colors.black..style=PaintingStyle.stroke..strokeWidth=2); if(s!=null&&c!=null){ canvas.drawLine(striker, striker+(s!-c!)*1.2, Paint()..color=Colors.yellow..strokeWidth=3); } }
  @override bool shouldRepaint(covariant CustomPainter old)=>true;
}

// ================= 2- دومينو شغال =================
class DominoScreen extends StatefulWidget { const DominoScreen({super.key}); @override State<DominoScreen> createState()=>_DominoState(); }
class _DominoState extends State<DominoScreen> {
  List<List<int>> hand = [[2,5],[6,6],[1,3],[4,4],[0,2],[3,5]];
  List<List<int>> board = [];
  int leftEnd=-1, rightEnd=-1;
  void playTile(int index){ var t=hand[index]; if(board.isEmpty){ setState((){ board.add(t); leftEnd=t[0]; rightEnd=t[1]; hand.removeAt(index); }); return; } if(t[0]==leftEnd||t[1]==leftEnd||t[0]==rightEnd||t[1]==rightEnd){ setState((){ if(t[0]==rightEnd||t[1]==rightEnd){ board.add(t); rightEnd= t[0]==rightEnd? t[1]: t[0]; } else { board.insert(0,t); leftEnd= t[0]==leftEnd? t[1]: t[0]; } hand.removeAt(index); }); } }
  @override Widget build(BuildContext context){ return Scaffold(backgroundColor: const Color(0xFF3A8A3A), appBar: AppBar(backgroundColor: const Color(0xFF1A2332), title: const WaitingMini(), leading: BackButton(onPressed: ()=>Navigator.pop(context))), body: Column(children: [Container(padding: const EdgeInsets.all(12), color: const Color(0xFF5DB85D), child: const Text("🪙 1500 LV.0", style: TextStyle(color: Colors.white))), const SizedBox(height:12), Container(height:120, color: Colors.black26, margin: const EdgeInsets.all(8), child: board.isEmpty? const Center(child: Text("العب أول بلاطة - لمس أي بلاطة تحت", style: TextStyle(color: Colors.white70))): SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: board.map((t)=> Container(margin: const EdgeInsets.all(4), width:50, height:80, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)), child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [Text("${t[0]}"), const Divider(), Text("${t[1]}")]))).toList()))), const Spacer(), const Text("إيدك - المس البلاطة لتلعبها", style: TextStyle(color: Colors.white)), Wrap(spacing:6, children: List.generate(hand.length, (i){ var t=hand[i]; return GestureDetector(onTap: ()=>playTile(i), child: Container(width:56, height:88, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(width:2, color: Colors.amber)), child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [Text("${t[0]}", style: const TextStyle(fontWeight: FontWeight.bold)), const Divider(), Text("${t[1]}", style: const TextStyle(fontWeight: FontWeight.bold))]))); })), const SizedBox(height:20)])); }
}

// ================= 3- لودو شغال =================
class LudoScreen extends StatefulWidget { const LudoScreen({super.key}); @override State<LudoScreen> createState()=>_LudoState(); }
class _LudoState extends State<LudoScreen> { int dice=1; int pos=0; final rnd=Random(); void roll(){ setState((){ dice=rnd.nextInt(6)+1; pos=(pos+dice)%40; }); } @override Widget build(BuildContext context){ return Scaffold(backgroundColor: const Color(0xFF0F2A66), appBar: AppBar(backgroundColor: const Color(0xFF1A2332), title: const WaitingMini(), leading: BackButton(onPressed: ()=>Navigator.pop(context))), body: Column(children: [const SizedBox(height:20), Text("رقم النرد: $dice - موقعك: $pos", style: const TextStyle(color: Colors.white)), const SizedBox(height:20), Expanded(child: GridView.builder(padding: const EdgeInsets.all(16), gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8), itemCount: 40, itemBuilder: (c,i)=> Container(margin: const EdgeInsets.all(2), decoration: BoxDecoration(color: i==pos? Colors.yellow: Colors.white24, borderRadius: BorderRadius.circular(6)), child: Center(child: i==pos? const Text("🛩️"): Text("$i", style: const TextStyle(color: Colors.white, fontSize:9)))))), ElevatedButton(onPressed: roll, style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(horizontal:40,vertical:16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))), child: Text("ارمي النرد 🎲 $dice", style: const TextStyle(fontSize:18)) ), const SizedBox(height:20)])); } }

// ================= 4- السلم والثعبان شغال =================
class SnakeScreen extends StatefulWidget { const SnakeScreen({super.key}); @override State<SnakeScreen> createState()=>_SnakeState(); }
class _SnakeState extends State<SnakeScreen> {
  int player=1; int dice=1; final rnd=Random();
  final Map<int,int> snakes={99:54, 70:55, 52:42, 56:8, 43:17, 50:5};
  final Map<int,int> ladders={3:22,5:8,11:26,20:29,27:56,21:42,36:51, 17:4};
  void roll(){ int d=rnd.nextInt(6)+1; setState((){ dice=d; int next=player+d; if(next<=100){ player=next; if(snakes.containsKey(player)) player=snakes[player]!; if(ladders.containsKey(player)) player=ladders[player]!; } }); }
  @override Widget build(BuildContext context){ return Scaffold(backgroundColor: const Color(0xFFFEF3C7), appBar: AppBar(backgroundColor: const Color(0xFF1A2332), title: const WaitingMini(), leading: BackButton(onPressed: ()=>Navigator.pop(context))), body: Column(children: [Expanded(child: Padding(padding: const EdgeInsets.all(8), child: CustomPaint(painter: SnakePainter(player, snakes, ladders), child: Container()))), Padding(padding: const EdgeInsets.all(12), child: Column(children: [Text("موقعك: $player / 100", style: const TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height:8), GestureDetector(onTap: roll, child: Container(width:80,height:80, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(width:2)), child: Center(child: Text("$dice", style: const TextStyle(fontSize:40))))), const SizedBox(height:8), Text(player==100? "فزت! 🎉": snakes.containsKey(player)? "ثعبان! نزلت": ladders.containsKey(player)? "سلم! طلعت": "المس النرد")]))])); }
}
class SnakePainter extends CustomPainter{
  final int player; final Map<int,int> snakes, ladders;
  SnakePainter(this.player, this.snakes, this.ladders);
  @override void paint(Canvas canvas, Size size){ final w=size.width/10; final h=size.height/10; int num=100; for(int r=0;r<10;r++){ for(int c=0;c<10;c++){ int col=r%2==0? c: 9-c; var rect=Rect.fromLTWH(col*w, r*h, w, h); var paint=Paint()..color=(r+c)%2==0? Colors.white: Colors.orange.withOpacity(0.5); canvas.drawRect(rect, paint); canvas.drawRect(rect, Paint()..style=PaintingStyle.stroke..strokeWidth=0.5); var tp=TextPainter(text: TextSpan(text:"$num", style: const TextStyle(fontSize:9, color: Colors.black)), textDirection: TextDirection.ltr)..layout(); tp.paint(canvas, Offset(rect.left+2, rect.top+2)); if(num==player){ canvas.drawCircle(Offset(rect.center.dx, rect.center.dy), 10, Paint()..color=Colors.red); } num--; } } snakes.forEach((s,e){ canvas.drawLine(Offset((s%10)*w, (10-s~/10)*h), Offset((e%10)*w, (10-e~/10)*h), Paint()..color=Colors.red..strokeWidth=4); }); ladders.forEach((s,e){ canvas.drawLine(Offset((s%10)*w, (10-s~/10)*h), Offset((e%10)*w, (10-e~/10)*h), Paint()..color=Colors.green..strokeWidth=4); }); }
  @override bool shouldRepaint(covariant CustomPainter old)=>true;
}
