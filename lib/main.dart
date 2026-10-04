import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';
import 'package:flutter/services.dart';

void main()
{
  runApp(
    MaterialApp(
      home: GameHub(),
      debugShowCheckedModeBanner: false
    )
  );
}

class SoundManager
{
  static void dice()
  {
    HapticFeedback.mediumImpact();
    SystemSound.play(SystemSoundType.click);
  }
  static void move()
  {
    HapticFeedback.lightImpact();
  }
  static void capture()
  {
    HapticFeedback.heavyImpact();
    SystemSound.play(SystemSoundType.alert);
  }
  static void win()
  {
    HapticFeedback.vibrate();
  }
  static void carromHit()
  {
    HapticFeedback.selectionClick();
  }
  static void carromPot()
  {
    HapticFeedback.lightImpact();
  }
}

class CarromPiece
{
  Offset pos;
  Color color;
  bool isWhite;
  bool isQueen;
  bool isStriker;
  Offset vel;
  CarromPiece(
    this.pos,
    this.color,
    this.isWhite,
    {this.isQueen=false,this.isStriker=false}
  ) : vel=Offset.zero;
}

class CarromImagePainter extends CustomPainter
{
  @override
  void paint(Canvas canvas,Size size)
  {
    var p=Paint()
     ..color=Color(0xFF8D6E63).withOpacity(0.7)
     ..style=PaintingStyle.stroke
     ..strokeWidth=1.5;
    double inset=size.width*0.14;
    RRect r=RRect.fromRectAndRadius(
      Rect.fromLTWH(inset,inset,size.width-inset*2,size.height-inset*2),
      Radius.circular(32)
    );
    canvas.drawRRect(r,p);
    var yellow=Paint()
     ..color=Color(0xFFFFD54F)
     ..style=PaintingStyle.fill;
    var border=Paint()
     ..color=Color(0xFF8D6E63)
     ..style=PaintingStyle.stroke
     ..strokeWidth=2;
    double rad=size.width*0.05;
    List<Offset> pts=[
      Offset(inset+18,inset+18),
      Offset(size.width-inset-18,inset+18),
      Offset(inset+18,size.height/2-20),
      Offset(size.width-inset-18,size.height/2-20),
      Offset(inset+18,size.height/2+20),
      Offset(size.width-inset-18,size.height/2+20),
      Offset(inset+18,size.height-inset-18),
      Offset(size.width-inset-18,size.height-inset-18)
    ];
    for(var pt in pts)
    {
      canvas.drawCircle(pt,rad,yellow);
      canvas.drawCircle(pt,rad,border);
    }
  }
  @override bool shouldRepaint(covariant CustomPainter old)=>false;
}

class AimPainterPro extends CustomPainter
{
  Offset from;
  Offset to;
  double power;
  AimPainterPro(this.from,this.to,this.power);
  @override
  void paint(Canvas c,Size s)
  {
    var p=Paint()
     ..color=Color(0xE6FFFFFF)
     ..strokeWidth=3
     ..style=PaintingStyle.stroke
     ..strokeCap=StrokeCap.round;
    c.drawLine(from,to,p);
    Offset dir=to-from;
    double len=dir.distance;
    if(len>0)
    {
      Offset n=dir/len;
      c.drawLine(
        to,
        to+n*power*300,
        Paint()
         ..color=Color(0xFFFFFF00)
         ..strokeWidth=4
         ..style=PaintingStyle.stroke
      );
    }
  }
  @override bool shouldRepaint(covariant CustomPainter o)=>true;
}

class GameHub extends StatefulWidget
{
  @override
  State<GameHub> createState()=>_GameHubState();
}

class _GameHubState extends State<GameHub>
{
  int tab=0;

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: tab==0
       ? LudoRoyalFull()
        : tab==1
         ? CarromProLikeImage()
          : SnakeLadderRoyal(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: tab,
        onTap: (i)
        {
          setState(()=>tab=i);
        },
        backgroundColor: Color(0xFF0A1931),
        selectedItemColor: Color(0xFFFFD700),
        unselectedItemColor: Colors.white54,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.workspace_premium),label: "لودو"),
          BottomNavigationBarItem(icon: Icon(Icons.circle),label: "كيرم"),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart),label: "سلم"),
        ],
      ),
    );
  }
}

// ================= LUDO FULL =================
class LudoRoyalFull extends StatefulWidget
{
  @override State<LudoRoyalFull> createState()=>_LudoRoyalFullState();
}

class _LudoRoyalFullState extends State<LudoRoyalFull>
{
  int dice=6;
  int turn=0;
  int winner=-1;
  int countdown=10;

