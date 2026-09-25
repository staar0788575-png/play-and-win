import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'dart:math';
void main() => runApp(const PlayAndWinApp());
class PlayAndWinApp extends StatelessWidget{const PlayAndWinApp({super.key}); @override Widget build(BuildContext context)=>const MaterialApp(debugShowCheckedModeBanner:false, home:LobbyScreen());}

// ================= اللوبي كامل بكل تفاصيله =================
class LobbyScreen extends StatelessWidget{
  const LobbyScreen({super.key});
  @override Widget build(BuildContext context){
    final friends=[{"n":"همام","v":"V6","i":"1"},{"n":"سحاب","v":"V7","i":"2"},{"n":"انا المجروح","v":"V6","i":"3"},{"n":"ابن الاكابر","v":"V6","i":"4"}];
    return Scaffold(backgroundColor:const Color(0xFF0A1020), body:SafeArea(child:Column(children:[
      Container(padding:const EdgeInsets.all(12), color:const Color(0xFF1A2332), child:Row(mainAxisAlignment:MainAxisAlignment.spaceBetween, children:[
        Row(children:[const CircleAvatar(backgroundImage:NetworkImage('https://i.pravatar.cc/100?img=12')), const SizedBox(width:8),
          Container(padding:const EdgeInsets.symmetric(horizontal:12,vertical:6), decoration:BoxDecoration(color:Colors.black45, borderRadius:BorderRadius.circular(20)), child:const Row(children:[Text("🪙 1500", style:TextStyle(color:Colors.white)), SizedBox(width:4), CircleAvatar(radius:10, backgroundColor:Colors.amber, child:Text("+", style:TextStyle(color:Colors.black, fontSize:12))) ])),
          const SizedBox(width:6), Container(padding:const EdgeInsets.all(8), decoration:BoxDecoration(color:Colors.black26, borderRadius:BorderRadius.circular(20)), child:const Text("🎁")),
        ]),
        Row(children:[Container(padding:const EdgeInsets.all(8), decoration:BoxDecoration(color:Colors.black26, borderRadius:BorderRadius.circular(20)), child:const Text("🔍", style:TextStyle(color:Colors.white, fontSize:12))), const SizedBox(width:6), Container(padding:const EdgeInsets.all(8), decoration:BoxDecoration(color:Colors.black26, borderRadius:BorderRadius.circular(20)), child:const Text("👑 TOP", style:TextStyle(color:Colors.white, fontSize:12)))])
      ])),
      Padding(padding:const EdgeInsets.all(14), child:Row(mainAxisAlignment:MainAxisAlignment.spaceBetween, children:[const Text("ألعاب عادية", style:TextStyle(color:Colors.white, fontWeight:FontWeight.bold, fontSize:18)), Container(padding:const EdgeInsets.symmetric(horizontal:12,vertical:6), decoration:BoxDecoration(color:Colors.white10, borderRadius:BorderRadius.circular(20)), child:const Text("غرفة خاصة +", style:TextStyle(color:Colors.white, fontSize:12))) ])),
      Expanded(child:SingleChildScrollView(child:Column(children:[
        GridView.count(shrinkWrap:true, physics:const NeverScrollableScrollPhysics(), crossAxisCount:2, padding:const EdgeInsets.symmetric(horizontal:14), childAspectRatio:1.2, mainAxisSpacing:12, crossAxisSpacing:12, children:[
          _gameCard(context,"كيرم / بلياردو",[const Color(0xFF8B5A2B), const Color(0xFF4A2C0A)],"🎯",const BilliardScreen()),
          _gameCard(context,"دومينو 50",[const Color(0xFF4CAF50), const Color(0xFF1B5E20)],"🀄",const DominoScreen()),
          _gameCard(context,"لودو",[const Color(0xFF2979FF), const Color(0xFF0D47A1)],"🎲",const LudoScreen()),
          _gameCard(context,"السلم والثعبان",[const Color(0xFFAB47BC), const Color(0xFF4A148C)],"🐍",const SnakeScreen()),
        ]),
        const SizedBox(height:16),
        Container(decoration:const BoxDecoration(color:Color(0xFF0E172A), borderRadius:BorderRadius.vertical(top:Radius.circular(24))), padding:const EdgeInsets.all(16), child:Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
          const Text("ابحث عن صديق - غرفة الانتظار", style:TextStyle(color:Colors.white, fontWeight:FontWeight.bold)), const SizedBox(height:12),
         ...friends.map((f)=> Container(margin:const EdgeInsets.only(bottom:10), padding:const EdgeInsets.all(12), decoration:BoxDecoration(color:const Color(0xFF1C2A45), borderRadius:BorderRadius.circular(16)), child:Row(mainAxisAlignment:MainAxisAlignment.spaceBetween, children:[
            Row(children:[CircleAvatar(radius:22, backgroundImage:NetworkImage('https://i.pravatar.cc/100?img=${f["i"]}')), const SizedBox(width:10), Column(crossAxisAlignment:CrossAxisAlignment.start, children:[Row(children:[Text(f["n"]!, style:const TextStyle(color:Colors.white, fontSize:13, fontWeight:FontWeight.bold)), const SizedBox(width:6), Container(padding:const EdgeInsets.symmetric(horizontal:4), decoration:BoxDecoration(color:Colors.amber, borderRadius:BorderRadius.circular(4)), child:Text(f["v"]!, style:const TextStyle(fontSize:9, color:Colors.black)))]), const Text("يشاهد اللعب - في الانتظار", style:TextStyle(color:Colors.white54, fontSize:11))])]),
            Container(padding:const EdgeInsets.symmetric(horizontal:18,vertical:6), decoration:BoxDecoration(color:const Color(0xFF22C55E), borderRadius:BorderRadius.circular(20)), child:const Text("إنضم", style:TextStyle(color:Colors.white, fontWeight:FontWeight.bold, fontSize:12)))
          ]))),
        ]))
      ])))
    ])));
  }
  Widget _gameCard(BuildContext c,String t,List<Color> col,String e,Widget p)=>GestureDetector(onTap:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>p)), child:Container(decoration:BoxDecoration(gradient:LinearGradient(colors:col), borderRadius:BorderRadius.circular(20), border:Border.all(color:Colors.amber.withOpacity(0.3))), child:Column(mainAxisAlignment:MainAxisAlignment.center, children:[Text(e, style:const TextStyle(fontSize:38)), const SizedBox(height:8), Container(padding:const EdgeInsets.symmetric(horizontal:12,vertical:4), decoration:BoxDecoration(color:Colors.black45, borderRadius:BorderRadius.circular(20)), child:Text(t, style:const TextStyle(color:Colors.white, fontSize:12, fontWeight:FontWeight.bold)))])));
}
class WaitingMini extends StatelessWidget{const WaitingMini({super.key}); @override Widget build(BuildContext context)=>const Row(children:[CircleAvatar(radius:12, backgroundImage:NetworkImage('https://i.pravatar.cc/100?img=8')), SizedBox(width:4), Text("غرفة الانتظار (4)", style:TextStyle(color:Colors.white70, fontSize:12))]);}

