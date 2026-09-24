import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(const PlayAndWinApp());

class PlayAndWinApp extends StatelessWidget {
  const PlayAndWinApp({super.key});
  @override Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'العب واربح',
      theme: ThemeData(useMaterial3: true, scaffoldBackgroundColor: const Color(0xFF0F172A), fontFamily: 'Cairo'),
      home: const GameHub(),
    );
  }
}

// ============ الصالة الرئيسية + الاعدادات ============
class GameHub extends StatefulWidget { const GameHub({super.key}); @override State<GameHub> createState()=> _HubState(); }
class _HubState extends State<GameHub> {
  String playerName="لاعب محترف"; bool soundOn=true;
  @override Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("العب واربح - صالة الألعاب", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E3A8A), foregroundColor: Colors.white, centerTitle: true,
        actions: [IconButton(icon: const Icon(Icons.settings), onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (_)=> SettingsScreen(name: playerName, sound: soundOn, onSave: (n,s){setState((){playerName=n; soundOn=s;});}))))],
      ),
      body: Column(children: [
        Container(padding: const EdgeInsets.all(16), color: Colors.black26, child: Row(children: [const CircleAvatar(backgroundColor: Colors.amber, child: Icon(Icons.person, color: Colors.black)), const SizedBox(width: 10), Text("مرحبا، $playerName", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), const Spacer(), Icon(soundOn? Icons.volume_up : Icons.volume_off, color: Colors.white70)])),
        Expanded(child: GridView.count(padding: const EdgeInsets.all(16), crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, children: [
          _card(context, "البلياردو", "Pool 8-Ball", Icons.circle, [const Color(0xFF065F46), const Color(0xFF10B981)], BilliardsPro()),
          _card(context, "الدومينو", "Domino", Icons.grid_view, [const Color(0xFF7C2D12), const Color(0xFFFBBF24)], DominoPro()),
          _card(context, "السلم والثعبان", "Snakes 3D", Icons.map, [const Color(0xFF1E40AF), const Color(0xFF60A5FA)], SnakesPro()),
          _card(context, "لودو", "Ludo King", Icons.casino, [const Color(0xFF7E22CE), const Color(0xFFC084FC)], LudoPro()),
        ])),
      ]),
    );
  }
  Widget _card(BuildContext c, String t, String s, IconData ic, List<Color> g, Widget go){
    return InkWell(onTap: ()=> Navigator.push(c, MaterialPageRoute(builder: (_)=> go)),
      child: Container(decoration: BoxDecoration(gradient: LinearGradient(colors: g, begin: Alignment.topLeft, end: Alignment.bottomRight), borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: g[1].withOpacity(0.4), blurRadius: 12, offset: const Offset(0,6))]), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(ic, size: 52, color: Colors.white), const SizedBox(height: 8), Text(t, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)), Text(s, style: const TextStyle(color: Colors.white70, fontSize: 11))])));}
}

class SettingsScreen extends StatefulWidget {
  final String name; final bool sound; final Function(String,bool) onSave;
  const SettingsScreen({super.key, required this.name, required this.sound, required this.onSave});
  @override State<SettingsScreen> createState()=> _SetState();
}
class _SetState extends State<SettingsScreen> {
  late TextEditingController _c; late bool _s;
  @override void initState(){ super.initState(); _c=TextEditingController(text: widget.name); _s=widget.sound; }
  @override Widget build(BuildContext context){
    return Scaffold(appBar: AppBar(title: const Text("الإعدادات")), body: Padding(padding: const EdgeInsets.all(20), child: Column(children: [
      TextField(controller: _c, decoration: const InputDecoration(labelText: "اسم اللاعب", border: OutlineInputBorder())),
      const SizedBox(height: 20),
      SwitchListTile(title: const Text("الصوت والموسيقى"), value: _s, onChanged: (v)=> setState(()=> _s=v)),
      const SizedBox(height: 20),
      ElevatedButton(onPressed: (){ widget.onSave(_c.text, _s); Navigator.pop(context); }, style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)), child: const Text("حفظ"))
    ])));
  }
}

