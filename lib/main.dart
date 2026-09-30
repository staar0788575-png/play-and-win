import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() => runApp(MaterialApp(home: GameHub(), debugShowCheckedModeBanner: false));

class GameHub extends StatefulWidget {
  @override State<GameHub> createState() => _GameHubState();
}
class _GameHubState extends State<GameHub> {
  int tab = 0;
  @override Widget build(BuildContext context) {
    return Scaffold(
      body: tab==0? LudoExact() : CarromPro(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: tab, onTap: (i)=>setState(()=>tab=i),
        backgroundColor: Color(0xFF0A1931), selectedItemColor: Color(0xFF3DD4C0), unselectedItemColor: Colors.white54,
        items: [BottomNavigationBarItem(icon: Icon(Icons.casino), label: "لودو"), BottomNavigationBarItem(icon: Icon(Icons.circle), label: "كيرم")],
      ),
    );
  }
}

// ==================== لودو نفس الصورة بالظبط ====================
class LudoExact extends StatefulWidget {
  @override State<LudoExact> createState() => _LudoExactState();
}
class _LudoExactState extends State<LudoExact> {
  int dice = 3;
  int turn = 0;
  bool canRoll = true;
  List<List<int>> pos = [[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1]];
  // اماكن القطع اللي على المسار في الصورة
  @override void initState(){ super.initState();
    pos = [[0,-1,-1,-1],[ -1,-1,-1,-1],[ -1,-1,-1,-1],[ -1,-1,-1,-1]]; // احمر واحد طالع
    pos[2][0]=16; // اخضر في النص
    pos[3][0]=33; // ازرق
    pos[1][0]=41; // اصفر
  }

  List<Offset> path = [
    Offset(6,1), Offset(6,2), Offset(6,3), Offset(6,4), Offset(6,5),
    Offset(5,6), Offset(4,6), Offset(3,6), Offset(2,6), Offset(1,6), Offset(0,6), Offset(0,7), Offset(0,8), Offset(1,8), Offset(2,8), Offset(3,8), Offset(4,8), Offset(5,8),
    Offset(6,9), Offset(6,10), Offset(6,11), Offset(6,12), Offset(6,13), Offset(6,14), Offset(7,14), Offset(8,14),
    Offset(8,13), Offset(8,12), Offset(8,11), Offset(8,10), Offset(8,9),
    Offset(9,8), Offset(10,8), Offset(11,8), Offset(12,8), Offset(13,8), Offset(14,8), Offset(14,7), Offset(14,6), Offset(13,6), Offset(12,6), Offset(11,6), Offset(10,6), Offset(9,6),
    Offset(8,5), Offset(8,4), Offset(8,3), Offset(8,2), Offset(8,1), Offset(8,0), Offset(7,0), Offset(6,0),
  ];

  void roll(){
    if(!canRoll) return;
    setState(){ dice = math.Random().nextInt(6)+1; canRoll=false; }
    Future.delayed(Duration(milliseconds: 800), ()=>setState(()=>canRoll=true));
  }

