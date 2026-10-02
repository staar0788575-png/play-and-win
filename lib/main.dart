import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';

void main() => runApp(MaterialApp(home: GameHub(), debugShowCheckedModeBanner: false));

class GameHub extends StatefulWidget {
  @override State<GameHub> createState() => _GameHubState();
}
class _GameHubState extends State<GameHub> {
  int tab=0;
  @override Widget build(BuildContext context){
    return Scaffold(
      body: tab==0? LudoRoyalFull(): CarromProLikeImage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: tab, onTap: (i){ setState(()=>tab=i); },
        backgroundColor: Color(0xFF0A1931), selectedItemColor: Color(0xFFFFD700), unselectedItemColor: Colors.white54,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.workspace_premium), label: "لودو ملوكي"),
          BottomNavigationBarItem(icon: Icon(Icons.circle), label: "كيرم 4 لاعبين"),
        ],
      ),
    );
  }
}

class LudoRoyalFull extends StatefulWidget { @override State<LudoRoyalFull> createState()=>_LudoRoyalFullState(); }
class _LudoRoyalFullState extends State<LudoRoyalFull>{
  int dice=6; int turn=0; bool canRoll=true; String msg="جبت 6";
  List<List<int>> tokens=[[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1]];
  List<int> start=[0,39,13,26]; List<int> safe=[0,8,13,21,26,34,39,47];
  List<List<int>> homePath=[[52,53,54,55,56,57],[58,59,60,61,62,63],[64,65,66,67,68,69],[70,71,72,73,74,75]];
  List<String> gameChat=["P3: عاش 💪","Me: السلام عليكم","Me: عاش","P1: يلا نلعب 👑"];
  TextEditingController chatCtrl=TextEditingController();
  List<Offset> path=[Offset(6,1),Offset(6,2),Offset(6,3),Offset(6,4),Offset(6,5),Offset(5,6),Offset(4,6),Offset(3,6),Offset(2,6),Offset(1,6),Offset(0,6),Offset(0,7),Offset(0,8),Offset(1,8),Offset(2,8),Offset(3,8),Offset(4,8),Offset(5,8),Offset(6,9),Offset(6,10),Offset(6,11),Offset(6,12),Offset(6,13),Offset(6,14),Offset(7,14),Offset(8,14),Offset(8,13),Offset(8,12),Offset(8,11),Offset(8,10),Offset(8,9),Offset(9,8),Offset(10,8),Offset(11,8),Offset(12,8),Offset(13,8),Offset(14,8),Offset(14,7),Offset(14,6),Offset(13,6),Offset(12,6),Offset(11,6),Offset(10,6),Offset(9,6),Offset(8,5),Offset(8,4),Offset(8,3),Offset(8,2),Offset(8,1),Offset(8,0),Offset(7,0),Offset(6,0)];
  Map<int,Offset> homeC={52:Offset(7,1),53:Offset(7,2),54:Offset(7,3),55:Offset(7,4),56:Offset(7,5),57:Offset(7,6),58:Offset(13,7),59:Offset(12,7),60:Offset(11,7),61:Offset(10,7),62:Offset(9,7),63:Offset(8,7),64:Offset(1,7),65:Offset(2,7),66:Offset(3,7),67:Offset(4,7),68:Offset(5,7),69:Offset(6,7),70:Offset(7,13),71:Offset(7,12),72:Offset(7,11),73:Offset(7,10),74:Offset(7,9),75:Offset(7,8)};
  void roll(){ if(!canRoll) return; setState((){ dice=math.Random().nextInt(6)+1; canRoll=false; msg="جبت $dice"; }); bool can=false; for(int t in tokens[turn]){ if(t==-1&&dice==6) can=true; if(t>=0) can=true; } if(!can) Future.delayed(Duration(milliseconds:800),(){ if(mounted) setState((){ turn=(turn+1)%4; canRoll=true; }); }); }
  void move(int p,int idx){ if(p!=turn||canRoll) return; int cur=tokens[p][idx]; if(cur==-1&&dice!=6) return; setState((){ if(cur==-1) tokens[p][idx]=start[p]; else if(cur>=0&&cur<52){ int entry=(start[p]+51)%52; int next=cur+dice; if(cur<=entry&&next>entry){ int h=next-entry-1; if(h<6) tokens[p][idx]=homePath[p][h]; else if(h==6) tokens[p][idx]=100; else tokens[p][idx]=next%52; } else tokens[p][idx]=next%52; } else if(cur>=52){ int hi=homePath[p].indexOf(cur); if(hi!=-1){ if(hi+dice<6) tokens[p][idx]=homePath[p][hi+dice]; else if(hi+dice==6) tokens[p][idx]=100; } } if(dice!=6) turn=(turn+1)%4; canRoll=true; }); }
  @override Widget build(BuildContext context){
    Color red=Color(0xFFE53935), yellow=Color(0xFFFBC02D), green=Color(0xFF43A047), blue=Color(0xFF1E88E5); List<Color> cols=[red,yellow,green,blue]; double boardSize=MediaQuery.of(context).size.width-8;
    return Scaffold(backgroundColor: Color(0xFF0D1B4A), body: SafeArea(child: Column(children: [
      Container(margin: EdgeInsets.only(top:8), padding: EdgeInsets.symmetric(horizontal:18, vertical:8), decoration: BoxDecoration(border: Border.all(color: Colors.amber), borderRadius: BorderRadius.circular(20)), child: Text(msg, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
      Container(margin: EdgeInsets.all(8), padding: EdgeInsets.symmetric(horizontal:14, vertical:10), decoration: BoxDecoration(color: Color(0xFF2A3A8C), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white24)), child: Row(children: [Icon(Icons.visibility, color: Colors.amber, size:18), SizedBox(width:8), Text("غرفة انتظار الأصدقاء - يشاهدون 👀", style: TextStyle(color: Colors.white, fontSize:12, fontWeight: FontWeight.bold)), Spacer(), Icon(Icons.remove_red_eye, color: Colors.white54, size:16), Text(" 3")])),
      Expanded(child: Center(child: Container(width: boardSize, height: boardSize, padding: EdgeInsets.all(4), decoration: BoxDecoration(border: Border.all(color: Color(0xFFD4AF37), width:4), color: Color(0xFF3E2723)), child: LayoutBuilder(builder: (c,cons){ double s=cons.maxWidth; double ce=s/15; return Stack(children: [
        GridView.count(crossAxisCount:15, physics: NeverScrollableScrollPhysics(), padding: EdgeInsets.zero, children: List.generate(225, (i){ int r=i~/15, co=i%15; Color bg=Color(0xFFFFF8E1); if(r<6&&co<6) bg=red; else if(r<6&&co>8) bg=green; else if(r>8&&co<6) bg=yellow; else if(r>8&&co>8) bg=blue; else if(r==7&&co>=1&&co<=5) bg=red.withOpacity(0.85); else if(r==7&&co>=9&&co<=13) bg=green.withOpacity(0.65); else if(co==7&&r>=1&&r<=5) bg=yellow.withOpacity(0.65); else if(co==7&&r>=9&&r<=13) bg=blue.withOpacity(0.65); else if(r>=6&&r<=8&&co>=6&&co<=8) bg=Color(0xFFFFD54F); Widget? child; int pIdx=path.indexWhere((e)=>e.dx==r&&e.dy==co); if(safe.contains(pIdx)) child=Text("★", style: TextStyle(fontSize: ce*0.50, color: Colors.black87, fontWeight: FontWeight.bold)); return Container(decoration: BoxDecoration(color: bg, border: Border.all(color: Colors.black12, width:0.3)), child: Center(child: child)); })),
     ...List.generate(4, (p)=>List.generate(4, (t){ int bp=tokens[p][t]; double cx,cy; double sz=ce*0.78; if(bp==-1){ cx=(t%2==0?1.5:3.5)*ce; cy=(t<2?1.5:3.5)*ce; if(p==1) cy=(t<2?10.5:12.5)*ce; if(p==2) cx=(t%2==0?10.5:12.5)*ce; if(p==3){ cx=(t%2==0?10.5:12.5)*ce; cy=(t<2?10.5:12.5)*ce; } } else if(bp>=100){ cx=7.5*ce; cy=7.5*ce; } else if(homeC.containsKey(bp)){ var pt=homeC[bp]!; cx=pt.dy*ce+ce/2; cy=pt.dx*ce+ce/2; } else{ var pt=path[bp%52]; cx=pt.dy*ce+ce/2; cy=pt.dx*ce+ce/2; } return Positioned(left: cx-sz/2, top: cy-sz/2, child: GestureDetector(onTap: ()=>move(p,t), child: Container(width: sz, height: sz, decoration: BoxDecoration(shape: BoxShape.circle, color: cols[p], border: Border.all(color: Colors.white, width:2)), child: Center(child: Text("♔", style: TextStyle(color: Colors.white, fontSize: sz*0.6)))))); })).expand((e)=>e),
        if(canRoll) Center(child: GestureDetector(onTap: roll, child: Container(width: 106, height: 106, decoration: BoxDecoration(shape: BoxShape.circle, gradient: RadialGradient(colors: [Color(0xFFFFD700), Color(0xFFFF6F00)]), border: Border.all(color: Colors.white, width:3)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text("$dice", style: TextStyle(fontSize:38, fontWeight: FontWeight.bold, color: Colors.black)), Text("ROLL", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))])))),
      ]); }))),
      Container(padding: EdgeInsets.all(10), color: Color(0xFF0A0A2A), child: Column(children: [
        Container(height: 95, width: double.infinity, child: SingleChildScrollView(child: Wrap(spacing:8, runSpacing:8, children: gameChat.map((m)=> Container(padding: EdgeInsets.symmetric(horizontal:14, vertical:9), decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(16)), child: Text(m, style: TextStyle(color: Colors.white, fontSize:12)))).toList()))),
        SizedBox(height:10),
        Row(children: [
          Container(width:46,height:46, decoration: BoxDecoration(color: Colors.white24, shape: BoxShape.circle), child: Icon(Icons.mic, color: Colors.white)),
          SizedBox(width:10),
          Expanded(child: Container(height:46, decoration: BoxDecoration(color: Color(0xFF2A2A4A), borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.white24)), child: Row(children: [SizedBox(width:16), Expanded(child: TextField(controller: chatCtrl, style: TextStyle(color: Colors.white), decoration: InputDecoration(hintText: "شات...", hintStyle: TextStyle(color: Colors.white38), border: InputBorder.none)))]))),
          SizedBox(width:10),
          GestureDetector(onTap: roll, child: Container(width:48,height:48, decoration: BoxDecoration(color: Color(0xFFFFD700), shape: BoxShape.circle), child: Icon(Icons.casino, color: Colors.black))),
        ]),
      ]),
    ])));
  }
}

