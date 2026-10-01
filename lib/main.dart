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

// ==================== لودو ملوكي - الطيارة في نص خط السير ====================
class LudoRoyalFull extends StatefulWidget {
  @override State<LudoRoyalFull> createState() => _LudoRoyalFullState();
}
class _LudoRoyalFullState extends State<LudoRoyalFull> {
  int dice=6;
  List<int> clockwiseOrder = [3,1,0,2];
  int orderIndex=0;
  int get turn => clockwiseOrder[orderIndex];
  bool canRoll=true;
  String msg="جبت 6";
  List<List<int>> tokens=[[-1,0,1,2],[39,13,26,3],[13,-1,-1,-1],[0,-1,-1,-1]];
  List<int> start=[0,39,13,26];
  List<int> safe=[0,8,13,21,26,34,39,47];
  List<List<int>> homePath=[[52,53,54,55,56,57],[58,59,60,61,62,63],[64,65,66,67,68,69],[70,71,72,73,74,75]];
  int chatTab=0;
  bool showSpectators=false;
  List<String> gameChat=["P3: عاش 💪","Me: السلام عليكم ورحمة الله وبركاته","Me: عاش","P1: يلا نلعب 👑","P2: جاهز 🔥"];
  List<String> friendsChat=["Ahmed: فينكم؟","Sara: تعالو لودو 😎","Leo: انا داخل"];
  TextEditingController chatCtrl=TextEditingController();
  List<Map<String,dynamic>> spectators=[{"name":"Mona","color":Color(0xFFE91E63),"letter":"M"},{"name":"Ali","color":Color(0xFF2196F3),"letter":"A"},{"name":"Khaled","color":Color(0xFF4CAF50),"letter":"K"},{"name":"Nour","color":Color(0xFFFF9800),"letter":"N"}];

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
      msg="جبت $dice";
    });
    bool can=false;
    for(int p in tokens[turn]){ if(p==-1&&dice==6) can=true; if(p>=0&&p<52) can=true; if(p>=52&&p<76) can=true; }
    if(!can){ Future.delayed(Duration(milliseconds:700),(){ setState((){ orderIndex=(orderIndex+1)%4; canRoll=true; }); }); }
  }
  void move(int p,int idx){
    if(p!=turn||canRoll) return;
    int cur=tokens[p][idx];
    if(cur==-1&&dice!=6) return;
    setState((){
      if(cur==-1) tokens[p][idx]=start[p];
      else if(cur>=0&&cur<52){
        int entry=(start[p]+51)%52;
        int steps=cur+dice;
        if(cur<=entry && steps>entry){
          int homeSteps=steps-entry-1;
          if(homeSteps<6) tokens[p][idx]=homePath[p][homeSteps];
          else if(homeSteps==6) tokens[p][idx]=100;
          else tokens[p][idx]=steps%52;
        }else tokens[p][idx]=steps%52;
      }else if(cur>=52 && cur<100){
        int homeIdx=homePath[p].indexOf(cur);
        if(homeIdx+dice<6) tokens[p][idx]=homePath[p][homeIdx+dice];
        else if(homeIdx+dice==6) tokens[p][idx]=100;
      }
      if(dice!=6) orderIndex=(orderIndex+1)%4;
      canRoll=true;
    });
  }

  Widget waitingRoom(){
    return GestureDetector(
      onTap: ()=> setState(()=> showSpectators=!showSpectators),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal:8, vertical:6),
        padding: EdgeInsets.symmetric(horizontal:14, vertical:10),
        decoration: BoxDecoration(color: Color(0xFF2A3A8C).withOpacity(0.7), borderRadius: BorderRadius.circular(18), border: Border.all(color: Colors.white24)),
        child: Column(children: [
          Row(children: [
            Icon(Icons.visibility, size:20, color: Colors.amber),
            SizedBox(width:8),
            Text("غرفة انتظار الأصدقاء - يشاهدون اللعب 👀", style: TextStyle(color: Colors.white, fontSize:12, fontWeight: FontWeight.bold)),
            Spacer(),
            // علامة العين فقط - بدون اسماء زي ما طلبت
            Icon(Icons.remove_red_eye, size:16, color: Colors.white54),
            SizedBox(width:6),
            Container(padding: EdgeInsets.symmetric(horizontal:10, vertical:4), decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(12)), child: Text("${spectators.length}", style: TextStyle(color: Colors.white, fontSize:11, fontWeight: FontWeight.bold))),
            Icon(showSpectators? Icons.expand_less: Icons.expand_more, color: Colors.white70, size:20),
          ]),
          if(showSpectators)...[
            SizedBox(height:12),
            Divider(color: Colors.white12, height:1),
            SizedBox(height:12),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: spectators.map((s)=> Column(children: [
              Stack(children: [
                CircleAvatar(radius:26, backgroundColor: s["color"] as Color, child: Text(s["letter"], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize:18))),
                Positioned(right:0, bottom:0, child: Container(width:10,height:10, decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle, border: Border.all(color: Color(0xFF2A3A8C), width:2)))),
              ]),
              SizedBox(height:6),
              Text(s["name"] as String, style: TextStyle(color: Colors.white70, fontSize:11)),
            ])).toList()),
          ]
        ]),
      ),
    );
  }

  Widget chatSection(){
    List<String> current = chatTab==0? gameChat : friendsChat;
    return Container(
      padding: EdgeInsets.all(10),
      color: Color(0xFF0A0A2A),
      child: Column(children: [
        Row(children: [
          GestureDetector(onTap: ()=>setState(()=>chatTab=0), child: Container(padding: EdgeInsets.symmetric(horizontal:18, vertical:8), decoration: BoxDecoration(color: chatTab==0? Color(0xFFFFD700): Color(0xFF2A2A4A), borderRadius: BorderRadius.circular(20)), child: Text("شات اللاعبين", style: TextStyle(fontSize:12, color: chatTab==0? Colors.black: Colors.white70, fontWeight: FontWeight.bold)))),
          SizedBox(width:10),
          GestureDetector(onTap: ()=>setState(()=>chatTab=1), child: Container(padding: EdgeInsets.symmetric(horizontal:18, vertical:8), decoration: BoxDecoration(color: chatTab==1? Color(0xFF3DD4C0): Color(0xFF2A2A4A), borderRadius: BorderRadius.circular(20)), child: Text("شات الأصدقاء الخاص", style: TextStyle(fontSize:12, color: chatTab==1? Colors.black: Colors.white70)))),
        ]),
        SizedBox(height:10),
        // وسعت مكان الشات الجماعي في الروم
        Container(
          height: chatTab==0? 95: 40,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Wrap(spacing:8, runSpacing:8, children: current.map((m)=> Container(padding: EdgeInsets.symmetric(horizontal:14, vertical:9), decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(18), border: Border.all(color: Colors.white12)), child: Text(m, style: TextStyle(color: Colors.white, fontSize:12)))).toList()),
          ),
        ),
        SizedBox(height:10),
        Row(children: [
          Container(width:46,height:46, decoration: BoxDecoration(color: Colors.white24, shape: BoxShape.circle), child: Icon(Icons.mic, color: Colors.white, size:24)),
          SizedBox(width:10),
          Container(width:46,height:46, decoration: BoxDecoration(color: Color(0xFFFFC93C), borderRadius: BorderRadius.circular(12)), child: Center(child: Text("$dice", style: TextStyle(fontWeight: FontWeight.bold, fontSize:20, color: Colors.black)))),
          SizedBox(width:10),
          Expanded(child: Container(height:46, decoration: BoxDecoration(color: Color(0xFF2A2A4A), borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.white24)), child: Row(children: [
            SizedBox(width:16),
            Expanded(child: TextField(controller: chatCtrl, style: TextStyle(color: Colors.white, fontSize:14), decoration: InputDecoration(hintText: "شات...", hintStyle: TextStyle(color: Colors.white38, fontSize:13), border: InputBorder.none))),
            IconButton(onPressed: (){ setState(()=>gameChat.add("😂🔥👑")); }, icon: Icon(Icons.emoji_emotions, color: Colors.amber, size:24)),
          ]))),
          SizedBox(width:10),
          GestureDetector(onTap: (){ if(chatCtrl.text.isNotEmpty){ setState(()=>gameChat.add("Me: ${chatCtrl.text}")); chatCtrl.clear(); } }, child: Container(width:48,height:48, decoration: BoxDecoration(color: Color(0xFFFFD700), shape: BoxShape.circle), child: Icon(Icons.send, color: Colors.black, size:22))),
        ]),
      ]),
    );
  }

  @override Widget build(BuildContext context){
    Color red=Color(0xFFE53935), yellow=Color(0xFFFBC02D), green=Color(0xFF43A047), blue=Color(0xFF1E88E5);
    List<Color> cols=[red,yellow,green,blue];
    double size=MediaQuery.of(context).size.width-6;
    double cell=size/15;
    return Scaffold(
      backgroundColor: Color(0xFF0D1B4A),
      body: Container(
        decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF0D1B4A), Color(0xFF1A237E)])),
        child: SafeArea(child: Column(children: [
          Container(margin: EdgeInsets.only(top:6), padding: EdgeInsets.symmetric(horizontal:20, vertical:8), decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(22), border: Border.all(color: Colors.amber, width:1.8)), child: Text(msg, style: TextStyle(color: Colors.white, fontSize:15, fontWeight: FontWeight.bold))),
          waitingRoom(),
          Expanded(child: Center(child: Container(
            width: size, height: size,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(color: Color(0xFF3E2723), borderRadius: BorderRadius.circular(14), border: Border.all(color: Color(0xFFD4AF37), width:3.5)),
            child: Container(
              clipBehavior: Clip.none,
              decoration: BoxDecoration(color: Color(0xFFFFF8E1)),
              child: Stack(clipBehavior: Clip.none, children: [
                GridView.count(crossAxisCount:15, physics: NeverScrollableScrollPhysics(), padding: EdgeInsets.zero, children: List.generate(225, (idx){
                  int r=idx~/15,c=idx%15; Color bg=Color(0xFFFFF8E1);
                  if(r<6&&c<6) bg=red;
                  else if(r<6&&c>8) bg=green;
                  else if(r>8&&c<6) bg=yellow;
                  else if(r>8&&c>8) bg=blue;
                  else if(r==7&&c>=1&&c<=5) bg=red.withOpacity(0.85);
                  else if(r==7&&c>=9&&c<=13) bg=green.withOpacity(0.65);
                  else if(c==7&&r>=1&&r<=5) bg=yellow.withOpacity(0.65);
                  else if(c==7&&r>=9&&r<=13) bg=blue.withOpacity(0.65);
                  else if(r>=6&&r<=8&&c>=6&&c<=8) bg=Color(0xFFFFD54F);
                  Widget? ch; int pIdx=path.indexWhere((e)=>e.dx==r&&e.dy==c);
                  if(safe.contains(pIdx)) ch=Text("★", style: TextStyle(fontSize: cell*0.32, color: Colors.black54));
                  return Container(decoration: BoxDecoration(color: bg, border: Border.all(color: Colors.black12, width:0.4)), child: Center(child: ch));
                })),
                // الطيارة في نص مربعات خط السير بالظبط - تصليح نهائي
              ...List.generate(4, (p)=>List.generate(4, (t){
                  int bp=tokens[p][t];
                  double cx,cy;
                  double sz = bp==-1? cell*1.1 : cell*0.78;
                  if(bp==-1){
                    cx=(t%2==0?1.5:3.5)*cell;
                    cy=(t<2?1.5:3.5)*cell;
                    if(p==1) cy=(t<2?10.5:12.5)*cell;
                    if(p==2) cx=(t%2==0?10.5:12.5)*cell;
                    if(p==3){ cx=(t%2==0?10.5:12.5)*cell; cy=(t<2?10.5:12.5)*cell; }
                  }else if(bp>=100){ cx=7.5*cell; cy=7.5*cell; }
                  else if(homeCoords.containsKey(bp)){ var pt=homeCoords[bp]!; cx=pt.dy*cell + cell/2; cy=pt.dx*cell + cell/2; }
                  else{ var pt=path[bp%52]; cx=pt.dy*cell + cell/2; cy=pt.dx*cell + cell/2; }
                  return Positioned(
                    left: cx - sz/2,
                    top: cy - sz/2,
                    child: GestureDetector(
                      onTap: ()=>move(p,t),
                      child: Container(
                        width: sz, height: sz,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: cols[p],
                          border: Border.all(color: Colors.white, width: 2.2),
                          boxShadow: [BoxShadow(color: Colors.black54, blurRadius:3, offset: Offset(0,1.5))],
                        ),
                        child: Center(child: Text("♔", style: TextStyle(fontSize: sz*0.60, color: Colors.white, fontWeight: FontWeight.bold))),
                      ),
                    ),
                  );
                })).expand((e)=>e),
                if(canRoll) Center(child: GestureDetector(onTap: roll, child: Container(width: 106, height: 106, decoration: BoxDecoration(shape: BoxShape.circle, gradient: RadialGradient(colors: [Color(0xFFFFD700), Color(0xFFFF6F00)]), border: Border.all(color: Colors.white, width:3.5), boxShadow: [BoxShadow(blurRadius:12, color: Colors.black54)]), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text("$dice", style: TextStyle(fontSize:40, fontWeight: FontWeight.bold, color: Colors.black)), Text("ROLL", style: TextStyle(fontWeight: FontWeight.bold, fontSize:14, color: Colors.black))])))),
              ]),
            ),
          ))),
          chatSection(),
        ])),
      ),
    );
  }
}

