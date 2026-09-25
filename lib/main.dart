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

// ========== اللوبي بتفاصيل كاملة ==========
class LobbyScreen extends StatelessWidget {
  const LobbyScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final friends = [
      {"name": "همام", "v": "V6", "img": "https://i.pravatar.cc/100?img=1"},
      {"name": "سحاب", "v": "V7", "img": "https://i.pravatar.cc/100?img=2"},
      {"name": "انا المجروح", "v": "V6", "img": "https://i.pravatar.cc/100?img=3"},
      {"name": "ابن الاكابر", "v": "V6", "img": "https://i.pravatar.cc/100?img=4"},
    ];
    return Scaffold(
      backgroundColor: const Color(0xFF0A1020),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              color: const Color(0xFF1A2332),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(backgroundImage: NetworkImage('https://i.pravatar.cc/100?img=12')),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(20)),
                        child: const Row(children: [Text("🪙 1500", style: TextStyle(color: Colors.white)), SizedBox(width: 4), CircleAvatar(radius: 10, backgroundColor: Colors.amber, child: Text("+", style: TextStyle(color: Colors.black, fontSize: 12)))]),
                      ),
                      const SizedBox(width: 6),
                      Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(20)), child: const Text("🎁")),
                    ],
                  ),
                  Row(children: [
                    _topBtn("🔍"),
                    const SizedBox(width: 6),
                    _topBtn("👑 TOP"),
                  ])
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("ألعاب عادية", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(20)), child: const Text("غرفة خاصة +", style: TextStyle(color: Colors.white, fontSize: 12)))
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      childAspectRatio: 1.2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      children: [
                        _gameCard(context, "كيرم / بلياردو", [const Color(0xFF8B5A2B), const Color(0xFF4A2C0A)], "🎯", const BilliardScreen()),
                        _gameCard(context, "دومينو 50", [const Color(0xFF4CAF50), const Color(0xFF1B5E20)], "🀄", const DominoScreen()),
                        _gameCard(context, "لودو", [const Color(0xFF2979FF), const Color(0xFF0D47A1)], "🎲", const LudoScreen()),
                        _gameCard(context, "السلم والثعبان", [const Color(0xFFAB47BC), const Color(0xFF4A148C)], "🐍", const SnakeScreen()),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: const BoxDecoration(color: Color(0xFF0E172A), borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("ابحث عن صديق - غرفة الانتظار", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 12),
                         ...friends.map((f) => Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(color: const Color(0xFF1C2A45), borderRadius: BorderRadius.circular(16)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(radius: 22, backgroundImage: NetworkImage(f["img"]!)),
                                        const SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(children: [Text(f["name"]!, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)), const SizedBox(width: 6), Container(padding: const EdgeInsets.symmetric(horizontal: 4), decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(4)), child: Text(f["v"]!, style: const TextStyle(fontSize: 9, color: Colors.black)))]),
                                            const Text("يشاهد اللعب - في الانتظار", style: TextStyle(color: Colors.white54, fontSize: 11))
                                          ],
                                        )
                                      ],
                                    ),
                                    Container(padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6), decoration: BoxDecoration(color: const Color(0xFF22C55E), borderRadius: BorderRadius.circular(20)), child: const Text("إنضم", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)))
                                  ],
                                ),
                              )),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _topBtn(String t) => Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(20)), child: Text(t, style: const TextStyle(color: Colors.white, fontSize: 12)));
  Widget _gameCard(BuildContext c, String title, List<Color> colors, String emoji, Widget page) => GestureDetector(
        onTap: () => Navigator.push(c, MaterialPageRoute(builder: (_) => page)),
        child: Container(
          decoration: BoxDecoration(gradient: LinearGradient(colors: colors), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.amber.withOpacity(0.3))),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(emoji, style: const TextStyle(fontSize: 38)),
            const SizedBox(height: 8),
            Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(20)), child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)))
          ]),
        ),
      );
}

class WaitingMini extends StatelessWidget {
  const WaitingMini({super.key});
  @override Widget build(BuildContext context) => Row(children: [const CircleAvatar(radius: 12, backgroundImage: NetworkImage('https://i.pravatar.cc/100?img=8')), const SizedBox(width: 4), const Text("غرفة الانتظار (4)", style: TextStyle(color: Colors.white70, fontSize: 12))]);
}

