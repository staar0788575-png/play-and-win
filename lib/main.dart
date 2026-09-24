import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() => runApp(const PlayAndWinApp());

class PlayAndWinApp extends StatelessWidget {
  const PlayAndWinApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Play And Win',
      theme: ThemeData(fontFamily: 'Cairo'),
      home: const LobbyScreen(),
    );
  }
}

// ========== الشاشة الرئيسية - نفس ترتيب صورك ==========
class LobbyScreen extends StatelessWidget {
  const LobbyScreen({super.key});

  final friends = const [
    {"name":"همام","v":"V6"},{"name":"سحاب","v":"V7"},{"name":"انا المجروح","v":"V6"},{"name":"ابن الاكابر","v":"V6"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1020),
      body: SafeArea(
        child: Column(
          children: [
            // بار علوي - عملات وهدايا
            Container(
              padding: const EdgeInsets.all(12),
              color: const Color(0xFF1A2332),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    const CircleAvatar(backgroundImage: NetworkImage('https://i.pravatar.cc/100?img=12')),
                    const SizedBox(width:8),
                    Container(padding: const EdgeInsets.symmetric(horizontal:12,vertical:6), decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(20)), child: const Row(children: [Text("🪙 1500", style: TextStyle(color: Colors.white)), SizedBox(width:4), CircleAvatar(radius:10, backgroundColor: Colors.amber, child: Text("+", style: TextStyle(color: Colors.black, fontSize:12)))])),
                    const SizedBox(width:6),
                    Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(20)), child: const Text("🎁")),
                  ]),
                  Row(children: [
                    _topBtn("🔍"), const SizedBox(width:6), _topBtn("👑 TOP")
                  ])
                ],
              ),
            ),
            // ألعاب عادية
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        children: [
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("ألعاب عادية", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize:18)), Container(padding: const EdgeInsets.symmetric(horizontal:12,vertical:6), decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(20)), child: const Text("غرفة خاصة +", style: TextStyle(color: Colors.white, fontSize:12))) ]),
                          const SizedBox(height:12),
                          GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2, childAspectRatio: 1.2, mainAxisSpacing:12, crossAxisSpacing:12,
                            children: [
                              _gameCard(context, "كيرم / بلياردو", const [Color(0xFF8B5A2B), Color(0xFF4A2C0A)], "🎯", const BilliardScreen()),
                              _gameCard(context, "دومينو 50", const [Color(0xFF4CAF50), Color(0xFF1B5E20)], "🀄", const DominoScreen()),
                              _gameCard(context, "لودو", const [Color(0xFF2979FF), Color(0xFF0D47A1)], "🎲", const LudoScreen()),
                              _gameCard(context, "السلم والثعبان", const [Color(0xFFAB47BC), Color(0xFF4A148C)], "🐍", const SnakeScreen()),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // غرفة الانتظار - أصدقاء الأصدقاء
                    Container(
                      decoration: const BoxDecoration(color: Color(0xFF0E172A), borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("ابحث عن صديق - غرفة الانتظار", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          const SizedBox(height:12),
                         ...friends.map((f) => Container(
                            margin: const EdgeInsets.only(bottom:10),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: const Color(0xFF1C2A45), borderRadius: BorderRadius.circular(16)),
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              Row(children: [
                                const CircleAvatar(radius:22, backgroundImage: NetworkImage('https://i.pravatar.cc/100?img=3')),
                                const SizedBox(width:10),
                                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Text(f["name"]!, style: const TextStyle(color: Colors.white, fontSize:13, fontWeight: FontWeight.bold)), const SizedBox(width:6), Container(padding: const EdgeInsets.symmetric(horizontal:4), decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(4)), child: Text(f["v"]!, style: const TextStyle(fontSize:9, color: Colors.black)))]), const Text("يشاهد اللعب - في الانتظار", style: TextStyle(color: Colors.white54, fontSize:11))])
                              ]),
                              Container(padding: const EdgeInsets.symmetric(horizontal:18,vertical:6), decoration: BoxDecoration(color: const Color(0xFF22C55E), borderRadius: BorderRadius.circular(20)), child: const Text("إنضم", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize:12)))
                            ]),
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

  Widget _topBtn(String t) => Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(20)), child: Text(t, style: const TextStyle(color: Colors.white, fontSize:12)));
  Widget _gameCard(BuildContext c, String title, List<Color> colors, String emoji, Widget page) => GestureDetector(
    onTap: () => Navigator.push(c, MaterialPageRoute(builder: (_) => page)),
    child: Container(decoration: BoxDecoration(gradient: LinearGradient(colors: colors), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.amber.withOpacity(0.3))), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text(emoji, style: const TextStyle(fontSize:38)), const SizedBox(height:8), Container(padding: const EdgeInsets.symmetric(horizontal:12,vertical:4), decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(20)), child: Text(title, style: const TextStyle(color: Colors.white, fontSize:12, fontWeight: FontWeight.bold)))])),
  );
}

