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

// ==================== لودو ملوكي كامل بالمسار ====================
class LudoRoyalFull extends StatefulWidget {
  @override State<LudoRoyalFull> createState() => _LudoRoyalFullState();
}
class _LudoRoyalFullState extends State<LudoRoyalFull> {
  int dice=1, turn=0; bool canRoll=true; String msg="دور الملك الأحمر";
  List<List<int>> tokens=[[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1]];
  List<int> start=[0,13,26,39];
  List<int> safe=[0,8,13,21,26,34,39,47];
  List<List<int>> homePath=[
    [52,53,54,55,56,57],
    [58,59,60,61,62,63],
    [64,65,66,67,68,69],
    [70,71,72,73,74,75],
  ];

  List<Offset> path=[
    Offset(6,1),Offset(6,2),Offset(6,3),Offset(6,4),Offset(6,5),
    Offset(5,6),Offset(4,6),Offset(3,6),Offset(2,6),Offset(1,6),Offset(0,6),Offset(0,7),Offset(0,8),Offset(1,8),Offset(2,8),Offset(3,8),Offset(4,8),Offset(5,8),
    Offset(6,9),Offset(6,10),Offset(6,11),Offset(6,12),Offset(6,13),Offset(6,14),Offset(7,14),Offset(8,14),
    Offset(8,13),Offset(8,12),Offset(8,11),Offset(8,10),Offset(8,9),Offset(9,8),Offset(10,8),Offset(11,8),Offset(12,8),Offset(13,8),Offset(14,8),Offset(14,7),Offset(14,6),Offset(13,6),Offset(12,6),Offset(11,6),Offset(10,6),Offset(9,6),
    Offset(8,5),Offset(8,4),Offset(8,3),Offset(8,2),Offset(8,1),Offset(8,0),Offset(7,0),Offset(6,0),
  ];
  Map<int,Offset> homeCoords={
    52:Offset(7,1),53:Offset(7,2),54:Offset(7,3),55:Offset(7,4),56:Offset(7,5),57:Offset(7,6),
    58:Offset(1,7),59:Offset(2,7),60:Offset(3,7),61:Offset(4,7),62:Offset(5,7),63:Offset(6,7),
    64:Offset(7,13),65:Offset(7,12),66:Offset(7,11),67:Offset(7,10),68:Offset(7,9),69:Offset(7,8),
    70:Offset(13,7),71:Offset(12,7),72:Offset(11,7),73:Offset(10,7),74:Offset(9,7),75:Offset(8,7),
  };

  void roll(){
    if(!canRoll) return;
    setState((){
      dice=math.Random().nextInt(6)+1;
      canRoll=false;
      msg="جبت $dice - حرك ملكك يا ${["الاحمر","الاصفر","الاخضر","الازرق"][turn]}";
    });
    bool can=false;
    for(int p in tokens[turn]){
      if(p==-1&&dice==6) can=true;
      if(p>=0&&p<52) can=true;
      if(p>=52&&p<76) can=true;
    }
    if(!can){
      Future.delayed(Duration(seconds:1),(){
        setState((){
          turn=(turn+1)%4;
          canRoll=true;
          msg="مفيش حركة - دور ${["الاحمر","الاصفر","الاخضر","الازرق"][turn]}";
        });
      });
    }
  }

  void move(int p,int idx){
    if(p!=turn){ setState(()=>msg="مش دورك!"); return; }
    if(canRoll){ setState(()=>msg="ارمي النرد الاول!"); return; }
    int cur=tokens[p][idx];
    if(cur==-1&&dice!=6){ setState(()=>msg="لازم 6 عشان الملك يطلع!"); return; }

    setState((){
      if(cur==-1){
        tokens[p][idx]=start[p];
      }else if(cur>=0&&cur<52){
        int steps=cur+dice;
        int entry = (start[p]+51)%52;
        if(cur<=entry && steps>entry && cur!=entry){
          int homeSteps = steps - entry -1;
          if(homeSteps<6) tokens[p][idx]=homePath[p][homeSteps];
          else tokens[p][idx]=100;
        }else if(cur==entry && steps>51){
          int homeSteps = steps - 52;
          if(homeSteps<6) tokens[p][idx]=homePath[p][homeSteps];
          else tokens[p][idx]=100;
        }else{
          tokens[p][idx]=steps%52;
        }
      }else if(cur>=52 && cur<100){
        int homeIdx = homePath[p].indexOf(cur);
        if(homeIdx+ dice <6) tokens[p][idx]=homePath[p][homeIdx+dice];
        else if(homeIdx+dice==6) tokens[p][idx]=100;
      }

      int newPos=tokens[p][idx];
      if(newPos<52 &&!safe.contains(newPos)){
        for(int op=0;op<4;op++){ if(op==p) continue; for(int ot=0;ot<4;ot++){ if(tokens[op][ot]==newPos){ tokens[op][ot]=-1; msg="اكلته! 🔥"; } } }
      }
      if(tokens[p].every((e)=>e==100)){
        msg="الملك ${["الاحمر","الاصفر","الاخضر","الازرق"][p]} كسب! 👑🏆";
        return;
      }
      if(dice!=6){ turn=(turn+1)%4; }
      canRoll=true;
      if(!msg.contains("اكلته")) msg="دور ملك ${["الاحمر","الاصفر","الاخضر","الازرق"][turn]}";
    });
  }

