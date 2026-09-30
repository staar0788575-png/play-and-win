import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';

void main() => runApp(MaterialApp(home: GameHub(), debugShowCheckedModeBanner: false));

class GameHub extends StatefulWidget {
  @override State<GameHub> createState() => _GameHubState();
}
class _GameHubState extends State<GameHub> {
  int tab = 0;
  @override Widget build(BuildContext context) {
    return Scaffold(
      body: tab==0? LudoRoyalFull() : CarromFull(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: tab,
        onTap: (i){ setState(()=>tab=i); },
        backgroundColor: Color(0xFF0A1931),
        selectedItemColor: Color(0xFFFFD700),
        unselectedItemColor: Colors.white54,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.workspace_premium), label: "لودو ملوكي"),
          BottomNavigationBarItem(icon: Icon(Icons.circle), label: "كيرم محترف"),
        ],
      ),
    );
  }
}

// ==================== لودو - خروج مظبوط من قدام البيت ====================
class LudoRoyalFull extends StatefulWidget {
  @override State<LudoRoyalFull> createState() => _LudoRoyalFullState();
}
class _LudoRoyalFullState extends State<LudoRoyalFull> {
  int dice=1, turn=0; bool canRoll=true; String msg="دور الملك الأحمر - ارمي 6 عشان تطلع";
  List<List<int>> tokens=[[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1]];

  // كل لون يطلع من قدام بيته بالظبط
  // 0=احمر قدام بيته شمال, 1=اصفر قدام بيته تحت, 2=اخضر قدام بيته فوق, 3=ازرق قدام بيته يمين
  List<int> start=[0,39,13,26];
  List<int> safe=[0,8,13,21,26,34,39,47];
  List<List<int>> homePath=[[52,53,54,55,56,57],[58,59,60,61,62,63],[64,65,66,67,68,69],[70,71,72,73,74,75]];

  List<Offset> path=[
    Offset(6,1),Offset(6,2),Offset(6,3),Offset(6,4),Offset(6,5),
    Offset(5,6),Offset(4,6),Offset(3,6),Offset(2,6),Offset(1,6),Offset(0,6),Offset(0,7),Offset(0,8),Offset(1,8),Offset(2,8),Offset(3,8),Offset(4,8),Offset(5,8),
    Offset(6,9),Offset(6,10),Offset(6,11),Offset(6,12),Offset(6,13),Offset(6,14),Offset(7,14),Offset(8,14),
    Offset(8,13),Offset(8,12),Offset(8,11),Offset(8,10),Offset(8,9),Offset(9,8),Offset(10,8),Offset(11,8),Offset(12,8),Offset(13,8),Offset(14,8),Offset(14,7),Offset(14,6),Offset(13,6),Offset(12,6),Offset(11,6),Offset(10,6),Offset(9,6),
    Offset(8,5),Offset(8,4),Offset(8,3),Offset(8,2),Offset(8,1),Offset(8,0),Offset(7,0),Offset(6,0),
  ];
  Map<int,Offset> homeCoords={
    52:Offset(7,1),53:Offset(7,2),54:Offset(7,3),55:Offset(7,4),56:Offset(7,5),57:Offset(7,6),
    58:Offset(13,7),59:Offset(12,7),60:Offset(11,7),61:Offset(10,7),62:Offset(9,7),63:Offset(8,7),
    64:Offset(1,7),65:Offset(2,7),66:Offset(3,7),67:Offset(4,7),68:Offset(5,7),69:Offset(6,7),
    70:Offset(7,13),71:Offset(7,12),72:Offset(7,11),73:Offset(7,10),74:Offset(7,9),75:Offset(7,8),
  };

  void roll(){
    if(!canRoll) return;
    setState((){
      dice=math.Random().nextInt(6)+1;
      canRoll=false;
      msg="جبت $dice - ${["الاحمر","الاصفر","الاخضر","الازرق"][turn]} يلعب";
    });
    bool can=false;
    for(int p in tokens[turn]){
      if(p==-1&&dice==6) can=true;
      if(p>=0&&p<52) can=true;
      if(p>=52&&p<76) can=true;
    }
    if(!can){
      Future.delayed(Duration(milliseconds:800),(){
        setState((){
          turn=(turn+1)%4;
          canRoll=true;
          msg="مفيش حركة - دور ${["الاحمر","الاصفر","الاخضر","الازرق"][turn]}";
        });
      });
    }
  }

