import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';
import 'package:flutter/services.dart';

void main() { runApp(const PlayAndWinApp()); }

class PlayAndWinApp extends StatelessWidget {
  const PlayAndWinApp({super.key});
  @override Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Play and Win',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFF0F172A)),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int tab = 0;
  final List<Widget> pages = const [LudoRoyalFull(), CarromProLikeImage(), SnakeLadderRoyal()];
  @override Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Play & Win - منصة الألعاب'),
        backgroundColor: const Color(0xFF1E293B),
        actions: [
          IconButton(
            icon: const Icon(Icons.diamond, color: Colors.amber),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ShopScreen())),
          )
        ],
      ),
      body: pages[tab],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: tab,
        onTap: (i) => setState(() => tab = i),
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

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});
  @override Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('عروض الشحن'), backgroundColor: const Color(0xFF1E293B)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('عروض الشحن والبطاقات', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _card('عرض المبتدئين: احصل على 500 عملة + 50 وردة هدية*، 4.99\$'),
          _card('عرض الأعضاء المميزين: احصل على 1500 عملة + 200 وردة هدية*، 9.99\$'),
          _card('عرض النخبة الماسى: احصل على 5000 عملة + 600 وردة هدية*، 24.99\$'),
        ],
      ),
    );
  }
  Widget _card(String t) => Card(color: const Color(0xFF1E293B), margin: const EdgeInsets.symmetric(vertical: 8), child: Padding(padding: const EdgeInsets.all(16), child: Text(t, style: const TextStyle(color: Colors.amber, fontSize: 16))));
}

class SoundManager {
  static void dice() => HapticFeedback.mediumImpact();
  static void move() => HapticFeedback.lightImpact();
  static void capture() => HapticFeedback.heavyImpact();
  static void win() => HapticFeedback.vibrate();
  static void hit() => HapticFeedback.selectionClick();
  static void pot() => HapticFeedback.lightImpact();
}

class CarromPiece {
  Offset pos; Color color; bool isWhite; bool isQueen; bool isStriker; Offset vel;
  CarromPiece(this.pos, this.color, this.isWhite, {this.isQueen = false, this.isStriker = false}) : vel = Offset.zero;
}

class CarromImagePainter extends CustomPainter {
  @override void paint(Canvas c, Size s) {
    final p = Paint()..color = const Color(0xFF8D6E63).withOpacity(0.7)..style = PaintingStyle.stroke..strokeWidth = 1.5;
    c.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(s.width*0.14, s.width*0.14, s.width*0.72, s.height*0.72), const Radius.circular(32)), p);
  }
  @override bool shouldRepaint(_) => false;
}

class AimPainter extends CustomPainter {
  final Offset from, to; final double power;
  AimPainter(this.from, this.to, this.power);
  @override void paint(Canvas c, Size s) {
    c.drawLine(from, to, Paint()..color = Colors.white..strokeWidth = 3);
  }
  @override bool shouldRepaint(_) => true;
}

// ================= LUDO =================
class LudoRoyalFull extends StatefulWidget { const LudoRoyalFull({super.key}); @override State<LudoRoyalFull> createState() => _LudoState(); }
class _LudoState extends State<LudoRoyalFull> {
  int dice=6, turn=0, winner=-1, countdown=10;
  bool canRoll=true, gameOver=false, micOn=true, privateMode=false;
  String flyingEmoji="", selectedGift="", msg="جبت 6";
  List<List<int>> tokens=[[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1]];
  List<int> start=[0,39,13,26], safe=[0,8,13,21,26,34,39,47];
  List<List<int>> homePath=[[52,53,54,55,56,57],[58,59,60,61,62,63],[64,65,66,67,68,69],[70,71,72,73,74,75]];
  List<String> publicChat=["P3: عاش 💪","Me: السلام عليكم"], privateChat=["P1 خاص: يلا"], gifts=["❤️","🌹","👑","🚗","🦁","💎"], emojis=["😂","😡","😍","👏","🎉","🔥"];
  TextEditingController chatCtrl=TextEditingController();
  Timer? timer;
  List<Offset> path=const [Offset(6,1),Offset(6,2),Offset(6,3),Offset(6,4),Offset(6,5),Offset(5,6),Offset(4,6),Offset(3,6),Offset(2,6),Offset(1,6),Offset(0,6),Offset(0,7),Offset(0,8),Offset(1,8),Offset(2,8),Offset(3,8),Offset(4,8),Offset(5,8),Offset(6,9),Offset(6,10),Offset(6,11),Offset(6,12),Offset(6,13),Offset(6,14),Offset(7,14),Offset(8,14),Offset(8,13),Offset(8,12),Offset(8,11),Offset(8,10),Offset(8,9),Offset(9,8),Offset(10,8),Offset(11,8),Offset(12,8),Offset(13,8),Offset(14,8),Offset(14,7),Offset(14,6),Offset(13,6),Offset(12,6),Offset(11,6),Offset(10,6),Offset(9,6),Offset(8,5),Offset(8,4),Offset(8,3),Offset(8,2),Offset(8,1),Offset(8,0),Offset(7,0),Offset(6,0)];
  Map<int,Offset> homeC={52:const Offset(7,1),53:const Offset(7,2),54:const Offset(7,3),55:const Offset(7,4),56:const Offset(7,5),57:const Offset(7,6),58:const Offset(13,7),59:const Offset(12,7),60:const Offset(11,7),61:const Offset(10,7),62:const Offset(9,7),63:const Offset(8,7),64:const Offset(1,7),65:const Offset(2,7),66:const Offset(3,7),67:const Offset(4,7),68:const Offset(5,7),69:const Offset(6,7),70:const Offset(7,13),71:const Offset(7,12),72:const Offset(7,11),73:const Offset(7,10),74:const Offset(7,9),75:const Offset(7,8)};