// ========== بار انتظار مصغر يظهر فوق كل لعبة بدل اسم اللعبة ==========
class WaitingMini extends StatelessWidget {
  const WaitingMini({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(children: [
     ...List.generate(3, (i) => const Padding(padding: EdgeInsets.only(right:4), child: CircleAvatar(radius:12, backgroundImage: NetworkImage('https://i.pravatar.cc/100?img=8')))),
      const SizedBox(width:6),
      const Text("غرفة الانتظار (4)", style: TextStyle(color: Colors.white70, fontSize:12))
    ]);
  }
}

// ========== 1- البلياردو - سحب في أي مكان بدون زر ==========
class BilliardScreen extends StatefulWidget {
  const BilliardScreen({super.key});
  @override
  State<BilliardScreen> createState() => _BilliardScreenState();
}
class _BilliardScreenState extends State<BilliardScreen> with SingleTickerProviderStateMixin {
  Offset? start, current;
  double power = 0;
  Offset striker = const Offset(200, 320);
  Offset vel = Offset.zero;
  List<Offset> coins = [const Offset(200,180), const Offset(180,160), const Offset(220,160), const Offset(200,200)];

  @override
  void initState() {
    super.initState();
    Ticker(tick).start();
  }
  void tick(Duration _) {
    if (vel!= Offset.zero) {
      setState(() {
        striker += vel;
        vel *= 0.97;
        if (vel.distance < 0.1) vel = Offset.zero;
        if (striker.dx < 20 || striker.dx > 380) vel = Offset(-vel.dx, vel.dy);
        if (striker.dy < 20 || striker.dy > 380) vel = Offset(vel.dx, -vel.dy);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1020),
      appBar: AppBar(backgroundColor: const Color(0xFF1A2332), title: const WaitingMini(), leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context))),
      body: Column(children: [
        const Padding(padding: EdgeInsets.all(8), child: Text("اسحب في أي مكان والقوة حسب طول السحبة - ارفع إصبعك تنطلق", style: TextStyle(color: Colors.white70, fontSize:12))),
        LinearProgressIndicator(value: power/100, color: Colors.amber, backgroundColor: Colors.white12),
        Expanded(child: GestureDetector(
          onPanStart: (d){ start = d.localPosition; },
          onPanUpdate: (d){ setState(() { current = d.localPosition; power = (start! - current!).distance.clamp(0, 100); }); },
          onPanEnd: (_){ if (start!=null && current!=null){ final dir = start! - current!; setState(() { vel = dir * 0.12; power=0; start=null; current=null; }); } },
          child: CustomPaint(painter: CarromPainter(striker, coins, start, current), size: const Size(400,400)),
        )),
        // لاعبين بسكور 0 وشات
        Container(padding: const EdgeInsets.all(10), color: const Color(0xFF1A2332), child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: List.generate(4, (i) => Column(children: [CircleAvatar(backgroundImage: NetworkImage('https://i.pravatar.cc/100?img=${i+1}')), const Text("0", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]))),
          const SizedBox(height:8),
          Row(children: [const Text("💬 59", style: TextStyle(color: Colors.white)), const SizedBox(width:8), const Text("🎁", style: TextStyle(color: Colors.white)), const SizedBox(width:8), Expanded(child: Container(padding: const EdgeInsets.symmetric(horizontal:12,vertical:8), decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(20)), child: const Text("قل شيئا", style: TextStyle(color: Colors.white54, fontSize:12))))]),
        ]))
      ]),
    );
  }
}
class CarromPainter extends CustomPainter {
  final Offset striker; final List<Offset> coins; final Offset? s,c;
  CarromPainter(this.striker, this.coins, this.s, this.c);
  @override
  void paint(Canvas canvas, Size size){
    final wood = Paint()..color = const Color(0xFFE8C49A);
    canvas.drawRect(Rect.fromLTWH(0,0,size.width,size.height), wood);
    final border = Paint()..color = const Color(0xFF8B5A2B)..style=PaintingStyle.stroke..strokeWidth=12;
    canvas.drawRect(Rect.fromLTWH(0,0,size.width,size.height), border);
    // جيوب
    final pocket = Paint()..color=Colors.black;
    for (var p in [const Offset(0,0), const Offset(400,0), const Offset(0,400), const Offset(400,400)]) { canvas.drawCircle(p, 18, pocket); }
    // عملات
    for (var o in coins) { canvas.drawCircle(o, 12, Paint()..color=Colors.black87); canvas.drawCircle(o, 10, Paint()..color=Colors.white); }
    // المضرب
    canvas.drawCircle(striker, 14, Paint()..color=Colors.white..style=PaintingStyle.fill);
    canvas.drawCircle(striker, 14, Paint()..color=Colors.black..style=PaintingStyle.stroke..strokeWidth=2);
    if (s!=null && c!=null){ final p=Paint()..color=Colors.yellow..strokeWidth=2..style=PaintingStyle.stroke; canvas.drawLine(striker, striker+(s!-c!)*1.2, p); }
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate)=>true;
}

