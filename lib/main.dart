import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(const PlayAndWinApp());

class PlayAndWinApp extends StatelessWidget {
  const PlayAndWinApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'العب واربح',
      theme: ThemeData(useMaterial3: true, scaffoldBackgroundColor: const Color(0xFF0F172A)),
      home: const GameHub(),
    );
  }
}

// ==================== الصالة ====================
class GameHub extends StatefulWidget { const GameHub({super.key}); @override State<GameHub> createState()=> _HubState(); }
class _HubState extends State<GameHub> {
  String name="بطل الألعاب"; bool sound=true;
  @override Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(title: const Text("العب واربح", style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: const Color(0xFF1E3A8A), foregroundColor: Colors.white, centerTitle: true,
        actions: [IconButton(icon: const Icon(Icons.settings), onPressed: () async {
          final res = await Navigator.push(context, MaterialPageRoute(builder: (_)=> SettingsScreen(name: name, sound: sound)));
          if(res!=null){ setState((){ name=res[0]; sound=res[1]; });}
        })]),
      body: Column(children: [
        Container(margin: const EdgeInsets.all(12), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(12)), child: Row(children: [const CircleAvatar(backgroundColor: Colors.amber, child: Icon(Icons.person)), const SizedBox(width: 8), Text("أهلا $name", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), const Spacer(), Icon(sound? Icons.volume_up : Icons.volume_off, color: Colors.white54)])),
        Expanded(child: GridView.count(crossAxisCount: 2, padding: const EdgeInsets.all(16), crossAxisSpacing: 16, mainAxisSpacing: 16, children: [
          _gameCard(context, "البلياردو", Icons.sports_basketball, [const Color(0xFF065F46), const Color(0xFF10B981)], const BilliardsFixed()),
          _gameCard(context, "الدومينو", Icons.view_module, [const Color(0xFF78350F), const Color(0xFFF59E0B)], const DominoFixed()),
          _gameCard(context, "السلم والثعبان", Icons.grid_on, [const Color(0xFF1E40AF), const Color(0xFF3B82F6)], const SnakesFixed()),
          _gameCard(context, "لودو كينج", Icons.casino, [const Color(0xFF6D28D9), const Color(0xFFA78BFA)], const LudoFixed()),
        ])),
      ]),
    );
  }
  Widget _gameCard(BuildContext c, String t, IconData ic, List<Color> g, Widget page){
    return InkWell(onTap: ()=> Navigator.push(c, MaterialPageRoute(builder: (_)=> page)),
      child: Container(decoration: BoxDecoration(gradient: LinearGradient(colors: g, begin: Alignment.topLeft, end: Alignment.bottomRight), borderRadius: BorderRadius.circular(22), boxShadow: [BoxShadow(color: g[1].withOpacity(0.3), blurRadius: 12, offset: const Offset(0,5))]), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(ic, size: 48, color: Colors.white), const SizedBox(height: 8), Text(t, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15))])));}
}

class SettingsScreen extends StatefulWidget {
  final String name; final bool sound;
  const SettingsScreen({super.key, required this.name, required this.sound});
  @override State<SettingsScreen> createState()=> _SetState();
}
class _SetState extends State<SettingsScreen> {
  late TextEditingController _c; late bool _s;
  @override void initState(){ super.initState(); _c=TextEditingController(text: widget.name); _s=widget.sound; }
  @override Widget build(BuildContext context){
    return Scaffold(appBar: AppBar(title: const Text("الإعدادات")), body: Padding(padding: const EdgeInsets.all(20), child: Column(children: [
      TextField(controller: _c, decoration: const InputDecoration(labelText: "اسمك", border: OutlineInputBorder())),
      const SizedBox(height: 16), SwitchListTile(title: const Text("الصوت"), value: _s, onChanged: (v)=> setState(()=> _s=v)),
      const SizedBox(height: 20), ElevatedButton(onPressed: ()=> Navigator.pop(context, [_c.text, _s]), style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)), child: const Text("حفظ"))
    ])));
  }
}