  Widget king(Color c,int p,int idx,bool small){
    bool isTurn = turn==p &&!canRoll;
    return GestureDetector(
      onTap: ()=>move(p,idx),
      child: Container(
        width: small?30:44, height: small?30:44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [Color(0xFFFFE082), Color(0xFFFFC107), Color(0xFFB8860B)]),
          border: Border.all(color: isTurn? Colors.white : Colors.white70, width: isTurn? 3.5:2),
          boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 5, offset: Offset(0,2))],
        ),
        child: Stack(alignment: Alignment.center, children: [
          Text("♔", style: TextStyle(fontSize: small?16:24, color: Color(0xFF3E2723), fontWeight: FontWeight.bold)),
          Positioned(top: 1, child: Container(width: small?6:9, height: small?6:9, decoration: BoxDecoration(color: c, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 1)))),
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
        decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF0D1B4A), Color(0xFF2A1B6A)])),
        child: SafeArea(child: Column(children: [
          Padding(padding: EdgeInsets.all(10), child: Row(children: [
            Icon(Icons.arrow_back, color: Colors.white), SizedBox(width:10),
            Text("Ludo Royal • 10356", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
            Spacer(),
            Container(padding: EdgeInsets.symmetric(horizontal:8, vertical:4), decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.amber)), child: Text(msg, style: TextStyle(color: Colors.white, fontSize:10))),
          ])),
          Container(
            margin: EdgeInsets.symmetric(horizontal:10),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(color: Color(0xFF2A2A7A).withOpacity(0.5), borderRadius: BorderRadius.circular(16)),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: List.generate(4, (i)=> Column(children: [
              Container(padding: EdgeInsets.all(2), decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: cols[i], width: turn==i?4:1.5)), child: CircleAvatar(radius: 22, backgroundColor: cols[i].withOpacity(0.8), child: Text("♔", style: TextStyle(fontSize:20)))),
              SizedBox(height:3), Text(["احمر","اصفر","اخضر","ازرق"][i], style: TextStyle(color: cols[i], fontSize:10, fontWeight: FontWeight.bold)),
            ]))),
          ),
          SizedBox(height:6),
          Center(child: Container(
            width: size, height: size,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(color: Color(0xFF4E342E), borderRadius: BorderRadius.circular(14), border: Border.all(color: Color(0xFFD4AF37), width: 4)),
            child: Container(
              decoration: BoxDecoration(color: Color(0xFFF5E6C8), border: Border.all(color: Color(0xFFD4AF37), width: 2)),
              child: Stack(children: [
                GridView.count(crossAxisCount:15, physics: NeverScrollableScrollPhysics(), children: List.generate(225, (idx){
                  int r=idx~/15,c=idx%15; Color bg=Color(0xFFFFF8E1);
                  if(r<6&&c<6) bg=red.withOpacity(0.85);
                  else if(r<6&&c>8) bg=green.withOpacity(0.85);
                  else if(r>8&&c<6) bg=yellow.withOpacity(0.85);
                  else if(r>8&&c>8) bg=blue.withOpacity(0.85);
                  else if(r>=6&&r<=8&&c>=6&&c<=8) bg=Color(0xFFFFD54F);
                  else if(r==7&&c>=1&&c<=5) bg=red.withOpacity(0.5);
                  else if(r==7&&c>=9&&c<=13) bg=green.withOpacity(0.5);
                  else if(c==7&&r>=1&&r<=5) bg=yellow.withOpacity(0.5);
                  else if(c==7&&r>=9&&r<=13) bg=yellow.withOpacity(0.5);
                  Widget? ch; int pIdx=path.indexWhere((e)=>e.dx==r&&e.dy==c);
                  if(safe.contains(pIdx)) ch=Icon(Icons.shield, size: cell*0.35, color: Colors.brown);
                  return Container(decoration: BoxDecoration(color: bg, border: Border.all(color: Color(0xFFD4AF37).withOpacity(0.3), width:0.5)), child: Center(child: ch));
                })),
                Positioned(left: cell*0.5, top: cell*0.5, width: cell*5, height: cell*5, child: Container(decoration: BoxDecoration(color: red, border: Border.all(color: Color(0xFFFFD700), width:3), borderRadius: BorderRadius.circular(6)))),
                Positioned(left: cell*9.5, top: cell*0.5, width: cell*5, height: cell*5, child: Container(decoration: BoxDecoration(color: green, border: Border.all(color: Color(0xFFFFD700), width:3), borderRadius: BorderRadius.circular(6)))),
                Positioned(left: cell*0.5, top: cell*9.5, width: cell*5, height: cell*5, child: Container(decoration: BoxDecoration(color: yellow, border: Border.all(color: Color(0xFFFFD700), width:3), borderRadius: BorderRadius.circular(6)))),
                Positioned(left: cell*9.5, top: cell*9.5, width: cell*5, height: cell*5, child: Container(decoration: BoxDecoration(color: blue, border: Border.all(color: Color(0xFFFFD700), width:3), borderRadius: BorderRadius.circular(6)))),
              ...List.generate(4, (p)=>List.generate(4, (t){
                  int bp=tokens[p][t]; double x,y;
                  if(bp==-1){
                    if(p==0){ x=(t%2==0?1:3.2)*cell; y=(t<2?1:3.2)*cell; }
                    else if(p==1){ x=(t%2==0?1:3.2)*cell; y=(t<2?10:12.2)*cell; }
                    else if(p==2){ x=(t%2==0?10:12.2)*cell; y=(t<2?1:3.2)*cell; }
                    else{ x=(t%2==0?10:12.2)*cell; y=(t<2?10:12.2)*cell; }
                  }else if(bp>=100){ x=6.3*cell; y=6.3*cell; }
                  else if(homeCoords.containsKey(bp)){ var pt=homeCoords[bp]!; x=pt.dy*cell; y=pt.dx*cell; }
                  else{ var pt=path[bp%52]; x=pt.dy*cell; y=pt.dx*cell; }
                  return Positioned(left: x+1, top: y+1, child: king(cols[p], p, t, bp!=-1));
                })).expand((e)=>e),
                Positioned(left: 6*cell, top: 6*cell, width: 3*cell, height: 3*cell, child: Container(decoration: BoxDecoration(shape: BoxShape.circle, gradient: RadialGradient(colors: [Color(0xFFFFD700), Color(0xFF8D6E00)]), border: Border.all(color: Colors.white, width:2)), child: Icon(Icons.emoji_events, color: Colors.white, size: 18))),
              ]),
            ),
          )),
          Spacer(),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(color: Color(0xFF12123A), borderRadius: BorderRadius.vertical(top: Radius.circular(20)), border: Border(top: BorderSide(color: Color(0xFFFFD700), width:1.5))),
            child: Row(children: [
              Container(width:56,height:56, decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xFFFFD700), Color(0xFFB8860B)]), borderRadius: BorderRadius.circular(12)), child: Center(child: Text("$dice", style: TextStyle(fontSize:28, fontWeight: FontWeight.bold)))),
              SizedBox(width:10),
              Expanded(child: GestureDetector(onTap: roll, child: Container(height:52, decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xFFFFD700), Color(0xFFFFA000)]), borderRadius: BorderRadius.circular(14)), child: Center(child: Text(canRoll?"ROLL 👑":"انتظر", style: TextStyle(fontWeight: FontWeight.bold, fontSize:18)))))),
              SizedBox(width:8),
              Container(height:52, padding: EdgeInsets.symmetric(horizontal:14), decoration: BoxDecoration(color: Color(0xFFFFC93C), borderRadius: BorderRadius.circular(12)), child: Center(child: Text("SAFE", style: TextStyle(fontWeight: FontWeight.bold)))),
            ]),
          ),
        ])),
      ),
    );
  }
}