  void roll(){ if(!canRoll||gameOver) return; setState((){ dice=math.Random().nextInt(6)+1; canRoll=false; msg="جبت $dice"; }); SoundManager.dice(); bool can=tokens[turn].any((e)=>e>=0||(e==-1&&dice==6)); if(!can) Future.delayed(const Duration(milliseconds:800),(){ if(mounted) setState((){ turn=(turn+1)%4; canRoll=true; }); }); }
  void moveToken(int p,int idx){ if(p!=turn||canRoll||gameOver) return; int cur=tokens[p][idx]; if(cur==-1&&dice!=6) return; setState((){ if(cur==-1) tokens[p][idx]=start[p]; else if(cur>=0&&cur<52){ int entry=(start[p]+51)%52; int next=cur+dice; if(cur<=entry&&next>entry){ int h=next-entry-1; tokens[p][idx]=h<6?homePath[p][h]:h==6?100:next%52; } else tokens[p][idx]=next%52; } else if(cur>=52){ int hi=homePath[p].indexOf(cur); if(hi!=-1&&hi+dice<=6) tokens[p][idx]=hi+dice==6?100:homePath[p][hi+dice]; } int pos=tokens[p][idx]; if(pos<52&&!safe.contains(pos)){ for(int op=0;op<4;op++) if(op!=p) for(int oi=0;oi<4;oi++) if(tokens[op][oi]==pos) tokens[op][oi]=-1; } if(dice!=6) turn=(turn+1)%4; canRoll=true; }); }
  @override Widget build(BuildContext context){
    List<Color> cols=[const Color(0xFFE53935),const Color(0xFFFBC02D),const Color(0xFF43A047),const Color(0xFF1E88E5)];
    double board=MediaQuery.of(context).size.width-8;
    return Column(children:[
      Container(margin:const EdgeInsets.all(8),padding:const EdgeInsets.all(10),decoration:BoxDecoration(color:const Color(0xFF2A3A8C),borderRadius:BorderRadius.circular(16)),child:Row(children:[const Icon(Icons.visibility,color:Colors.amber,size:18),const SizedBox(width:8),Text(msg,style:const TextStyle(color:Colors.white)),const Spacer(),Icon(micOn?Icons.mic:Icons.mic_off,color:Colors.greenAccent)])),
      Expanded(child:Center(child:Container(width:board,height:board,decoration:BoxDecoration(border:Border.all(color:const Color(0xFFFFD700),width:5),borderRadius:BorderRadius.circular(8)),child:LayoutBuilder(builder:(c,cons){ double ce=cons.maxWidth/15; List<Widget> tw=[]; for(int p=0;p<4;p++) for(int t=0;t<4;t++){ int bp=tokens[p][t]; Offset pt; if(bp==-1) pt=Offset((t%2==0?1.5:3.5),(t<2?1.5:3.5)); else if(bp>=100) pt=const Offset(7.5,7.5); else if(homeC.containsKey(bp)) pt=Offset(homeC[bp]!.dy,homeC[bp]!.dx); else{ var o=path[bp%52]; pt=Offset(o.dy,o.dx);} double sz=ce*0.78; tw.add(Positioned(left:pt.dx*ce+ce/2-sz/2,top:pt.dy*ce+ce/2-sz/2,child:GestureDetector(onTap:()=>moveToken(p,t),child:Container(width:sz,height:sz,decoration:BoxDecoration(shape:BoxShape.circle,color:cols[p],border:Border.all(color:Colors.white,width:2)),child:const Center(child:Text("♔"))))))); } List<Widget> grid=List.generate(225,(i){ int r=i~/15, co=i%15; Color bg=const Color(0xFFFFF8E1); if(r<6&&co<6) bg=cols[0]; if(r<6&&co>8) bg=cols[2]; if(r>8&&co<6) bg=cols[1]; if(r>8&&co>8) bg=cols[3]; return Container(decoration:BoxDecoration(color:bg,border:Border.all(color:Colors.black12,width:0.3))); }); return Stack(children:[GridView.count(crossAxisCount:15,physics:const NeverScrollableScrollPhysics(),padding:EdgeInsets.zero,children:grid),...tw, if(canRoll) Center(child:GestureDetector(onTap:roll,child:Container(width:106,height:106,decoration:BoxDecoration(shape:BoxShape.circle,gradient:const RadialGradient(colors:[Color(0xFFFFD700),Color(0xFFFF6F00)]),border:Border.all(color:Colors.white,width:3)),child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[Text("$dice",style:const TextStyle(fontSize:38,fontWeight:FontWeight.bold)),const Text("ROLL")]))))]); })))),
      Container(height:60,margin:const EdgeInsets.all(8),child:ListView.builder(scrollDirection:Axis.horizontal,itemCount:publicChat.length,itemBuilder:(c,i)=>Container(margin:const EdgeInsets.only(right:6),padding:const EdgeInsets.symmetric(horizontal:8,vertical:6),decoration:BoxDecoration(color:const Color(0xFF2A3A8C),borderRadius:BorderRadius.circular(10)),child:Text(publicChat[i],style:const TextStyle(color:Colors.white,fontSize:11))))),
    ]);
  }
}