// ============ 1- السلم والثعبان برو - 100% ============
class SnakesPro extends StatefulWidget { @override State<SnakesPro> createState()=> _SnakesProState(); }
class _SnakesProState extends State<SnakesPro> {
  int p1=1,p2=1,turn=1,dice=1; bool moving=false;
  final Map<int,int> ladders={4:25,13:46,33:85,42:63,50:69,62:81,74:92};
  final Map<int,int> snakes={27:5,40:3,43:18,54:31,66:45,76:58,89:53,99:41};
  void roll() async {
    if(moving) return;
    setState(()=> dice=Random().nextInt(6)+1);
    setState(()=> moving=true);
    int cur=turn==1?p1:p2; int tgt=cur+dice; if(tgt>100){setState(()=>moving=false);return;}
    for(int i=cur+1;i<=tgt;i++){ await Future.delayed(const Duration(milliseconds: 120)); if(!mounted) return; setState((){ if(turn==1) p1=i; else p2=i; }); }
    int pos=turn==1?p1:p2;
    if(ladders.containsKey(pos)){ await Future.delayed(const Duration(milliseconds: 500)); if(!mounted) return; setState((){ if(turn==1) p1=ladders[pos]!; else p2=ladders[pos]!; }); }
    if(snakes.containsKey(pos)){ await Future.delayed(const Duration(milliseconds: 500)); if(!mounted) return; setState((){ if(turn==1) p1=snakes[pos]!; else p2=snakes[pos]!; }); }
    if((turn==1?p1:p2)==100){ if(!mounted) return; showDialog(context: context, builder: (_)=> AlertDialog(title: Text("🏆 فاز اللاعب $turn!"), actions: [TextButton(onPressed: (){ setState((){ p1=1;p2=1;}); Navigator.pop(context); }, child: const Text("اعادة"))])); }
    setState((){ turn=turn==1?2:1; moving=false; });
  }
  @override Widget build(BuildContext context){
    return Scaffold(appBar: AppBar(title: Text("السلم والثعبان - دور $turn - نرد $dice")), body: Column(children: [
      Expanded(child: GridView.builder(padding: const EdgeInsets.all(6), gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 10, childAspectRatio: 1), itemCount: 100, reverse: true, itemBuilder: (_,i){
        int n=i+1; bool isP1=p1==n,isP2=p2==n;
        Color c=Colors.white; String icon="";
        if(ladders.containsKey(n)){ c=Colors.green.shade200; icon="🪜"; } if(snakes.containsKey(n)){ c=Colors.red.shade300; icon="🐍"; }
        return Container(margin: const EdgeInsets.all(2), decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.black12)), child: Stack(children: [
          Positioned(top:2,left:3,child: Text("$n", style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold))),
          Center(child: Text(icon, style: const TextStyle(fontSize: 14))),
          if(isP1 && isP2) const Center(child: Text("🔵🟠", style: TextStyle(fontSize: 12))),
          if(isP1 &&!isP2) const Center(child: Icon(Icons.circle, color: Colors.blue, size: 18)),
          if(isP2 &&!isP1) const Center(child: Icon(Icons.circle, color: Colors.orange, size: 18)),
        ]));
      })),
      Container(padding: const EdgeInsets.all(12), child: ElevatedButton(onPressed: roll, style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 56), backgroundColor: Colors.amber, foregroundColor: Colors.black, textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), child: Text(moving? "جاري التحرك..." : "🎲 رمي النرد - $dice"))),
    ]));
  }
}

