import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(MaterialApp(home: LudoExact(), debugShowCheckedModeBanner: false));

class LudoExact extends StatefulWidget { @override _LudoExactState createState() => _LudoExactState(); }

class _LudoExactState extends State<LudoExact> {
  int dice=5, turn=0;
  bool canRoll=true;
  List<List<int>> tokens=List.generate(4, (_) => List.filled(4,-1));
  List<int> safe=[0,8,13,21,26,34,39,47];
  List<Point<int>> path=[
    Point(6,1), Point(6,2), Point(6,3), Point(6,4), Point(6,5), Point(5,6), Point(4,6), Point(3,6), Point(2,6), Point(1,6), Point(0,6), Point(0,7), Point(0,8),
    Point(1,8), Point(2,8), Point(3,8), Point(4,8), Point(5,8), Point(6,9), Point(6,10), Point(6,11), Point(6,12), Point(6,13), Point(6,14), Point(7,14), Point(8,14),
    Point(8,13), Point(8,12), Point(8,11), Point(8,10), Point(8,9), Point(9,8), Point(10,8), Point(11,8), Point(12,8), Point(13,8), Point(14,8), Point(14,7), Point(14,6),
    Point(13,6), Point(12,6), Point(11,6), Point(10,6), Point(9,6), Point(8,5), Point(8,4), Point(8,3), Point(8,2), Point(8,1), Point(8,0), Point(7,0), Point(6,0),
  ];

  void roll(){ if(!canRoll) return; setState(()=> dice=Random().nextInt(6)+1); canRoll=false;
    bool has=false; for(int i=0;i<4;i++) if(tokens[turn][i]==-1&&dice==6||tokens[turn][i]>=0) has=true;
    if(!has) Future.delayed(Duration(seconds:1), ()=> setState((){ turn=(turn+1)%4; canRoll=true; }));
  }
  void move(int t){ if(canRoll) return; setState((){
    int p=tokens[turn][t]; if(p==-1&&dice==6) tokens[turn][t]=turn*13;
    else if(p>=0){ int np=p+dice; if(np>=52) np-=52;
      if(!safe.contains(np)) for(int pl=0;pl<4;pl++) for(int tk=0;tk<4;tk++) if(pl!=turn&&tokens[pl][tk]==np) tokens[pl][tk]=-1;
      tokens[turn][t]=np;
    }
    if(dice!=6) turn=(turn+1)%4; canRoll=true;
  });}