// ================= CARROM =================
class CarromProLikeImage extends StatefulWidget{ const CarromProLikeImage({super.key}); @override State<CarromProLikeImage> createState()=>_CarromState(); }
class _CarromState extends State<CarromProLikeImage>{
  List<CarromPiece> pieces=[]; CarromPiece striker=CarromPiece(const Offset(0.5,0.82),const Color(0xFFFF1744),false,isStriker:true);
  Offset? ds, de; Timer? t; bool over=false;
  @override void initState(){ super.initState(); reset(); t=Timer.periodic(const Duration(milliseconds:16),(x)=>phys()); }
  void reset(){ pieces=[CarromPiece(const Offset(0.5,0.5),Colors.black,false,isQueen:true),CarromPiece(const Offset(0.5,0.40),Colors.white,true),CarromPiece(const Offset(0.43,0.43),Colors.white,true),CarromPiece(const Offset(0.57,0.43),Colors.white,true),CarromPiece(const Offset(0.38,0.50),Colors.white,true),CarromPiece(const Offset(0.62,0.50),Colors.white,true),CarromPiece(const Offset(0.43,0.57),Colors.white,true),CarromPiece(const Offset(0.57,0.57),Colors.white,true),CarromPiece(const Offset(0.5,0.60),Colors.brown,false)]; over=false; }
  void phys(){ if(!mounted||over) return; setState((){ for(var p in [...pieces,striker]){ if(p.vel==Offset.zero) continue; p.pos+=p.vel*0.016; p.vel*=0.985; if(p.vel.distance<0.002) p.vel=Offset.zero; if(p.pos.dx<0.07||p.pos.dx>0.93) {p.vel=Offset(-p.vel.dx,p.vel.dy); p.pos=Offset(p.pos.dx.clamp(0.07,0.93),p.pos.dy);} if(p.pos.dy<0.07||p.pos.dy>0.93){p.vel=Offset(p.vel.dx,-p.vel.dy); p.pos=Offset(p.pos.dx,p.pos.dy.clamp(0.07,0.93));} } pieces.removeWhere((p)=> (p.pos-const Offset(0.08,0.08)).distance<0.06 || (p.pos-const Offset(0.92,0.08)).distance<0.06 || (p.pos-const Offset(0.08,0.92)).distance<0.06 || (p.pos-const Offset(0.92,0.92)).distance<0.06 ); }); }
  @override void dispose(){ t?.cancel(); super.dispose(); }
  @override Widget build(BuildContext context){
    return Center(child:LayoutBuilder(builder:(c,cons){ double s=math.min(cons.maxWidth-12,cons.maxHeight*0.8); return GestureDetector(
      onPanStart:(d)=>ds=Offset(d.localPosition.dx/s,d.localPosition.dy/s),
      onPanUpdate:(d)=>setState(()=>de=Offset(d.localPosition.dx/s,d.localPosition.dy/s)),
      onPanEnd:(_){ if(ds!=null&&de!=null){ var dir=de!-ds!; striker.vel=dir*20; } ds=null; de=null; },
      child:Container(width:s,height:s,decoration:BoxDecoration(color:const Color(0xFFDEB887),borderRadius:BorderRadius.circular(22),border:Border.all(color:const Color(0xFFFFD700),width:4)),child:Stack(children:[
        CustomPaint(size:Size(s,s),painter:CarromImagePainter()),
       ...pieces.map((p)=>Positioned(left:p.pos.dx*s-16,top:p.pos.dy*s-16,child:Container(width:32,height:32,decoration:BoxDecoration(shape:BoxShape.circle,color:p.isQueen?Colors.black:p.isWhite?Colors.white:Colors.brown,border:Border.all(color:Colors.white))))),
        Positioned(left:striker.pos.dx*s-22,top:striker.pos.dy*s-22,child:Container(width:44,height:44,decoration:BoxDecoration(shape:BoxShape.circle,color:Colors.pink,border:Border.all(color:Colors.white,width:3)))),
        if(ds!=null&&de!=null) CustomPaint(size:Size(s,s),painter:AimPainter(ds!*s,de!*s,1)),
      ])),
    ); }));
  }
}

