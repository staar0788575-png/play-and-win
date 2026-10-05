import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';
import 'package:flutter/services.dart';

void main() {
  runApp(const MaterialApp(home: GameHub(), debugShowCheckedModeBanner: false));
}

class SoundManager {
  static void dice() { HapticFeedback.mediumImpact(); }
  static void move() { HapticFeedback.lightImpact(); }
  static void capture() { HapticFeedback.heavyImpact(); }
  static void win() { HapticFeedback.vibrate(); }
  static void hit() { HapticFeedback.selectionClick(); }
  static void pot() { HapticFeedback.lightImpact(); }
}

// عشان نصلح Error: Couldn't find constructor 'CarromProFull' و 'SnakeLadderFull'
class CarromProFull extends CarromProLikeImage { const CarromProFull({super.key}); }
class SnakeLadderFull extends SnakeLadderRoyal { const SnakeLadderFull({super.key}); }

class CarromPiece {
  Offset pos; Color color; bool isWhite; bool isQueen; bool isStriker; Offset vel;
  CarromPiece(this.pos, this.color, this.isWhite, {this.isQueen = false, this.isStriker = false}) : vel = Offset.zero;
}

class CarromImagePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = const Color(0xFF8D6E63).withOpacity(0.7)..style = PaintingStyle.stroke..strokeWidth = 1.5;
    double inset = size.width * 0.14;
    RRect r = RRect.fromRectAndRadius(Rect.fromLTWH(inset, inset, size.width - inset * 2, size.height - inset * 2), const Radius.circular(32));
    canvas.drawRRect(r, p);
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class AimPainter extends CustomPainter {
  final Offset from; final Offset to; final double power;
  AimPainter(this.from, this.to, this.power);
  @override void paint(Canvas c, Size s) {
    var p = Paint()..color = const Color(0xE6FFFFFF)..strokeWidth = 3..style = PaintingStyle.stroke;
    c.drawLine(from, to, p);
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class GameHub extends StatefulWidget {
  const GameHub({super.key});
  @override State<GameHub> createState() => _GameHubState();
}
class _GameHubState extends State<GameHub> {
  int tab = 0;
  @override
  Widget build(BuildContext context) {
    Widget body;
    if (tab == 0) { body = const LudoRoyalFull(); }
    else if (tab == 1) { body = const CarromProFull(); }
    else { body = const SnakeLadderFull(); }
    return Scaffold(
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: tab,
        onTap: (i) { setState(() { tab = i; }); },
        backgroundColor: const Color(0xFF0A1931),
        selectedItemColor: const Color(0xFFFFD700),
        unselectedItemColor: Colors.white54,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.casino), label: "لودو"),
          BottomNavigationBarItem(icon: Icon(Icons.circle), label: "كيرم"),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: "سلم"),
        ],
      ),
    );
  }
}

// ================= LUDO FULL =================
class LudoRoyalFull extends StatefulWidget {
  const LudoRoyalFull({super.key});
  @override State<LudoRoyalFull> createState() => _LudoRoyalFullState();
}
class _LudoRoyalFullState extends State<LudoRoyalFull> {
  int dice = 6; int turn = 0; int winner = -1; int countdown = 10;
  bool canRoll = true; bool gameOver = false; bool micOn = true; bool privateMode = false;
  String msg = "جبت 6"; String flyingEmoji = ""; String selectedGift = "";
  List<List<int>> tokens = [[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1]];
  List<int> start = [0,39,13,26];
  List<int> safe = [0,8,13,21,26,34,39,47];
  List<List<int>> homePath = [[52,53,54,55,56,57],[58,59,60,61,62,63],[64,65,66,67,68,69],[70,71,72,73,74,75]];
  List<String> publicChat = ["P3: عاش 💪","Me: السلام عليكم","P1: يلا نلعب 👑"];
  List<String> privateChat = ["P1 خاص: يلا"];
  List<String> gifts = ["❤️","🌹","👑","🚗","🦁","💎"];
  List<String> emojis = ["😂","😡","😍","👏","🎉","🔥"];
  TextEditingController chatCtrl = TextEditingController();
  Timer? countdownTimer;
  List<Offset> path = [const Offset(6,1),const Offset(6,2),const Offset(6,3),const Offset(6,4),const Offset(6,5),const Offset(5,6),const Offset(4,6),const Offset(3,6),const Offset(2,6),const Offset(1,6),const Offset(0,6),const Offset(0,7),const Offset(0,8),const Offset(1,8),const Offset(2,8),const Offset(3,8),const Offset(4,8),const Offset(5,8),const Offset(6,9),const Offset(6,10),const Offset(6,11),const Offset(6,12),const Offset(6,13),const Offset(6,14),const Offset(7,14),const Offset(8,14),const Offset(8,13),const Offset(8,12),const Offset(8,11),const Offset(8,10),const Offset(8,9),const Offset(9,8),const Offset(10,8),const Offset(11,8),const Offset(12,8),const Offset(13,8),const Offset(14,8),const Offset(14,7),const Offset(14,6),const Offset(13,6),const Offset(12,6),const Offset(11,6),const Offset(10,6),const Offset(9,6),const Offset(8,5),const Offset(8,4),const Offset(8,3),const Offset(8,2),const Offset(8,1),const Offset(8,0),const Offset(7,0),const Offset(6,0)];
  Map<int,Offset> homeC = {52:const Offset(7,1),53:const Offset(7,2),54:const Offset(7,3),55:const Offset(7,4),56:const Offset(7,5),57:const Offset(7,6),58:const Offset(13,7),59:const Offset(12,7),60:const Offset(11,7),61:const Offset(10,7),62:const Offset(9,7),63:const Offset(8,7),64:const Offset(1,7),65:const Offset(2,7),66:const Offset(3,7),67:const Offset(4,7),68:const Offset(5,7),69:const Offset(6,7),70:const Offset(7,13),71:const Offset(7,12),72:const Offset(7,11),73:const Offset(7,10),74:const Offset(7,9),75:const Offset(7,8)};

