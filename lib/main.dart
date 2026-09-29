import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(MaterialApp(home: LudoComplete(), debugShowCheckedModeBanner: false));

class LudoComplete extends StatefulWidget {
  @override State<LudoComplete> createState() => _LudoCompleteState();
}

class _LudoCompleteState extends State<LudoComplete> {
  int dice = 6;
  int turn = 1;
  bool canRoll = true;
  List<String> chat = ["Sara: يلا دورك 😂", "Leo: هات 6 بقى!", "Mia: 😍😍"];

  void roll() {
    if (!canRoll) return;
    setState(() { dice = Random().nextInt(6)+1; canRoll = false; });
    Future.delayed(Duration(milliseconds: 700), () {
      setState(() { canRoll = true; if (dice!=6) turn = (turn+1)%4; });
    });
  }

  Widget token(Color c, {bool empty=false}) {
    return Container(
      width: 36, height: 36,
      decoration: BoxDecoration(shape: BoxShape.circle, color: empty? Colors.white24 : c, border: Border.all(color: Colors.white, width: 2.5)),
      child: empty? null : Icon(Icons.star, size: 16, color: Color(0xFFFFC107)),
    );
  }

  Widget cell(Color col, {Widget? child}) {
    return Container(
      decoration: BoxDecoration(color: col, border: Border.all(color: Colors.black12, width: 0.3)),
      child: Center(child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color red = Color(0xFFE53935);
    Color yellow = Color(0xFFFFC107);
    Color green = Color(0xFF43A047);
    Color blue = Color(0xFF1E88E5);
    List<Color> cols = [red, yellow, green, blue];
    double boardSize = MediaQuery.of(context).size.width - 20;

    return Scaffold(
      backgroundColor: Color(0xFF0A1931),
      body: SafeArea(
        child: Column(
          children: [
            // هيدر
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(children: [
                Icon(Icons.arrow_back, color: Colors.white),
                SizedBox(width: 10),
                Text("Ludo Room - 10356", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Spacer(),
                Container(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(12)), child: Text("1025 💰", style: TextStyle(color: Colors.white, fontSize: 12))),
                SizedBox(width: 8),
                Icon(Icons.pause, color: Colors.white),
                SizedBox(width: 8),
                Icon(Icons.volume_up, color: Colors.white),
              ]),
            ),
            // اللاعبين
            Container(
              height: 78,
              margin: EdgeInsets.symmetric(horizontal: 10),
              padding: EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(color: Color(0xFF1E2E6B), borderRadius: BorderRadius.circular(16)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(4, (i) => Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(padding: EdgeInsets.all(2), decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: cols[i], width: turn==i? 3.5 : 1.5)), child: CircleAvatar(radius: 22, backgroundColor: cols[i], child: Icon(Icons.person, size: 20, color: Colors.white))),
                  SizedBox(height: 3),
                  Text(["You|Red","Sara|Yellow","Leo|Green","Mia|Blue"][i], style: TextStyle(color: cols[i], fontSize: 10, fontWeight: turn==i? FontWeight.bold : FontWeight.normal)),
                ])),
              ),
            ),
            SizedBox(height: 8),
            // البورد - بيخلص عند نص الشاشة بس
            Container(
              width: boardSize,
              height: boardSize,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(color: Color(0xFFD4A94A), borderRadius: BorderRadius.circular(12)),
              child: Container(
                color: Colors.white,
                child: Column(
                  children: List.generate(15, (r) => Expanded(
                    child: Row(children: List.generate(15, (c) {
                      if (r<6 && c<6) {
                        if ((r==1&&c==1)||(r==1&&c==4)||(r==4&&c==1)||(r==4&&c==4)) return Expanded(child: Container(color: red, child: Center(child: token(red))));
                        return Expanded(child: Container(color: red));
                      }
                      if (r<6 && c>8) {
                        if ((r==1&&c==10)||(r==1&&c==13)||(r==4&&c==10)||(r==4&&c==13)) return Expanded(child: Container(color: green, child: Center(child: token(green))));
                        return Expanded(child: Container(color: green));
                      }
                      if (r>8 && c<6) return Expanded(child: Container(color: yellow, child: Center(child: token(yellow, empty: true))));
                      if (r>8 && c>8) {
                        if ((r==10&&c==10)||(r==10&&c==13)||(r==13&&c==10)||(r==13&&c==13)) return Expanded(child: Container(color: blue, child: Center(child: token(blue))));
                        return Expanded(child: Container(color: blue));
                      }
                      if (r>=6&&r<=8&&c>=6&&c<=8) {
                        if (r==7&&c==7) return Expanded(child: cell(yellow, child: Icon(Icons.emoji_events, size: 14)));
                        return Expanded(child: cell(yellow));
                      }
                      if (r==7&&c>=1&&c<=5) return Expanded(child: cell(red));
                      if (r==7&&c>=9&&c<=13) return Expanded(child: cell(blue));
                      if (c==7&&r>=1&&r<=5) return Expanded(child: cell(green));
                      if (c==7&&r>=9&&r<=13) return Expanded(child: cell(yellow));
                      if ((r==2&&c==6)||(r==6&&c==2)||(r==8&&c==12)||(r==12&&c==8)) return Expanded(child: cell(Colors.white, child: Icon(Icons.star, size: 12, color: Colors.orange)));
                      return Expanded(child: cell(Colors.white));
                    })),
                  )),
                ),
              ),
            ),
            SizedBox(height: 8),
            // مكان الشات
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(color: Color(0xFF162554), borderRadius: BorderRadius.circular(14)),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: chat.map((m) => Padding(
                          padding: EdgeInsets.symmetric(vertical: 2),
                          child: Text(m, style: TextStyle(color: Colors.white70, fontSize: 12)),
                        )).toList(),
                      ),
                    ),
                    // صف الهدايا والمايك والنرد
                    Row(
                      children: [
                        // الهدايا
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          decoration: BoxDecoration(color: Color(0xFF0F1E42), borderRadius: BorderRadius.circular(20)),
                          child: Row(children: [
                            Icon(Icons.card_giftcard, color: Colors.pinkAccent, size: 20),
                            SizedBox(width: 6),
                            Icon(Icons.emoji_events, color: Colors.amber, size: 20),
                            SizedBox(width: 6),
                            Icon(Icons.favorite, color: Colors.redAccent, size: 20),
                            SizedBox(width: 6),
                            Text("🎁", style: TextStyle(fontSize: 16)),
                          ]),
                        ),
                        Spacer(),
                        // المايك
                        Container(
                          width: 42, height: 42,
                          decoration: BoxDecoration(color: Color(0xFF2E3A6B), shape: BoxShape.circle),
                          child: Icon(Icons.mic, color: Colors.white, size: 22),
                        ),
                        SizedBox(width: 8),
                        // النرد
                        GestureDetector(
                          onTap: roll,
                          child: Container(
                            width: 48, height: 48,
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                            child: Center(child: Text("$dice", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold))),
                          ),
                        ),
                        SizedBox(width: 8),
                        // ROLL
                        GestureDetector(
                          onTap: roll,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                            decoration: BoxDecoration(color: Color(0xFF3DD4C0), borderRadius: BorderRadius.circular(24)),
                            child: Text(canRoll? "ROLL" : "انتظر", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A0A4A))),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    // انبوت الشات
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 38,
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(color: Color(0xFF0F1E42), borderRadius: BorderRadius.circular(20)),
                            child: Row(children: [
                              Expanded(child: TextField(decoration: InputDecoration(hintText: "اكتب رسالة...", hintStyle: TextStyle(color: Colors.white38, fontSize: 12), border: InputBorder.none), style: TextStyle(color: Colors.white, fontSize: 12))),
                              Icon(Icons.emoji_emotions_outlined, color: Colors.white38, size: 20),
                            ]),
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(width: 38, height: 38, decoration: BoxDecoration(color: Color(0xFF3DD4C0), shape: BoxShape.circle), child: Icon(Icons.send, size: 18, color: Colors.white)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