// ================= 1- بلياردو 16 كورة 6 فتحات حجم صغير فيزياء منسقة =================
class BilliardScreen extends StatefulWidget{const BilliardScreen({super.key}); @override State<BilliardScreen> createState()=>_BState();}
class _BState extends State<BilliardScreen> with SingleTickerProviderStateMixin{
  Offset? ds, dc; Offset cue=const Offset(200,380); Offset vel=Offset.zero; List<Ball> balls=[]; late Ticker tk; int sc=0;
  @override void initState(){super.initState(); _reset(); tk=createTicker(_tick); tk.start();}
  void _reset(){ balls=[]; cue=const Offset(200,380); sc=0; List<Color> cols=[Colors.yellow, Colors.blue, Colors.red, Colors.purple, Colors.orange, Colors.green, Colors.brown, Colors.black, Colors.yellow, Colors.blue, Colors.red, Colors.purple, Colors.orange, Colors.green, Colors.brown]; double sx=200, sy=110; int k=0; for(int r=0;r<5;r++){ for(int c=0;c<=r;c++){ if(k>=15) break; double x=sx + (c - r/2)*22; double y=sy + r*20; balls.add(Ball(pos:Offset(x,y), color:cols[k], num:k+1)); k++; }} setState((){}); }
  void _tick(Duration _){ if(vel==Offset.zero) return; setState((){
    cue=cue+vel; vel=vel*0.985; if(vel.distance<0.2) vel=Offset.zero;
    if(cue.dx<28||cue.dx>372) vel=Offset(-vel.dx, vel.dy); if(cue.dy<28||cue.dy>572) vel=Offset(vel.dx, -vel.dy);
    // تصادم كور
    for(int i=0;i<balls.length;i++){ if(balls[i].out) continue; for(int j=i+1;j<balls.length;j++){ if(balls[j].out) continue; double d=(balls[i].pos-balls[j].pos).distance; if(d<20 && d>0){ var mid=(balls[i].pos+balls[j].pos)/2; var dir=(balls[i].pos-balls[j].pos); dir=dir/dir.distance; balls[i].pos=mid+dir*10; balls[j].pos=mid-dir*10; } } if((cue-balls[i].pos).distance<20){ var dir=balls[i].pos-cue; double l=dir.distance; if(l>0){ dir=dir/l; balls[i].pos=balls[i].pos+dir*8; } } if(balls[i].pos.dx<14||balls[i].pos.dx>386||balls[i].pos.dy<14||balls[i].pos.dy>586){ balls[i].out=true; sc++; } }
  });}
  @override void dispose(){tk.dispose(); super.dispose();}
  @override Widget build(BuildContext context){
    double pow=0; if(ds!=null&&dc!=null){ pow=(ds!-dc!).distance; if(pow>100) pow=100; }
    return Scaffold(backgroundColor:const Color(0xFF0A1020), appBar:AppBar(backgroundColor:const Color(0xFF1A2332), title:const WaitingMini(), leading:IconButton(icon:const Icon(Icons.arrow_back), onPressed:()=>Navigator.pop(context))), body:Column(children:[
      Container(padding:const EdgeInsets.all(6), color:Colors.black45, child:const Text("اسحب في أي مكان - بدون زر اطلاق - 16 كورة - 6 جيوب", style:TextStyle(color:Colors.white70, fontSize:11))),
      LinearProgressIndicator(value:pow/100, color:Colors.amber, backgroundColor:Colors.white12),
      Expanded(child:Center(child:SizedBox(width:400, height:600, child:GestureDetector(onPanStart:(d)=>setState(()=>ds=d.localPosition), onPanUpdate:(d)=>setState(()=>dc=d.localPosition), onPanEnd:(_){ if(ds!=null&&dc!=null){ vel=(ds!-dc!)*0.13; } setState(()=>{ds=null, dc=null}); }, child:CustomPaint(painter:PoolPainter(cue,balls,ds,dc)))))),
      Container(padding:const EdgeInsets.all(10), color:const Color(0xFF1A2332), child:Column(children:[Row(mainAxisAlignment:MainAxisAlignment.spaceAround, children:List.generate(4, (i)=>Column(children:[CircleAvatar(backgroundImage:NetworkImage('https://i.pravatar.cc/100?img=${i+1}')), Text("$sc", style:const TextStyle(color:Colors.white, fontWeight:FontWeight.bold))]))), const SizedBox(height:8), Row(children:[const Text("💬 59", style:TextStyle(color:Colors.white)), const SizedBox(width:8), const Text("🎁", style:TextStyle(color:Colors.white)), const SizedBox(width:8), Expanded(child:Container(padding:const EdgeInsets.symmetric(horizontal:12,vertical:8), decoration:BoxDecoration(color:Colors.black45, borderRadius:BorderRadius.circular(20)), child:const Text("قل شيئا", style:TextStyle(color:Colors.white54, fontSize:12))))])]))
    ]));
  }
}
class Ball{Offset pos; Color color; int num; bool out; Ball({required this.pos, required this.color, required this.num, this.out=false});}
class PoolPainter extends CustomPainter{
  final Offset cue; final List<Ball> balls; final Offset? s,c; PoolPainter(this.cue,this.balls,this.s,this.c);
  @override void paint(Canvas canvas, Size size){
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(0,0,size.width,size.height), const Radius.circular(16)), Paint()..color=const Color(0xFF5D4037));
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(8,8,size.width-16,size.height-16), const Radius.circular(12)), Paint()..color=const Color(0xFF2E7D32));
    var pockets=[Offset.zero, Offset(size.width/2,0), Offset(size.width,0), Offset(0,size.height), Offset(size.width/2,size.height), Offset(size.width,size.height)];
    for(var p in pockets){ canvas.drawCircle(p, 14, Paint()..color=Colors.black); canvas.drawCircle(p, 16, Paint()..color=const Color(0xFF3E2723)..style=PaintingStyle.stroke..strokeWidth=4); }
    for(var b in balls){ if(b.out) continue; canvas.drawCircle(b.pos, 9, Paint()..color=b.color); canvas.drawCircle(b.pos, 9, Paint()..color=Colors.black..style=PaintingStyle.stroke..strokeWidth=0.8); if(b.num==8){ canvas.drawCircle(b.pos, 3, Paint()..color=Colors.white); } }
    canvas.drawCircle(cue, 9, Paint()..color=Colors.white); canvas.drawCircle(cue, 9, Paint()..color=Colors.black..style=PaintingStyle.stroke..strokeWidth=1);
    if(s!=null&&c!=null){ canvas.drawLine(cue, cue+(s!-c!)*0.7, Paint()..color=Colors.yellow..strokeWidth=2); }
  }
  @override bool shouldRepaint(covariant CustomPainter o)=>true;
}