  void checkWin(){ for(int p=0;p<4;p++){ if(tokens[p].every((e)=>e==100)){ setState((){ gameOver=true; winner=p; countdown=10; }); SoundManager.win(); startCountdown(); break; } } }
  void startCountdown(){ countdownTimer?.cancel(); countdownTimer=Timer.periodic(const Duration(seconds:1),(t){ if(!mounted) return; setState((){ countdown--; }); if(countdown<=0){ t.cancel(); resetGame(); } }); }
  void resetGame(){ setState((){ tokens=[[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1]]; turn=0; dice=6; canRoll=true; msg="جيم جديد"; gameOver=false; winner=-1; countdown=10; }); }
  void roll(){ if(!canRoll||gameOver) return; setState((){ dice=math.Random().nextInt(6)+1; canRoll=false; msg="جبت $dice"; }); SoundManager.dice(); bool can=false; for(int tt in tokens[turn]){ if(tt==-1&&dice==6) can=true; if(tt>=0) can=true; } if(!can){ Future.delayed(const Duration(milliseconds:800),(){ if(mounted){ setState((){ turn=(turn+1)%4; canRoll=true; }); } }); } }
  void moveToken(int p,int idx){ if(p!=turn||canRoll||gameOver) return; int cur=tokens[p][idx]; if(cur==-1&&dice!=6) return; bool cap=false; setState((){ if(cur==-1){ tokens[p][idx]=start[p]; } else if(cur>=0&&cur<52){ int entry=(start[p]+51)%52; int next=cur+dice; if(cur<=entry&&next>entry){ int h=next-entry-1; if(h<6) tokens[p][idx]=homePath[p][h]; else if(h==6) tokens[p][idx]=100; else tokens[p][idx]=next%52; } else { tokens[p][idx]=next%52; } } else if(cur>=52){ int hi=homePath[p].indexOf(cur); if(hi!=-1){ if(hi+dice<6) tokens[p][idx]=homePath[p][hi+dice]; else if(hi+dice==6) tokens[p][idx]=100; } } int pos=tokens[p][idx]; if(pos>=0&&pos<52&&!safe.contains(pos)){ for(int op=0;op<4;op++){ if(op==p) continue; for(int oi=0;oi<4;oi++){ if(tokens[op][oi]==pos){ tokens[op][oi]=-1; cap=true; } } } } if(dice!=6) turn=(turn+1)%4; canRoll=true; }); if(cap) SoundManager.capture(); else SoundManager.move(); checkWin(); }
  void sendChat(){ if(chatCtrl.text.trim().isEmpty) return; setState((){ if(privateMode){ privateChat.add("Me خاص: ${chatCtrl.text.trim()}"); } else { publicChat.add("Me: ${chatCtrl.text.trim()}"); } chatCtrl.clear(); }); }
  void sendEmoji(String e){ setState((){ flyingEmoji=e; }); Future.delayed(const Duration(seconds:2),(){ if(mounted) setState((){ flyingEmoji=""; }); }); }
  void sendGift(String g){ setState((){ selectedGift=g; }); SoundManager.win(); Future.delayed(const Duration(seconds:2),(){ if(mounted) setState((){ selectedGift=""; }); }); }
  @override void dispose(){ countdownTimer?.cancel(); chatCtrl.dispose(); super.dispose(); }
  @override Widget build(BuildContext context){
    Color red=const Color(0xFFE53935); Color green=const Color(0xFF43A047); Color yellow=const Color(0xFFFBC02D); Color blue=const Color(0xFF1E88E5);
    List<Color> cols=[red,yellow,green,blue];
    double boardSize=MediaQuery.of(context).size.width-8;
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B4A),
      body: SafeArea(child: Column(children:[
        Container(margin: const EdgeInsets.all(8),padding: const EdgeInsets.symmetric(horizontal:14,vertical:10),decoration: BoxDecoration(color: const Color(0xFF2A3A8C),borderRadius: BorderRadius.circular(16)),child: Row(children:[const Icon(Icons.visibility,color: Colors.amber,size:18), const SizedBox(width:8), const Text("غرفة انتظار الأصدقاء - لودو 👀",style: TextStyle(color: Colors.white,fontSize:12,fontWeight: FontWeight.bold)), const Spacer(), GestureDetector(onTap:(){ setState((){ micOn=!micOn; }); },child: Icon(micOn?Icons.mic:Icons.mic_off,color: micOn?Colors.greenAccent:Colors.redAccent,size:18))])),
        Expanded(child: Center(child: Container(width: boardSize,height: boardSize,padding: const EdgeInsets.all(4),decoration: BoxDecoration(border: Border.all(color: const Color(0xFFFFD700),width:5),color: const Color(0xFF3E2723),borderRadius: BorderRadius.circular(8)),child: LayoutBuilder(builder: (c,cons){ double s=cons.maxWidth; double ce=s/15; List<Widget> tW=[]; for(int p=0;p<4;p++){ for(int t=0;t<4;t++){ int bp=tokens[p][t]; double cx; double cy; double sz=ce*0.78; if(bp==-1){ cx=(t%2==0?1.5:3.5)*ce; cy=(t<2?1.5:3.5)*ce; if(p==1) cy=(t<2?10.5:12.5)*ce; if(p==2) cx=(t%2==0?10.5:12.5)*ce; if(p==3){ cx=(t%2==0?10.5:12.5)*ce; cy=(t<2?10.5:12.5)*ce; } } else if(bp>=100){ cx=7.5*ce; cy=7.5*ce; } else if(homeC.containsKey(bp)){ var pt=homeC[bp]!; cx=pt.dy*ce+ce/2; cy=pt.dx*ce+ce/2; } else { var pt=path[bp%52]; cx=pt.dy*ce+ce/2; cy=pt.dx*ce+ce/2; } tW.add(Positioned(left:cx-sz/2,top:cy-sz/2,child: GestureDetector(onTap:(){ moveToken(p,t); },child: Container(width:sz,height:sz,decoration: BoxDecoration(shape: BoxShape.circle,color: cols[p],border: Border.all(color: Colors.white,width:2)),child: Center(child: Text("♔",style: TextStyle(color: Colors.white,fontSize:sz*0.6))))))); } } List<Widget> gridCells = List.generate(225,(i){ int r=i~/15; int co=i%15; Color bg=const Color(0xFFFFF8E1); if(r<6&&co<6) bg=red; else if(r<6&&co>8) bg=green; else if(r>8&&co<6) bg=yellow; else if(r>8&&co>8) bg=blue; else if(r==7&&co>=1&&co<=5) bg=red.withOpacity(0.85); else if(r==7&&co>=9&&co<=13) bg=green.withOpacity(0.65); else if(co==7&&r>=1&&r<=5) bg=yellow.withOpacity(0.65); else if(co==7&&r>=9&&r<=13) bg=blue.withOpacity(0.65); else if(r>=6&&r<=8&&co>=6&&co<=8) bg=const Color(0xFFFFD54F); Widget? ch; int pIdx=path.indexWhere((e)=>e.dx==r&&e.dy==co); if(safe.contains(pIdx)) ch=Text("★",style: TextStyle(fontSize:ce*0.5)); return Container(decoration: BoxDecoration(color:bg,border: Border.all(color: Colors.black12,width:0.3)),child: Center(child:ch)); }); return Stack(children: [ GridView.count(crossAxisCount:15,physics: const NeverScrollableScrollPhysics(),padding: EdgeInsets.zero,children: gridCells),...tW, if(flyingEmoji.isNotEmpty) Center(child: Text(flyingEmoji,style: const TextStyle(fontSize:60))), if(selectedGift.isNotEmpty) Center(child: Container(padding: const EdgeInsets.all(12),decoration: BoxDecoration(color: const Color(0xCC000000),borderRadius: BorderRadius.circular(16)),child: Text(selectedGift,style: const TextStyle(fontSize:40)))), if(canRoll&&!gameOver) Center(child: GestureDetector(onTap:roll,child: Container(width:106,height:106,decoration: BoxDecoration(shape: BoxShape.circle,gradient: const RadialGradient(colors:[Color(0xFFFFD700),Color(0xFFFF6F00)]),border: Border.all(color: Colors.white,width:3)),child: Column(mainAxisAlignment: MainAxisAlignment.center,children:[Text("$dice",style: const TextStyle(fontSize:38,fontWeight: FontWeight.bold)), const Text("ROLL",style: TextStyle(fontWeight: FontWeight.bold))])))), if(gameOver) Container(color: const Color(0x99000000),child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,children:[const Icon(Icons.emoji_events,color: Color(0xFFFFD700),size:70), Text("اللاعب ${winner+1} فاز",style: const TextStyle(color: Colors.white,fontSize:22)), const SizedBox(height:20), Text("$countdown",style: const TextStyle(color: Colors.white,fontSize:36)),]))), ]); })))),
        // ==== هنا كان الخطأ - تم اصلاح ListView.builder ====
        Container(
          height: 70,
          margin: const EdgeInsets.symmetric(horizontal:8,vertical:4),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(color: const Color(0xFF1A2A6A),borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(onTap:(){ setState((){ privateMode=false; }); },child: Container(padding: const EdgeInsets.symmetric(horizontal:10,vertical:4),decoration: BoxDecoration(color:!privateMode?const Color(0xFFFFD700):const Color(0xFF2A3A8C),borderRadius: BorderRadius.circular(12)),child: Text("عام",style: TextStyle(color:!privateMode?Colors.black:Colors.white,fontSize:11)))),
                  const SizedBox(width:6),
                  GestureDetector(onTap:(){ setState((){ privateMode=true; }); },child: Container(padding: const EdgeInsets.symmetric(horizontal:10,vertical:4),decoration: BoxDecoration(color:privateMode?const Color(0xFFFFD700):const Color(0xFF2A3A8C),borderRadius: BorderRadius.circular(12)),child: Text("خاص",style: TextStyle(color:privateMode?Colors.black:Colors.white,fontSize:11)))),
                  const Spacer(),
                  Row(children: List.generate(gifts.length,(index){ String g=gifts[index]; return GestureDetector(onTap:(){ sendGift(g); },child: Container(margin: const EdgeInsets.symmetric(horizontal:2),padding: const EdgeInsets.all(4),decoration: BoxDecoration(color: const Color(0x33FFFFFF),borderRadius: BorderRadius.circular(8)),child: Text(g,style: const TextStyle(fontSize:14)))); })),
                ],
              ),
              const SizedBox(height:4),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: privateMode? privateChat.length : publicChat.length,
                  itemBuilder: (context, i) {
                    var list = privateMode? privateChat : publicChat;
                    return Container(
                      margin: const EdgeInsets.only(right:6),
                      padding: const EdgeInsets.symmetric(horizontal:8,vertical:2),
                      decoration: BoxDecoration(color: const Color(0xFF2A3A8C),borderRadius: BorderRadius.circular(10)),
                      child: Text(list[i],style: const TextStyle(color: Colors.white,fontSize:11)),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Container(padding: const EdgeInsets.symmetric(horizontal:8,vertical:4),child: Row(children:[Row(children: List.generate(emojis.length,(index){ String e=emojis[index]; return GestureDetector(onTap:(){ sendEmoji(e); },child: Container(margin: const EdgeInsets.only(right:4),padding: const EdgeInsets.all(6),decoration: const BoxDecoration(color: Color(0xFF2A3A8C),shape: BoxShape.circle),child: Text(e,style: const TextStyle(fontSize:16)))); })), const SizedBox(width:6), Expanded(child: TextField(controller:chatCtrl,style: const TextStyle(color: Colors.white,fontSize:12),decoration: InputDecoration(hintText:privateMode?"رسالة خاصة...":"اكتب رسالة...",filled:true,fillColor: const Color(0xFF2A3A8C),border: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide.none),contentPadding: const EdgeInsets.symmetric(horizontal:12,vertical:6)),onSubmitted:(_){ sendChat(); })), const SizedBox(width:6), GestureDetector(onTap:(){ sendChat(); },child: Container(padding: const EdgeInsets.all(8),decoration: const BoxDecoration(shape: BoxShape.circle,color: Color(0xFFFFD700)),child: const Icon(Icons.send,color: Colors.black,size:16)))])),
      ])),
    );
  }
}