// ========== 1- بلياردو بكل تفاصيل الصورة ==========
class BilliardScreen extends StatefulWidget { const BilliardScreen({super.key}); @override State<BilliardScreen> createState() => _BilliardState(); }
class _BilliardState extends State<BilliardScreen> with SingleTickerProviderStateMixin {
  Offset? dragStart; Offset? dragCurrent; Offset striker = const Offset(200, 320); Offset velocity = Offset.zero; List<Ball> balls = []; late Ticker ticker; int score = 0;
  @override void initState() { super.initState(); balls = [Ball(pos: const Offset(200, 180)), Ball(pos: const Offset(180, 160)), Ball(pos: const Offset(220, 160)), Ball(pos: const Offset(200, 200))]; ticker = createTicker(_onTick); ticker.start(); }
  void _onTick(Duration _) { if (velocity == Offset.zero) return; setState(() { striker = striker + velocity; velocity = velocity * 0.96; if (velocity.distance < 0.2) velocity = Offset.zero; if (striker.dx < 20 || striker.dx > 380) velocity = Offset(-velocity.dx, velocity.dy); if (striker.dy < 20 || striker.dy > 380) velocity = Offset(velocity.dx, -velocity.dy); for (var b in balls) { if (b.out) continue; double d = (striker - b.pos).distance; if (d < 28) { Offset dir = b.pos - striker; double len = dir.distance; if (len > 0) { dir = dir / len; b.pos = b.pos + dir * 5; } } if (b.pos.dx < 18 || b.pos.dx > 382 || b.pos.dy < 18 || b.pos.dy > 382) { b.out = true; score++; } } }); }
  @override void dispose() { ticker.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) {
    double power = 0; if (dragStart!= null && dragCurrent!= null) { power = (dragStart! - dragCurrent!).distance; if (power > 100) power = 100; }
    return Scaffold(
      backgroundColor: const Color(0xFF0A1020),
      appBar: AppBar(backgroundColor: const Color(0xFF1A2332), title: const WaitingMini(), leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context))),
      body: Column(children: [
        Container(padding: const EdgeInsets.all(6), color: Colors.black45, child: const Text("اسحب في أي مكان والقوة حسب طول السحبة - ارفع إصبعك تنطلق", style: TextStyle(color: Colors.white70, fontSize: 12))),
        LinearProgressIndicator(value: power / 100, color: Colors.amber, backgroundColor: Colors.white12),
        Expanded(child: GestureDetector(onPanStart: (d) => setState(() => dragStart = d.localPosition), onPanUpdate: (d) => setState(() => dragCurrent = d.localPosition), onPanEnd: (d) { if (dragStart!= null && dragCurrent!= null) { Offset dir = dragStart! - dragCurrent!; velocity = dir * 0.15; } setState(() { dragStart = null; dragCurrent = null; }); }, child: CustomPaint(size: const Size(400, 600), painter: BilliardPainter(striker, balls, dragStart, dragCurrent)))),
        Container(padding: const EdgeInsets.all(10), color: const Color(0xFF1A2332), child: Column(children: [Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: List.generate(4, (i) => Column(children: [CircleAvatar(backgroundImage: NetworkImage('https://i.pravatar.cc/100?img=${i+1}')), Text("$score", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]))), const SizedBox(height: 8), Row(children: [const Text("💬 59", style: TextStyle(color: Colors.white)), const SizedBox(width: 8), const Text("🎁", style: TextStyle(color: Colors.white)), const SizedBox(width: 8), Expanded(child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(20)), child: const Text("قل شيئا", style: TextStyle(color: Colors.white54, fontSize: 12))))])]))
      ]),
    );
  }
}
class Ball { Offset pos; bool out; Ball({required this.pos, this.out = false}); }
class BilliardPainter extends CustomPainter {
  final Offset striker; final List<Ball> balls; final Offset? s; final Offset? c; BilliardPainter(this.striker, this.balls, this.s, this.c);
  @override void paint(Canvas canvas, Size size) { canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint()..color = const Color(0xFFE8C49A)); canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint()..color = const Color(0xFF8B5A2B)..style = PaintingStyle.stroke..strokeWidth = 12); for (var p in [Offset.zero, Offset(size.width, 0), Offset(0, size.height), Offset(size.width, size.height)]) { canvas.drawCircle(p, 18, Paint()..color = Colors.black); } for (var b in balls) { if (b.out) continue; canvas.drawCircle(b.pos, 12, Paint()..color = Colors.white); canvas.drawCircle(b.pos, 12, Paint()..color = Colors.black..style = PaintingStyle.stroke); } canvas.drawCircle(striker, 14, Paint()..color = Colors.white); canvas.drawCircle(striker, 14, Paint()..color = Colors.black..style = PaintingStyle.stroke..strokeWidth = 2); if (s!= null && c!= null) { canvas.drawLine(striker, striker + (s! - c!) * 1.2, Paint()..color = Colors.yellow..strokeWidth = 3); } }
  @override bool shouldRepaint(covariant CustomPainter old) => true;
}

