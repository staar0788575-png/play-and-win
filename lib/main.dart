import 'package:flutter/material.dart';
import 'dart:math';
void main()=>runApp(MaterialApp(home: LudoPro(), debugShowCheckedModeBanner: false));

class LudoPro extends StatefulWidget{ @override _LudoProState createState()=>_LudoProState(); }
class _LudoProState extends State<LudoPro>{
  int dice=1, turn=0;
  // 4x4 tokens
  List<List<int>> pos = List.generate(4, (_)=>List.filled(4, -1));
  void roll(){ setState(()=> dice=Random().nextInt(6)+1 ); }

  @override Widget build(BuildContext ctx){
    return Scaffold(backgroundColor: Color(0xFF1A1A2E),
      body: Column(children:[
        SizedBox(height:40),
        // بورد لودو حقيقي
        Container(margin: EdgeInsets.all(10), height: 350, decoration: BoxDecoration(border: Border.all(color: Colors.white, width:3)),
          child: GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 15), itemCount: 225,
            itemBuilder: (c,i){
              int r=i~/15, col=i%15;
              Color bg=Colors.white;
              if(r<6 && col<6) bg=Colors.red.shade400;
              else if(r<6 && col>8) bg=Colors.green.shade400;
              else if(r>8 && col<6) bg=Colors.yellow.shade700;
              else if(r>8 && col>8) bg=Colors.blue.shade400;
              else if(r==6 || r==8 || col==6 || col==8) bg=Colors.white;
              else bg=Color(0xFF16213E);
              // SAFE stars
              bool isSafe = (r==6&&col==1)||(r==1&&col==8)||(r==8&&col==13)||(r==13&&col==6);
              return Container(decoration: BoxDecoration(color:bg, border: Border.all(color: Colors.black12, width:0.5)),
                child: isSafe?Icon(Icons.star, size:10, color: Colors.black):null);
            }
          )
        ),
        ElevatedButton(onPressed: roll, child: Text("🎲 ارمي: $dice - دور اللاعب ${turn+1}")),
      ])
    );
  }
}
