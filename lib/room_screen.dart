import 'package:flutter/material.dart';
import 'room_model.dart';

class RoomScreen extends StatefulWidget {
  final String gameName;
  const RoomScreen({super.key, required this.gameName});

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  final GameRoom _room = GameRoom(roomId: '101', roomName: 'غرفة تحدي ' );
  int myCoins = 500; // رصيد افتراضي للتجربة

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.gameName} - ${_room.roomName}'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_room.isLocked ? Icons.lock : Icons.lock_open, 
                 color: _room.isLocked ? Colors.red : Colors.green),
            onPressed: () {
              setState(() {
                if (!_room.isLocked) {
                  if (myCoins >= _room.lockCost) {
                    myCoins -= _room.lockCost;
                    _room.lockRoom(myCoins + _room.lockCost);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم إغلاق الغرفة بنجاح مقابل 100 عملة!')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('رصيد العملات غير كافٍ لإغلاق الغرفة!')),
                    );
                  }
                }
              });
            },
            tooltip: 'إغلاق/فتح الغرفة',
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. غرفة الانتظار لأصدقاء اللاعبين (أعلى شاشة اللعب)
          Container(
            color: Colors.amber[100],
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'غرفة انتظار أصدقاء اللاعبين:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      ..._room.waitingPlayers.map((player) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Chip(
                          avatar: const Icon(Icons.person, size: 16),
                          label: Text(player),
                          backgroundColor: Colors.white,
                        ),
                      )),
                      ActionChip(
                        avatar: const Icon(Icons.add, size: 16),
                        label: const Text('دعوة صديق'),
                        onPressed: () {
                          setState(() {
                            _room.addPlayerToWaitingRoom('صديق #${_room.waitingPlayers.length + 1}');
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 2. ساحة اللعب الرئيسية (تخيلية للعبة)
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.sports_esports, size: 80, color: Colors.blue),
                  const SizedBox(height: 16),
                  Text(
                    'جاري اللعب في ${widget.gameName}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _room.isLocked ? '🔒 الغرفة مغلقة بكلمة مرور/عملات' : '🔓 الغرفة مفتوحة للجميع',
                    style: TextStyle(color: _room.isLocked ? Colors.red : Colors.green, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),

          // 3. شريط التحكم الصوتي والمايكروفونات
          Container(
            color: Colors.grey[200],
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _room.activeMics.contains('أنا') ? Colors.red : Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _room.toggleMic('أنا');
                    });
                  },
                  icon: Icon(_room.activeMics.contains('أنا') ? Icons.mic : Icons.mic_off),
                  label: Text(_room.activeMics.contains('أنا') ? 'إغلاق المايك' : 'فتح المايك'),
                ),
                Text(
                  'المتاحات الصوتية النشطة: ${_room.activeMics.length}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
