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

// ==================== لودو ====================
class LudoRoyalFull extends StatefulWidget {
  @override State<LudoRoyalFull> createState() => _LudoRoyalFullState();
}
class _LudoRoyalFullState extends State<LudoRoyalFull> {
  int dice=1;
  // ترتيب عقارب الساعة: ازرق(3) -> اصفر(1) -> احمر(0) -> اخضر(2) -> يرجع ازرق
  List<int> clockwiseOrder = [3,1,0,2];
  int orderIndex=0;
  int get turn => clockwiseOrder[orderIndex];
  bool canRoll=true;
  String msg="دور عشوائي - ارمي 6 عشان تطلع من قدام بيتك";
  List<List<int>> tokens=[[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1]];
  List<int> start=[0,39,13,26]; // احمر, اصفر, اخضر, ازرق
  List<int> safe=[0,8,13,21,26,34,39,47];
  List<List<int>> homePath=[[52,53,54,55,56,57],[58,59,60,61,62,63],[64,65,66,67,68,69],[70,71,72,73,74,75]];
  int chatTab=0;
  List<String> gameChat=["P1: يلا نلعب 👑","P2: جاهز 🔥"];
  List<String> friendsChat=["Ahmed: فينكم؟","Sara: تعالو لودو 😎"];
  TextEditingController chatCtrl=TextEditingController();

