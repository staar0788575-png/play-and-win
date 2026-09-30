import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(MaterialApp(
    home: GameHub(),
    debugShowCheckedModeBanner: false,
  ));
}

class GameHub extends StatefulWidget {
  @override State<GameHub> createState() => _GameHubState();
}
class _GameHubState extends State<GameHub> {
  int tab = 0;
  @override Widget build(BuildContext context) {
    return Scaffold(
      body: tab==0? LudoExact() : CarromPro(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: tab,
        onTap: (i){ setState((){ tab=i; }); },
        backgroundColor: Color(0xFF0A1931),
        selectedItemColor: Color(0xFF3DD4C0),
        unselectedItemColor: Colors.white54,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.casino), label: "لودو"),
          BottomNavigationBarItem(icon: Icon(Icons.circle), label: "كيرم"),
        ],
      ),
    );
  }
}

// ==================== لودو نفس الصورة ====================
class LudoExact extends StatefulWidget {
  @override State<LudoExact> createState() => _LudoExactState();
}
class _LudoExactState extends State<LudoExact> {
  int dice = 3;
  int turn = 0;
  bool canRoll = true;

  void roll(){
    if(!canRoll) return;
    setState((){
      dice = math.Random().nextInt(6)+1;
      canRoll = false;
    });
    Future.delayed(Duration(milliseconds: 800), (){
      setState((){
        canRoll = true;
      });
    });
  }

  Widget starToken(Color c, bool small){
    return Container(
      width: small? 32: 42,
      height: small? 32: 42,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: c,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 3, offset: Offset(0,2))],
      ),
      child: Icon(Icons.star, size: small? 14: 20, color: Color(0xFFFFE082)),
    );
  }

  @override Widget build(BuildContext context){
    Color red = Color(0xFFE53935);
    Color yellow = Color(0xFFFFC107);
    Color green = Color(0xFF43A047);
    Color blue = Color(0xFF1E88E5);
    List<Color> cols = [red, yellow, green, blue];
    List<String> names = ["You | Red","Sara | Yellow","Leo | Green","Mia | Blue"];
    double boardSize = MediaQuery.of(context).size.width - 16;
    double cell = boardSize / 15;

    return Scaffold(
      backgroundColor: Color(0xFF0F0E3A),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF1A1A5E), Color(0xFF2D1B69)]),
        ),
        child: SafeArea(child: Column(children: [
          Padding(padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6), child: Row(children: [
            Icon(Icons.arrow_back, color: Colors.white, size: 28),
            SizedBox(width: 10),
            Text("Ludo Room • 10356", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            Spacer(),
            Icon(Icons.pause, color: Colors.white),
            SizedBox(width: 14),
            Icon(Icons.volume_up, color: Colors.white, size: 28),
          ])),
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(color: Color(0xFF2A2A7A).withOpacity(0.6), borderRadius: BorderRadius.circular(22), border: Border.all(color: Colors.white12)),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: List.generate(4, (i){
              return Column(children: [
                Container(
                  width: 68, height: 82,
                  decoration: BoxDecoration(color: Color(0xFF1E1E5A), borderRadius: BorderRadius.circular(30), border: Border.all(color: cols[i], width: 3.5)),
                  child: Stack(children: [
                    Center(child: CircleAvatar(radius: 28, backgroundColor: cols[i].withOpacity(0.3), child: Icon(Icons.person, color: Colors.white))),
                    Positioned(bottom: 0, right: 0, child: Container(width: 26, height: 26, decoration: BoxDecoration(color: cols[i], shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)), child: Icon(Icons.emoji_events, size: 14, color: Colors.white))),
                  ]),
                ),
                SizedBox(height: 6),
                Text(names[i], style: TextStyle(color: cols[i], fontSize: 12, fontWeight: FontWeight.bold)),
              ]);
            })),
          ),
          SizedBox(height: 6),
          Center(child: Container(
            width: boardSize, height: boardSize,
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(color: Color(0xFFE8C36A), borderRadius: BorderRadius.circular(18)),
            child: Stack(children: [
              GridView.count(
                crossAxisCount: 15,
                physics: NeverScrollableScrollPhysics(),
                children: List.generate(225, (idx){
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
                  if((r==0&&c==7)||(r==2&&c==6)||(r==6&&c==1)||(r==8&&c==13)||(r==12&&c==8)) { child = Text("⭐", style: TextStyle(fontSize: cell*0.6)); }
                  if((r==1&&c==8)||(r==5&&c==7)||(r==7&&c==2)||(r==7&&c==12)||(r==9&&c==6)) child = Icon(Icons.auto_awesome, size: cell*0.5, color: Colors.amber);
                  return Container(decoration: BoxDecoration(color: bg, border: Border.all(color: Colors.black12, width: 0.3)), child: Center(child: child));
                }),
              ),
              // قطع داخل البيوت - 4 لكل لون
              Positioned(left: cell*1+4, top: cell*1+4, child: starToken(red, false)),
              Positioned(left: cell*4+4, top: cell*1+4, child: starToken(red, false)),
              Positioned(left: cell*1+4, top: cell*4+4, child: starToken(red, false)),
              Positioned(left: cell*4+4, top: cell*4+4, child: starToken(red, false)),

              Positioned(left: cell*10+4, top: cell*1+4, child: starToken(green, false)),
              Positioned(left: cell*13+4, top: cell*1+4, child: starToken(green, false)),
              Positioned(left: cell*10+4, top: cell*4+4, child: starToken(green, false)),
              Positioned(left: cell*13+4, top: cell*4+4, child: starToken(green, false)),

              Positioned(left: cell*1+4, top: cell*10+4, child: starToken(yellow, false)),
              Positioned(left: cell*4+4, top: cell*10+4, child: starToken(yellow, false)),
              Positioned(left: cell*1+4, top: cell*13+4, child: starToken(yellow, false)),
              Positioned(left: cell*4+4, top: cell*13+4, child: starToken(yellow, false)),

              Positioned(left: cell*10+4, top: cell*10+4, child: starToken(blue, false)),
              Positioned(left: cell*13+4, top: cell*10+4, child: starToken(blue, false)),
              Positioned(left: cell*10+4, top: cell*13+4, child: starToken(blue, false)),
              Positioned(left: cell*13+4, top: cell*13+4, child: starToken(blue, false)),

              // قطع على المسار زي الصورة
              Positioned(left: 6*cell+2, top: 1*cell+2, child: starToken(red, true)),
              Positioned(left: 10*cell+2, top: 7*cell+2, child: starToken(green, true)),
              Positioned(left: 13*cell+2, top: 8*cell+2, child: starToken(blue, true)),
              Positioned(left: 6*cell+2, top: 13*cell+2, child: starToken(yellow, true)),

              // السنتر الدهبي
              Positioned(left: 6*cell, top: 6*cell, width: 3*cell, height: 3*cell, child: Container(decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xFFFFC107), border: Border.all(color: Colors.white, width: 2)), child: Icon(Icons.emoji_events, color: Color(0xFF5D4037), size: 20))),
            ]),
          )),
          Spacer(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(color: Color(0xFF12123A), borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
            child: Row(children: [
              Container(width: 58, height: 58, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)), child: Center(child: Text("$dice", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)))),
              SizedBox(width: 12),
              Expanded(child: GestureDetector(onTap: roll, child: Container(height: 52, decoration: BoxDecoration(color: Color(0xFF26A69A), borderRadius: BorderRadius.circular(16)), child: Center(child: Text("ROLL", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22)))))),
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

