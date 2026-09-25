import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'dart:math';
void main()=>runApp(const PlayAndWinApp());
class PlayAndWinApp extends StatelessWidget{const PlayAndWinApp({super.key}); @override Widget build(BuildContext context)=>const MaterialApp(debugShowCheckedModeBanner:false, home:LobbyScreen());}

// ================= اللوبي بكل شيء + طلبات صداقة + شات + كروت 3D أحلى =================
class LobbyScreen extends StatefulWidget{const LobbyScreen({super.key}); @override State<LobbyScreen> createState()=>_LobbyState();}
class _LobbyState extends State<LobbyScreen>{
  List<Map<String,String>> requests=[{"n":"أحمد","v":"V5","i":"10"},{"n":"نور","v":"V8","i":"11"}];
  List<String> generalChat=["همام: يلا نلعب؟","سحاب: أنا جاهز","المجروح: دومينو؟"];
  TextEditingController chatCtrl=TextEditingController();

  void showPrivateChat(String name){
    showDialog(context:context, builder:(_)=>AlertDialog(
      backgroundColor:const Color(0xFF1C2A45), title:Text("شات خاص مع $name", style:const TextStyle(color:Colors.white, fontSize:14)),
      content:SizedBox(height:200, child:Column(children:[const Expanded(child:Text("رسائل خاصة هنا...", style:TextStyle(color:Colors.white54))), Row(children:[Expanded(child:TextField(decoration:const InputDecoration(hintText:"قل شيئا خاص", hintStyle:TextStyle(color:Colors.white54)), style:const TextStyle(color:Colors.white))), IconButton(onPressed:(){ Navigator.pop(context); }, icon:const Icon(Icons.send, color:Colors.amber))])])),
    ));
  }
  void showRequests(){
    showModalBottomSheet(context:context, backgroundColor:const Color(0xFF0E172A), shape:const RoundedRectangleBorder(borderRadius:BorderRadius.vertical(top:Radius.circular(24))), builder:(_)=>Padding(padding:const EdgeInsets.all(16), child:Column(mainAxisSize:MainAxisSize.min, children:[
      const Text("طلبات الصداقة (2)", style:TextStyle(color:Colors.white, fontWeight:FontWeight.bold)), const SizedBox(height:12),
     ...requests.map((r)=> Container(margin:const EdgeInsets.only(bottom:10), padding:const EdgeInsets.all(12), decoration:BoxDecoration(color:const Color(0xFF1C2A45), borderRadius:BorderRadius.circular(12)), child:Row(mainAxisAlignment:MainAxisAlignment.spaceBetween, children:[
        Row(children:[CircleAvatar(backgroundImage:NetworkImage('https://i.pravatar.cc/100?img=${r["i"]}')), const SizedBox(width:8), Text(r["n"]!, style:const TextStyle(color:Colors.white)), const SizedBox(width:6), Container(padding:const EdgeInsets.symmetric(horizontal:4), decoration:BoxDecoration(color:Colors.amber, borderRadius:BorderRadius.circular(4)), child:Text(r["v"]!, style:const TextStyle(fontSize:9)))]),
        Row(children:[Container(padding:const EdgeInsets.symmetric(horizontal:12,vertical:6), decoration:BoxDecoration(color:Colors.green, borderRadius:BorderRadius.circular(20)), child:const Text("قبول", style:TextStyle(color:Colors.white, fontSize:11))), const SizedBox(width:6), Container(padding:const EdgeInsets.symmetric(horizontal:12,vertical:6), decoration:BoxDecoration(color:Colors.white24, borderRadius:BorderRadius.circular(20)), child:const Text("رفض", style:TextStyle(color:Colors.white, fontSize:11)))])
      ]))),
    ])));
  }