class CarromProLikeImage extends StatefulWidget { @override State<CarromProLikeImage> createState()=>_CarromProState(); }
class _CarromProState extends State<CarromProLikeImage> {
  List<CarromPiece> pieces=[]; CarromPiece striker=CarromPiece(Offset(0.5,0.82), Color(0xFFFF1744), false, isStriker:true);
  Offset? dragStart, dragEnd; double power=0; Timer? timer;
  @override void initState(){ super.initState(); pieces=[CarromPiece(Offset(0.5,0.5), Color(0xFF000000), false, isQueen:true), CarromPiece(Offset(0.5,0.40), Color(0xFFFFFDE7), true), CarromPiece(Offset(0.43,0.43), Color(0xFFFFF8E1), true), CarromPiece(Offset(0.57,0.43), Color(0xFFFFFDE7), true), CarromPiece(Offset(0.38,0.50), Color(0xFFFFF8E1), true), CarromPiece(Offset(0.62,0.50), Color(0xFFFFFDE7), true), CarromPiece(Offset(0.43,0.57), Color(0xFFFFF8E1), true), CarromPiece(Offset(0.57,0.57), Color(0xFFFFFDE7), true), CarromPiece(Offset(0.5,0.60), Color(0xFF3E2723), false), CarromPiece(Offset(0.38,0.43), Color(0xFF212121), false), CarromPiece(Offset(0.62,0.43), Color(0xFF3E2723), false), CarromPiece(Offset(0.33,0.50), Color(0xFF121212), false), CarromPiece(Offset(0.67,0.50), Color(0xFF3E2723), false), CarromPiece(Offset(0.38,0.57), Color(0xFF121212), false), CarromPiece(Offset(0.62,0.57), Color(0xFF000000), false)]; timer=Timer.periodic(Duration(milliseconds:16), (_)=>updatePhysics()); }
  void updatePhysics(){ if(!mounted) return; setState((){ for(var p in [...pieces, striker]){ if(p.vel==Offset.zero) continue; p.pos+=p.vel*0.016; p.vel*=0.985; if(p.vel.distance<0.002) p.vel=Offset.zero; if(p.pos.dx<0.07||p.pos.dx>0.93){ p.vel=Offset(-p.vel.dx*0.85, p.vel.dy); p.pos=Offset(p.pos.dx.clamp(0.07,0.93), p.pos.dy); } if(p.pos.dy<0.07||p.pos.dy>0.93){ p.vel=Offset(p.vel.dx, -p.vel.dy*0.85); p.pos=Offset(p.pos.dx, p.pos.dy.clamp(0.07,0.93)); } } for(int i=0;i<pieces.length;i++){ for(int j=i+1;j<pieces.length;j++){ Offset d=pieces[i].pos-pieces[j].pos; double dist=d.distance; if(dist<0.064&&dist>0.001){ Offset n=d/dist; double dv=(pieces[i].vel.dx*n.dx+pieces[i].vel.dy*n.dy)-(pieces[j].vel.dx*n.dx+pieces[j].vel.dy*n.dy); if(dv<0){ pieces[i].vel-=n*dv*0.95; pieces[j].vel+=n*dv*0.95; } } } Offset ds=pieces[i].pos-striker.pos; double dist=ds.distance; if(dist<0.08&&dist>0.001){ Offset n=ds/dist; double dv=(pieces[i].vel.dx*n.dx+pieces[i].vel.dy*n.dy)-(striker.vel.dx*n.dx+striker.vel.dy*n.dy); if(dv<0){ pieces[i].vel-=n*dv*1.1; striker.vel+=n*dv*1.1; } } } pieces.removeWhere((p)=> (p.pos-Offset(0.08,0.08)).distance<0.06||(p.pos-Offset(0.92,0.08)).distance<0.06||(p.pos-Offset(0.08,0.92)).distance<0.06||(p.pos-Offset(0.92,0.92)).distance<0.06)); }); }
  @override void dispose(){ timer?.cancel(); super.dispose(); }
  Widget playerAvatar(String name, bool me){
    return Column(children: [
      Stack(clipBehavior: Clip.none, children: [
        Container(width: 54, height: 54, decoration: BoxDecoration(shape: BoxShape.circle, color: me? Color(0xFF7C4DFF): Colors.white, border: Border.all(color: Colors.white, width:2)), child: Center(child: me? Text("I", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize:24)): Icon(Icons.person, color: Colors.grey, size:28))),
        Positioned(top:-8, left:-6, child: Container(padding: EdgeInsets.symmetric(horizontal:6, vertical:2), decoration: BoxDecoration(color: Color(0xFFFFEB3B), borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.black, width:1)), child: Text("0", style: TextStyle(fontWeight: FontWeight.bold, fontSize:12)))),
      ]),
      SizedBox(height:4),
      Text(name, style: TextStyle(color: Colors.white70, fontSize:11)),
    ]);
  }
  @override Widget build(BuildContext context){
    return Scaffold(body: Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF3A1A7A), Color(0xFF8B2E6E), Color(0xFF1A0A2E)])), child: SafeArea(child: Column(children: [
      Padding(padding: EdgeInsets.symmetric(horizontal:8, vertical:4), child: Row(children: [
        Icon(Icons.settings_outlined, color: Colors.white, size:28), SizedBox(width:12), Icon(Icons.ios_share, color: Colors.white, size:24), Spacer(),
        Container(padding: EdgeInsets.symmetric(horizontal:10, vertical:4), decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(20)), child: Row(children: [Text("46ms", style: TextStyle(color: Colors.white70, fontSize:10)), SizedBox(width:6), Icon(Icons.wifi, color: Colors.greenAccent, size:16)])),
        SizedBox(width:8),
        Row(children: [Text("0", style: TextStyle(color: Colors.white, fontSize:16)), SizedBox(width:4), Icon(Icons.visibility, color: Colors.white, size:18)]),
        Icon(Icons.arrow_forward_ios, color: Colors.white, size:20),
      ])),
      Expanded(child: Center(child: LayoutBuilder(builder: (ctx,cons){ double size=math.min(cons.maxWidth-12, cons.maxHeight*0.75); return GestureDetector(onPanStart: (d){ dragStart=Offset(d.localPosition.dx/size, d.localPosition.dy/size); }, onPanUpdate: (d){ dragEnd=Offset(d.localPosition.dx/size, d.localPosition.dy/size); if(dragStart!=null&&dragEnd!=null) power=(dragEnd! - dragStart!).distance.clamp(0,0.35); setState((){}); }, onPanEnd: (_){ if(dragStart!=null&&dragEnd!=null){ Offset dir=dragEnd!-dragStart!; double pwr=dir.distance*20; if(pwr>0.5) striker.vel=dir.normalized()*pwr.clamp(0,10); } dragStart=null; dragEnd=null; power=0; setState((){}); }, child: Container(width: size, height: size, decoration: BoxDecoration(color: Color(0xFFDEB887), borderRadius: BorderRadius.circular(22), border: Border.all(color: Color(0xFFFFD700), width:4)), child: Stack(children: [
        Positioned(left:6, top:6, child: Container(width: size*0.11, height: size*0.11, decoration: BoxDecoration(color: Color(0xFF1A0A0A), shape: BoxShape.circle, border: Border.all(color: Color(0xFFFFD700), width:3)))),
        Positioned(right:6, top:6, child: Container(width: size*0.11, height: size*0.11, decoration: BoxDecoration(color: Color(0xFF1A0A0A), shape: BoxShape.circle, border: Border.all(color: Color(0xFFFFD700), width:3)))),
        Positioned(left:6, bottom:6, child: Container(width: size*0.11, height: size*0.11, decoration: BoxDecoration(color: Color(0xFF1A0A0A), shape: BoxShape.circle, border: Border.all(color: Color(0xFFFFD700), width:3)))),
        Positioned(right:6, bottom:6, child: Container(width: size*0.11, height: size*0.11, decoration: BoxDecoration(color: Color(0xFF1A0A0A), shape: BoxShape.circle, border: Border.all(color: Color(0xFFFFD700), width:3)))),
        CustomPaint(size: Size(size,size), painter: CarromImagePainter()),
        Center(child: Opacity(opacity:0.18, child: Icon(Icons.local_florist, size: size*0.32, color: Color(0xFF8D6E63)))),
   ...pieces.map((pc)=>Positioned(left: pc.pos.dx*size-16, top: pc.pos.dy*size-16, child: Container(width:32,height:32, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: pc.isQueen?2.5:1.5), gradient: pc.isQueen? RadialGradient(colors: [Color(0xFF424242), Colors.black]): pc.isWhite? RadialGradient(colors: [Colors.white, Color(0xFFFFE082)]): RadialGradient(colors: [Color(0xFF5D4037), Colors.black])), child: pc.isQueen? Center(child: Text("★", style: TextStyle(color: Colors.yellow, fontSize:12))): null)))),
        Positioned(left: striker.pos.dx*size-22, top: striker.pos.dy*size-22, child: Container(width:44,height:44, decoration: BoxDecoration(shape: BoxShape.circle, gradient: RadialGradient(colors: [Color(0xFFFF4081), Color(0xFF880E4F)]), border: Border.all(color: Colors.white, width:3)), child: Center(child: Container(width:16,height:16, decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle))))),
        if(dragStart!=null&&dragEnd!=null) CustomPaint(size: Size(size,size), painter: AimPainterPro(dragStart!*size, dragEnd!*size, power)),
        Positioned(bottom: size*0.02, left: size*0.22, right: size*0.22, child: Container(padding: EdgeInsets.symmetric(vertical:8), decoration: BoxDecoration(color: Color(0xFF263238).withOpacity(0.9), borderRadius: BorderRadius.circular(12)), child: Center(child: Text("حرك المضرب لتحديد الهدف", style: TextStyle(color: Colors.white70, fontSize:11))))),
      ]))); }))),
      Container(width: double.infinity, padding: EdgeInsets.symmetric(vertical:6), child: Column(children: [
        Container(padding: EdgeInsets.symmetric(horizontal:18, vertical:6), decoration: BoxDecoration(color: Color(0xFF3E2723).withOpacity(0.9), borderRadius: BorderRadius.circular(20)), child: Text("جارٍ إعادة الاتصال بالشبكة...", style: TextStyle(color: Colors.white, fontSize:13, fontWeight: FontWeight.bold))),
        SizedBox(height:10),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [playerAvatar("منخ..", false), playerAvatar("الـهـ...", false), playerAvatar("Čřáž..", false), playerAvatar("ابن الاكابر", true)]),
        SizedBox(height:10),
        Padding(padding: EdgeInsets.symmetric(horizontal:12), child: Column(children: [
          Align(alignment: Alignment.centerRight, child: Container(padding: EdgeInsets.symmetric(horizontal:16, vertical:10), decoration: BoxDecoration(color: Color(0xFF2E1A3A).withOpacity(0.9), borderRadius: BorderRadius.circular(16)), child: Text("مرحباً بالجميع، سأنضم إليكم!", style: TextStyle(color: Colors.white, fontSize:13)))),
          SizedBox(height:8),
          Container(width: double.infinity, padding: EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), borderRadius: BorderRadius.circular(12)), child: Text("عبرت سيارة گـ ـرم VIP", style: TextStyle(color: Color(0xFF4DB6AC), fontSize:12), textAlign: TextAlign.center)),
        ])),
        SizedBox(height:12),
        Padding(padding: EdgeInsets.symmetric(horizontal:10, vertical:4), child: Row(children: [
          Container(width:36,height:36, decoration: BoxDecoration(color: Color(0xFF26A69A), shape: BoxShape.circle), child: Icon(Icons.more_horiz, color: Colors.white, size:20)),
          SizedBox(width:8),
          Container(width:36,height:36, decoration: BoxDecoration(color: Color(0xFFFF8F00), borderRadius: BorderRadius.circular(8)), child: Icon(Icons.card_giftcard, color: Colors.white)),
          SizedBox(width:8),
          Expanded(child: Container(height:38, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(20)), child: Center(child: Text("قل شيئاً", style: TextStyle(color: Colors.white60))))),
          SizedBox(width:8),
          Container(width:36,height:36, decoration: BoxDecoration(color: Colors.white24, shape: BoxShape.circle), child: Icon(Icons.emoji_emotions_outlined, color: Colors.white, size:20)),
          SizedBox(width:6),
          Container(width:36,height:36, decoration: BoxDecoration(color: Colors.white24, shape: BoxShape.circle), child: Icon(Icons.mic_off, color: Colors.white, size:20)),
          SizedBox(width:6),
          Container(width:36,height:36, decoration: BoxDecoration(color: Colors.white24, shape: BoxShape.circle), child: Icon(Icons.volume_up, color: Colors.white, size:20)),
        ])),
      ])),
    ]))));
  }
}