// ============ 2- لودو برو - 100% ============
class LudoPro extends StatefulWidget { @override State<LudoPro> createState()=> _LudoProState(); }
class _LudoProState extends State<LudoPro> {
  List<int> red=[-1,-1,-1,-1], green=[-1,-1,-1,-1]; int turn=0,dice=1; List<String> names=["الأحمر","الأخضر"];
  void roll(){ setState(()=> dice=Random().nextInt(6)+1); }
  void movePiece(int p, int idx){
    List<int> arr = p==0? red:green;
    if(arr[idx]==-1 && dice!=6) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("لازم تجيب 6 عشان تطلع من البيت!"))); return; }
    setState((){ if(arr[idx]==-1) arr[idx]=0; else { arr[idx]+=dice; if(arr[idx]>57) arr[idx]=57; } if(dice!=6) turn=(turn+1)%2; });
    if(arr.every((e)=> e==57)){ showDialog(context: context, builder: (_)=> AlertDialog(title: Text("فاز فريق ${names[p]}!"))); }
  }
  @override Widget build(BuildContext context){
    return Scaffold(appBar: AppBar(title: Text("لودو - دور ${names[turn]} - نرد $dice"), backgroundColor: Colors.deepPurple), body: Column(children: [
      Padding(padding: const EdgeInsets.all(12), child: Row(children: [Chip(label: Text("النرد: $dice", style: const TextStyle(fontWeight: FontWeight.bold))), const Spacer(), ElevatedButton.icon(onPressed: roll, icon: const Icon(Icons.casino), label: const Text("ارمي النرد"))])),
      Expanded(child: Row(children: [
        Expanded(child: _ludoBox(0, red, Colors.red, names[0])),
        Expanded(child: _ludoBox(1, green, Colors.green, names[1])),
      ])),
      Container(height: 100, margin: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(12)), child: GridView.builder(padding: const EdgeInsets.all(8), gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 6), itemCount: 58, itemBuilder: (_,i){
        bool hasRed=red.contains(i); bool hasGreen=green.contains(i);
        return Container(margin: const EdgeInsets.all(2), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)), child: hasRed||hasGreen? Center(child: Text(hasRed&&hasGreen? "🔴🟢": hasRed? "🔴":"🟢", style: const TextStyle(fontSize: 10))): Center(child: Text("$i", style: const TextStyle(fontSize: 7))));
      })),
    ]));
  }
  Widget _ludoBox(int p, List<int> arr, Color col, String name){
    return Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(color: col.withOpacity(0.2), border: Border.all(color: col, width: 3), borderRadius: BorderRadius.circular(16)), child: Column(children: [
      Padding(padding: const EdgeInsets.all(8), child: Text(name, style: TextStyle(color: col, fontWeight: FontWeight.bold))),
      Expanded(child: GridView.count(crossAxisCount: 2, padding: const EdgeInsets.all(8), children: List.generate(4, (i)=> InkWell(onTap: ()=> movePiece(p,i), child: Container(margin: const EdgeInsets.all(6), decoration: BoxDecoration(color: arr[i]==-1? Colors.black45 : arr[i]==57? Colors.greenAccent : Colors.white, shape: BoxShape.circle, border: Border.all(color: col, width: 2)), child: Center(child: Text(arr[i]==-1? "🏠": arr[i]==57? "🏆":"${arr[i]}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)))))))),
    ]));
  }
}

// ============ 3- دومينو برو - 100% ============
class DominoPro extends StatefulWidget { @override State<DominoPro> createState()=> _DominoProState(); }
class _DominoProState extends State<DominoPro> {
  List<List<int>> board=[[3,2]]; List<List<int>> myHand=[[0,6],[6,1],[2,5],[1,4],[4,4]]; List<List<int>> botHand=[[1,2],[5,3],[0,0]];
  int left=3,right=2; String msg="دورك انت";
  void playMy(int idx){
    var d=myHand[idx];
    if(d[0]==left || d[1]==left || d[0]==right || d[1]==right){
      setState((){
        if(d[0]==left || d[1]==left){ board.insert(0, d[0]==left? [d[1],d[0]]:d); left=board.first[0]; }
        else { board.add(d[0]==right? d:[d[1],d[0]]); right=board.last[1]; }
        myHand.removeAt(idx); msg="دور البوت...";
      });
      Future.delayed(const Duration(seconds: 1), botPlay);
    } else { setState(()=> msg="القطعة لا تناسب!"); }
  }
  void botPlay(){
    for(int i=0;i<botHand.length;i++){
      var d=botHand[i];
      if(d[0]==left || d[1]==left || d[0]==right || d[1]==right){
        setState((){
          if(d[0]==left || d[1]==left){ board.insert(0, d[0]==left? [d[1],d[0]]:d); left=board.first[0]; }
          else { board.add(d[0]==right? d:[d[1],d[0]]); right=board.last[1]; }
          botHand.removeAt(i); msg="دورك انت";
        }); return;
      }
    }
    setState(()=> msg="البوت سحب قطعة"); botHand.add([Random().nextInt(7), Random().nextInt(7)]);
    Future.delayed(const Duration(milliseconds: 800), ()=> setState(()=> msg="دورك انت"));
  }
  @override Widget build(BuildContext context){
    return Scaffold(appBar: AppBar(title: Text("دومينو [$left | $right] - $msg"), backgroundColor: Colors.brown.shade800), body: Column(children: [
      Container(padding: const EdgeInsets.all(12), color: Colors.black26, child: Row(children: [Text("البوت: ${botHand.length} قطع", style: const TextStyle(color: Colors.white70)), const Spacer(), Text(msg, style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold))])),
      Expanded(child: Container(margin: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFF4A2C2A), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.amber.shade700, width: 3)), child: Center(child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: board.map((d)=> Container(margin: const EdgeInsets.all(6), padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 4)]), child: Column(children: [Text("${d[0]}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)), const Divider(height: 6), Text("${d[1]}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18))]))).toList()))))),
      Container(padding: const EdgeInsets.all(12), decoration: const BoxDecoration(color: Colors.black54), child: Column(children: [
        const Text("قطعك:", style: TextStyle(color: Colors.white70)), const SizedBox(height: 8),
        Wrap(spacing: 10, runSpacing: 10, children: List.generate(myHand.length, (i)=> InkWell(onTap: ()=> playMy(i), child: Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.amber, width: 2)), child: Text("${myHand[i][0]} | ${myHand[i][1]}", style: const TextStyle(fontWeight: FontWeight.bold)))))),
        const SizedBox(height: 10),
        ElevatedButton(onPressed: (){ setState(()=> myHand.add([Random().nextInt(7), Random().nextInt(7)])); }, child: const Text("اسحب قطعة")),
      ])),
    ]));
  }
}