// ==================== 1- السلم والثعبان - مصلح ====================
class SnakesFixed extends StatefulWidget { const SnakesFixed({super.key}); @override State<SnakesFixed> createState()=> _SnakesState(); }
class _SnakesState extends State<SnakesFixed> {
  int p1=1,p2=1,turn=1,dice=1; bool busy=false;
  final Map<int,int> ladders={4:25,13:46,33:85,50:69,62:81,74:92};
  final Map<int,int> snakes={99:41,89:53,76:58,66:45,54:31,43:18,27:5,40:3};
  Future<void> roll() async {
    if(busy) return; setState((){ busy=true; dice=Random().nextInt(6)+1; });
    int cur=turn==1?p1:p2; int target=cur+dice; if(target>100){ setState(()=> busy=false); return;}
    for(int i=cur+1;i<=target;i++){ await Future.delayed(const Duration(milliseconds: 180)); if(!mounted) return; setState((){ if(turn==1) p1=i; else p2=i; });}
    int pos=turn==1?p1:p2;
    if(ladders.containsKey(pos)){ await Future.delayed(const Duration(milliseconds: 400)); setState((){ if(turn==1) p1=ladders[pos]!; else p2=ladders[pos]!; });}
    if(snakes.containsKey(pos)){ await Future.delayed(const Duration(milliseconds: 400)); setState((){ if(turn==1) p1=snakes[pos]!; else p2=snakes[pos]!; });}
    int finalPos=turn==1?p1:p2;
    if(finalPos==100){ if(!mounted) return; showDialog(context: context, builder: (_)=> AlertDialog(title: Text("🏆 فاز اللاعب $turn"), actions: [TextButton(onPressed: (){ setState((){p1=1;p2=1;}); Navigator.pop(context);}, child: const Text("اعادة"))])); }
    setState((){ turn=turn==1?2:1; busy=false; });
  }
  @override Widget build(BuildContext context){
    return Scaffold(appBar: AppBar(title: Text("السلم والثعبان - دور: $turn | نرد: $dice"), backgroundColor: const Color(0xFF1E3A8A), foregroundColor: Colors.white),
      body: Column(children: [
        Expanded(child: Container(color: const Color(0xFF0F172A), padding: const EdgeInsets.all(6), child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 10, mainAxisSpacing: 4, crossAxisSpacing: 4),
          itemCount: 100,
          itemBuilder: (ctx, idx){
            int row=9-idx~/10; int col=idx%10; int num = row%2==0? row*10+col+1 : row*10+(9-col)+1;
            bool isP1=p1==num, isP2=p2==num;
            Color bg=Colors.white; String emoji="";
            if(ladders.containsKey(num)){ bg=const Color(0xFFBBF7D0); emoji="🪜"; }
            if(snakes.containsKey(num)){ bg=const Color(0xFFFECACA); emoji="🐍"; }
            return Container(decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)), child: Stack(children: [
              Positioned(top: 2, left: 3, child: Text("$num", style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.black54))),
              if(emoji.isNotEmpty) Center(child: Text(emoji, style: const TextStyle(fontSize: 14))),
              if(isP1 && isP2) const Align(alignment: Alignment.bottomCenter, child: Text("🔵🟠", style: TextStyle(fontSize: 11))),
              if(isP1 &&!isP2) const Align(alignment: Alignment.bottomCenter, child: Icon(Icons.circle, color: Colors.blue, size: 16)),
              if(isP2 &&!isP1) const Align(alignment: Alignment.bottomCenter, child: Icon(Icons.circle, color: Colors.orange, size: 16)),
            ]));
          }))),
        Container(padding: const EdgeInsets.all(12), child: ElevatedButton(onPressed: busy? null: roll, style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black, minimumSize: const Size(double.infinity, 58), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))), child: Text(busy? "يتحرك..." : "🎲 رمي النرد - $dice", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)))),
      ]),
    );
  }
}