// ================= SNAKE =================
class SnakeLadderRoyal extends StatefulWidget{ const SnakeLadderRoyal({super.key}); @override State<SnakeLadderRoyal> createState()=>_SnakeState(); }
class _SnakeState extends State<SnakeLadderRoyal>{
  int dice=1, turn=0; bool canRoll=true; List<int> pos=[0,0,0,0];
  Map<int,int> snakes={99:54,70:55,52:42,56:8,43:17,50:5,27:5}, ladders={3:51,6:27,20:70,36:55,63:95,68:98};
  void roll(){ if(!canRoll) return; setState((){ dice=math.Random().nextInt(6)+1; canRoll=false; }); Future.delayed(const Duration(milliseconds:600),(){ setState((){ int n=pos[turn]+dice; if(n<=100){ pos[turn]=snakes[n]??ladders[n]??n; if(n==100) pos=[0,0,0,0]; } turn=(turn+1)%4; canRoll=true; }); }); }
  Widget cell(int num){ bool sn=snakes.containsKey(num), lad=ladders.containsKey(num); Color bg=sn?const Color(0xFFFFCDD2):lad?const Color(0xFFC8E6C9):const Color(0xFFFFF8E1); List<int> here=[]; for(int i=0;i<4;i++) if(pos[i]==num) here.add(i); return Container(decoration:BoxDecoration(color:bg,border:Border.all(color:Colors.black12,width:0.4)),child:Stack(children:[Positioned(top:2,left:4,child:Text("$num",style:const TextStyle(fontSize:9))), if(sn) const Center(child:Text("🐍")), if(lad) const Center(child:Text("🪜")), if(here.isNotEmpty) Positioned(bottom:2,right:2,child:Row(children:here.map((p)=>Container(width:10,height:10,margin:const EdgeInsets.only(left:1),decoration:BoxDecoration(shape:BoxShape.circle,color:[Colors.red,Colors.amber,Colors.green,Colors.blue][p]))).toList()))])); }
  @override Widget build(BuildContext context){
    double size=MediaQuery.of(context).size.width-12;
    return Center(child:Container(width:size,height:size,decoration:BoxDecoration(border:Border.all(color:const Color(0xFFFFD700),width:4)),child:Stack(children:[
      GridView.builder(gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:10),physics:const NeverScrollableScrollPhysics(),reverse:true,itemCount:100,itemBuilder:(c,i){ int r=i~/10, co=i%10, num=r%2==0?100-r*10-co:100-r*10-(9-co); return cell(num); }),
      if(canRoll) Center(child:GestureDetector(onTap:roll,child:Container(width:90,height:90,decoration:BoxDecoration(shape:BoxShape.circle,gradient:const RadialGradient(colors:[Color(0xFFFFD700),Color(0xFFFF6F00)]),border:Border.all(color:Colors.white,width:3)),child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[Text("$dice",style:const TextStyle(fontSize:32,fontWeight:FontWeight.bold)),const Text("ROLL")])))),
    ])));
  }
}