// ========== 2- دومينو واقعي 100% ==========
class DominoScreen extends StatelessWidget {
  const DominoScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final tiles = [[2,5],[6,6],[1,3],[4,4],[0,2],[3,5]];
    return Scaffold(
      backgroundColor: const Color(0xFF3A8A3A),
      appBar: AppBar(backgroundColor: const Color(0xFF1A2332), title: const WaitingMini(), leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: ()=>Navigator.pop(context))),
      body: Column(children: [
        Container(padding: const EdgeInsets.all(12), color: const Color(0xFF5DB85D), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("🪙 1500 LV.0", style: TextStyle(color: Colors.white)), Row(children: [ _iconBox("🏪"), _iconBox("🎯"), _iconBox("👑")])])),
        const SizedBox(height:10),
        Container(padding: const EdgeInsets.symmetric(horizontal:20,vertical:8), decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(20)), child: const Text("دومينو 50", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
        const SizedBox(height:10),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [ _btn("ترفيهي", Colors.amber), const SizedBox(width:8), _btn("معركة", Colors.green), const SizedBox(width:8), _btn("إنشاء", Colors.purple)]),
        const SizedBox(height:20),
        // رص واقعي
        Wrap(spacing:6, runSpacing:8, children: tiles.map((t)=> Container(width:54, height:88, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: Colors.black45, blurRadius:4, offset: const Offset(2,2))], border: Border.all(color: Colors.black12)), child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [ _dots(t[0]), Container(height:1, color: Colors.black26, margin: const EdgeInsets.symmetric(horizontal:8)), _dots(t[1])]))).toList()),
        const Spacer(),
        Container(padding: const EdgeInsets.all(8), color: const Color(0xFF1A2332), child: Row(children: [const Text("الغرفة الموصى بها: ملتقى آل سلاطين (14) ", style: TextStyle(color: Colors.white, fontSize:11)), Expanded(child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(20)), child: const Text("قل شيئا", style: TextStyle(color: Colors.white54))))]))
      ]),
    );
  }
  Widget _iconBox(String e)=>Container(margin: const EdgeInsets.only(left:6), padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(12)), child: Text(e));
  Widget _btn(String t, Color c)=>Container(padding: const EdgeInsets.symmetric(horizontal:18,vertical:10), decoration: BoxDecoration(gradient: LinearGradient(colors:[c, c.withOpacity(0.6)]), borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black45, offset: const Offset(0,3))]), child: Text(t, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize:12)));
  Widget _dots(int n)=>Wrap(spacing:2, runSpacing:2, alignment: WrapAlignment.center, children: List.generate(n, (i)=> Container(width:8,height:8, decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle))));
}

// ========== 3- لودو بألوان 3D أجمل ==========
class LudoScreen extends StatelessWidget {
  const LudoScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F2A66),
      appBar: AppBar(backgroundColor: const Color(0xFF1A2332), title: const WaitingMini(), leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: ()=>Navigator.pop(context))),
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors:[Color(0xFF2A6EDB), Color(0xFF0F2A66)])),
        child: Column(children: [
          const SizedBox(height:10),
          Container(padding: const EdgeInsets.symmetric(horizontal:20,vertical:8), decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(20)), child: const Text("لودو", style: TextStyle(color: Colors.white))),
          const SizedBox(height:6),
          const Text("اللعبة علي وشك البدء 7", style: TextStyle(color: Colors.white70, fontSize:12)),
          const SizedBox(height:12),
          Container(padding: const EdgeInsets.symmetric(horizontal:36,vertical:12), decoration: BoxDecoration(gradient: const LinearGradient(colors:[Color(0xFF4ADE80), Color(0xFF16A34A)]), borderRadius: BorderRadius.circular(30), boxShadow: [BoxShadow(color: Colors.black45, offset: Offset(0,4))]), child: const Text("العب مع الأصدقاء", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
          const SizedBox(height:20),
          Expanded(child: GridView.count(crossAxisCount:2, padding: const EdgeInsets.all(16), mainAxisSpacing:16, crossAxisSpacing:16, children: [
            _ludoHouse(Colors.red, "🛩️"), _ludoHouse(Colors.green, "🛩️"), _ludoHouse(Colors.amber, "🛩️"), _ludoHouse(Colors.blue, "🛩️"),
          ])),
          Padding(padding: const EdgeInsets.all(12), child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: List.generate(4, (i)=> Column(children: [CircleAvatar(radius:20, backgroundImage: NetworkImage('https://i.pravatar.cc/100?img=${i+5}')), Text(["همام","سحاب","المجروح","الاكابر"][i], style: const TextStyle(color: Colors.white, fontSize:10))])))),
        ]),
      ),
    );
  }
  Widget _ludoHouse(Color c, String e)=>Container(decoration: BoxDecoration(color: c.withOpacity(0.85), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white, width:3), boxShadow: [BoxShadow(color: Colors.black45, blurRadius:6)]), child: Center(child: Text(e, style: const TextStyle(fontSize:40))));
}