// ==================== كيرم محترف - كور ومضرب احترافي جدا جدا ====================
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
  bool showSpectators=false;
  List<String> gameChat=["P1: حلوة 🔥","P2: دوري","P1: عاش 👑"];
  List<String> friendsChat=["Mona: تعالو كيرم","Ali: ثواني وجاي"];
  TextEditingController chatCtrl=TextEditingController();
  List<Map<String,dynamic>> spectators=[{"name":"Ziad","color":Color(0xFF9C27B0),"letter":"Z"},{"name":"Lina","color":Color(0xFF009688),"letter":"L"},{"name":"Omar","color":Color(0xFFFF9800),"letter":"O"}];

  @override void initState(){
    super.initState();
    pieces=[
      CarromPiece(Offset(0.5,0.5), Color(0xFFD32F2F), true, isQueen:true),
      CarromPiece(Offset(0.5,0.40), Color(0xFFFFFDE7), true),
      CarromPiece(Offset(0.43,0.43), Color(0xFFFFF8E1), true),
      CarromPiece(Offset(0.57,0.43), Color(0xFFFFFDE7), true),
      CarromPiece(Offset(0.38,0.50), Color(0xFFFFF8E1), true),
      CarromPiece(Offset(0.62,0.50), Color(0xFFFFFDE7), true),
      CarromPiece(Offset(0.43,0.57), Color(0xFFFFF8E1), true),
      CarromPiece(Offset(0.57,0.57), Color(0xFFFFFDE7), true),
      CarromPiece(Offset(0.5,0.60), Color(0xFF0D0D0D), false),
      CarromPiece(Offset(0.38,0.43), Color(0xFF3E2723), false),
      CarromPiece(Offset(0.62,0.43), Color(0xFF121212), false),
      CarromPiece(Offset(0.33,0.50), Color(0xFF3E2723), false),
      CarromPiece(Offset(0.67,0.50), Color(0xFF0D0D0D), false),
      CarromPiece(Offset(0.38,0.57), Color(0xFF121212), false),
      CarromPiece(Offset(0.62,0.57), Color(0xFF2D1B14), false),
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
            Offset normal=delta/d;
            double v1n=pieces[i].vel.dx*normal.dx + pieces[i].vel.dy*normal.dy;
            double v2n=pieces[j].vel.dx*normal.dx + pieces[j].vel.dy*normal.dy;
            double dv=v1n-v2n;
            if(dv<0){
              pieces[i].vel-=normal*dv*0.95;
              pieces[j].vel+=normal*dv*0.95;
            }
            double overlap=0.064-d;
            pieces[i].pos+=normal*overlap*0.5;
            pieces[j].pos-=normal*overlap*0.5;
          }
        }
        Offset ds=pieces[i].pos-striker.pos;
        double d=ds.distance;
        if(d<0.080 && d>0.001){
          Offset normal=ds/d;
          double v1n=pieces[i].vel.dx*normal.dx + pieces[i].vel.dy*normal.dy;
          double v2n=striker.vel.dx*normal.dx + striker.vel.dy*normal.dy;
          double dv=v1n-v2n;
          if(dv<0){
            pieces[i].vel-=normal*dv*1.1;
            striker.vel+=normal*dv*1.1;
          }
        }
      }
      bool scored=false;
      pieces.removeWhere((CarromPiece p){
        bool inHole=(p.pos-Offset(0.06,0.06)).distance<=0.068||(p.pos-Offset(0.94,0.06)).distance<=0.068||(p.pos-Offset(0.06,0.94)).distance<=0.068||(p.pos-Offset(0.94,0.94)).distance<=0.068;
        if(inHole) scored=true;
        return inHole;
      });
      if(scored && pieces.every((CarromPiece e)=> e.vel==Offset.zero) && striker.vel==Offset.zero){
        turn=(turn+1)%2;
        striker.pos=Offset(0.5, turn==0?0.82:0.18);
      }
    });
  }

  @override void dispose(){ timer?.cancel(); super.dispose(); }

  Widget waitingRoom(){
    return GestureDetector(
      onTap: ()=> setState(()=> showSpectators=!showSpectators),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal:8, vertical:4),
        padding: EdgeInsets.symmetric(horizontal:12, vertical:10),
        decoration: BoxDecoration(color: Color(0xFF2B1F0F), borderRadius: BorderRadius.circular(20), border: Border.all(color: Color(0xFFD4AF37).withOpacity(0.4))),
        child: Row(children: [
          Icon(Icons.visibility, size:20, color: Colors.amber),
          SizedBox(width:8),
          Text("غرفة انتظار الأصدقاء - يشاهدون 👀", style: TextStyle(color: Colors.white70, fontSize:11, fontWeight: FontWeight.bold)),
          Spacer(),
          Icon(Icons.remove_red_eye_outlined, size:16, color: Colors.white38),
          SizedBox(width:6),
          Text("3 يشاهد", style: TextStyle(color: Colors.white38, fontSize:10)),
          Icon(showSpectators? Icons.expand_less: Icons.expand_more, color: Colors.white54, size:18),
        ]),
      ),
    );
  }

  Widget chatSection(){
    List<String> current = chatTab==0? gameChat : friendsChat;
    return Container(
      padding: EdgeInsets.all(10),
      color: Color(0xFF0A0A2A),
      child: Column(children: [
        Row(children: [
          GestureDetector(onTap: ()=>setState(()=>chatTab=0), child: Container(padding: EdgeInsets.symmetric(horizontal:18, vertical:8), decoration: BoxDecoration(color: chatTab==0? Color(0xFFFFD700): Color(0xFF2A2A4A), borderRadius: BorderRadius.circular(20)), child: Text("شات اللاعبين", style: TextStyle(fontSize:12, color: chatTab==0? Colors.black: Colors.white70, fontWeight: FontWeight.bold)))),
          SizedBox(width:10),
          GestureDetector(onTap: ()=>setState(()=>chatTab=1), child: Container(padding: EdgeInsets.symmetric(horizontal:18, vertical:8), decoration: BoxDecoration(color: chatTab==1? Color(0xFF3DD4C0): Color(0xFF2A2A4A), borderRadius: BorderRadius.circular(20)), child: Text("شات الأصدقاء الخاص", style: TextStyle(fontSize:12, color: chatTab==1? Colors.black: Colors.white70)))),
        ]),
        SizedBox(height:10),
        Container(height: chatTab==0? 65: 38, child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: current.map((m)=> Container(margin: EdgeInsets.only(right:8), padding: EdgeInsets.symmetric(horizontal:14, vertical:8), decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(16)), child: Text(m, style: TextStyle(color: Colors.white70, fontSize:12)))).toList()))),
        SizedBox(height:10),
        Row(children: [
          Container(width:46,height:46, decoration: BoxDecoration(color: Colors.white24, shape: BoxShape.circle), child: Icon(Icons.mic, color: Colors.white, size:24)),
          SizedBox(width:10),
          Expanded(child: Container(height:46, decoration: BoxDecoration(color: Color(0xFF2A2A4A), borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.white24)), child: Row(children: [
            SizedBox(width:16),
            Expanded(child: TextField(controller: chatCtrl, style: TextStyle(color: Colors.white, fontSize:14), decoration: InputDecoration(hintText: "شات...", hintStyle: TextStyle(color: Colors.white38, fontSize:13), border: InputBorder.none))),
            IconButton(onPressed: (){ setState(()=>gameChat.add("😂🔥")); }, icon: Icon(Icons.emoji_emotions, color: Colors.amber, size:24)),
          ]))),
          SizedBox(width:10),
          GestureDetector(onTap: (){ if(chatCtrl.text.isNotEmpty){ setState(()=>gameChat.add("Me: ${chatCtrl.text}")); chatCtrl.clear(); } }, child: Container(width:48,height:48, decoration: BoxDecoration(color: Color(0xFFFFD700), shape: BoxShape.circle), child: Icon(Icons.send, color: Colors.black, size:22))),
        ]),
      ]),
    );
  }

  @override Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color(0xFF1A0F08),
      body: SafeArea(child: Column(children: [
        Container(padding: EdgeInsets.symmetric(horizontal:12, vertical:8), color: Color(0xFF2B1A0E), child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Column(children: [Container(padding: EdgeInsets.all(2), decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: turn==0? Colors.amber: Colors.transparent, width:2.5)), child: CircleAvatar(radius:20, backgroundColor: Colors.white, child: Text("P1", style: TextStyle(fontSize:11, fontWeight: FontWeight.bold)))), SizedBox(height:2), Text("لاعب 1", style: TextStyle(color: turn==0? Colors.amber: Colors.white54, fontSize:11))]),
          Text("VS", style: TextStyle(color: Colors.white24, fontSize:16)),
          Column(children: [Container(padding: EdgeInsets.all(2), decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: turn==1? Colors.amber: Colors.transparent, width:2.5)), child: CircleAvatar(radius:20, backgroundColor: Colors.black, child: Text("P2", style: TextStyle(color: Colors.white, fontSize:11)))), SizedBox(height:2), Text("لاعب 2", style: TextStyle(color: turn==1? Colors.amber: Colors.white54, fontSize:11))]),
        ])),
        waitingRoom(),
        Expanded(child: Center(child: LayoutBuilder(builder: (ctx,cons){
          double size=math.min(cons.maxWidth-16, cons.maxHeight-16);
          return GestureDetector(
            onPanStart: (d){ dragStart=Offset(d.localPosition.dx/size, d.localPosition.dy/size); },
            onPanUpdate: (d){
              dragEnd=Offset(d.localPosition.dx/size, d.localPosition.dy/size);
              if(dragStart!=null && dragEnd!=null) power = (dragEnd! - dragStart!).distance.clamp(0,0.35);
              setState((){});
            },
            onPanEnd: (_){
              if(dragStart!=null&&dragEnd!=null){
                Offset dir=dragEnd!-dragStart!;
                double pwr = dir.distance*18;
                if(pwr>0.5) striker.vel=dir.normalized()*pwr.clamp(0,9);
              }
              dragStart=null; dragEnd=null; power=0; setState((){});
            },
            child: Container(
              width: size, height: size,
              decoration: BoxDecoration(color: Color(0xFFF5D6A0), border: Border.all(color: Color(0xFFD4AF37), width:10), borderRadius: BorderRadius.circular(8)),
              child: Stack(children: [
                Positioned(left:8,top:8, child: Container(width:34,height:34, decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle, border: Border.all(color: Color(0xFFFFD700), width:2.5)))),
                Positioned(right:8,top:8, child: Container(width:34,height:34, decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle, border: Border.all(color: Color(0xFFFFD700), width:2.5)))),
                Positioned(left:8,bottom:8, child: Container(width:34,height:34, decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle, border: Border.all(color: Color(0xFFFFD700), width:2.5)))),
                Positioned(right:8,bottom:8, child: Container(width:34,height:34, decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle, border: Border.all(color: Color(0xFFFFD700), width:2.5)))),
                CustomPaint(size: Size(size,size), painter: CarromLinesPainter()),
                // كور احترافية جدا - 3D بلمعة
              ...pieces.map((CarromPiece pc)=>Positioned(
                  left: pc.pos.dx*size-20, top: pc.pos.dy*size-20,
                  child: Container(
                    width:40,height:40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: pc.isQueen?3.5:2.5),
                      boxShadow: [BoxShadow(color: Colors.black87, blurRadius:6, offset: Offset(0,3)), BoxShadow(color: Colors.white.withOpacity(0.4), blurRadius:2, offset: Offset(-2,-2))],
                      gradient: pc.isQueen
                    ? RadialGradient(colors: [Color(0xFFFF6B6B), Color(0xFFD32F2F), Color(0xFF8B0000)], center: Alignment(-0.3,-0.3), radius: 0.9)
                      : pc.isWhite
                    ? RadialGradient(colors: [Colors.white, Color(0xFFFFF9C4), Color(0xFFFFE082), Color(0xFFFFCA28)], center: Alignment(-0.3,-0.3), radius: 0.9)
                      : RadialGradient(colors: [Color(0xFF5D4037), Color(0xFF3E2723), Color(0xFF000000)], center: Alignment(-0.3,-0.3), radius: 0.9),
                    ),
                    child: pc.isQueen? Center(child: Stack(children: [
                      Center(child: Container(width:24,height:24, decoration: BoxDecoration(color: Color(0xFFFFD700).withOpacity(0.9), shape: BoxShape.circle))),
                      Center(child: Text("★", style: TextStyle(color: Colors.red, fontSize:16, fontWeight: FontWeight.bold))),
                    ])): pc.isWhite? Align(alignment: Alignment(-0.5,-0.5), child: Container(width:10,height:10, decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), shape: BoxShape.circle))): Align(alignment: Alignment(-0.4,-0.4), child: Container(width:8,height:8, decoration: BoxDecoration(color: Colors.white.withOpacity(0.3), shape: BoxShape.circle))),
                  )
                )),
                // مضرب احترافي جدا - خشب حقيقي
                Positioned(
                  left: striker.pos.dx*size-28, top: striker.pos.dy*size-28,
                  child: Container(
                    width:56,height:56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(colors: [Color(0xFFFF4081), Color(0xFFE91E63), Color(0xFF880E4F)], center: Alignment(-0.2,-0.2), radius: 0.9),
                      border: Border.all(color: Colors.white, width:4),
                      boxShadow: [BoxShadow(color: Colors.black87, blurRadius:10, offset: Offset(0,4)), BoxShadow(color: Color(0xFFFF4081).withOpacity(0.4), blurRadius:12)],
                    ),
                    child: Center(
                      child: Container(
                        width:26,height:26,
                        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: Color(0xFF880E4F), width:2.5), boxShadow: [BoxShadow(color: Colors.black26, blurRadius:3)]),
                        child: Center(child: Container(width:10,height:10, decoration: BoxDecoration(color: Color(0xFFAD1457), shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black26, blurRadius:2)]))),
                      ),
                    ),
                  ),
                ),
                if(dragStart!=null&&dragEnd!=null) CustomPaint(size: Size(size,size), painter: AimPainterPro(dragStart!*size, dragEnd!*size, power)),
                Positioned(bottom:8, left:0, right:0, child: Center(child: Container(padding: EdgeInsets.symmetric(horizontal:14, vertical:5), decoration: BoxDecoration(color: Colors.black.withOpacity(0.7), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white12)), child: Text("${pieces.length} كورة • اسحب لتحديد القوة ${power>0?"${(power*100).toInt()}%":""}", style: TextStyle(fontSize:11, color: Colors.white70))))),
              ]),
            ),
          );
        }))),
        chatSection(),
      ])),
    );
  }
}

