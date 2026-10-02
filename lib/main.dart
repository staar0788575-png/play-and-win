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

// ==================== لودو ملوكي - مش معلق + الطيارة في نص المربع ====================
class LudoRoyalFull extends StatefulWidget {
  @override State<LudoRoyalFull> createState() => _LudoRoyalFullState();
}
class _LudoRoyalFullState extends State<LudoRoyalFull> {
  int dice=6;
  int turn=0;
  bool canRoll=true;
  String msg="جبت 6 - دوس على الطيارة";
  List<List<int>> tokens=[[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1]];
  List<int> start=[0,39,13,26];
  List<List<int>> homePath=[[52,53,54,55,56,57],[58,59,60,61,62,63],[64,65,66,67,68,69],[70,71,72,73,74,75]];
  int chatTab=0;
  bool showSpec=false;
  List<String> gameChat=["P3: عاش 💪","Me: السلام عليكم ورحمة الله وبركاته","Me: عاش","P1: يلا نلعب 👑 يلا بينا"];
  List<String> friendsChat=["Ahmed: فينكم؟","Sara: تعالو لودو 😎","Leo: انا داخل"];
  TextEditingController chatCtrl=TextEditingController();
  List<Map<String,dynamic>> specs=[{"name":"Mona","color":Color(0xFFE91E63)},{"name":"Ali","color":Color(0xFF2196F3)},{"name":"Khaled","color":Color(0xFF4CAF50)}];

