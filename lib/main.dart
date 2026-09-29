import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(const MaterialApp(home: LudoExact(), debugShowCheckedModeBanner: false));

class LudoExact extends StatefulWidget {
  const LudoExact({super.key});
  @override State<LudoExact> createState() => _LudoExactState();
}

class _LudoExactState extends State<LudoExact> {
  int dice=5, turn=0;
  bool canRoll=true;
  List<List<int>> tokens=List.generate(4, (_) => List.filled(4,-1));
  final List<int> safe=[0,8,13,21,26,34,39,47];
  final List<Point<int>> path=[
    Point(6,1), Point(6,2), Point(6,3), Point(6,4), Point(6,5), Point(5,6), Point(4,6), Point(3,6), Point(2,6), Point(1,6), Point(0,6), Point(0,7), Point(0,8),
    Point(1,8), Point(2,8), Point(3,8), Point(4,8), Point(5,8), Point(6,9), Point(6,10), Point(6,11), Point(6,12), Point(6,13), Point(6,14), Point(7,14), Point(8,14),
    Point(8,13), Point(8,12), Point(8,11), Point(8,10), Point(8,9), Point(9,8), Point(10,8), Point(11,8), Point(12,8), Point(13,8), Point(14,8), Point(14,7), Point(14,6),
    Point(13,6), Point(12,6), Point(11,6), Point(10,6), Point(9,6), Point(8,5), Point(8,4), Point(8,3), Point(8,2), Point(8,1), Point(8,0), Point(7,0), Point(6,0),
  ];

  void roll(){
    if(!canRoll) return;
    setState(()=> dice=Random().nextInt(6)+1);
    canRoll=false;
    bool has=false;
    for(int i=0;i<4;i++){ if(tokens[turn][i]==-1 && dice==6) has=true; if(tokens[turn][i]>=0) has=true; }
    if(!has){ Future.delayed(const Duration(seconds:1), ()=> setState((){ turn=(turn+1)%4; canRoll=true; })); }
  }

  void moveToken(int t){
    if(canRoll) return;
    setState((){
      int p=tokens[turn][t];
      if(p==-1 && dice==6) tokens[turn][t]=turn*13;
      else if(p>=0){
        int np=p+dice; if(np>=52) np-=52;
        if(!safe.contains(np)){ for(int pl=0;pl<4;pl++){ for(int tk=0;tk<4;tk++){ if(pl!=turn && tokens[pl][tk]==np) tokens[pl][tk]=-1; } } }
        tokens[turn][t]=np;
      }
      if(dice!=6) turn=(turn+1)%4;
      canRoll=true;
    });
  }

  Widget tokenBox(Color c){
    return Container(
      width: 26, height: 26,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: c,
        border: Border.all(color: Colors.white, width: 2.5),
        boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 4, offset: Offset(0,2))],
      ),
      child: const Center(child: Icon(Icons.star, size: 14, color: Color(0xFFFFD700))),
    );
  }

  @override Widget build(BuildContext context){
    List<Color> cols=[const Color(0xFFE53935), const Color(0xFFFBC02D), const Color(0xFF43A047), const Color(0xFF1E88E5)];
    List<String> names=["You Red","Sara Yellow","Leo Green","Mia Blue"];
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF0D1B4A), Color(0xFF1A0B3E)])),
        child: SafeArea(child: Column(children: [
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: const Color(0xFF1E2A5E), borderRadius: BorderRadius.circular(22), border: Border.all(color: Colors.white24)),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: List.generate(4, (i)=> Column(children: [
              Container(padding: const EdgeInsets.all(3), decoration: BoxDecoration(border: Border.all(color: cols[i], width: 3), borderRadius: BorderRadius.circular(30)), child: Container(width: 54, height: 60, decoration: BoxDecoration(color: cols[i], borderRadius: BorderRadius.circular(20)), child: const Icon(Icons.person, color: Colors.white, size: 32))),
              const SizedBox(height: 4),
              Text(names[i], style: TextStyle(color: cols[i], fontWeight: FontWeight.bold, fontSize: 11)),
            ]))),
          ),
          Expanded(child: Center(child: AspectRatio(aspectRatio: 1, child: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: const Color(0xFFD4AF37), borderRadius: BorderRadius.circular(18)),
            child: Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Stack(children: [
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 15),
                  itemCount: 225,
                  itemBuilder: (c,i){
                    int r=i~/15, co=i%15;
                    Color bg=Colors.white;
                    if(r<6 && co<6) bg=const Color(0xFFE53935);
                    else if(r<6 && co>8) bg=const Color(0xFF43A047);
                    else if(r>8 && co<6) bg=const Color(0xFFFBC02D);
                    else if(r>8 && co>8) bg=const Color(0xFF1E88E5);
                    if(co==7 && r>=1 && r<=5) bg=const Color(0xFFFFEB3B);
                    if(co==7 && r>=9 && r<=13) bg=const Color(0xFFFFEB3B);
                    if(r==7 && co>=1 && co<=5) bg=const Color(0xFFE53935);
                    if(r==7 && co>=9 && co<=13) bg=const Color(0xFF43A047);
                    bool isSafe=false;
                    for(var s in safe){ var p=path[s]; if(p.x==r && p.y==co) isSafe=true; }
                    return Container(
                      decoration: BoxDecoration(color: bg, border: Border.all(color: Colors.black26, width: 0.5)),
                      child: isSafe? const Icon(Icons.star, size: 12, color: Color(0xFFFF8F00)) : null,
                    );
                  },
                ),
                Center(child: Container(width: 46, height: 46, decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFFFFA000), border: Border.all(color: Colors.white, width: 2)), child: const Icon(Icons.emoji_events, color: Colors.white))),
                for(int p=0;p<4;p++) for(int t=0;t<4;t++) Builder(builder: (_){
                  int pos=tokens[p][t];
                  if(pos==-1) return const SizedBox.shrink();
                  var cc=path[pos];
                  double x=cc.y*23.5+1, y=cc.x*23.5+1;
                  return Positioned(left: x, top: y, child: GestureDetector(onTap: ()=> p==turn? moveToken(t) : null, child: tokenBox(cols[p])));
                }),
              ]),
            ),
          )))),
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: const Color(0xFF0F1E42), borderRadius: BorderRadius.circular(20)),
            child: Row(children: [
              Container(width: 56, height: 56, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)), child: Center(child: Text("$dice", style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)))),
              const SizedBox(width: 10),
              Expanded(child: ElevatedButton(onPressed: roll, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2EC4B6), padding: const EdgeInsets.symmetric(vertical: 14)), child: Text(canRoll?"ROLL":"MOVE", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)))),
            ]),
          )
        ]))),
      ),
    );
  }
}