// ================= CARROM FULL =================
class CarromProLikeImage extends StatefulWidget { const CarromProLikeImage({super.key}); @override State<CarromProLikeImage> createState()=>_CarromProState(); }
class _CarromProState extends State<CarromProLikeImage> {
  List<CarromPiece> pieces=[]; CarromPiece striker=CarromPiece(const Offset(0.5,0.82),const Color(0xFFFF1744),false,isStriker:true);
  Offset? dragStart; Offset? dragEnd; double power=0; Timer? timer; bool gameOver=false; int countdown=10; Timer? countdownTimer;
  @override void initState(){ super.initState(); resetCarrom(); timer=Timer.periodic(const Duration(milliseconds:16),(t){ updatePhysics(); }); }
  void resetCarrom(){ pieces=[ CarromPiece(const Offset(0.5,0.5),const Color(0xFF000000),false,isQueen:true), CarromPiece(const Offset(0.5,0.40),const Color(0xFFFFFDE7),true), CarromPiece(const Offset(0.43,0.43),const Color(0xFFFFF8E1),true), CarromPiece(const Offset(0.57,0.43),const Color(0xFFFFFDE7),true), CarromPiece(const Offset(0.38,0.50),const Color(0xFFFFF8E1),true), CarromPiece(const Offset(0.62,0.50),const Color(0xFFFFFDE7),true), CarromPiece(const Offset(0.43,0.57),const Color(0xFFFFF8E1),true), CarromPiece(const Offset(0.57,0.57),const Color(0xFFFFFDE7),true), CarromPiece(const Offset(0.5,0.60),const Color(0xFF3E2723),false), CarromPiece(const Offset(0.38,0.43),const Color(0xFF212121),false), CarromPiece(const Offset(0.62,0.43),const Color(0xFF3E2723),false), CarromPiece(const Offset(0.33,0.50),const Color(0xFF121212),false), CarromPiece(const Offset(0.67,0.50),const Color(0xFF3E2723),false), CarromPiece(const Offset(0.38,0.57),const Color(0xFF121212),false), CarromPiece(const Offset(0.62,0.57),const Color(0xFF000000),false) ]; striker=CarromPiece(const Offset(0.5,0.82),const Color(0xFFFF1744),false,isStriker:true); gameOver=false; countdown=10; }
  void checkWin(){ if(pieces.isEmpty&&!gameOver){ setState((){ gameOver=true; }); SoundManager.win(); startCountdown(); } }
  void startCountdown(){ countdownTimer?.cancel(); countdown=10; countdownTimer=Timer.periodic(const Duration(seconds:1),(t){ if(!mounted) return; setState((){ countdown--; }); if(countdown<=0){ t.cancel(); setState((){ resetCarrom(); }); } }); }
  void updatePhysics(){ if(!mounted||gameOver) return; setState((){ int before=pieces.length; List<CarromPiece> all=[...pieces,striker]; for(var p in all){ if(p.vel==Offset.zero) continue; p.pos+=p.vel*0.016; p.vel*=0.985; if(p.vel.distance<0.002) p.vel=Offset.zero; if(p.pos.dx<0.07||p.pos.dx>0.93){ p.vel=Offset(-p.vel.dx*0.85,p.vel.dy); p.pos=Offset(p.pos.dx.clamp(0.07,0.93),p.pos.dy); } if(p.pos.dy<0.07||p.pos.dy>0.93){ p.vel=Offset(p.vel.dx,-p.vel.dy*0.85); p.pos=Offset(p.pos.dx,p.pos.dy.clamp(0.07,0.93)); } } for(int i=0;i<pieces.length;i++){ for(int j=i+1;j<pieces.length;j++){ Offset d=pieces[i].pos-pieces[j].pos; double dist=d.distance; if(dist<0.064&&dist>0.001){ Offset n=d/dist; double dv=(pieces[i].vel.dx*n.dx+pieces[i].vel.dy*n.dy)-(pieces[j].vel.dx*n.dx+pieces[j].vel.dy*n.dy); if(dv<0){ pieces[i].vel-=n*dv*0.95; pieces[j].vel+=n*dv*0.95; } } } Offset ds=pieces[i].pos-striker.pos; double dist=ds.distance; if(dist<0.08&&dist>0.001){ Offset n=ds/dist; double dv=(pieces[i].vel.dx*n.dx+pieces[i].vel.dy*n.dy)-(striker.vel.dx*n.dx+striker.vel.dy*n.dy); if(dv<0){ pieces[i].vel-=n*dv*1.1; striker.vel+=n*dv*1.1; } } } pieces.removeWhere((p)=>(p.pos-const Offset(0.08,0.08)).distance<0.06||(p.pos-const Offset(0.92,0.08)).distance<0.06||(p.pos-const Offset(0.08,0.92)).distance<0.06||(p.pos-const Offset(0.92,0.92)).distance<0.06); if(pieces.length<before) SoundManager.pot(); }); checkWin(); }
  @override void dispose(){ timer?.cancel(); countdownTimer?.cancel(); super.dispose(); }
  @override Widget build(BuildContext context){
    return Scaffold(body: Container(decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter,end: Alignment.bottomCenter,colors:[Color(0xFF3A1A7A),Color(0xFF8B2E6E)])),child: SafeArea(child: Column(children:[
      Container(margin: const EdgeInsets.all(8),padding: const EdgeInsets.all(10),decoration: BoxDecoration(color: const Color(0xFF2A3A8C),borderRadius: BorderRadius.circular(16)),child: const Row(children:[Icon(Icons.visibility,color: Colors.amber,size:18), SizedBox(width:8), Text("كيرم 4 لاعبين - كامل",style: TextStyle(color: Colors.white,fontSize:12,fontWeight: FontWeight.bold)), Spacer(), Icon(Icons.mic,color: Colors.greenAccent)])),
      Expanded(child: Center(child: LayoutBuilder(builder: (ctx,cons){ double size=math.min(cons.maxWidth-12,cons.maxHeight*0.75); List<Widget> pieceWidgets = List.generate(pieces.length,(index){ var pc=pieces[index]; return Positioned(left:pc.pos.dx*size-16,top:pc.pos.dy*size-16,child: Container(width:32,height:32,decoration: BoxDecoration(shape: BoxShape.circle,border: Border.all(color: Colors.white,width: pc.isQueen?2.5:1.5),color: pc.isQueen?Colors.black:pc.isWhite?Colors.white:Colors.brown),child: pc.isQueen?const Center(child: Text("★",style: TextStyle(color: Colors.yellow))):null)); }); return GestureDetector(onPanStart: (d){ dragStart=Offset(d.localPosition.dx/size,d.localPosition.dy/size); },onPanUpdate: (d){ dragEnd=Offset(d.localPosition.dx/size,d.localPosition.dy/size); if(dragStart!=null&&dragEnd!=null){ power=(dragEnd!-dragStart!).distance.clamp(0,0.35); } setState((){}); },onPanEnd: (_){ if(dragStart!=null&&dragEnd!=null&&!gameOver){ Offset dir=dragEnd!-dragStart!; double pwr=dir.distance*20; if(pwr>0.5){ Offset norm=dir.distance==0?Offset.zero:dir/dir.distance; striker.vel=norm*pwr.clamp(0,10); SoundManager.hit(); } } dragStart=null; dragEnd=null; power=0; setState((){}); },child: Container(width:size,height:size,decoration: BoxDecoration(color: const Color(0xFFDEB887),borderRadius: BorderRadius.circular(22),border: Border.all(color: const Color(0xFFFFD700),width:4)),child: Stack(children:[ CustomPaint(size: Size(size,size),painter: CarromImagePainter()),...pieceWidgets, Positioned(left:striker.pos.dx*size-22,top:striker.pos.dy*size-22,child: Container(width:44,height:44,decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.pink,border: Border.all(color: Colors.white,width:3)))), if(dragStart!=null&&dragEnd!=null) CustomPaint(size: Size(size,size),painter: AimPainter(dragStart!*size,dragEnd!*size,power)), if(gameOver) Container(width:size,height:size,color: const Color(0xCC000000),child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,children:[const Icon(Icons.emoji_events,color: Color(0xFFFFD700),size:60), Text("$countdown",style: const TextStyle(color: Colors.white,fontSize:32)),]))), ]))); }))),
    ]))));
  }
}