// ==================== 2- لودو - مصلح ====================
class LudoFixed extends StatefulWidget { const LudoFixed({super.key}); @override State<LudoFixed> createState()=> _LudoState(); }
class _LudoState extends State<LudoFixed> {
  List<int> red=[-1,-1,-1,-1], green=[-1,-1,-1,-1]; int turn=0,dice=1;
  void rollDice(){ setState(()=> dice=Random().nextInt(6)+1); }
  void move(int player, int idx){
    List<int> arr = player==0? red:green;
    if(arr[idx]==-1 && dice!=6){ ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("تحتاج 6 لتخرج من البيت!"))); return; }
    setState((){
      if(arr[idx]==-1) arr[idx]=0; else { arr[idx]+=dice; if(arr[idx]>=57) arr[idx]=57; }
      if(dice!=6) turn=1-turn;
    });
  }
  @override Widget build(BuildContext context){
    return Scaffold(appBar: AppBar(title: Text("لودو - دور ${turn==0?'الأحمر':'الأخضر'} | نرد $dice"), backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
      body: Column(children: [
        Padding(padding: const EdgeInsets.all(12), child: Row(children: [Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)), child: Text("النرد: $dice", style: const TextStyle(fontWeight: FontWeight.bold))), const Spacer(), ElevatedButton.icon(onPressed: rollDice, icon: const Icon(Icons.casino), label: const Text("ارمي النرد"))])),
        Expanded(child: Row(children: [
          Expanded(child: _playerBox("الأحمر", Colors.red, red, 0)),
          Expanded(child: _playerBox("الأخضر", Colors.green, green, 1)),
        ])),
        Container(height: 90, margin: const EdgeInsets.all(10), padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)), child: ListView.builder(scrollDirection: Axis.horizontal, itemCount: 57, itemBuilder: (_, i){
          bool r=red.contains(i), g=green.contains(i);
          return Container(width: 36, margin: const EdgeInsets.all(2), decoration: BoxDecoration(color: r||g? Colors.amber.shade200: Colors.grey.shade200, borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.black12)), child: Center(child: Text(r&&g? "RG": r? "R": g? "G": "$i", style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold))));
        })),
      ]),
    );
  }
  Widget _playerBox(String name, Color c, List<int> arr, int p){
    return Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(color: c.withOpacity(0.15), borderRadius: BorderRadius.circular(18), border: Border.all(color: c, width: 2.5)), child: Column(children: [
      const SizedBox(height: 10), Text(name, style: TextStyle(color: c, fontWeight: FontWeight.bold, fontSize: 16)),
      const SizedBox(height: 10),
     ...List.generate(2, (row)=> Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: List.generate(2, (col){
        int idx=row*2+col; return InkWell(onTap: ()=> move(p, idx), child: Container(width: 68, height: 68, margin: const EdgeInsets.all(6), decoration: BoxDecoration(color: arr[idx]==-1? Colors.black45: arr[idx]==57? Colors.amber: Colors.white, shape: BoxShape.circle, border: Border.all(color: c, width: 2)), child: Center(child: Text(arr[idx]==-1? "🏠": arr[idx]==57? "🏆": "${arr[idx]}", style: const TextStyle(fontWeight: FontWeight.bold)))));
      }))),
    ]));
  }
}

// ==================== 3- بلياردو - مصلح ====================
class BilliardsFixed extends StatefulWidget { const BilliardsFixed({super.key}); @override State<BilliardsFixed> createState()=> _BilliState(); }
class _BilliState extends State<BilliardsFixed> {
  double ang=0, pow=35; Offset cue=const Offset(120,200);
  List<Offset> balls=[const Offset(250,180), const Offset(270,210), const Offset(250,240), const Offset(290,200)];
  List<bool> gone=[false,false,false,false];
  void shoot(){
    double rad=ang*pi/180; Offset dir=Offset(cos(rad), sin(rad));
    setState((){
      cue+=dir*pow*2.2;
      if(cue.dx<18||cue.dx>332||cue.dy<18||cue.dy>432) cue=const Offset(120,200);
      for(int i=0;i<balls.length;i++){ if(gone[i]) continue; if((cue-balls[i]).distance<24){ balls[i]+=dir*pow*1.4; if(balls[i].dx<15||balls[i].dx>335||balls[i].dy<15||balls[i].dy>435) gone[i]=true; } }
    });
  }
  void reset(){ setState((){ cue=const Offset(120,200); balls=[const Offset(250,180), const Offset(270,210), const Offset(250,240), const Offset(290,200)]; gone=[false,false,false,false]; });}
  @override Widget build(BuildContext context){
    return Scaffold(appBar: AppBar(title: const Text("بلياردو 8-Ball"), backgroundColor: const Color(0xFF065F46), foregroundColor: Colors.white, actions: [IconButton(onPressed: reset, icon: const Icon(Icons.refresh))]),
      body: Column(children: [
        Expanded(child: Container(margin: const EdgeInsets.all(10), decoration: BoxDecoration(color: const Color(0xFF0B7A4A), borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFF8B4513), width: 8)), child: CustomPaint(painter: _PoolPainter(cue,balls,gone), child: const SizedBox.expand()))),
        Container(padding: const EdgeInsets.all(14), decoration: const BoxDecoration(color: Color(0xFF1F2937), borderRadius: BorderRadius.vertical(top: Radius.circular(18))), child: Column(children: [
          Row(children: [const Icon(Icons.screen_rotation, color: Colors.white54, size: 20), Expanded(child: Slider(value: ang, min: -90, max: 90, onChanged: (v)=> setState(()=> ang=v))), Text("${ang.toInt()}°", style: const TextStyle(color: Colors.white))]),
          Row(children: [const Icon(Icons.flash_on, color: Colors.amber, size: 20), Expanded(child: Slider(value: pow, min: 5, max: 100, activeColor: Colors.amber, onChanged: (v)=> setState(()=> pow=v))), Text("${pow.toInt()}%", style: const TextStyle(color: Colors.white))]),
          const SizedBox(height: 6), ElevatedButton(onPressed: shoot, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0D9488), minimumSize: const Size(double.infinity, 52), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))), child: const Text("إضرب بقوة!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
        ])),
      ]),
    );
  }
}
class _PoolPainter extends CustomPainter {
  final Offset cue; final List<Offset> balls; final List<bool> gone;
  _PoolPainter(this.cue,this.balls,this.gone);
  @override void paint(Canvas c, Size s){
    final pocket=Paint()..color=Colors.black;
    c.drawCircle(const Offset(12,12), 14, pocket); c.drawCircle(Offset(s.width-12,12), 14, pocket);
    c.drawCircle(const Offset(12,400-12), 14, pocket); c.drawCircle(Offset(s.width-12,400-12), 14, pocket);
    c.drawCircle(Offset(s.width/2,10), 12, pocket); c.drawCircle(Offset(s.width/2,400-10), 12, pocket);
    c.drawCircle(cue, 12, Paint()..color=Colors.white);
    List<Color> cols=[Colors.red, Colors.blue, Colors.yellow, Colors.purple];
    for(int i=0;i<balls.length;i++){ if(gone[i]) continue; c.drawCircle(balls[i], 10, Paint()..color=cols[i]); }
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate)=> true;
}