  bool canRoll=true;
  bool gameOver=false;
  bool micOn=true;
  bool privateMode=false;

  String msg="جبت 6";
  String flyingEmoji="";
  String selectedGift="";

  List<List<int>> tokens=[
    [-1,-1,-1,-1],
    [-1,-1,-1,-1],
    [-1,-1,-1,-1],
    [-1,-1,-1,-1]
  ];

  List<int> start=[0,39,13,26];
  List<int> safe=[0,8,13,21,26,34,39,47];

  List<List<int>> homePath=[
    [52,53,54,55,56,57],
    [58,59,60,61,62,63],
    [64,65,66,67,68,69],
    [70,71,72,73,74,75]
  ];

  List<String> publicChat=["P3: عاش 💪","Me: السلام عليكم"];
  List<String> privateChat=["P1 خاص: يلا"];
  List<String> gifts=["❤️","🌹","👑","🚗","🦁","💎"];
  List<String> emojis=["😂","😡","😍","👏","🎉","🔥"];

  TextEditingController chatCtrl=TextEditingController();
  Timer? countdownTimer;

  List<Offset> path=[
    Offset(6,1),Offset(6,2),Offset(6,3),Offset(6,4),Offset(6,5),
    Offset(5,6),Offset(4,6),Offset(3,6),Offset(2,6),Offset(1,6),Offset(0,6),
    Offset(0,7),Offset(0,8),Offset(1,8),Offset(2,8),Offset(3,8),Offset(4,8),Offset(5,8),
    Offset(6,9),Offset(6,10),Offset(6,11),Offset(6,12),Offset(6,13),Offset(6,14),
    Offset(7,14),Offset(8,14),Offset(8,13),Offset(8,12),Offset(8,11),Offset(8,10),Offset(8,9),
    Offset(9,8),Offset(10,8),Offset(11,8),Offset(12,8),Offset(13,8),Offset(14,8),
    Offset(14,7),Offset(14,6),Offset(13,6),Offset(12,6),Offset(11,6),Offset(10,6),Offset(9,6),
    Offset(8,5),Offset(8,4),Offset(8,3),Offset(8,2),Offset(8,1),Offset(8,0),Offset(7,0),Offset(6,0)
  ];

  Map<int,Offset> homeC={
    52:Offset(7,1),53:Offset(7,2),54:Offset(7,3),55:Offset(7,4),56:Offset(7,5),57:Offset(7,6),
    58:Offset(13,7),59:Offset(12,7),60:Offset(11,7),61:Offset(10,7),62:Offset(9,7),63:Offset(8,7),
    64:Offset(1,7),65:Offset(2,7),66:Offset(3,7),67:Offset(4,7),68:Offset(5,7),69:Offset(6,7),
    70:Offset(7,13),71:Offset(7,12),72:Offset(7,11),73:Offset(7,10),74:Offset(7,9),75:Offset(7,8)
  };

  void checkWin()
  {
    for(int p=0;p<4;p++)
    {
      if(tokens[p].every((e)=>e==100))
      {
        setState(()
        {
          gameOver=true;
          winner=p;
          countdown=10;
        });
        SoundManager.win();
        startCountdown();
        break;
      }
    }
  }

  void startCountdown()
  {
    countdownTimer?.cancel();
    countdownTimer=Timer.periodic(Duration(seconds:1),(t)
    {
      if(!mounted) return;
      setState(()=>countdown--);
      if(countdown<=0)
      {
        t.cancel();
        resetGame();
      }
    });
  }

  void resetGame()
  {
    setState(()
    {
      tokens=[
        [-1,-1,-1,-1],
        [-1,-1,-1,-1],
        [-1,-1,-1,-1],
        [-1,-1,-1,-1]
      ];
      turn=0;
      dice=6;
      canRoll=true;
      msg="جيم جديد 👑";
      gameOver=false;
      winner=-1;
      countdown=10;
    });
  }

  void roll()
  {
    if(!canRoll||gameOver) return;
    setState(()
    {
      dice=math.Random().nextInt(6)+1;
      canRoll=false;
      msg="جبت $dice";
    });
    SoundManager.dice();
    bool can=false;
    for(int tt in tokens[turn])
    {
      if(tt==-1&&dice==6) can=true;
      if(tt>=0) can=true;
    }
    if(!can)
    {
      Future.delayed(Duration(milliseconds:800),()
      {
        if(mounted)
        {
          setState(()
          {
            turn=(turn+1)%4;
            canRoll=true;
          });
        }
      });
    }
  }