// ================= 2- دومينو قالب جاهز حقيقي =================
class DominoScreen extends StatefulWidget{const DominoScreen({super.key}); @override State<DominoScreen> createState()=>_DominoState();}
class _DominoState extends State<DominoScreen>{
  List<List<int>> hand=[[0,2],[2,5],[3,5],[1,3],[6,6],[4,4]]; List<List<int>> board=[];
  void play(int i){ var t=hand[i]; if(board.isEmpty){ setState((){ board.add(t); hand.removeAt(i); }); return; } int l=board.first[0]; int r=board.last[1]; if(t[0]==r||t[1]==r){ if(t[0]!=r) t=[t[1],t[0]]; setState((){ board.add(t); hand.removeAt(i); }); } else if(t[0]==l||t[1]==l){ if(t[1]!=l) t=[t[1],t[0]]; setState((){ board.insert(0,t); hand.removeAt(i); }); } }
  @override Widget build(BuildContext context){ return Scaffold(backgroundColor:const Color(0xFF2E7D32), appBar:AppBar(backgroundColor:const Color(0xFF1A2332), title:const WaitingMini(), leading:IconButton(icon:const Icon(Icons.arrow_back), onPressed:()=>Navigator.pop(context))), body:Column(children:[
    Container(padding:const EdgeInsets.all(12), color:const Color(0xFF4CAF50), child:Row(mainAxisAlignment:MainAxisAlignment.spaceBetween, children:[const Text("🪙 1500 LV.0", style:TextStyle(color:Colors.white, fontWeight:FontWeight.bold)), Row(children:[ _ic("📦"), _ic("🎯"), _ic("👑")])])),
    const SizedBox(height:8), Container(padding:const EdgeInsets.symmetric(horizontal:20,vertical:6), decoration:BoxDecoration(color:Colors.black54, borderRadius:BorderRadius.circular(20)), child:const Text("دومينو 50", style:TextStyle(color:Colors.white, fontWeight:FontWeight.bold, fontSize:13))),
    const SizedBox(height:8), Row(mainAxisAlignment:MainAxisAlignment.center, children:[ _btn("ترفيهي", Colors.amber), const SizedBox(width:8), _btn("معركة", const Color(0xFF66BB6A)), const SizedBox(width:8), _btn("إنشاء", const Color(0xFFAB47BC))]),
    const SizedBox(height:10), Center(child:SizedBox(width:360, height:100, child:Container(color:Colors.black26, child:SingleChildScrollView(scrollDirection:Axis.horizontal, child:Row(children:board.map((t)=> DominoTile(a:t[0], b:t[1])).toList()))))),
    const Spacer(),
    const Text("إيدك - لمس البلاطة للعب - نقط حقيقية", style:TextStyle(color:Colors.white70, fontSize:12)),
    Padding(padding:const EdgeInsets.all(10), child:Wrap(spacing:8, children:List.generate(hand.length, (i){ var t=hand[i]; return GestureDetector(onTap:()=>play(i), child:DominoTile(a:t[0], b:t[1], sel:true)); }))),
    Container(padding:const EdgeInsets.all(10), color:const Color(0xFF1A2332), child:Row(children:[const Expanded(child:Text("الغرفة الموصى بها: ملتقى آل سلاطين (14)", style:TextStyle(color:Colors.white, fontSize:11))), Container(padding:const EdgeInsets.symmetric(horizontal:12,vertical:8), decoration:BoxDecoration(color:Colors.black45, borderRadius:BorderRadius.circular(20)), child:const Text("قل شيئا", style:TextStyle(color:Colors.white54)))]))
  ])); }
  Widget _ic(String e)=>Container(margin:const EdgeInsets.only(left:6), padding:const EdgeInsets.all(8), decoration:BoxDecoration(color:Colors.black26, borderRadius:BorderRadius.circular(12)), child:Text(e, style:const TextStyle(fontSize:14)));
  Widget _btn(String t,Color c)=>Container(padding:const EdgeInsets.symmetric(horizontal:18,vertical:9), decoration:BoxDecoration(color:c, borderRadius:BorderRadius.circular(20)), child:Text(t, style:const TextStyle(color:Colors.white, fontWeight:FontWeight.bold, fontSize:12)));
}
class DominoTile extends StatelessWidget{
  final int a,b; final bool sel; const DominoTile({super.key, required this.a, required this.b, this.sel=false});
  @override Widget build(BuildContext context){ return Container(width:52, height:82, margin:const EdgeInsets.all(4), decoration:BoxDecoration(color:Colors.white, borderRadius:BorderRadius.circular(8), border:Border.all(color:sel? Colors.amber: Colors.black12, width:sel?2:1), boxShadow:const [BoxShadow(color:Colors.black26, blurRadius:3, offset:Offset(1,2))]), child:Column(children:[Expanded(child:CustomPaint(painter:DotPainter(a))), Container(height:1, color:Colors.black26), Expanded(child:CustomPaint(painter:DotPainter(b))) ])); }
}
class DotPainter extends CustomPainter{
  final int n; DotPainter(this.n);
  @override void paint(Canvas c, Size s){ if(n==0) return; var p=Paint()..color=Colors.black; var w=s.width, h=s.height; List<Offset> o=[]; if(n==1) o=[Offset(w/2,h/2)]; if(n==2) o=[Offset(w*0.25,h*0.25), Offset(w*0.75,h*0.75)]; if(n==3) o=[Offset(w*0.25,h*0.25), Offset(w/2,h/2), Offset(w*0.75,h*0.75)]; if(n==4) o=[Offset(w*0.25,h*0.25), Offset(w*0.75,h*0.25), Offset(w*0.25,h*0.75), Offset(w*0.75,h*0.75)]; if(n==5) o=[Offset(w*0.25,h*0.25), Offset(w*0.75,h*0.25), Offset(w/2,h/2), Offset(w*0.25,h*0.75), Offset(w*0.75,h*0.75)]; if(n==6) o=[Offset(w*0.25,h*0.25), Offset(w*0.25,h/2), Offset(w*0.25,h*0.75), Offset(w*0.75,h*0.25), Offset(w*0.75,h/2), Offset(w*0.75,h*0.75)]; for(var pos in o){ c.drawCircle(pos, 3.2, p); } }
  @override bool shouldRepaint(covariant CustomPainter o)=>false;
}

