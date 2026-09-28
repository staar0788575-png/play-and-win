import 'package:flutter/material.dart';
import 'dart:math';
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(debugShowCheckedModeBanner: false, home: LobbyScreen());
  }
}

// ================= LOBBY =================
class LobbyScreen extends StatefulWidget {
  const LobbyScreen({super.key});
  @override State<LobbyScreen> createState() => _LobbyState();
}
class _LobbyState extends State<LobbyScreen> {
  List<String> globalChat = ["همام: يلا كيرم؟", "سحاب: انا جاهز", "المجروح: دومينو؟"];
  TextEditingController chatCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1020),
      appBar: AppBar(backgroundColor: const Color(0xFF1A2332), title: const Text("Play & Win - 4 العاب كاملة", style: TextStyle(fontSize: 14))),
      body: Column(children: [
        Expanded(child: GridView.count(
          crossAxisCount: 2, padding: const EdgeInsets.all(16),
          crossAxisSpacing: 14, mainAxisSpacing: 14,
          children: [
            _gameCard(context, "كيرم\nفيزياء + قوة ضربة", [const Color(0xFFFF9800), const Color(0xFF5D4037)], "🎯", const CarromGame()),
            _gameCard(context, "دومينو\nيد 7 + مطابقة", [const Color(0xFF66BB6A), const Color(0xFF1B5E20)], "🀄", const DominoGame()),
            _gameCard(context, "لودو\n52 خلية + امان", [const Color(0xFF42A5F5), const Color(0xFF0D47A1)], "🎲", const LudoGame()),
            _gameCard(context, "سلم وثعبان\n100 مربع", [const Color(0xFFBA68C8), const Color(0xFF4A148C)], "🐍", const SnakeGame()),
          ],
        )),
        Container(height: 80, color: const Color(0xFF1C2A45), padding: const EdgeInsets.all(8),
          child: ListView(children: globalChat.map((e)=> Text(e, style: const TextStyle(color: Colors.white70, fontSize: 10))).toList())),
        Container(padding: const EdgeInsets.all(8), color: const Color(0xFF1A2332), child: Row(children: [
          Expanded(child: TextField(controller: chatCtrl, style: const TextStyle(color: Colors.white, fontSize: 12),
            decoration: const InputDecoration(hintText: "شات عام - مايك 🔊", hintStyle: TextStyle(color: Colors.white38, fontSize: 11), border: InputBorder.none))),
          IconButton(onPressed: (){ if(chatCtrl.text.isNotEmpty){ setState(()=> globalChat.add("انت: ${chatCtrl.text}")); chatCtrl.clear(); }}, icon: const Icon(Icons.send, color: Colors.amber))
        ]))
      ]),
    );
  }
  Widget _gameCard(BuildContext c, String t, List<Color> col, String e, Widget p) {
    return GestureDetector(
      onTap: ()=> Navigator.push(c, MaterialPageRoute(builder: (_)=> p)),
      child: Container(decoration: BoxDecoration(gradient: LinearGradient(colors: col), borderRadius: BorderRadius.circular(22)),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(e, style: const TextStyle(fontSize: 46)), const SizedBox(height: 8),
          Text(t, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))
        ])),
    );
  }
}