  void moveToken(int p,int idx)
  {
    if(p!=turn||canRoll||gameOver) return;
    int cur=tokens[p][idx];
    if(cur==-1&&dice!=6) return;
    bool cap=false;
    setState(()
    {
      if(cur==-1)
      {
        tokens[p][idx]=start[p];
      }
      else if(cur>=0&&cur<52)
      {
        int entry=(start[p]+51)%52;
        int next=cur+dice;
        if(cur<=entry&&next>entry)
        {
          int h=next-entry-1;
          if(h<6) tokens[p][idx]=homePath[p][h];
          else if(h==6) tokens[p][idx]=100;
          else tokens[p][idx]=next%52;
        }
        else
        {
          tokens[p][idx]=next%52;
        }
      }
      else if(cur>=52)
      {
        int hi=homePath[p].indexOf(cur);
        if(hi!=-1)
        {
          if(hi+dice<6) tokens[p][idx]=homePath[p][hi+dice];
          else if(hi+dice==6) tokens[p][idx]=100;
        }
      }
      int pos=tokens[p][idx];
      if(pos>=0&&pos<52&&!safe.contains(pos))
      {
        for(int op=0;op<4;op++)
        {
          if(op==p) continue;
          for(int oi=0;oi<4;oi++)
          {
            if(tokens[op][oi]==pos)
            {
              tokens[op][oi]=-1;
              cap=true;
            }
          }
        }
      }
      if(dice!=6) turn=(turn+1)%4;
      canRoll=true;
    });
    if(cap) SoundManager.capture(); else SoundManager.move();
    checkWin();
  }

  void sendChat()
  {
    if(chatCtrl.text.trim().isEmpty) return;
    setState(()
    {
      if(privateMode) privateChat.add("Me خاص: ${chatCtrl.text.trim()}");
      else publicChat.add("Me: ${chatCtrl.text.trim()}");
      chatCtrl.clear();
    });
  }

  void sendEmoji(String e)
  {
    setState(()=>flyingEmoji=e);
    Future.delayed(Duration(seconds:2),()
    {
      if(mounted) setState(()=>flyingEmoji="");
    });
  }

  void sendGift(String g)
  {
    setState(()=>selectedGift=g);
    SoundManager.win();
    Future.delayed(Duration(seconds:2),()
    {
      if(mounted) setState(()=>selectedGift="");
    });
  }

  @override void dispose()
  {
    countdownTimer?.cancel();
    chatCtrl.dispose();
    super.dispose();
  }