// ================= 3- لودو قالب حقيقي =================
class LudoScreen extends StatefulWidget{const LudoScreen({super.key}); @override State<LudoScreen> createState()=>_LState();}
class _LState extends State<LudoScreen>{
  int dice=2; int pos=13; final rnd=Random(); void roll(){ setState((){ dice=rnd.nextInt(6)+1; pos=(pos+dice)%40; }); }
  @override Widget build(BuildContext context){ return Scaffold(backgroundColor:const Color(0xFF0F2A66), appBar:AppBar(backgroundColor:const Color(0xFF1A2332), title:const WaitingMini(), leading:IconButton(icon:const Icon(Icons.arrow_back), onPressed:()=>Navigator.pop(context))), body:Container(decoration:const BoxDecoration(gradient:LinearGradient(begin:Alignment.topCenter, end:Alignment.bottomCenter, colors:[Color(0xFF2A6EDB), Color(0xFF0F2A66)])), child:Column(children:[
    const SizedBox(height:16), Container(padding:const EdgeInsets.symmetric(horizontal:36,vertical:12), decoration:BoxDecoration(color:const Color(0xFF22C55E), borderRadius:BorderRadius.circular(30)), child:const Text("العب مع الأصدقاء", style:TextStyle(color:Colors.white, fontWeight:FontWeight.bold))),
    const SizedBox(height:16), Center(child:SizedBox(width:360, height:360, child:CustomPaint(painter:LudoRealPainter(pos), size:const Size(360,360)))),
    const SizedBox(height:12), Text("موقعك $pos", style:const TextStyle(color:Colors.white)), const SizedBox(height:12),
    ElevatedButton(onPressed:roll, style:ElevatedButton.styleFrom(backgroundColor:Colors.white, padding:const EdgeInsets.symmetric(horizontal:40,vertical:12), shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(30))), child:Text("ارمي $dice", style:const TextStyle(color:Colors.black, fontSize:18))),
    const Spacer(), Container(padding:const EdgeInsets.all(10), color:const Color(0xFF1A2332), child:Row(mainAxisAlignment:MainAxisAlignment.spaceAround, children:List.generate(4, (i)=> Column(children:[CircleAvatar(backgroundImage:NetworkImage('https://i.pravatar.cc/100?img=${i+5}')), Text(["همام","سحاب","المجروح","الاكابر"][i], style:const TextStyle(color:Colors.white, fontSize:10))]))))
  ]))); }
}
class LudoRealPainter extends CustomPainter{
  final int pos; LudoRealPainter(this.pos);
  @override void paint(Canvas c, Size s){
    double cell=s.width/15; c.drawRect(Rect.fromLTWH(0,0,s.width,s.height), Paint()..color=Colors.white);
    c.drawRect(Rect.fromLTWH(0,0,6*cell,6*cell), Paint()..color=Colors.red); c.drawRect(Rect.fromLTWH(9*cell,0,6*cell,6*cell), Paint()..color=Colors.green);
    c.drawRect(Rect.fromLTWH(0,9*cell,6*cell,6*cell), Paint()..color=Colors.blue); c.drawRect(Rect.fromLTWH(9*cell,9*cell,6*cell,6*cell), Paint()..color=Colors.yellow);
    for(int i=0;i<15;i++){ for(int j=0;j<15;j++){ if((i>=6&&i<=8)||(j>=6&&j<=8)){ c.drawRect(Rect.fromLTWH(i*cell, j*cell, cell, cell), Paint()..color=Colors.white..style=PaintingStyle.stroke..strokeWidth=0.5); } } }
    // tokens 4
    c.drawCircle(Offset(3*cell,3*cell), 10, Paint()..color=Colors.white); c.drawCircle(Offset(12*cell,3*cell), 10, Paint()..color=Colors.white);
    c.drawCircle(Offset(3*cell,12*cell), 10, Paint()..color=Colors.white); c.drawCircle(Offset(12*cell,12*cell), 10, Paint()..color=Colors.yellow);
    // moving token
    double px=7.5*cell, py=6*cell; if(pos<5){ px=(6+pos)*cell; py=6*cell; } else if(pos<11){ px=11*cell; py=(6+pos-5)*cell; }
    c.drawCircle(Offset(px,py), 9, Paint()..color=Colors.yellow); c.drawCircle(Offset(px,py), 9, Paint()..color=Colors.black..style=PaintingStyle.stroke..strokeWidth=1.5);
  }
  @override bool shouldRepaint(covariant CustomPainter o)=>true;
}

