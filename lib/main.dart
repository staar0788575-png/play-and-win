import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MaterialApp(home: ExactLudo(), debugShowCheckedModeBanner: false));
}

class ExactLudo extends StatefulWidget {
  @override
  _ExactLudoState createState() => _ExactLudoState();
}

class _ExactLudoState extends State<ExactLudo> {
  int dice = 5;
  int turn = 0;
  bool canRoll = true;

  void roll() {
    if (!canRoll) return;
    setState(() {
      dice = Random().nextInt(6) + 1;
      canRoll = false;
    });
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        turn = (turn + 1) % 4;
        canRoll = true;
      });
    });
  }

  Widget avatar(Color border, String name, String colorName, IconData icon) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 72, height: 88,
              decoration: BoxDecoration(
                color: Color(0xFF1A2A5A),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: border, width: 4),
              ),
              child: Icon(icon, size: 48, color: Colors.white),
            ),
            Positioned(
              bottom: 0, right: 0,
              child: Container(
                width: 28, height: 28,
                decoration: BoxDecoration(color: border, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                child: Icon(Icons.emoji_events, size: 16, color: Colors.white),
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
        Text(name + " | " + colorName, style: TextStyle(color: border, fontWeight: FontWeight.bold, fontSize: 12)),
      ],
    );
  }

  Widget token(Color c) {
    return Container(
      width: 42, height: 42,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: c,
        border: Border.all(color: Colors.black26, width: 2),
        boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 3, offset: Offset(0,2))],
      ),
      child: Center(child: Icon(Icons.star, color: Color(0xFFFFB300), size: 20)),
    );
  }

  Widget starCell() {
    return Center(child: Icon(Icons.star, color: Color(0xFFFF8F00), size: 22));
  }

  Widget sparkle() {
    return Center(child: Icon(Icons.auto_awesome, color: Colors.white, size: 18));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF0A1931), Color(0xFF1A0A4A)]),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top Bar
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Row(
                  children: [
                    Icon(Icons.arrow_back, color: Colors.white, size: 28),
                    SizedBox(width: 10),
                    Text("Ludo Room • 10356", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    Spacer(),
                    Icon(Icons.pause, color: Colors.white, size: 28),
                    SizedBox(width: 12),
                    Icon(Icons.volume_up, color: Colors.white, size: 28),
                  ],
                ),
              ),
              // Avatars Bar
              Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                decoration: BoxDecoration(color: Color(0xFF1E2E6B), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white24)),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                  avatar(Color(0xFFE53935), "You", "Red", Icons.person),
                  avatar(Color(0xFFFBC02D), "Sara", "Yellow", Icons.person_outline),
                  avatar(Color(0xFF43A047), "Leo", "Green", Icons.person),
                  avatar(Color(0xFF42A5F5), "Mia", "Blue", Icons.person_outline),
                ]),
              ),
              SizedBox(height: 10),
              // Board
              Expanded(
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 12),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(0xFFE5C06A),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Color(0xFFFFD54F), width: 2),
                        boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 10)],
                      ),
                      child: Container(
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
                        child: Column(
                          children: [
                            // Row 0-5 Top part
                            Expanded(flex: 6, child: Row(children: [
                              // Red Home
                              Expanded(flex: 6, child: Container(color: Color(0xFFE53935), child: Container(margin: EdgeInsets.all(10), decoration: BoxDecoration(color: Color(0xFFC62828), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.black26)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Row(mainAxisAlignment: MainAxisAlignment.center, children: [token(Color(0xFFE53935)), SizedBox(width:12), token(Color(0xFFE53935))]), SizedBox(height:12), Row(mainAxisAlignment: MainAxisAlignment.center, children: [token(Color(0xFFE53935)), SizedBox(width:12), token(Color(0xFFE53935))])])))),
                              // Middle Top Path
                              Expanded(flex: 3, child: Column(children: [
                                Expanded(child: Row(children: [Expanded(child: Container(color: Colors.white, child: null)), Expanded(child: Container(color: Colors.white, child: starCell())), Expanded(child: Container(color: Colors.white)) ])),
                                Expanded(child: Row(children: [Expanded(child: Container(color: Colors.white)), Expanded(child: Container(color: Color(0xFFFFC107))), Expanded(child: Container(color: Colors.white, child: sparkle())) ])),
                                Expanded(child: Row(children: [Expanded(child: Container(color: Colors.white, child: starCell())), Expanded(child: Container(color: Color(0xFFFFC107))), Expanded(child: Container(color: Colors.white)) ])),
                                Expanded(child: Row(children: [Expanded(child: Container(color: Colors.white, child: starCell())), Expanded(child: Container(color: Color(0xFFFFC107))), Expanded(child: Container(color: Colors.white)) ])),
                                Expanded(child: Row(children: [Expanded(child: Container(color: Colors.white)), Expanded(child: Container(color: Color(0xFFFFC107))), Expanded(child: Container(color: Colors.white)) ])),
                                Expanded(child: Row(children: [Expanded(child: Container(color: Colors.white)), Expanded(child: Container(color: Color(0xFFFFC107), child: Center(child: Icon(Icons.auto_awesome, color: Colors.white, size: 16)))), Expanded(child: Container(color: Colors.white)) ])),
                              ])),
                              // Green Home
                              Expanded(flex: 6, child: Container(color: Color(0xFF43A047), child: Container(margin: EdgeInsets.all(10), decoration: BoxDecoration(color: Color(0xFF2E7D32), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.black26)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Row(mainAxisAlignment: MainAxisAlignment.center, children: [token(Color(0xFF43A047)), SizedBox(width:12), token(Color(0xFF43A047))]), SizedBox(height:12), Row(mainAxisAlignment: MainAxisAlignment.center, children: [token(Color(0xFF43A047)), SizedBox(width:12), token(Color(0xFF43A047))])])))),
                            ])),
                            // Middle Row 6-8
                            Expanded(flex: 3, child: Row(children: [
                              // Left path
                              Expanded(flex: 6, child: Column(children: [
                                Expanded(child: Row(children: [Expanded(child: Container(color: Colors.white, child: Center(child: token(Color(0xFFE53935))))), Expanded(child: Container(color: Colors.white, child: sparkle())), Expanded(child: Container(color: Colors.white)), Expanded(child: Container(color: Color(0xFFE53935))), Expanded(child: Container(color: Color(0xFFE53935))), Expanded(child: Container(color: Color(0xFFE53935))) ])),
                                Expanded(child: Row(children: [Expanded(child: Container(color: Colors.white, child: Icon(Icons.play_arrow, color: Colors.red, size: 20))), Expanded(child: Container(color: Color(0xFFE53935))), Expanded(child: Container(color: Color(0xFFE53935))), Expanded(child: Container(color: Color(0xFFE53935))), Expanded(child: Container(color: Color(0xFFE53935))), Expanded(child: Container(color: Color(0xFFE53935))) ])),
                                Expanded(child: Row(children: [Expanded(child: Container(color: Colors.white)), Expanded(child: Container(color: Colors.white, child: starCell())), Expanded(child: Container(color: Colors.white, child: sparkle())), Expanded(child: Container(color: Colors.white)), Expanded(child: Container(color: Colors.white)), Expanded(child: Container(color: Colors.white)) ])),
                              ])),
                              // Center Crown
                              Expanded(flex: 3, child: Container(
                                decoration: BoxDecoration(color: Colors.white),
                                child: Stack(
                                  children: [
                                    Column(children: [
                                      Expanded(child: Row(children: [Expanded(child: Container(color: Color(0xFFE53935))), Expanded(child: Container(color: Color(0xFF43A047)))])),
                                      Expanded(child: Row(children: [Expanded(child: Container(color: Color(0xFFFBC02D))), Expanded(child: Container(color: Color(0xFF1E88E5)))])),
                                    ]),
                                    Center(child: Container(width: 48, height: 48, decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xFFFFC107), border: Border.all(color: Colors.white, width: 2), boxShadow: [BoxShadow(color: Colors.amber, blurRadius: 8)]), child: Icon(Icons.emoji_events, color: Color(0xFF8D6E00), size: 28))),
                                  ],
                                ),
                              )),
                              // Right path
                              Expanded(flex: 6, child: Column(children: [
                                Expanded(child: Row(children: [Expanded(child: Container(color: Colors.white)), Expanded(child: Container(color: Colors.white)), Expanded(child: Container(color: Colors.white)), Expanded(child: Container(color: Colors.white)), Expanded(child: Container(color: Colors.white, child: starCell())), Expanded(child: Container(color: Colors.white)) ])),
                                Expanded(child: Row(children: [Expanded(child: Container(color: Color(0xFF43A047))), Expanded(child: Container(color: Color(0xFF43A047))), Expanded(child: Container(color: Color(0xFF43A047), child: Center(child: token(Color(0xFF43A047))))), Expanded(child: Container(color: Color(0xFF43A047))), Expanded(child: Container(color: Colors.white, child: sparkle())), Expanded(child: Container(color: Colors.white, child: Center(child: Icon(Icons.play_arrow, color: Color(0xFF43A047), size: 20)))) ])),
                                Expanded(child: Row(children: [Expanded(child: Container(color: Colors.white, child: sparkle())), Expanded(child: Container(color: Colors.white, child: sparkle())), Expanded(child: Container(color: Colors.white)), Expanded(child: Container(color: Colors.white)), Expanded(child: Container(color: Colors.white)), Expanded(child: Container(color: Colors.white, child: Center(child: token(Color(0xFF1E88E5))))) ])),
                              ])),
                            ])),
                            // Bottom part 9-14
                            Expanded(flex: 6, child: Row(children: [
                              // Yellow Home
                              Expanded(flex: 6, child: Container(color: Color(0xFFFBC02D), child: Container(margin: EdgeInsets.all(10), decoration: BoxDecoration(color: Color(0xFFF9A825), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.black26)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Row(mainAxisAlignment: MainAxisAlignment.center, children: [token(Color(0xFFFBC02D)), SizedBox(width:12), token(Color(0xFFFBC02D))]), SizedBox(height:12), Row(mainAxisAlignment: MainAxisAlignment.center, children: [token(Color(0xFFFBC02D)), SizedBox(width:12), token(Color(0xFFFBC02D))])])))),
                              // Middle Bottom Path
                              Expanded(flex: 3, child: Column(children: [
                                Expanded(child: Row(children: [Expanded(child: Container(color: Color(0xFFFFC107), child: Center(child: Icon(Icons.auto_awesome, color: Colors.white, size: 16)))), Expanded(child: Container(color: Colors.white, child: sparkle())), Expanded(child: Container(color: Colors.white)) ])),
                                Expanded(child: Row(children: [Expanded(child: Container(color: Color(0xFFFFC107))), Expanded(child: Container(color: Colors.white)), Expanded(child: Container(color: Colors.white, child: starCell())) ])),
                                Expanded(child: Row(children: [Expanded(child: Container(color: Color(0xFFFFC107))), Expanded(child: Container(color: Colors.white)), Expanded(child: Container(color: Colors.white, child: starCell())) ])),
                                Expanded(child: Row(children: [Expanded(child: Container(color: Color(0xFFFFC107))), Expanded(child: Container(color: Colors.white)), Expanded(child: Container(color: Colors.white)) ])),
                                Expanded(child: Row(children: [Expanded(child: Container(color: Color(0xFFFFC107), child: Center(child: token(Color(0xFFFBC02D))))), Expanded(child: Container(color: Color(0xFFFFC107))), Expanded(child: Container(color: Colors.white)) ])),
                                Expanded(child: Row(children: [Expanded(child: Container(color: Colors.white, child: Icon(Icons.play_arrow, color: Color(0xFFFFC107), size: 20))), Expanded(child: Container(color: Colors.white)), Expanded(child: Container(color: Colors.white)) ])),
                              ])),
                              // Blue Home
                              Expanded(flex: 6, child: Container(color: Color(0xFF1E88E5), child: Container(margin: EdgeInsets.all(10), decoration: BoxDecoration(color: Color(0xFF1565C0), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.black26)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Row(mainAxisAlignment: MainAxisAlignment.center, children: [token(Color(0xFF1E88E5)), SizedBox(width:12), token(Color(0xFF1E88E5))]), SizedBox(height:12), Row(mainAxisAlignment: MainAxisAlignment.center, children: [token(Color(0xFF1E88E5)), SizedBox(width:12), token(Color(0xFF1E88E5))])])))),
                            ])),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Bottom Buttons
              Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(color: Color(0xFF0F1E42), borderRadius: BorderRadius.circular(20)),
                child: Row(
                  children: [
                    Container(width: 56, height: 56, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 4)]), child: Center(child: Text("$dice", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)))),
                    SizedBox(width: 8),
                    Container(width: 56, height: 56, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)), child: Center(child: Text("$dice", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)))),
                    SizedBox(width: 10),
                    Expanded(child: GestureDetector(onTap: roll, child: Container(height: 50, decoration: BoxDecoration(color: Color(0xFF2EC4B6), borderRadius: BorderRadius.circular(14)), child: Center(child: Text("ROLL", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)))))),
                    SizedBox(width: 8),
                    Container(height: 50, padding: EdgeInsets.symmetric(horizontal: 16), decoration: BoxDecoration(color: Color(0xFFFFC233), borderRadius: BorderRadius.circular(14)), child: Row(children: [Icon(Icons.shield, color: Colors.black54), SizedBox(width:4), Text("SAFE", style: TextStyle(fontWeight: FontWeight.bold))])),
                    SizedBox(width: 8),
                    Container(height: 50, padding: EdgeInsets.symmetric(horizontal: 16), decoration: BoxDecoration(color: Color(0xFF3A4A7A), borderRadius: BorderRadius.circular(14)), child: Row(children: [Icon(Icons.settings, color: Colors.white), SizedBox(width:4), Text("MENU", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))])),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