// ========== 2- دومينو بكل تفاصيل الصورة ==========
class DominoScreen extends StatefulWidget { const DominoScreen({super.key}); @override State<DominoScreen> createState() => _DominoState(); }
class _DominoState extends State<DominoScreen> {
  List<List<int>> hand = [[2,5],[6,6],[1,3],[4,4],[0,2],[3,5]]; List<List<int>> board = []; int leftEnd = -1; int rightEnd = -1;
  void play(int i) { var t = hand[i]; if (board.isEmpty) { setState(() { board.add(t); leftEnd = t[0]; rightEnd = t[1]; hand.removeAt(i); }); return; } if (t[0]==leftEnd||t[1]==leftEnd||t[0]==rightEnd||t[1]==rightEnd) { setState(() { if (t[0]==rightEnd||t[1]==rightEnd) { board.add(t); rightEnd = t[0]==rightEnd? t[1]: t[0]; } else { board.insert(0,t); leftEnd = t[0]==leftEnd? t[1]: t[0]; } hand.removeAt(i); }); } }
  @override Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3A8A3A),
      appBar: AppBar(backgroundColor: const Color(0xFF1A2332), title: const WaitingMini(), leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: ()=>Navigator.pop(context))),
      body: Column(children: [
        Container(padding: const EdgeInsets.all(12), color: const Color(0xFF5DB85D), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("🪙 1500 LV.0", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), Row(children: [ _iconBox("📦"), _iconBox("🎯"), _iconBox("👑")])])),
        const SizedBox(height: 10),
        Container(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8), decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(20)), child: const Text("دومينو 50", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
        const SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [_btn("ترفيهي", Colors.amber), const SizedBox(width: 8), _btn("معركة", Colors.green), const SizedBox(width: 8), _btn("إنشاء", Colors.purple)]),
        const SizedBox(height: 20),
        Container(height: 110, color: Colors.black26, margin: const EdgeInsets.all(8), child: board.isEmpty? const Center(child: Text("العب أول بلاطة", style: TextStyle(color: Colors.white70))): SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: board.map((t)=> Container(margin: const EdgeInsets.all(4), width:50, height:80, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)), child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [Text("${t[0]}", style: const TextStyle(fontWeight: FontWeight.bold)), const Divider(), Text("${t[1]}", style: const TextStyle(fontWeight: FontWeight.bold))]))).toList()))),
        const Spacer(),
        Padding(padding: const EdgeInsets.all(8), child: Wrap(spacing: 6, runSpacing: 8, children: List.generate(hand.length, (i){ var t=hand[i]; return GestureDetector(onTap: ()=>play(i), child: Container(width:54, height:88, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(width:1.5, color: Colors.black12), boxShadow: const [BoxShadow(color: Colors.black26, blurRadius:3, offset: Offset(1,2))]), child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [Text("${t[0]}"), const Divider(), Text("${t[1]}")]))); }))),
        Container(padding: const EdgeInsets.all(8), color: const Color(0xFF1A2332), child: Row(children: [const Expanded(child: Text("الغرفة الموصى بها: ملتقى آل سلاطين (14)", style: TextStyle(color: Colors.white, fontSize:11))), Container(padding: const EdgeInsets.symmetric(horizontal:12,vertical:8), decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(20)), child: const Text("قل شيئا", style: TextStyle(color: Colors.white54)))]))
      ]),
    );
  }
  Widget _iconBox(String e)=>Container(margin: const EdgeInsets.only(left:6), padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(12)), child: Text(e));
  Widget _btn(String t, Color c)=>Container(padding: const EdgeInsets.symmetric(horizontal:18,vertical:10), decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(20)), child: Text(t, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize:12)));
}

// ========== 3- لودو ==========
class LudoScreen extends StatefulWidget { const LudoScreen({super.key}); @override State<LudoScreen> createState()=> _LudoState(); }
class _LudoState extends State<LudoScreen> { int dice=1; int pos=0; final rnd=Random(); void roll(){ setState((){ dice=rnd.nextInt(6)+1; pos=(pos+dice)%40; }); } @override Widget build(BuildContext context){ return Scaffold(backgroundColor: const Color(0xFF0F2A66), appBar: AppBar(backgroundColor: const Color(0xFF1A2332), title: const WaitingMini(), leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: ()=>Navigator.pop(context))), body: Container(decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors:[Color(0xFF2A6EDB), Color(0xFF0F2A66)])), child: Column(children: [const SizedBox(height:20), Container(padding: const EdgeInsets.symmetric(horizontal:36,vertical:12), decoration: BoxDecoration(color: const Color(0xFF4ADE80), borderRadius: BorderRadius.circular(30)), child: const Text("العب مع الأصدقاء", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))), Expanded(child: GridView.builder(padding: const EdgeInsets.all(16), gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:8), itemCount:40, itemBuilder: (c,i)=> Container(margin: const EdgeInsets.all(2), decoration: BoxDecoration(color: i==pos? Colors.yellow: Colors.white24, borderRadius: BorderRadius.circular(6)), child: Center(child: Text(i==pos? "🛩️": "$i", style: const TextStyle(color: Colors.white, fontSize:9)))))), ElevatedButton(onPressed: roll, child: Text("ارمي $dice")), const SizedBox(height:20)]))); } }

