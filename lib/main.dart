// شاشة لودو المحدثة بلوحة اللعب الحقيقية والقطع التفاعلية
class LudoGameScreen extends StatefulWidget {
  @override
  _LudoGameScreenState createState() => _LudoGameScreenState();
}

class _LudoGameScreenState extends State<LudoGameScreen> {
  int _diceValue = 1;
  bool _isRolling = false;
  int _activePlayerIndex = 0; // 0: أحمر, 1: أخضر, 2: أصفر, 3: أزرق
  
  final List<String> _playerNames = ['الأحمر', 'الأخضر', ' الأصفر', 'الأزرق'];
  final List<Color> _playerColors = [Colors.redAccent, Colors.greenAccent, Colors.amber, Colors.blueAccent];
  
  // مواقع القطع على المسار لكل لاعب
  final List<int> _tokenPositions = [0, 0, 0, 0];

  void _rollDiceAndMove() {
    setState(() {
      _isRolling = true;
    });

    Future.delayed(Duration(milliseconds: 400), () {
      setState(() {
        _diceValue = Random().nextInt(6) + 1;
        
        // تحريك قطع اللاعب الحالي على المسار
        _tokenPositions[_activePlayerIndex] += _diceValue;
        if (_tokenPositions[_activePlayerIndex] > 56) {
          _tokenPositions[_activePlayerIndex] = 56; // نهاية اللوحة
          WalletData.addEarnings(15.0); // مكافأة الفوز بالدورة
        } else {
          WalletData.addEarnings(_diceValue * 2.0); // أرباح تفاعلية لكل خطوة
        }

        // الانتقال للاعب التالي
        _activePlayerIndex = (_activePlayerIndex + 1) % 4;
        _isRolling = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('لعبة لودو الملكية', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF1E293B),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // لوحة اللعب المصغرة الراقية (تمثل ساحة لودو الكلاسيكية)
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.amber.withOpacity(0.3), width: 2),
                ),
                child: Stack(
                  children: [
                    // القاعدة العلوية اليسرى (أحمر)
                    Positioned(top: 16, left: 16, child: _buildHomeBase('أحمر', Colors.redAccent, _tokenPositions[0])),
                    // القاعدة العلوية اليمنى (أخضر)
                    Positioned(top: 16, right: 16, child: _buildHomeBase('أخضر', Colors.greenAccent, _tokenPositions[1])),
                    // القاعدة السفلية اليسرى (أصفر)
                    Positioned(bottom: 16, left: 16, child: _buildHomeBase('أصفر', Colors.amber, _tokenPositions[2])),
                    // القاعدة السفلية اليمنى (أزرق)
                    Positioned(bottom: 16, right: 16, child: _buildHomeBase('أزرق', Colors.blueAccent, _tokenPositions[3])),
                    
                    // مركز اللوحة (منطقة الفوز)
                    Center(
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Colors.amber.withOpacity(0.4), Colors.orange.withOpacity(0.1)],
                          ),
                          border: Border.all(color: Colors.amber, width: 2),
                        ),
                        child: Center(
                          child: Icon(Icons.star, color: Colors.amber, size: 36),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            // لوحة معلومات الدور والنرد
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFF334155),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('دور اللاعب: ', style: TextStyle(color: Colors.white70, fontSize: 16)),
                        Text(
                          _playerNames[_activePlayerIndex],
                          style: TextStyle(
                            color: _playerColors[_activePlayerIndex],
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // شكل النرد الراقي
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Color(0xFF1E293B),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: _playerColors[_activePlayerIndex], width: 2),
                          ),
                          child: Center(
                            child: Text(
                              _isRolling ? '...' : '$_diceValue',
                              style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        // زر رمي النرد
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _playerColors[_activePlayerIndex],
                                minimumSize: Size(double.infinity, 55),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: _isRolling ? null : _rollDiceAndMove,
                              child: Text(
                                _isRolling ? 'جاري التحريك...' : 'ارمِ النرد وتقدم',
                                style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
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

  // عنصر مساعد لرسم قواعد اللاعبين على اللوحة
  Widget _buildHomeBase(String name, Color color, int position) {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(name, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
          SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(backgroundColor: color, radius: 8),
              SizedBox(width: 4),
              Text('$position خيانة', style: TextStyle(color: Colors.white70, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }
}