  @override Widget build(BuildContext context){
    final friends=[{"n":"همام","v":"V6","i":"1"},{"n":"سحاب","v":"V7","i":"2"},{"n":"انا المجروح","v":"V6","i":"3"},{"n":"ابن الاكابر","v":"V6","i":"4"}];
    return Scaffold(backgroundColor:const Color(0xFF0A1020), body:SafeArea(child:Column(children:[
      Container(padding:const EdgeInsets.all(12), color:const Color(0xFF1A2332), child:Row(mainAxisAlignment:MainAxisAlignment.spaceBetween, children:[
        Row(children:[const CircleAvatar(backgroundImage:NetworkImage('https://i.pravatar.cc/100?img=12')), const SizedBox(width:8),
          Container(padding:const EdgeInsets.symmetric(horizontal:12,vertical:6), decoration:BoxDecoration(color:Colors.black45, borderRadius:BorderRadius.circular(20)), child:const Row(children:[Text("🪙 1500", style:TextStyle(color:Colors.white)), SizedBox(width:4), CircleAvatar(radius:10, backgroundColor:Colors.amber, child:Text("+", style:TextStyle(color:Colors.black, fontSize:12))) ])),
          const SizedBox(width:6), GestureDetector(onTap:showRequests, child:Stack(children:[Container(padding:const EdgeInsets.all(8), decoration:BoxDecoration(color:Colors.black26, borderRadius:BorderRadius.circular(20)), child:const Text("👥")), Positioned(right:0, top:0, child:Container(width:16, height:16, decoration:const BoxDecoration(color:Colors.red, shape:BoxShape.circle), child:const Center(child:Text("2", style:TextStyle(fontSize:9, color:Colors.white)))))])),
          const SizedBox(width:6), Container(padding:const EdgeInsets.all(8), decoration:BoxDecoration(color:Colors.black26, borderRadius:BorderRadius.circular(20)), child:const Text("🎁")),
        ]),
        Row(children:[Container(padding:const EdgeInsets.all(8), decoration:BoxDecoration(color:Colors.black26, borderRadius:BorderRadius.circular(20)), child:const Text("🔍", style:TextStyle(color:Colors.white, fontSize:12))), const SizedBox(width:6), Container(padding:const EdgeInsets.all(8), decoration:BoxDecoration(color:Colors.black26, borderRadius:BorderRadius.circular(20)), child:const Text("👑 TOP", style:TextStyle(color:Colors.white, fontSize:12)))])
      ])),
      Expanded(child:SingleChildScrollView(child:Column(children:[
        Padding(padding:const EdgeInsets.all(14), child:Column(children:[
          Row(mainAxisAlignment:MainAxisAlignment.spaceBetween, children:[const Text("ألعاب عادية", style:TextStyle(color:Colors.white, fontWeight:FontWeight.bold, fontSize:18)), Container(padding:const EdgeInsets.symmetric(horizontal:12,vertical:6), decoration:BoxDecoration(color:Colors.white10, borderRadius:BorderRadius.circular(20)), child:const Text("غرفة خاصة +", style:TextStyle(color:Colors.white, fontSize:12))) ]),
          const SizedBox(height:12),
          GridView.count(shrinkWrap:true, physics:const NeverScrollableScrollPhysics(), crossAxisCount:2, childAspectRatio:0.95, mainAxisSpacing:16, crossAxisSpacing:14, children:[
            _prettyCard(context,"كيرم / بلياردو",[const Color(0xFFFF9800), const Color(0xFF5D4037)],"🎯✨",const BilliardScreen()),
            _prettyCard(context,"دومينو 50",[const Color(0xFF66BB6A), const Color(0xFF1B5E20)],"🀄🔥",const DominoScreen()),
            _prettyCard(context,"لودو",[const Color(0xFF42A5F5), const Color(0xFF0D47A1)],"🎲👑",const LudoScreen()),
            _prettyCard(context,"السلم والثعبان",[const Color(0xFFBA68C8), const Color(0xFF4A148C)],"🐍🪜",const SnakeScreen()),
          ]),
        ])),
        Container(decoration:const BoxDecoration(color:Color(0xFF0E172A), borderRadius:BorderRadius.vertical(top:Radius.circular(24))), padding:const EdgeInsets.all(16), child:Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
          Row(mainAxisAlignment:MainAxisAlignment.spaceBetween, children:[const Text("ابحث عن صديق - غرفة الانتظار", style:TextStyle(color:Colors.white, fontWeight:FontWeight.bold)), Container(padding:const EdgeInsets.symmetric(horizontal:10,vertical:4), decoration:BoxDecoration(color:Colors.white10, borderRadius:BorderRadius.circular(20)), child:Text("عام (${generalChat.length})", style:const TextStyle(color:Colors.white70, fontSize:11)))]),
          const SizedBox(height:8), Container(height:60, padding:const EdgeInsets.all(8), decoration:BoxDecoration(color:Colors.black26, borderRadius:BorderRadius.circular(12)), child:ListView(children: generalChat.map((m)=> Text(m, style:const TextStyle(color:Colors.white70, fontSize:11))).toList())),
          const SizedBox(height:12),
         ...friends.map((f)=> GestureDetector(onTap:()=>showPrivateChat(f["n"]!), child:Container(margin:const EdgeInsets.only(bottom:10), padding:const EdgeInsets.all(12), decoration:BoxDecoration(color:const Color(0xFF1C2A45), borderRadius:BorderRadius.circular(16), boxShadow:[BoxShadow(color:Colors.black45, blurRadius:6, offset:const Offset(0,3))]), child:Row(mainAxisAlignment:MainAxisAlignment.spaceBetween, children:[
            Row(children:[CircleAvatar(radius:22, backgroundImage:NetworkImage('https://i.pravatar.cc/100?img=${f["i"]}')), const SizedBox(width:10), Column(crossAxisAlignment:CrossAxisAlignment.start, children:[Row(children:[Text(f["n"]!, style:const TextStyle(color:Colors.white, fontSize:13, fontWeight:FontWeight.bold)), const SizedBox(width:6), Container(padding:const EdgeInsets.symmetric(horizontal:4), decoration:BoxDecoration(color:Colors.amber, borderRadius:BorderRadius.circular(4)), child:Text(f["v"]!, style:const TextStyle(fontSize:9, color:Colors.black)))]), const Text("يشاهد اللعب - اضغط لشات خاص", style:TextStyle(color:Colors.white54, fontSize:10))])]),
            Container(padding:const EdgeInsets.symmetric(horizontal:18,vertical:6), decoration:BoxDecoration(gradient:const LinearGradient(colors:[Color(0xFF22C55E), Color(0xFF16A34A)]), borderRadius:BorderRadius.circular(20)), child:const Text("إنضم", style:TextStyle(color:Colors.white, fontWeight:FontWeight.bold, fontSize:12)))
          ])))),
        ]))
      ]))),
      Container(padding:const EdgeInsets.all(8), color:const Color(0xFF1A2332), child:Row(children:[Expanded(child:TextField(controller:chatCtrl, style:const TextStyle(color:Colors.white, fontSize:12), decoration:InputDecoration(hintText:"دردشة عامة - قل شيئا...", hintStyle:const TextStyle(color:Colors.white54, fontSize:12), filled:true, fillColor:Colors.black45, border:OutlineInputBorder(borderRadius:BorderRadius.circular(20), borderSide:BorderSide.none), contentPadding:const EdgeInsets.symmetric(horizontal:14, vertical:8)))), const SizedBox(width:6), GestureDetector(onTap:(){ if(chatCtrl.text.isNotEmpty){ setState(()=> generalChat.add("أنت: ${chatCtrl.text}")); chatCtrl.clear(); } }, child:Container(padding:const EdgeInsets.all(10), decoration:const BoxDecoration(color:Colors.amber, shape:BoxShape.circle), child:const Icon(Icons.send, size:16))) ]))
    ])));
  }
  Widget _prettyCard(BuildContext c,String t,List<Color> col,String e,Widget p)=>GestureDetector(onTap:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>p)), child:Container(decoration:BoxDecoration(gradient:LinearGradient(begin:Alignment.topLeft, end:Alignment.bottomRight, colors:col), borderRadius:BorderRadius.circular(24), boxShadow:[BoxShadow(color:col[0].withOpacity(0.5), blurRadius:12, offset:const Offset(0,6)), BoxShadow(color:Colors.black45, blurRadius:8, offset:const Offset(0,3))], border:Border.all(color:Colors.white.withOpacity(0.2), width:1.5)), child:Stack(children:[Positioned(top:-10, right:-10, child:Container(width:60, height:60, decoration:BoxDecoration(color:Colors.white.withOpacity(0.15), shape:BoxShape.circle))), Column(mainAxisAlignment:MainAxisAlignment.center, children:[Text(e, style:const TextStyle(fontSize:42)), const SizedBox(height:10), Container(padding:const EdgeInsets.symmetric(horizontal:14,vertical:6), decoration:BoxDecoration(color:Colors.black54, borderRadius:BorderRadius.circular(20), border:Border.all(color:Colors.amber.withOpacity(0.5))), child:Text(t, style:const TextStyle(color:Colors.white, fontSize:12, fontWeight:FontWeight.bold)))])])));
}
class WaitingMini extends StatelessWidget{const WaitingMini({super.key}); @override Widget build(BuildContext context)=>const Row(children:[CircleAvatar(radius:12, backgroundImage:NetworkImage('https://i.pravatar.cc/100?img=8')), SizedBox(width:4), Text("غرفة الانتظار (4) - عام وخاص", style:TextStyle(color:Colors.white70, fontSize:11))]);}