// ========== 4- السلم والثعبان زي الصورة بالظبط ==========
class SnakeScreen extends StatefulWidget { const SnakeScreen({super.key}); @override State<SnakeScreen> createState()=> _SnakeState(); }
class _SnakeState extends State<SnakeScreen> {
  int player=1; int dice=1; final rnd=Random();
  final Map<int,int> snakes={99:54, 70:55, 52:42, 56:8, 62:19, 43:17};
  final Map<int,int> ladders={3:22, 5:8, 11:26, 20:29, 27:56, 21:42, 36:51};
  void roll(){ int d=rnd.nextInt(6)+1; setState((){ dice=d; int next=player+d; if(next<=100){ player=next; if(snakes.containsKey(player)) player=snakes[player]!; if(ladders.containsKey(player)) player=ladders[player]!; } }); }
  @override Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: const Color(0xFFFEF3C7),
      appBar: AppBar(backgroundColor: const Color(0xFF1A2332), title: const WaitingMini(), leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: ()=>Navigator.pop(context))),
      body: Column(children: [
        Expanded(child: Padding(padding: const EdgeInsets.all(8), child: CustomPaint(painter: SnakePainter(player, snakes, ladders), size: const Size(400, 600)))),
        Padding(padding: const EdgeInsets.all(12), child: Column(children: [Text("موقعك $player / 100 - ${player==100?"فزت!":"المس النرد"}", style: const TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height:8), GestureDetector(onTap: roll, child: Container(width:80,height:80, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(width:2)), child: Center(child: Text("$dice", style: const TextStyle(fontSize:40)))))]))
      ]),
    );
  }
}
class SnakePainter extends CustomPainter {
  final int player; final Map<int,int> snakes; final Map<int,int> ladders; SnakePainter(this.player, this.snakes, this.ladders);
  @override void paint(Canvas canvas, Size size){ double w=size.width/10; double h=size.height/10; int num=100; for(int r=0;r<10;r++){ for(int c=0;c<10;c++){ int col=r%2==0? c: 9-c; var rect=Rect.fromLTWH(col*w, r*h, w, h); Color colr; if(num%10==2||num%10==0) colr=Colors.blue.withOpacity(0.8); else if(num%10==4) colr=Colors.yellow.withOpacity(0.8); else if(num%10==6) colr=Colors.green.withOpacity(0.8); else if(num%10==8) colr=Colors.orange.withOpacity(0.8); else if(num%10==1||num%10==0) colr=Colors.red.withOpacity(0.7); else colr=Colors.white; canvas.drawRect(rect, Paint()..color=colr); canvas.drawRect(rect, Paint()..style=PaintingStyle.stroke..strokeWidth=0.5); var tp=TextPainter(text: TextSpan(text:"$num", style: TextStyle(fontSize:9, fontWeight: FontWeight.bold, color: colr==Colors.white? Colors.black: Colors.white)), textDirection: TextDirection.ltr)..layout(); tp.paint(canvas, Offset(rect.left+2, rect.top+2)); if(num==player){ canvas.drawCircle(rect.center, 10, Paint()..color=Colors.red); } num--; } } snakes.forEach((s,e){ var sp=Offset(((s-1)%10)*w + w/2, (9-(s-1)~/10)*h + h/2); var ep=Offset(((e-1)%10)*w + w/2, (9-(e-1)~/10)*h + h/2); canvas.drawLine(sp, ep, Paint()..color=Colors.blue..strokeWidth=5..strokeCap=StrokeCap.round); canvas.drawCircle(sp, 6, Paint()..color=Colors.pink); }); ladders.forEach((s,e){ var sp=Offset(((s-1)%10)*w + w/2, (9-(s-1)~/10)*h + h/2); var ep=Offset(((e-1)%10)*w + w/2, (9-(e-1)~/10)*h + h/2); canvas.drawLine(sp, ep, Paint()..color=Colors.white..strokeWidth=3); canvas.drawLine(sp.translate(6,0), ep.translate(6,0), Paint()..color=Colors.white..strokeWidth=3); }); }
  @override bool shouldRepaint(covariant CustomPainter old)=>true;
}