  List<Offset> path=[
    Offset(6,1),Offset(6,2),Offset(6,3),Offset(6,4),Offset(6,5),
    Offset(5,6),Offset(4,6),Offset(3,6),Offset(2,6),Offset(1,6),Offset(0,6),Offset(0,7),Offset(0,8),Offset(1,8),Offset(2,8),Offset(3,8),Offset(4,8),Offset(5,8),
    Offset(6,9),Offset(6,10),Offset(6,11),Offset(6,12),Offset(6,13),Offset(6,14),Offset(7,14),Offset(8,14),
    Offset(8,13),Offset(8,12),Offset(8,11),Offset(8,10),Offset(8,9),Offset(9,8),Offset(10,8),Offset(11,8),Offset(12,8),Offset(13,8),Offset(14,8),Offset(14,7),Offset(14,6),Offset(13,6),Offset(12,6),Offset(11,6),Offset(10,6),Offset(9,6),
    Offset(8,5),Offset(8,4),Offset(8,3),Offset(8,2),Offset(8,1),Offset(8,0),Offset(7,0),Offset(6,0),
  ];
  Map<int,Offset> homeC={
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
      msg="جبت $dice - حرك طيارة ${["الحمرا","الصفرا","الخضرا","الزرقا"][turn]}";
    });
    bool canMove=false;
    for(int t in tokens[turn]){
      if(t==-1 && dice==6) canMove=true;
      if(t>=0) canMove=true;
    }
    if(!canMove){
      Future.delayed(Duration(milliseconds:800),(){
        if(mounted) setState((){
          turn=(turn+1)%4;
          canRoll=true;
          msg="دور ${["الاحمر","الاصفر","الاخضر","الازرق"][turn]}";
        });
      });
    }
  }

  void move(int p,int idx){
    if(p!=turn || canRoll) return;
    int cur=tokens[p][idx];
    if(cur==-1 && dice!=6) return;
    setState((){
      if(cur==-1){
        tokens[p][idx]=start[p];
      }else if(cur>=0 && cur<52){
        int entry=(start[p]+51)%52;
        int next=cur+dice;
        if(cur<=entry && next>entry){
          int h=next-entry-1;
          if(h<6) tokens[p][idx]=homePath[p][h];
          else if(h==6) tokens[p][idx]=100;
          else tokens[p][idx]=next%52;
        }else{
          tokens[p][idx]=next%52;
        }
      }else if(cur>=52){
        int hi=homePath[p].indexOf(cur);
        if(hi!=-1){
          if(hi+dice<6) tokens[p][idx]=homePath[p][hi+dice];
          else if(hi+dice==6) tokens[p][idx]=100;
        }
      }
      if(dice!=6) turn=(turn+1)%4;
      canRoll=true;
      msg="دور ${["الاحمر","الاصفر","الاخضر","الازرق"][turn]}";
    });
  }

  @override Widget build(BuildContext context){
    Color red=Color(0xFFE53935), yellow=Color(0xFFFBC02D), green=Color(0xFF43A047), blue=Color(0xFF1E88E5);
    List<Color> cols=[red,yellow,green,blue];
    double boardSize=MediaQuery.of(context).size.width-8;
    return Scaffold(
      backgroundColor: Color(0xFF0D1B4A),
      body: SafeArea(child: Column(children: [
        Container(margin: EdgeInsets.only(top:8), padding: EdgeInsets.symmetric(horizontal:18, vertical:8), decoration: BoxDecoration(border: Border.all(color: Colors.amber, width:1.5), borderRadius: BorderRadius.circular(20)), child: Text(msg, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize:13))),
        GestureDetector(
          onTap: ()=> setState(()=> showSpec=!showSpec),
          child: Container(
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.symmetric(horizontal:14, vertical:10),
            decoration: BoxDecoration(color: Color(0xFF2A3A8C), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white24)),
            child: Column(children: [
              Row(children: [
                Icon(Icons.visibility, color: Colors.amber, size:18),
                SizedBox(width:8),
                Text("غرفة انتظار الأصدقاء - يشاهدون 👀", style: TextStyle(color: Colors.white, fontSize:12, fontWeight: FontWeight.bold)),
                Spacer(),
                Icon(Icons.remove_red_eye, color: Colors.white54, size:16),
                SizedBox(width:6),
                Text("${specs.length}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Icon(showSpec? Icons.expand_less: Icons.expand_more, color: Colors.white70),
              ]),
              if(showSpec) Padding(padding: EdgeInsets.only(top:10), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: specs.map((s)=> Padding(padding: EdgeInsets.symmetric(horizontal:8), child: Column(children: [CircleAvatar(radius:22, backgroundColor: s["color"] as Color, child: Text((s["name"] as String)[0], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))), SizedBox(height:4), Text(s["name"] as String, style: TextStyle(color: Colors.white70, fontSize:10))]))).toList())),
            ]),
          ),
        ),
        Expanded(child: Center(child: Container(
          width: boardSize, height: boardSize,
          decoration: BoxDecoration(border: Border.all(color: Color(0xFFD4AF37), width:4), color: Color(0xFF3E2723)),
          padding: EdgeInsets.all(4),
          child: LayoutBuilder(builder: (c,cons){
            double s = cons.maxWidth;
            double ce = s/15;
            return Stack(children: [
              GridView.count(crossAxisCount:15, physics: NeverScrollableScrollPhysics(), padding: EdgeInsets.zero, children: List.generate(225, (i){
                int r=i~/15, co=i%15; Color bg=Color(0xFFFFF8E1);
                if(r<6&&co<6) bg=red;
                else if(r<6&&co>8) bg=green;
                else if(r>8&&co<6) bg=yellow;
                else if(r>8&&co>8) bg=blue;
                else if(r==7&&co>=1&&co<=5) bg=red.withOpacity(0.8);
                else if(r==7&&co>=9&&co<=13) bg=green.withOpacity(0.6);
                else if(co==7&&r>=1&&r<=5) bg=yellow.withOpacity(0.6);
                else if(co==7&&r>=9&&r<=13) bg=blue.withOpacity(0.6);
                else if(r>=6&&r<=8&&co>=6&&co<=8) bg=Color(0xFFFFD54F);
                return Container(decoration: BoxDecoration(color: bg, border: Border.all(color: Colors.black12, width:0.3)));
              })),
            ...List.generate(4, (p)=>List.generate(4, (t){
                int bp=tokens[p][t];
                double cx,cy;
                double sz = ce*0.80;
                if(bp==-1){
                  cx=(t%2==0?1.5:3.5)*ce;
                  cy=(t<2?1.5:3.5)*ce;
                  if(p==1) cy=(t<2?10.5:12.5)*ce;
                  if(p==2) cx=(t%2==0?10.5:12.5)*ce;
                  if(p==3){ cx=(t%2==0?10.5:12.5)*ce; cy=(t<2?10.5:12.5)*ce; }
                }else if(bp>=100){ cx=7.5*ce; cy=7.5*ce; }
                else if(homeC.containsKey(bp)){ var pt=homeC[bp]!; cx=pt.dy*ce + ce/2; cy=pt.dx*ce + ce/2; }
                else{ var pt=path[bp%52]; cx=pt.dy*ce + ce/2; cy=pt.dx*ce + ce/2; }
                return Positioned(
                  left: cx - sz/2,
                  top: cy - sz/2,
                  child: GestureDetector(
                    onTap: ()=>move(p,t),
                    child: Container(width: sz, height: sz, decoration: BoxDecoration(shape: BoxShape.circle, color: cols[p], border: Border.all(color: turn==p &&!canRoll? Colors.white: Colors.white70, width: turn==p &&!canRoll?3:2)), child: Center(child: Text("♔", style: TextStyle(color: Colors.white, fontSize: sz*0.6, fontWeight: FontWeight.bold)))),
                  ),
                );
              })).expand((e)=>e),
              if(canRoll) Center(child: GestureDetector(onTap: roll, child: Container(width: 106, height: 106, decoration: BoxDecoration(shape: BoxShape.circle, gradient: RadialGradient(colors: [Color(0xFFFFD700), Color(0xFFFF6F00)]), border: Border.all(color: Colors.white, width:3)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text("$dice", style: TextStyle(fontSize:38, fontWeight: FontWeight.bold, color: Colors.black)), Text("ROLL", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))])))),
            ]);
          }),
        ))),
        Container(
          padding: EdgeInsets.all(10),
          color: Color(0xFF0A0A2A),
          child: Column(children: [
            Row(children: [
              GestureDetector(onTap: ()=>setState(()=>chatTab=0), child: Container(padding: EdgeInsets.symmetric(horizontal:18, vertical:8), decoration: BoxDecoration(color: chatTab==0? Color(0xFFFFD700): Color(0xFF2A2A4A), borderRadius: BorderRadius.circular(20)), child: Text("شات اللاعبين", style: TextStyle(fontSize:12, color: chatTab==0? Colors.black: Colors.white70, fontWeight: FontWeight.bold)))),
              SizedBox(width:10),
              GestureDetector(onTap: ()=>setState(()=>chatTab=1), child: Container(padding: EdgeInsets.symmetric(horizontal:18, vertical:8), decoration: BoxDecoration(color: chatTab==1? Color(0xFF3DD4C0): Color(0xFF2A2A4A), borderRadius: BorderRadius.circular(20)), child: Text("شات الأصدقاء الخاص", style: TextStyle(fontSize:12, color: chatTab==1? Colors.black: Colors.white70)))),
            ]),
            SizedBox(height:10),
            Container(height: 95, width: double.infinity, child: SingleChildScrollView(child: Wrap(spacing:8, runSpacing:8, children: (chatTab==0? gameChat: friendsChat).map((m)=> Container(padding: EdgeInsets.symmetric(horizontal:14, vertical:9), decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(16)), child: Text(m, style: TextStyle(color: Colors.white, fontSize:12)))).toList()))),
            SizedBox(height:10),
            Row(children: [
              Container(width:46,height:46, decoration: BoxDecoration(color: Colors.white24, shape: BoxShape.circle), child: Icon(Icons.mic, color: Colors.white)),
              SizedBox(width:10),
              Container(width:46,height:46, decoration: BoxDecoration(color: Color(0xFFFFC93C), borderRadius: BorderRadius.circular(12)), child: Center(child: Text("$dice", style: TextStyle(fontWeight: FontWeight.bold, fontSize:20)))),
              SizedBox(width:10),
              Expanded(child: Container(height:46, decoration: BoxDecoration(color: Color(0xFF2A2A4A), borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.white24)), child: Row(children: [SizedBox(width:16), Expanded(child: TextField(controller: chatCtrl, style: TextStyle(color: Colors.white), decoration: InputDecoration(hintText: "شات...", hintStyle: TextStyle(color: Colors.white38), border: InputBorder.none))), IconButton(onPressed: (){ setState(()=>gameChat.add("😂🔥")); }, icon: Icon(Icons.emoji_emotions, color: Colors.amber))] ))),
              SizedBox(width:10),
              GestureDetector(onTap: (){ if(chatCtrl.text.isNotEmpty){ setState(()=>gameChat.add("Me: ${chatCtrl.text}")); chatCtrl.clear(); } }, child: Container(width:48,height:48, decoration: BoxDecoration(color: Color(0xFFFFD700), shape: BoxShape.circle), child: Icon(Icons.send, color: Colors.black))),
            ]),
          ]),
        ),
      ])),
    );
  }
}