class CarromImagePainter extends CustomPainter{
  @override void paint(Canvas canvas, Size size){
    var p=Paint()..color=Color(0xFF8D6E63).withOpacity(0.7)..style=PaintingStyle.stroke..strokeWidth=1.5;
    double inset=size.width*0.14;
    RRect r=RRect.fromRectAndRadius(Rect.fromLTWH(inset, inset, size.width-inset*2, size.height-inset*2), Radius.circular(32));
    canvas.drawRRect(r, p);
    var yellow=Paint()..color=Color(0xFFFFD54F)..style=PaintingStyle.fill;
    var border=Paint()..color=Color(0xFF8D6E63)..style=PaintingStyle.stroke..strokeWidth=2;
    double rad=size.width*0.05;
    List<Offset> pts=[
      Offset(inset+18, inset+18), Offset(size.width-inset-18, inset+18),
      Offset(inset+18, size.height/2-20), Offset(size.width-inset-18, size.height/2-20),
      Offset(inset+18, size.height/2+20), Offset(size.width-inset-18, size.height/2+20),
      Offset(inset+18, size.height-inset-18), Offset(size.width-inset-18, size.height-inset-18),
    ];
    for(var pt in pts){ canvas.drawCircle(pt, rad, yellow); canvas.drawCircle(pt, rad, border); }
  }
  @override bool shouldRepaint(covariant CustomPainter old)=>false;
}
class CarromPiece{ Offset pos; Color color; bool isWhite; bool isQueen=false; bool isStriker=false; Offset vel=Offset.zero; CarromPiece(this.pos,this.color,this.isWhite,{this.isQueen=false,this.isStriker=false}); }
extension OffsetExt on Offset{ Offset normalized(){ double d=distance; if(d==0) return Offset.zero; return this/d; } }
class AimPainterPro extends CustomPainter{ Offset from,to; double power; AimPainterPro(this.from,this.to,this.power); @override void paint(Canvas c, Size s){ var p=Paint()..color=Colors.white.withOpacity(0.9)..strokeWidth=3..style=PaintingStyle.stroke..strokeCap=StrokeCap.round; c.drawLine(from, to, p); Offset dir=to-from; double len=dir.distance; if(len>0){ Offset n=dir/len; c.drawLine(to, to+n*power*300, Paint()..color=Colors.yellowAccent..strokeWidth=4..style=PaintingStyle.stroke); } } @override bool shouldRepaint(covariant CustomPainter o)=>true; }