// ==================== 4- دومينو - مصلح ====================
class DominoFixed extends StatefulWidget { const DominoFixed({super.key}); @override State<DominoFixed> createState()=> _DominoState(); }
class _DominoState extends State<DominoFixed> {
  List<List<int>> board=[[3,2]]; List<List<int>> hand=[[0,6],[6,1],[2,5],[1,4],[4,4]]; List<List<int>> bot=[[5,3],[1,2]];
  int left=3,right=2; String status="دورك";
  void play(int idx){
    var d=hand[idx]; bool canLeft=d[0]==left||d[1]==left; bool canRight=d[0]==right||d[1]==right;
    if(!canLeft &&!canRight){ setState(()=> status="لا تناسب"); return; }
    setState((){
      if(canLeft){ board.insert(0, d[0]==left? [d[1],d[0]]:d); left=board.first[0]; }
      else { board.add(d[0]==right? d: [d[1],d[0]]); right=board.last[1]; }
      hand.removeAt(idx); status="دور البوت";
    });
    Future.delayed(const Duration(seconds: 1), botMove);
  }
  void botMove(){
    for(int i=0;i<bot.length;i++){
      var d=bot[i]; if(d[0]==left||d[1]==left||d[0]==right||d[1]==right){
        setState((){
          if(d[0]==left||d[1]==left){ board.insert(0, d[0]==left? [d[1],d[0]]:d); left=board.first[0]; }
          else { board.add(d[0]==right? d: [d[1],d[0]]); right=board.last[1]; }
          bot.removeAt(i); status="دورك انت";
        }); return;
      }
    }
    setState((){ bot.add([Random().nextInt(7), Random().nextInt(7)]); status="البوت سحب - دورك"; });
  }
  @override Widget build(BuildContext context){
    return Scaffold(appBar: AppBar(title: Text("دومينو [$left | $right] - $status"), backgroundColor: const Color(0xFF451A03), foregroundColor: Colors.white),
      body: Column(children: [
        Container(padding: const EdgeInsets.all(10), color: Colors.black26, child: Row(children: [Text("البوت: ${bot.length} قطع", style: const TextStyle(color: Colors.white70)), const Spacer(), Text(status, style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold))])),
        Expanded(child: Container(margin: const EdgeInsets.all(10), decoration: BoxDecoration(color: const Color(0xFF3E2723), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.amber.shade700, width: 2)), child: Center(child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(mainAxisAlignment: MainAxisAlignment.center, children: board.map((d)=> Container(margin: const EdgeInsets.all(4), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.black26)), child: Column(mainAxisSize: MainAxisSize.min, children: [Text("${d[0]}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)), Container(width: 24, height: 2, color: Colors.black), Text("${d[1]}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18))]))).toList()))))),
        Container(padding: const EdgeInsets.all(12), color: const Color(0xFF111827), child: Column(children: [
          const Text("قطعك:", style: TextStyle(color: Colors.white54)), const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 8, children: List.generate(hand.length, (i)=> InkWell(onTap: ()=> play(i), child: Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.amber, width: 1.5)), child: Text("${hand[i][0]} | ${hand[i][1]}", style: const TextStyle(fontWeight: FontWeight.bold)))))),
          const SizedBox(height: 10), ElevatedButton(onPressed: ()=> setState(()=> hand.add([Random().nextInt(7), Random().nextInt(7)])), child: const Text("اسحب قطعة")),
        ])),
      ]),
    );
  }
}