  @override Widget build(BuildContext context)
  {
    Color red=Color(0xFFE53935);
    Color green=Color(0xFF43A047);
    Color yellow=Color(0xFFFBC02D);
    Color blue=Color(0xFF1E88E5);
    List<Color> cols=[red,yellow,green,blue];
    double boardSize=MediaQuery.of(context).size.width-8;

    return Scaffold(
      backgroundColor: Color(0xFF0D1B4A),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.symmetric(horizontal:14,vertical:10),
              decoration: BoxDecoration(color: Color(0xFF2A3A8C),borderRadius: BorderRadius.circular(16)),
              child: Row(
                children: [
                  Icon(Icons.visibility,color: Colors.amber,size:18),
                  SizedBox(width:8),
                  Text("غرفة انتظار الأصدقاء - لودو 👀",style: TextStyle(color: Colors.white,fontSize:12,fontWeight: FontWeight.bold)),
                  Spacer(),
                  GestureDetector(onTap:(){setState(()=>micOn=!micOn);},child: Icon(micOn?Icons.mic:Icons.mic_off,color: micOn?Colors.greenAccent:Colors.redAccent)),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Container(
                  width: boardSize,
                  height: boardSize,
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(border: Border.all(color: Color(0xFFFFD700),width:5),color: Color(0xFF3E2723),borderRadius: BorderRadius.circular(8)),
                  child: LayoutBuilder(
                    builder: (c,cons)
                    {
                      double s=cons.maxWidth;
                      double ce=s/15;
                      List<Widget> tW=[];
                      for(int p=0;p<4;p++)
                      {
                        for(int t=0;t<4;t++)
                        {
                          int bp=tokens[p][t];
                          double cx,cy,sz=ce*0.78;
                          if(bp==-1)
                          {
                            cx=(t%2==0?1.5:3.5)*ce;
                            cy=(t<2?1.5:3.5)*ce;
                            if(p==1) cy=(t<2?10.5:12.5)*ce;
                            if(p==2) cx=(t%2==0?10.5:12.5)*ce;
                            if(p==3){cx=(t%2==0?10.5:12.5)*ce; cy=(t<2?10.5:12.5)*ce;}
                          }
                          else if(bp>=100){cx=7.5*ce; cy=7.5*ce;}
                          else if(homeC.containsKey(bp)){var pt=homeC[bp]!; cx=pt.dy*ce+ce/2; cy=pt.dx*ce+ce/2;}
                          else{var pt=path[bp%52]; cx=pt.dy*ce+ce/2; cy=pt.dx*ce+ce/2;}
                          tW.add(Positioned(left:cx-sz/2,top:cy-sz/2,child: GestureDetector(onTap:()=>moveToken(p,t),child: Container(width:sz,height:sz,decoration: BoxDecoration(shape: BoxShape.circle,color: cols[p],border: Border.all(color: Colors.white,width:2)),child: Center(child: Text("♔",style: TextStyle(color: Colors.white,fontSize:sz*0.6)))))));
                        }
                      }
                      return Stack(
                        children: [
                          GridView.count(
                            crossAxisCount:15,
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            children: List.generate(225,(i)
                            {
                              int r=i~/15;
                              int co=i%15;
                              Color bg=Color(0xFFFFF8E1);
                              if(r<6&&co<6) bg=red;
                              else if(r<6&&co>8) bg=green;
                              else if(r>8&&co<6) bg=yellow;
                              else if(r>8&&co>8) bg=blue;
                              else if(r==7&&co>=1&&co<=5) bg=red.withOpacity(0.85);
                              else if(r==7&&co>=9&&co<=13) bg=green.withOpacity(0.65);
                              else if(co==7&&r>=1&&r<=5) bg=yellow.withOpacity(0.65);
                              else if(co==7&&r>=9&&r<=13) bg=blue.withOpacity(0.65);
                              else if(r>=6&&r<=8&&co>=6&&co<=8) bg=Color(0xFFFFD54F);
                              Widget? ch;
                              int pIdx=path.indexWhere((e)=>e.dx==r&&e.dy==co);
                              if(safe.contains(pIdx)) ch=Text("★",style: TextStyle(fontSize:ce*0.50));
                              return Container(decoration: BoxDecoration(color:bg,border: Border.all(color: Colors.black12,width:0.3)),child: Center(child:ch));
                            })
                          ),
                          for(var w in tW) w,
                          if(flyingEmoji.isNotEmpty) Center(child: Text(flyingEmoji,style: TextStyle(fontSize:60))),
                          if(selectedGift.isNotEmpty) Center(child: Container(padding: EdgeInsets.all(12),decoration: BoxDecoration(color: Color(0xCC000000),borderRadius: BorderRadius.circular(16)),child: Text(selectedGift,style: TextStyle(fontSize:40)))),
                          if(canRoll&&!gameOver) Center(child: GestureDetector(onTap:roll,child: Container(width:106,height:106,decoration: BoxDecoration(shape: BoxShape.circle,gradient: RadialGradient(colors:[Color(0xFFFFD700),Color(0xFFFF6F00)]),border: Border.all(color: Colors.white,width:3)),child: Column(mainAxisAlignment: MainAxisAlignment.center,children:[Text("$dice",style: TextStyle(fontSize:38,fontWeight: FontWeight.bold)),Text("ROLL",style: TextStyle(fontWeight: FontWeight.bold))])))),
                          if(gameOver) Container(color: Color(0x99000000),child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,children:[Icon(Icons.emoji_events,color: Color(0xFFFFD700),size:70),Text("اللاعب ${winner+1} فاز 👑",style: TextStyle(color: Colors.white,fontSize:22,fontWeight: FontWeight.bold)),SizedBox(height:20),Stack(alignment: Alignment.center,children:[SizedBox(width:90,height:90,child: CircularProgressIndicator(value:countdown/10,strokeWidth:8,color: Color(0xFFFFD700))),Text("$countdown",style: TextStyle(color: Colors.white,fontSize:36,fontWeight: FontWeight.bold))])])))
                        ]
                      );
                    }
                  )
                )
              )
            ),
            Container(height:60,margin: EdgeInsets.all(8),padding: EdgeInsets.all(8),decoration: BoxDecoration(color: Color(0xFF1A2A6A),borderRadius: BorderRadius.circular(12)),child: ListView.builder(scrollDirection: Axis.horizontal,itemCount: publicChat.length,itemBuilder: (c,i)=>Container(margin: EdgeInsets.only(right:6),padding: EdgeInsets.symmetric(horizontal:10,vertical:4),decoration: BoxDecoration(color: Color(0xFF2A3A8C),borderRadius: BorderRadius.circular(10)),child: Text(publicChat[i],style: TextStyle(color: Colors.white,fontSize:12)))))
          ]
        )
      )
    );
  }
}

