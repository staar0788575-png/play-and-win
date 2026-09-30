import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() => runApp(MaterialApp(home: LudoLuxury(), debugShowCheckedModeBanner: false));

class LudoLuxury extends StatefulWidget {
  @override State<LudoLuxury> createState() => _LudoLuxuryState();
}

class _LudoLuxuryState extends State<LudoLuxury> {
  int dice = 1; int turn = 0; bool canRoll = true; String msg = "دورك يا ملك";
  List<List<int>> pos = [[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1]];
  List<int> start = [0,13,26,39];
  List<int> safe = [0,8,13,21,26,34,39,47];
  List<Offset> path = [
    Offset(6,1), Offset(6,2), Offset(6,3), Offset(6,4), Offset(6,5),
    Offset(5,6), Offset(4,6), Offset(3,6), Offset(2,6), Offset(1,6), Offset(0,6), Offset(0,7), Offset(0,8), Offset(1,8), Offset(2,8), Offset(3,8), Offset(4,8), Offset(5,8),
    Offset(6,9), Offset(6,10), Offset(6,11), Offset(6,12), Offset(6,13), Offset(6,14), Offset(7,14), Offset(8,14),
    Offset(8,13), Offset(8,12), Offset(8,11), Offset(8,10), Offset(8,9), Offset(9,8), Offset(10,8), Offset(11,8), Offset(12,8), Offset(13,8), Offset(14,8), Offset(14,7), Offset(14,6), Offset(13,6), Offset(12,6), Offset(11,6), Offset(10,6), Offset(9,6),
    Offset(8,5), Offset(8,4), Offset(8,3), Offset(8,2), Offset(8,1), Offset(8,0), Offset(7,0), Offset(6,0),
  ];

  void roll(){ if(!canRoll) return; setState((){ dice=math.Random().nextInt(6)+1; canRoll=false; msg="جبت $dice - حرك ملكك"; });
    bool has=false; for(int t in pos[turn]){ if(t==-1&&dice==6) has=true; if(t>=0&&t<52) has=true; }
    if(!has){ Future.delayed(Duration(seconds: 1),(){ setState((){ turn=(turn+1)%4; canRoll=true; msg="مفيش حركة"; }); }); }
  }
  void move(int p,int idx){
    if(p!=turn||canRoll) return;
    if(pos[p][idx]==-1&&dice!=6) return;
    setState((){
      if(pos[p][idx]==-1) pos[p][idx]=start[p]; else pos[p][idx]+=dice;
      int np=pos[p][idx]; if(np<52&&!safe.contains(np)){ for(int op=0;op<4;op++){ if(op==p) continue; for(int ot=0;ot<4;ot++){ if(pos[op][ot]==np) pos[op][ot]=-1; } } }
      if(dice!=6) turn=(turn+1)%4; canRoll=true; msg="دور ملك ${["الأحمر","الأصفر","الأخضر","الأزرق"][turn]}";
    });
  }

