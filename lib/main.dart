import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'dart:math';

void main() => runApp(const PlayAndWinApp());

class PlayAndWinApp extends StatelessWidget {
  const PlayAndWinApp({super.key});
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
      body: SafeArea(
        child: GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(16),
          children: [
            _card(context, "بلياردو", const BilliardScreen()),
            _card(context, "دومينو", const DominoScreen()),
            _card(context, "لودو", const LudoScreen()),
            _card(context, "السلم", const SnakeScreen()),
          ],
        ),
      ),
    );
  }
  Widget _card(BuildContext c, String t, Widget p) {
    return GestureDetector(
      onTap: () => Navigator.push(c, MaterialPageRoute(builder: (_) => p)),
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF1A2332),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(child: Text(t, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
      ),
    );
  }
}

class WaitingMini extends StatelessWidget {
  const WaitingMini({super.key});
  @override
  Widget build(BuildContext context) {
    return const Text("غرفة الانتظار (4)", style: TextStyle(color: Colors.white70, fontSize: 12));
  }
}

// ===== بلياردو شغال 100% بعد التصليح =====
class BilliardScreen extends StatefulWidget {
  const BilliardScreen({super.key});
  @override
  State<BilliardScreen> createState() => _BilliardState();
}

class _BilliardState extends State<BilliardScreen> with SingleTickerProviderStateMixin {
  Offset? dragStart;
  Offset? dragCurrent;
  Offset striker = const Offset(200, 320);
  Offset velocity = Offset.zero;
  List<Ball> balls = [];
  late Ticker ticker;
  int score = 0;

  @override
  void initState() {
    super.initState();
    balls = [
      Ball(pos: const Offset(200, 180)),
      Ball(pos: const Offset(180, 160)),
      Ball(pos: const Offset(220, 160)),
      Ball(pos: const Offset(200, 200)),
    ];
    ticker = createTicker(_onTick);
    ticker.start();
  }

  void _onTick(Duration _) {
    if (velocity == Offset.zero) return;
    setState(() {
      striker = striker + velocity;
      velocity = velocity * 0.96;
      if (velocity.distance < 0.2) velocity = Offset.zero;
      if (striker.dx < 20 || striker.dx > 380) velocity = Offset(-velocity.dx, velocity.dy);
      if (striker.dy < 20 || striker.dy > 380) velocity = Offset(velocity.dx, -velocity.dy);
      for (var b in balls) {
        if (b.out) continue;
        double d = (striker - b.pos).distance;
        if (d < 28) {
          Offset dir = (b.pos - striker);
          double len = dir.distance;
          if (len > 0) {
            dir = dir / len;
            b.pos = b.pos + dir * 5;
          }
        }
        if (b.pos.dx < 18 || b.pos.dx > 382 || b.pos.dy < 18 || b.pos.dy > 382) {
          b.out = true;
          score++;
        }
      }
    });
  }

  @override
  void dispose() {
    ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double power = 0;
    if (dragStart!= null && dragCurrent!= null) {
      power = (dragStart! - dragCurrent!).distance;
      if (power > 100) power = 100;
    }
    return Scaffold(
      backgroundColor: const Color(0xFF0A1020),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A2332),
        title: const WaitingMini(),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
      ),
      body: Column(
        children: [
          LinearProgressIndicator(value: power / 100, color: Colors.amber, backgroundColor: Colors.white12),
          Expanded(
            child: GestureDetector(
              onPanStart: (details) { setState(() { dragStart = details.localPosition; }); },
              onPanUpdate: (details) { setState(() { dragCurrent = details.localPosition; }); },
              onPanEnd: (details) {
                if (dragStart!= null && dragCurrent!= null) {
                  Offset dir = dragStart! - dragCurrent!;
                  velocity = dir * 0.15;
                }
                setState(() { dragStart = null; dragCurrent = null; });
              },
              child: CustomPaint(
                size: const Size(400, 600),
                painter: BilliardPainter(striker, balls, dragStart, dragCurrent),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            color: const Color(0xFF1A2332),
            child: Text("السكور: $score", style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class Ball { Offset pos; bool out; Ball({required this.pos, this.out = false}); }

class BilliardPainter extends CustomPainter {
  final Offset striker; final List<Ball> balls; final Offset? s; final Offset? c;
  BilliardPainter(this.striker, this.balls, this.s, this.c);
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint()..color = const Color(0xFFE8C49A));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint()..color = const Color(0xFF8B5A2B)..style = PaintingStyle.stroke..strokeWidth = 12);
    canvas.drawCircle(Offset.zero, 18, Paint()..color = Colors.black);
    canvas.drawCircle(Offset(size.width, 0), 18, Paint()..color = Colors.black);
    canvas.drawCircle(Offset(0, size.height), 18, Paint()..color = Colors.black);
    canvas.drawCircle(Offset(size.width, size.height), 18, Paint()..color = Colors.black);
    for (var b in balls) { if (b.out) continue; canvas.drawCircle(b.pos, 12, Paint()..color = Colors.white); }
    canvas.drawCircle(striker, 14, Paint()..color = Colors.white);
    if (s!= null && c!= null) { canvas.drawLine(striker, striker + (s! - c!) * 1.2, Paint()..color = Colors.yellow..strokeWidth = 3); }
  }
  @override bool shouldRepaint(covariant CustomPainter old) => true;
}

// ===== دومينو =====
class DominoScreen extends StatefulWidget { const DominoScreen({super.key}); @override State<DominoScreen> createState()=> _DominoState(); }
class _DominoState extends State<DominoScreen> {
  List<List<int>> hand = [[2,5],[6,6],[1,3],[4,4],[0,2],[3,5]];
  List<List<int>> board = [];
  int leftEnd=-1, rightEnd=-1;
  void play(int i){
    var t=hand[i];
    if(board.isEmpty){ setState((){ board.add(t); leftEnd=t[0]; rightEnd=t[1]; hand.removeAt(i); }); return; }
    if(t[0]==leftEnd||t[1]==leftEnd||t[0]==rightEnd||t[1]==rightEnd){
      setState((){
        if(t[0]==rightEnd||t[1]==rightEnd){ board.add(t); rightEnd = t[0]==rightEnd? t[1]: t[0]; }
        else { board.insert(0,t); leftEnd = t[0]==leftEnd? t[1]: t[0]; }
        hand.removeAt(i);
      });
    }
  }
  @override Widget build(BuildContext context){
    return Scaffold(backgroundColor: const Color(0xFF3A8A3A), appBar: AppBar(backgroundColor: const Color(0xFF1A2332), title: const WaitingMini(), leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: ()=>Navigator.pop(context))), body: Column(children: [
      Container(height:120, margin: const EdgeInsets.all(8), color: Colors.black26, child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: board.map((t)=> Container(margin: const EdgeInsets.all(4), width:50, height:80, color: Colors.white, child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [Text("${t[0]}"), const Divider(), Text("${t[1]}")]))).toList()))),
      const Spacer(),
      Wrap(spacing:6, children: List.generate(hand.length, (i){ var t=hand[i]; return GestureDetector(onTap: ()=>play(i), child: Container(width:56, height:88, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)), child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [Text("${t[0]}"), const Divider(), Text("${t[1]}")]))); })),
      const SizedBox(height:20)
    ]));
  }
}