// ================= CARROM FULL =================
class CarromProLikeImage extends StatefulWidget
{
  @override State<CarromProLikeImage> createState()=>_CarromProState();
}

class _CarromProState extends State<CarromProLikeImage>
{
  List<CarromPiece> pieces=[];
  CarromPiece striker=CarromPiece(Offset(0.5,0.82),Color(0xFFFF1744),false,isStriker:true);
  Offset? dragStart;
  Offset? dragEnd;
  double power=0;
  Timer? timer;
  bool gameOver=false;
  int countdown=10;
  Timer? countdownTimer;

  @override void initState()
  {
    super.initState();
    resetCarrom();
    timer=Timer.periodic(Duration(milliseconds:16),(t)=>updatePhysics());
  }

  void resetCarrom()
  {
    pieces=[
      CarromPiece(Offset(0.5,0.5),Color(0xFF000000),false,isQueen:true),
      CarromPiece(Offset(0.5,0.40),Color(0xFFFFFDE7),true),
      CarromPiece(Offset(0.43,0.43),Color(0xFFFFF8E1),true),
      CarromPiece(Offset(0.57,0.43),Color(0xFFFFFDE7),true),
      CarromPiece(Offset(0.38,0.50),Color(0xFFFFF8E1),true),
      CarromPiece(Offset(0.62,0.50),Color(0xFFFFFDE7),true),
      CarromPiece(Offset(0.43,0.57),Color(0xFFFFF8E1),true),
      CarromPiece(Offset(0.57,0.57),Color(0xFFFFFDE7),true),
      CarromPiece(Offset(0.5,0.60),Color(0xFF3E2723),false),
      CarromPiece(Offset(0.38,0.43),Color(0xFF212121),false),
      CarromPiece(Offset(0.62,0.43),Color(0xFF3E2723),false),
      CarromPiece(Offset(0.33,0.50),Color(0xFF121212),false),
      CarromPiece(Offset(0.67,0.50),Color(0xFF3E2723),false),
      CarromPiece(Offset(0.38,0.57),Color(0xFF121212),false),
      CarromPiece(Offset(0.62,0.57),Color(0xFF000000),false)
    ];
    striker=CarromPiece(Offset(0.5,0.82),Color(0xFFFF1744),false,isStriker:true);
    gameOver=false;
    countdown=10;
  }

  void checkCarromWin()
  {
    if(pieces.isEmpty&&!gameOver)
    {
      setState(()=>gameOver=true);
      SoundManager.win();
      startCountdown();
    }
  }

  void startCountdown()
  {
    countdownTimer?.cancel();
    countdown=10;
    countdownTimer=Timer.periodic(Duration(seconds:1),(t)
    {
      if(!mounted) return;
      setState(()=>countdown--);
      if(countdown<=0)
      {
        t.cancel();
        setState(()=>resetCarrom());
      }
    });
  }

  void updatePhysics()
  {
    if(!mounted||gameOver) return;
    setState(()
    {
      int before=pieces.length;
      List<CarromPiece> all=[...pieces,striker];
      for(var p in all)
      {
        if(p.vel==Offset.zero) continue;
        p.pos+=p.vel*0.016;
        p.vel*=0.985;
        if(p.vel.distance<0.002) p.vel=Offset.zero;
        if(p.pos.dx<0.07||p.pos.dx>0.93)
        {
          p.vel=Offset(-p.vel.dx*0.85,p.vel.dy);
          p.pos=Offset(p.pos.dx.clamp(0.07,0.93),p.pos.dy);
        }
        if(p.pos.dy<0.07||p.pos.dy>0.93)
        {
          p.vel=Offset(p.vel.dx,-p.vel.dy*0.85);
          p.pos=Offset(p.pos.dx,p.pos.dy.clamp(0.07,0.93));
        }
      }
      for(int i=0;i<pieces.length;i++)
      {
        for(int j=i+1;j<pieces.length;j++)
        {
          Offset d=pieces[i].pos-pieces[j].pos;
          double dist=d.distance;
          if(dist<0.064&&dist>0.001)
          {
            Offset n=d/dist;
            double dv=(pieces[i].vel.dx*n.dx+pieces[i].vel.dy*n.dy)-(pieces[j].vel.dx*n.dx+pieces[j].vel.dy*n.dy);
            if(dv<0)
            {
              pieces[i].vel-=n*dv*0.95;
              pieces[j].vel+=n*dv*0.95;
            }
          }
        }
        Offset ds=pieces[i].pos-striker.pos;
        double dist=ds.distance;
        if(dist<0.08&&dist>0.001)
        {
          Offset n=ds/dist;
          double dv=(pieces[i].vel.dx*n.dx+pieces[i].vel.dy*n.dy)-(striker.vel.dx*n.dx+striker.vel.dy*n.dy);
          if(dv<0)
          {
            pieces[i].vel-=n*dv*1.1;
            striker.vel+=n*dv*1.1;
          }
        }
      }
      pieces.removeWhere((p)=>(p.pos-Offset(0.08,0.08)).distance<0.06||(p.pos-Offset(0.92,0.08)).distance<0.06||(p.pos-Offset(0.08,0.92)).distance<0.06||(p.pos-Offset(0.92,0.92)).distance<0.06);
      if(pieces.length<before) SoundManager.carromPot();
    });
    checkCarromWin();
  }