// ==================== كيرم كامل بفيزياء ====================
class CarromFull extends StatefulWidget {
  @override State<CarromFull> createState()=>_CarromFullState();
}
class _CarromFullState extends State<CarromFull> {
  List<CarromPiece> pieces=[];
  CarromPiece striker=CarromPiece(Offset(0.5,0.85), Color(0xFFE91E63), false, isStriker:true);
  Offset? dragStart, dragEnd;
  Timer? timer;

  @override void initState(){
    super.initState();
    pieces=[
      CarromPiece(Offset(0.5,0.5), Colors.red, true, isQueen:true),
    ...List.generate(9, (i){
        double ang=i*40*3.14159/180;
        return CarromPiece(Offset(0.5+0.06*math.cos(ang), 0.5+0.06*math.sin(ang)), i%2==0? Colors.white: Colors.black, false);
      }),
    ];
    timer=Timer.periodic(Duration(milliseconds:16), (_)=>updatePhysics());
  }

  void updatePhysics(){
    setState((){
      for(var p in [...pieces, striker]){
        if(p.vel==Offset.zero) continue;
        p.pos+=p.vel*0.016;
        p.vel*=0.985;
        if(p.vel.distance<0.001) p.vel=Offset.zero;
        if(p.pos.dx<0.05||p.pos.dx>0.95){ p.vel=Offset(-p.vel.dx, p.vel.dy); p.pos=Offset(p.pos.dx.clamp(0.05,0.95), p.pos.dy); }
        if(p.pos.dy<0.05||p.pos.dy>0.95){ p.vel=Offset(p.vel.dx, -p.vel.dy); p.pos=Offset(p.pos.dx, p.pos.dy.clamp(0.05,0.95)); }
      }
      for(int i=0;i<pieces.length;i++){
        for(int j=i+1;j<pieces.length;j++){
          double d=(pieces[i].pos-pieces[j].pos).distance;
          if(d<0.055){
            Offset v1=pieces[i].vel, v2=pieces[j].vel;
            pieces[i].vel=v2; pieces[j].vel=v1;
            Offset dir=(pieces[i].pos-pieces[j].pos)/d;
            pieces[i].pos+=dir*0.01; pieces[j].pos-=dir*0.01;
          }
        }
        double ds=(pieces[i].pos-striker.pos).distance;
        if(ds<0.065){ Offset tmp=pieces[i].vel; pieces[i].vel=striker.vel; striker.vel=tmp; }
      }
      pieces.removeWhere((p){
        bool inHole=(p.pos-Offset(0,0)).distance<=0.08||(p.pos-Offset(1,0)).distance<=0.08||(p.pos-Offset(0,1)).distance<=0.08||(p.pos-Offset(1,1)).distance<=0.08;
        return inHole;
      });
    });
  }