// ================= SNAKE FULL =================
class SnakeLadderRoyal extends StatefulWidget { const SnakeLadderRoyal({super.key}); @override State<SnakeLadderRoyal> createState()=>_SnakeLadderState(); }
class _SnakeLadderState extends State<SnakeLadderRoyal> {
  int dice=1; int turn=0; int winner=-1; int countdown=10; bool canRoll=true; bool gameOver=false; bool micOn=true; bool privateMode=false;
  List<int> pos=[0,0,0,0];
  Map<int,int> snakes={99:54,70:55,52:42,56:8,43:17,50:5,27:5};
  Map<int,int> ladders={3:51,6:27,20:70,36:55,63:95,68:98};
  Timer? countdownTimer;
  TextEditingController chatCtrl = TextEditingController();
  List<String> publicChat = ["P2: يلا 😂","Me: هات سلم"];
  List<String> privateChat = ["P1 خاص: لا تديها لحد"];
  List<String> gifts = ["❤️","🌹","👑","🚗","🦁","💎"];
  List<String> emojis = ["😂","😡","😍","👏","🎉","🔥"];
  String flyingEmoji=""; String selectedGift="";
  void roll(){ if(!canRoll||gameOver) return; setState((){ dice=math.Random().nextInt(6)+1; canRoll=false; }); SoundManager.dice(); Future.delayed(const Duration(milliseconds:600),(){ movePlayer(); }); }
  void movePlayer(){ setState((){ int cur=pos[turn]; int next=cur+dice; if(next>100){ canRoll=true; turn=(turn+1)%4; return; } if(next==100){ pos[turn]=100; gameOver=true; winner=turn; countdown=10; SoundManager.win(); startCountdown(); return; } pos[turn]=next; if(snakes.containsKey(next)){ pos[turn]=snakes[next]!; SoundManager.capture(); } else if(ladders.containsKey(next)){ pos[turn]=ladders[next]!; SoundManager.move(); } if(dice!=6) turn=(turn+1)%4; canRoll=true; }); }
  void startCountdown(){ countdownTimer?.cancel(); countdownTimer=Timer.periodic(const Duration(seconds:1),(t){ if(!mounted) return; setState((){ countdown--; }); if(countdown<=0){ t.cancel(); resetGame(); } }); }
  void resetGame(){ setState((){ pos=[0,0,0,0]; turn=0; dice=1; canRoll=true; gameOver=false; winner=-1; countdown=10; }); }
  void sendChat(){ if(chatCtrl.text.trim().isEmpty) return; setState((){ if(privateMode){ privateChat.add("Me خاص: ${chatCtrl.text.trim()}"); } else { publicChat.add("Me: ${chatCtrl.text.trim()}"); } chatCtrl.clear(); }); }
  void sendEmoji(String e){ setState((){ flyingEmoji=e; }); Future.delayed(const Duration(seconds:2),(){ if(mounted) setState((){ flyingEmoji=""; }); }); }
  void sendGift(String g){ setState((){ selectedGift=g; }); SoundManager.win(); Future.delayed(const Duration(seconds:2),(){ if(mounted) setState((){ selectedGift=""; }); }); }
  Widget buildCell(int num){ bool isSnake=snakes.containsKey(num); bool isLadder=ladders.containsKey(num); Color bg=const Color(0xFFFFF8E1); if(isSnake) bg=const Color(0xFFFFCDD2); if(isLadder) bg=const Color(0xFFC8E6C9); List<int> playersHere=[]; for(int i=0;i<4;i++){ if(pos[i]==num) playersHere.add(i); } List<Widget> playerDots = List.generate(playersHere.length,(index){ int p=playersHere[index]; List<Color> c=[const Color(0xFFE53935),const Color(0xFFFBC02D),const Color(0xFF43A047),const Color(0xFF1E88E5)]; return Container(width:12,height:12,margin: const EdgeInsets.only(left:1),decoration: BoxDecoration(shape: BoxShape.circle,color:c[p]),child: Center(child: Text("${p+1}",style: const TextStyle(fontSize:8,color: Colors.white)))); }); return Container(decoration: BoxDecoration(color:bg,border: Border.all(color: Colors.black12,width:0.4)),child: Stack(children:[Positioned(top:2,left:4,child: Text("$num",style: const TextStyle(fontSize:9,fontWeight: FontWeight.bold))), if(isSnake) const Center(child: Text("🐍")), if(isLadder) const Center(child: Text("🪜")), if(playersHere.isNotEmpty) Positioned(bottom:2,right:2,child: Row(children: playerDots)) ])); }
  @override void dispose(){ countdownTimer?.cancel(); chatCtrl.dispose(); super.dispose(); }
  @override Widget build(BuildContext context){
    double size=MediaQuery.of(context).size.width-12;
    List<Color> cols=[const Color(0xFFE53935),const Color(0xFFFBC02D),const Color(0xFF43A047),const Color(0xFF1E88E5)];
    List<Widget> topPlayers = List.generate(4,(i){ return Expanded(child: Container(margin: const EdgeInsets.symmetric(horizontal:3),padding: const EdgeInsets.symmetric(vertical:6),decoration: BoxDecoration(color:turn==i?cols[i]:const Color(0xFF2A3A8C),borderRadius: BorderRadius.circular(20)),child: Column(children:[const Icon(Icons.person,color: Colors.white,size:18), Text("P${i+1}:${pos[i]}",style: const TextStyle(color: Colors.white,fontSize:10))]))); });
    return Scaffold(backgroundColor: const Color(0xFF0D1B4A),body: SafeArea(child: Column(children:[
      Container(margin: const EdgeInsets.all(8),padding: const EdgeInsets.all(10),decoration: BoxDecoration(color: const Color(0xFF2A3A8C),borderRadius: BorderRadius.circular(16)),child: Row(children:[const Icon(Icons.visibility,color: Colors.amber), const SizedBox(width:8), const Text("سلم وثعبان - P1:0 P2:0 👀",style: TextStyle(color: Colors.white,fontSize:12)), const Spacer(), GestureDetector(onTap:(){ setState((){ micOn=!micOn; }); },child: Icon(micOn?Icons.mic:Icons.mic_off,color: micOn?Colors.greenAccent:Colors.redAccent)) ])),
      Container(padding: const EdgeInsets.symmetric(horizontal:12,vertical:6),child: Row(children: topPlayers)),
      Expanded(child: Center(child: Container(width:size,height:size,decoration: BoxDecoration(border: Border.all(color: const Color(0xFFFFD700),width:4)),child: Stack(children:[
        GridView.builder(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:10),physics: const NeverScrollableScrollPhysics(),reverse: true,itemCount: 100,itemBuilder: (c,idx){ int row=idx~/10; int col=idx%10; int num; if(row%2==0) num=100-row*10-col; else num=100-row*10-(9-col); return buildCell(num); }),
        if(flyingEmoji.isNotEmpty) Center(child: Text(flyingEmoji,style: const TextStyle(fontSize:60))),
        if(selectedGift.isNotEmpty) Center(child: Container(padding: const EdgeInsets.all(16),decoration: BoxDecoration(color: const Color(0xCC000000),borderRadius: BorderRadius.circular(20)),child: Text(selectedGift,style: const TextStyle(fontSize:50)))),
        if(canRoll&&!gameOver) Center(child: GestureDetector(onTap:roll,child: Container(width:90,height:90,decoration: BoxDecoration(shape: BoxShape.circle,gradient: const RadialGradient(colors:[Color(0xFFFFD700),Color(0xFFFF6F00)]),border: Border.all(color: Colors.white,width:3)),child: Column(mainAxisAlignment: MainAxisAlignment.center,children:[Text("$dice",style: const TextStyle(fontSize:32,fontWeight: FontWeight.bold)), const Text("ROLL",style: TextStyle(fontWeight: FontWeight.bold))])))),
        if(gameOver) Container(color: const Color(0x99000000),child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,children:[const Icon(Icons.emoji_events,color: Color(0xFFFFD700),size:70), Text("اللاعب ${winner+1} فاز 👑",style: const TextStyle(color: Colors.white,fontSize:22)), const SizedBox(height:20), Text("$countdown",style: const TextStyle(color: Colors.white,fontSize:36))]))),
      ])))),
      Container(
        height: 70,
        margin: const EdgeInsets.symmetric(horizontal:8,vertical:4),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(color: const Color(0xFF1A2A6A),borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(onTap:(){ setState((){ privateMode=false; }); },child: Container(padding: const EdgeInsets.symmetric(horizontal:10,vertical:4),decoration: BoxDecoration(color:!privateMode?const Color(0xFFFFD700):const Color(0xFF2A3A8C),borderRadius: BorderRadius.circular(12)),child: Text("عام",style: TextStyle(color:!privateMode?Colors.black:Colors.white,fontSize:11)))),
                const SizedBox(width:6),
                GestureDetector(onTap:(){ setState((){ privateMode=true; }); },child: Container(padding: const EdgeInsets.symmetric(horizontal:10,vertical:4),decoration: BoxDecoration(color:privateMode?const Color(0xFFFFD700):const Color(0xFF2A3A8C),borderRadius: BorderRadius.circular(12)),child: Text("خاص",style: TextStyle(color:privateMode?Colors.black:Colors.white,fontSize:11)))),
                const Spacer(),
                Row(children: List.generate(gifts.length,(index){ return GestureDetector(onTap:(){ sendGift(gifts[index]); },child: Container(margin: const EdgeInsets.symmetric(horizontal:2),padding: const EdgeInsets.all(4),decoration: BoxDecoration(color: const Color(0x33FFFFFF),borderRadius: BorderRadius.circular(8)),child: Text(gifts[index],style: const TextStyle(fontSize:14)))); })),
              ],
            ),
            const SizedBox(height:4),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: privateMode? privateChat.length : publicChat.length,
                itemBuilder: (context, i) {
                  var list = privateMode? privateChat : publicChat;
                  return Container(
                    margin: const EdgeInsets.only(right:6),
                    padding: const EdgeInsets.symmetric(horizontal:8,vertical:2),
                    decoration: BoxDecoration(color: const Color(0xFF2A3A8C),borderRadius: BorderRadius.circular(10)),
                    child: Text(list[i],style: const TextStyle(color: Colors.white,fontSize:11)),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      Container(padding: const EdgeInsets.symmetric(horizontal:8,vertical:4),child: Row(children:[Row(children: List.generate(emojis.length,(index){ return GestureDetector(onTap:(){ sendEmoji(emojis[index]); },child: Container(margin: const EdgeInsets.only(right:4),padding: const EdgeInsets.all(6),decoration: const BoxDecoration(color: Color(0xFF2A3A8C),shape: BoxShape.circle),child: Text(emojis[index],style: const TextStyle(fontSize:16)))); })), const SizedBox(width:6), Expanded(child: TextField(controller:chatCtrl,style: const TextStyle(color: Colors.white,fontSize:12),decoration: InputDecoration(hintText:privateMode?"رسالة خاصة...":"دردشة عامة...",filled:true,fillColor: const Color(0xFF2A3A8C),border: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide.none),contentPadding: const EdgeInsets.symmetric(horizontal:12,vertical:6)),onSubmitted:(_){ sendChat(); })), const SizedBox(width:6), GestureDetector(onTap:(){ sendChat(); },child: Container(padding: const EdgeInsets.all(8),decoration: const BoxDecoration(shape: BoxShape.circle,color: Color(0xFFFFD700)),child: const Icon(Icons.send,color: Colors.black,size:16)))])),
    ])));
  }
}