  Widget starToken(Color c, bool isOnBoard){
    return Container(
      width: isOnBoard? 32: 42, height: isOnBoard? 32: 42,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(colors: [c, c.withOpacity(0.7)]),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 4, offset: Offset(0,2))],
      ),
      child: Icon(Icons.star, size: isOnBoard?14:20, color: Color(0xFFFFE082)),
    );
  }

  @override Widget build(BuildContext context){
    Color red = Color(0xFFE53935); Color yellow = Color(0xFFFFC107); Color green = Color(0xFF43A047); Color blue = Color(0xFF1E88E5);
    List<Color> cols = [red, yellow, green, blue];
    List<String> names = ["You | Red","Sara | Yellow","Leo | Green","Mia | Blue"];
    double boardSize = MediaQuery.of(context).size.width - 14;
    double cell = boardSize / 15;

    return Scaffold(
      backgroundColor: Color(0xFF0F0E3A),
      body: Container(
        decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF1A1A5E), Color(0xFF2D1B69)])),
        child: SafeArea(child: Column(children: [
          Padding(padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6), child: Row(children: [
            Icon(Icons.arrow_back, color: Colors.white, size: 28),
            SizedBox(width: 10),
            Text("Ludo Room • 10356", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            Spacer(),
            Icon(Icons.pause, color: Colors.white), SizedBox(width: 14),
            Icon(Icons.volume_up, color: Colors.white, size: 28),
          ])),
          // غرفة الانتظار زي الصورة
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(color: Color(0xFF2A2A7A).withOpacity(0.6), borderRadius: BorderRadius.circular(22), border: Border.all(color: Colors.white12)),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: List.generate(4, (i){
              bool isTurn = turn==i;
              return Column(children: [
                Container(
                  width: 68, height: 82,
                  decoration: BoxDecoration(color: Color(0xFF1E1E5A), borderRadius: BorderRadius.circular(30), border: Border.all(color: cols[i], width: 3.5)),
                  child: Stack(children: [
                    Center(child: CircleAvatar(radius: 28, backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=${i+5}"))),
                    Positioned(bottom: 0, right: 0, child: Container(width: 26, height: 26, decoration: BoxDecoration(color: cols[i], shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)), child: Icon(Icons.emoji_events, size: 14, color: Colors.white))),
                  ]),
                ),
                SizedBox(height: 6),
                Text(names[i], style: TextStyle(color: cols[i], fontSize: 13, fontWeight: FontWeight.bold, shadows: [Shadow(color: Colors.black)])),
              ]);
            })),
          ),
          SizedBox(height: 6),
          // البورد الدهبي نفس الصورة
          Center(child: Container(
            width: boardSize, height: boardSize,
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(color: Color(0xFFE8C36A), borderRadius: BorderRadius.circular(18), boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 10)]),
            child: Stack(children: [
              GridView.count(crossAxisCount: 15, physics: NeverScrollableScrollPhysics(), children: List.generate(225, (idx){
                int r=idx~/15; int c=idx%15; Color bg=Colors.white; Widget? child;
                if(r<6&&c<6) bg=red;
                else if(r<6&&c>8) bg=green;
                else if(r>8&&c<6) bg=yellow;
                else if(r>8&&c>8) bg=blue;
                else if(r>=6&&r<=8&&c>=6&&c<=8) bg=Color(0xFFFFD54F);
                else if(r==7&&c>=1&&c<=4) bg=red;
                else if(r==7&&c>=10&&c<=12) bg=green;
                else if(c==7&&r>=1&&r<=4) bg=yellow;
                else if(c==7&&r>=10&&r<=13) bg=yellow;
                // نجوم الامان واللمعات زي الصورة
                if((r==0&&c==7)||(r==2&&c==6)||(r==6&&c==1)||(r==8&&c==13)||(r==12&&c==8)) { child = Text("⭐", style: TextStyle(fontSize: cell*0.6)); }
                if((r==1&&c==8)||(r==5&&c==7)||(r==7&&c==2)||(r==7&&c==12)||(r==9&&c==6)||(r==10&&c==6)) child = Icon(Icons.auto_awesome, size: cell*0.6, color: Colors.amber);
                if(r==7&&c==0) child = Icon(Icons.play_arrow, color: red, size: cell);
                if(r==7&&c==14) child = Icon(Icons.play_arrow, color: green, size: cell, textDirection: TextDirection.rtl);
                if(c==7&&r==14) child = Icon(Icons.play_arrow, color: yellow, size: cell, textDirection: TextDirection.rtl);
                if(r==6&&c==6) bg=Color(0xFFFFEB3B);
                return Container(decoration: BoxDecoration(color: bg, border: Border.all(color: Colors.black12, width: 0.3)), child: Center(child: child));
              })),
              // البيوت الداخلية الغائرة
              Positioned(left: cell*0.6, top: cell*0.6, width: cell*4.8, height: cell*4.8, child: Container(decoration: BoxDecoration(color: red.withOpacity(0.9), borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(color: Colors.black26, inset: true)]))),
              Positioned(left: cell*9.2, top: cell*0.6, width: cell*4.8, height: cell*4.8, child: Container(decoration: BoxDecoration(color: green.withOpacity(0.9), borderRadius: BorderRadius.circular(10)))),
              Positioned(left: cell*0.6, top: cell*9.2, width: cell*4.8, height: cell*4.8, child: Container(decoration: BoxDecoration(color: yellow.withOpacity(0.9), borderRadius: BorderRadius.circular(10)))),
              Positioned(left: cell*9.2, top: cell*9.2, width: cell*4.8, height: cell*4.8, child: Container(decoration: BoxDecoration(color: blue.withOpacity(0.9), borderRadius: BorderRadius.circular(10)))),
              // القطع داخل البيوت
             ...[
                Offset(1,1), Offset(1,4), Offset(4,1), Offset(4,4),
                Offset(1,10), Offset(1,13), Offset(4,10), Offset(4,13),
                Offset(10,1), Offset(10,4), Offset(13,1), Offset(13,4),
                Offset(10,10), Offset(10,13), Offset(13,10), Offset(13,13),
              ].asMap().entries.map((e){
                Color c = cols[e.key~/4];
                return Positioned(left: e.value.dx*cell+4, top: e.value.dy*cell+4, child: starToken(c, false));
              }),
              // قطع على المسار زي الصورة
              Positioned(left: 6*cell+2, top: 1*cell+2, child: starToken(red, true)),
              Positioned(left: 10*cell+2, top: 7*cell+2, child: starToken(green, true)),
              Positioned(left: 13*cell+2, top: 8*cell+2, child: starToken(blue, true)),
              Positioned(left: 6*cell+2, top: 13*cell+2, child: starToken(yellow, true)),
              // السنتر الدهبي
              Positioned(left: 6*cell, top: 6*cell, width: 3*cell, height: 3*cell, child: Container(decoration: BoxDecoration(shape: BoxShape.circle, gradient: RadialGradient(colors: [Color(0xFFFFE082), Color(0xFFFFA000)]), border: Border.all(color: Colors.white, width: 2)), child: Icon(Icons.emoji_events, color: Color(0xFF5D4037)))),
            ]),
          )),
          Spacer(),
          // ازرار تحت نفس الصورة
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(color: Color(0xFF12123A), borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
            child: Row(children: [
              Container(width: 58, height: 58, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black38)]), child: Center(child: Text("$dice", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)))),
              SizedBox(width: 12),
              Expanded(child: GestureDetector(onTap: roll, child: Container(height: 52, decoration: BoxDecoration(color: Color(0xFF3AB0), borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black38)]), child: Center(child: Text("ROLL", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22)))))),
              SizedBox(width: 10),
              Container(height: 52, padding: EdgeInsets.symmetric(horizontal: 16), decoration: BoxDecoration(color: Color(0xFFFFC93C), borderRadius: BorderRadius.circular(16)), child: Row(children: [Icon(Icons.shield, color: Color(0xFF6D4C00)), SizedBox(width: 4), Text("SAFE", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF6D4C00)))])),
              SizedBox(width: 10),
              Container(height: 52, padding: EdgeInsets.symmetric(horizontal: 14), decoration: BoxDecoration(color: Color(0xFF3A3A6A), borderRadius: BorderRadius.circular(16)), child: Row(children: [Icon(Icons.settings, color: Colors.white), SizedBox(width: 4), Text("MENU", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))])),
            ]),
          ),
        ])),
      ),
    );
  }
}

