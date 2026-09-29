import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(MaterialApp(home: LudoPro(), debugShowCheckedModeBanner: false));

class LudoPro extends StatefulWidget {
  @override State<LudoPro> createState() => _LudoProState();
}

class _LudoProState extends State<LudoPro> {
  int dice = 6;
  int turn = 2;
  bool canRoll = true;
  List<List<int>> tokens = [[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1]];

  void roll() {
    if(!canRoll) return;
    setState((){ dice = Random().nextInt(6)+1; canRoll = false; });
    bool has = false;
    for(int i=0;i<4;i++){ if(tokens[turn][i]==-1 && dice==6) has=true; if(tokens[turn][i]>=0) has=true; }
    if(!has){ Future.delayed(Duration(seconds:1),(){ setState((){ turn=(turn+1)%4; canRoll=true; }); }); }
  }

  void moveToken(int p,int t){
    if(p!=turn || canRoll) return;
    setState((){
      if(tokens[p][t]==-1 && dice==6) tokens[p][t]=0;
      else if(tokens[p][t]>=0) tokens[p][t]+=dice;
      if(dice!=6) turn=(turn+1)%4;
      canRoll=true;
    });
  }

  Widget starToken(Color c, int p,int t){
    bool out = tokens[p][t]!=-1;
    return GestureDetector(
      onTap: ()=>moveToken(p,t),
      child: Opacity(
        opacity: out?0.25:1,
        child: Container(width:38,height:38,decoration: BoxDecoration(shape:BoxShape.circle,color:c,border:Border.all(color:Colors.white,width:2.2),boxShadow:[BoxShadow(color:Colors.black38,blurRadius:3)]),child: Icon(Icons.star,size:18,color:Color(0xFFFFC107))),
      ),
    );
  }

  @override Widget build(BuildContext context){
    List<Color> cols=[Color(0xFFE53935),Color(0xFFFBC02D),Color(0xFF43A047),Color(0xFF1E88E5)];
    return Scaffold(
      backgroundColor: Color(0xFF0A1931),
      body: SafeArea(child: Column(children: [
        Padding(padding: EdgeInsets.symmetric(horizontal:12,vertical:8),child: Row(children: [Icon(Icons.arrow_back,color:Colors.white),SizedBox(width:10),Text("Ludo Room - 10356",style: TextStyle(color:Colors.white,fontWeight:FontWeight.bold)),Spacer(),Icon(Icons.pause,color:Colors.white),SizedBox(width:12),Icon(Icons.volume_up,color:Colors.white)])),
        Container(margin: EdgeInsets.all(10),padding: EdgeInsets.symmetric(vertical:12,horizontal:6),decoration: BoxDecoration(color:Color(0xFF1E2E6B),borderRadius:BorderRadius.circular(18)),child: Row(mainAxisAlignment:MainAxisAlignment.spaceAround,children: List.generate(4,(i)=> Column(children: [Container(padding: EdgeInsets.all(3),decoration: BoxDecoration(border: Border.all(color:cols[i],width: turn==i?4:2),borderRadius:BorderRadius.circular(30)),child: CircleAvatar(radius:26,backgroundColor:Color(0xFF1A2A5A),child: Icon(Icons.person,color:Colors.white,size:30))),SizedBox(height:4),Text(["You | Red","Sara | Yellow","Leo | Green","Mia | Blue"][i],style: TextStyle(color:cols[i],fontSize:11,fontWeight:FontWeight.bold))])))),
        Expanded(child: Center(child: Container(width:360,height:360,padding: EdgeInsets.all(7),decoration: BoxDecoration(color:Color(0xFFE5C06A),borderRadius:BorderRadius.circular(14)),child: Container(decoration: BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(6)),child: Column(children: [
          Expanded(flex:6,child: Row(children: [
            Expanded(flex:6,child: Container(color:Color(0xFFE53935),child: Center(child: Column(mainAxisSize:MainAxisSize.min,children: [Row(mainAxisSize:MainAxisSize.min,children:[starToken(cols[0],0,0),SizedBox(width:12),starToken(cols[0],0,1)]),SizedBox(height:12),Row(mainAxisSize:MainAxisSize.min,children:[starToken(cols[0],0,2),SizedBox(width:12),starToken(cols[0],0,3)])])))),
            Expanded(flex:3,child: Container(color:Colors.white,child: Column(children: [Expanded(child: Container(child: Center(child: Icon(Icons.star,color:Colors.orange,size:22)))),Expanded(child: Container(color:Color(0xFFFFC107))),Expanded(child: Container()),Expanded(child: Container()),Expanded(child: Container())]))),
            Expanded(flex:6,child: Container(color:Color(0xFF43A047),child: Center(child: Column(mainAxisSize:MainAxisSize.min,children: [Row(mainAxisSize:MainAxisSize.min,children:[starToken(cols[2],2,0),SizedBox(width:12),starToken(cols[2],2,1)]),SizedBox(height:12),Row(mainAxisSize:MainAxisSize.min,children:[starToken(cols[2],2,2),SizedBox(width:12),starToken(cols[2],2,3)])])))),
          ])),
          Expanded(flex:3,child: Row(children: [
            Expanded(flex:6,child: Container(color:Colors.white)),
            Expanded(flex:3,child: Container(color:Color(0xFFFFC107),child: Center(child: Container(width:84,height:28,decoration: BoxDecoration(color:Color(0xFFFFC107),borderRadius:BorderRadius.circular(4)),child: Icon(Icons.emoji_events,size:20,color:Color(0xFF6D4C00)))))),
            Expanded(flex:6,child: Container(color:Colors.white)),
          ])),
          Expanded(flex:6,child: Row(children: [
            Expanded(flex:6,child: Container(color:Color(0xFFFBC02D),child: Center(child: Column(mainAxisSize:MainAxisSize.min,children: [Row(mainAxisSize:MainAxisSize.min,children:[starToken(cols[1],1,0),SizedBox(width:12),starToken(cols[1],1,1)]),SizedBox(height:12),Row(mainAxisSize:MainAxisSize.min,children:[starToken(cols[1],1,2),SizedBox(width:12),starToken(cols[1],1,3)])])))),
            Expanded(flex:3,child: Container(color:Colors.white)),
            Expanded(flex:6,child: Container(color:Color(0xFF1E88E5),child: Center(child: Column(mainAxisSize:MainAxisSize.min,children: [Row(mainAxisSize:MainAxisSize.min,children:[starToken(cols[3],3,0),SizedBox(width:12),starToken(cols[3],3,1)]),SizedBox(height:12),Row(mainAxisSize:MainAxisSize.min,children:[starToken(cols[3],3,2),SizedBox(width:12),starToken(cols[3],3,3)])])))),
          ])),
        ])))))),
        Container(margin: EdgeInsets.all(12),padding: EdgeInsets.all(12),decoration: BoxDecoration(color:Color(0xFF101E3C),borderRadius:BorderRadius.circular(18)),child: Row(children: [
          Container(width:56,height:56,decoration: BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(12)),child: Center(child: Text("$dice",style: TextStyle(fontSize:30,fontWeight:FontWeight.bold)))),
          SizedBox(width:12),
          Expanded(child: GestureDetector(onTap: roll,child: Container(height:56,decoration: BoxDecoration(color:Color(0xFF2EC4B6),borderRadius:BorderRadius.circular(28)),child: Center(child: Text(canRoll?"ROLL - دور اللاعب ${turn+1}":"دوس على قطعة",style: TextStyle(color:Color(0xFF5D2DE6),fontWeight:FontWeight.bold,fontSize:16)))))),
        ])),
      ]))),
    );
  }
}