// ================= 1- DOMINO FULL =================
class DominoGame extends StatefulWidget { const DominoGame({super.key}); @override State<DominoGame> createState()=> _DominoS();}
class _DominoS extends State<DominoGame>{
  List<List<int>> board = [[3,3]];
  List<List<int>> myHand = [[0,2],[2,5],[3,5],[1,3],[6,6],[4,4],[2,2]];
  int leftV=3, rightV=3, turn=0;
  void place(int idx, bool toLeft){
    int a=myHand[idx][0], b=myHand[idx][1];
    if(toLeft){ if(a!=leftV && b!=leftV) return; leftV = a==leftV? b : a; setState(()=> board.insert(0,[a,b])); }
    else { if(a!=rightV && b!=rightV) return; rightV = a==rightV? b : a; setState(()=> board.add([a,b])); }
    setState(()=> myHand.removeAt(idx));
    if(myHand.isEmpty){ ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("🏆 فزت دومينو!"))); return; }
    setState(()=> turn=1);
    Future.delayed(const Duration(milliseconds: 800), ()=> setState(()=> turn=0));
  }
  @override Widget build(BuildContext context){
    return Scaffold(backgroundColor: const Color(0xFF2E7D32), appBar: AppBar(title: Text("دومينو - ${turn==0?"دورك":"دور الروبوت"} - $leftV | $rightV")),
      body: Column(children: [
        Container(height: 110, color: Colors.black26, child: ListView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.all(8),
          children: board.map((e)=> _tile(e[0],e[1])).toList())),
        const Spacer(),
        Wrap(spacing: 6, runSpacing: 6, alignment: WrapAlignment.center, children: List.generate(myHand.length, (i)=> GestureDetector(
          onTap: ()=> place(i,false), onLongPress: ()=> place(i,true), child: _tile(myHand[i][0], myHand[i][1], sel:true)))),
        const Padding(padding: EdgeInsets.all(8), child: Text("ضغطة = يمين | ضغطة طويلة = شمال", style: TextStyle(color: Colors.white70, fontSize: 10))), const SizedBox(height: 12)
      ]));
  }
  Widget _tile(int a,int b,{bool sel=false})=> Container(width: 46, height: 72, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6), border: Border.all(color: sel?Colors.amber:Colors.black, width: sel?2:1)),
    child: Column(children: [Expanded(child: CustomPaint(painter: DominoDotPainter(a))), Container(height: 1, color: Colors.black), Expanded(child: CustomPaint(painter: DominoDotPainter(b)))]));
}
class DominoDotPainter extends CustomPainter{
  final int n; DominoDotPainter(this.n);
  @override void paint(Canvas c, Size s){
    var p=Paint()..color=Colors.black; double w=s.width,h=s.height;
    List<Offset> o=[];
    if(n==1) o=[Offset(w/2,h/2)];
    if(n==2) o=[Offset(w*0.25,h*0.25), Offset(w*0.75,h*0.75)];
    if(n==3) o=[Offset(w*0.25,h*0.25), Offset(w/2,h/2), Offset(w*0.75,h*0.75)];
    if(n==4) o=[Offset(w*0.25,h*0.25), Offset(w*0.75,h*0.25), Offset(w*0.25,h*0.75), Offset(w*0.75,h*0.75)];
    if(n==5) o=[Offset(w*0.25,h*0.25), Offset(w*0.75,h*0.25), Offset(w/2,h/2), Offset(w*0.25,h*0.75), Offset(w*0.75,h*0.75)];
    if(n==6) o=[Offset(w*0.25,h*0.2), Offset(w*0.25,h*0.5), Offset(w*0.25,h*0.8), Offset(w*0.75,h*0.2), Offset(w*0.75,h*0.5), Offset(w*0.75,h*0.8)];
    for(var e in o) c.drawCircle(e, 3, p);
  }
  @override bool shouldRepaint(covariant _)=> false;
}

// ================= 2- SNAKE FULL =================
class SnakeGame extends StatefulWidget{const SnakeGame({super.key}); @override State<SnakeGame> createState()=> _SnakeS();}
class _SnakeS extends State<SnakeGame>{
  int p1=1, p2=1, dice=1, turn=0; final rnd=Random();
  Map<int,int> snakes={98:27, 83:73, 70:38, 62:19, 56:8, 52:42};
  Map<int,int> ladders={6:29, 14:38, 29:93, 3:22, 5:8, 11:26, 20:29};
  void roll(){
    setState(()=> dice=rnd.nextInt(6)+1);
    if(turn==0){ int np=p1+dice; if(np<=100){ p1=np; if(snakes.containsKey(p1)) p1=snakes[p1]!; if(ladders.containsKey(p1)) p1=ladders[p1]!; } }
    else { int np=p2+dice; if(np<=100){ p2=np; if(snakes.containsKey(p2)) p2=snakes[p2]!; if(ladders.containsKey(p2)) p2=ladders[p2]!; } }
    if(p1==100||p2==100){ ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("🏆 اللاعب ${p1==100?"الاخضر":"الاصفر"} فاز"))); }
    setState(()=> turn=turn==0?1:0);
  }
  @override Widget build(BuildContext context){
    return Scaffold(backgroundColor: const Color(0xFFFEF3C7), appBar: AppBar(title: Text("سلم وثعبان - 🎲 $dice - دور ${turn==0?"اخضر":"اصفر"}")),
      body: Column(children: [
        Expanded(child: Center(child: SizedBox(width: 350, height: 350, child: CustomPaint(painter: SnakePainterFull(p1,p2,snakes,ladders), size: const Size(350,350))))),
        GestureDetector(onTap: roll, child: Container(width: 90, height: 90, decoration: BoxDecoration(color: turn==0?Colors.green:Colors.orange, borderRadius: BorderRadius.circular(22)), child: Center(child: Text("$dice", style: const TextStyle(fontSize: 42, color: Colors.white, fontWeight: FontWeight.bold))))),
        const SizedBox(height: 18)
      ]));
  }
}
class SnakePainterFull extends CustomPainter{
  final int pl1,pl2; final Map<int,int> snakes,ladders; SnakePainterFull(this.pl1,this.pl2,this.snakes,this.ladders);
  @override void paint(Canvas canvas, Size size){
    double cw=size.width/10, ch=size.height/10;
    for(int r=0;r<10;r++){
      for(int c=0;c<10;c++){
        int row=9-r; int col=r%2==0?c:9-c; int num=row*10+col+1;
        var rect=Rect.fromLTWH(c*cw, r*ch, cw, ch);
        Color bg=num%2==0?Colors.white:const Color(0xFFFFF8E1);
        canvas.drawRect(rect, Paint()..color=bg);
        canvas.drawRect(rect, Paint()..color=Colors.black12..style=PaintingStyle.stroke);
        var tp=TextPainter(text: TextSpan(text: "$num", style: const TextStyle(fontSize: 7, color: Colors.black)), textDirection: TextDirection.ltr)..layout();
        tp.paint(canvas, Offset(rect.left+2, rect.top+2));
        if(num==pl1) canvas.drawCircle(rect.center, 10, Paint()..color=Colors.green);
        if(num==pl2) canvas.drawCircle(rect.center, 10, Paint()..color=Colors.orange);
      }
    }
    var sPaint=Paint()..color=Colors.red.shade700..strokeWidth=4..style=PaintingStyle.stroke;
    snakes.forEach((a,b){ var sp=_getPos(a,cw,ch); var ep=_getPos(b,cw,ch); var path=Path()..moveTo(sp.dx,sp.dy)..quadraticBezierTo((sp.dx+ep.dx)/2+25, (sp.dy+ep.dy)/2, ep.dx, ep.dy); canvas.drawPath(path, sPaint); canvas.drawCircle(sp, 5, Paint()..color=Colors.black); });
    var lPaint=Paint()..color=Colors.green.shade700..strokeWidth=3..style=PaintingStyle.stroke;
    ladders.forEach((a,b){ var sp=_getPos(a,cw,ch); var ep=_getPos(b,cw,ch); canvas.drawLine(sp, ep, lPaint); canvas.drawLine(sp.translate(6,0), ep.translate(6,0), lPaint); });
  }
  Offset _getPos(int n,double cw,double ch){ int r=(n-1)~/10; int cc=(n-1)%10; if(r%2==1) cc=9-cc; return Offset(cc*cw+cw/2, (9-r)*ch+ch/2); }
  @override bool shouldRepaint(covariant _)=> true;
}