// ================= 4- سلم وثعبان قالب حقيقي ملون حجم صغير =================
class SnakeScreen extends StatefulWidget{const SnakeScreen({super.key}); @override State<SnakeScreen> createState()=>_SState();}
class _SState extends State<SnakeScreen>{
  int pl=1; int dice=6; final rnd=Random(); final Map<int,int> snakes={99:54, 70:55, 52:42, 56:8, 62:19, 43:17}; final Map<int,int> ladders={3:22, 5:8, 11:26, 20:29, 27:56, 21:42, 36:51};
  void roll(){ int d=rnd.nextInt(6)+1; setState((){ dice=d; int nx=pl+d; if(nx<=100){ pl=nx; if(snakes.containsKey(pl)) pl=snakes[pl]!; if(ladders.containsKey(pl)) pl=ladders[pl]!; } }); }
  @override Widget build(BuildContext context){ return Scaffold(backgroundColor:const Color(0xFFFEF3C7), appBar:AppBar(backgroundColor:const Color(0xFF1A2332), title:const WaitingMini(), leading:IconButton(icon:const Icon(Icons.arrow_back), onPressed:()=>Navigator.pop(context))), body:Column(children:[
    const SizedBox(height:6), Center(child:SizedBox(width:360, height:480, child:CustomPaint(painter:SnakeRealPainter(pl, snakes, ladders), size:const Size(360,480)))),
    const SizedBox(height:6), Text("موقعك $pl / 100 - ${pl==100?"فزت! 🎉":""}", style:const TextStyle(fontWeight:FontWeight.bold, fontSize:14)),
    const SizedBox(height:6), GestureDetector(onTap:roll, child:Container(width:70, height:70, decoration:BoxDecoration(color:Colors.white, borderRadius:BorderRadius.circular(14), border:Border.all(width:2, color:Colors.black)), child:Center(child:Text("$dice", style:const TextStyle(fontSize:34, fontWeight:FontWeight.bold))))),
    const SizedBox(height:10),
  ])); }
}
class SnakeRealPainter extends CustomPainter{
  final int player; final Map<int,int> snakes,ladders; SnakeRealPainter(this.player,this.snakes,this.ladders);
  @override void paint(Canvas canvas, Size size){
    double w=size.width/10; double h=size.height/10; int num=100;
    for(int r=0;r<10;r++){ for(int c=0;c<10;c++){ int col=r%2==0? c: 9-c; var rect=Rect.fromLTWH(col*w, r*h, w, h);
      Color colr; if([1,0].contains(num%10)) colr=const Color(0xFFE57373); else if([2,8].contains(num%10)) colr=const Color(0xFF64B5F6); else if([3,7].contains(num%10)) colr=const Color(0xFFFFB74D); else if([4].contains(num%10)) colr=const Color(0xFFFFEB3B); else if([5].contains(num%10)) colr=const Color(0xFF81C784); else colr=Colors.white;
      canvas.drawRect(rect, Paint()..color=colr); canvas.drawRect(rect, Paint()..color=Colors.black..style=PaintingStyle.stroke..strokeWidth=0.4);
      var tp=TextPainter(text:TextSpan(text:"$num", style:TextStyle(fontSize:9, fontWeight:FontWeight.bold, color:colr==Colors.white? Colors.black: Colors.white)), textDirection:TextDirection.ltr)..layout(); tp.paint(canvas, Offset(rect.left+3, rect.top+2));
      if(num==player){ canvas.drawCircle(Offset(rect.center.dx, rect.center.dy+6), 9, Paint()..color=Colors.red); canvas.drawCircle(Offset(rect.center.dx, rect.center.dy+6), 9, Paint()..color=Colors.black..style=PaintingStyle.stroke..strokeWidth=1.2); }
      num--; }
    }
    var sPaint=Paint()..color=const Color(0xFF2196F3)..strokeWidth=5..strokeCap=StrokeCap.round..style=PaintingStyle.stroke;
    snakes.forEach((s,e){ var sp=Offset(((100-s)%10)*w + w/2, ((100-s)~/10)*h + h/2); var ep=Offset(((100-e)%10)*w + w/2, ((100-e)~/10)*h + h/2); var path=Path()..moveTo(sp.dx, sp.dy)..quadraticBezierTo((sp.dx+ep.dx)/2+25, (sp.dy+ep.dy)/2, ep.dx, ep.dy); canvas.drawPath(path, sPaint); canvas.drawCircle(sp, 7, Paint()..color=Colors.pink); canvas.drawCircle(sp.translate(2,1), 2, Paint()..color=Colors.white); });
    var lPaint=Paint()..color=Colors.white..strokeWidth=3..style=PaintingStyle.stroke..strokeCap=StrokeCap.round;
    ladders.forEach((s,e){ var sp=Offset(((s-1)%10)*w + w/2, (9-(s-1)~/10)*h + h/2); var ep=Offset(((e-1)%10)*w + w/2, (9-(e-1)~/10)*h + h/2); canvas.drawLine(sp, ep, lPaint); canvas.drawLine(sp.translate(8,0), ep.translate(8,0), lPaint); for(double t=0.25; t<0.9; t+=0.2){ var x=sp.dx+(ep.dx-sp.dx)*t; var y=sp.dy+(ep.dy-sp.dy)*t; canvas.drawLine(Offset(x,y), Offset(x+8,y), lPaint); } });
  }
  @override bool shouldRepaint(covariant CustomPainter o)=>true;
}