  void move(int p,int idx){
    if(p!=turn){ setState(()=>msg="مش دورك - دور ${["الاحمر","الاصفر","الاخضر","الازرق"][turn]}"); return; }
    if(canRoll){ setState(()=>msg="ارمي النرد الاول!"); return; }
    int cur=tokens[p][idx];
    if(cur==-1&&dice!=6){ setState(()=>msg="لازم 6 عشان تطلع من قدام بيتك!"); return; }

    setState((){
      if(cur==-1){
        tokens[p][idx]=start[p];
      }else if(cur>=0&&cur<52){
        int entry=(start[p]+51)%52;
        int steps=cur+dice;
        if(cur<=entry && steps>entry){
          int homeSteps=steps-entry-1;
          if(homeSteps<6) tokens[p][idx]=homePath[p][homeSteps];
          else if(homeSteps==6) tokens[p][idx]=100;
          else tokens[p][idx]=steps%52;
        }else{
          tokens[p][idx]=steps%52;
        }
      }else if(cur>=52 && cur<100){
        int homeIdx=homePath[p].indexOf(cur);
        if(homeIdx+dice<6) tokens[p][idx]=homePath[p][homeIdx+dice];
        else if(homeIdx+dice==6) tokens[p][idx]=100;
      }
      int newPos=tokens[p][idx];
      if(newPos<52 &&!safe.contains(newPos)){
        for(int op=0;op<4;op++){ if(op==p) continue; for(int ot=0;ot<4;ot++){ if(tokens[op][ot]==newPos){ tokens[op][ot]=-1; msg="الملك ${["الاحمر","الاصفر","الاخضر","الازرق"][p]} أكل ${["الاحمر","الاصفر","الاخضر","الازرق"][op]}! 🔥"; } } }
      }
      if(tokens[p].every((e)=>e==100)){ msg="الملك ${["الاحمر","الاصفر","الاخضر","الازرق"][p]} كسب! 👑"; return; }
      if(dice!=6) turn=(turn+1)%4;
      canRoll=true;
      if(!msg.contains("أكل")) msg="دور ملك ${["الاحمر","الاصفر","الاخضر","الازرق"][turn]}";
    });
  }