// ============ 4- بلياردو برو - 100% ============
class BilliardsPro extends StatefulWidget { @override State<BilliardsPro> createState()=> _BilliProState(); }
class _BilliProState extends State<BilliardsPro> {
  double angle=0, power=30; Offset cue=const Offset(100,220); List<Offset> balls=[const Offset(260,180), const Offset(280,220), const Offset(260,260), const Offset(300,200)];
  List<bool> pocketed=[false,false,false,false];
  void shoot(){
    setState((){
      double rad=angle*pi/180; Offset next=cue+Offset(cos(rad)*power*2.5, sin(rad)*power*2.5);
      if(next.dx<20 || next.dx>330 || next.dy<20 || next.dy>430){ cue=const Offset(100,220); return; }
      cue=next;
      for(int i=0;i<balls.length;i++){
        if(pocketed[i]) continue;
        if((cue-balls[i]).distance<22){ balls[i]+=Offset(cos(rad)*power*1.5, sin(rad)*power*1.5); if(balls[i].dx<15 || balls[i].dx>335 || balls[i].dy<15 || balls[i].dy>435){ pocketed[i]=true; } }
      }
    });
  }
  @override Widget build(BuildContext context){
    return Scaffold(appBar: AppBar(title: const Text("بلياردو 8-Ball Pro"), backgroundColor: const Color(0xFF065F46)), body: Column(children: [
      Expanded(child: Container(margin: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFF0F6A4A), borderRadius: BorderRadius.circular(24), border: Border.all(color: const Color(0xFF8B4513), width: 10), boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 20)]), child: CustomPaint(painter: PoolProPainter(cue, balls, pocketed), child: Container()))),
      Container(padding: const EdgeInsets.all(16), decoration: const BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.vertical(top: Radius.circular(20))), child: Column(children: [
        Row(children: [const Icon(Icons.rotate_90_degrees_ccw, color: Colors.white70), Expanded(child: Slider(value: angle, min: -90, max: 90, divisions: 36, label: "${angle.toInt()}°", onChanged: (v)=> setState(()=> angle=v), activeColor: Colors.tealAccent)), Text("${angle.toInt()}°", style: const TextStyle(color: Colors.white))]),
        Row(children: [const Icon(Icons.bolt, color: Colors.amber), Expanded(child: Slider(value: power, min: 0, max: 100, onChanged: (v)=> setState(()=> power=v), activeColor: Colors.amber)), Text("${power.toInt()}%", style: const TextStyle(color: Colors.white))]),
        const SizedBox(height: 8),
        ElevatedButton.icon(onPressed: shoot, icon: const Icon(Icons.sports_baseball), label: const Text("اضرب بقوة!"), style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 54), backgroundColor: Colors.teal, foregroundColor: Colors.white, textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
      ])),
    ]));
  }
}
class PoolProPainter extends CustomPainter {
  Offset cue; List<Offset> balls; List<bool> pocketed; PoolProPainter(this.cue, this.balls, this.pocketed);
  @override void paint(Canvas c, Size s){
    var pocketPaint=Paint()..color=Colors.black;
    c.drawCircle(Offset(10,10), 16, pocketPaint); c.drawCircle(Offset(s.width-10,10), 16, pocketPaint);
    c.drawCircle(Offset(10,s.height-10), 16, pocketPaint); c.drawCircle(Offset(s.width-10,s.height-10), 16, pocketPaint);
    c.drawCircle(Offset(s.width/2,8), 14, pocketPaint); c.drawCircle(Offset(s.width/2,s.height-8), 14, pocketPaint);
    c.drawCircle(cue, 13, Paint()..color=Colors.white..style=PaintingStyle.fill);
    c.drawCircle(cue, 13, Paint()..color=Colors.black26..style=PaintingStyle.stroke..strokeWidth=1);
    for(int i=0;i<balls.length;i++){ if(pocketed[i]) continue; Color col=[Colors.red, Colors.blue, Colors.yellow, Colors.purple][i]; c.drawCircle(balls[i], 11, Paint()..color=col); }
  }
  @override bool shouldRepaint(old)=> true;
}
