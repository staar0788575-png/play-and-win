import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'dart:math';
void main()=>runApp(const PlayAndWinApp());
class PlayAndWinApp extends StatelessWidget{const PlayAndWinApp({super.key}); @override Widget build(BuildContext context)=>const MaterialApp(debugShowCheckedModeBanner:false, home:LobbyScreen());}

class LobbyScreen extends StatefulWidget{const LobbyScreen({super.key}); @override State<LobbyScreen> createState()=>_LobbyState();}
class _LobbyState extends State<LobbyScreen>{
  List<Map<String,String>> requests=[{"n":"أحمد","v":"V5","i":"10"},{"n":"نور","v":"V8","i":"11"}];
  List<String> generalChat=["همام: يلا نلعب؟","سحاب: أنا جاهز"];
  TextEditingController chatCtrl=TextEditingController();
  // سيستم الروبوتات الذكي
  List<Map<String,String>> getPlayers(List<Map<String,String>> real){
    List<Map<String,String>> all=List.from(real);
    List<Map<String,String>> robots=[{"n":"روبوت 1","v":"BOT","i":"20"},{"n":"روبوت 2","v":"BOT","i":"21"},{"n":"روبوت 3","v":"BOT","i":"22"}];
    int need=4-all.length; for(int i=0;i<need && i<robots.length;i++){ all.add(robots[i]); } return all;
  }
  void showPrivateChat(String name){ showDialog(context:context, builder:(_)=>AlertDialog(backgroundColor:const Color(0xFF1C2A45), title:Text("شات خاص مع $name", style:const TextStyle(color:Colors.white, fontSize:12)), content:const Text("رسائل خاصة...", style:TextStyle(color:Colors.white54)))); }
  void showRequests(){ showModalBottomSheet(context:context, backgroundColor:const Color(0xFF0E172A), shape:const RoundedRectangleBorder(borderRadius:BorderRadius.vertical(top:Radius.circular(24))), builder:(_)=>Padding(padding:const EdgeInsets.all(16), child:Column(mainAxisSize:MainAxisSize.min, children:[const Text("طلبات الصداقة (2)", style:TextStyle(color:Colors.white, fontWeight:FontWeight.bold)), const SizedBox(height:12),...requests.map((r)=> Container(margin:const EdgeInsets.only(bottom:10), padding:const EdgeInsets.all(12), decoration:BoxDecoration(color:const Color(0xFF1C2A45), borderRadius:BorderRadius.circular(12)), child:Row(mainAxisAlignment:MainAxisAlignment.spaceBetween, children:[Row(children:[CircleAvatar(backgroundImage:NetworkImage('https://i.pravatar.cc/100?img=${r["i"]}')), const SizedBox(width:8), Text(r["n"]!, style:const TextStyle(color:Colors.white))]), Row(children:[Container(padding:const EdgeInsets.symmetric(horizontal:12,vertical:6), decoration:BoxDecoration(color:Colors.green, borderRadius:BorderRadius.circular(20)), child:const Text("قبول", style:TextStyle(color:Colors.white, fontSize:11))), const SizedBox(width:6), Container(padding:const EdgeInsets.symmetric(horizontal:12,vertical:6), decoration:BoxDecoration(color:Colors.white24, borderRadius:BorderRadius.circular(20)), child:const Text("رفض", style:TextStyle(color:Colors.white, fontSize:11)))])])))]))); }
  @override Widget build(BuildContext context){
    final friends=[{"n":"همام","v":"V6","i":"1"},{"n":"سحاب","v":"V7","i":"2"}]; final displayFriends=getPlayers(friends);
    return Scaffold(backgroundColor:const Color(0xFF0A1020), body:SafeArea(child:Column(children:[
      Container(padding:const EdgeInsets.all(12), color:const Color(0xFF1A2332), child:Row(mainAxisAlignment:MainAxisAlignment.spaceBetween, children:[
        Row(children:[const CircleAvatar(backgroundImage:NetworkImage('https://i.pravatar.cc/100?img=12')), const SizedBox(width:8), Container(padding:const EdgeInsets.symmetric(horizontal:12,vertical:6), decoration:BoxDecoration(color:Colors.black45, borderRadius:BorderRadius.circular(20)), child:const Row(children:[Text("🪙 1500", style:TextStyle(color:Colors.white)), SizedBox(width:4), CircleAvatar(radius:10, backgroundColor:Colors.amber, child:Text("+", style:TextStyle(fontSize:10)))])), const SizedBox(width:6), GestureDetector(onTap:showRequests, child:Stack(children:[Container(padding:const EdgeInsets.all(8), decoration:BoxDecoration(color:Colors.black26, borderRadius:BorderRadius.circular(20)), child:const Text("👥")), Positioned(right:0, top:0, child:Container(width:16, height:16, decoration:const BoxDecoration(color:Colors.red, shape:BoxShape.circle), child:const Center(child:Text("2", style:TextStyle(fontSize:9, color:Colors.white)))))]))]),
        Row(children:[Container(padding:const EdgeInsets.all(8), decoration:BoxDecoration(color:Colors.black26, borderRadius:BorderRadius.circular(20)), child:const Text("🔍", style:TextStyle(color:Colors.white, fontSize:12))), const SizedBox(width:6), Container(padding:const EdgeInsets.all(8), decoration:BoxDecoration(color:Colors.black26, borderRadius:BorderRadius.circular(20)), child:const Text("👑 TOP", style:TextStyle(color:Colors.white, fontSize:12)))])
      ])),
      Expanded(child:SingleChildScrollView(child:Column(children:[
        Padding(padding:const EdgeInsets.all(14), child:Column(children:[
          Row(mainAxisAlignment:MainAxisAlignment.spaceBetween, children:[const Text("ألعاب عادية", style:TextStyle(color:Colors.white, fontWeight:FontWeight.bold, fontSize:18)), Container(padding:const EdgeInsets.symmetric(horizontal:12,vertical:6), decoration:BoxDecoration(color:Colors.white10, borderRadius:BorderRadius.circular(20)), child:const Text("غرفة خاصة +", style:TextStyle(color:Colors.white, fontSize:12))) ]),
          const SizedBox(height:12),
          GridView.count(shrinkWrap:true, physics:const NeverScrollableScrollPhysics(), crossAxisCount:2, childAspectRatio:0.90, mainAxisSpacing:16, crossAxisSpacing:14, children:[
            _prettyCard(context,"كيرم / بلياردو",[const Color(0xFFFF9800), const Color(0xFF5D4037)],"🎯",const BilliardScreen()),
            _prettyCard(context,"دومينو 50",[const Color(0xFF66BB6A), const Color(0xFF1B5E20)],"🀄",const DominoScreen()),
            _prettyCard(context,"لودو",[const Color(0xFF42A5F5), const Color(0xFF0D47A1)],"🎲",const LudoScreen()),
            _prettyCard(context,"السلم والثعبان",[const Color(0xFFBA68C8), const Color(0xFF4A148C)],"🐍",const SnakeScreen()),
          ]),
        ])),
        Container(decoration:const BoxDecoration(color:Color(0xFF0E172A), borderRadius:BorderRadius.vertical(top:Radius.circular(24))), padding:const EdgeInsets.all(16), child:Column(children:[
          const Text("غرفة الانتظار - لو مفيش حقيقيين نكمل بروبوتات", style:TextStyle(color:Colors.white70, fontSize:11)), const SizedBox(height:8),
         ...displayFriends.map((f)=> GestureDetector(onTap:()=>showPrivateChat(f["n"]!), child:Container(margin:const EdgeInsets.only(bottom:10), padding:const EdgeInsets.all(12), decoration:BoxDecoration(color:const Color(0xFF1C2A45), borderRadius:BorderRadius.circular(16)), child:Row(mainAxisAlignment:MainAxisAlignment.spaceBetween, children:[Row(children:[CircleAvatar(radius:22, backgroundImage:NetworkImage('https://i.pravatar.cc/100?img=${f["i"]}')), const SizedBox(width:10), Column(crossAxisAlignment:CrossAxisAlignment.start, children:[Row(children:[Text(f["n"]!, style:const TextStyle(color:Colors.white, fontSize:13, fontWeight:FontWeight.bold)), const SizedBox(width:6), Container(padding:const EdgeInsets.symmetric(horizontal:4), decoration:BoxDecoration(color:f["v"]=="BOT"?Colors.grey:Colors.amber, borderRadius:BorderRadius.circular(4)), child:Text(f["v"]!, style:const TextStyle(fontSize:9)))]), const Text("اضغط لشات خاص", style:TextStyle(color:Colors.white54, fontSize:10))])]), Container(padding:const EdgeInsets.symmetric(horizontal:18,vertical:6), decoration:BoxDecoration(color:const Color(0xFF22C55E), borderRadius:BorderRadius.circular(20)), child:const Text("إنضم", style:TextStyle(color:Colors.white, fontSize:12)))])))),
        ]))
      ]))),
      Container(padding:const EdgeInsets.all(8), color:const Color(0xFF1A2332), child:Row(children:[Expanded(child:TextField(controller:chatCtrl, style:const TextStyle(color:Colors.white, fontSize:12), decoration:InputDecoration(hintText:"دردشة عامة - قل شيئا...", hintStyle:const TextStyle(color:Colors.white54, fontSize:12), filled:true, fillColor:Colors.black45, border:OutlineInputBorder(borderRadius:BorderRadius.circular(20), borderSide:BorderSide.none), contentPadding:const EdgeInsets.symmetric(horizontal:14, vertical:8)))), const SizedBox(width:6), GestureDetector(onTap:(){ if(chatCtrl.text.isNotEmpty){ setState(()=> generalChat.add("أنت: ${chatCtrl.text}")); chatCtrl.clear(); } }, child:Container(padding:const EdgeInsets.all(10), decoration:const BoxDecoration(color:Colors.amber, shape:BoxShape.circle), child:const Icon(Icons.send, size:16))) ]))
    ])));
  }
  Widget _prettyCard(BuildContext c,String t,List<Color> col,String e,Widget p)=>GestureDetector(onTap:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>p)), child:Container(decoration:BoxDecoration(gradient:LinearGradient(colors:col), borderRadius:BorderRadius.circular(24), boxShadow:[BoxShadow(color:col[0].withOpacity(0.5), blurRadius:12, offset:const Offset(0,6))], border:Border.all(color:Colors.white24)), child:Column(mainAxisAlignment:MainAxisAlignment.center, children:[Text(e, style:const TextStyle(fontSize:44)), const SizedBox(height:8), Container(padding:const EdgeInsets.symmetric(horizontal:14,vertical:6), decoration:BoxDecoration(color:Colors.black54, borderRadius:BorderRadius.circular(20)), child:Text(t, style:const TextStyle(color:Colors.white, fontSize:11, fontWeight:FontWeight.bold)))])));
}
class WaitingMini extends StatelessWidget{const WaitingMini({super.key}); @override Widget build(BuildContext context)=>const Row(children:[CircleAvatar(radius:12, backgroundImage:NetworkImage('https://i.pravatar.cc/100?img=8')), SizedBox(width:4), Text("غرفة الانتظار (4)", style:TextStyle(color:Colors.white70, fontSize:11))]);}