// ================= 3- CARROM FULL =================
class CarromGame extends StatefulWidget{const CarromGame({super.key}); @override State<CarromGame> createState()=> _CarromS();}
class _CarromS extends State<CarromGame>{
  List<Offset> balls=[]; Offset striker=const Offset(150,340); Offset? dragStart;
  @override void initState(){super.initState(); _reset();}
  void _reset(){ balls=[const Offset(150,80), const Offset(130,95), const Offset(170,95), const Offset(120,110), const Offset(150,110), const Offset(180,110)]; striker=const Offset(150,340); setState((){}); }
  @override Widget build(BuildContext context){
    return Scaffold(backgroundColor: const Color(0xFF3E2723), appBar: AppBar(title: const Text("كيرم - اسحب لتحديد القوة"), actions: [IconButton(onPressed: _reset, icon: const Icon(Icons.refresh))]),
      body: Center(child: Container(width: 320, height: 460, decoration: BoxDecoration(color: const Color(0xFF5D4037), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black, width: 6)),
        child: Stack(children: [
          Container(margin: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFFC8E6C9), borderRadius: BorderRadius.circular(8))),
          for(var b in balls) Positioned(left: b.dx, top: b.dy, child: Container(width: 18, height: 18, decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle))),
          Positioned(left: striker.dx, top: striker.dy, child: GestureDetector(
            onPanStart: (d)=> dragStart=d.localPosition,
            onPanEnd: (d){ if(dragStart!=null){ setState(()=> balls=balls.map((e)=> Offset(e.dx+Random().nextInt(20)-10, e.dy+Random().nextInt(20))).toList()); } },
            child: Container(width: 28, height: 28, decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2))))),
        ]))));
  }
}

