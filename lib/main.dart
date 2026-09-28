import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(MaterialApp(home: TopTopLudo(), debugShowCheckedModeBanner: false));

class TopTopLudo extends StatefulWidget { @override _TopTopLudoState createState() => _TopTopLudoState(); }

class _TopTopLudoState extends State<TopTopLudo> {
  int dice = 6, turn = 0;
  bool canRoll = true, micOn = true;
  List<String> chat = ["يلا نبدأ يا رجالة"];
  TextEditingController ctrl = TextEditingController();
  List<List<int>> tokens = List.generate(4, (_) => List.filled(4, -1));
  List<int> safeCells = [0, 8, 13, 21, 26, 34, 39, 47];

  List<Point<int>> path = [
    Point(6,1), Point(6,2), Point(6,3), Point(6,4), Point(6,5), Point(5,6), Point(4,6), Point(3,6), Point(2,6), Point(1,6), Point(0,6), Point(0,7), Point(0,8),
    Point(1,8), Point(2,8), Point(3,8), Point(4,8), Point(5,8), Point(6,9), Point(6,10), Point(6,11), Point(6,12), Point(6,13), Point(6,14), Point(7,14), Point(8,14),
    Point(8,13), Point(8,12), Point(8,11), Point(8,10), Point(8,9), Point(9,8), Point(10,8), Point(11,8), Point(12,8), Point(13,8), Point(14,8), Point(14,7), Point(14,6),
    Point(13,6), Point(12,6), Point(11,6), Point(10,6), Point(9,6), Point(8,5), Point(8,4), Point(8,3), Point(8,2), Point(8,1), Point(8,0), Point(7,0), Point(6,0),
  ];

  void roll() {
    if (!canRoll) return;
    setState(() {
      dice = Random().nextInt(6) + 1;
      canRoll = false;
      bool hasMove = false;
      for (int i=0;i<4;i++) {
        if (tokens[turn][i]==-1 && dice==6) hasMove=true;
        if (tokens[turn][i]>=0) hasMove=true;
      }
      if (!hasMove) {
        Future.delayed(Duration(seconds: 1), ()=> setState((){ turn=(turn+1)%4; canRoll=true; }));
      }
    });
  }

