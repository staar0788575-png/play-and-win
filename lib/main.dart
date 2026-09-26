import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'dart:math';
void main()=>runApp(const PlayAndWinApp());
class PlayAndWinApp extends StatelessWidget{const PlayAndWinApp({super.key}); @override Widget build(BuildContext c)=>const MaterialApp(debugShowCheckedModeBanner:false, home:LobbyScreen());}

// ================= اللوبي 313 أمر الأصلي + إضافات =================
class LobbyScreen extends StatefulWidget{const LobbyScreen({super.key}); @override State<LobbyScreen> createState()=>_LobbyState();}
class _LobbyState extends State<LobbyScreen>{
  List<Map<String,String>> requests=[{"n":"أحمد","v":"V5","i":"10"},{"n":"نور","v":"V8","i":"11"},{"n":"سارة","v":"V9","i":"12"}];
  List<String> globalChat=["همام: يلا نلعب؟","سحاب: أنا جاهز","المجروح: دومينو؟","ابن الاكابر: بلياردو؟"];
  TextEditingController chatCtrl=TextEditingController();
  int selectedGame=0;

  List<Map<String,String>> getFullPlayers(List<Map<String,String>> real){
    List<Map<String,String>> all=List.from(real);
    List<Map<String,String>> bots=[{"n":"روبوت 1","v":"BOT","i":"20"},{"n":"روبوت 2","v":"BOT","i":"21"},{"n":"روبوت 3","v":"BOT","i":"22"},{"n":"روبوت 4","v":"BOT","i":"23"}];
    int need=4-all.length;
    for(int i=0;i<need && i<bots.length;i++){ all.add(bots[i]); }
    return all;
  }

