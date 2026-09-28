import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(MaterialApp(home: TopTopLudoFinal(), debugShowCheckedModeBanner: false));

class TopTopLudoFinal extends StatefulWidget { @override _TopTopLudoFinalState createState() => _TopTopLudoFinalState(); }

class _TopTopLudoFinalState extends State<TopTopLudoFinal> {
  int dice = 5, turn = 0;
  bool canRoll = true;
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
    setState(() { dice = Random().nextInt(6)+1; canRoll=false; });
    bool hasMove=false;
    for(int i=0;i<4;i++) if(tokens[turn][i]==-1 && dice==6 || tokens[turn][i]>=0) hasMove=true;
    if(!hasMove) Future.delayed(Duration(seconds:1), ()=> setState((){ turn=(turn+1)%4; canRoll=true; }));
  }
  void move(int t) {
    if(canRoll) return;
    setState(() {
      int p=tokens[turn][t];
      if(p==-1 && dice==6) tokens[turn][t]=turn*13;
      else if(p>=0){ int np=p+dice; if(np>=52) np-=52;
        if(!safeCells.contains(np)) for(int pl=0;pl<4;pl++) for(int tk=0;tk<4;tk++) if(pl!=turn && tokens[pl][tk]==np) tokens[pl][tk]=-1;
        tokens[turn][t]=np;
      }
      if(dice!=6) turn=(turn+1)%4;
      canRoll=true;
    });
  }

  Widget tokenWidget(Color c, bool isMine){
    return Container(width: 26, height: 26,
      decoration: BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.white, c, c.withOpacity(0.8)]), border: Border.all(color: Colors.white, width: 2.5), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 4, offset: Offset(0,3))]),
      child: Center(child: Icon(Icons.star, size: 14, color: Color(0xFFFFD700))),
    );
  }

  @override Widget build(BuildContext context){
    List<Color> cols=[Color(0xFFE53935), Color(0xFF43A047), Color(0xFFFBC02D), Color(0xFF1E88E5)];
    return Scaffold(backgroundColor: Color(0xFF0F1B2E),
      body: SafeArea(child: Column(children: [
        Padding(padding: EdgeInsets.all(8), child: Row(children: [
          for(int i=0;i<4;i++) Container(margin: EdgeInsets.only(right:10), padding: EdgeInsets.all(2), decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: turn==i?cols[i]:Colors.white24, width: 3)), child: CircleAvatar(radius: 18, backgroundColor: cols[i].withOpacity(0.3), child: Icon(Icons.person, color: Colors.white))),
          Spacer(), Icon(Icons.mic, color: Colors.greenAccent),
        ])),
        // البورد الذهبي
        Container(margin: EdgeInsets.all(8), padding: EdgeInsets.all(5), decoration: BoxDecoration(color: Color(0xFFD4AF37), borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 10)]),
          child: Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: AspectRatio(aspectRatio: 1, child: Stack(children: [
              GridView.builder(physics: NeverScrollableScrollPhysics(), gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 15), itemCount: 225,
                itemBuilder: (c,i){
                  int r=i~/15, co=i%15;
                  Color bg=Colors.white;
                  if(r<6 && co<6) bg=Color(0xFFE53935);
                  else if(r<6 && co>8) bg=Color(0xFF43A047);
                  else if(r>8 && co<6) bg=Color(0xFFFBC02D);
                  else if(r>8 && co>8) bg=Color(0xFF1E88E5);
                  else if(r==7 && co==7) bg=Colors.white;
                  if(co==7 && r>=1 && r<=5) bg=Color(0xFFFFCDD2);
                  if(co==7 && r>=9 && r<=13) bg=Color(0xFFBBDEFB);
                  if(r==7 && co>=1 && co<=5) bg=Color(0xFFFFF9C4);
                  if(r==7 && co>=9 && co<=13) bg=Color(0xFFC8E6C9);
                  if(r>=6 && r<=8 && co>=6 && co<=8 && (r==6||r==8||co==6||co==8)) bg=Color(0xFFFFD54F);
                  bool isSafe=false; for(var s in safeCells){ var p=path[s]; if(p.x==r && p.y==co) isSafe=true; }
                  bool isCenter = (r>=6&&r<=8&&co>=6&&co<=8);
                  return Container(decoration: BoxDecoration(color: bg, border: Border.all(color: Colors.black12, width: 0.6)),
                    child: isCenter && r==7 && co==7? Icon(Icons.emoji_events, size: 18, color: Color(0xFFD4AF37))
                    : isSafe? Icon(Icons.star, size: 12, color: Color(0xFFD4AF37)) : null,
                  );
                }
              ),
              for(int p=0;p<4;p++) for(int t=0;t<4;t++) Builder(builder: (_){
                int pos=tokens[p][t];
                double x,y;
                if(pos==-1){ x=(p==0||p==3)? 18 + t%2*65 : 268 + t%2*65; y=(p<2)? 22 + t~/2*65 : 270 + t~/2*65; }
                else { var cc=path[pos]; x=cc.y*23.8+2; y=cc.x*23.8+2; }
                return Positioned(left: x, top: y, child: GestureDetector(onTap: ()=> p==turn?move(t):null, child: tokenWidget(cols[p], p==turn)));
              }),
            ]))
          )
        ),
        SizedBox(height: 12),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(width: 70, height: 70, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)]), child: Center(child: Text("$dice", style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900)))),
          SizedBox(width: 16),
          GestureDetector(onTap: roll, child: Container(padding: EdgeInsets.symmetric(horizontal: 50, vertical: 18), decoration: BoxDecoration(color: Color(0xFFFFC300), borderRadius: BorderRadius.circular(30), boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)]), child: Text(canRoll?"ارمي النرد 🎲":"حرك قطعة", style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)))),
        ]),
        SizedBox(height: 8), Text("⭐ 8 خانات آمنة لا يمكن الأكل فيها", style: TextStyle(color: Colors.white54)),
      ])),
    );
  }
}