// ==================== كيرم - 7 ابيض + 7 بني + كورة 15 سوداء + مضرب احترافي ====================
class CarromFull extends StatefulWidget {
  @override State<CarromFull> createState()=>_CarromFullState();
}
class _CarromFullState extends State<CarromFull> {
  List<CarromPiece> pieces=[];
  CarromPiece striker=CarromPiece(Offset(0.5,0.82), Color(0xFFFF1744), false, isStriker:true);
  int turn=0;
  Offset? dragStart, dragEnd;
  double power=0;
  Timer? timer;
  int chatTab=0;
  List<String> gameChat=["P1: حلوة 🔥","P2: دوري"];
  List<String> friendsChat=["Mona: تعالو كيرم","Ali: ثواني وجاي"];
  TextEditingController chatCtrl=TextEditingController();

  @override void initState(){
    super.initState();
    pieces=[
      // الكورة 15 السوداء - الملكة السوداء في النص
      CarromPiece(Offset(0.5,0.5), Color(0xFF000000), false, isQueen:true),
      // 7 كور بيضاء
      CarromPiece(Offset(0.5,0.40), Color(0xFFFFFDE7), true),
      CarromPiece(Offset(0.43,0.43), Color(0xFFFFF8E1), true),
      CarromPiece(Offset(0.57,0.43), Color(0xFFFFFDE7), true),
      CarromPiece(Offset(0.38,0.50), Color(0xFFFFF8E1), true),
      CarromPiece(Offset(0.62,0.50), Color(0xFFFFFDE7), true),
      CarromPiece(Offset(0.43,0.57), Color(0xFFFFF8E1), true),
      CarromPiece(Offset(0.57,0.57), Color(0xFFFFFDE7), true),
      // 7 كور بني/اسود
      CarromPiece(Offset(0.5,0.60), Color(0xFF3E2723), false),
      CarromPiece(Offset(0.38,0.43), Color(0xFF212121), false),
      CarromPiece(Offset(0.62,0.43), Color(0xFF3E2723), false),
      CarromPiece(Offset(0.33,0.50), Color(0xFF121212), false),
      CarromPiece(Offset(0.67,0.50), Color(0xFF3E2723), false),
      CarromPiece(Offset(0.38,0.57), Color(0xFF121212), false),
      CarromPiece(Offset(0.62,0.57), Color(0xFF000000), false),
    ];
    timer=Timer.periodic(Duration(milliseconds:16), (_)=>updatePhysics());
  }