  @override void initState(){
    super.initState();
    // بداية عشوائية
    orderIndex = math.Random().nextInt(4);
    msg="دور الملك ${["الاحمر","الاصفر","الاخضر","الازرق"][turn]} - البداية عشوائية";
  }

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
    for(int p in tokens[turn]){ if(p==-1&&dice==6) can=true; if(p>=0&&p<52) can=true; if(p>=52&&p<76) can=true; }
    if(!can){ Future.delayed(Duration(milliseconds:700),(){ setState((){ orderIndex=(orderIndex+1)%4; canRoll=true; msg="دور ${["الاحمر","الاصفر","الاخضر","الازرق"][turn]} - اللي جنبه"; }); }); }
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
      int newPos=tokens[p][idx];
      if(newPos<52 &&!safe.contains(newPos)){
        for(int op=0;op<4;op++){ if(op==p) continue; for(int ot=0;ot<4;ot++){ if(tokens[op][ot]==newPos){ tokens[op][ot]=-1; } } }
      }
      if(dice!=6) orderIndex=(orderIndex+1)%4;
      canRoll=true;
      msg="دور ${["الاحمر","الاصفر","الاخضر","الازرق"][turn]} - اللي جنبه";
    });
  }

  Widget king(Color c,int p,int idx,bool onBoard){
    bool isTurn=turn==p &&!canRoll;
    // لو فيه اكتر من ملك في نفس الخانة - زحزحة بسيطة عشان ميختفوش
    int sameSpot=0;
    int pos=tokens[p][idx];
    for(int i=0;i<4;i++){ if(i!=idx && tokens[p][i]==pos && pos!=-1) sameSpot++; }
    double offset = sameSpot*6.0;
    return Transform.translate(
      offset: Offset(offset, offset),
      child: GestureDetector(
        onTap: ()=>move(p,idx),
        child: Container(
          width: onBoard?28:36, height: onBoard?28:36,
          decoration: BoxDecoration(shape: BoxShape.circle, color: c, border: Border.all(color: isTurn? Colors.white : Colors.white70, width: isTurn?3:2), boxShadow: [BoxShadow(color: Colors.black54, blurRadius:3)]),
          child: Center(child: Text("♔", style: TextStyle(fontSize: onBoard?13:18, color: Colors.white, fontWeight: FontWeight.bold))),
        ),
      ),
    );
  }

  Widget chatSection(){
    List<String> current = chatTab==0? gameChat : friendsChat;
    return Container(
      padding: EdgeInsets.all(6),
      color: Color(0xFF0A0A2A),
      child: Column(children: [
        Row(children: [
          GestureDetector(onTap: ()=>setState(()=>chatTab=0), child: Container(padding: EdgeInsets.symmetric(horizontal:12, vertical:5), decoration: BoxDecoration(color: chatTab==0? Color(0xFFFFD700): Colors.white10, borderRadius: BorderRadius.circular(14)), child: Row(children: [Icon(Icons.groups, size:14, color: chatTab==0? Colors.black: Colors.white54), SizedBox(width:4), Text("شات اللاعبين", style: TextStyle(fontSize:10, color: chatTab==0? Colors.black: Colors.white70, fontWeight: FontWeight.bold))]))),
          SizedBox(width:6),
          GestureDetector(onTap: ()=>setState(()=>chatTab=1), child: Container(padding: EdgeInsets.symmetric(horizontal:12, vertical:5), decoration: BoxDecoration(color: chatTab==1? Color(0xFF3DD4C0): Colors.white10, borderRadius: BorderRadius.circular(14)), child: Row(children: [Icon(Icons.person, size:14, color: chatTab==1? Colors.black: Colors.white54), SizedBox(width:4), Text("شات الأصدقاء الخاص", style: TextStyle(fontSize:10, color: chatTab==1? Colors.black: Colors.white70, fontWeight: FontWeight.bold))]))),
          Spacer(),
          Text(chatTab==0?"4 Online":"3 أصدقاء", style: TextStyle(color: Colors.white38, fontSize:9)),
        ]),
        SizedBox(height:5),
        Container(height:32, child: ListView.builder(scrollDirection: Axis.horizontal, itemCount: current.length, itemBuilder: (_,i)=>Container(margin: EdgeInsets.only(right:6), padding: EdgeInsets.symmetric(horizontal:10, vertical:6), decoration: BoxDecoration(color: chatTab==0? Colors.white10: Color(0xFF3DD4C0).withOpacity(0.15), borderRadius: BorderRadius.circular(12)), child: Text(current[i], style: TextStyle(color: Colors.white70, fontSize:10))))),
        SizedBox(height:6),
        Row(children: [
          Container(width:38,height:38, decoration: BoxDecoration(color: Colors.white24, shape: BoxShape.circle), child: Icon(Icons.mic, color: Colors.white, size:18)),
          SizedBox(width:5),
          Container(width:38,height:38, decoration: BoxDecoration(color: Color(0xFFFFC93C), borderRadius: BorderRadius.circular(10)), child: Center(child: Text("$dice", style: TextStyle(fontWeight: FontWeight.bold)))),
          SizedBox(width:5),
          Expanded(child: Container(height:38, decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white24)), child: Row(children: [
            SizedBox(width:10),
            Expanded(child: TextField(controller: chatCtrl, style: TextStyle(color: Colors.white, fontSize:12), decoration: InputDecoration(hintText: chatTab==0?"شات اللعبة...":"شات خاص للأصدقاء...", hintStyle: TextStyle(color: Colors.white38, fontSize:10), border: InputBorder.none))),
            IconButton(icon: Icon(Icons.emoji_emotions, color: Colors.amber, size:18), onPressed: (){ setState((){ if(chatTab==0) gameChat.add("😂🔥👑"); else friendsChat.add("Me: 😂🔥"); }); }),
          ]))),
          SizedBox(width:5),
          GestureDetector(onTap: (){ if(chatCtrl.text.isNotEmpty){ setState((){ if(chatTab==0) gameChat.add("Me: ${chatCtrl.text}"); else friendsChat.add("Me: ${chatCtrl.text}"); }); chatCtrl.clear(); } }, child: Container(width:38,height:38, decoration: BoxDecoration(color: chatTab==0? Color(0xFFD4AF37): Color(0xFF3DD4C0), shape: BoxShape.circle), child: Icon(Icons.send, color: Colors.black, size:16))),
        ]),
      ]),
    );
  }

  @override Widget build(BuildContext context){
    Color red=Color(0xFFE53935), yellow=Color(0xFFFBC02D), green=Color(0xFF43A047), blue=Color(0xFF1E88E5);
    List<Color> cols=[red,yellow,green,blue];
    double size=MediaQuery.of(context).size.width-10;
    double cell=size/15;
    return Scaffold(
      backgroundColor: Color(0xFF0D1B4A),
      body: Container(
        decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF0D1B4A), Color(0xFF1A237E)])),
        child: SafeArea(child: Column(children: [
          Padding(padding: EdgeInsets.all(6), child: Container(padding: EdgeInsets.symmetric(horizontal:10, vertical:5), decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.amber)), child: Text(msg, style: TextStyle(color: Colors.white, fontSize:11, fontWeight: FontWeight.bold)))),
          Expanded(child: Center(child: Container(
            width: size, height: size,
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(color: Color(0xFF4E342E), borderRadius: BorderRadius.circular(12), border: Border.all(color: Color(0xFFD4AF37), width:3)),
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
                  else if(r==7&&c>=1&&c<=5) bg=red.withOpacity(0.9);
                  else if(r==7&&c>=9&&c<=13) bg=green.withOpacity(0.7);
                  else if(c==7&&r>=1&&r<=5) bg=yellow.withOpacity(0.7);
                  else if(c==7&&r>=9&&r<=13) bg=blue.withOpacity(0.7);
                  else if(r>=6&&r<=8&&c>=6&&c<=8) bg=Color(0xFFFFD54F);
                  Widget? ch; int pIdx=path.indexWhere((e)=>e.dx==r&&e.dy==c);
                  if(safe.contains(pIdx)) ch=Text("★", style: TextStyle(fontSize: cell*0.35));
                  return Container(decoration: BoxDecoration(color: bg, border: Border.all(color: Colors.black12, width:0.3)), child: Center(child: ch));
                })),
           ...List.generate(4, (p)=>List.generate(4, (t){
                  int bp=tokens[p][t]; double x,y;
                  if(bp==-1){
                    if(p==0){ x=(t%2==0?1:3.1)*cell; y=(t<2?1:3.1)*cell; }
                    else if(p==1){ x=(t%2==0?1:3.1)*cell; y=(t<2?10:12.1)*cell; }
                    else if(p==2){ x=(t%2==0?10:12.1)*cell; y=(t<2?1:3.1)*cell; }
                    else{ x=(t%2==0?10:12.1)*cell; y=(t<2?10:12.1)*cell; }
                  }else if(bp>=100){ x=6.5*cell; y=6.5*cell; }
                  else if(homeCoords.containsKey(bp)){ var pt=homeCoords[bp]!; x=pt.dy*cell; y=pt.dx*cell; }
                  else{ var pt=path[bp%52]; x=pt.dy*cell; y=pt.dx*cell; }
                  return Positioned(left: x, top: y, child: king(cols[p], p, t, bp!=-1));
                })).expand((e)=>e),
                // زر ROLL عائم كبرته 20%
                if(canRoll) Center(child: GestureDetector(onTap: roll, child: Container(width: 106, height: 106, decoration: BoxDecoration(shape: BoxShape.circle, gradient: RadialGradient(colors: [Color(0xFFFFD700), Color(0xFFFF6F00)]), border: Border.all(color: Colors.white, width:3), boxShadow: [BoxShadow(blurRadius:12, color: Colors.black54)]), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text("$dice", style: TextStyle(fontSize:36, fontWeight: FontWeight.bold)), Text("ROLL", style: TextStyle(fontWeight: FontWeight.bold, fontSize:14))])))),
              ]),
            ),
          ))),
          chatSection(),
        ])),
      ),
    );
  }
}