  void showPrivate(String name){
    showDialog(context:context, builder:(_)=>AlertDialog(
      backgroundColor:const Color(0xFF1C2A45),
      shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(16)),
      title:Text("شات خاص مع $name 💬", style:const TextStyle(color:Colors.white, fontSize:13, fontWeight:FontWeight.bold)),
      content:Container(height:220, child:Column(children:[
        Expanded(child:Container(padding:const EdgeInsets.all(8), decoration:BoxDecoration(color:Colors.black26, borderRadius:BorderRadius.circular(12)), child:const Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
          Text("همام: هلا والله", style:TextStyle(color:Colors.white70, fontSize:11)),
          SizedBox(height:4),
          Text("أنت: أخبارك؟", style:TextStyle(color:Colors.amber, fontSize:11)),
        ]))),
        const SizedBox(height:8),
        Row(children:[
          Expanded(child:TextField(decoration:InputDecoration(hintText:"قل شيئا خاص لـ $name...", hintStyle:const TextStyle(color:Colors.white30, fontSize:10), filled:true, fillColor:Colors.black26, border:OutlineInputBorder(borderRadius:BorderRadius.circular(20), borderSide:BorderSide.none), contentPadding:const EdgeInsets.symmetric(horizontal:12, vertical:8)), style:const TextStyle(color:Colors.white, fontSize:11))),
          const SizedBox(width:6),
          Container(padding:const EdgeInsets.all(8), decoration:const BoxDecoration(color:Colors.amber, shape:BoxShape.circle), child:const Icon(Icons.send, size:14))
        ])
      ])),
      actions:[TextButton(onPressed:()=>Navigator.pop(context), child:const Text("إغلاق", style:TextStyle(color:Colors.white54)))]
    ));
  }

  void showReq(){
    showModalBottomSheet(context:context, backgroundColor:const Color(0xFF0E172A), shape:const RoundedRectangleBorder(borderRadius:BorderRadius.vertical(top:Radius.circular(24))), builder:(_)=>Padding(padding:const EdgeInsets.all(16), child:Column(mainAxisSize:MainAxisSize.min, children:[
      Row(mainAxisAlignment:MainAxisAlignment.spaceBetween, children:[
        const Text("طلبات الصداقة (3)", style:TextStyle(color:Colors.white, fontWeight:FontWeight.bold, fontSize:14)),
        Container(padding:const EdgeInsets.symmetric(horizontal:8,vertical:4), decoration:BoxDecoration(color:Colors.red, borderRadius:BorderRadius.circular(10)), child:const Text("3 جديد", style:TextStyle(color:Colors.white, fontSize:9)))
      ]),
      const SizedBox(height:12),
     ...requests.map((r)=>Container(margin:const EdgeInsets.only(bottom:10), padding:const EdgeInsets.all(12), decoration:BoxDecoration(color:const Color(0xFF1C2A45), borderRadius:BorderRadius.circular(12), border:Border.all(color:Colors.white10)), child:Row(mainAxisAlignment:MainAxisAlignment.spaceBetween, children:[
        Row(children:[
          CircleAvatar(radius:20, backgroundImage:NetworkImage('https://i.pravatar.cc/100?img=${r["i"]}')),
          const SizedBox(width:8),
          Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
            Text(r["n"]!, style:const TextStyle(color:Colors.white, fontSize:12, fontWeight:FontWeight.bold)),
            Row(children:[
              Container(padding:const EdgeInsets.symmetric(horizontal:4), decoration:BoxDecoration(color:Colors.amber, borderRadius:BorderRadius.circular(4)), child:Text(r["v"]!, style:const TextStyle(fontSize:8, color:Colors.black, fontWeight:FontWeight.bold))),
              const SizedBox(width:4),
              const Text("يريد أن يكون صديقك", style:TextStyle(color:Colors.white54, fontSize:8))
            ])
          ])
        ]),
        Row(children:[
          GestureDetector(onTap:(){ setState(()=> requests.remove(r)); Navigator.pop(context); }, child:Container(padding:const EdgeInsets.symmetric(horizontal:14,vertical:7), decoration:BoxDecoration(gradient:const LinearGradient(colors:[Color(0xFF22C55E), Color(0xFF16A34A)]), borderRadius:BorderRadius.circular(20)), child:const Text("قبول", style:TextStyle(color:Colors.white, fontSize:11, fontWeight:FontWeight.bold)))),
          const SizedBox(width:6),
          Container(padding:const EdgeInsets.symmetric(horizontal:14,vertical:7), decoration:BoxDecoration(color:Colors.white12, borderRadius:BorderRadius.circular(20)), child:const Text("رفض", style:TextStyle(color:Colors.white70, fontSize:11)))
        ])
      ]))),
      const SizedBox(height:10),
    ])));
  }

  @override Widget build(BuildContext context){
    final friends=[{"n":"همام","v":"V6","i":"1"},{"n":"سحاب","v":"V7","i":"2"},{"n":"انا المجروح","v":"V6","i":"3"}];
    final display=getFullPlayers(friends);
    return Scaffold(backgroundColor:const Color(0xFF0A1020), body:SafeArea(child:Column(children:[
      Container(padding:const EdgeInsets.symmetric(horizontal:12, vertical:10), decoration:const BoxDecoration(color:Color(0xFF1A2332), boxShadow:[BoxShadow(color:Colors.black26, blurRadius:4)]), child:Row(mainAxisAlignment:MainAxisAlignment.spaceBetween, children:[
        Row(children:[
          Stack(children:[const CircleAvatar(radius:18, backgroundImage:NetworkImage('https://i.pravatar.cc/100?img=12')), Positioned(bottom:0, right:0, child:Container(width:10, height:10, decoration:BoxDecoration(color:Colors.green, shape:BoxShape.circle, border:Border.all(color:const Color(0xFF1A2332), width:2))))]),
          const SizedBox(width:8),
          Container(padding:const EdgeInsets.symmetric(horizontal:12,vertical:6), decoration:BoxDecoration(color:Colors.black45, borderRadius:BorderRadius.circular(20), border:Border.all(color:Colors.amber.withOpacity(0.3))), child:const Row(children:[Text("🪙", style:TextStyle(fontSize:12)), SizedBox(width:4), Text("1500", style:TextStyle(color:Colors.white, fontWeight:FontWeight.bold, fontSize:12)), SizedBox(width:6), CircleAvatar(radius:9, backgroundColor:Colors.amber, child:Text("+", style:TextStyle(color:Colors.black, fontSize:10, fontWeight:FontWeight.bold))) ])),
          const SizedBox(width:6),
          GestureDetector(onTap:showReq, child:Stack(children:[Container(padding:const EdgeInsets.all(8), decoration:BoxDecoration(color:Colors.black26, borderRadius:BorderRadius.circular(20), border:Border.all(color:Colors.white10)), child:const Text("👥", style:TextStyle(fontSize:12))), Positioned(right:0, top:0, child:Container(width:16, height:16, decoration:BoxDecoration(color:Colors.red, shape:BoxShape.circle, border:Border.all(color:const Color(0xFF1A2332), width:1)), child:const Center(child:Text("3", style:TextStyle(fontSize:8, color:Colors.white, fontWeight:FontWeight.bold)))))])),
          const SizedBox(width:6),
          Container(padding:const EdgeInsets.all(8), decoration:BoxDecoration(color:Colors.black26, borderRadius:BorderRadius.circular(20), border:Border.all(color:Colors.white10)), child:const Text("🎁", style:TextStyle(fontSize:12))),
        ]),
        Row(children:[
          Container(padding:const EdgeInsets.all(8), decoration:BoxDecoration(color:Colors.black26, borderRadius:BorderRadius.circular(20)), child:const Text("🔍", style:TextStyle(color:Colors.white, fontSize:12))),
          const SizedBox(width:6),
          Container(padding:const EdgeInsets.symmetric(horizontal:10,vertical:6), decoration:BoxDecoration(gradient:const LinearGradient(colors:[Color(0xFFFFD700), Color(0xFFFFA000)]), borderRadius:BorderRadius.circular(20)), child:const Text("👑 TOP", style:TextStyle(color:Colors.black, fontSize:10, fontWeight:FontWeight.bold)))
        ])
      ])),
      Expanded(child:SingleChildScrollView(child:Column(children:[
        Padding(padding:const EdgeInsets.all(14), child:Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
          Row(mainAxisAlignment:MainAxisAlignment.spaceBetween, children:[
            const Text("ألعاب عادية", style:TextStyle(color:Colors.white, fontWeight:FontWeight.bold, fontSize:18)),
            Container(padding:const EdgeInsets.symmetric(horizontal:14,vertical:7), decoration:BoxDecoration(color:Colors.white10, borderRadius:BorderRadius.circular(20), border:Border.all(color:Colors.white24)), child:const Row(children:[Icon(Icons.add, color:Colors.white, size:12), SizedBox(width:4), Text("غرفة خاصة +", style:TextStyle(color:Colors.white, fontSize:12))]))
          ]),
          const SizedBox(height:6),
          const Text("4 ألعاب - كل لعبة نصف شاشة - شات عام وخاص يعمل في الكل - روبوتات تكمل", style:TextStyle(color:Colors.white38, fontSize:9)),
          const SizedBox(height:12),
          GridView.count(shrinkWrap:true, physics:const NeverScrollableScrollPhysics(), crossAxisCount:2, childAspectRatio:0.85, mainAxisSpacing:16, crossAxisSpacing:14, children:[
            _prettyCard(context,"كيرم / بلياردو",[const Color(0xFFFF9800), const Color(0xFF5D4037)],"🎯", BilliardScreen(chat:globalChat)),
            _prettyCard(context,"دومينو 50",[const Color(0xFF66BB6A), const Color(0xFF1B5E20)],"🀄", DominoScreen(chat:globalChat)),
            _prettyCard(context,"لودو",[const Color(0xFF42A5F5), const Color(0xFF0D47A1)],"🎲", LudoScreen(chat:globalChat)),
            _prettyCard(context,"السلم والثعبان",[const Color(0xFFBA68C8), const Color(0xFF4A148C)],"🐍", SnakeScreen(chat:globalChat)),
          ]),
        ])),
        Container(decoration:const BoxDecoration(color:Color(0xFF0E172A), borderRadius:BorderRadius.vertical(top:Radius.circular(24)), boxShadow:[BoxShadow(color:Colors.black45, blurRadius:10, offset:Offset(0,-2))]), padding:const EdgeInsets.all(16), child:Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
          Row(mainAxisAlignment:MainAxisAlignment.spaceBetween, children:[
            const Text("ابحث عن صديق - غرفة الانتظار", style:TextStyle(color:Colors.white, fontWeight:FontWeight.bold, fontSize:12)),
            Row(children:[
              Container(padding:const EdgeInsets.symmetric(horizontal:8,vertical:4), decoration:BoxDecoration(color:Colors.green.withOpacity(0.2), borderRadius:BorderRadius.circular(20), border:Border.all(color:Colors.green)), child:const Text("متصل 4", style:TextStyle(color:Colors.green, fontSize:9))),
              const SizedBox(width:6),
              Container(padding:const EdgeInsets.symmetric(horizontal:10,vertical:4), decoration:BoxDecoration(color:Colors.white10, borderRadius:BorderRadius.circular(20)), child:Text("عام (${globalChat.length})", style:const TextStyle(color:Colors.white70, fontSize:10)))
            ])
          ]),
          const SizedBox(height:8),
          Container(height:60, padding:const EdgeInsets.all(8), decoration:BoxDecoration(color:Colors.black26, borderRadius:BorderRadius.circular(12), border:Border.all(color:Colors.white10)), child:SingleChildScrollView(child:Column(crossAxisAlignment:CrossAxisAlignment.start, children: globalChat.map((m)=> Padding(padding:const EdgeInsets.only(bottom:2), child:Text("💬 $m", style:const TextStyle(color:Colors.white70, fontSize:10)))).toList()))),
          const SizedBox(height:12),
        ...display.map((f)=> GestureDetector(onTap:()=>showPrivate(f["n"]!), child:Container(margin:const EdgeInsets.only(bottom:10), padding:const EdgeInsets.all(12), decoration:BoxDecoration(color:const Color(0xFF1C2A45), borderRadius:BorderRadius.circular(16), boxShadow:[BoxShadow(color:Colors.black45, blurRadius:6, offset:const Offset(0,3))], border:Border.all(color:Colors.white.withOpacity(0.05))), child:Row(mainAxisAlignment:MainAxisAlignment.spaceBetween, children:[
            Row(children:[
              Stack(children:[CircleAvatar(radius:22, backgroundImage:NetworkImage('https://i.pravatar.cc/100?img=${f["i"]}')), Positioned(bottom:0, right:0, child:Container(width:10, height:10, decoration:BoxDecoration(color:f["v"]=="BOT"?Colors.grey:Colors.green, shape:BoxShape.circle, border:Border.all(color:const Color(0xFF1C2A45), width:2))))]),
              const SizedBox(width:10),
              Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
                Row(children:[
                  Text(f["n"]!, style:const TextStyle(color:Colors.white, fontSize:13, fontWeight:FontWeight.bold)),
                  const SizedBox(width:6),
                  Container(padding:const EdgeInsets.symmetric(horizontal:5,vertical:2), decoration:BoxDecoration(color:f["v"]=="BOT"?Colors.grey:Colors.amber, borderRadius:BorderRadius.circular(4)), child:Text(f["v"]!, style:TextStyle(fontSize:8, color:f["v"]=="BOT"?Colors.white:Colors.black, fontWeight:FontWeight.bold)))
                ]),
                const SizedBox(height:2),
                Row(children:[
                  Container(width:6, height:6, decoration:BoxDecoration(color:f["v"]=="BOT"?Colors.grey:Colors.green, shape:BoxShape.circle)),
                  const SizedBox(width:4),
                  Text(f["v"]=="BOT"?"روبوت يكمل - يلعب تلقائي":"يشاهد اللعب - اضغط لشات خاص", style:const TextStyle(color:Colors.white54, fontSize:10))
                ])
              ])
            ]),
            Container(padding:const EdgeInsets.symmetric(horizontal:18,vertical:7), decoration:BoxDecoration(gradient:LinearGradient(colors:f["v"]=="BOT"?[Colors.grey, Colors.black54]:[const Color(0xFF22C55E), const Color(0xFF16A34A)]), borderRadius:BorderRadius.circular(20), boxShadow:[BoxShadow(color:(f["v"]=="BOT"?Colors.grey:const Color(0xFF22C55E)).withOpacity(0.3), blurRadius:6)]), child:Text(f["v"]=="BOT"?"🤖 روبوت":"إنضم", style:const TextStyle(color:Colors.white, fontWeight:FontWeight.bold, fontSize:11)))
          ])))),
          const SizedBox(height:6),
          const Text("لو مفيش لاعبين حقيقيين → نكمل بروبوتات | لو فيه حقيقيين → يلعبوا في أماكنهم عادي", style:TextStyle(color:Colors.white24, fontSize:8)),
        ]))
      ]))),
      Container(padding:const EdgeInsets.all(8), decoration:const BoxDecoration(color:Color(0xFF1A2332), boxShadow:[BoxShadow(color:Colors.black45, blurRadius:8, offset:Offset(0,-2))]), child:Row(children:[
        Expanded(child:TextField(controller:chatCtrl, style:const TextStyle(color:Colors.white, fontSize:11), decoration:InputDecoration(hintText:"دردشة عامة في كل الألعاب - قل شيئا... (عام 59 🎁)", hintStyle:const TextStyle(color:Colors.white54, fontSize:11), filled:true, fillColor:Colors.black45, border:OutlineInputBorder(borderRadius:BorderRadius.circular(20), borderSide:BorderSide.none), contentPadding:const EdgeInsets.symmetric(horizontal:14, vertical:8), prefixIcon:const Icon(Icons.chat_bubble, color:Colors.white24, size:16)))),
        const SizedBox(width:6),
        GestureDetector(onTap:(){ if(chatCtrl.text.isNotEmpty){ setState(()=> globalChat.add("أنت: ${chatCtrl.text}")); chatCtrl.clear(); } }, child:Container(padding:const EdgeInsets.all(11), decoration:BoxDecoration(gradient:const LinearGradient(colors:[Color(0xFFFFD700), Color(0xFFFFA000)]), shape:BoxShape.circle, boxShadow:[BoxShadow(color:Colors.amber.withOpacity(0.4), blurRadius:6)]), child:const Icon(Icons.send, size:16, color:Colors.black)))
      ]))
    ])));
  }
  Widget _prettyCard(BuildContext c,String t,List<Color> col,String e,Widget p)=>GestureDetector(onTap:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>p)), child:Container(decoration:BoxDecoration(gradient:LinearGradient(begin:Alignment.topLeft, end:Alignment.bottomRight, colors:col), borderRadius:BorderRadius.circular(24), boxShadow:[BoxShadow(color:col[0].withOpacity(0.5), blurRadius:14, offset:const Offset(0,7)), BoxShadow(color:Colors.black45, blurRadius:8, offset:const Offset(0,3))], border:Border.all(color:Colors.white.withOpacity(0.2), width:1.2)), child:Stack(children:[Positioned(top:-14, right:-14, child:Container(width:70, height:70, decoration:BoxDecoration(color:Colors.white.withOpacity(0.14), shape:BoxShape.circle))), Positioned(bottom:-10, left:-10, child:Container(width:50, height:50, decoration:BoxDecoration(color:Colors.black.withOpacity(0.15), shape:BoxShape.circle))), Column(mainAxisAlignment:MainAxisAlignment.center, children:[Container(padding:const EdgeInsets.all(10), decoration:BoxDecoration(color:Colors.white.withOpacity(0.15), shape:BoxShape.circle), child:Text(e, style:const TextStyle(fontSize:40))), const SizedBox(height:10), Container(padding:const EdgeInsets.symmetric(horizontal:14,vertical:7), decoration:BoxDecoration(color:Colors.black54, borderRadius:BorderRadius.circular(20), border:Border.all(color:Colors.amber.withOpacity(0.5)), boxShadow:[BoxShadow(color:Colors.black26, blurRadius:4)]), child:Text(t, style:const TextStyle(color:Colors.white, fontSize:11, fontWeight:FontWeight.bold)))])])));
}
class WaitingMini extends StatelessWidget{const WaitingMini({super.key}); @override Widget build(BuildContext context)=>Row(children:[Container(padding:const EdgeInsets.symmetric(horizontal:8,vertical:4), decoration:BoxDecoration(color:Colors.black45, borderRadius:BorderRadius.circular(12)), child:const Row(children:[CircleAvatar(radius:10, backgroundImage:NetworkImage('https://i.pravatar.cc/100?img=8')), SizedBox(width:4), Text("غرفة الانتظار (4) - عام وخاص", style:TextStyle(color:Colors.white70, fontSize:10))]))]);}

//... باقي الألعاب الأربعة بنفس الكود الكبير السابق 313 أمر + التعديلات الجديدة (الثعابين المنحنية S، الطيارات، الورق الصغير 32، الترابيزة 260x400 خفيفة) موجودة كاملة في النسخة اللي فوق - لو عايز أبعتلك ملف dart كامل مضغوط قولي أبعتهولك كـ ملف عشان Messenger ما يقطعش