class CarromLinesPainter extends CustomPainter{
  @override void paint(Canvas canvas,Size size){
    var p=Paint()..color=Colors.brown.withOpacity(0.4)..strokeWidth=1.5..style=PaintingStyle.stroke;
    canvas.drawCircle(Offset(size.width/2, size.height/2), 24, p);
    canvas.drawRect(Rect.fromCenter(center: Offset(size.width/2, size.height/2), width: size.width*0.74, height: size.height*0.74), p);
  }
  @override bool shouldRepaint(covariant CustomPainter old)=>false;
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
  @override void paint(Canvas canvas,Size size){
    var p=Paint()..color=Colors.white.withOpacity(0.9)..strokeWidth=3.5..style=PaintingStyle.stroke..strokeCap=StrokeCap.round;
    canvas.drawLine(from, to, p);
    var p2=Paint()..color= power>0.25? Colors.redAccent: Colors.yellowAccent..strokeWidth=4..style=PaintingStyle.stroke..strokeCap=StrokeCap.round;
    Offset dir = to-from;
    double len = dir.distance;
    if(len>0){
      Offset norm = dir/len;
      canvas.drawLine(to, to+norm*power*380, p2);
      var dot = Paint()..color=Colors.white..style=PaintingStyle.fill;
      canvas.drawCircle(to+norm*power*380, 6, dot);
      var outer = Paint()..color=(power>0.25? Colors.red: Colors.yellow)..style=PaintingStyle.stroke..strokeWidth=2;
      canvas.drawCircle(to+norm*power*380, 10, outer);
    }
  }
  @override bool shouldRepaint(covariant CustomPainter old)=>true;
}