  Widget king(Color c,int p,int idx,bool onBoard){
    bool isTurn=turn==p &&!canRoll;
    return GestureDetector(
      onTap: ()=>move(p,idx),
      child: Container(
        width: onBoard?28:38, height: onBoard?28:38,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [Color(0xFFFFE082), Color(0xFFFFC107), Color(0xFFB8860B)]),
          border: Border.all(color: isTurn? Colors.white : Colors.white70, width: isTurn?3:2),
        ),
        child: Stack(alignment: Alignment.center, children: [
          Text("♔", style: TextStyle(fontSize: onBoard?13:18, color: Color(0xFF3E2723))),
          Positioned(top:1, child: Container(width:6, height:6, decoration: BoxDecoration(color: c, shape: BoxShape.circle, border: Border.all(color: Colors.white, width:1)))),
        ]),
      ),
    );
  }

  @override Widget build(BuildContext context){
    Color red=Color(0xFFE53935), yellow=Color(0xFFFBC02D), green=Color(0xFF43A047), blue=Color(0xFF1E88E5);
    List<Color> cols=[red,yellow,green,blue];
    double size=MediaQuery.of(context).size.width-12;
    double cell=size/15;
    return Scaffold(
      backgroundColor: Color(0xFF0D1B4A),
      body: Container(
        decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF0D1B4A), Color(0xFF1A237E)])),
        child: SafeArea(child: Column(children: [
          Padding(padding: EdgeInsets.symmetric(horizontal:12, vertical:8), child: Row(children: [
            Icon(Icons.arrow_back, color: Colors.white, size:22),
            Spacer(),
            Container(padding: EdgeInsets.symmetric(horizontal:12, vertical:6), decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.amber)), child: Text(msg, style: TextStyle(color: Colors.white, fontSize:11, fontWeight: FontWeight.bold))),
            Spacer(), SizedBox(width:22),
          ])),
          Container(
            margin: EdgeInsets.symmetric(horizontal:10),
            padding: EdgeInsets.symmetric(vertical:6),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(14)),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: List.generate(4, (i)=> Column(children: [
              Container(padding: EdgeInsets.all(2), decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: cols[i], width: turn==i?3:1.2)), child: CircleAvatar(radius: 20, backgroundColor: cols[i].withOpacity(0.2), child: Text("♔", style: TextStyle(fontSize:16, color: cols[i])))),
              SizedBox(height:2), Text(["احمر","اصفر","اخضر","ازرق"][i], style: TextStyle(color: cols[i], fontSize:10)),
            ]))),
          ),
          SizedBox(height:6),
          Center(child: Container(
            width: size, height: size,
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(color: Color(0xFF4E342E), borderRadius: BorderRadius.circular(12), border: Border.all(color: Color(0xFFD4AF37), width:3)),
            child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFF8E1)),
              child: Stack(children: [
                GridView.count(crossAxisCount:15, physics: NeverScrollableScrollPhysics(), padding: EdgeInsets.zero, children: List.generate(225, (idx){
                  int r=idx~/15,c=idx%15; Color bg=Color(0xFFFFF8E1);
                  if(r<6&&c<6) bg=red;
                  else if(r<6&&c>8) bg=green;
                  else if(r>8&&c<6) bg=yellow;
                  else if(r>8&&c>8) bg=blue;
                  else if(r==7&&c>=1&&c<=5) bg=red.withOpacity(0.9);
                  else if(r==7&&c>=9&&c<=13) bg=green.withOpacity(0.7);
                  else if(c==7&&r>=1&&r<=5) bg=yellow.withOpacity(0.7);
                  else if(c==7&&r>=9&&r<=13) bg=blue.withOpacity(0.7);
                  else if(r>=6&&r<=8&&c>=6&&c<=8) bg=Color(0xFFFFD54F);
                  Widget? ch; int pIdx=path.indexWhere((e)=>e.dx==r&&e.dy==c);
                  if(safe.contains(pIdx)) ch=Icon(Icons.shield, size: cell*0.35, color: Colors.brown);
                  return Container(decoration: BoxDecoration(color: bg, border: Border.all(color: Colors.black12, width:0.3)), child: Center(child: ch));
                })),
              ...List.generate(4, (p)=>List.generate(4, (t){
                  int bp=tokens[p][t]; double x,y;
                  if(bp==-1){
                    if(p==0){ x=(t%2==0?1:3.2)*cell; y=(t<2?1:3.2)*cell; }
                    else if(p==1){ x=(t%2==0?1:3.2)*cell; y=(t<2?10:12.2)*cell; }
                    else if(p==2){ x=(t%2==0?10:12.2)*cell; y=(t<2?1:3.2)*cell; }
                    else{ x=(t%2==0?10:12.2)*cell; y=(t<2?10:12.2)*cell; }
                  }else if(bp>=100){ x=6.5*cell; y=6.5*cell; }
                  else if(homeCoords.containsKey(bp)){ var pt=homeCoords[bp]!; x=pt.dy*cell; y=pt.dx*cell; }
                  else{ var pt=path[bp%52]; x=pt.dy*cell; y=pt.dx*cell; }
                  return Positioned(left: x+1, top: y+1, child: king(cols[p], p, t, bp!=-1));
                })).expand((e)=>e),
                Positioned(left: 6*cell, top: 6*cell, width: 3*cell, height: 3*cell, child: Container(decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xFFC9A600), border: Border.all(color: Colors.white, width:2)), child: Icon(Icons.emoji_events, color: Colors.white, size:16))),
              ]),
            ),
          )),
          Spacer(),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(color: Color(0xFF0A0A2A), borderRadius: BorderRadius.vertical(top: Radius.circular(18)), border: Border(top: BorderSide(color: Color(0xFFFFD700), width:1))),
            child: Row(children: [
              Container(width:52,height:52, decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xFFFFD700), Color(0xFFB8860B)]), borderRadius: BorderRadius.circular(10)), child: Center(child: Text("$dice", style: TextStyle(fontSize:26, fontWeight: FontWeight.bold)))),
              SizedBox(width:10),
              Expanded(child: GestureDetector(onTap: roll, child: Container(height:50, decoration: BoxDecoration(gradient: LinearGradient(colors: canRoll?[Color(0xFFFFD700), Color(0xFFFFA000)]:[Colors.grey, Colors.grey]), borderRadius: BorderRadius.circular(12)), child: Center(child: Text(canRoll?"ROLL 👑":"حرك ملكك", style: TextStyle(fontWeight: FontWeight.bold)))))),
              SizedBox(width:8),
              Container(height:50, padding: EdgeInsets.symmetric(horizontal:14), decoration: BoxDecoration(color: Color(0xFFFFC93C), borderRadius: BorderRadius.circular(10)), child: Center(child: Text("SAFE"))),
            ]),
          ),
        ])),
      ),
    );
  }
}