  void move(int t) {
    if (canRoll) return;
    setState(() {
      int p = tokens[turn][t];
      if (p==-1 && dice==6) {
        tokens[turn][t]= turn*13;
      } else if (p>=0) {
        int np = p+dice;
        if (np>=52) np-=52;
        if (!safeCells.contains(np)) {
          for (int pl=0; pl<4; pl++) for (int tk=0; tk<4; tk++) if (pl!=turn && tokens[pl][tk]==np) tokens[pl][tk]=-1;
        }
        tokens[turn][t]=np;
      }
      if (dice!=6) turn=(turn+1)%4;
      canRoll=true;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Color> cols = [Colors.red, Colors.green, Colors.amber.shade700, Colors.blue];
    List<String> avatars = ["https://i.pravatar.cc/100?img=1","https://i.pravatar.cc/100?img=2","https://i.pravatar.cc/100?img=5","https://i.pravatar.cc/100?img=8"];
    return Scaffold(
      backgroundColor: Color(0xFF0F1B2E),
      appBar: AppBar(backgroundColor: Color(0xFF16213E), automaticallyImplyLeading: false,
        title: Row(children: [
          for(int i=0;i<4;i++) Container(margin: EdgeInsets.only(right:6), padding: EdgeInsets.all(2), decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: turn==i?cols[i]:Colors.transparent, width:3)), child: CircleAvatar(radius: 16, backgroundImage: NetworkImage(avatars[i]))),
          Spacer(),
          IconButton(icon: Icon(micOn?Icons.mic:Icons.mic_off, color: micOn?Colors.green:Colors.red), onPressed: ()=>setState(()=>micOn=!micOn)),
        ])
      ),
      body: Column(children: [
        AspectRatio(aspectRatio: 1, child: Container(margin: EdgeInsets.all(6), decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.white, width: 3), borderRadius: BorderRadius.circular(8)),
          child: Stack(children: [
            GridView.builder(physics: NeverScrollableScrollPhysics(), gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 15), itemCount: 225,
              itemBuilder: (c,i){
                int r=i~/15, col=i%15;
                Color bg=Colors.white;
                if (r<6 && col<6) bg=Colors.red.shade400;
                else if (r<6 && col>8) bg=Colors.green.shade400;
                else if (r>8 && col<6) bg=Colors.amber.shade400;
                else if (r>8 && col>8) bg=Colors.blue.shade400;
                else if (r>=6 && r<=8 && col>=6 && col<=8) { // بيت الفوز في النص
                  if (r==6 && col==7) bg=Colors.green;
                  else if (r==7 && col==8) bg=Colors.yellow.shade700;
                  else if (r==8 && col==7) bg=Colors.blue;
                  else if (r==7 && col==6) bg=Colors.red;
                  else bg=Colors.white;
                }
                else if (path.any((p)=>p.x==r && p.y==col)) bg=Colors.white;
                else bg=Color(0xFFEEF2F7);

                // ممرات ملونة للبيت
                if (col==7 && r>=1 && r<=5) bg=Colors.red.shade200;
                if (col==7 && r>=9 && r<=13) bg=Colors.blue.shade200;
                if (r==7 && col>=1 && col<=5) bg=Colors.amber.shade200;
                if (r==7 && col>=9 && col<=13) bg=Colors.green.shade200;

                bool isSafe=false;
                for(var s in safeCells){ var pp=path[s]; if(pp.x==r && pp.y==col) isSafe=true; }

                return Container(decoration: BoxDecoration(color: bg, border: Border.all(color: Colors.black12, width: 0.4)),
                  child: isSafe? Icon(Icons.star, size: 14, color: Color(0xFFD4AF37)) : null);
              }
            ),
            // القطع المجسمة
            for(int p=0;p<4;p++) for(int t=0;t<4;t++) Builder(builder: (_){
              int pos=tokens[p][t];
              double x,y;
              if(pos==-1){
                x=(p==0||p==3)? 22 + t%2*55 : 270 + t%2*55;
                y=(p<2)? 25 + t~/2*55 : 270 + t~/2*55;
              } else {
                var cc=path[pos];
                x=cc.y*24.5+4; y=cc.x*24.5+4;
              }
              return Positioned(left: x, top: y, child: GestureDetector(onTap: ()=> p==turn?move(t):null,
                child: Container(width: 22, height: 22, decoration: BoxDecoration(color: cols[p], shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 3), boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 4, offset: Offset(0,2))]),
                  child: Center(child: Container(width: 8, height: 8, decoration: BoxDecoration(color: Colors.white70, shape: BoxShape.circle)))
                )
              ));
            }),
          ])
        )),
        // نرد و زر حركة
        Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(width: 60, height: 70, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)), child: Center(child: Text("$dice", style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold)))),
          SizedBox(width: 18),
          ElevatedButton(onPressed: roll, style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFFFC300), padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16), shape: StadiumBorder()), child: Text(canRoll?"ارمي النرد 🎲":"حرك قطعة", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold))),
        ])),
        Text("⭐ 8 خانات آمنة لا يمكن الأكل فيها", style: TextStyle(color: Colors.white70, fontSize: 12)),
        Spacer(),
        // شات و هدايا زي توب توب
        Container(color: Colors.black26, padding: EdgeInsets.all(4), child: Column(children: [
          Container(height: 28, child: ListView(children: chat.map((m)=> Padding(padding: EdgeInsets.only(left:8), child: Text(m, style: TextStyle(color: Colors.white70, fontSize: 12)))).toList())),
          Row(children: [
            IconButton(icon: Icon(Icons.card_giftcard, color: Colors.pinkAccent), onPressed: ()=> setState(()=> chat.add("🎁 ارسل هدية"))),
            IconButton(icon: Icon(Icons.emoji_emotions, color: Colors.amber), onPressed: ()=> setState(()=> chat.add("😂🔥👏"))),
            Expanded(child: TextField(controller: ctrl, style: TextStyle(color: Colors.white), decoration: InputDecoration(hintText: "اكتب رسالة...", hintStyle: TextStyle(color: Colors.white38), isDense: true))),
            IconButton(icon: Icon(Icons.send, color: Colors.white), onPressed: (){ if(ctrl.text.isNotEmpty){ setState(()=> chat.add(ctrl.text)); ctrl.clear(); }}),
          ])
        ]))
      ])
    );
  }
}