  Widget kingToken(Color c, int p, int idx, bool small){
    Color gem = c;
    return GestureDetector(
      onTap: ()=>move(p,idx),
      child: Container(
        width: small?34:48, height: small?34:48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [Color(0xFFFFE082), Color(0xFFFFC107), Color(0xFFB8860B)]),
          border: Border.all(color: Colors.white, width: 2.2),
          boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 6, offset: Offset(0,3)), BoxShadow(color: gem.withOpacity(0.6), blurRadius: 8)],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(Icons.chess, size: small?18:28, color: Color(0xFF3E2723)),
            Positioned(top: 2, child: Container(width: small?8:12, height: small?8:12, decoration: BoxDecoration(color: gem, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 1)),)),
          ],
        ),
      ),
    );
  }

  @override Widget build(BuildContext context){
    Color red = Color(0xFFE53935); Color yellow = Color(0xFFFBC02D); Color green = Color(0xFF43A047); Color blue = Color(0xFF1E88E5);
    List<Color> cols=[red,yellow,green,blue];
    double size = MediaQuery.of(context).size.width - 12;
    double cell = size/15;

    return Scaffold(
      backgroundColor: Color(0xFF1A237E),
      body: Container(
        decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF0D1B4A), Color(0xFF2A1B6A)])),
        child: SafeArea(child: Column(children: [
          Padding(padding: EdgeInsets.all(12), child: Row(children: [
            Icon(Icons.arrow_back, color: Colors.white), SizedBox(width:10),
            Text("Ludo Royal • 10356", style: TextStyle(color: Colors.amber[200], fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1)),
            Spacer(), Container(padding: EdgeInsets.symmetric(horizontal:10, vertical:4), decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.amber)), child: Text(msg, style: TextStyle(color: Colors.white, fontSize:11))),
          ])),
          // بورد خشب فخم زي الصورة
          Center(child: Container(
            width: size, height: size,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0xFF4E342E),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Color(0xFFD4AF37), width: 4),
              boxShadow: [BoxShadow(color: Colors.black87, blurRadius: 20, offset: Offset(0,10))],
            ),
            child: Container(
              decoration: BoxDecoration(color: Color(0xFFF5E6C8), borderRadius: BorderRadius.circular(6), border: Border.all(color: Color(0xFFD4AF37), width: 2)),
              child: Stack(children: [
                GridView.count(
                  crossAxisCount: 15, physics: NeverScrollableScrollPhysics(),
                  children: List.generate(225, (i){
                    int r=i~/15, c=i%15; Color bg=Color(0xFFFFF8E1); Widget? ch;
                    if(r<6&&c<6) bg=red.withOpacity(0.85);
                    else if(r<6&&c>8) bg=green.withOpacity(0.85);
                    else if(r>8&&c<6) bg=yellow.withOpacity(0.85);
                    else if(r>8&&c>8) bg=blue.withOpacity(0.85);
                    else if(r>=6&&r<=8&&c>=6&&c<=8) bg=Color(0xFFFFD54F);
                    else if(r==7&&c>=1&&c<=4) bg=red.withOpacity(0.5);
                    else if(r==7&&c>=10&&c<=12) bg=green.withOpacity(0.5);
                    else if(c==7&&r>=1&&r<=4) bg=yellow.withOpacity(0.5);
                    else if(c==7&&r>=10&&r<=13) bg=yellow.withOpacity(0.5);
                    if(safe.contains(path.indexWhere((e)=>e.dx==r&&e.dy==c))) ch=Icon(Icons.shield, size: cell*0.4, color: Colors.brown);
                    return Container(decoration: BoxDecoration(color: bg, border: Border.all(color: Color(0xFFD4AF37).withOpacity(0.4), width: 0.6)), child: Center(child: ch));
                  }),
                ),
                // بيوت مزخرفة دهبي زي الصورة
                Positioned(left: cell*0.5, top: cell*0.5, width: cell*5, height: cell*5, child: Container(decoration: BoxDecoration(color: red, borderRadius: BorderRadius.circular(6), border: Border.all(color: Color(0xFFFFD700), width: 3)))),
                Positioned(left: cell*9.5, top: cell*0.5, width: cell*5, height: cell*5, child: Container(decoration: BoxDecoration(color: green, borderRadius: BorderRadius.circular(6), border: Border.all(color: Color(0xFFFFD700), width: 3)))),
                Positioned(left: cell*0.5, top: cell*9.5, width: cell*5, height: cell*5, child: Container(decoration: BoxDecoration(color: yellow, borderRadius: BorderRadius.circular(6), border: Border.all(color: Color(0xFFFFD700), width: 3)))),
                Positioned(left: cell*9.5, top: cell*9.5, width: cell*5, height: cell*5, child: Container(decoration: BoxDecoration(color: blue, borderRadius: BorderRadius.circular(6), border: Border.all(color: Color(0xFFFFD700), width: 3)))),

                // ملوك داخل البيوت
              ...List.generate(4, (p)=>List.generate(4, (t){
                  int bp=pos[p][t];
                  double x,y;
                  if(bp==-1){
                    if(p==0){ x=(t%2==0?1.2:3.2)*cell; y=(t<2?1.2:3.2)*cell; }
                    else if(p==1){ x=(t%2==0?1.2:3.2)*cell; y=(t<2?10.2:12.2)*cell; }
                    else if(p==2){ x=(t%2==0?10.2:12.2)*cell; y=(t<2?1.2:3.2)*cell; }
                    else{ x=(t%2==0?10.2:12.2)*cell; y=(t<2?10.2:12.2)*cell; }
                  } else if(bp>=100){ x=6.3*cell; y=6.3*cell; }
                  else{ var pt=path[bp%52]; x=pt.dy*cell; y=pt.dx*cell; }
                  return Positioned(left: x, top: y, child: kingToken(cols[p], p, t, bp!=-1));
                })).expand((e)=>e),

                Positioned(left: 6*cell, top: 6*cell, width: 3*cell, height: 3*cell, child: Container(decoration: BoxDecoration(shape: BoxShape.circle, gradient: RadialGradient(colors: [Color(0xFFFFD700), Color(0xFF8D6E00)]), border: Border.all(color: Colors.white, width: 2)), child: Icon(Icons.emoji_events, color: Colors.white, size: 20))),
              ]),
            ),
          )),
          Spacer(),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(color: Color(0xFF12123A), borderRadius: BorderRadius.vertical(top: Radius.circular(24)), border: Border(top: BorderSide(color: Color(0xFFFFD700), width: 1.5))),
            child: Row(children: [
              Container(width: 58, height: 58, decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xFFFFD700), Color(0xFFB8860B)]), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white)), child: Center(child: Text("$dice", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF3E2723))))),
              SizedBox(width: 12),
              Expanded(child: GestureDetector(onTap: roll, child: Container(height: 52, decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xFFFFD700), Color(0xFFFFA000)]), borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.amber.withOpacity(0.5), blurRadius: 10)]), child: Center(child: Text("ROLL 👑", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFF3E2723))))))),
              SizedBox(width: 10),
              Container(height: 52, padding: EdgeInsets.symmetric(horizontal: 16), decoration: BoxDecoration(color: Color(0xFFFFC93C), borderRadius: BorderRadius.circular(14)), child: Center(child: Text("SAFE", style: TextStyle(fontWeight: FontWeight.bold)))),
            ]),
          ),
        ])),
      ),
    );
  }
}