// ===== لودو =====
class LudoScreen extends StatefulWidget { const LudoScreen({super.key}); @override State<LudoScreen> createState()=> _LudoState(); }
class _LudoState extends State<LudoScreen> {
  int dice=1; int pos=0; final rnd=Random();
  void roll(){ setState((){ dice=rnd.nextInt(6)+1; pos=(pos+dice)%40; }); }
  @override Widget build(BuildContext context){
    return Scaffold(backgroundColor: const Color(0xFF0F2A66), appBar: AppBar(backgroundColor: const Color(0xFF1A2332), title: const WaitingMini(), leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: ()=>Navigator.pop(context))), body: Column(children: [
      Expanded(child: GridView.builder(padding: const EdgeInsets.all(16), gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8), itemCount: 40, itemBuilder: (c,i)=> Container(margin: const EdgeInsets.all(2), decoration: BoxDecoration(color: i==pos? Colors.yellow: Colors.white24, borderRadius: BorderRadius.circular(6)), child: Center(child: Text("$i", style: const TextStyle(color: Colors.white, fontSize:9)))))),
      ElevatedButton(onPressed: roll, child: Text("ارمي $dice")), const SizedBox(height:20)
    ]));
  }
}

// ===== سلم وثعبان =====
class SnakeScreen extends StatefulWidget { const SnakeScreen({super.key}); @override State<SnakeScreen> createState()=> _SnakeState(); }
class _SnakeState extends State<SnakeScreen> {
  int player=1; int dice=1; final rnd=Random();
  final Map<int,int> snakes={99:54, 70:55, 52:42};
  final Map<int,int> ladders={3:22, 5:8, 11:26, 20:29};
  void roll(){ int d=rnd.nextInt(6)+1; setState((){ dice=d; int next=player+d; if(next<=100){ player=next; if(snakes.containsKey(player)) player=snakes[player]!; if(ladders.containsKey(player)) player=ladders[player]!; } }); }
  @override Widget build(BuildContext context){
    return Scaffold(backgroundColor: const Color(0xFFFEF3C7), appBar: AppBar(backgroundColor: const Color(0xFF1A2332), title: const WaitingMini(), leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: ()=>Navigator.pop(context))), body: Column(children: [
      Expanded(child: CustomPaint(painter: SnakePainter(player), size: const Size(400,400))),
      GestureDetector(onTap: roll, child: Container(width:80, height:80, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(width:2)), child: Center(child: Text("$dice", style: const TextStyle(fontSize:40))))),
      Text("موقعك $player / 100"), const SizedBox(height:20)
    ]));
  }
}
class SnakePainter extends CustomPainter {
  final int player; SnakePainter(this.player);
  @override void paint(Canvas canvas, Size size){ double w=size.width/10; double h=size.height/10; int num=100; for(int r=0;r<10;r++){ for(int c=0;c<10;c++){ int col=r%2==0? c: 9-c; var rect=Rect.fromLTWH(col*w, r*h, w, h); canvas.drawRect(rect, Paint()..color= (r+c)%2==0? Colors.white: Colors.orange.withOpacity(0.5)); canvas.drawRect(rect, Paint()..style=PaintingStyle.stroke..strokeWidth=0.5); if(num==player) canvas.drawCircle(rect.center, 10, Paint()..color=Colors.red); num--; } } }
  @override bool shouldRepaint(covariant CustomPainter old)=>true;
}