// ========== 4- السلم والثعبان بثعابين حقيقية ==========
class SnakeScreen extends StatelessWidget {
  const SnakeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF3C7),
      appBar: AppBar(backgroundColor: const Color(0xFF1A2332), title: const WaitingMini(), leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: ()=>Navigator.pop(context))),
      body: Column(children: [
        Expanded(child: Padding(padding: const EdgeInsets.all(8), child: CustomPaint(painter: SnakeBoardPainter(), child: Container()))),
        Container(padding: const EdgeInsets.all(12), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Container(width:70,height:70, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(width:2), boxShadow: [BoxShadow(color: Colors.black26, blurRadius:6)]), child: const Center(child: Text("🎲", style: TextStyle(fontSize:36))))])),
      ]),
    );
  }
}
class SnakeBoardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width / 10;
    final h = size.height / 10;
    final colors = [Colors.red, Colors.green, Colors.blue, Colors.orange, Colors.yellow];
    int num = 100;
    for (int r=0; r<10; r++){
      for (int c=0; c<10; c++){
        int col = r%2==0? c : 9-c;
        final rect = Rect.fromLTWH(col*w, r*h, w, h);
        final paint = Paint()..color = (r+c)%2==0? Colors.white : colors[(num%5)].withOpacity(0.8);
        canvas.drawRect(rect, paint);
        canvas.drawRect(rect, Paint()..color=Colors.black..style=PaintingStyle.stroke..strokeWidth=0.5);
        final tp = TextPainter(text: TextSpan(text: "$num", style: TextStyle(fontSize:10, fontWeight: FontWeight.bold, color: (r+c)%2==0?Colors.black:Colors.white)), textDirection: TextDirection.ltr)..layout();
        tp.paint(canvas, Offset(rect.left+4, rect.top+2));
        num--;
      }
    }
    // ثعابين ملونة بعيون
    void drawSnake(Offset start, Offset end, Color col){
      final path = Path()..moveTo(start.dx, start.dy)..cubicTo(start.dx+30, start.dy+80, end.dx-30, end.dy-80, end.dx, end.dy);
      canvas.drawPath(path, Paint()..color=col..style=PaintingStyle.stroke..strokeWidth=8..strokeCap=StrokeCap.round);
      canvas.drawCircle(start, 8, Paint()..color=col);
      canvas.drawCircle(start.translate(3, -2), 2, Paint()..color=Colors.white);
      canvas.drawCircle(start.translate(3, -2), 1, Paint()..color=Colors.black);
    }
    drawSnake(Offset(2*w,1*h), Offset(1.5*w,5*h), Colors.amber);
    drawSnake(Offset(5*w,0.5*h), Offset(5.5*w,3*h), Colors.pink);
    drawSnake(Offset(6*w,2*h), Offset(3*w,6*h), Colors.green);
    drawSnake(Offset(1*w,3*h), Offset(2.5*w,8*h), Colors.blue);
    drawSnake(Offset(7*w,4*h), Offset(6*w,6.5*h), Colors.purple);
    drawSnake(Offset(2*w,6.5*h), Offset(5*w,9*h), Colors.deepPurple);
    // سلالم بيضاء
    final ladderPaint = Paint()..color=Colors.white..style=PaintingStyle.stroke..strokeWidth=3;
    void drawLadder(Offset a, Offset b){
      canvas.drawLine(a, b, ladderPaint);
      canvas.drawLine(a.translate(10,0), b.translate(10,0), ladderPaint);
      for(double t=0.2; t<0.8; t+=0.15){ canvas.drawLine(Offset(a.dx + (b.dx-a.dx)*t, a.dy + (b.dy-a.dy)*t), Offset(a.dx + (b.dx-a.dx)*t+10, a.dy + (b.dy-a.dy)*t), ladderPaint); }
    }
    drawLadder(Offset(0.5*w,0.5*h), Offset(0.2*w,2.5*h));
    drawLadder(Offset(3*w,1.2*h), Offset(5*w,4.5*h));
    drawLadder(Offset(7*w,2.8*h), Offset(9*w,3.5*h));
  }
  @override bool shouldRepaint(covariant CustomPainter old)=>false;
}