  Widget token(Color c){ return Container(width: 28, height: 28, decoration: BoxDecoration(shape: BoxShape.circle, gradient: RadialGradient(colors: [Colors.white, c]), border: Border.all(color: Colors.white, width: 2.5), boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 4, offset: Offset(0,2))]), child: Center(child: Icon(Icons.star, size: 16, color: Color(0xFFFFA000)))); }
  Widget house(Color c){ return Container(decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(6), boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0,2))]), child: Container(margin: EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.black.withOpacity(0.15), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.black12)), child: Center(child: Wrap(spacing: 12, runSpacing: 12, children: List.generate(4, (_)=> token(c)))))); }

  @override Widget build(BuildContext context){
    List<Color> cols=[Color(0xFFE53935), Color(0xFFFBC02D), Color(0xFF43A047), Color(0xFF1E88E5)];
    List<String> names=["You | Red","Sara | Yellow","Leo | Green","Mia | Blue"];
    return Scaffold(
      body: Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF0D1B4A), Color(0xFF1A0B3E)])),
        child: SafeArea(child: Column(children: [
          // Top players like image
          Container(margin: EdgeInsets.all(10), padding: EdgeInsets.all(10), decoration: BoxDecoration(color: Color(0xFF1E2A5E).withOpacity(0.9), borderRadius: BorderRadius.circular(22), border: Border.all(color: Colors.white24)),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: List.generate(4, (i)=> Column(children: [
              Container(padding: EdgeInsets.all(3), decoration: BoxDecoration(border: Border.all(color: cols[i], width: 3), borderRadius: BorderRadius.circular(30)), child: Container(width: 54, height: 64, decoration: BoxDecoration(color: cols[i].withOpacity(0.2), borderRadius: BorderRadius.circular(24)), child: Icon(Icons.person, color: Colors.white, size: 36))),
              SizedBox(height: 4), Text(names[i], style: TextStyle(color: cols[i], fontWeight: FontWeight.bold, fontSize: 12)),
            ]))
          ),
          SizedBox(height: 10),
          // Board with gold frame
          Expanded(child: Center(child: AspectRatio(aspectRatio: 0.95, child: Container(padding: EdgeInsets.all(8), decoration: BoxDecoration(color: Color(0xFFD4AF37), borderRadius: BorderRadius.circular(18), boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 12)], gradient: LinearGradient(colors: [Color(0xFFE8C765), Color(0xFFB8962F)])),
            child: Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
              child: Stack(children: [
                // Grid
                Column(children: List.generate(15, (r)=> Expanded(child: Row(children: List.generate(15, (co){
                  Color bg=Colors.white;
                  if(r<6&&co<6) bg=Color(0xFFE53935);
                  else if(r<6&&co>8) bg=Color(0xFF43A047);
                  else if(r>8&&co<6) bg=Color(0xFFFBC02D);
                  else if(r>8&&co>8) bg=Color(0xFF1E88E5);
                  if(co==7&&r>=1&&r<=5) bg=Color(0xFFFFEB3B);
                  if(co==7&&r>=9&&r<=13) bg=Color(0xFFFFEB3B);
                  if(r==7&&co>=1&&co<=5) bg=Color(0xFFE53935);
                  if(r==7&&co>=9&&co<=13) bg=Color(0xFF43A047);
                  if(r>=6&&r<=8&&co>=6&&co<=8) bg=Colors.white;
                  bool isSafe=false; for(var s in safe){ var p=path[s]; if(p.x==r&&p.y==co) isSafe=true; }
                  return Expanded(child: Container(decoration: BoxDecoration(color: bg, border: Border.all(color: Colors.black26, width: 0.5)),
                    child: isSafe? Icon(Icons.star, size: 14, color: Color(0xFFFF8F00)) : (r==6&&co==10||r==9&&co==2||r==2&&co==7||r==12&&co==7? Icon(Icons.star, size: 10, color: Colors.white70):null)
                  ));
                }))))),
                // Houses inner
                Positioned(left: 0, top: 0, width: 90, height: 90, child: house(cols[0])),
                Positioned(right: 0, top: 0, width: 90, height: 90, child: house(cols[2])),
                Positioned(left: 0, bottom: 0, width: 90, height: 90, child: house(cols[1])),
                Positioned(right: 0, bottom: 0, width: 90, height: 90, child: house(cols[3])),
                // Center crown
                Center(child: Container(width: 50, height: 50, decoration: BoxDecoration(shape: BoxShape.circle, gradient: RadialGradient(colors: [Color(0xFFFFE082), Color(0xFFFFA000)]), border: Border.all(color: Colors.white, width: 2), boxShadow: [BoxShadow(color: Colors.amber, blurRadius: 10)]), child: Icon(Icons.emoji_events, color: Colors.brown, size: 28))),
                // Tokens on path
                for(int p=0;p<4;p++) for(int t=0;t<4;t++) Builder(builder: (_){
                  int pos=tokens[p][t]; if(pos==-1) return SizedBox();
                  var cc=path[pos]; double x=cc.y*16.8+1, y=cc.x*16.8+1;
                  return Positioned(left: x, top: y, child: GestureDetector(onTap: ()=> p==turn?move(t):null, child: token(cols[p])));
                }),
              ])
            )
          )))),
          // Bottom like image
          Container(margin: EdgeInsets.all(10), padding: EdgeInsets.all(10), decoration: BoxDecoration(color: Color(0xFF0F1E42), borderRadius: BorderRadius.circular(20)),
            child: Row(children: [
              Container(width: 54, height: 54, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)), child: Center(child: Text("$dice", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)))),
              SizedBox(width: 10),
              Expanded(child: ElevatedButton(onPressed: roll, style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF2EC4B6), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), padding: EdgeInsets.symmetric(vertical: 14)), child: Text(canRoll?"ROLL":"MOVE", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)))),
              SizedBox(width: 10),
              ElevatedButton(onPressed: (){}, style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFFFC233), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))), child: Text("SAFE", style: TextStyle(color: Colors.black))),
              SizedBox(width: 10),
              ElevatedButton(onPressed: (){}, style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF3A4A7A), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))), child: Text("MENU")),
            ])
          )
        ]))
      )
    );
  }
}