// ===== بلياردو ترابيزة أصغر من نص الشاشة 320x480 فتحات واضحة حركة قوية =====
class BilliardScreen extends StatefulWidget{const BilliardScreen({super.key}); @override State<BilliardScreen> createState()=>_BState();}
class _BState extends State<BilliardScreen> with SingleTickerProviderStateMixin{
  Offset? ds, dc; Offset cue=const Offset(160,360); Offset vel=Offset.zero; List<Ball> balls=[]; late Ticker tk; int sc=0;
  @override void initState(){super.initState(); _reset(); tk=createTicker(_tick); tk.start();}
  void _reset(){ balls=[]; double sx=160, sy=90; int k=0; List<Color> cols=[Colors.yellow, Colors.blue, Colors.red, Colors.purple, Colors.orange, Colors.green, Colors.brown, Colors.black, Colors.yellow, Colors.blue, Colors.red, Colors.purple, Colors.orange, Colors.green, Colors.brown]; for(int r=0;r<5;r++){ for(int c=0;c<=r;c++){ if(k>=15) break; double x=sx + (c - r/2)*18; double y=sy + r*16; balls.add(Ball(pos:Offset(x,y), color:cols[k], num:k+1)); k++; }} cue=const Offset(160,360); sc=0; }
  void _tick(Duration _){ if(vel==Offset.zero) return; setState((){ cue=cue+vel*1.8; vel=vel*0.992; if(vel.distance<0.3) vel=Offset.zero; if(cue.dx<22||cue.dx>298) vel=Offset(-vel.dx, vel.dy); if(cue.dy<22||cue.dy>458) vel=Offset(vel.dx, -vel.dy); for(int i=0;i<balls.length;i++){ if(balls[i].out) continue; if((cue-balls[i].pos).distance<18){ var dir=balls[i].pos-cue; var l=dir.distance; if(l>0){ dir=dir/l; balls[i].pos=balls[i].pos+dir*10; } } if(balls[i].pos.dx<14||balls[i].pos.dx>306||balls[i].pos.dy<14||balls[i].pos.dy>466){ balls[i].out=true; sc++; } } });}
  @override void dispose(){tk.dispose(); super.dispose();}
  @override Widget build(BuildContext context){
    double pow=0; if(ds!=null&&dc!=null){ pow=(ds!-dc!).distance; if(pow>100) pow=100; }
    return Scaffold(backgroundColor:const Color(0xFF0A1020), appBar:AppBar(backgroundColor:const Color(0xFF1A2332), title:const WaitingMini(), leading:IconButton(icon:const Icon(Icons.arrow_back), onPressed:()=>Navigator.pop(context))), body:Column(children:[
      LinearProgressIndicator(value:pow/100, color:Colors.amber, backgroundColor:Colors.white12),
      Expanded(child:Center(child:SizedBox(width:320, height:480, child:GestureDetector(onPanStart:(d)=>setState(()=>ds=d.localPosition), onPanUpdate:(d)=>setState(()=>dc=d.localPosition), onPanEnd:(_){ if(ds!=null&&dc!=null){ vel=(ds!-dc!)*0.25; } setState(()=>{ds=null, dc=null}); }, child:CustomPaint(painter:PoolPainter(cue,balls,ds,dc)))))),
      Container(padding:const EdgeInsets.all(8), color:const Color(0xFF1A2332), child:Column(children:[Row(mainAxisAlignment:MainAxisAlignment.spaceAround, children:List.generate(4, (i)=> Column(children:[CircleAvatar(radius:16, backgroundImage:NetworkImage('https://i.pravatar.cc/100?img=${i+1}')), Text("$sc", style:const TextStyle(color:Colors.white, fontSize:10))]))), const SizedBox(height:6), Container(padding:const EdgeInsets.symmetric(horizontal:12,vertical:8), decoration:BoxDecoration(color:Colors.black45, borderRadius:BorderRadius.circular(20)), child:const Row(children:[Text("💬 عام 59 🎁 ", style:TextStyle(color:Colors.white, fontSize:11)), Expanded(child:Text("قل شيئا - شات عام وخاص", style:TextStyle(color:Colors.white54, fontSize:11))) ]))]))
    ]));
  }
}
class Ball{Offset pos; Color color; int num; bool out; Ball({required this.pos, required this.color, required this.num, this.out=false});}
class PoolPainter extends CustomPainter{
  final Offset cue; final List<Ball> balls; final Offset? s,c; PoolPainter(this.cue,this.balls,this.s,this.c);
  @override void paint(Canvas canvas, Size size){
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(0,0,size.width,size.height), const Radius.circular(20)), Paint()..color=const Color(0xFF5D4037));
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(10,10,size.width-20,size.height-20), const Radius.circular(14)), Paint()..color=const Color(0xFF2E7D32));
    var pockets=[Offset(12,12), Offset(size.width/2,8), Offset(size.width-12,12), Offset(12,size.height-12), Offset(size.width/2,size.height-8), Offset(size.width-12,size.height-12)];
    for(var p in pockets){ canvas.drawCircle(p, 18, Paint()..color=Colors.black); canvas.drawCircle(p, 22, Paint()..color=const Color(0xFF3E2723)..style=PaintingStyle.stroke..strokeWidth=4); }
    for(var b in balls){ if(b.out) continue; canvas.drawCircle(b.pos, 8, Paint()..color=b.color); canvas.drawCircle(b.pos, 8, Paint()..color=Colors.black..style=PaintingStyle.stroke..strokeWidth=0.8); }
    canvas.drawCircle(cue, 9, Paint()..color=Colors.white); canvas.drawCircle(cue, 9, Paint()..color=Colors.black..style=PaintingStyle.stroke..strokeWidth=1);
    if(s!=null&&c!=null){ canvas.drawLine(cue, cue+(s!-c!)*0.9, Paint()..color=Colors.yellow..strokeWidth=3); }
  }
  @override bool shouldRepaint(covariant CustomPainter o)=>true;
}

