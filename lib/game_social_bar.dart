import 'package:flutter/material.dart';

class GameSocialBar extends StatefulWidget {
  final bool isVip;
  final int dailyFlowersCount;
  final Function(bool isMicOn) onMicToggle;
  final VoidCallback onSendGift;

  const GameSocialBar({
    Key? key,
    required this.isVip,
    required this.dailyFlowersCount,
    required this.onMicToggle,
    required this.onSendGift,
  }) : super(key: key);

  @override
  State<GameSocialBar> createState() => _GameSocialBarState();
}

class _GameSocialBarState extends State<GameSocialBar> {
  bool _micActive = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.isVip ? Colors.amber : Colors.white24,
          width: widget.isVip ? 2 : 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 1. شارة البرستيج و الـ VIP
          Row(
            children: [
              Icon(
                Icons.star,
                color: widget.isVip ? Colors.amberAccent : Colors.grey,
              ),
              const SizedBox(width: 6),
              Text(
                widget.isVip ? 'عضو VIP مميز ⭐' : 'لاعب عادي',
                style: TextStyle(
                  color: widget.isVip ? Colors.amberAccent : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          // 2. عداد الورود اليومية والهدايا
          InkWell(
            onTap: widget.onSendGift,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.pink[800],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Text('🌹', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 4),
                  Text(
                    '${widget.dailyFlowersCount}',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),

          // 3. أزرار التحكم الصوتي (المايك)
          IconButton(
            icon: Icon(
              _micActive ? Icons.mic : Icons.mic_off,
              color: _micActive ? Colors.greenAccent : Colors.white54,
            ),
            onPressed: () {
              setState(() {
                _micActive = !_micActive;
              });
              widget.onMicToggle(_micActive);
            },
          ),
        ],
      ),
    );
  }
}