// ==================== كيرم - ترابيزة مظبوطة + باسكت مظبوط ====================
class CarromFull extends StatefulWidget {
  @override State<CarromFull> createState()=>_CarromFullState();
}
class _CarromFullState extends State<CarromFull> {
  List<CarromPiece> pieces=[];
  CarromPiece striker=CarromPiece(Offset(0.5,0.82), Color(0xFFE91E63), false, isStriker:true);
  Offset? dragStart, dragEnd;
  Timer? timer;

  @override void initState(){
    super.initState();
    pieces=[
      CarromPiece(Offset(0.5,0.5), Colors.red, true, isQueen:true),
    ...List.generate(9, (i){
        double ang=i*40*3.14159/180;
        double r=i<3?0.05:0.09;
        return CarromPiece(Offset(0.5+r*math.cos(ang), 0.5+r*math.sin(ang)), i%2==0? Colors.white: Colors.black, false);
      }),
    ];
    timer=Timer.periodic(Duration(milliseconds:16), (_)=>updatePhysics());
  }

  void updatePhysics(){
    if(!mounted) return;
    setState((){
      for(var p in [...pieces, striker]){
        if(p.vel==Offset.zero) continue;
        p.pos+=p.vel*0.016;
        p.vel*=0.985;
        if(p.vel.distance<0.001) p.vel=Offset.zero;
        if(p.pos.dx<0.06||p.pos.dx>0.94){ p.vel=Offset(-p.vel.dx*0.8, p.vel.dy); p.pos=Offset(p.pos.dx.clamp(0.06,0.94), p.pos.dy); }
        if(p.pos.dy<0.06||p.pos.dy>0.94){ p.vel=Offset(p.vel.dx, -p.vel.dy*0.8); p.pos=Offset(p.pos.dx, p.pos.dy.clamp(0.06,0.94)); }
      }
      for(int i=0;i<pieces.length;i++){
        for(int j=i+1;j<pieces.length;j++){
          double d=(pieces[i].pos-pieces[j].pos).distance;
          if(d<0.06){
            Offset v1=pieces[i].vel, v2=pieces[j].vel;
            pieces[i].vel=v2*0.9; pieces[j].vel=v1*0.9;
            Offset dir=(pieces[i].pos-pieces[j].pos)/d;
            pieces[i].pos+=dir*0.015; pieces[j].pos-=dir*0.015;
          }
        }
        double ds=(pieces[i].pos-striker.pos).distance;
        if(ds<0.07){ Offset tmp=pieces[i].vel; pieces[i].vel=striker.vel*0.9; striker.vel=tmp*0.9; }
      }
      pieces.removeWhere((p){
        bool inHole=(p.pos-Offset(0.06,0.06)).distance<=0.07||(p.pos-Offset(0.94,0.06)).distance<=0.07||(p.pos-Offset(0.06,0.94)).distance<=0.07||(p.pos-Offset(0.94,0.94)).distance<=0.07;
        return inHole;
      });
    });
  }

  @override void dispose(){ timer?.cancel(); super.dispose(); }