// ===== دومينو ورق صغير 4 لاعبين روبوتات =====
class DominoScreen extends StatefulWidget{const DominoScreen({super.key}); @override State<DominoScreen> createState()=>_DominoState();}
class _DominoState extends State<DominoScreen>{
  List<List<int>> hand=[[0,2],[2,5],[3,5],[1,3],[6,6],[4,4]]; List<List<int>> board=[]; List<List<int>> robot1=[[1,1],[2,2]]; List<List<int>> robot2=[[0,0],[5,5]]; List<List<int>> robot3=[[3,3]];
  void play(int i){ var t=hand[i]; if(board.isEmpty){ setState((){ board.add(t); hand.removeAt(i); }); return; } int l=board.first[0]; int r=board.last[1]; if(t[0]==r||t[1]==r){ if(t[0]!=r) t=[t[1],t[0]]; setState((){ board.add(t); hand.removeAt(i); }); } else if(t[0]==l||t[1]==l){ if(t[1]!=l) t=[t[1],t[0]]; setState((){ board.insert(0,t); hand.removeAt(i); }); } }
  @override Widget build(BuildContext context){ return Scaffold(backgroundColor:const Color(0xFF2E7D32), appBar:AppBar(backgroundColor:const Color(0xFF1A2332), title:const WaitingMini(), leading:IconButton(icon:const Icon(Icons.arrow_back), onPressed:()=>Navigator.pop(context))), body:Column(children:[
    Container(padding:const EdgeInsets.all(10), color:const Color(0xFF4CAF50), child:Row(mainAxisAlignment:MainAxisAlignment.spaceBetween, children:[const Text("🪙 1500 LV.0 📦 🎯 👑", style:TextStyle(color:Colors.white, fontWeight:FontWeight.bold, fontSize:12)), Container(padding:const EdgeInsets.symmetric(horizontal:8,vertical:4), decoration:BoxDecoration(color:Colors.black26, borderRadius:BorderRadius.circular(12)), child:const Text("🔍", style:TextStyle(color:Colors.white)))])),
    Padding(padding:const EdgeInsets.all(6), child:Row(mainAxisAlignment:MainAxisAlignment.spaceBetween, children:[
      Column(children:[const CircleAvatar(radius:18, backgroundImage:NetworkImage('https://i.pravatar.cc/100?img=20')), const Text("روبوت 1", style:TextStyle(color:Colors.white, fontSize:9)), Row(children: robot1.map((_)=> Container(width:12, height:18, margin:const EdgeInsets.all(1), color:Colors.black54)).toList())]),
      Column(children:[const Text("دومينو 50", style:TextStyle(color:Colors.white, fontWeight:FontWeight.bold, fontSize:11)), Row(children:[_btn("ترفيهي", Colors.amber), const SizedBox(width:4), _btn("معركة", const Color(0xFF66BB6A)), const SizedBox(width:4), _btn("إنشاء", const Color(0xFFAB47BC))])]),
      Column(children:[const CircleAvatar(radius:18, backgroundImage:NetworkImage('https://i.pravatar.cc/100?img=21')), const Text("روبوت 2", style:TextStyle(color:Colors.white, fontSize:9)), Row(children: robot2.map((_)=> Container(width:12, height:18, margin:const EdgeInsets.all(1), color:Colors.black54)).toList())]),
    ])),
    const SizedBox(height:4), Center(child:SizedBox(width:340, height:90, child:Container(decoration:BoxDecoration(color:Colors.black26, borderRadius:BorderRadius.circular(12)), child:SingleChildScrollView(scrollDirection:Axis.horizontal, child:Row(children:board.map((t)=> DominoTile(a:t[0], b:t[1])).toList()))))),
    const Spacer(),
    const Text("إيدك - 4 لاعبين - ورق صغير 38x58 - روبوتات تكمل", style:TextStyle(color:Colors.white70, fontSize:10)),
    Padding(padding:const EdgeInsets.all(8), child:Wrap(spacing:6, children:List.generate(hand.length, (i){ var t=hand[i]; return GestureDetector(onTap:()=>play(i), child:DominoTile(a:t[0], b:t[1], sel:true)); }))),
    Container(padding:const EdgeInsets.all(8), color:const Color(0xFF1A2332), child:Row(children:[const CircleAvatar(radius:14, backgroundImage:NetworkImage('https://i.pravatar.cc/100?img=1')), const SizedBox(width:6), const Expanded(child:Text("الغرفة الموصى بها: ملتقى آل سلاطين (14) - دردشة عام وخاص", style:TextStyle(color:Colors.white, fontSize:9))), Container(padding:const EdgeInsets.symmetric(horizontal:10,vertical:6), decoration:BoxDecoration(color:Colors.black45, borderRadius:BorderRadius.circular(20)), child:const Text("قل شيئا 💬", style:TextStyle(color:Colors.white54, fontSize:10)))]))
  ])); }
  Widget _btn(String t,Color c)=>Container(padding:const EdgeInsets.symmetric(horizontal:10,vertical:6), decoration:BoxDecoration(color:c, borderRadius:BorderRadius.circular(20)), child:Text(t, style:const TextStyle(color:Colors.white, fontWeight:FontWeight.bold, fontSize:9)));
}
class DominoTile extends StatelessWidget{
  final int a,b; final bool sel; const DominoTile({super.key, required this.a, required this.b, this.sel=false});
  @override Widget build(BuildContext context){ return Container(width:38, height:58, margin:const EdgeInsets.all(3), decoration:BoxDecoration(color:Colors.white, borderRadius:BorderRadius.circular(6), border:Border.all(color:sel? Colors.amber: Colors.black26, width:sel?1.5:0.8), boxShadow:[BoxShadow(color:Colors.black26, blurRadius:2, offset:const Offset(1,1))]), child:Column(children:[Expanded(child:CustomPaint(painter:DotPainter(a))), Container(height:1, color:Colors.black26), Expanded(child:CustomPaint(painter:DotPainter(b))) ])); }
}
class DotPainter extends CustomPainter{
  final int n; DotPainter(this.n);
  @override void paint(Canvas c, Size s){ if(n==0) return; var p=Paint()..color=Colors.black; var w=s.width, h=s.height; List<Offset> o=[]; if(n==1) o=[Offset(w/2,h/2)]; if(n==2) o=[Offset(w*0.25,h*0.25), Offset(w*0.75,h*0.75)]; if(n==3) o=[Offset(w*0.25,h*0.25), Offset(w/2,h/2), Offset(w*0.75,h*0.75)]; if(n==4) o=[Offset(w*0.25,h*0.25), Offset(w*0.75,h*0.25), Offset(w*0.25,h*0.75), Offset(w*0.75,h*0.75)]; if(n==5) o=[Offset(w*0.25,h*0.25), Offset(w*0.75,h*0.25), Offset(w/2,h/2), Offset(w*0.25,h*0.75), Offset(w*0.75,h*0.75)]; if(n==6) o=[Offset(w*0.25,h*0.25), Offset(w*0.25,h/2), Offset(w*0.25,h*0.75), Offset(w*0.75,h*0.25), Offset(w*0.75,h/2), Offset(w*0.75,h*0.75)]; for(var pos in o){ c.drawCircle(pos, 2.2, p); } }
  @override bool shouldRepaint(covariant CustomPainter o)=>false;
}