// ==================== كيرم ====================
class CarromFull extends StatefulWidget {
  @override State<CarromFull> createState()=>_CarromFullState();
}
class _CarromFullState extends State<CarromFull> {
  List<CarromPiece> pieces=[];
  CarromPiece striker=CarromPiece(Offset(0.5,0.8), Color(0xFFE91E63), false, isStriker:true);
  int turn=0;
  Offset? dragStart, dragEnd;
  Timer? timer;
  int chatTab=0;
  List<String> gameChat=["P1: حلوة 🔥","P2: دوري"];
  List<String> friendsChat=["Mona: تعالو كيرم","Ali: ثواني وجاي"];
  TextEditingController chatCtrl=TextEditingController();

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
        if(p.vel.distance<0.002) p.vel=Offset.zero;
        if(p.pos.dx<0.06||p.pos.dx>0.94){ p.vel=Offset(-p.vel.dx*0.85, p.vel.dy); p.pos=Offset(p.pos.dx.clamp(0.06,0.94), p.pos.dy); }
        if(p.pos.dy<0.06||p.pos.dy>0.94){ p.vel=Offset(p.vel.dx, -p.vel.dy*0.85); p.pos=Offset(p.pos.dx, p.pos.dy.clamp(0.06,0.94)); }
      }
      for(int i=0;i<pieces.length;i++){
        for(int j=i+1;j<pieces.length;j++){
          Offset delta=pieces[i].pos-pieces[j].pos;
          double d=delta.distance;
          if(d<0.062 && d>0.001){
            Offset normal=delta/d;
            double v1n=pieces[i].vel.dx*normal.dx + pieces[i].vel.dy*normal.dy;
            double v2n=pieces[j].vel.dx*normal.dx + pieces[j].vel.dy*normal.dy;
            double dv=v1n-v2n;
            if(dv<0){
              pieces[i].vel-=normal*dv*0.9;
              pieces[j].vel+=normal*dv*0.9;
            }
            double overlap=0.062-d;
            pieces[i].pos+=normal*overlap*0.5;
            pieces[j].pos-=normal*overlap*0.5;
          }
        }
        Offset ds=pieces[i].pos-striker.pos;
        double d=ds.distance;
        if(d<0.07 && d>0.001){
          Offset normal=ds/d;
          double v1n=pieces[i].vel.dx*normal.dx + pieces[i].vel.dy*normal.dy;
          double v2n=striker.vel.dx*normal.dx + striker.vel.dy*normal.dy;
          double dv=v1n-v2n;
          if(dv<0){
            pieces[i].vel-=normal*dv;
            striker.vel+=normal*dv;
          }
        }
      }
      bool scored=false;
      pieces.removeWhere((p){
        bool inHole=(p.pos-Offset(0.06,0.06)).distance<=0.065||(p.pos-Offset(0.94,0.06)).distance<=0.065||(p.pos-Offset(0.06,0.94)).distance<=0.065||(p.pos-Offset(0.94,0.94)).distance<=0.065;
        if(inHole) scored=true;
        return inHole;
      });
      if(scored && pieces.every((e)=>e.vel==Offset.zero) && striker.vel==Offset.zero){
        turn=(turn+1)%2;
        striker.pos=Offset(0.5, turn==0?0.8:0.2);
      }
    });
  }

  @override void dispose(){ timer?.cancel(); super.dispose(); }

  Widget chatSection(){
    List<String> current = chatTab==0? gameChat : friendsChat;
    return Container(
      padding: EdgeInsets.all(6),
      color: Color(0xFF0A0A2A),
      child: Column(children: [
        Row(children: [
          GestureDetector(onTap: ()=>setState(()=>chatTab=0), child: Container(padding: EdgeInsets.symmetric(horizontal:12, vertical:5), decoration: BoxDecoration(color: chatTab==0? Color(0xFFFFD700): Colors.white10, borderRadius: BorderRadius.circular(14)), child: Row(children: [Icon(Icons.sports_esports, size:14, color: chatTab==0? Colors.black: Colors.white54), SizedBox(width:4), Text("شات اللاعبين", style: TextStyle(fontSize:10, color: chatTab==0? Colors.black: Colors.white70))]))),
          SizedBox(width:6),
          GestureDetector(onTap: ()=>setState(()=>chatTab=1), child: Container(padding: EdgeInsets.symmetric(horizontal:12, vertical:5), decoration: BoxDecoration(color: chatTab==1? Color(0xFF3DD4C0): Colors.white10, borderRadius: BorderRadius.circular(14)), child: Row(children: [Icon(Icons.lock, size:12, color: chatTab==1? Colors.black: Colors.white54), SizedBox(width:4), Text("شات الأصدقاء الخاص", style: TextStyle(fontSize:10, color: chatTab==1? Colors.black: Colors.white70))]))),
          Spacer(),
          Text(chatTab==0?"2 لاعبين":"خاص 🔒", style: TextStyle(color: Colors.white38, fontSize:9)),
        ]),
        SizedBox(height:5),
        Container(height:32, child: ListView.builder(scrollDirection: Axis.horizontal, itemCount: current.length, itemBuilder: (_,i)=>Container(margin: EdgeInsets.only(right:6), padding: EdgeInsets.symmetric(horizontal:10, vertical:6), decoration: BoxDecoration(color: chatTab==0? Colors.white10: Color(0xFF3DD4C0).withOpacity(0.15), borderRadius: BorderRadius.circular(12)), child: Text(current[i], style: TextStyle(color: Colors.white70, fontSize:10))))),
        SizedBox(height:6),
        Row(children: [
          Container(width:38,height:38, decoration: BoxDecoration(color: Colors.white24, shape: BoxShape.circle), child: Icon(Icons.mic, color: Colors.white, size:18)),
          SizedBox(width:5),
          Expanded(child: Container(height:38, decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white24)), child: Row(children: [
            SizedBox(width:10),
            Expanded(child: TextField(controller: chatCtrl, style: TextStyle(color: Colors.white, fontSize:12), decoration: InputDecoration(hintText: chatTab==0?"شات اللعبة...":"شات خاص...", hintStyle: TextStyle(color: Colors.white38, fontSize:10), border: InputBorder.none))),
            IconButton(icon: Icon(Icons.emoji_emotions, color: Colors.amber, size:18), onPressed: (){ setState((){ if(chatTab==0) gameChat.add("😂"); else friendsChat.add("😂"); }); }),
          ]))),
          SizedBox(width:5),
          GestureDetector(onTap: (){ if(chatCtrl.text.isNotEmpty){ setState((){ if(chatTab==0) gameChat.add("Me: ${chatCtrl.text}"); else friendsChat.add("Me: ${chatCtrl.text}"); }); chatCtrl.clear(); } }, child: Container(width:38,height:38, decoration: BoxDecoration(color: chatTab==0? Color(0xFFD4AF37): Color(0xFF3DD4C0), shape: BoxShape.circle), child: Icon(Icons.send, color: Colors.black, size:16))),
        ]),
      ]),
    );
  }

  @override Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color(0xFF1A0F08),
      body: SafeArea(child: Column(children: [
        Container(padding: EdgeInsets.symmetric(horizontal:12, vertical:6), color: Color(0xFF2B1A0E), child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Column(children: [Container(padding: EdgeInsets.all(2), decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: turn==0? Colors.amber: Colors.transparent, width:2)), child: CircleAvatar(radius:16, backgroundColor: Colors.white, child: Text("P1", style: TextStyle(fontSize:9)))), Text("لاعب 1", style: TextStyle(color: turn==0? Colors.amber: Colors.white54, fontSize:9))]),
          Text("VS", style: TextStyle(color: Colors.white24)),
          Column(children: [Container(padding: EdgeInsets.all(2), decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: turn==1? Colors.amber: Colors.transparent, width:2)), child: CircleAvatar(radius:16, backgroundColor: Colors.black, child: Text("P2", style: TextStyle(color: Colors.white, fontSize:9)))), Text("لاعب 2", style: TextStyle(color: turn==1? Colors.amber: Colors.white54, fontSize:9))]),
        ])),
        Expanded(child: Center(child: LayoutBuilder(builder: (ctx,cons){
          double size=math.min(cons.maxWidth-20, cons.maxHeight-20);
          return GestureDetector(
            onPanStart: (d){ dragStart=Offset(d.localPosition.dx/size, d.localPosition.dy/size); },
            onPanUpdate: (d){ dragEnd=Offset(d.localPosition.dx/size, d.localPosition.dy/size); setState((){}); },
            onPanEnd: (_){
              if(dragStart!=null&&dragEnd!=null){
                // صلحت الاتجاه - دلوقتي يسحب لقدام يضرب لقدام
                Offset dir=dragEnd!-dragStart!;
                if(dir.distance>0.02) striker.vel=dir*14;
              }
              dragStart=null; dragEnd=null; setState((){});
            },
            child: Container(
              width: size, height: size,
              decoration: BoxDecoration(color: Color(0xFFF5D6A0), border: Border.all(color: Color(0xFFD4AF37), width:8), borderRadius: BorderRadius.circular(4)),
              child: Stack(children: [
                Positioned(left:4,top:4, child: Container(width:26,height:26, decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle, border: Border.all(color: Color(0xFFFFD700), width:2)))),
                Positioned(right:4,top:4, child: Container(width:26,height:26, decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle, border: Border.all(color: Color(0xFFFFD700), width:2)))),
                Positioned(left:4,bottom:4, child: Container(width:26,height:26, decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle, border: Border.all(color: Color(0xFFFFD700), width:2)))),
                Positioned(right:4,bottom:4, child: Container(width:26,height:26, decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle, border: Border.all(color: Color(0xFFFFD700), width:2)))),
                CustomPaint(size: Size(size,size), painter: CarromLinesPainter()),
            ...pieces.map((pc)=>Positioned(left: pc.pos.dx*size-15, top: pc.pos.dy*size-15, child: Container(width:30,height:30, decoration: BoxDecoration(color: pc.color, shape: BoxShape.circle, border: Border.all(color: Colors.white, width:2)), child: pc.isQueen? Center(child: Text("★", style: TextStyle(color: Colors.yellow, fontSize:14))): null))),
                Positioned(left: striker.pos.dx*size-18, top: striker.pos.dy*size-18, child: Container(width:36,height:36, decoration: BoxDecoration(color: striker.color, shape: BoxShape.circle, border: Border.all(color: Colors.white, width:3)), child: Icon(Icons.adjust, color: Colors.white, size:16))),
                if(dragStart!=null&&dragEnd!=null) CustomPaint(size: Size(size,size), painter: AimPainter(dragStart!*size, dragEnd!*size)),
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
    var p=Paint()..color=Colors.brown.withOpacity(0.3)..strokeWidth=1..style=PaintingStyle.stroke;
    canvas.drawCircle(Offset(size.width/2, size.height/2), 18, p);
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
  }
  @override bool shouldRepaint(covariant CustomPainter old)=>true;
}