// ========== بلياردو كامل ==========
class BilliardScreen extends StatefulWidget{const BilliardScreen({super.key}); @override State<BilliardScreen> createState()=>_BState();}
class _BState extends State<BilliardScreen> with SingleTickerProviderStateMixin{
  Offset? ds, dc; Offset cue=const Offset(200,380); Offset vel=Offset.zero; List<Ball> balls=[]; late Ticker tk; int sc=0; List<String> chat=["عام: يلا","59: هلا"];
  @override void initState(){super.initState(); _reset(); tk=createTicker(_tick); tk.start();}
  void _reset(){ balls=[]; double sx=200, sy=110; int k=0; List<Color> cols=[Colors.yellow, Colors.blue, Colors.red, Colors.purple, Colors.orange, Colors.green, Colors.brown, Colors.black, Colors.yellow, Colors.blue, Colors.red, Colors.purple, Colors.orange, Colors.green, Colors.brown]; for(int r=0;r<5;r++){ for(int c=0;c<=r;c++){ if(k>=15) break; double x=sx + (c - r/2)*22; double y=sy + r*20; balls.add(Ball(pos:Offset(x,y), color:cols[k], num:k+1)); k++; }} cue=const Offset(200,380); sc=0; }
  void _tick(Duration _){ if(vel==Offset.zero) return; setState((){ cue=cue+vel; vel=vel*0.985; if(vel.distance<0.2) vel=Offset.zero; if(cue.dx<28||cue.dx>372) vel=Offset(-vel.dx, vel.dy); if(cue.dy<28||cue.dy>572) vel=Offset(vel.dx, -vel.dy); for(int i=0;i<balls.length;i++){ if(balls[i].out) continue; if((cue-balls[i].pos).distance<20){ var dir=balls[i].pos-cue; var l=dir.distance; if(l>0){ dir=dir/l; balls[i].pos=balls[i].pos+dir*8; } } if(balls[i].pos.dx<14||balls[i].pos.dx>386||balls[i].pos.dy<14||balls[i].pos.dy>586){ balls[i].out=true; sc++; } } });}
  @override void dispose(){tk.dispose(); super.dispose();}
  @override Widget build(BuildContext context){
    double pow=0; if(ds!=null&&dc!=null){ pow=(ds!-dc!).distance; if(pow>100) pow=100; }
    return Scaffold(backgroundColor:const Color(0xFF0A1020), appBar:AppBar(backgroundColor:const Color(0xFF1A2332), title:const WaitingMini(), leading:IconButton(icon:const Icon(Icons.arrow_back), onPressed:()=>Navigator.pop(context))), body:Column(children:[
      LinearProgressIndicator(value:pow/100, color:Colors.amber, backgroundColor:Colors.white12),
      Expanded(child:Center(child:SizedBox(width:400, height:600, child:GestureDetector(onPanStart:(d)=>setState(()=>ds=d.localPosition), onPanUpdate:(d)=>setState(()=>dc=d.localPosition), onPanEnd:(_){ if(ds!=null&&dc!=null){ vel=(ds!-dc!)*0.13; } setState(()=>{ds=null, dc=null}); }, child:CustomPaint(painter:PoolPainter(cue,balls,ds,dc)))))),
      Container(padding:const EdgeInsets.all(8), color:const Color(0xFF1A2332), child:Column(children:[Row(mainAxisAlignment:MainAxisAlignment.spaceAround, children:List.generate(4, (i)=> GestureDetector(onTap:(){ showDialog(context:context, builder:(_)=> AlertDialog(backgroundColor:const Color(0xFF1C2A45), title:Text("شات خاص مع ${["همام","سحاب","المجروح","الاكابر"][i]}", style:const TextStyle(color:Colors.white, fontSize:12)))); }, child:Column(children:[CircleAvatar(backgroundImage:NetworkImage('https://i.pravatar.cc/100?img=${i+1}')), Text("$sc", style:const TextStyle(color:Colors.white))])))), const SizedBox(height:6), Row(children:[const Text("💬 59", style:TextStyle(color:Colors.white)), const SizedBox(width:8), const Text("🎁", style:TextStyle(color:Colors.white)), const SizedBox(width:8), Expanded(child:Container(padding:const EdgeInsets.symmetric(horizontal:12,vertical:8), decoration:BoxDecoration(color:Colors.black45, borderRadius:BorderRadius.circular(20)), child:const Text("دردشة عامة - قل شيئا", style:TextStyle(color:Colors.white54, fontSize:12))))])]))
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
    for(var p in pockets){ canvas.drawCircle(p, 14, Paint()..color=Colors.black); }
    for(var b in balls){ if(b.out) continue; canvas.drawCircle(b.pos, 9, Paint()..color=b.color); }
    canvas.drawCircle(cue, 9, Paint()..color=Colors.white);
    if(s!=null&&c!=null){ canvas.drawLine(cue, cue+(s!-c!)*0.7, Paint()..color=Colors.yellow..strokeWidth=2); }
  }
  @override bool shouldRepaint(covariant CustomPainter o)=>true;
}

// ========== دومينو كامل ==========
class DominoScreen extends StatefulWidget{const DominoScreen({super.key}); @override State<DominoScreen> createState()=>_DominoState();}
class _DominoState extends State<DominoScreen>{
  List<List<int>> hand=[[0,2],[2,5],[3,5],[1,3],[6,6],[4,4]]; List<List<int>> board=[];
  void play(int i){ var t=hand[i]; if(board.isEmpty){ setState((){ board.add(t); hand.removeAt(i); }); return; } int l=board.first[0]; int r=board.last[1]; if(t[0]==r||t[1]==r){ if(t[0]!=r) t=[t[1],t[0]]; setState((){ board.add(t); hand.removeAt(i); }); } else if(t[0]==l||t[1]==l){ if(t[1]!=l) t=[t[1],t[0]]; setState((){ board.insert(0,t); hand.removeAt(i); }); } }
  @override Widget build(BuildContext context){ return Scaffold(backgroundColor:const Color(0xFF2E7D32), appBar:AppBar(backgroundColor:const Color(0xFF1A2332), title:const WaitingMini(), leading:IconButton(icon:const Icon(Icons.arrow_back), onPressed:()=>Navigator.pop(context))), body:Column(children:[
    Container(padding:const EdgeInsets.all(12), color:const Color(0xFF4CAF50), child:Row(mainAxisAlignment:MainAxisAlignment.spaceBetween, children:[const Text("🪙 1500 LV.0", style:TextStyle(color:Colors.white, fontWeight:FontWeight.bold)), Row(children:[_ic("📦"), _ic("🎯"), _ic("👑")])])),
    const SizedBox(height:8), Container(padding:const EdgeInsets.symmetric(horizontal:20,vertical:6), decoration:BoxDecoration(color:Colors.black54, borderRadius:BorderRadius.circular(20)), child:const Text("دومينو 50", style:TextStyle(color:Colors.white, fontWeight:FontWeight.bold))),
    const SizedBox(height:8), Row(mainAxisAlignment:MainAxisAlignment.center, children:[_btn("ترفيهي", Colors.amber), const SizedBox(width:8), _btn("معركة", const Color(0xFF66BB6A)), const SizedBox(width:8), _btn("إنشاء", const Color(0xFFAB47BC))]),
    const SizedBox(height:10), Center(child:SizedBox(width:360, height:100, child:Container(color:Colors.black26, child:SingleChildScrollView(scrollDirection:Axis.horizontal, child:Row(children:board.map((t)=> DominoTile(a:t[0], b:t[1])).toList()))))),
    const Spacer(),
    Padding(padding:const EdgeInsets.all(10), child:Wrap(spacing:8, children:List.generate(hand.length, (i){ var t=hand[i]; return GestureDetector(onTap:()=>play(i), child:DominoTile(a:t[0], b:t[1], sel:true)); }))),
    Container(padding:const EdgeInsets.all(10), color:const Color(0xFF1A2332), child:Row(children:[const Expanded(child:Text("الغرفة الموصى بها: ملتقى آل سلاطين (14) - دردشة عام وخاص", style:TextStyle(color:Colors.white, fontSize:10))), Container(padding:const EdgeInsets.symmetric(horizontal:12,vertical:8), decoration:BoxDecoration(color:Colors.black45, borderRadius:BorderRadius.circular(20)), child:const Text("قل شيئا", style:TextStyle(color:Colors.white54)))]))
  ])); }
  Widget _ic(String e)=>Container(margin:const EdgeInsets.only(left:6), padding:const EdgeInsets.all(8), decoration:BoxDecoration(color:Colors.black26, borderRadius:BorderRadius.circular(12)), child:Text(e));
  Widget _btn(String t,Color c)=>Container(padding:const EdgeInsets.symmetric(horizontal:18,vertical:9), decoration:BoxDecoration(color:c, borderRadius:BorderRadius.circular(20)), child:Text(t, style:const TextStyle(color:Colors.white, fontWeight:FontWeight.bold, fontSize:12)));
}
class DominoTile extends StatelessWidget{
  final int a,b; final bool sel; const DominoTile({super.key, required this.a, required this.b, this.sel=false});
  @override Widget build(BuildContext context){ return Container(width:52, height:82, margin:const EdgeInsets.all(4), decoration:BoxDecoration(color:Colors.white, borderRadius:BorderRadius.circular(8), border:Border.all(color:sel? Colors.amber: Colors.black12, width:sel?2:1)), child:Column(children:[Expanded(child:CustomPaint(painter:DotPainter(a))), Container(height:1, color:Colors.black26), Expanded(child:CustomPaint(painter:DotPainter(b))) ])); }
}
class DotPainter extends CustomPainter{
  final int n; DotPainter(this.n);
  @override void paint(Canvas c, Size s){ if(n==0) return; var p=Paint()..color=Colors.black; var w=s.width, h=s.height; List<Offset> o=[]; if(n==1) o=[Offset(w/2,h/2)]; if(n==2) o=[Offset(w*0.25,h*0.25), Offset(w*0.75,h*0.75)]; if(n==3) o=[Offset(w*0.25,h*0.25), Offset(w/2,h/2), Offset(w*0.75,h*0.75)]; if(n==4) o=[Offset(w*0.25,h*0.25), Offset(w*0.75,h*0.25), Offset(w*0.25,h*0.75), Offset(w*0.75,h*0.75)]; if(n==5) o=[Offset(w*0.25,h*0.25), Offset(w*0.75,h*0.25), Offset(w/2,h/2), Offset(w*0.25,h*0.75), Offset(w*0.75,h*0.75)]; if(n==6) o=[Offset(w*0.25,h*0.25), Offset(w*0.25,h/2), Offset(w*0.25,h*0.75), Offset(w*0.75,h*0.25), Offset(w*0.75,h/2), Offset(w*0.75,h*0.75)]; for(var pos in o){ c.drawCircle(pos, 3.2, p); } }
  @override bool shouldRepaint(covariant CustomPainter o)=>false;
}

// ========== لودو وسلم وثعبان نفس القديم بس حجم صغير ==========
class LudoScreen extends StatefulWidget{const LudoScreen({super.key}); @override State<LudoScreen> createState()=>_LState();}
class _LState extends State<LudoScreen>{
  int dice=2; int pos=13; final rnd=Random(); void roll(){ setState((){ dice=rnd.nextInt(6)+1; pos=(pos+dice)%40; }); }
  @override Widget build(BuildContext context){ return Scaffold(backgroundColor:const Color(0xFF0F2A66), appBar:AppBar(backgroundColor:const Color(0xFF1A2332), title:const WaitingMini(), leading:IconButton(icon:const Icon(Icons.arrow_back), onPressed:()=>Navigator.pop(context))), body:Column(children:[
    const SizedBox(height:16), Container(padding:const EdgeInsets.symmetric(horizontal:36,vertical:12), decoration:BoxDecoration(color:const Color(0xFF22C55E), borderRadius:BorderRadius.circular(30)), child:const Text("العب مع الأصدقاء", style:TextStyle(color:Colors.white, fontWeight:FontWeight.bold))),
    const SizedBox(height:16), Center(child:SizedBox(width:360, height:360, child:CustomPaint(painter:LudoRealPainter(pos), size:const Size(360,360)))),
    ElevatedButton(onPressed:roll, child:Text("ارمي $dice")),
  ])); }
}
class LudoRealPainter extends CustomPainter{
  final int pos; LudoRealPainter(this.pos);
  @override void paint(Canvas c, Size s){
    double cell=s.width/15; c.drawRect(Rect.fromLTWH(0,0,s.width,s.height), Paint()..color=Colors.white);
    c.drawRect(Rect.fromLTWH(0,0,6*cell,6*cell), Paint()..color=Colors.red); c.drawRect(Rect.fromLTWH(9*cell,0,6*cell,6*cell), Paint()..color=Colors.green);
    c.drawRect(Rect.fromLTWH(0,9*cell,6*cell,6*cell), Paint()..color=Colors.blue); c.drawRect(Rect.fromLTWH(9*cell,9*cell,6*cell,6*cell), Paint()..color=Colors.yellow);
    for(int i=0;i<15;i++){ for(int j=0;j<15;j++){ if((i>=6&&i<=8)||(j>=6&&j<=8)){ c.drawRect(Rect.fromLTWH(i*cell, j*cell, cell, cell), Paint()..color=Colors.white..style=PaintingStyle.stroke); } } }
    c.drawCircle(Offset(12*cell,12*cell), 9, Paint()..color=Colors.yellow);
  }
  @override bool shouldRepaint(covariant CustomPainter o)=>true;
}
class SnakeScreen extends StatefulWidget{const SnakeScreen({super.key}); @override State<SnakeScreen> createState()=>_SState();}
class _SState extends State<SnakeScreen>{
  int pl=1; int dice=6; final rnd=Random(); final Map<int,int> snakes={99:54, 70:55, 52:42, 56:8, 62:19}; final Map<int,int> ladders={3:22, 5:8, 11:26, 20:29, 27:56};
  void roll(){ int d=rnd.nextInt(6)+1; setState((){ dice=d; int nx=pl+d; if(nx<=100){ pl=nx; if(snakes.containsKey(pl)) pl=snakes[pl]!; if(ladders.containsKey(pl)) pl=ladders[pl]!; } }); }
  @override Widget build(BuildContext context){ return Scaffold(backgroundColor:const Color(0xFFFEF3C7), appBar:AppBar(backgroundColor:const Color(0xFF1A2332), title:const WaitingMini(), leading:IconButton(icon:const Icon(Icons.arrow_back), onPressed:()=>Navigator.pop(context))), body:Column(children:[
    Center(child:SizedBox(width:360, height:480, child:CustomPaint(painter:SnakeRealPainter(pl, snakes, ladders), size:const Size(360,480)))),
    Text("موقعك $pl / 100"), GestureDetector(onTap:roll, child:Container(width:70, height:70, decoration:BoxDecoration(color:Colors.white, borderRadius:BorderRadius.circular(12), border:Border.all(width:2)), child:Center(child:Text("$dice", style:const TextStyle(fontSize:34))))),
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
      if(num==player){ canvas.drawCircle(Offset(rect.center.dx, rect.center.dy+6), 9, Paint()..color=Colors.red); }
      num--; }
    }
    var sPaint=Paint()..color=const Color(0xFF2196F3)..strokeWidth=5..strokeCap=StrokeCap.round..style=PaintingStyle.stroke;
    snakes.forEach((s,e){ var sp=Offset(((100-s)%10)*w + w/2, ((100-s)~/10)*h + h/2); var ep=Offset(((100-e)%10)*w + w/2, ((100-e)~/10)*h + h/2); var path=Path()..moveTo(sp.dx, sp.dy)..quadraticBezierTo((sp.dx+ep.dx)/2+25, (sp.dy+ep.dy)/2, ep.dx, ep.dy); canvas.drawPath(path, sPaint); canvas.drawCircle(sp, 7, Paint()..color=Colors.pink); });
    var lPaint=Paint()..color=Colors.white..strokeWidth=3..style=PaintingStyle.stroke;
    ladders.forEach((s,e){ var sp=Offset(((s-1)%10)*w + w/2, (9-(s-1)~/10)*h + h/2); var ep=Offset(((e-1)%10)*w + w/2, (9-(e-1)~/10)*h + h/2); canvas.drawLine(sp, ep, lPaint); canvas.drawLine(sp.translate(8,0), ep.translate(8,0), lPaint); for(double t=0.25; t<0.9; t+=0.2){ var x=sp.dx+(ep.dx-sp.dx)*t; var y=sp.dy+(ep.dy-sp.dy)*t; canvas.drawLine(Offset(x,y), Offset(x+8,y), lPaint); } });
  }
  @override bool shouldRepaint(covariant CustomPainter o)=>true;
}