// ===== لودو صغير 360 مع إقلاع ووصول وأمان =====
class LudoScreen extends StatefulWidget{const LudoScreen({super.key}); @override State<LudoScreen> createState()=>_LState();}
class _LState extends State<LudoScreen>{
  int dice=2; int pos=0; final rnd=Random(); void roll(){ setState((){ dice=rnd.nextInt(6)+1; pos=(pos+dice)%40; }); }
  @override Widget build(BuildContext context){ return Scaffold(backgroundColor:const Color(0xFF0F2A66), appBar:AppBar(backgroundColor:const Color(0xFF1A2332), title:const WaitingMini(), leading:IconButton(icon:const Icon(Icons.arrow_back), onPressed:()=>Navigator.pop(context))), body:Column(children:[
    const SizedBox(height:10), Container(padding:const EdgeInsets.symmetric(horizontal:30,vertical:10), decoration:BoxDecoration(color:const Color(0xFF22C55E), borderRadius:BorderRadius.circular(30)), child:const Text("العب مع الأصدقاء - 4 لاعبين (روبوتات تكمل)", style:TextStyle(color:Colors.white, fontWeight:FontWeight.bold, fontSize:11))),
    const SizedBox(height:10), Center(child:SizedBox(width:340, height:340, child:CustomPaint(painter:LudoRealPainter(pos), size:const Size(340,340)))),
    const SizedBox(height:8), Text("الإقلاع ✈️ من البيوت - الوصول 🏁 في النص - الأمان ⭐", style:const TextStyle(color:Colors.white70, fontSize:10)),
    ElevatedButton(onPressed:roll, style:ElevatedButton.styleFrom(backgroundColor:Colors.white, shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(20))), child:Text("ارمي $dice", style:const TextStyle(color:Colors.black))),
    const Spacer(), Container(padding:const EdgeInsets.all(8), color:const Color(0xFF1A2332), child:Row(mainAxisAlignment:MainAxisAlignment.spaceAround, children:List.generate(4, (i)=> Column(children:[CircleAvatar(radius:14, backgroundImage:NetworkImage('https://i.pravatar.cc/100?img=${i+5}')), Text(["همام","سحاب","روبوت","الاكابر"][i], style:const TextStyle(color:Colors.white, fontSize:8))]))))
  ])); }
}
class LudoRealPainter extends CustomPainter{
  final int pos; LudoRealPainter(this.pos);
  @override void paint(Canvas c, Size s){
    double cell=s.width/15; c.drawRect(Rect.fromLTWH(0,0,s.width,s.height), Paint()..color=Colors.white);
    c.drawRect(Rect.fromLTWH(0,0,6*cell,6*cell), Paint()..color=Colors.red); c.drawRect(Rect.fromLTWH(9*cell,0,6*cell,6*cell), Paint()..color=Colors.green);
    c.drawRect(Rect.fromLTWH(0,9*cell,6*cell,6*cell), Paint()..color=Colors.blue); c.drawRect(Rect.fromLTWH(9*cell,9*cell,6*cell,6*cell), Paint()..color=Colors.yellow);
    // طيارات الإقلاع
    c.drawCircle(Offset(1.5*cell,1.5*cell), 8, Paint()..color=Colors.white); c.drawCircle(Offset(4.5*cell,1.5*cell), 8, Paint()..color=Colors.white); c.drawCircle(Offset(1.5*cell,4.5*cell), 8, Paint()..color=Colors.white); c.drawCircle(Offset(4.5*cell,4.5*cell), 8, Paint()..color=Colors.white);
    // أماكن أمان نجمة
    var safe=[Offset(6*cell+cell/2,1*cell+cell/2), Offset(13*cell+cell/2,6*cell+cell/2)];
    for(var p in safe){ c.drawCircle(p, 5, Paint()..color=Colors.amber); }
    // المسار
    for(int i=6;i<=8;i++){ for(int j=0;j<15;j++){ c.drawRect(Rect.fromLTWH(i*cell, j*cell, cell, cell), Paint()..color=Colors.white..style=PaintingStyle.stroke..strokeWidth=0.3); } for(int j=6;j<=8;j++){ c.drawRect(Rect.fromLTWH(j*cell, i*cell, cell, cell), Paint()..color=Colors.white..style=PaintingStyle.stroke..strokeWidth=0.3); } }
    // الوصول في النص
    c.drawRect(Rect.fromLTWH(6*cell,6*cell,3*cell,3*cell), Paint()..color=Colors.black12);
    // الطيارة المتحركة
    double px=7.5*cell, py=6*cell; if(pos<5){ px=(6+pos)*cell+cell/2; py=6*cell+cell/2; } else if(pos<11){ px=11*cell+cell/2; py=(6+pos-5)*cell+cell/2; }
    c.drawCircle(Offset(px,py), 9, Paint()..color=Colors.yellow); c.drawCircle(Offset(px,py), 9, Paint()..color=Colors.black..style=PaintingStyle.stroke..strokeWidth=1.5);
  }
  @override bool shouldRepaint(covariant CustomPainter o)=>true;
}