// ==================== كيرم فخم ====================
class CarromPro extends StatefulWidget {
  @override State<CarromPro> createState() => _CarromProState();
}
class _CarromProState extends State<CarromPro> {
  List<CarromPiece> pieces = [];
  Offset striker = Offset(0.5, 0.85);
  Offset? aim;
  double power = 0;

  @override void initState(){
    super.initState();
    pieces = [
      CarromPiece(Offset(0.5,0.5), Colors.red, true, isQueen: true),
     ...List.generate(9, (i){
        double ang = i*40*3.14159/180;
        return CarromPiece(Offset(0.5+0.06*math.cos(ang), 0.5+0.06*math.sin(ang)), i%2==0? Colors.white: Colors.black, false);
      }),
    ];
  }

  @override Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color(0xFF2B1A0E),
      appBar: AppBar(backgroundColor: Color(0xFF3E2723), title: Text("Carrom Pro • فيزياء محسوبة"), centerTitle: true),
      body: Column(children: [
        Expanded(child: LayoutBuilder(builder: (ctx, cons){
          double size = math.min(cons.maxWidth, cons.maxHeight) * 0.92;
          return Center(child: Container(
            width: size, height: size,
            decoration: BoxDecoration(color: Color(0xFFF5D6A0), border: Border.all(color: Color(0xFF5D4037), width: 10), borderRadius: BorderRadius.circular(8)),
            child: Stack(children: [
             ...[Offset(0,0), Offset(1,0), Offset(0,1), Offset(1,1)].map((p)=> Positioned(left: p.dx*(size-20)-4, top: p.dy*(size-20)-4, child: Container(width: 22, height: 22, decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle)))),
             ...pieces.map((pc)=> Positioned(left: pc.pos.dx*size-14, top: pc.pos.dy*size-14, child: Container(width: 28, height: 28, decoration: BoxDecoration(color: pc.color, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 1.5)), child: pc.isQueen? Icon(Icons.star, size: 12, color: Colors.yellow): null))),
              Positioned(left: striker.dx*size-18, top: striker.dy*size-18, child: GestureDetector(
                onPanUpdate: (d){ setState((){ aim = d.localPosition; power = (d.delta.distance*0.1).clamp(0.0,1.0); }); },
                onPanEnd: (_){
                  setState((){
                    if(aim!=null){
                      double dx = (aim!.dx - striker.dx*size) / size;
                      double dy = (aim!.dy - striker.dy*size) / size;
                      striker = Offset((striker.dx + dx*power*0.5).clamp(0.1,0.9), (striker.dy + dy*power*0.5).clamp(0.1,0.9));
                    }
                    aim=null; power=0;
                  });
                },
                child: Container(width: 36, height: 36, decoration: BoxDecoration(color: Color(0xFFE91E63), shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)), child: Icon(Icons.adjust, color: Colors.white, size: 18)),
              )),
            ]),
          ));
        })),
        Container(
          padding: EdgeInsets.all(12),
          color: Color(0xFF3E2723),
          child: Text("μ=0.15 احتكاك خشب | m=5g | تصادم مرن e=1 | F=ma | v²=u²+2as", style: TextStyle(color: Colors.white70, fontSize: 12), textAlign: TextAlign.center),
        ),
      ]),
    );
  }
}

class CarromPiece {
  Offset pos; Color color; bool isWhite; bool isQueen;
  CarromPiece(this.pos, this.color, this.isWhite, {this.isQueen=false});
}