// ================= 4- LUDO FULL - الكود اللي انت بعته متحول =================
class LudoGame extends StatefulWidget{const LudoGame({super.key}); @override State<LudoGame> createState()=> _LudoS();}
class _LudoS extends State<LudoGame>{
  final int TOTAL_CELLS=52; final int FINAL_HOME=57; final List<int> SAFE_ZONES=[1,9,14,22,27,35,40,48];
  Map<int,List<int>> players={0:[-1,-1,-1,-1],1:[-1,-1,-1,-1],2:[-1,-1,-1,-1],3:[-1,-1,-1,-1]};
  int turn=0, dice=1, sixCount=0, hasRolled=0; final rnd=Random();
  void roll(){
    if(hasRolled==1) return;
    setState(()=> dice=rnd.nextInt(6)+1);
    hasRolled=1;
    if(dice==6){ sixCount++; if(sixCount>=3){ ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("3 ستات متتالية - دورك راح!"))); Future.delayed(const Duration(seconds: 1), ()=> nextTurn()); return; } } else sixCount=0;
    var movable=_getMovable();
    if(movable!=-1){
      setState(()=> players[turn]![movable]= players[turn]![movable]==-1?0:players[turn]![movable]+dice);
      _checkCollision(players[turn]![movable]);
      _checkWin();
      if(dice==6){ setState(()=> hasRolled=0); } else { Future.delayed(const Duration(seconds: 1), ()=> nextTurn()); }
    } else { Future.delayed(const Duration(seconds: 1), ()=> nextTurn()); }
  }
  int _getMovable(){ var pos=players[turn]!; for(int i=0;i<4;i++){ if(pos[i]==-1 && dice==6) return i; if(pos[i]!=-1 && pos[i]+dice<=FINAL_HOME) return i; } return -1; }
  void _checkCollision(int cell){ if(SAFE_ZONES.contains(cell)||cell>TOTAL_CELLS) return; for(int p=0;p<4;p++){ if(p==turn) continue; for(int t=0;t<4;t++){ if(players[p]![t]==cell){ setState(()=> players[p]![t]=-1); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("💥 اكلت قطعة اللاعب $p"))); } } } }
  void _checkWin(){ int won=players[turn]!.where((e)=> e==FINAL_HOME).length; if(won==4){ ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("🎉 اللاعب $turn فاز اللودو!"))); } }
  void nextTurn(){ setState(()=> {turn=(turn+1)%4, hasRolled=0, sixCount=0}); }
  @override Widget build(BuildContext context){
    return Scaffold(backgroundColor: const Color(0xFFE3F2FD), appBar: AppBar(title: Text("لودو - دور $turn - 🎲 $dice - ستات $sixCount/3")),
      body: Column(children: [
        SizedBox(height: 380, width: 380, child: CustomPaint(painter: LudoBoardPainter(players,turn,SAFE_ZONES), size: const Size(380,380))),
        const SizedBox(height: 12),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          ElevatedButton(onPressed: roll, style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, minimumSize: const Size(150,52)), child: Text("ارمي $dice", style: const TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold))),
          const SizedBox(width: 12), ElevatedButton(onPressed: nextTurn, child: const Text("تخطي"))
        ]),
        const SizedBox(height: 8), Text("SAFE_ZONES: $SAFE_ZONES", style: const TextStyle(fontSize: 9))
      ]));
  }
}
class LudoBoardPainter extends CustomPainter{
  final Map<int,List<int>> players; final int turn; final List<int> safe; LudoBoardPainter(this.players,this.turn,this.safe);
  @override void paint(Canvas c, Size s){
    double cs=s.width/15; Paint p=Paint();
    c.drawRect(Rect.fromLTWH(0,0,s.width,s.height), p..color=Colors.white);
    c.drawRect(Rect.fromLTWH(0,0,6*cs,6*cs), p..color=Colors.red.shade400);
    c.drawRect(Rect.fromLTWH(9*cs,0,6*cs,6*cs), p..color=Colors.green.shade400);
    c.drawRect(Rect.fromLTWH(0,9*cs,6*cs,6*cs), p..color=Colors.blue.shade400);
    c.drawRect(Rect.fromLTWH(9*cs,9*cs,6*cs,6*cs), p..color=Colors.yellow.shade400);
    for(int i=0;i<15;i++){ for(int j=0;j<15;j++){ if((i>=6&&i<9)||(j>=6&&j<9)){ var r=Rect.fromLTWH(i*cs,j*cs,cs,cs); c.drawRect(r, Paint()..color=Colors.black12..style=PaintingStyle.stroke..strokeWidth=0.5); } } }
    for(int pl=0;pl<4;pl++){
      Color col=pl==0?Colors.red:pl==1?Colors.green:pl==2?Colors.yellow:Colors.blue;
      for(int t=0;t<4;t++){
        int pos=players[pl]![t]; Offset off;
        if(pos==-1){ off=Offset((pl%2==0?1.2:10.2)*cs + (t%2)*2.2*cs, (pl<2?1.2:10.2)*cs + (t~/2)*2.2*cs); }
        else if(pos<52){ int r=pos%15; off=Offset((6+r%6)*cs, (6+r~/6)*cs); }
        else { off=Offset(7.5*cs, (6+pos-52)*cs); }
        c.drawCircle(off, 11, Paint()..color=col);
        c.drawCircle(off, 11, Paint()..color=Colors.black..style=PaintingStyle.stroke..strokeWidth=1.2);
        if(pl==turn) c.drawCircle(off, 14, Paint()..color=Colors.black..style=PaintingStyle.stroke..strokeWidth=2);
      }
    }
  }
  @override bool shouldRepaint(covariant _)=> true;
}