  @override void dispose()
  {
    timer?.cancel();
    countdownTimer?.cancel();
    super.dispose();
  }

  @override Widget build(BuildContext context)
  {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter,end: Alignment.bottomCenter,colors:[Color(0xFF3A1A7A),Color(0xFF8B2E6E),Color(0xFF1A0A2E)])),
        child: SafeArea(
          child: Column(
            children: [
              Container(margin: EdgeInsets.all(8),padding: EdgeInsets.symmetric(horizontal:14,vertical:10),decoration: BoxDecoration(color: Color(0xFF2A3A8C),borderRadius: BorderRadius.circular(16)),child: Row(children:[Icon(Icons.visibility,color: Colors.amber,size:18),SizedBox(width:8),Text("غرفة انتظار الأصدقاء - كيرم 4 لاعبين 👀",style: TextStyle(color: Colors.white,fontSize:12,fontWeight: FontWeight.bold)),Spacer(),Icon(Icons.mic,color: Colors.greenAccent)])),
              Expanded(
                child: Center(
                  child: LayoutBuilder(
                    builder: (ctx,cons)
                    {
                      double size=math.min(cons.maxWidth-12,cons.maxHeight*0.75);
                      return GestureDetector(
                        onPanStart: (d){dragStart=Offset(d.localPosition.dx/size,d.localPosition.dy/size);},
                        onPanUpdate: (d){dragEnd=Offset(d.localPosition.dx/size,d.localPosition.dy/size); if(dragStart!=null&&dragEnd!=null){power=(dragEnd!-dragStart!).distance.clamp(0,0.35);} setState((){});},
                        onPanEnd: (_)
                        {
                          if(dragStart!=null&&dragEnd!=null&&!gameOver)
                          {
                            Offset dir=dragEnd!-dragStart!;
                            double pwr=dir.distance*20;
                            if(pwr>0.5){Offset norm=dir.distance==0?Offset.zero:dir/dir.distance; striker.vel=norm*pwr.clamp(0,10); SoundManager.carromHit();}
                          }
                          dragStart=null;
                          dragEnd=null;
                          power=0;
                          setState((){});
                        },
                        child: Container(
                          width: size,
                          height: size,
                          decoration: BoxDecoration(color: Color(0xFFDEB887),borderRadius: BorderRadius.circular(22),border: Border.all(color: Color(0xFFFFD700),width:4)),
                          child: Stack(
                            children: [
                              Positioned(left:6,top:6,child: Container(width:size*0.11,height:size*0.11,decoration: BoxDecoration(color: Color(0xFF1A0A0A),shape: BoxShape.circle,border: Border.all(color: Color(0xFFFFD700),width:3)))),
                              Positioned(right:6,top:6,child: Container(width:size*0.11,height:size*0.11,decoration: BoxDecoration(color: Color(0xFF1A0A0A),shape: BoxShape.circle,border: Border.all(color: Color(0xFFFFD700),width:3)))),
                              Positioned(left:6,bottom:6,child: Container(width:size*0.11,height:size*0.11,decoration: BoxDecoration(color: Color(0xFF1A0A0A),shape: BoxShape.circle,border: Border.all(color: Color(0xFFFFD700),width:3)))),
                              Positioned(right:6,bottom:6,child: Container(width:size*0.11,height:size*0.11,decoration: BoxDecoration(color: Color(0xFF1A0A0A),shape: BoxShape.circle,border: Border.all(color: Color(0xFFFFD700),width:3)))),
                              CustomPaint(size: Size(size,size),painter: CarromImagePainter()),
                              for(var pc in pieces) Positioned(left:pc.pos.dx*size-16,top:pc.pos.dy*size-16,child: Container(width:32,height:32,decoration: BoxDecoration(shape: BoxShape.circle,border: Border.all(color: Colors.white,width: pc.isQueen?2.5:1.5),gradient: pc.isQueen?RadialGradient(colors:[Color(0xFF424242),Colors.black]):pc.isWhite?RadialGradient(colors:[Colors.white,Color(0xFFFFE082)]):RadialGradient(colors:[Color(0xFF5D4037),Colors.black])),child: pc.isQueen?Center(child: Text("★",style: TextStyle(color: Colors.yellow,fontSize:12))):null)),
                              Positioned(left:striker.pos.dx*size-22,top:striker.pos.dy*size-22,child: Container(width:44,height:44,decoration: BoxDecoration(shape: BoxShape.circle,gradient: RadialGradient(colors:[Color(0xFFFF4081),Color(0xFF880E4F)]),border: Border.all(color: Colors.white,width:3)),child: Center(child: Container(width:16,height:16,decoration: BoxDecoration(color: Colors.white,shape: BoxShape.circle))))),
                              if(dragStart!=null&&dragEnd!=null) CustomPaint(size: Size(size,size),painter: AimPainterPro(dragStart!*size,dragEnd!*size,power)),
                              if(gameOver) Container(width:size,height:size,decoration: BoxDecoration(color: Color(0xCC000000),borderRadius: BorderRadius.circular(18)),child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,children:[Icon(Icons.emoji_events,color: Color(0xFFFFD700),size:60),Text("انتهى الجيم 🎉",style: TextStyle(color: Colors.white,fontSize:20,fontWeight: FontWeight.bold)),SizedBox(height:16),Stack(alignment: Alignment.center,children:[SizedBox(width:80,height:80,child: CircularProgressIndicator(value:countdown/10,strokeWidth:7,color: Color(0xFFFFD700))),Text("$countdown",style: TextStyle(color: Colors.white,fontSize:32,fontWeight: FontWeight.bold))])])))
                            ]
                          )
                        )
                      );
                    }
                  )
                )
              ),
            ]
          )
        )
      )
    );
  }
}