  @override void dispose(){ timer?.cancel(); super.dispose(); }

  @override Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color(0xFF2B1A0E),
      appBar: AppBar(backgroundColor: Color(0xFF3E2723), title: Text("Carrom Royal • فيزياء μ=0.15 e=1"), centerTitle:true),
      body: Column(children: [
        Expanded(child: LayoutBuilder(builder: (ctx,cons){
          double size=math.min(cons.maxWidth, cons.maxHeight)*0.92;
          return GestureDetector(
            onPanStart: (d){ dragStart=Offset(d.localPosition.dx/size, d.localPosition.dy/size); },
            onPanUpdate: (d){ dragEnd=Offset(d.localPosition.dx/size, d.localPosition.dy/size); setState((){}); },
            onPanEnd: (_){
              if(dragStart!=null&&dragEnd!=null){
                Offset dir=dragStart!-dragEnd!;
                striker.vel=dir*8;
              }
              dragStart=null; dragEnd=null; setState((){});
            },
            child: Center(child: Container(
              width: size, height: size,
              decoration: BoxDecoration(color: Color(0xFFF5D6A0), border: Border.all(color: Color(0xFFD4AF37), width:10), borderRadius: BorderRadius.circular(8)),
              child: Stack(children: [
              ...[Offset(0,0),Offset(1,0),Offset(0,1),Offset(1,1)].map((p)=>Positioned(left: p.dx*(size-24), top: p.dy*(size-24), child: Container(width:26,height:26, decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle, border: Border.all(color: Color(0xFFD4AF37), width:2))))),
              ...pieces.map((pc)=>Positioned(left: pc.pos.dx*size-14, top: pc.pos.dy*size-14, child: Container(width:28,height:28, decoration: BoxDecoration(color: pc.color, shape: BoxShape.circle, border: Border.all(color: Colors.white, width:1.5)), child: pc.isQueen? Icon(Icons.star, size:12, color: Colors.yellow): null))),
                Positioned(left: striker.pos.dx*size-18, top: striker.pos.dy*size-18, child: Container(width:36,height:36, decoration: BoxDecoration(color: striker.color, shape: BoxShape.circle, border: Border.all(color: Colors.white, width:3)), child: Icon(Icons.adjust, color: Colors.white, size:18))),
                Positioned(bottom:6, left:0, right:0, child: Center(child: Container(padding: EdgeInsets.symmetric(horizontal:10, vertical:4), decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(10)), child: Text("اسحب وسيب - متبقي ${pieces.length}", style: TextStyle(color: Colors.white, fontSize:11))))),
              ]),
            )),
          );
        })),
      ]),
    );
  }
}

class CarromPiece{
  Offset pos; Color color; bool isWhite; bool isQueen=false; bool isStriker=false; Offset vel=Offset.zero;
  CarromPiece(this.pos,this.color,this.isWhite,{this.isQueen=false,this.isStriker=false});
}