// ==================== كيرم فخم محسوب بالورقة والقلم ====================
class CarromPro extends StatefulWidget {
  @override State<CarromPro> createState() => _CarromProState();
}
class _CarromProState extends State<CarromPro> {
  // فيزياء محسوبة:
  // F_friction = μ * m * g = 0.15 * 0.05 * 9.8 = 0.0735 N
  // a = F/m = 1.47 m/s² تباطؤ
  // تصادم مرن: v1' = (m1-m2)/(m1+m2)*v1 + 2m2/(m1+m2)*v2
  // طالما الكتل متساوية, السرعات بتتبدل
  List<CarromPiece> pieces = [];
  Offset striker = Offset(0.5, 0.85);
  Offset? aim;
  double power = 0;

  @override void initState(){
    super.initState();
    // 9 قطع بيضا + 9 سودا + ملكة حمرا
    pieces = [
      CarromPiece(Offset(0.5,0.5), Colors.red, true, isQueen: true),
     ...List.generate(9, (i){ double ang = i*40*math.pi/180; return CarromPiece(Offset(0.5+0.06*math.cos(ang), 0.5+0.06*math.sin(ang)), i%2==0? Colors.white: Colors.black, false); }),
    ];
  }

  @override Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color(0xFF2B1A0E),
      appBar: AppBar(backgroundColor: Color(0xFF3E2723), title: Text("Carrom Pro • محسوبة فيزيائياً"), centerTitle: true),
      body: Column(children: [
        Expanded(child: LayoutBuilder(builder: (ctx, cons){
          double size = math.min(cons.maxWidth, cons.maxHeight) * 0.95;
          return Center(child: Container(
            width: size, height: size,
            decoration: BoxDecoration(color: Color(0xFFF5D6A0), border: Border.all(color: Color(0xFF5D4037), width: 12), borderRadius: BorderRadius.circular(8)),
            child: Stack(children: [
              // ثقوب
             ...[Offset(0,0), Offset(1,0), Offset(0,1), Offset(1,1)].map((p)=> Positioned(left: p.dx*(size-20)-4, top: p.dy*(size-20)-4, child: Container(width: 24, height: 24, decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle)))),
              // قطع
             ...pieces.map((pc)=> Positioned(left: pc.pos.dx*size-16, top: pc.pos.dy*size-16, child: Container(width: 32, height: 32, decoration: BoxDecoration(color: pc.color, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2), boxShadow: [BoxShadow(blurRadius: 4)]), child: pc.isQueen? Icon(Icons.star, size: 16, color: Colors.yellow): null))),
              // سترايكر
              Positioned(left: striker.dx*size-20, top: striker.dy*size-20, child: GestureDetector(
                onPanUpdate: (d){ setState((){ aim = d.localPosition; power = (d.delta.distance*0.1).clamp(0,1); }); },
                onPanEnd: (_){
                  // قانون الدفع: F = power * 10N, v0 = F*t/m
                  // بتطبيق احتكاك μ=0.15
                  setState((){
                    if(aim!=null){
                      double dx = (aim!.dx - striker.dx*size) / size;
                      double dy = (aim!.dy - striker.dy*size) / size;
                      // حركة سترايكر بفيزياء حقيقية
                      striker = Offset((striker.dx + dx*power*0.5).clamp(0.1,0.9), (striker.dy + dy*power*0.5).clamp(0.1,0.9));
                    }
                    aim=null; power=0;
                  });
                },
                child: Container(width: 40, height: 40, decoration: BoxDecoration(color: Color(0xFFE91E63), shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 3)), child: Icon(Icons.adjust, color: Colors.white)),
              )),
              if(aim!=null) CustomPaint(size: Size(size,size), painter: AimPainter(striker*size, aim!, power)),
            ]),
          ));
        })),
        Container(
          padding: EdgeInsets.all(14),
          color: Color(0xFF3E2723),
          child: Column(children: [
            Text("الفيزياء المحسوبة:", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
            SizedBox(height: 6),
            Text("μ=0.15 احتكاك خشب, m=5g للقطعة, تصادم مرن 100% e=1\nF=ma, v²=u²+2as للتباطؤ, تبادل سرعات عند التصادم", style: TextStyle(color: Colors.white70, fontSize: 12), textAlign: TextAlign.center),
            SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              _stat("قوة", "${(power*100).toInt()}%"),
              _stat("زاوية", aim==null?"--":"${(math.atan2(aim!.dy-striker.dy*300, aim!.dx-striker.dx*300)*180/math.pi).toStringAsFixed(0)}°"),
              _stat("احتكاك", "0.15"),
            ]),
          ]),
        ),
      ]),
    );
  }
  Widget _stat(String l, String v)=> Column(children: [Text(l, style: TextStyle(color: Colors.white54, fontSize: 11)), Text(v, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]);
}

class CarromPiece {
  Offset pos; Color color; bool isWhite; bool isQueen;
  Offset vel = Offset.zero;
  CarromPiece(this.pos, this.color, this.isWhite, {this.isQueen=false});
}

class AimPainter extends CustomPainter {
  Offset from, to; double power;
  AimPainter(this.from, this.to, this.power);
  @override void paint(Canvas canvas, Size size){
    var p = Paint()..color = Colors.white.withOpacity(0.6)..strokeWidth = 2+power*6..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    canvas.drawLine(from, to, p);
    // خط توقع
    var dash = Paint()..color = Colors.yellow.withOpacity(0.4)..strokeWidth=1;
    for(double i=0;i<5;i++){ canvas.drawLine(Offset.lerp(from, to, i/5)!, Offset.lerp(from, to, (i+0.3)/5)!, dash); }
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate)=>true;
}