// ================= سلم وثعبان FULL =================
class SnakeLadderRoyal extends StatefulWidget
{
  @override State<SnakeLadderRoyal> createState()=>_SnakeLadderState();
}

class _SnakeLadderState extends State<SnakeLadderRoyal>
{
  int dice=1;
  int turn=0;
  int winner=-1;
  int countdown=10;

  bool canRoll=true;
  bool gameOver=false;
  bool micOn=true;
  bool privateMode=false;

  List<int> pos=[0,0,0,0];

  Map<int,int> snakes={
    99:54,
    70:55,
    52:42,
    56:8,
    43:17,
    50:5,
    27:5
  };

  Map<int,int> ladders={
    3:51,
    6:27,
    20:70,
    36:55,
    63:95,
    68:98
  };

  Timer? countdownTimer;
  TextEditingController chatCtrl=TextEditingController();

  List<String> publicChat=["P2: يلا 😂","Me: هات سلم"];
  List<String> privateChat=["P1 خاص: لا تديها لحد"];
  String flyingEmoji="";
  String selectedGift="";
  List<String> gifts=["❤️","🌹","👑","🚗","🦁","💎"];
  List<String> emojis=["😂","😡","😍","👏","🎉","🔥"];

  void roll()
  {
    if(!canRoll||gameOver) return;
    setState(()
    {
      dice=math.Random().nextInt(6)+1;
      canRoll=false;
    });
    SoundManager.dice();
    Future.delayed(Duration(milliseconds:600),()
    {
      movePlayer();
    });
  }

  void movePlayer()
  {
    setState(()
    {
      int cur=pos[turn];
      int next=cur+dice;
      if(next>100)
      {
        canRoll=true;
        turn=(turn+1)%4;
        return;
      }
      if(next==100)
      {
        pos[turn]=100;
        gameOver=true;
        winner=turn;
        countdown=10;
        SoundManager.win();
        startCountdown();
        return;
      }
      pos[turn]=next;
      if(snakes.containsKey(next))
      {
        pos[turn]=snakes[next]!;
        SoundManager.capture();
      }
      else if(ladders.containsKey(next))
      {
        pos[turn]=ladders[next]!;
        SoundManager.move();
      }
      else
      {
        SoundManager.move();
      }
      if(dice!=6) turn=(turn+1)%4;
      canRoll=true;
    });
  }