  @override Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color(0xFF1A0F08),
      appBar: AppBar(backgroundColor: Color(0xFF3E2723), elevation:0, title: Text("Carrom Royal", style: TextStyle(fontSize:14, color: Colors.amber)), centerTitle:true),
      body: Column(children: [
        SizedBox(height:10),
        Text("اسحب من الوردي وسيب عشان تضرب - الباسكت في الزوايا", style: TextStyle(color: Colors.white54, fontSize:11)),
        SizedBox(height:10),
        Expanded(child: Center(child: LayoutBuilder(builder: (ctx,cons){
          double size=math.min(cons.maxWidth-20, cons.maxHeight-20);
          return GestureDetector(
            onPanStart: (d){ dragStart=Offset(d.localPosition.dx/size, d.localPosition.dy/size); },
            onPanUpdate: (d){ dragEnd=Offset(d.localPosition.dx/size, d.localPosition.dy/size); setState((){}); },
            onPanEnd: (_){
              if(dragStart!=null&&dragEnd!=null){
                Offset dir=dragStart!-dragEnd!;
                if(dir.distance>0.02) striker.vel=dir*12;
              }
              dragStart=null; dragEnd=null; setState((){});
            },
            child: Container(
              width: size, height: size,
              decoration: BoxDecoration(
                color: Color(0xFFF5D6A0),
                border: Border.all(color: Color(0xFFD4AF37), width:8),
                borderRadius: BorderRadius.circular(4),
                boxShadow: [BoxShadow(color: Colors.black54, blurRadius:12, offset: Offset(0,6))],
              ),
              child: Stack(children: [
                // 4 باسكت في الزوايا - مظبوطين جوه
                Positioned(left: 4, top: 4, child: Container(width:28,height:28, decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle, border: Border.all(color: Color(0xFFFFD700), width:2)))),
                Positioned(right: 4, top: 4, child: Container(width:28,height:28, decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle, border: Border.all(color: Color(0xFFFFD700), width:2)))),
                Positioned(left: 4, bottom: 4, child: Container(width:28,height:28, decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle, border: Border.all(color: Color(0xFFFFD700), width:2)))),
                Positioned(right: 4, bottom: 4, child: Container(width:28,height:28, decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle, border: Border.all(color: Color(0xFFFFD700), width:2)))),

                // خطوط الترابيزة
                CustomPaint(size: Size(size,size), painter: CarromLinesPainter()),

                // الكور
              ...pieces.map((pc)=>Positioned(left: pc.pos.dx*size-15, top: pc.pos.dy*size-15, child: Container(width:30,height:30, decoration: BoxDecoration(color: pc.color, shape: BoxShape.circle, border: Border.all(color: Colors.white, width:2), boxShadow: [BoxShadow(color: Colors.black26, blurRadius:3)]), child: pc.isQueen? Center(child: Text("★", style: TextStyle(color: Colors.yellow, fontSize:14))): null))),

                // الستريكر
                Positioned(left: striker.pos.dx*size-18, top: striker.pos.dy*size-18, child: Container(width:36,height:36, decoration: BoxDecoration(color: striker.color, shape: BoxShape.circle, border: Border.all(color: Colors.white, width:3), boxShadow: [BoxShadow(color: Colors.black54, blurRadius:4)]), child: Icon(Icons.adjust, color: Colors.white, size:16))),

                if(dragStart!=null&&dragEnd!=null) CustomPaint(size: Size(size,size), painter: AimPainter(dragStart!*size, dragEnd!*size)),

                Positioned(bottom:8, left:0, right:0, child: Center(child: Container(padding: EdgeInsets.symmetric(horizontal:10, vertical:4), decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(12)), child: Text("متبقي ${pieces.length} | μ=0.15 | e=0.9", style: TextStyle(color: Colors.white, fontSize:11))))),
              ]),
            ),
          );
        }))),
        SizedBox(height:10),
      ]),
    );
  }
}

class CarromLinesPainter extends CustomPainter{
  @override void paint(Canvas canvas,Size size){
    var p=Paint()..color=Colors.brown.withOpacity(0.3)..strokeWidth=1..style=PaintingStyle.stroke;
    canvas.drawCircle(Offset(size.width/2, size.height/2), 20, p);
    canvas.drawRect(Rect.fromCenter(center: Offset(size.width/2, size.height/2), width: size.width*0.7, height: size.height*0.7), p);
  }
  @override bool shouldRepaint(covariant CustomPainter old)=>false;
}

class CarromPiece{
  Offset pos; Color color; bool isWhite; bool isQueen=false; bool isStriker=false; Offset vel=Offset.zero;
  CarromPiece(this.pos,this.color,this.isWhite,{this.isQueen=false,this.isStriker=false});
}

class AimPainter extends CustomPainter{
  Offset from,to; AimPainter(this.from,this.to);
  @override void paint(Canvas canvas,Size size){
    var p=Paint()..color=Colors.white..strokeWidth=3..style=PaintingStyle.stroke;
    canvas.drawLine(from, to, p);
    var p2=Paint()..color=Colors.yellow.withOpacity(0.5)..strokeWidth=2;
    canvas.drawLine(to, to+(to-from)*0.5, p2);
  }
  @override bool shouldRepaint(covariant CustomPainter old)=>true;
}