// ===== سلم وثعبان ثعبان أسود جسم كامل دماغ غامق سلالم لون ظاهر =====
class SnakeScreen extends StatefulWidget{const SnakeScreen({super.key}); @override State<SnakeScreen> createState()=>_SState();}
class _SState extends State<SnakeScreen>{
  int pl=1; int dice=6; final rnd=Random(); final Map<int,int> snakes={99:54, 70:55, 52:42, 56:8, 62:19}; final Map<int,int> ladders={3:22, 5:8, 11:26, 20:29, 27:56, 21:42, 36:51};
  void roll(){ int d=rnd.nextInt(6)+1; setState((){ dice=d; int nx=pl+d; if(nx<=100){ pl=nx; if(snakes.containsKey(pl)) pl=snakes[pl]!; if(ladders.containsKey(pl)) pl=ladders[pl]!; } }); }
  @override Widget build(BuildContext context){ return Scaffold(backgroundColor:const Color(0xFFFEF3C7), appBar:AppBar(backgroundColor:const Color(0xFF1A2332), title:const WaitingMini(), leading:IconButton(icon:const Icon(Icons.arrow_back), onPressed:()=>Navigator.pop(context))), body:Column(children:[
    const SizedBox(height:6), Center(child:SizedBox(width:340, height:440, child:CustomPaint(painter:SnakeRealPainter(pl, snakes, ladders), size:const Size(340,440)))),
    const SizedBox(height:4), Text("موقعك $pl / 100 - ثعبان أسود جسم كامل - سلم أصفر ظاهر", style:const TextStyle(fontSize:10, fontWeight:FontWeight.bold)),
    GestureDetector(onTap:roll, child:Container(width:60, height:60, margin:const EdgeInsets.all(6), decoration:BoxDecoration(color:Colors.white, borderRadius:BorderRadius.circular(12), border:Border.all(width:2)), child:Center(child:Text("$dice", style:const TextStyle(fontSize:28, fontWeight:FontWeight.bold))))),
    Container(padding:const EdgeInsets.all(6), color:const Color(0xFF1A2332), child:const Row(children:[Text("💬 عام ", style:TextStyle(color:Colors.white, fontSize:10)), Expanded(child:Text("دردشة عامة أثناء اللعب - قل شيئا", style:TextStyle(color:Colors.white54, fontSize:10)))]))
  ])); }
}
class SnakeRealPainter extends CustomPainter{
  final int player; final Map<int,int> snakes,ladders; SnakeRealPainter(this.player,this.snakes,this.ladders);
  @override void paint(Canvas canvas, Size size){
    double w=size.width/10; double h=size.height/10; int num=100;
    for(int r=0;r<10;r++){ for(int c=0;c<10;c++){ int col=r%2==0? c: 9-c; var rect=Rect.fromLTWH(col*w, r*h, w, h);
      Color colr; if(num%10==0||num%10==1) colr=const Color(0xFFE57373); else if(num%10==2||num%10==8) colr=const Color(0xFF64B5F6); else if(num%10==3||num%10==7) colr=const Color(0xFFFFB74D); else if(num%10==4) colr=const Color(0xFFFFEB3B); else if(num%10==5) colr=const Color(0xFF81C784); else colr=Colors.white;
      canvas.drawRect(rect, Paint()..color=colr); canvas.drawRect(rect, Paint()..color=Colors.black..style=PaintingStyle.stroke..strokeWidth=0.3);
      var tp=TextPainter(text:TextSpan(text:"$num", style:TextStyle(fontSize:8, fontWeight:FontWeight.bold, color:colr==Colors.white? Colors.black: Colors.white)), textDirection:TextDirection.ltr)..layout(); tp.paint(canvas, Offset(rect.left+2, rect.top+1));
      if(num==player){ canvas.drawCircle(Offset(rect.center.dx, rect.center.dy+5), 8, Paint()..color=Colors.red); canvas.drawCircle(Offset(rect.center.dx, rect.center.dy+5), 8, Paint()..color=Colors.black..style=PaintingStyle.stroke..strokeWidth=1); }
      num--; }
    }
    var sBody=Paint()..color=Colors.black..strokeWidth=8..strokeCap=StrokeCap.round..style=PaintingStyle.stroke;
    var sHead=Paint()..color=const Color(0xFF4A0000)..strokeWidth=10..strokeCap=StrokeCap.round;
    snakes.forEach((s,e){ var sp=Offset(((100-s)%10)*w + w/2, ((100-s)~/10)*h + h/2); var ep=Offset(((100-e)%10)*w + w/2, ((100-e)~/10)*h + h/2); var path=Path()..moveTo(sp.dx, sp.dy)..quadraticBezierTo((sp.dx+ep.dx)/2+20, (sp.dy+ep.dy)/2, ep.dx, ep.dy); canvas.drawPath(path, sBody); canvas.drawCircle(sp, 9, Paint()..color=const Color(0xFF4A0000)); canvas.drawCircle(sp.translate(-2,-1), 2, Paint()..color=Colors.white); canvas.drawCircle(sp.translate(2,-1), 2, Paint()..color=Colors.white); });
    var lPaint=Paint()..color=const Color(0xFFFFC107)..strokeWidth=4..style=PaintingStyle.stroke..strokeCap=StrokeCap.round;
    var rungPaint=Paint()..color=const Color(0xFFFFC107)..strokeWidth=3;
    ladders.forEach((s,e){ var sp=Offset(((s-1)%10)*w + w/2, (9-(s-1)~/10)*h + h/2); var ep=Offset(((e-1)%10)*w + w/2, (9-(e-1)~/10)*h + h/2); canvas.drawLine(sp, ep, lPaint); canvas.drawLine(sp.translate(10,0), ep.translate(10,0), lPaint); for(double t=0.25; t<0.9; t+=0.2){ var x=sp.dx+(ep.dx-sp.dx)*t; var y=sp.dy+(ep.dy-sp.dy)*t; canvas.drawLine(Offset(x,y), Offset(x+10,y), rungPaint); } });
  }
  @override bool shouldRepaint(covariant CustomPainter o)=>true;
}