  void startCountdown()
  {
    countdownTimer?.cancel();
    countdownTimer=Timer.periodic(Duration(seconds:1),(t)
    {
      if(!mounted) return;
      setState(()=>countdown--);
      if(countdown<=0)
      {
        t.cancel();
        resetGame();
      }
    });
  }

  void resetGame()
  {
    setState(()
    {
      pos=[0,0,0,0];
      turn=0;
      dice=1;
      canRoll=true;
      gameOver=false;
      winner=-1;
      countdown=10;
    });
  }

  void sendChat()
  {
    if(chatCtrl.text.isEmpty) return;
    setState(()
    {
      if(privateMode) privateChat.add("Me خاص: ${chatCtrl.text}");
      else publicChat.add("Me: ${chatCtrl.text}");
      chatCtrl.clear();
    });
  }

  void sendEmoji(String e)
  {
    setState(()=>flyingEmoji=e);
    Future.delayed(Duration(seconds:2),(){if(mounted) setState(()=>flyingEmoji="");});
  }

  void sendGift(String g)
  {
    setState(()=>selectedGift=g);
    SoundManager.win();
    Future.delayed(Duration(seconds:2),(){if(mounted) setState(()=>selectedGift="");});
  }

  Widget buildCell(int num)
  {
    bool isSnake=snakes.containsKey(num);
    bool isLadder=ladders.containsKey(num);
    Color bg=Color(0xFFFFF8E1);
    if(num%2==0) bg=Color(0xFFE8F5E9);
    if(isSnake) bg=Color(0xFFFFCDD2);
    if(isLadder) bg=Color(0xFFC8E6C9);
    List<int> playersHere=[];
    for(int i=0;i<4;i++){if(pos[i]==num) playersHere.add(i);}
    return Container(
      decoration: BoxDecoration(color:bg,border: Border.all(color: Colors.black12,width:0.4)),
      child: Stack(
        children: [
          Positioned(top:2,left:4,child: Text("$num",style: TextStyle(fontSize:9,fontWeight: FontWeight.bold,color: Colors.black54))),
          if(isSnake) Center(child: Text("🐍",style: TextStyle(fontSize:18))),
          if(isLadder) Center(child: Text("🪜",style: TextStyle(fontSize:18))),
          if(playersHere.isNotEmpty) Positioned(bottom:2,right:2,child: Row(children: playersHere.map((p){List<Color> c=[Color(0xFFE53935),Color(0xFFFBC02D),Color(0xFF43A047),Color(0xFF1E88E5)]; return Container(width:14,height:14,margin: EdgeInsets.only(left:1),decoration: BoxDecoration(shape: BoxShape.circle,color:c[p],border: Border.all(color: Colors.white,width:1)),child: Center(child: Text("${p+1}",style: TextStyle(fontSize:8,color: Colors.white))));}).toList()))
        ]
      )
    );
  }

  @override void dispose()
  {
    countdownTimer?.cancel();
    chatCtrl.dispose();
    super.dispose();
  }

  @override Widget build(BuildContext context)
  {
    double size=MediaQuery.of(context).size.width-12;
    List<Color> cols=[Color(0xFFE53935),Color(0xFFFBC02D),Color(0xFF43A047),Color(0xFF1E88E5)];

    return Scaffold(
      backgroundColor: Color(0xFF0D1B4A),
      body: SafeArea(
        child: Column(
          children: [
            Container(margin: EdgeInsets.all(8),padding: EdgeInsets.symmetric(horizontal:14,vertical:10),decoration: BoxDecoration(color: Color(0xFF2A3A8C),borderRadius: BorderRadius.circular(16)),child: Row(children:[Icon(Icons.visibility,color: Colors.amber,size:18),SizedBox(width:8),Text("غرفة انتظار الأصدقاء - سلم وثعبان 👀",style: TextStyle(color: Colors.white,fontSize:12,fontWeight: FontWeight.bold)),Spacer(),GestureDetector(onTap:(){setState(()=>micOn=!micOn);},child: Icon(micOn?Icons.mic:Icons.mic_off,color: micOn?Colors.greenAccent:Colors.redAccent))])),
            Container(padding: EdgeInsets.symmetric(horizontal:12,vertical:6),child: Row(children:[for(int i=0;i<4;i++) Expanded(child: Container(margin: EdgeInsets.symmetric(horizontal:3),padding: EdgeInsets.symmetric(vertical:6),decoration: BoxDecoration(color:turn==i?cols[i]:Color(0xFF2A3A8C),borderRadius: BorderRadius.circular(20),border: turn==i?Border.all(color: Colors