  void updatePhysics(){
    if(!mounted) return;
    setState((){
      for(CarromPiece p in [...pieces, striker]){
        if(p.vel==Offset.zero) continue;
        p.pos+=p.vel*0.016;
        p.vel*=0.985;
        if(p.vel.distance<0.002) p.vel=Offset.zero;
        if(p.pos.dx<0.06||p.pos.dx>0.94){ p.vel=Offset(-p.vel.dx*0.85, p.vel.dy); p.pos=Offset(p.pos.dx.clamp(0.06,0.94), p.pos.dy); }
        if(p.pos.dy<0.06||p.pos.dy>0.94){ p.vel=Offset(p.vel.dx, -p.vel.dy*0.85); p.pos=Offset(p.pos.dx, p.pos.dy.clamp(0.06,0.94)); }
      }
      for(int i=0;i<pieces.length;i++){
        for(int j=i+1;j<pieces.length;j++){
          Offset delta=pieces[i].pos-pieces[j].pos;
          double d=delta.distance;
          if(d<0.064 && d>0.001){
            Offset n=delta/d;
            double dv=(pieces[i].vel.dx*n.dx + pieces[i].vel.dy*n.dy) - (pieces[j].vel.dx*n.dx + pieces[j].vel.dy*n.dy);
            if(dv<0){ pieces[i].vel-=n*dv*0.95; pieces[j].vel+=n*dv*0.95; }
            double o=0.064-d; pieces[i].pos+=n*o*0.5; pieces[j].pos-=n*o*0.5;
          }
        }
        Offset ds=pieces[i].pos-striker.pos;
        double d=ds.distance;
        if(d<0.08 && d>0.001){
          Offset n=ds/d;
          double dv=(pieces[i].vel.dx*n.dx + pieces[i].vel.dy*n.dy) - (striker.vel.dx*n.dx + striker.vel.dy*n.dy);
          if(dv<0){ pieces[i].vel-=n*dv*1.1; striker.vel+=n*dv*1.1; }
        }
      }
      bool scored=false;
      pieces.removeWhere((CarromPiece p){
        bool inHole=(p.pos-Offset(0.06,0.06)).distance<=0.068||(p.pos-Offset(0.94,0.06)).distance<=0.068||(p.pos-Offset(0.06,0.94)).distance<=0.068||(p.pos-Offset(0.94,0.94)).distance<=0.068);
        if(inHole) scored=true; return inHole;
      });
      if(scored && pieces.every((CarromPiece e)=> e.vel==Offset.zero) && striker.vel==Offset.zero){
        turn=(turn+1)%2; striker.pos=Offset(0.5, turn==0?0.82:0.18);
      }
    });
  }

  @override void dispose(){ timer?.cancel(); super.dispose(); }

  @override Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color(0xFF1A0F08),
      body: SafeArea(child: Column(children: [
        Container(padding: EdgeInsets.symmetric(horizontal:12, vertical:8), color: Color(0xFF2B1A0E), child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Column(children: [Container(padding: EdgeInsets.all(2), decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: turn==0? Colors.amber: Colors.transparent, width:2.5)), child: CircleAvatar(radius:20, backgroundColor: Colors.white, child: Text("P1", style: TextStyle(fontSize:11, fontWeight: FontWeight.bold)))), Text("لاعب 1", style: TextStyle(color: turn==0? Colors.amber: Colors.white54, fontSize:11))]),
          Text("VS", style: TextStyle(color: Colors.white24)),
          Column(children: [Container(padding: EdgeInsets.all(2), decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: turn==1? Colors.amber: Colors.transparent, width:2.5)), child: CircleAvatar(radius:20, backgroundColor: Colors.black, child: Text("P2", style: TextStyle(color: Colors.white, fontSize:11)))), Text("لاعب 2", style: TextStyle(color: turn==1? Colors.amber: Colors.white54, fontSize:11))]),
        ])),
        Container(
          margin: EdgeInsets.all(8),
          padding: EdgeInsets.symmetric(horizontal:12, vertical:10),
          decoration: BoxDecoration(color: Color(0xFF2B1F0F), borderRadius: BorderRadius.circular(16), border: Border.all(color: Color(0xFFD4AF37).withOpacity(0.4))),
          child: Row(children: [
            Icon(Icons.visibility, color: Colors.amber, size:18),
            SizedBox(width:8),
            Text("غرفة انتظار الأصدقاء - يشاهدون 👀", style: TextStyle(color: Colors.white70, fontSize:11, fontWeight: FontWeight.bold)),
            Spacer(),
            Icon(Icons.remove_red_eye_outlined, color: Colors.white38, size:16),
            SizedBox(width:6),
            Text("3 يشاهد", style: TextStyle(color: Colors.white38, fontSize:10)),
          ]),
        ),
        Expanded(child: Center(child: LayoutBuilder(builder: (ctx,cons){
          double size=math.min(cons.maxWidth-16, cons.maxHeight-16);
          return GestureDetector(
            onPanStart: (d){ dragStart=Offset(d.localPosition.dx/size, d.localPosition.dy/size); },
            onPanUpdate: (d){ dragEnd=Offset(d.localPosition.dx/size, d.localPosition.dy/size); if(dragStart!=null&&dragEnd!=null) power=(dragEnd! - dragStart!).distance.clamp(0,0.35); setState((){}); },
            onPanEnd: (_){ if(dragStart!=null&&dragEnd!=null){ Offset dir=dragEnd!-dragStart!; double pwr=dir.distance*18; if(pwr>0.5) striker.vel=dir.normalized()*pwr.clamp(0,9); } dragStart=null; dragEnd=null; power=0; setState((){}); },
            child: Container(
              width: size, height: size,
              decoration: BoxDecoration(color: Color(0xFFF5D6A0), border: Border.all(color: Color(0xFFD4AF37), width:10), borderRadius: BorderRadius.circular(8)),
              child: Stack(children: [
                Positioned(left:8,top:8, child: Container(width:34,height:34, decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle, border: Border.all(color: Color(0xFFFFD700), width:2.5)))),
                Positioned(right:8,top:8, child: Container(width:34,height:34, decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle, border: Border.all(color: Color(0xFFFFD700), width:2.5)))),
                Positioned(left:8,bottom:8, child: Container(width:34,height:34, decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle, border: Border.all(color: Color(0xFFFFD700), width:2.5)))),
                Positioned(right:8,bottom:8, child: Container(width:34,height:34, decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle, border: Border.all(color: Color(0xFFFFD700), width:2.5)))),
             ...pieces.map((CarromPiece pc)=>Positioned(
                  left: pc.pos.dx*size-20, top: pc.pos.dy*size-20,
                  child: Container(
                    width:40,height:40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: pc.isQueen?3.5:2.2),
                      boxShadow: [BoxShadow(color: Colors.black87, blurRadius:6, offset: Offset(0,3))],
                      gradient: pc.isQueen
                   ? RadialGradient(colors: [Color(0xFF424242), Color(0xFF000000)], center: Alignment(-0.3,-0.3))
                      : pc.isWhite? RadialGradient(colors: [Colors.white, Color(0xFFFFECB3), Color(0xFFFFCA28)], center: Alignment(-0.3,-0.3))
                      : RadialGradient(colors: [Color(0xFF5D4037), Color(0xFF000000)], center: Alignment(-0.3,-0.3)),
                    ),
                    child: pc.isQueen? Center(child: Text("★", style: TextStyle(color: Colors.yellowAccent, fontSize:18, fontWeight: FontWeight.bold))): null,
                  )
                )),
                Positioned(left: striker.pos.dx*size-28, top: striker.pos.dy*size-28, child: Container(width:56,height:56, decoration: BoxDecoration(shape: BoxShape.circle, gradient: RadialGradient(colors: [Color(0xFFFF4081), Color(0xFF880E4F)], center: Alignment(-0.2,-0.2)), border: Border.all(color: Colors.white, width:4), boxShadow: [BoxShadow(color: Colors.black87, blurRadius:10)]), child: Center(child: Container(width:26,height:26, decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: Color(0xFF880E4F), width:2.5)), child: Center(child: Container(width:10,height:10, decoration: BoxDecoration(color: Color(0xFFAD1457), shape: BoxShape.circle))))))),
                if(dragStart!=null&&dragEnd!=null) CustomPaint(size: Size(size,size), painter: AimPainterPro(dragStart!*size, dragEnd!*size, power)),
                Positioned(bottom:8, left:0, right:0, child: Center(child: Container(padding: EdgeInsets.symmetric(horizontal:14, vertical:5), decoration: BoxDecoration(color: Colors.black.withOpacity(0.7), borderRadius: BorderRadius.circular(14)), child: Text("${pieces.length} كورة • 7 ابيض + 7 بني + 1 سوداء", style: TextStyle(fontSize:11, color: Colors.white70))))),
              ]),
            ),
          );
        }))),
        Container(
          padding: EdgeInsets.all(10),
          color: Color(0xFF0A0A2A),
          child: Column(children: [
            Row(children: [
              GestureDetector(onTap: ()=>setState(()=>chatTab=0), child: Container(padding: EdgeInsets.symmetric(horizontal:18, vertical:8), decoration: BoxDecoration(color: chatTab==0? Color(0xFFFFD700): Color(0xFF2A2A4A), borderRadius: BorderRadius.circular(20)), child: Text("شات اللاعبين", style: TextStyle(fontSize:12, color: chatTab==0? Colors.black: Colors.white70, fontWeight: FontWeight.bold)))),
              SizedBox(width:10),
              GestureDetector(onTap: ()=>setState(()=>chatTab=1), child: Container(padding: EdgeInsets.symmetric(horizontal:18, vertical:8), decoration: BoxDecoration(color: chatTab==1? Color(0xFF3DD4C0): Color(0xFF2A2A4A), borderRadius: BorderRadius.circular(20)), child: Text("شات الأصدقاء الخاص", style: TextStyle(fontSize:12, color: chatTab==1? Colors.black: Colors.white70)))),
            ]),
            SizedBox(height:10),
            Container(height: 38, child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: (chatTab==0? gameChat: friendsChat).map((m)=> Container(margin: EdgeInsets.only(right:8), padding: EdgeInsets.symmetric(horizontal:14, vertical:8), decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(16)), child: Text(m, style: TextStyle(color: Colors.white70, fontSize:12)))).toList()))),
            SizedBox(height:10),
            Row(children: [
              Container(width:46,height:46, decoration: BoxDecoration(color: Colors.white24, shape: BoxShape.circle), child: Icon(Icons.mic, color: Colors.white)),
              SizedBox(width:10),
              Expanded(child: Container(height:46, decoration: BoxDecoration(color: Color(0xFF2A2A4A), borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.white24)), child: Row(children: [SizedBox(width:16), Expanded(child: TextField(controller: chatCtrl, style: TextStyle(color: Colors.white), decoration: InputDecoration(hintText: "شات...", hintStyle: TextStyle(color: Colors.white38), border: InputBorder.none))), IconButton(onPressed: (){ setState(()=>gameChat.add("😂🔥")); }, icon: Icon(Icons.emoji_emotions, color: Colors.amber))] ))),
              SizedBox(width:10),
              GestureDetector(onTap: (){ if(chatCtrl.text.isNotEmpty){ setState(()=>gameChat.add("Me: ${chatCtrl.text}")); chatCtrl.clear(); } }, child: Container(width:48,height:48, decoration: BoxDecoration(color: Color(0xFFFFD700), shape: BoxShape.circle), child: Icon(Icons.send, color: Colors.black))),
            ]),
          ]),
        ),
      ])),
    );
  }
}

class CarromPiece{
  Offset pos; Color color; bool isWhite; bool isQueen=false; bool isStriker=false; Offset vel=Offset.zero;
  CarromPiece(this.pos,this.color,this.isWhite,{this.isQueen=false,this.isStriker=false});
}
extension OffsetExt on Offset{
  Offset normalized(){ double d=distance; if(d==0) return Offset.zero; return this/d; }
}
class AimPainterPro extends CustomPainter{
  Offset from,to; double power;
  AimPainterPro(this.from,this.to,this.power);
  @override void paint(Canvas c,Size s){
    var p=Paint()..color=Colors.white.withOpacity(0.9)..strokeWidth=3.5..style=PaintingStyle.stroke..strokeCap=StrokeCap.round;
    c.drawLine(from, to, p);
    Offset dir=to-from; double len=dir.distance;
    if(len>0){ Offset n=dir/len; c.drawLine(to, to+n*power*380, Paint()..color=power>0.25? Colors.redAccent: Colors.yellowAccent..strokeWidth=4..style=PaintingStyle.stroke); c.drawCircle(to+n*power*380, 6, Paint()..color=Colors.white); }
  }
  @override bool shouldRepaint(covariant CustomPainter o)=>true;
}
