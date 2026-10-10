import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:typed_data';

void main() {
  runApp(const PlayAndWinApp());
}



// ================= الأساسيات: الألوان والنماذج والخدمات =================

/// وضع تجريبي: الدخول والغرف والدفع تعمل محلياً بدون خادم.
/// اجعلها false بعد ربط خدمات حقيقية (Firebase أو خادم خاص).
const bool kDemoMode = true;

/// الإعلانات مقفولة حالياً. عند التفعيل لاحقاً اربطها بـ google_mobile_ads
/// ثم اجعلها true (إعلان بانر في الرئيسية + إعلان مكافأة لعملات مجانية).
const bool kAdsEnabled = false;

class AdService {
  /// إعلان مكافأة: يعيد true إذا شاهده اللاعب كاملاً (معطّل الآن)
  static Future<bool> showRewarded() async {
    if (!kAdsEnabled) return false;
    return false; // TODO: ربط google_mobile_ads
  }
}

class AdBanner extends StatelessWidget {
  const AdBanner({super.key});
  @override
  Widget build(BuildContext context) {
    if (!kAdsEnabled) return const SizedBox.shrink();
    return const SizedBox(height: 50); // TODO: BannerAd
  }
}

Widget rtl(Widget w) => Directionality(textDirection: TextDirection.rtl, child: w);

class Pal {
  static const Color bg = Color(0xFF14061A);
  static const Color bg2 = Color(0xFF1E0524);
  static const Color card = Color(0xFF2A1236);
  static const Color card2 = Color(0xFF3A1B4B);
  static const Color gold = Color(0xFFFFD54F);
  static const Color goldDeep = Color(0xFFFFA000);
  static const Color muted = Color(0xFFB9A6C7);
  static const Color green = Color(0xFF3DDC84);
  static const Color red = Color(0xFFFF5252);
}

// ---------- أفاتار شخصي مرسوم (للاعبين الآليين) ----------
class _PersonPainter extends CustomPainter {
  final int v;
  const _PersonPainter(this.v);

  static const List<Color> skins = [
    Color(0xFFF5D0B0), Color(0xFFE8B98F), Color(0xFFD39B6C), Color(0xFFB77A4E), Color(0xFF8D5A38), Color(0xFFFFE0C7),
  ];
  static const List<Color> hairs = [
    Color(0xFF1B1B1B), Color(0xFF3E2723), Color(0xFF5D4037), Color(0xFF8D6E63), Color(0xFF212121),
  ];
  static const List<Color> shirts = [
    Color(0xFF1E88E5), Color(0xFF43A047), Color(0xFFE53935), Color(0xFF8E24AA), Color(0xFF00897B), Color(0xFFFB8C00), Color(0xFF546E7A), Color(0xFFD81B60),
  ];
  static const List<List<Color>> bgs = [
    [Color(0xFF4FC3F7), Color(0xFF0277BD)],
    [Color(0xFFA5D6A7), Color(0xFF2E7D32)],
    [Color(0xFFFFCC80), Color(0xFFEF6C00)],
    [Color(0xFFCE93D8), Color(0xFF6A1B9A)],
    [Color(0xFFEF9A9A), Color(0xFFC62828)],
    [Color(0xFF80CBC4), Color(0xFF00695C)],
    [Color(0xFF9FA8DA), Color(0xFF283593)],
    [Color(0xFFB0BEC5), Color(0xFF37474F)],
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final style = v % 5;
    final skin = skins[(v ~/ 5) % skins.length];
    final hair = hairs[(v ~/ 30) % hairs.length];
    final bg = bgs[(v ~/ 150) % bgs.length];
    final shirt = shirts[(v ~/ 7) % shirts.length];

    canvas.drawRect(
      Offset.zero & size,
      Paint()..shader = LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: bg).createShader(Offset.zero & size),
    );

    final headC = Offset(s * 0.5, s * 0.42);
    final headR = s * 0.22;

    // الشعر الخلفي أو الحجاب
    if (style == 2) {
      canvas.drawOval(Rect.fromCenter(center: Offset(s * 0.5, s * 0.5), width: s * 0.62, height: s * 0.7), Paint()..color = hair);
    } else if (style == 3) {
      final hij = shirts[(v ~/ 11) % shirts.length];
      canvas.drawOval(Rect.fromCenter(center: Offset(s * 0.5, s * 0.52), width: s * 0.66, height: s * 0.78), Paint()..color = hij);
    } else if (style == 1) {
      canvas.drawOval(Rect.fromCenter(center: Offset(s * 0.5, s * 0.46), width: s * 0.62, height: s * 0.66), Paint()..color = Colors.white);
    }

    // الكتفان
    final body = Path()
      ..moveTo(s * 0.1, s * 1.02)
      ..quadraticBezierTo(s * 0.12, s * 0.7, s * 0.5, s * 0.68)
      ..quadraticBezierTo(s * 0.88, s * 0.7, s * 0.9, s * 1.02)
      ..close();
    canvas.drawPath(body, Paint()..color = style == 1 ? Colors.white : shirt);

    // العنق والوجه
    canvas.drawRect(Rect.fromCenter(center: Offset(s * 0.5, s * 0.66), width: s * 0.14, height: s * 0.12), Paint()..color = skin);
    canvas.drawCircle(headC, headR, Paint()..color = skin);

    // غطاء الرأس / الشعر الأمامي
    if (style == 0) {
      canvas.drawArc(Rect.fromCircle(center: headC, radius: headR * 1.04), math_pi, math_pi, true, Paint()..color = hair);
    } else if (style == 2) {
      canvas.drawArc(Rect.fromCircle(center: headC, radius: headR * 1.04), math_pi * 1.05, math_pi * 0.9, true, Paint()..color = hair);
    } else if (style == 4) {
      canvas.drawArc(Rect.fromCircle(center: headC, radius: headR * 1.06), math_pi, math_pi, true, Paint()..color = shirt);
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(headC.dx - headR * 0.2, headC.dy - headR * 0.18, headR * 1.4, headR * 0.2), Radius.circular(headR * 0.1)),
        Paint()..color = shirt,
      );
    } else if (style == 1) {
      canvas.drawArc(Rect.fromCircle(center: headC, radius: headR * 1.08), math_pi, math_pi, true, Paint()..color = Colors.white);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(center: Offset(headC.dx, headC.dy - headR * 0.78), width: headR * 2.0, height: headR * 0.22), Radius.circular(headR * 0.1)),
        Paint()..color = const Color(0xFF212121),
      );
    } else if (style == 3) {
      canvas.drawArc(Rect.fromCircle(center: headC, radius: headR * 1.1), math_pi * 1.02, math_pi * 0.96, false,
          Paint()
            ..color = shirts[(v ~/ 11) % shirts.length]
            ..style = PaintingStyle.stroke
            ..strokeWidth = headR * 0.4);
    }

    // الملامح
    final eye = Paint()..color = const Color(0xFF212121);
    canvas.drawCircle(Offset(headC.dx - headR * 0.38, headC.dy + headR * 0.05), headR * 0.09, eye);
    canvas.drawCircle(Offset(headC.dx + headR * 0.38, headC.dy + headR * 0.05), headR * 0.09, eye);
    final smile = Path()
      ..moveTo(headC.dx - headR * 0.32, headC.dy + headR * 0.42)
      ..quadraticBezierTo(headC.dx, headC.dy + headR * 0.75, headC.dx + headR * 0.32, headC.dy + headR * 0.42);
    canvas.drawPath(
        smile,
        Paint()
          ..color = const Color(0xFF8D3B2F)
          ..style = PaintingStyle.stroke
          ..strokeWidth = headR * 0.1
          ..strokeCap = StrokeCap.round);
    // لحية خفيفة لبعض الرجال
    if ((style == 0 || style == 1 || style == 4) && (v ~/ 3) % 3 == 0) {
      canvas.drawArc(Rect.fromCircle(center: headC, radius: headR * 0.98), 0.25, math_pi - 0.5, false,
          Paint()
            ..color = hair.withOpacity(0.75)
            ..style = PaintingStyle.stroke
            ..strokeWidth = headR * 0.28);
    }
  }

  @override
  bool shouldRepaint(covariant _PersonPainter old) => old.v != v;
}

const double math_pi = 3.141592653589793;

// ---------- الأفاتار ----------
class Avatars {
  static const List<String> emoji = ['👑', '🦁', '🐯', '🦅', '🐉', '🦊', '🐼', '🚀', '⚽', '🎯', '🌹', '💎'];
  static const List<List<Color>> grads = [
    [Color(0xFFFFD54F), Color(0xFFFF8F00)],
    [Color(0xFFFF8A65), Color(0xFFD84315)],
    [Color(0xFFFFB74D), Color(0xFFEF6C00)],
    [Color(0xFF4DB6AC), Color(0xFF00695C)],
    [Color(0xFFBA68C8), Color(0xFF6A1B9A)],
    [Color(0xFFFF8A80), Color(0xFFC62828)],
    [Color(0xFF90A4AE), Color(0xFF37474F)],
    [Color(0xFF64B5F6), Color(0xFF1565C0)],
    [Color(0xFF81C784), Color(0xFF2E7D32)],
    [Color(0xFFF06292), Color(0xFFAD1457)],
    [Color(0xFFE57373), Color(0xFFB71C1C)],
    [Color(0xFF7986CB), Color(0xFF283593)],
  ];
}

class AvatarView extends StatelessWidget {
  final int id;
  final double size;
  final bool ring;
  const AvatarView({super.key, required this.id, this.size = 40, this.ring = false});

  @override
  Widget build(BuildContext context) {
    if (id >= 100) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: ring ? Pal.gold : Colors.white24, width: ring ? 2.5 : 1.5),
        ),
        child: ClipOval(child: CustomPaint(painter: _PersonPainter(id - 100))),
      );
    }
    final i = id.abs() % Avatars.emoji.length;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: Avatars.grads[i]),
        border: Border.all(color: ring ? Pal.gold : Colors.white24, width: ring ? 2.5 : 1.5),
      ),
      child: Text(Avatars.emoji[i], style: TextStyle(fontSize: size * 0.5)),
    );
  }
}

// ---------- الملف الشخصي واللاعبون ----------
class Profile {
  String name;
  int avatar;
  String method; // phone | google
  String contact;
  Profile({required this.name, required this.avatar, required this.method, required this.contact});
}

class SeatInfo {
  final String name;
  final int avatar;
  final bool isMe;
  final bool isBot;
  const SeatInfo(this.name, this.avatar, {this.isMe = false, this.isBot = true});
}

class Bots {
  static const List<String> maleNames = [
    'سلطان', 'ليث', 'فهد', 'زياد', 'أحمد', 'محمد', 'خالد', 'عمر', 'يوسف', 'حسن', 'علي', 'مصطفى', 'إبراهيم', 'طارق', 'ماجد',
    'سعود', 'نبيل', 'وليد', 'رامي', 'باسم', 'كرم', 'هاني', 'جاسم', 'ناصر', 'عادل', 'سامي', 'بدر', 'ياسر', 'مازن', 'أنس',
  ];
  static const List<String> femaleNames = [
    'نورة', 'ريم', 'هديل', 'لمى', 'سارة', 'ليلى', 'منى', 'مريم', 'فاطمة', 'زينب', 'هند', 'دانة', 'رهف', 'جود', 'ملك',
    'سلمى', 'آية', 'رنا', 'شهد', 'تالا',
  ];

  static final List<SeatInfo> pool = _build();

  static List<SeatInfo> _build() {
    final res = <SeatInfo>[];
    for (int i = 0; i < maleNames.length; i++) {
      final style = const [0, 1, 4][i % 3];
      res.add(SeatInfo(maleNames[i], 100 + style + 5 * ((i * 7) % 6) + 30 * ((i * 3) % 5) + 150 * ((i * 5) % 8)));
    }
    for (int i = 0; i < femaleNames.length; i++) {
      final style = const [2, 3][i % 2];
      res.add(SeatInfo(femaleNames[i], 100 + style + 5 * ((i * 5 + 1) % 6) + 30 * ((i * 2) % 5) + 150 * ((i * 3 + 2) % 8)));
    }
    return res;
  }
}

class Seats {
  /// أنا أولاً، ثم أعضاء الغرفة الخاصة (إن وُجدت)، ثم لاعبون آليون لإكمال العدد
  static List<SeatInfo> players(int n) {
    final res = <SeatInfo>[SeatInfo(AppState.I.myName, AppState.I.myAvatar, isMe: true, isBot: false)];
    final room = AppState.I.currentRoom;
    if (room != null) {
      for (final m in room.members) {
        if (res.length >= n) break;
        if (!m.isMe) res.add(m);
      }
    }
    final start = _rnd.nextInt(Bots.pool.length);
    final step = 7 + 2 * _rnd.nextInt(5); // 7,9,11,13,15 أولية مع 50
    int k = 0;
    while (res.length < n && k < 200) {
      final b = Bots.pool[(start + k * step) % Bots.pool.length];
      k++;
      if (res.any((s) => s.name == b.name)) continue;
      res.add(b);
    }
    return res;
  }

  static final math.Random _rnd = math.Random();

  /// لاعب آلي جديد غير موجود على الطاولة (يُستخدم بعد الطرد)
  static SeatInfo replacement(List<SeatInfo> current) {
    for (int k = 0; k < 200; k++) {
      final b = Bots.pool[_rnd.nextInt(Bots.pool.length)];
      if (!current.any((s) => s.name == b.name)) return b;
    }
    return Bots.pool.first;
  }
}

// ---------- حالة التطبيق ----------
class AppState extends ChangeNotifier {
  AppState._();
  static final AppState I = AppState._();

  Profile? me;
  bool aimDirect = false; // الضرب عكس اتجاه السحب (مثل المقلاع)
  bool welcomeShown = false;
  GameRoom? currentRoom;

  String get myName => me?.name ?? 'أنت';
  int get myAvatar => me?.avatar ?? 0;
  final int myId = 1000000 + math.Random().nextInt(8999999);
  SeatInfo get meSeat => SeatInfo(myName, myAvatar, isMe: true, isBot: false);

  void setProfile(Profile p) {
    me = p;
    notifyListeners();
  }

  void changed() => notifyListeners();

  void logout() {
    me = null;
    welcomeShown = false;
    currentRoom = null;
    notifyListeners();
  }
}

// ---------- الألعاب ----------
class GameInfo {
  final String id;
  final String title;
  final String tagline;
  final String emoji;
  final List<Color> colors;
  final List<String> help;
  const GameInfo(this.id, this.title, this.tagline, this.emoji, this.colors, this.help);
}

class Games {
  static const List<GameInfo> list = [
    GameInfo('ludo', 'لودو', 'سباق الأربعة', '🎲', [Color(0xFFE53935), Color(0xFFFF8A65)], [
      'اللعبة لأربعة لاعبين، وهدفك إدخال قطعك الأربع إلى المنزل في المنتصف.',
      'اضغط على النرد لترميه. تحتاج رقم 6 لإخراج قطعة من بيتها.',
      'عند وجود أكثر من حركة، اضغط على القطعة المضيئة التي تريد تحريكها.',
      'إذا وقفت على قطعة خصم أكلتها وعادت لبيتها، إلا في الخانات الآمنة (النجوم).',
      'رمي 6 أو أكل قطعة أو إيصال قطعة للمنزل يعطيك دوراً إضافياً.',
      'ثلاث ستات متتالية تضيّع دورك. أول من يُدخل قطعه الأربع يفوز.',
    ]),
    GameInfo('carrom', 'كيرم', 'اضرب وأسقط', '🎯', [Color(0xFF8D6E63), Color(0xFFFFB74D)], [
      'تلعب بالقطع البيضاء ضد الخصم الأسود، والهدف إسقاط كل قطعك في الجيوب.',
      'حرّك القاطع على خط التصويب بالشريط الأسفل.',
      'اسحب بإصبعك على اللوحة لتحديد الاتجاه والقوة. يمكنك تغيير طريقة السحب من الإعدادات.',
      'إسقاط إحدى قطعك يعطيك دوراً إضافياً، والملكة الحمراء تساوي ثلاث نقاط.',
      'إسقاط القاطع في الجيب خطأ، وتُعاد لك قطعة إلى اللوحة.',
    ]),
    GameInfo('snake', 'سلم وثعبان', 'اصعد ولا تسقط', '🐍', [Color(0xFF2E7D32), Color(0xFF4DB6AC)], [
      'ارمِ النرد وتحرّك بعدد النقاط. الهدف الوصول إلى الخانة 100.',
      'السلم يرفعك لأعلى، والثعبان ينزل بك إلى الأسفل.',
      'تحتاج رقماً مضبوطاً للوصول إلى 100 تماماً.',
      'رمي 6 يمنحك دوراً إضافياً.',
    ]),
    GameInfo('domino', 'دومينو', 'فريقان وأربع قطع', '🀄', [Color(0xFF1E88E5), Color(0xFF5C6BC0)], [
      'أربعة لاعبين في فريقين: أنت وشريكك المقابل لك ضد الخصمين.',
      'لكل لاعب 7 قطع، ويبدأ صاحب أكبر قطعة مزدوجة.',
      'ضع قطعة تطابق رقم أحد طرفي السلسلة. إذا ناسبت الطرفين فاختر الجهة.',
      'إن لم تملك قطعة مناسبة تدق ويمر الدور.',
      'من يُنهي قطعه أولاً يفوز لفريقه. وإن انغلقت اللعبة يفوز الفريق ذو النقاط الأقل.',
    ]),
  ];

  static GameInfo byId(String id) => list.firstWhere((g) => g.id == id, orElse: () => list.first);
}

// ---------- الغرف الخاصة ----------
class GameRoom {
  final String code;
  final String game; // ludo | carrom | snake | domino | chat
  final List<SeatInfo> members;
  final Map<String, int> invites = {}; // 0 لا شيء ، 1 أُرسلت ، 2 انضم
  GameRoom(this.code, this.game, this.members);

  String get title => game == 'chat' ? 'غرفة دردشة خاصة' : 'غرفة ${Games.byId(game).title}';
  String get emoji => game == 'chat' ? '💬' : Games.byId(game).emoji;
}

class RoomService {
  static final List<GameRoom> rooms = [];
  static final math.Random _r = math.Random();

  static GameRoom create(String game) {
    const prefixes = {'ludo': 'LD', 'carrom': 'CR', 'snake': 'SN', 'domino': 'DM', 'chat': 'CH'};
    final code = '${prefixes[game] ?? 'RM'}-${1000 + _r.nextInt(9000)}';
    final room = GameRoom(code, game, [SeatInfo(AppState.I.myName, AppState.I.myAvatar, isMe: true, isBot: false)]);
    rooms.insert(0, room);
    return room;
  }

  /// طرد لاعب: يكلّف المُطرِد قيمة مستوى الهدف، ثم ينخفض مستوى الهدف 5
  static String? kick(GameRoom? room, SeatInfo target) {
    final st = Stats.of(target);
    final cost = st.kickCost;
    if (UserData.coins < cost) return 'رصيدك لا يكفي. تحتاج $cost عملة لطرد ${target.name}';
    UserData.addCoins(-cost);
    st.kickCost = math.max(0, st.kickCost - 5);
    room?.members.removeWhere((m) => m.name == target.name && !m.isMe);
    AppState.I.changed();
    return null;
  }

  static GameRoom? find(String code) {
    final c = code.trim().toUpperCase();
    for (final r in rooms) {
      if (r.code == c) return r;
    }
    return null;
  }
}

class Friends {
  static const List<SeatInfo> list = [
    SeatInfo('أحمد', 3),
    SeatInfo('سارة', 9),
    SeatInfo('محمد', 7),
    SeatInfo('ليلى', 11),
    SeatInfo('خالد', 1),
    SeatInfo('منى', 10),
  ];

  /// أصدقائي (قابلة للإضافة)
  static final List<SeatInfo> mine = <SeatInfo>[list[0], list[1], list[2], list[3], list[4], list[5]];
}

// ---------- خدمات الدخول والدفع (تجريبية، جاهزة للربط) ----------
class AuthService {
  static Future<bool> sendCode(String fullPhone) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return fullPhone.length >= 8;
  }

  static Future<bool> verifyCode(String fullPhone, String code) async {
    await Future.delayed(const Duration(milliseconds: 700));
    if (!kDemoMode) return false;
    return code.length == 6;
  }

  static Future<Profile?> signInWithGoogle() async {
    await Future.delayed(const Duration(milliseconds: 900));
    if (!kDemoMode) return null;
    return Profile(name: 'لاعب جوجل', avatar: 0, method: 'google', contact: 'google-demo');
  }
}

class PaymentService {
  /// دفع ببطاقة بنكية. التطبيق لا يستقبل رقم البطاقة أبداً:
  /// في النسخة الحقيقية تُفتح صفحة الدفع الآمنة لمزوّد الدفع ثم يؤكد الخادم العملية.
  static Future<bool> cardCheckout(String country, String scheme, int pack) async {
    await Future.delayed(const Duration(milliseconds: 1400));
    return kDemoMode; // تجريبي: ينجح بدون خصم أي مبلغ
  }

  static Future<bool> redeemCard(String pin) async {
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!kDemoMode) return false;
    return pin.length >= 12;
  }
}

// ---------- عناصر واجهة مشتركة ----------
class GoldButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final IconData? icon;
  final bool busy;
  final bool outlined;
  const GoldButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.busy = false,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null && !busy;
    final fg = outlined ? Colors.white : Colors.black87;
    return Opacity(
      opacity: enabled ? 1 : 0.6,
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        child: Container(
          height: 52,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: outlined ? null : const LinearGradient(colors: [Pal.gold, Pal.goldDeep]),
            color: outlined ? Colors.white10 : null,
            border: outlined ? Border.all(color: Colors.white24) : null,
            boxShadow: outlined
                ? const []
                : [BoxShadow(color: Pal.goldDeep.withOpacity(0.35), blurRadius: 14, offset: const Offset(0, 5))],
          ),
          child: busy
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.black87),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[Icon(icon, color: fg, size: 22), const SizedBox(width: 8)],
                    Flexible(
                      child: Text(label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: fg, fontWeight: FontWeight.bold, fontSize: 15)),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class CoinChip extends StatelessWidget {
  final VoidCallback? onTap;
  const CoinChip({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.black26,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Pal.gold.withOpacity(0.5)),
        ),
        child: ValueListenableBuilder<int>(
          valueListenable: UserData.tick,
          builder: (context, _, __) => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.monetization_on, color: Pal.gold, size: 18),
              const SizedBox(width: 4),
              Text('${UserData.coins}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
              if (onTap != null) ...[
                const SizedBox(width: 4),
                const Icon(Icons.add_circle, color: Pal.gold, size: 16),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// زر علامة التعجب لشرح اللعبة
class HelpButton extends StatelessWidget {
  final String gameId;
  const HelpButton({super.key, required this.gameId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showGameHelp(context, gameId),
      child: Container(
        width: 28,
        height: 28,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withOpacity(0.3),
          border: Border.all(color: Colors.white70, width: 1.5),
        ),
        child: const Text('!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16)),
      ),
    );
  }
}

void showGameHelp(BuildContext context, String gameId) {
  final g = Games.byId(gameId);
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Pal.card,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (ctx) => rtl(
      SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Text(g.emoji, style: const TextStyle(fontSize: 28)),
                  const SizedBox(width: 10),
                  Text('طريقة لعب ${g.title}',
                      style: const TextStyle(color: Pal.gold, fontSize: 19, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 12),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (int i = 0; i < g.help.length; i++)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 22,
                                height: 22,
                                alignment: Alignment.center,
                                margin: const EdgeInsets.only(top: 2),
                                decoration: const BoxDecoration(shape: BoxShape.circle, color: Pal.gold),
                                child: Text('${i + 1}',
                                    style: const TextStyle(
                                        color: Colors.black87, fontSize: 12, fontWeight: FontWeight.bold)),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(g.help[i],
                                    style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5)),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              GoldButton(label: 'فهمت', onTap: () => Navigator.of(ctx).pop()),
            ],
          ),
        ),
      ),
    ),
  );
}

// ================= بيانات المستخدم =================
class UserData {
  static int coins = 1200;
  static int freeRoses = 5;

  /// يتغير كلما تغير الرصيد ليتحدث الشريط العلوي فوراً
  static final ValueNotifier<int> tick = ValueNotifier<int>(0);

  static void _notify() => tick.value = tick.value + 1;

  static void addCoins(int n) {
    coins += n;
    _notify();
  }

  static void addRoses(int n) {
    freeRoses += n;
    _notify();
  }

  static int earned = 0; // مجموع أرباح الألعاب نحو مكافأة 5000
  static String _lastSpin = '';

  static String _today() {
    final d = DateTime.now();
    return '${d.year}-${d.month}-${d.day}';
  }

  static bool get canSpin => _lastSpin != _today();
  static void markSpun() {
    _lastSpin = _today();
    _notify();
  }

  static void win() {
    SoundManager.win();
    coins += 20;
    earned += 20;
    _notify();
  }

  static void lose() {
    SoundManager.lose();
    coins = math.max(0, coins - 10);
    _notify();
  }

  static void claimMilestone() {
    if (earned < 5000) return;
    earned -= 5000;
    coins += 500;
    _notify();
  }

  static bool useRose() {
    if (freeRoses <= 0) return false;
    freeRoses--;
    _notify();
    return true;
  }
}

void showRoseFeedback(BuildContext context) {
  final ok = UserData.useRose();
  final m = ScaffoldMessenger.of(context);
  m.hideCurrentSnackBar();
  m.showSnackBar(SnackBar(
    duration: const Duration(milliseconds: 1500),
    content: Text(ok ? '🌹 تم إرسال وردة يومية بنجاح!' : 'نفدت الوردات المجانية'),
  ));
}

class BotChat {
  static final math.Random _r = math.Random();
  static const List<String> replies = [
    'لعبة حلوة 👏',
    'حظ موفق 🍀',
    'يا سلام على الحركة 🔥',
    'ما شاء الله عليك 👑',
    'هههه 😂',
    'جاي عليك الدور 😎',
  ];
  static String random() => replies[_r.nextInt(replies.length)];
}

// ================= الصوت والاهتزاز =================
class SoundManager {
  static bool enabled = true;
  static double volume = 0.8;
  static FlutterTts? _tts;
  static bool _ttsReady = false;
  static final Map<String, Uint8List> _cache = {};
  static final math.Random _rnd = math.Random();
  static int _lastMs = 0;

  // ---------- توليد المؤثرات برمجياً (WAV) ----------
  static const int _sr = 22050;

  static List<double> _tone(double f, double dur, {double decay = 9, double vol = 0.6, double slide = 0}) {
    final n = (dur * _sr).round();
    final out = List<double>.filled(n, 0);
    double ph = 0;
    for (int i = 0; i < n; i++) {
      final t = i / _sr;
      final fr = f + slide * (t / dur);
      ph += 2 * math.pi * fr / _sr;
      final env = math.exp(-decay * t) * math.min(1.0, i / 60.0);
      out[i] = math.sin(ph) * env * vol;
    }
    return out;
  }

  static List<double> _noise(double dur, {double decay = 40, double vol = 0.5}) {
    final n = (dur * _sr).round();
    double lp = 0;
    return List<double>.generate(n, (i) {
      lp = lp * 0.55 + (_rnd.nextDouble() * 2 - 1) * 0.45;
      return lp * math.exp(-decay * i / _sr) * vol;
    });
  }

  static void _add(List<double> base, List<double> x, double at) {
    final o = (at * _sr).round();
    for (int i = 0; i < x.length && o + i < base.length; i++) {
      base[o + i] += x[i];
    }
  }

  static Uint8List _wav(List<double> s) {
    final n = s.length;
    final b = ByteData(44 + n * 2);
    void str(int o, String t) {
      for (int i = 0; i < t.length; i++) {
        b.setUint8(o + i, t.codeUnitAt(i));
      }
    }

    str(0, 'RIFF');
    b.setUint32(4, 36 + n * 2, Endian.little);
    str(8, 'WAVE');
    str(12, 'fmt ');
    b.setUint32(16, 16, Endian.little);
    b.setUint16(20, 1, Endian.little);
    b.setUint16(22, 1, Endian.little);
    b.setUint32(24, _sr, Endian.little);
    b.setUint32(28, _sr * 2, Endian.little);
    b.setUint16(32, 2, Endian.little);
    b.setUint16(34, 16, Endian.little);
    str(36, 'data');
    b.setUint32(40, n * 2, Endian.little);
    for (int i = 0; i < n; i++) {
      final v = (s[i].clamp(-1.0, 1.0) * 32000).round();
      b.setInt16(44 + i * 2, v, Endian.little);
    }
    return b.buffer.asUint8List();
  }

  static Uint8List _make(String k) {
    List<double> s;
    switch (k) {
      case 'dice':
        s = List<double>.filled((0.55 * _sr).round(), 0);
        for (int i = 0; i < 8; i++) {
          final at = i * 0.06 + (i * i) * 0.004;
          _add(s, _noise(0.03, decay: 90, vol: 0.55), at);
          _add(s, _tone(260 + _rnd.nextInt(180).toDouble(), 0.05, decay: 60, vol: 0.3), at);
        }
        break;
      case 'move':
        s = _tone(520, 0.07, decay: 55, vol: 0.5);
        _add(s, _noise(0.02, decay: 120, vol: 0.25), 0);
        break;
      case 'hit':
        s = _noise(0.09, decay: 55, vol: 0.6);
        _add(s, _tone(180, 0.12, decay: 35, vol: 0.5), 0);
        break;
      case 'pocket':
        s = _tone(300, 0.22, decay: 14, vol: 0.55, slide: -160);
        _add(s, _noise(0.04, decay: 80, vol: 0.3), 0);
        break;
      case 'coin':
        s = List<double>.filled((0.38 * _sr).round(), 0);
        _add(s, _tone(988, 0.2, decay: 12, vol: 0.45), 0);
        _add(s, _tone(1319, 0.26, decay: 10, vol: 0.45), 0.08);
        break;
      case 'win':
        s = List<double>.filled((0.9 * _sr).round(), 0);
        const notes = [523.0, 659.0, 784.0, 1047.0];
        for (int i = 0; i < notes.length; i++) {
          _add(s, _tone(notes[i], 0.3, decay: 7, vol: 0.4), i * 0.14);
        }
        break;
      case 'lose':
        s = List<double>.filled((0.7 * _sr).round(), 0);
        const notes = [392.0, 330.0, 262.0];
        for (int i = 0; i < notes.length; i++) {
          _add(s, _tone(notes[i], 0.3, decay: 8, vol: 0.4), i * 0.18);
        }
        break;
      case 'up':
        s = _tone(400, 0.35, decay: 5, vol: 0.45, slide: 700);
        break;
      case 'snake':
        s = _tone(700, 0.45, decay: 4, vol: 0.45, slide: -520);
        break;
      case 'pass':
        s = _tone(200, 0.18, decay: 18, vol: 0.5);
        break;
      case 'pop':
        s = _tone(760, 0.06, decay: 60, vol: 0.4, slide: 500);
        break;
      default: // pen / bonk كرتوني
        s = _tone(240, 0.3, decay: 9, vol: 0.6, slide: -140);
        _add(s, _noise(0.03, decay: 90, vol: 0.4), 0);
    }
    return _wav(s);
  }

  static void _play(String k, {double vol = 1.0, int minGap = 0}) {
    if (!enabled || volume <= 0) return;
    final now = DateTime.now().millisecondsSinceEpoch;
    if (now - _lastMs < minGap) return;
    _lastMs = now;
    try {
      final bytes = _cache.putIfAbsent(k, () => _make(k));
      final p = AudioPlayer();
      p.onPlayerComplete.listen((_) => p.dispose());
      p.play(BytesSource(bytes), volume: (volume * vol).clamp(0.0, 1.0).toDouble()).catchError((_) {});
    } catch (_) {}
  }

  static void dice() {
    if (!enabled) return;
    HapticFeedback.mediumImpact();
    _play('dice');
  }

  static void move() {
    if (!enabled) return;
    HapticFeedback.lightImpact();
    _play('move', minGap: 70);
  }

  static void hit() {
    if (!enabled) return;
    HapticFeedback.mediumImpact();
    _play('hit');
  }

  static void pocket() {
    if (!enabled) return;
    HapticFeedback.heavyImpact();
    _play('pocket');
  }

  static void coin() {
    if (!enabled) return;
    HapticFeedback.selectionClick();
    _play('coin');
  }

  static void capture() {
    if (!enabled) return;
    HapticFeedback.heavyImpact();
    _play('pocket');
  }

  static void win() => _play('win');
  static void lose() => _play('lose');
  static void up() => _play('up');
  static void pass() => _play('pass');
  static void pop() => _play('pop', minGap: 80);

  /// صوت القلم + "ارررجع يالمبي" عند أكل قطعة أو الوقوف على رأس ثعبان
  static Future<void> oops() async {
    if (!enabled) return;
    HapticFeedback.heavyImpact();
    _play('bonk');
    try {
      if (_tts == null) {
        _tts = FlutterTts();
        await _tts!.setLanguage('ar');
        await _tts!.setPitch(1.5);
        await _tts!.setSpeechRate(0.4);
        _ttsReady = true;
      }
      await _tts!.setVolume(volume.clamp(0.0, 1.0).toDouble());
      if (_ttsReady) await _tts!.speak('ارررجع يالمبي');
    } catch (_) {}
  }
}

// ================= شريط الدردشة =================
class ChatAndControlsBar extends StatefulWidget {
  final ValueChanged<String> onSendChat;
  final ValueChanged<String> onSendEmoji;
  final VoidCallback onSendRose;

  const ChatAndControlsBar({
    super.key,
    required this.onSendChat,
    required this.onSendEmoji,
    required this.onSendRose,
  });

  @override
  State<ChatAndControlsBar> createState() => _ChatAndControlsBarState();
}

class _ChatAndControlsBarState extends State<ChatAndControlsBar> {
  final TextEditingController chatCtrl = TextEditingController();
  final List<String> emojis = ["❤️", "🌹", "👑", "🔥", "😂", "👍"];
  bool isMuted = false;

  @override
  void dispose() {
    chatCtrl.dispose();
    super.dispose();
  }

  void _send() {
    final text = chatCtrl.text.trim();
    if (text.isEmpty) return;
    SoundManager.pop();
    widget.onSendChat(text);
    chatCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    final kbOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      color: Pal.bg,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: kbOpen ? 0 : 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                IconButton(
                  icon: Icon(isMuted ? Icons.mic_off : Icons.mic, color: isMuted ? Colors.red : Colors.green),
                  onPressed: () {
                    setState(() => isMuted = !isMuted);
                    final m = ScaffoldMessenger.of(context);
                    m.hideCurrentSnackBar();
                    m.showSnackBar(
                      SnackBar(
                        duration: const Duration(milliseconds: 1200),
                        content: Text(isMuted ? 'تم كتم المايك' : 'تم فتح المايك الصوتي'),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Text("🌹", style: TextStyle(fontSize: 18)),
                  onPressed: widget.onSendRose,
                ),
                ...emojis.map((e) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: ActionChip(
                        backgroundColor: Pal.card,
                        label: Text(e, style: const TextStyle(fontSize: 14)),
                        onPressed: () => widget.onSendEmoji(e),
                      ),
                    )),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: chatCtrl,
                  onSubmitted: (_) => _send(),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                  decoration: InputDecoration(
                    hintText: "اكتب رسالة عامة أو خاصة...",
                    hintStyle: const TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: Pal.card,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send, color: Colors.amber, size: 20),
                onPressed: _send,
              )
            ],
          ),
        ],
      ),
    );
  }
}

// ================= عناصر مشتركة =================

/// شريط يعرض آخر رسالة دردشة
class ChatTicker extends StatelessWidget {
  final List<String> messages;
  const ChatTicker({super.key, required this.messages});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(8)),
      child: Text(
        messages.isEmpty ? '💬 الدردشة العامة' : messages.last,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Colors.white70, fontSize: 11),
      ),
    );
  }
}

/// بطاقة لاعب (صورة + اسم + شارة)
class _PlayerBadgeBody extends StatelessWidget {
  final String name;
  final Color color;
  final String badge;
  final bool active;
  final int avatar;

  const _PlayerBadgeBody({
    super.key,
    required this.name,
    required this.color,
    required this.badge,
    required this.active,
    this.avatar = -1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: active ? Colors.greenAccent : Colors.transparent, width: 2.5),
                boxShadow: active
                    ? [BoxShadow(color: Colors.greenAccent.withOpacity(0.6), blurRadius: 10, spreadRadius: 1)]
                    : const [],
              ),
              child: Padding(
                padding: const EdgeInsets.all(3),
                child: avatar >= 0
                    ? AvatarView(id: avatar, size: 36)
                    : CircleAvatar(
                        backgroundColor: color,
                        child: const Icon(Icons.person, color: Colors.white, size: 20),
                      ),
              ),
            ),
            Positioned(
              top: -2,
              right: -6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(6)),
                child: Text(badge,
                    style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.black)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(name, style: TextStyle(color: active ? Colors.white : Colors.white60, fontSize: 10)),
      ],
    );
  }
}

/// وجه النرد بالنقاط
class DiceFace extends StatelessWidget {
  final int value;
  final double size;
  final Color accent;
  final bool active;
  final bool rolling;
  final VoidCallback? onTap;

  const DiceFace({
    super.key,
    required this.value,
    required this.size,
    required this.accent,
    this.active = false,
    this.rolling = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final face = AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size * 0.2),
        border: Border.all(color: accent, width: 3),
        boxShadow: [
          BoxShadow(
            color: active ? const Color(0xFFFFD700).withOpacity(0.85) : Colors.black45,
            blurRadius: active ? 14 : 5,
            spreadRadius: active ? 2 : 0,
          ),
        ],
      ),
      child: CustomPaint(painter: _PipsPainter(value, Colors.black87)),
    );
    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        scale: rolling ? 1.14 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Transform.rotate(angle: rolling ? value * 0.45 : 0, child: face),
      ),
    );
  }
}

class _PipsPainter extends CustomPainter {
  final int v;
  final Color color;
  _PipsPainter(this.v, this.color);

  static const Map<int, List<Offset>> layout = {
    1: [Offset(.5, .5)],
    2: [Offset(.28, .28), Offset(.72, .72)],
    3: [Offset(.28, .28), Offset(.5, .5), Offset(.72, .72)],
    4: [Offset(.28, .28), Offset(.72, .28), Offset(.28, .72), Offset(.72, .72)],
    5: [Offset(.28, .28), Offset(.72, .28), Offset(.5, .5), Offset(.28, .72), Offset(.72, .72)],
    6: [Offset(.28, .25), Offset(.72, .25), Offset(.28, .5), Offset(.72, .5), Offset(.28, .75), Offset(.72, .75)],
  };

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final pips = layout[v] ?? layout[1]!;
    for (final o in pips) {
      canvas.drawCircle(Offset(o.dx * size.width, o.dy * size.height), size.width * 0.085, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _PipsPainter old) => old.v != v;
}

/// نجمة صغيرة تستخدم لتعليم المربعات الآمنة
Path starPath(Offset c, double r) {
  final path = Path();
  for (int i = 0; i < 10; i++) {
    final rad = i.isEven ? r : r * 0.45;
    final a = -math.pi / 2 + i * math.pi / 5;
    final p = Offset(c.dx + rad * math.cos(a), c.dy + rad * math.sin(a));
    if (i == 0) {
      path.moveTo(p.dx, p.dy);
    } else {
      path.lineTo(p.dx, p.dy);
    }
  }
  path.close();
  return path;
}

Future<void> showWinDialog(BuildContext context, String title, String body, VoidCallback onAgain) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      backgroundColor: Pal.card,
      title: Text(title, style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
      content: Text(body, style: const TextStyle(color: Colors.white)),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(ctx).pop();
            onAgain();
          },
          child: const Text('العب مرة أخرى', style: TextStyle(color: Colors.amber)),
        ),
      ],
    ),
  );
}

/// لوحة دردشة عامة تعرض آخر الرسائل (صيغة الرسالة: "الاسم: النص")
class ChatPanel extends StatelessWidget {
  final List<String> messages;
  const ChatPanel({super.key, required this.messages});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: Colors.black.withOpacity(0.28), borderRadius: BorderRadius.circular(12)),
      child: messages.isEmpty
          ? const Center(child: Text('💬 الدردشة العامة', style: TextStyle(color: Colors.white38, fontSize: 12)))
          : ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (c, i) {
                final m = messages[messages.length - 1 - i];
                final idx = m.indexOf(':');
                final who = idx > 0 ? m.substring(0, idx) : '';
                final txt = idx > 0 ? m.substring(idx + 1).trim() : m;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(color: Pal.card2, borderRadius: BorderRadius.circular(12)),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                if (who.isNotEmpty)
                                  TextSpan(
                                    text: '$who  ',
                                    style: const TextStyle(color: Pal.gold, fontSize: 11, fontWeight: FontWeight.bold),
                                  ),
                                TextSpan(text: txt, style: const TextStyle(color: Colors.white, fontSize: 12)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}


// ================= هيكل شاشة اللعب المشترك (آمن مع الكيبورد) =================
/// اللوحة بالأعلى بحجم ثابت، تحتها ملفات اللاعبين ثم الدردشة.
/// عند ظهور الكيبورد: تبقى اللوحة بنفس حجمها وتختفي ملفات اللاعبين والإيموجي.
class GameFrame extends StatelessWidget {
  final Widget? top;
  final Widget board;
  final Widget? mid;
  final double midH;
  final Widget badges;
  final Widget chat;
  final Widget bar;
  final double boardFrac;
  final double topH;

  const GameFrame({
    super.key,
    this.top,
    required this.board,
    this.mid,
    this.midH = 0,
    required this.badges,
    required this.chat,
    required this.bar,
    this.boardFrac = 0.46,
    this.topH = 36,
  });

  @override
  Widget build(BuildContext context) {
    final kb = MediaQuery.of(context).viewInsets.bottom;
    final kbOpen = kb > 0;
    return LayoutBuilder(builder: (context, cons) {
      final full = cons.maxHeight;
      final th = top == null ? 0.0 : topH;
      final boardH = full * boardFrac;
      final boardTop = kbOpen ? 0.0 : th;
      final midShown = mid != null && !kbOpen;
      final upper = boardTop + boardH + (midShown ? midH : 0.0);
      final lowerH = kbOpen ? math.max(full - upper - kb, 92.0) : math.max(full - upper, 0.0);
      return Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          if (top != null)
            Positioned(left: 0, right: 0, top: 0, height: th, child: Visibility(visible: !kbOpen, child: top!)),
          Positioned(left: 0, right: 0, top: boardTop, height: boardH, child: board),
          if (mid != null)
            Positioned(
              left: 0,
              right: 0,
              top: boardTop + boardH,
              height: midH,
              child: Visibility(visible: midShown, child: mid!),
            ),
          Positioned(
            left: 0,
            right: 0,
            bottom: kbOpen ? kb : 0,
            height: lowerH,
            child: Container(
              color: Pal.bg,
              child: Column(
                children: [
                  Visibility(visible: !kbOpen, child: badges),
                  Expanded(child: chat),
                  bar,
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}


// ================= الملفات الشخصية، الهدايا، الطرد =================
class Stat {
  int roses = 0;
  int gifts = 0;
  int kickCost = 500; // تكلفة طرد هذا اللاعب (مستوى الحماية)
  int recharges = 0;
}

class Stats {
  static final Map<String, Stat> _m = {};

  static Stat of(SeatInfo s) => _m.putIfAbsent(s.isMe ? 'me' : s.name, () {
        final st = Stat();
        if (!s.isMe) {
          final h = idOf(s);
          st.roses = 20 + h % 780;
          st.gifts = h % 9;
          st.kickCost = 500 + (h % 5) * 25;
        }
        return st;
      });
  static Stat get mine => _m.putIfAbsent('me', () => Stat());

  static int idOf(SeatInfo s) {
    if (s.isMe) return AppState.I.myId;
    int h = 7;
    for (final c in s.name.codeUnits) {
      h = (h * 31 + c) % 8999999;
    }
    return 1000000 + h;
  }

  /// أصدقاء اللاعب (توليد ثابت من اسمه)
  static List<SeatInfo> friendsOf(SeatInfo s) {
    final pool = <SeatInfo>[...Friends.list, ...Bots.pool].where((x) => x.name != s.name).toList();
    int h = 11;
    for (final c in s.name.codeUnits) {
      h = (h * 17 + c) % 100003;
    }
    final res = <SeatInfo>[];
    for (int i = 0; i < pool.length && res.length < 8; i++) {
      if ((h + i * 7) % 3 != 0) res.add(pool[i]);
    }
    return res;
  }
}

class Gift {
  final String id;
  final String emoji;
  final String name;
  final int cost;
  final int roses;
  const Gift(this.id, this.emoji, this.name, this.cost, this.roses);
}

const List<Gift> kGifts = [
  Gift('rose', '🌹', 'وردة', 10, 1),
  Gift('bouquet', '💐', 'باقة ورد', 45, 5),
  Gift('hearts', '💕', 'قلوب كثيرة', 150, 0),
  Gift('crown', '👑', 'تاج', 1200, 0),
  Gift('rose500', '🌹', '500 وردة', 3500, 500),
  Gift('car', '🚗', 'سيارة', 5000, 0),
  Gift('yacht', '🛥️', 'يخت', 20000, 0),
  Gift('plane', '✈️', 'طائرة', 50000, 0),
];

const List<int> kCoinGifts = [50, 100, 500, 1000];

void _toastCtx(BuildContext context, String t) {
  final m = ScaffoldMessenger.of(context);
  m.hideCurrentSnackBar();
  m.showSnackBar(SnackBar(duration: const Duration(milliseconds: 1900), content: rtl(Text(t))));
}

class PlayerBadge extends StatelessWidget {
  final String name;
  final Color color;
  final String badge;
  final bool active;
  final int avatar;
  final SeatInfo? seat;
  final VoidCallback? onKick;

  const PlayerBadge({
    super.key,
    required this.name,
    required this.color,
    required this.badge,
    required this.active,
    this.avatar = -1,
    this.seat,
    this.onKick,
  });

  @override
  Widget build(BuildContext context) {
    final body = _PlayerBadgeBody(name: name, color: color, badge: badge, active: active, avatar: avatar);
    if (seat == null) return body;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => showPlayerProfile(context, seat!, onKick: onKick),
      child: body,
    );
  }
}

void showPlayerProfile(BuildContext context, SeatInfo s, {GameRoom? room, VoidCallback? onKick}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Pal.card,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (ctx) => rtl(_ProfileSheet(seat: s, room: room ?? AppState.I.currentRoom, onKick: onKick)),
  );
}

class _ProfileSheet extends StatefulWidget {
  final SeatInfo seat;
  final GameRoom? room;
  final VoidCallback? onKick;
  const _ProfileSheet({required this.seat, this.room, this.onKick});

  @override
  State<_ProfileSheet> createState() => _ProfileSheetState();
}

class _ProfileSheetState extends State<_ProfileSheet> {
  Widget _stat(String icon, String value, String label) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(color: Pal.card2, borderRadius: BorderRadius.circular(14)),
          child: Column(children: [
            Text('$icon $value', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(color: Pal.muted, fontSize: 11)),
          ]),
        ),
      );

  void _confirmKick() {
    final s = widget.seat;
    final room = widget.room;
    final cost = Stats.of(s).kickCost;
    showDialog<void>(
      context: context,
      builder: (ctx) => rtl(AlertDialog(
        backgroundColor: Pal.card,
        title: const Text('طرد اللاعب', style: TextStyle(color: Pal.gold)),
        content: Text('سيتم خصم $cost عملة من رصيدك لطرد ${s.name} من الغرفة. هل تريد المتابعة؟',
            style: const TextStyle(color: Colors.white)),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('إلغاء')),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              final err = RoomService.kick(room, s);
              if (err != null) {
                _toastCtx(context, err);
              } else {
                final messenger = ScaffoldMessenger.of(context);
                widget.onKick?.call();
                Navigator.of(context).pop();
                messenger.hideCurrentSnackBar();
                messenger.showSnackBar(SnackBar(content: rtl(Text('تم طرد ${s.name} من الغرفة'))));
              }
            },
            child: const Text('طرد', style: TextStyle(color: Pal.red)),
          ),
        ],
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.seat;
    final st = Stats.of(s);
    final mutual = s.isMe
        ? List<SeatInfo>.from(Friends.mine)
        : Stats.friendsOf(s).where((f) => Friends.mine.any((m) => m.name == f.name)).toList();
    final room = widget.room;
    final canKick = !s.isMe &&
        (widget.onKick != null ||
            (room != null && room.members.isNotEmpty && room.members.first.isMe && room.members.any((m) => m.name == s.name)));
    final isFriend = Friends.mine.any((m) => m.name == s.name);
    final id = Stats.idOf(s);
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 44, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 14),
          AvatarView(id: s.avatar, size: 78, ring: StoryService.hasStory(s)),
          const SizedBox(height: 8),
          Text(s.name, style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold)),
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: '$id'));
              _toastCtx(context, 'تم نسخ الـ ID');
            },
            child: Text('ID: $id  ⧉', textDirection: TextDirection.ltr, style: const TextStyle(color: Pal.muted, fontSize: 13)),
          ),
          const SizedBox(height: 14),
          Row(children: [
            _stat('🌹', '${st.roses}', 'ورود مستلمة'),
            const SizedBox(width: 8),
            _stat('🎁', '${st.gifts}', 'هدايا'),
            const SizedBox(width: 8),
            _stat('⭐', '${st.kickCost}', 'المستوى'),
          ]),
          const SizedBox(height: 16),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(s.isMe ? 'أصدقائي' : 'الأصدقاء المشتركون',
                style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 8),
          if (mutual.isEmpty)
            const Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text('لا يوجد أصدقاء مشتركون', style: TextStyle(color: Pal.muted, fontSize: 13)),
            )
          else
            SizedBox(
              height: 66,
              child: ListView(scrollDirection: Axis.horizontal, children: [
                for (final f in mutual)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: 12),
                    child: Column(children: [
                      AvatarView(id: f.avatar, size: 40),
                      const SizedBox(height: 3),
                      Text(f.name, style: const TextStyle(color: Pal.muted, fontSize: 11)),
                    ]),
                  ),
              ]),
            ),
          const SizedBox(height: 16),
          if (!s.isMe) GoldButton(label: 'إهداء هدية', icon: Icons.card_giftcard, onTap: () => showGiftSheet(context, target: s)),
          if (!s.isMe && !isFriend) ...[
            const SizedBox(height: 10),
            GoldButton(
              label: 'إضافة صديق',
              icon: Icons.person_add_alt_1,
              outlined: true,
              onTap: () {
                Friends.mine.add(s);
                setState(() {});
                _toastCtx(context, 'تمت إضافة ${s.name} إلى أصدقائك');
              },
            ),
          ],
          if (canKick) ...[
            const SizedBox(height: 10),
            TextButton.icon(
              onPressed: _confirmKick,
              icon: const Icon(Icons.exit_to_app, color: Pal.red),
              label: Text('طرد من الغرفة (${st.kickCost} عملة)', style: const TextStyle(color: Pal.red)),
            ),
          ],
        ]),
      ),
    );
  }
}

void showGiftSheet(BuildContext context, {SeatInfo? target}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Pal.card,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (ctx) => rtl(_GiftSheet(target: target)),
  );
}

class _GiftSheet extends StatefulWidget {
  final SeatInfo? target;
  const _GiftSheet({this.target});

  @override
  State<_GiftSheet> createState() => _GiftSheetState();
}

class _GiftSheetState extends State<_GiftSheet> {
  SeatInfo? sel;

  @override
  void initState() {
    super.initState();
    if (widget.target != null && !widget.target!.isMe) sel = widget.target;
  }

  List<SeatInfo> get candidates {
    final res = <SeatInfo>[];
    final room = AppState.I.currentRoom;
    if (room != null) {
      for (final m in room.members) {
        if (!m.isMe) res.add(m);
      }
    }
    for (final f in Friends.mine) {
      if (!res.any((x) => x.name == f.name)) res.add(f);
    }
    if (sel != null && !res.any((x) => x.name == sel!.name)) res.insert(0, sel!);
    return res;
  }

  void _send(Gift g) {
    if (sel == null) {
      _toastCtx(context, 'اختر اللاعب الذي تريد إهداءه أولاً');
      return;
    }
    if (UserData.coins < g.cost) {
      _toastCtx(context, 'رصيدك لا يكفي. اشحن العملات أو جرّب عجلة الحظ');
      return;
    }
    UserData.addCoins(-g.cost);
    final st = Stats.of(sel!);
    st.roses += g.roses;
    if (g.roses == 0) st.gifts++;
    SoundManager.coin();
    _toastCtx(context, '${g.emoji} تم إهداء ${g.name} إلى ${sel!.name}');
    setState(() {});
  }

  void _sendCoins(int n) {
    if (sel == null) {
      _toastCtx(context, 'اختر اللاعب الذي تريد إهداءه أولاً');
      return;
    }
    if (UserData.coins < n) {
      _toastCtx(context, 'رصيدك لا يكفي لإهداء $n عملة');
      return;
    }
    UserData.addCoins(-n);
    SoundManager.coin();
    _toastCtx(context, '🪙 تم إهداء $n عملة إلى ${sel!.name}');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final cands = candidates;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(child: Container(width: 44, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 12),
          Row(children: [
            const Text('إهداء', style: TextStyle(color: Pal.gold, fontSize: 18, fontWeight: FontWeight.bold)),
            const Spacer(),
            const CoinChip(),
          ]),
          const SizedBox(height: 10),
          SizedBox(
            height: 72,
            child: cands.isEmpty
                ? const Center(child: Text('لا يوجد لاعبون لإهدائهم', style: TextStyle(color: Pal.muted)))
                : ListView(scrollDirection: Axis.horizontal, children: [
                    for (final c in cands)
                      GestureDetector(
                        onTap: () => setState(() => sel = c),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.only(end: 12),
                          child: Opacity(
                            opacity: sel != null && sel!.name == c.name ? 1 : 0.55,
                            child: Column(children: [
                              AvatarView(id: c.avatar, size: 44, ring: sel != null && sel!.name == c.name),
                              const SizedBox(height: 3),
                              Text(c.name, style: const TextStyle(color: Colors.white, fontSize: 11)),
                            ]),
                          ),
                        ),
                      ),
                  ]),
          ),
          const SizedBox(height: 8),
          Flexible(
            child: SingleChildScrollView(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                GridView.count(
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.78,
                  children: [
                    for (final g in kGifts)
                      GestureDetector(
                        onTap: () => _send(g),
                        child: Container(
                          decoration: BoxDecoration(color: Pal.card2, borderRadius: BorderRadius.circular(14)),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                            Text(g.emoji, style: const TextStyle(fontSize: 30)),
                            const SizedBox(height: 4),
                            Text(g.name, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 11)),
                            const SizedBox(height: 2),
                            Text('🪙 ${g.cost}', style: const TextStyle(color: Pal.gold, fontSize: 11, fontWeight: FontWeight.bold)),
                          ]),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 14),
                const Text('إهداء عملات', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(children: [
                  for (final n in kCoinGifts)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: SizedBox(
                          height: 42,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Pal.gold, foregroundColor: Colors.black87, padding: EdgeInsets.zero),
                            onPressed: () => _sendCoins(n),
                            child: Text('$n 🪙', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          ),
                        ),
                      ),
                    ),
                ]),
              ]),
            ),
          ),
        ]),
      ),
    );
  }
}

// ================= القصص =================
const List<List<Color>> kStoryStyles = [
  [Color(0xFF6A1B9A), Color(0xFFD81B60)],
  [Color(0xFF00897B), Color(0xFF26C6DA)],
  [Color(0xFFFF8F00), Color(0xFFE53935)],
  [Color(0xFF1E88E5), Color(0xFF5E35B1)],
  [Color(0xFF43A047), Color(0xFFFFEB3B)],
  [Color(0xFF263238), Color(0xFF546E7A)],
];

class Story {
  final SeatInfo owner;
  final String text;
  final int style;
  final DateTime time;
  Story(this.owner, this.text, this.style, this.time);
}

class StoryService {
  static final List<Story> stories = [];
  static bool _seeded = false;

  static void seed() {
    if (_seeded) return;
    _seeded = true;
    const texts = [
      'يوم جميل للعب 🎲',
      'من يتحداني في الكيرم؟ 🎯',
      'فزت للتو في الدومينو 🏆',
      'صباح الخير يا أصدقاء ☀️',
      'جولة لودو الليلة؟ 🌙',
      'أحب سلم وثعبان 🐍',
      'شكراً على الورود 🌹',
      'أهلاً بالجميع 👋',
    ];
    for (int i = 0; i < texts.length && i < Bots.pool.length; i++) {
      stories.add(Story(Bots.pool[i], texts[i], i % kStoryStyles.length, DateTime.now().subtract(Duration(hours: i * 2 + 1))));
    }
  }

  static List<Story> active() =>
      stories.where((s) => DateTime.now().difference(s.time).inHours < 24).toList();

  static bool _same(SeatInfo a, SeatInfo b) => a.isMe == b.isMe && (a.isMe || a.name == b.name);

  static bool hasStory(SeatInfo s) => active().any((x) => _same(x.owner, s));
}

String _ago(DateTime t) {
  final m = DateTime.now().difference(t).inMinutes;
  if (m < 1) return 'الآن';
  if (m < 60) return 'قبل $m دقيقة';
  return 'قبل ${m ~/ 60} ساعة';
}

class StoriesBar extends StatefulWidget {
  const StoriesBar({super.key});

  @override
  State<StoriesBar> createState() => _StoriesBarState();
}

class _StoriesBarState extends State<StoriesBar> {
  @override
  void initState() {
    super.initState();
    StoryService.seed();
  }

  List<List<Story>> _groups() {
    final map = <String, List<Story>>{};
    for (final s in StoryService.active()) {
      final k = s.owner.isMe ? 'me' : s.owner.name;
      map.putIfAbsent(k, () => <Story>[]).add(s);
    }
    final keys = map.keys.toList();
    keys.sort((a, b) => a == 'me' ? -1 : (b == 'me' ? 1 : 0));
    return keys.map((k) => map[k]!).toList();
  }

  void _open(List<List<Story>> groups, int idx) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => StoryViewer(groups: groups, start: idx)))
        .then((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final groups = _groups();
    final hasMine = groups.isNotEmpty && groups.first.first.owner.isMe;
    final me = AppState.I.meSeat;
    return SizedBox(
      height: 92,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 14),
            child: Column(children: [
              GestureDetector(
                onTap: () => hasMine ? _open(groups, 0) : showCreateStory(context, () => setState(() {})),
                child: Stack(clipBehavior: Clip.none, children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: hasMine ? const LinearGradient(colors: [Pal.gold, Color(0xFFFF5F8D)]) : null,
                      border: hasMine ? null : Border.all(color: Colors.white24, width: 2),
                    ),
                    child: AvatarView(id: me.avatar, size: 52),
                  ),
                  PositionedDirectional(
                    bottom: -2,
                    end: -2,
                    child: GestureDetector(
                      onTap: () => showCreateStory(context, () => setState(() {})),
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Pal.gold,
                          border: Border.all(color: Pal.bg, width: 2),
                        ),
                        child: const Icon(Icons.add, size: 16, color: Colors.black87),
                      ),
                    ),
                  ),
                ]),
              ),
              const SizedBox(height: 4),
              const Text('قصتي', style: TextStyle(color: Colors.white70, fontSize: 11)),
            ]),
          ),
          for (int i = 0; i < groups.length; i++)
            if (!groups[i].first.owner.isMe)
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 14),
                child: GestureDetector(
                  onTap: () => _open(groups, i),
                  child: Column(children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(colors: [Pal.gold, Color(0xFFFF5F8D)]),
                      ),
                      child: AvatarView(id: groups[i].first.owner.avatar, size: 52),
                    ),
                    const SizedBox(height: 4),
                    Text(groups[i].first.owner.name, style: const TextStyle(color: Colors.white70, fontSize: 11)),
                  ]),
                ),
              ),
        ],
      ),
    );
  }
}

void showCreateStory(BuildContext context, VoidCallback onDone) {
  final ctrl = TextEditingController();
  int style = 0;
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Pal.card,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (ctx) => rtl(StatefulBuilder(
      builder: (ctx, setS) => Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + MediaQuery.of(ctx).viewInsets.bottom),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('قصة جديدة', style: TextStyle(color: Pal.gold, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Container(
            height: 140,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: LinearGradient(colors: kStoryStyles[style]),
            ),
            child: TextField(
              controller: ctrl,
              maxLength: 120,
              maxLines: 3,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                hintText: 'اكتب قصتك هنا...',
                hintStyle: TextStyle(color: Colors.white54),
                counterText: '',
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            for (int i = 0; i < kStoryStyles.length; i++)
              GestureDetector(
                onTap: () => setS(() => style = i),
                child: Container(
                  width: 34,
                  height: 34,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: kStoryStyles[i]),
                    border: Border.all(color: style == i ? Colors.white : Colors.transparent, width: 2.5),
                  ),
                ),
              ),
          ]),
          const SizedBox(height: 14),
          GoldButton(
            label: 'نشر القصة',
            onTap: () {
              final t = ctrl.text.trim();
              if (t.isEmpty) return;
              StoryService.stories.add(Story(AppState.I.meSeat, t, style, DateTime.now()));
              Navigator.of(ctx).pop();
              onDone();
            },
          ),
        ]),
      ),
    )),
  );
}

class StoryViewer extends StatefulWidget {
  final List<List<Story>> groups;
  final int start;
  const StoryViewer({super.key, required this.groups, required this.start});

  @override
  State<StoryViewer> createState() => _StoryViewerState();
}

class _StoryViewerState extends State<StoryViewer> {
  int g = 0, i = 0;
  double p = 0;
  Timer? t;

  @override
  void initState() {
    super.initState();
    g = widget.start;
    _restart();
  }

  @override
  void dispose() {
    t?.cancel();
    super.dispose();
  }

  void _restart() {
    t?.cancel();
    p = 0;
    t = Timer.periodic(const Duration(milliseconds: 50), (_) {
      if (!mounted) return;
      setState(() => p += 0.05 / 4.0);
      if (p >= 1) _next();
    });
  }

  void _next() {
    final groups = widget.groups;
    if (i + 1 < groups[g].length) {
      setState(() => i++);
      _restart();
    } else if (g + 1 < groups.length) {
      setState(() {
        g++;
        i = 0;
      });
      _restart();
    } else {
      t?.cancel();
      Navigator.of(context).pop();
    }
  }

  void _prev() {
    if (i > 0) {
      setState(() => i--);
    } else if (g > 0) {
      setState(() {
        g--;
        i = widget.groups[g].length - 1;
      });
    }
    _restart();
  }

  @override
  Widget build(BuildContext context) {
    final grp = widget.groups[g];
    final s = grp[i];
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapUp: (d) {
          final w = MediaQuery.of(context).size.width;
          if (d.globalPosition.dx > w / 2) {
            _next();
          } else {
            _prev();
          }
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: kStoryStyles[s.style % kStoryStyles.length]),
          ),
          child: SafeArea(
            child: rtl(Stack(children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Text(s.text,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800, height: 1.5)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                child: Column(children: [
                  Row(children: [
                    for (int k = 0; k < grp.length; k++)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: LinearProgressIndicator(
                            value: k < i ? 1 : (k == i ? p.clamp(0.0, 1.0).toDouble() : 0),
                            minHeight: 3,
                            backgroundColor: Colors.white24,
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      ),
                  ]),
                  const SizedBox(height: 10),
                  Row(children: [
                    AvatarView(id: s.owner.avatar, size: 36),
                    const SizedBox(width: 8),
                    Text(s.owner.isMe ? 'قصتي' : s.owner.name,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    Text(_ago(s.time), style: const TextStyle(color: Colors.white70, fontSize: 12)),
                    const Spacer(),
                    IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.of(context).pop()),
                  ]),
                ]),
              ),
            ])),
          ),
        ),
      ),
    );
  }
}

// ================= LUDO =================
const List<Color> kLudoColors = [
  Color(0xFFE53935), // أحمر (أعلى اليسار)
  Color(0xFF43A047), // أخضر (أعلى اليمين)
  Color(0xFF1E88E5), // أزرق (أسفل اليمين)
  Color(0xFFFBC02D), // أصفر (أسفل اليسار)
];

/// مسار اللعب الرئيسي: 52 خانة، كل عنصر [صف، عمود]
const List<List<int>> kLudoPath = [
  [6, 1], [6, 2], [6, 3], [6, 4], [6, 5],
  [5, 6], [4, 6], [3, 6], [2, 6], [1, 6], [0, 6],
  [0, 7], [0, 8],
  [1, 8], [2, 8], [3, 8], [4, 8], [5, 8],
  [6, 9], [6, 10], [6, 11], [6, 12], [6, 13], [6, 14],
  [7, 14], [8, 14],
  [8, 13], [8, 12], [8, 11], [8, 10], [8, 9],
  [9, 8], [10, 8], [11, 8], [12, 8], [13, 8], [14, 8],
  [14, 7], [14, 6],
  [13, 6], [12, 6], [11, 6], [10, 6], [9, 6],
  [8, 5], [8, 4], [8, 3], [8, 2], [8, 1], [8, 0],
  [7, 0], [6, 0],
];

/// ممرات المنزل الخمسة لكل لاعب [صف، عمود]
const List<List<List<int>>> kLudoHome = [
  [[7, 1], [7, 2], [7, 3], [7, 4], [7, 5]],
  [[1, 7], [2, 7], [3, 7], [4, 7], [5, 7]],
  [[7, 13], [7, 12], [7, 11], [7, 10], [7, 9]],
  [[13, 7], [12, 7], [11, 7], [10, 7], [9, 7]],
];

class LudoBoardPainter extends CustomPainter {
  const LudoBoardPainter();

  static const List<int> starts = [0, 13, 26, 39];
  static const List<int> stars = [8, 21, 34, 47];
  static const List<Offset> yards = [Offset(0, 0), Offset(9, 0), Offset(9, 9), Offset(0, 9)];

  @override
  void paint(Canvas canvas, Size size) {
    final ce = size.width / 15;
    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xFFFFF8E1));

    // الزوايا (بيوت اللاعبين)
    for (int p = 0; p < 4; p++) {
      final o = yards[p];
      canvas.drawRect(Rect.fromLTWH(o.dx * ce, o.dy * ce, 6 * ce, 6 * ce), Paint()..color = kLudoColors[p]);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH((o.dx + 1) * ce, (o.dy + 1) * ce, 4 * ce, 4 * ce),
          Radius.circular(ce * 0.6),
        ),
        Paint()..color = Colors.white,
      );
      for (final dx in [2.0, 4.0]) {
        for (final dy in [2.0, 4.0]) {
          final c = Offset((o.dx + dx) * ce, (o.dy + dy) * ce);
          canvas.drawCircle(c, ce * 0.5, Paint()..color = kLudoColors[p].withOpacity(0.25));
          canvas.drawCircle(
            c,
            ce * 0.5,
            Paint()
              ..color = kLudoColors[p].withOpacity(0.7)
              ..style = PaintingStyle.stroke
              ..strokeWidth = 1.5,
          );
        }
      }
    }

    final border = Paint()
      ..color = Colors.black26
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.7;

    // خانات ممرات المنزل
    for (int p = 0; p < 4; p++) {
      for (final h in kLudoHome[p]) {
        final r = Rect.fromLTWH(h[1] * ce, h[0] * ce, ce, ce);
        canvas.drawRect(r, Paint()..color = kLudoColors[p].withOpacity(0.85));
        canvas.drawRect(r, border);
      }
    }

    // المسار الرئيسي
    for (int i = 0; i < 52; i++) {
      final cell = kLudoPath[i];
      final r = Rect.fromLTWH(cell[1] * ce, cell[0] * ce, ce, ce);
      final sp = starts.indexOf(i);
      canvas.drawRect(r, Paint()..color = sp >= 0 ? kLudoColors[sp] : const Color(0xFFFFFDF5));
      canvas.drawRect(r, border);
      if (stars.contains(i) || sp >= 0) {
        canvas.drawPath(
          starPath(r.center, ce * 0.32),
          Paint()..color = sp >= 0 ? Colors.white70 : const Color(0xFFFFB300),
        );
      }
    }

    // المثلثات في المنتصف
    final c = Offset(7.5 * ce, 7.5 * ce);
    final tl = Offset(6 * ce, 6 * ce);
    final tr = Offset(9 * ce, 6 * ce);
    final bl = Offset(6 * ce, 9 * ce);
    final br = Offset(9 * ce, 9 * ce);
    void tri(Offset a, Offset b, Color col) {
      final path = Path()
        ..moveTo(a.dx, a.dy)
        ..lineTo(b.dx, b.dy)
        ..lineTo(c.dx, c.dy)
        ..close();
      canvas.drawPath(path, Paint()..color = col);
      canvas.drawPath(path, border);
    }

    tri(tl, bl, kLudoColors[0]); // يسار: أحمر
    tri(tl, tr, kLudoColors[1]); // أعلى: أخضر
    tri(tr, br, kLudoColors[2]); // يمين: أزرق
    tri(bl, br, kLudoColors[3]); // أسفل: أصفر
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LudoToken {
  final int p, i;
  final Offset pos;
  final bool movable;
  _LudoToken(this.p, this.i, this.pos, this.movable);
}

class LudoRoyalFull extends StatefulWidget {
  const LudoRoyalFull({super.key});

  @override
  State<LudoRoyalFull> createState() => _LudoState();
}

class _LudoState extends State<LudoRoyalFull> with SingleTickerProviderStateMixin {
  static const List<int> startIdx = [0, 13, 26, 39];
  static const Set<int> safeCells = {0, 13, 26, 39, 8, 21, 34, 47};
  final List<SeatInfo> seats = Seats.players(4);
  List<String> get names => seats.map((s) => s.name).toList();
  static const List<Offset> yard = [Offset(0, 0), Offset(9, 0), Offset(9, 9), Offset(0, 9)];

  final math.Random rnd = math.Random();
  late final AnimationController pulse;

  /// -1 = في البيت ، 0..50 = على المسار (نسبةً لخانة البداية) ، 51..55 = ممر المنزل ، 56 = وصلت
  List<List<int>> tokens = List.generate(4, (_) => List.filled(4, -1));
  int dice = 1, turn = 0, sixes = 0, gen = 0;
  bool rolling = false, busy = false, waitingMove = false, gameOver = false;
  String msg = 'اضغط على النرد لتبدأ';
  List<int> movable = [];
  final List<String> publicChat = ['سلطان: هلا بالجميع 💪'];

  @override
  void initState() {
    super.initState();
    pulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    gen++;
    pulse.dispose();
    super.dispose();
  }

  bool get canRoll => turn == 0 && !rolling && !busy && !waitingMove && !gameOver;

  int homeCount(int p) => tokens[p].where((r) => r == 56).length;

  // ---------- الرمي ----------
  void roll() {
    if (turn != 0) return;
    _doRoll();
  }

  void _doRoll() {
    if (rolling || busy || waitingMove || gameOver) return;
    final g = gen;
    setState(() {
      rolling = true;
      msg = turn == 0 ? 'جاري رمي النرد...' : '${names[turn]} يرمي النرد...';
    });
    SoundManager.dice();
    int ticks = 0;
    Timer.periodic(const Duration(milliseconds: 70), (t) {
      if (!mounted || g != gen) {
        t.cancel();
        return;
      }
      ticks++;
      if (ticks < 9) {
        setState(() => dice = rnd.nextInt(6) + 1);
      } else {
        t.cancel();
        setState(() {
          dice = rnd.nextInt(6) + 1;
          rolling = false;
        });
        _afterRoll();
      }
    });
  }

  bool _canMove(int p, int i, int d) {
    final r = tokens[p][i];
    if (r == 56) return false;
    if (r == -1) return d == 6;
    return r + d <= 56;
  }

  List<int> _movable(int p, int d) {
    final res = <int>[];
    for (int i = 0; i < 4; i++) {
      if (_canMove(p, i, d)) res.add(i);
    }
    return res;
  }

  Future<void> _afterRoll() async {
    final g = gen;
    if (dice == 6) {
      sixes++;
    } else {
      sixes = 0;
    }
    if (sixes >= 3) {
      setState(() => msg = 'ثلاث ستات متتالية! ضاع الدور');
      _endTurn(false);
      return;
    }
    final opts = _movable(turn, dice);
    if (opts.isEmpty) {
      setState(() => msg = 'لا توجد حركة متاحة');
      _endTurn(false);
      return;
    }
    if (turn == 0) {
      setState(() {
        movable = opts;
        waitingMove = true;
        msg = 'اختر قطعة للتحريك';
      });
      if (opts.length == 1) {
        await Future.delayed(const Duration(milliseconds: 450));
        if (!mounted || g != gen || !waitingMove) return;
        _move(0, opts.first);
      }
    } else {
      await Future.delayed(const Duration(milliseconds: 650));
      if (!mounted || g != gen) return;
      _move(turn, _botPick(turn, opts));
    }
  }

  // ---------- الحركة ----------
  void _tapToken(int p, int i) {
    if (p != 0 || turn != 0 || !waitingMove || !movable.contains(i)) return;
    _move(0, i);
  }

  Future<void> _move(int p, int i) async {
    final g = gen;
    setState(() {
      busy = true;
      waitingMove = false;
      movable = [];
    });
    final r = tokens[p][i];
    if (r == -1) {
      setState(() => tokens[p][i] = 0);
      SoundManager.move();
      await Future.delayed(const Duration(milliseconds: 250));
      if (!mounted || g != gen) return;
    } else {
      for (int s = 0; s < dice; s++) {
        await Future.delayed(const Duration(milliseconds: 150));
        if (!mounted || g != gen) return;
        setState(() => tokens[p][i] = tokens[p][i] + 1);
        if (p == 0) SoundManager.move();
      }
    }

    bool bonus = false;
    final rel = tokens[p][i];

    // الأكل
    if (rel >= 0 && rel <= 50) {
      final cell = (startIdx[p] + rel) % 52;
      if (!safeCells.contains(cell)) {
        for (int q = 0; q < 4; q++) {
          if (q == p) continue;
          for (int j = 0; j < 4; j++) {
            final rq = tokens[q][j];
            if (rq >= 0 && rq <= 50 && (startIdx[q] + rq) % 52 == cell) {
              setState(() {
                tokens[q][j] = -1;
                msg = '${names[p]} أكل قطعة ${names[q]}! 🔥';
              });
              SoundManager.oops();
              bonus = true;
            }
          }
        }
      }
    }

    if (rel == 56) {
      bonus = true;
      setState(() => msg = '${names[p]} أوصل قطعة للمنزل! 🏠');
    }

    // الفوز
    if (tokens[p].every((x) => x == 56)) {
      setState(() {
        gameOver = true;
        busy = false;
        msg = 'فاز ${names[p]}!';
      });
      if (p == 0) {
        UserData.win();
      } else {
        UserData.lose();
      }
      if (!mounted) return;
      showWinDialog(
        context,
        p == 0 ? '🏆 مبروك، لقد فزت!' : 'انتهت اللعبة',
        p == 0 ? 'ربحت 20 عملة. هل تلعب مرة أخرى؟' : 'خسرت 10 عملات. الفائز هو ${names[p]}. حظاً أوفر في المرة القادمة!',
        _reset,
      );
      return;
    }

    _endTurn(bonus || dice == 6);
  }

  Future<void> _endTurn(bool extra) async {
    final g = gen;
    setState(() {
      busy = true;
      waitingMove = false;
      movable = [];
    });
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted || g != gen) return;
    setState(() {
      if (!extra) {
        turn = (turn + 1) % 4;
        sixes = 0;
      }
      busy = false;
      msg = turn == 0 ? 'دورك! اضغط على النرد' : 'دور ${names[turn]}';
    });
    if (turn != 0 && !gameOver) {
      await Future.delayed(const Duration(milliseconds: 600));
      if (!mounted || g != gen) return;
      _doRoll();
    }
  }

  // ---------- ذكاء اللاعب الآلي ----------
  bool _danger(int p, int rel) {
    if (rel < 0 || rel > 50) return false;
    final cell = (startIdx[p] + rel) % 52;
    if (safeCells.contains(cell)) return false;
    for (int q = 0; q < 4; q++) {
      if (q == p) continue;
      for (final rq in tokens[q]) {
        if (rq < 0 || rq > 50) continue;
        final a = (startIdx[q] + rq) % 52;
        final dist = (cell - a + 52) % 52;
        if (dist >= 1 && dist <= 6) return true;
      }
    }
    return false;
  }

  int _capturesAt(int p, int rel) {
    if (rel < 0 || rel > 50) return 0;
    final cell = (startIdx[p] + rel) % 52;
    if (safeCells.contains(cell)) return 0;
    int n = 0;
    for (int q = 0; q < 4; q++) {
      if (q == p) continue;
      for (final rq in tokens[q]) {
        if (rq >= 0 && rq <= 50 && (startIdx[q] + rq) % 52 == cell) n++;
      }
    }
    return n;
  }

  int _botPick(int p, List<int> opts) {
    int best = opts.first;
    double bestScore = -1e9;
    for (final i in opts) {
      final r = tokens[p][i];
      final nr = r == -1 ? 0 : r + dice;
      double s = 0;
      if (nr == 56) s += 100;
      if (r == -1) s += 40;
      s += _capturesAt(p, nr) * 80;
      if (nr >= 51 && nr < 56) s += 20;
      if (r >= 0 && _danger(p, r)) s += 18;
      if (_danger(p, nr)) s -= 14;
      if (nr <= 50 && safeCells.contains((startIdx[p] + nr) % 52)) s += 8;
      s += nr * 0.3;
      s += rnd.nextDouble() * 3;
      if (s > bestScore) {
        bestScore = s;
        best = i;
      }
    }
    return best;
  }

  void _reset() {
    gen++;
    setState(() {
      tokens = List.generate(4, (_) => List.filled(4, -1));
      dice = 1;
      turn = 0;
      sixes = 0;
      rolling = false;
      busy = false;
      waitingMove = false;
      gameOver = false;
      movable = [];
      msg = 'اضغط على النرد لتبدأ';
    });
  }

  // ---------- الرسم ----------
  Offset _tokenUnit(int p, int i) {
    final r = tokens[p][i];
    if (r == -1) {
      final o = yard[p];
      return Offset(o.dx + (i % 2 == 0 ? 2 : 4), o.dy + (i < 2 ? 2 : 4));
    }
    if (r <= 50) {
      final cell = kLudoPath[(startIdx[p] + r) % 52];
      return Offset(cell[1] + 0.5, cell[0] + 0.5);
    }
    final h = kLudoHome[p][r - 51];
    return Offset(h[1] + 0.5, h[0] + 0.5);
  }

  List<Widget> _buildTokens(double ce) {
    final entries = <_LudoToken>[];
    for (int p = 0; p < 4; p++) {
      for (int i = 0; i < 4; i++) {
        if (tokens[p][i] == 56) continue;
        final mv = p == 0 && turn == 0 && waitingMove && movable.contains(i);
        entries.add(_LudoToken(p, i, _tokenUnit(p, i), mv));
      }
    }
    final groups = <String, List<_LudoToken>>{};
    for (final e in entries) {
      final key = '${e.pos.dx.toStringAsFixed(2)},${e.pos.dy.toStringAsFixed(2)}';
      groups.putIfAbsent(key, () => <_LudoToken>[]).add(e);
    }
    final placed = <Widget>[];
    final sorted = [...entries]..sort((a, b) => (a.movable ? 1 : 0).compareTo(b.movable ? 1 : 0));
    for (final e in sorted) {
      final key = '${e.pos.dx.toStringAsFixed(2)},${e.pos.dy.toStringAsFixed(2)}';
      final grp = groups[key]!;
      final k = grp.indexOf(e);
      final n = grp.length;
      double ox = 0, oy = 0;
      if (n > 1) {
        ox = ((k % 2) - 0.5) * 0.42;
        oy = (((k ~/ 2) % 2) - 0.5) * 0.42;
      }
      final sz = ce * (n > 1 ? 0.52 : 0.76);
      final col = kLudoColors[e.p];
      placed.add(AnimatedPositioned(
        key: ValueKey('tk${e.p}_${e.i}'),
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        left: (e.pos.dx + ox) * ce - sz / 2,
        top: (e.pos.dy + oy) * ce - sz / 2,
        width: sz,
        height: sz,
        child: GestureDetector(
          onTap: () => _tapToken(e.p, e.i),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                center: const Alignment(-0.3, -0.3),
                colors: [Colors.white.withOpacity(0.85), col, Color.lerp(col, Colors.black, 0.35)!],
                stops: const [0.0, 0.45, 1.0],
              ),
              border: Border.all(
                color: e.movable ? const Color(0xFFFFD700) : Colors.white,
                width: e.movable ? 2.5 : 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: e.movable
                      ? const Color(0xFFFFD700).withOpacity(0.4 + 0.5 * pulse.value)
                      : Colors.black38,
                  blurRadius: e.movable ? 8 + 6 * pulse.value : 3,
                  spreadRadius: e.movable ? 1 + 2 * pulse.value : 0,
                ),
              ],
            ),
          ),
        ),
      ));
    }
    return placed;
  }

  @override
  Widget build(BuildContext context) {
    return GameFrame(
      boardFrac: 0.47,
      top: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(color: Pal.card, borderRadius: BorderRadius.circular(8)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(msg,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.amber, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 8),
              Text('الدور: ${names[turn]}', style: const TextStyle(color: Colors.white, fontSize: 11)),
            ],
          ),
        ),
      badges: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              4,
              (p) => PlayerBadge(
                name: names[p],
                avatar: seats[p].avatar,
                color: kLudoColors[p],
                badge: '${homeCount(p)}/4',
                active: turn == p && !gameOver,
                seat: seats[p],
                onKick: p == 0 ? null : () => setState(() => seats[p] = Seats.replacement(seats)),
              ),
            ),
          ),
        ),
      board: LayoutBuilder(builder: (context, cons) {
            final bs = math.min(cons.maxWidth - 16, cons.maxHeight - 8);
            if (bs <= 0) return const SizedBox.shrink();
            return Center(
              child: Container(
                width: bs,
                height: bs,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFFFD700), width: 3),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 10)],
                ),
                child: LayoutBuilder(builder: (c, inner) {
                  final ce = inner.maxWidth / 15;
                  return AnimatedBuilder(
                    animation: pulse,
                    builder: (context, _) => Stack(
                      children: [
                        const Positioned.fill(child: CustomPaint(painter: LudoBoardPainter())),
                        ..._buildTokens(ce),
                        Positioned(
                          left: 6 * ce,
                          top: 6 * ce,
                          width: 3 * ce,
                          height: 3 * ce,
                          child: Center(
                            child: DiceFace(
                              value: dice,
                              size: ce * 2.0,
                              accent: kLudoColors[turn],
                              active: canRoll,
                              rolling: rolling,
                              onTap: roll,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            );
          }),
      chat: ChatPanel(messages: publicChat),
      bar: ChatAndControlsBar(
          onSendChat: (txt) {
            setState(() => publicChat.add('${AppState.I.myName}: $txt'));
            Future.delayed(const Duration(milliseconds: 1200), () {
              if (!mounted) return;
              setState(() => publicChat.add('${names[1 + rnd.nextInt(3)]}: ${BotChat.random()}'));
            });
          },
          onSendEmoji: (em) => setState(() => publicChat.add('${AppState.I.myName}: $em')),
          onSendRose: () => showRoseFeedback(context),
        ),
    );
  }
}


// ================= CARROM : المحرك الفيزيائي =================
// كل الإحداثيات مقيسة على لوحة مربعة طولها 1.0

enum CKind { white, black, queen, striker }

class CPiece {
  Offset pos;
  Offset vel = Offset.zero;
  final CKind kind;
  final double r;
  final double mass;
  bool out = false;

  CPiece(this.pos, CKind k)
      : kind = k,
        r = k == CKind.striker ? 0.036 : 0.027,
        mass = k == CKind.striker ? 1.8 : 1.0;

  bool get moving => vel != Offset.zero;
}

class AimInfo {
  Offset dir = Offset.zero;
  double power = 0;
  bool visible = false;
}

class BotShot {
  final double x;
  final Offset dir;
  final double speed;
  BotShot(this.x, this.dir, this.speed);
}

class CarromEngine {
  static const double wallMin = 0.06;
  static const double wallMax = 0.94;
  static const double captureDist = 0.052;
  static const double drag = 1.3;
  static const double stopSpeed = 0.02;
  static const double wallE = 0.8;
  static const double pieceE = 0.92;
  static const List<Offset> pockets = [
    Offset(0.07, 0.07),
    Offset(0.93, 0.07),
    Offset(0.07, 0.93),
    Offset(0.93, 0.93),
  ];

  final List<CPiece> pieces = [];
  late CPiece striker;
  double lastImpact = 0;

  CarromEngine() {
    reset();
  }

  List<CPiece> get all => [...pieces, striker];

  bool get anyMoving => all.any((p) => !p.out && p.moving);

  void reset() {
    pieces.clear();
    const c = Offset(0.5, 0.5);
    pieces.add(CPiece(c, CKind.queen));
    final d = 0.027 * 2 * 1.03;
    for (int k = 0; k < 6; k++) {
      final a = k * math.pi / 3 + math.pi / 2;
      // الحلقة الداخلية: أسود وأبيض بالتناوب
      pieces.add(CPiece(
        c + Offset(math.cos(a), math.sin(a)) * d,
        k.isEven ? CKind.black : CKind.white,
      ));
      // الحلقة الخارجية: بيضاء على نفس الزاوية
      pieces.add(CPiece(
        c + Offset(math.cos(a), math.sin(a)) * (2 * d),
        CKind.white,
      ));
      // الحلقة الخارجية: سوداء بين كل قطعتين
      final b = a + math.pi / 6;
      pieces.add(CPiece(
        c + Offset(math.cos(b), math.sin(b)) * (math.sqrt(3) * d),
        CKind.black,
      ));
    }
    striker = CPiece(const Offset(0.5, 0.80), CKind.striker);
  }

  // ---------- الفيزياء ----------
  /// يحرّك المحاكاة ويرجع القطع التي سقطت في الجيوب أثناء هذه الخطوة
  List<CPiece> step(double dt) {
    final newly = <CPiece>[];
    lastImpact = 0;
    const sub = 4;
    final h = dt / sub;
    final items = all;
    for (int s = 0; s < sub; s++) {
      for (final p in items) {
        if (p.out) continue;
        if (p.moving) p.pos = p.pos + p.vel * h;
        _wall(p);
      }
      for (int a = 0; a < items.length; a++) {
        final pa = items[a];
        if (pa.out) continue;
        for (int b = a + 1; b < items.length; b++) {
          final pb = items[b];
          if (pb.out) continue;
          _collide(pa, pb);
        }
      }
      final damp = math.exp(-drag * h);
      for (final p in items) {
        if (p.out || !p.moving) continue;
        p.vel = p.vel * damp;
        if (p.vel.distance < stopSpeed) p.vel = Offset.zero;
        for (final pk in pockets) {
          if ((p.pos - pk).distance < captureDist) {
            p.out = true;
            p.vel = Offset.zero;
            newly.add(p);
            break;
          }
        }
      }
    }
    return newly;
  }

  void _wall(CPiece p) {
    final lo = wallMin + p.r;
    final hi = wallMax - p.r;
    double x = p.pos.dx, y = p.pos.dy, vx = p.vel.dx, vy = p.vel.dy;
    if (x < lo) {
      x = lo;
      if (vx < 0) vx = -vx * wallE;
    } else if (x > hi) {
      x = hi;
      if (vx > 0) vx = -vx * wallE;
    }
    if (y < lo) {
      y = lo;
      if (vy < 0) vy = -vy * wallE;
    } else if (y > hi) {
      y = hi;
      if (vy > 0) vy = -vy * wallE;
    }
    p.pos = Offset(x, y);
    p.vel = Offset(vx, vy);
  }

  void _collide(CPiece a, CPiece b) {
    final d = b.pos - a.pos;
    final dist = d.distance;
    final minD = a.r + b.r;
    if (dist >= minD) return;
    final Offset n = dist < 1e-9 ? const Offset(1, 0) : d / dist;
    final overlap = minD - dist;
    final tm = a.mass + b.mass;
    a.pos = a.pos - n * (overlap * b.mass / tm);
    b.pos = b.pos + n * (overlap * a.mass / tm);
    final rv = (b.vel.dx - a.vel.dx) * n.dx + (b.vel.dy - a.vel.dy) * n.dy;
    if (rv >= 0) return;
    final j = -(1 + pieceE) * rv / (1 / a.mass + 1 / b.mass);
    a.vel = a.vel - n * (j / a.mass);
    b.vel = b.vel + n * (j / b.mass);
    if (-rv > lastImpact) lastImpact = -rv;
  }

  // ---------- أدوات مساعدة ----------
  /// المسافة التي يقطعها القاطع من نقطة o باتجاه dir حتى أول قطعة أو جدار
  double rayDistance(Offset o, Offset dir) {
    double best = 2.0;
    final lo = wallMin + striker.r;
    final hi = wallMax - striker.r;
    if (dir.dx > 1e-9) best = math.min(best, (hi - o.dx) / dir.dx);
    if (dir.dx < -1e-9) best = math.min(best, (lo - o.dx) / dir.dx);
    if (dir.dy > 1e-9) best = math.min(best, (hi - o.dy) / dir.dy);
    if (dir.dy < -1e-9) best = math.min(best, (lo - o.dy) / dir.dy);
    for (final p in pieces) {
      if (p.out) continue;
      final rr = p.r + striker.r;
      final oc = p.pos - o;
      final tca = oc.dx * dir.dx + oc.dy * dir.dy;
      if (tca <= 0) continue;
      final d2 = oc.dx * oc.dx + oc.dy * oc.dy - tca * tca;
      if (d2 > rr * rr) continue;
      final t = tca - math.sqrt(rr * rr - d2);
      if (t > 0 && t < best) best = t;
    }
    return best < 0 ? 0 : best;
  }

  double _segDist(Offset p, Offset a, Offset b) {
    final ab = b - a;
    final l2 = ab.dx * ab.dx + ab.dy * ab.dy;
    if (l2 < 1e-12) return (p - a).distance;
    final t = (((p.dx - a.dx) * ab.dx + (p.dy - a.dy) * ab.dy) / l2).clamp(0.0, 1.0).toDouble();
    return (p - (a + ab * t)).distance;
  }

  bool _pathClear(Offset a, Offset b, double radius, CPiece ignore) {
    for (final p in pieces) {
      if (p.out || identical(p, ignore)) continue;
      if (_segDist(p.pos, a, b) < p.r + radius + 0.004) return false;
    }
    return true;
  }

  bool _free(Offset c, double r, CPiece self) {
    for (final q in all) {
      if (identical(q, self) || q.out) continue;
      if ((q.pos - c).distance < q.r + r + 0.002) return false;
    }
    return true;
  }

  /// يعيد قطعة سقطت (أو الملكة) إلى منتصف اللوحة في أقرب مكان فارغ
  void respawn(CPiece p) {
    p.out = false;
    p.vel = Offset.zero;
    const c = Offset(0.5, 0.5);
    for (int ring = 0; ring < 6; ring++) {
      final n = ring == 0 ? 1 : ring * 8;
      for (int k = 0; k < n; k++) {
        final a = 2 * math.pi * k / n;
        final cand = ring == 0 ? c : c + Offset(math.cos(a), math.sin(a)) * (ring * 0.06);
        if (_free(cand, p.r, p)) {
          p.pos = cand;
          return;
        }
      }
    }
    p.pos = c;
  }

  // ---------- ذكاء اللاعب الآلي (يلعب من الأعلى) ----------
  BotShot planBotShot(CKind own, math.Random rnd) {
    const y = 0.20;
    BotShot? best;
    double bestScore = -1e9;
    final targets = pieces.where((p) => !p.out && (p.kind == own || p.kind == CKind.queen)).toList();
    for (int xi = 0; xi < 9; xi++) {
      final x = 0.24 + xi * 0.06;
      final from = Offset(x, y);
      for (final t in targets) {
        for (final pk in pockets) {
          final toPocket = pk - t.pos;
          final dp = toPocket.distance;
          if (dp < 1e-6) continue;
          final u = toPocket / dp;
          final ghost = t.pos - u * (t.r + striker.r);
          final sv = ghost - from;
          final ds = sv.distance;
          if (ds < 1e-6) continue;
          final dir = sv / ds;
          final cosA = dir.dx * u.dx + dir.dy * u.dy;
          if (cosA < 0.35) continue;
          if (!_pathClear(from, ghost, striker.r, t)) continue;
          if (!_pathClear(t.pos, pk, t.r, t)) continue;
          final score = cosA * 3 - ds - dp * 1.2 + (t.kind == CKind.queen ? 0.3 : 0.0) + rnd.nextDouble() * 0.4;
          if (score > bestScore) {
            bestScore = score;
            final sp = ((ds + dp) * drag * 1.6).clamp(1.4, 3.3).toDouble();
            best = BotShot(x, dir, sp);
          }
        }
      }
    }
    if (best != null) return best;

    // لا توجد تصويبة جيدة: اضرب أقرب قطعة
    final from = Offset(0.5, y);
    CPiece? nearest;
    double nd = 9;
    final pool = pieces.where((p) => !p.out).toList();
    for (final p in pool) {
      final d = (p.pos - from).distance;
      if (d < nd) {
        nd = d;
        nearest = p;
      }
    }
    final target = nearest == null ? const Offset(0.5, 0.5) : nearest.pos;
    final v = target - from;
    final dist = v.distance;
    final dir = dist < 1e-6 ? const Offset(0, 1) : v / dist;
    return BotShot(0.5, dir, 2.0);
  }
}


// ================= CARROM : الواجهة والقواعد =================
class CarromProScreen extends StatefulWidget {
  const CarromProScreen({super.key});

  @override
  State<CarromProScreen> createState() => _CarromProScreenState();
}

class _CarromProScreenState extends State<CarromProScreen> {
  final CarromEngine eng = CarromEngine();
  final List<SeatInfo> seats = Seats.players(2);
  final math.Random rnd = math.Random();
  Timer? timer;

  bool myTurn = true, over = false, shotActive = false, shotByMe = true;
  int gen = 0;
  int queenBy = 0; // 0 لا أحد ، 1 أنت ، 2 الخصم
  double sliderX = 0.5;
  double boardPx = 300;
  Offset? pullStart, pullNow;
  List<CPiece> shotPocketed = [];
  String msg = 'دورك! اسحب بإصبعك لتحديد الاتجاه والقوة';

  final List<Map<String, String>> messages = [
    {"user": "ابن الاكابر", "text": "مرحباً بالجميع، سأنضم اليكم!"},
    {"user": "رحيل", "text": "بالتوفيق للجميع 🍀"},
  ];

  @override
  void initState() {
    super.initState();
    _placeStriker();
    timer = Timer.periodic(const Duration(milliseconds: 16), (_) => _tick());
  }

  @override
  void dispose() {
    gen++;
    timer?.cancel();
    super.dispose();
  }

  // ---------- حالة اللعبة ----------
  int _count(CKind k, {bool out = false}) =>
      eng.pieces.where((p) => p.kind == k && (!out || p.out)).length;

  int get myScore => _count(CKind.white, out: true) + (queenBy == 1 ? 3 : 0);
  int get botScore => _count(CKind.black, out: true) + (queenBy == 2 ? 3 : 0);

  bool get canShoot => myTurn && !shotActive && !over;

  void _placeStriker() {
    eng.striker.out = false;
    eng.striker.vel = Offset.zero;
    eng.striker.pos = myTurn ? Offset(sliderX, 0.80) : const Offset(0.5, 0.20);
    eng.step(0);
  }

  void _launch(Offset vel, bool byMe) {
    shotByMe = byMe;
    shotPocketed = [];
    eng.striker.vel = vel;
    shotActive = true;
  }

  void _tick() {
    if (!mounted || !shotActive) return;
    final out = eng.step(0.016);
    if (out.isNotEmpty) {
      shotPocketed.addAll(out);
      SoundManager.pocket();
    } else if (eng.lastImpact > 1.2) {
      SoundManager.hit();
    }
    if (!eng.anyMoving) {
      shotActive = false;
      _resolve();
    }
    setState(() {});
  }

  void _resolve() {
    final mineKind = shotByMe ? CKind.white : CKind.black;
    final who = shotByMe ? seats[0].name : seats[1].name;
    final foul = shotPocketed.any((p) => p.kind == CKind.striker);
    bool gotOwn = false;
    bool queenIn = false;
    for (final p in shotPocketed) {
      if (p.kind == CKind.queen) {
        queenIn = true;
        gotOwn = true;
      } else if (p.kind == mineKind) {
        gotOwn = true;
      }
    }
    String m;
    if (foul) {
      m = 'خطأ! القاطع سقط في الجيب';
      final pen = eng.pieces.where((p) => p.out && p.kind == mineKind).toList();
      if (pen.isNotEmpty) {
        eng.respawn(pen.last);
        m += ' وأُعيدت قطعة للوحة';
      }
      if (queenIn) {
        eng.respawn(eng.pieces.first);
        queenIn = false;
      }
    } else if (gotOwn) {
      m = '$who أسقط قطعة! يلعب مرة أخرى';
    } else if (shotPocketed.isNotEmpty) {
      m = 'سقطت قطعة الخصم، ينتقل الدور';
    } else {
      m = 'لم تسقط أي قطعة';
    }
    if (queenIn) {
      queenBy = shotByMe ? 1 : 2;
      m = '$who أسقط الملكة 👑 +3';
    }

    final whiteLeft = eng.pieces.where((p) => p.kind == CKind.white && !p.out).length;
    final blackLeft = eng.pieces.where((p) => p.kind == CKind.black && !p.out).length;
    if (whiteLeft == 0 || blackLeft == 0) {
      over = true;
      final iWon = whiteLeft == 0;
      msg = iWon ? 'فزت بالمباراة! 🏆' : 'فاز الخصم بالمباراة';
      if (iWon) {
        UserData.win();
      } else {
        UserData.lose();
      }
      eng.striker.out = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        showWinDialog(
          context,
          iWon ? '🏆 مبروك، لقد فزت!' : 'انتهت المباراة',
          iWon ? 'أسقطت كل قطعك البيضاء وربحت 20 عملة.' : 'أسقط الخصم كل قطعه وخسرت 10 عملات. حاول مرة أخرى!',
          _reset,
        );
      });
      return;
    }

    final extra = gotOwn && !foul;
    myTurn = extra ? shotByMe : !shotByMe;
    _placeStriker();
    msg = '$m — ${myTurn ? 'دورك' : 'دور الخصم'}';
    if (!myTurn) _botTurn();
  }

  Future<void> _botTurn() async {
    final g = gen;
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted || g != gen || over || myTurn) return;
    final shot = eng.planBotShot(CKind.black, rnd);
    eng.striker.pos = Offset(shot.x, 0.20);
    eng.step(0);
    setState(() {});
    await Future.delayed(const Duration(milliseconds: 650));
    if (!mounted || g != gen || over || myTurn) return;
    final a = (rnd.nextDouble() - 0.5) * 0.06;
    final d = shot.dir;
    final rd = Offset(d.dx * math.cos(a) - d.dy * math.sin(a), d.dx * math.sin(a) + d.dy * math.cos(a));
    setState(() {
      _launch(rd * shot.speed, false);
    });
  }

  void _reset() {
    gen++;
    setState(() {
      eng.reset();
      myTurn = true;
      over = false;
      shotActive = false;
      queenBy = 0;
      pullStart = null;
      pullNow = null;
      sliderX = 0.5;
      shotPocketed = [];
      msg = 'دورك! اسحب بإصبعك لتحديد الاتجاه والقوة';
      _placeStriker();
    });
  }

  // ---------- التحكم ----------
  void _panStart(DragStartDetails d) {
    if (!canShoot) return;
    final p = d.localPosition / boardPx;
    setState(() {
      pullStart = p;
      pullNow = p;
    });
  }

  void _panUpdate(DragUpdateDetails d) {
    if (pullStart == null) return;
    setState(() => pullNow = d.localPosition / boardPx);
  }

  void _panEnd(DragEndDetails _) {
    final s = pullStart, n = pullNow;
    setState(() {
      pullStart = null;
      pullNow = null;
    });
    if (s == null || n == null || !canShoot) return;
    final v = AppState.I.aimDirect ? n - s : s - n;
    final len = v.distance;
    if (len < 0.03) return;
    final power = (len / 0.30).clamp(0.0, 1.0).toDouble();
    final dir = v / len;
    SoundManager.hit();
    setState(() {
      _launch(dir * (0.9 + power * 2.9), true);
      msg = 'تم التصويب...';
    });
  }

  // ---------- الواجهة ----------
  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    return GameFrame(
      boardFrac: 0.45,
      top: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() => SoundManager.enabled = !SoundManager.enabled);
                },
                child: _topBtn(SoundManager.enabled ? Icons.vibration : Icons.volume_off),
              ),
              const SizedBox(width: 8),
              GestureDetector(onTap: _reset, child: _topBtn(Icons.refresh)),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(12)),
                  child: Text(
                    msg,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ),
              ),
            ],
          ),
        ),
      board: Center(
            child: LayoutBuilder(builder: (c, cons) {
              final bs = math.min(screenW - 24, cons.maxHeight);
              if (bs <= 0) return const SizedBox.shrink();
              boardPx = bs;
              return GestureDetector(
                onPanStart: _panStart,
                onPanUpdate: _panUpdate,
                onPanEnd: _panEnd,
                onPanCancel: () => setState(() {
                  pullStart = null;
                  pullNow = null;
                }),
                child: Container(
                  width: bs,
                  height: bs,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDEB887),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFFFFD700), width: 3.5),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 10, spreadRadius: 2)],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      children: [
                        const Positioned.fill(child: CustomPaint(painter: CarromBoardPainter())),
                        ...eng.pieces.where((p) => !p.out).map((p) => _pieceWidget(p, bs)),
                        if (!eng.striker.out) _pieceWidget(eng.striker, bs),
                        if (_aim(bs) != null) Positioned.fill(child: CustomPaint(painter: _aim(bs))),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
      midH: 44,
      mid: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 0),
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 14,
              activeTrackColor: const Color(0xFF883344),
              inactiveTrackColor: const Color(0xFF883344),
              disabledActiveTrackColor: const Color(0xFF55303A),
              disabledInactiveTrackColor: const Color(0xFF55303A),
              thumbColor: Colors.pinkAccent,
              disabledThumbColor: Colors.pink.shade200.withOpacity(0.4),
              overlayShape: SliderComponentShape.noOverlay,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
            ),
            child: Slider(
              value: sliderX,
              min: 0.22,
              max: 0.78,
              onChanged: canShoot
                  ? (v) => setState(() {
                        sliderX = v;
                        _placeStriker();
                      })
                  : null,
            ),
          ),
        ),
      badges: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              PlayerBadge(name: '${seats[0].name} ⚪', color: Colors.blueGrey, avatar: seats[0].avatar, badge: '$myScore', active: myTurn && !over, seat: seats[0]),
              Text('${_count(CKind.white, out: true)} / ${_count(CKind.white)}   ·   ${_count(CKind.black, out: true)} / ${_count(CKind.black)}',
                  style: const TextStyle(color: Colors.white54, fontSize: 11)),
              PlayerBadge(name: '${seats[1].name} ⚫', color: Colors.deepPurple, avatar: seats[1].avatar, badge: '$botScore', active: !myTurn && !over, seat: seats[1], onKick: () => setState(() => seats[1] = Seats.replacement(seats))),
            ],
          ),
        ),
      chat: ChatPanel(messages: messages.map((m) => "${m['user']}: ${m['text']}").toList()),
      bar: ChatAndControlsBar(
          onSendChat: (txt) {
            setState(() => messages.add({"user": AppState.I.myName, "text": txt}));
            Future.delayed(const Duration(milliseconds: 1200), () {
              if (!mounted) return;
              setState(() => messages.add({"user": "رحيل", "text": BotChat.random()}));
            });
          },
          onSendEmoji: (em) => setState(() => messages.add({"user": AppState.I.myName, "text": em})),
          onSendRose: () => showRoseFeedback(context),
        ),
    );
  }

  Widget _topBtn(IconData i) => Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(8)),
        child: Icon(i, color: Colors.white70, size: 18),
      );

  _CarromAimPainter? _aim(double bs) {
    final s = pullStart, n = pullNow;
    if (s == null || n == null || !canShoot) return null;
    final v = AppState.I.aimDirect ? n - s : s - n;
    final len = v.distance;
    if (len < 0.015) return null;
    final dir = v / len;
    final from = eng.striker.pos;
    final dist = eng.rayDistance(from, dir);
    final power = (len / 0.30).clamp(0.0, 1.0).toDouble();
    return _CarromAimPainter(from * bs, (from + dir * dist) * bs, eng.striker.r * bs, power);
  }

  Widget _pieceWidget(CPiece p, double bs) {
    final d = p.r * 2 * bs;
    late List<Color> cols;
    Color border;
    switch (p.kind) {
      case CKind.white:
        cols = [Colors.white, const Color(0xFFEFE6D2)];
        border = Colors.black38;
        break;
      case CKind.black:
        cols = [const Color(0xFF555555), const Color(0xFF111111)];
        border = Colors.black87;
        break;
      case CKind.queen:
        cols = [const Color(0xFFFF6B6B), const Color(0xFFC62828)];
        border = Colors.white70;
        break;
      case CKind.striker:
        cols = [const Color(0xFFFF9EC0), const Color(0xFFE91E63)];
        border = Colors.white;
        break;
    }
    final isStriker = p.kind == CKind.striker;
    return Positioned(
      left: p.pos.dx * bs - d / 2,
      top: p.pos.dy * bs - d / 2,
      width: d,
      height: d,
      child: IgnorePointer(
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(center: const Alignment(-0.3, -0.3), colors: cols),
            border: Border.all(color: border, width: isStriker ? 2 : 1),
            boxShadow: [
              BoxShadow(
                color: isStriker ? const Color(0xFFFFD700).withOpacity(0.8) : Colors.black38,
                blurRadius: isStriker ? 8 : 2,
                spreadRadius: isStriker ? 1.5 : 0,
                offset: isStriker ? Offset.zero : const Offset(0, 1),
              ),
            ],
          ),
          child: p.kind == CKind.striker || p.kind == CKind.queen
              ? null
              : Center(
                  child: Container(
                    width: d * 0.55,
                    height: d * 0.55,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: border.withOpacity(0.35), width: 1),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

class _CarromAimPainter extends CustomPainter {
  final Offset from, to;
  final double r, power;
  _CarromAimPainter(this.from, this.to, this.r, this.power);

  @override
  void paint(Canvas canvas, Size size) {
    final col = Color.lerp(Colors.greenAccent, Colors.redAccent, power)!;
    final paint = Paint()
      ..color = col.withOpacity(0.9)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    final total = (to - from).distance;
    if (total < 1) return;
    final dir = (to - from) / total;
    double t = r;
    while (t < total) {
      final a = from + dir * t;
      final b = from + dir * math.min(t + 7, total);
      canvas.drawLine(a, b, paint);
      t += 14;
    }
    canvas.drawCircle(
      to,
      r,
      Paint()
        ..color = col.withOpacity(0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    // مؤشر القوة خلف القاطع
    final back = from - dir * (r + 8 + power * 40);
    canvas.drawLine(from - dir * (r + 4), back, paint..strokeWidth = 4);
  }

  @override
  bool shouldRepaint(covariant _CarromAimPainter old) => true;
}

class CarromBoardPainter extends CustomPainter {
  const CarromBoardPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final gold = const Color(0xFFD4AF37);

    // سطح اللعب
    final play = Rect.fromLTRB(w * 0.06, h * 0.06, w * 0.94, h * 0.94);
    canvas.drawRect(play, Paint()..color = const Color(0xFFF2D9A6));
    canvas.drawRect(
      play,
      Paint()
        ..color = const Color(0xFF8B5A2B)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );

    final line = Paint()
      ..color = gold.withOpacity(0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final dot = Paint()..color = gold;

    // مستطيل داخلي
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.15, h * 0.15, w * 0.7, h * 0.7), const Radius.circular(16)),
      line,
    );

    // خطوط التصويب العلوية والسفلية
    for (final y in [0.20, 0.80]) {
      canvas.drawLine(Offset(w * 0.22, h * y), Offset(w * 0.78, h * y), line);
      for (final x in [0.22, 0.78]) {
        canvas.drawCircle(Offset(w * x, h * y), 5, line);
        canvas.drawCircle(Offset(w * x, h * y), 1.8, dot);
      }
    }
    // خطوط جانبية
    for (final x in [0.20, 0.80]) {
      canvas.drawLine(Offset(w * x, h * 0.22), Offset(w * x, h * 0.78), line);
    }

    // الدائرة المركزية
    canvas.drawCircle(Offset(w / 2, h / 2), w * 0.12, line);
    canvas.drawCircle(Offset(w / 2, h / 2), w * 0.035, line);

    // الجيوب
    for (final pk in CarromEngine.pockets) {
      final c = Offset(pk.dx * w, pk.dy * h);
      canvas.drawCircle(c, w * 0.052, Paint()..color = const Color(0xFF111111));
      canvas.drawCircle(
        c,
        w * 0.052,
        Paint()
          ..color = const Color(0xFF5D4037)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


// ================= SNAKE & LADDER =================
const Map<int, int> kSnakes = {99: 54, 70: 55, 52: 42, 56: 8, 43: 17};
const Map<int, int> kLadders = {3: 51, 6: 27, 20: 70, 36: 55, 63: 95};
const List<Color> kSnakeColors = [Color(0xFFE53935), Color(0xFFFBC02D), Color(0xFF43A047), Color(0xFF1E88E5)];

/// مركز الخانة بوحدات الخانة (0..10)
Offset snakeCellCenter(int n) {
  if (n <= 0) return const Offset(0.5, 10.4);
  final idx = n - 1;
  final row = idx ~/ 10;
  int col = idx % 10;
  if (row.isOdd) col = 9 - col;
  return Offset(col + 0.5, (9 - row) + 0.5);
}

class SnakeBoardPainter extends CustomPainter {
  const SnakeBoardPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final ce = size.width / 10;
    for (int n = 1; n <= 100; n++) {
      final c = snakeCellCenter(n);
      final r = Rect.fromLTWH((c.dx - 0.5) * ce, (c.dy - 0.5) * ce, ce, ce);
      Color bg = (n % 2 == 0) ? const Color(0xFFFFF8E1) : const Color(0xFFFFECB3);
      if (kSnakes.containsKey(n)) bg = const Color(0xFFFFCDD2);
      if (kLadders.containsKey(n)) bg = const Color(0xFFC8E6C9);
      if (n == 100) bg = const Color(0xFFFFD54F);
      canvas.drawRect(r, Paint()..color = bg);
      canvas.drawRect(
        r,
        Paint()
          ..color = Colors.black12
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.4,
      );
      final tp = TextPainter(
        text: TextSpan(text: '$n', style: const TextStyle(fontSize: 8, color: Colors.black54)),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(r.left + 2, r.top + 1));
    }

    // السلالم
    kLadders.forEach((a, b) {
      final p1 = snakeCellCenter(a) * ce;
      final p2 = snakeCellCenter(b) * ce;
      final v = p2 - p1;
      final len = v.distance;
      final d = v / len;
      final nrm = Offset(-d.dy, d.dx) * (ce * 0.16);
      final rail = Paint()
        ..color = const Color(0xFF6D4C41)
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(p1 + nrm, p2 + nrm, rail);
      canvas.drawLine(p1 - nrm, p2 - nrm, rail);
      final rung = Paint()
        ..color = const Color(0xFF8D6E63)
        ..strokeWidth = 2.5;
      for (double t = ce * 0.4; t < len; t += ce * 0.45) {
        final c = p1 + d * t;
        canvas.drawLine(c + nrm, c - nrm, rung);
      }
    });

    // الثعابين (جسم متدرج الحجم بجلد منقوش ورأس واقعي)
    const palettes = [
      [Color(0xFF2E7D32), Color(0xFF1B5E20), Color(0xFFC5E1A5)],
      [Color(0xFF6D4C41), Color(0xFF3E2723), Color(0xFFFFE0B2)],
      [Color(0xFFC62828), Color(0xFF7F0000), Color(0xFFFFCDD2)],
      [Color(0xFF00695C), Color(0xFF004D40), Color(0xFFB2DFDB)],
      [Color(0xFF6A1B9A), Color(0xFF38006B), Color(0xFFE1BEE7)],
    ];
    int k = 0;
    kSnakes.forEach((a, b) {
      final pal = palettes[k % palettes.length];
      final head = snakeCellCenter(a) * ce;
      final tail = snakeCellCenter(b) * ce;
      final v = tail - head;
      final len = v.distance;
      final d = v / len;
      final nrm = Offset(-d.dy, d.dx);
      final sign = k.isEven ? 1.0 : -1.0;
      k++;
      final amp = ce * 0.75 * sign;
      const seg = 60;
      final pts = <Offset>[];
      for (int i = 0; i <= seg; i++) {
        final t = i / seg;
        final off = math.sin(t * math.pi * 3.2) * amp * (0.35 + 0.65 * math.sin(t * math.pi).abs() + 0.2);
        pts.add(head + v * t + nrm * off);
      }
      double rad(int i) {
        final t = i / seg;
        final neck = t < 0.06 ? 0.85 + t * 2.5 : 1.0;
        return ce * (0.07 + 0.15 * (1 - t) * neck);
      }

      // الظل
      for (int i = seg; i >= 0; i--) {
        canvas.drawCircle(pts[i] + Offset(ce * 0.05, ce * 0.07), rad(i), Paint()..color = Colors.black26);
      }
      // الجسم من الذيل إلى الرأس
      for (int i = seg; i >= 0; i--) {
        canvas.drawCircle(pts[i], rad(i), Paint()..color = pal[0]);
      }
      // البطن الفاتح على الحافة السفلى
      for (int i = seg; i >= 1; i--) {
        canvas.drawCircle(pts[i] + nrm * (rad(i) * 0.15), rad(i) * 0.45, Paint()..color = pal[2].withOpacity(0.55));
      }
      // لمعان الظهر
      for (int i = seg; i >= 1; i--) {
        canvas.drawCircle(pts[i] - nrm * (rad(i) * 0.28), rad(i) * 0.38, Paint()..color = Color.lerp(pal[0], Colors.white, 0.38)!.withOpacity(0.55));
      }
      // أحزمة داكنة وحراشف
      for (int i = 3; i < seg - 1; i += 3) {
        final tg = pts[i + 1] - pts[i - 1];
        final tl = tg.distance == 0 ? 1.0 : tg.distance;
        final nn = Offset(-tg.dy / tl, tg.dx / tl);
        final r = rad(i);
        canvas.drawLine(
          pts[i] + nn * r * 0.9,
          pts[i] - nn * r * 0.9,
          Paint()
            ..color = pal[1].withOpacity(0.55)
            ..strokeWidth = ce * 0.055
            ..strokeCap = StrokeCap.round,
        );
        final dot = Paint()..color = pal[2].withOpacity(0.5);
        canvas.drawCircle(pts[i] + nn * r * 0.35, r * 0.13, dot);
        canvas.drawCircle(pts[i] - nn * r * 0.35, r * 0.13, dot);
      }
      // الحواف
      for (int i = seg; i >= 0; i -= 2) {
        canvas.drawCircle(
            pts[i],
            rad(i),
            Paint()
              ..color = pal[1].withOpacity(0.35)
              ..style = PaintingStyle.stroke
              ..strokeWidth = ce * 0.012);
      }
      // الرأس
      final ang = math.atan2(-d.dy, -d.dx); // الرأس يواجه عكس اتجاه الجسم
      canvas.save();
      canvas.translate(head.dx, head.dy);
      canvas.rotate(ang);
      final hr = ce * 0.24;
      // اللسان المشقوق
      final tongue = Path()
        ..moveTo(hr * 0.95, 0)
        ..lineTo(hr * 1.6, 0)
        ..moveTo(hr * 1.6, 0)
        ..lineTo(hr * 1.9, -hr * 0.28)
        ..moveTo(hr * 1.6, 0)
        ..lineTo(hr * 1.9, hr * 0.28);
      canvas.drawPath(
        tongue,
        Paint()
          ..color = const Color(0xFFE53935)
          ..style = PaintingStyle.stroke
          ..strokeWidth = ce * 0.04
          ..strokeCap = StrokeCap.round,
      );
      final hp = Path()
        ..moveTo(hr * 1.4, 0)
        ..quadraticBezierTo(hr * 1.0, -hr * 1.0, -hr * 0.55, -hr * 0.9)
        ..quadraticBezierTo(-hr * 1.0, 0, -hr * 0.55, hr * 0.9)
        ..quadraticBezierTo(hr * 1.0, hr * 1.0, hr * 1.4, 0)
        ..close();
      canvas.drawPath(hp, Paint()..color = pal[0]);
      canvas.drawPath(
          hp,
          Paint()
            ..color = pal[1]
            ..style = PaintingStyle.stroke
            ..strokeWidth = ce * 0.035);
      final mark = Path()
        ..moveTo(-hr * 0.4, -hr * 0.45)
        ..lineTo(hr * 0.1, 0)
        ..lineTo(-hr * 0.4, hr * 0.45);
      canvas.drawPath(
          mark,
          Paint()
            ..color = pal[1].withOpacity(0.8)
            ..style = PaintingStyle.stroke
            ..strokeWidth = ce * 0.04
            ..strokeCap = StrokeCap.round);
      for (final sgn in [-1.0, 1.0]) {
        final e = Offset(hr * 0.55, sgn * hr * 0.5);
        canvas.drawCircle(e, hr * 0.3, Paint()..color = const Color(0xFFFFEB3B));
        canvas.drawOval(Rect.fromCenter(center: e, width: hr * 0.12, height: hr * 0.4), Paint()..color = Colors.black);
        canvas.drawCircle(e + Offset(-hr * 0.07, -hr * 0.08), hr * 0.05, Paint()..color = Colors.white);
        canvas.drawCircle(Offset(hr * 1.05, sgn * hr * 0.22), hr * 0.06, Paint()..color = pal[1]);
      }
      canvas.restore();
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class SnakeLadderRoyal extends StatefulWidget {
  const SnakeLadderRoyal({super.key});

  @override
  State<SnakeLadderRoyal> createState() => _SnakeState();
}

class _SnakeState extends State<SnakeLadderRoyal> {
  final List<SeatInfo> seats = Seats.players(4);
  List<String> get names => seats.map((s) => s.name).toList();
  final math.Random rnd = math.Random();

  int dice = 1, turn = 0, gen = 0;
  bool rolling = false, busy = false, gameOver = false;
  List<int> pos = [0, 0, 0, 0];
  String msg = 'اضغط على النرد لتبدأ';
  final List<String> publicChat = ['نورة: بالتوفيق للجميع 🍀'];

  bool get canRoll => turn == 0 && !rolling && !busy && !gameOver;

  @override
  void dispose() {
    gen++;
    super.dispose();
  }

  void roll() {
    if (turn != 0) return;
    _doRoll();
  }

  Future<void> _doRoll() async {
    if (rolling || busy || gameOver) return;
    final g = gen;
    setState(() {
      rolling = true;
      msg = turn == 0 ? 'جاري رمي النرد...' : '${names[turn]} يرمي النرد...';
    });
    SoundManager.dice();
    for (int i = 0; i < 8; i++) {
      await Future.delayed(const Duration(milliseconds: 70));
      if (!mounted || g != gen) return;
      setState(() => dice = rnd.nextInt(6) + 1);
    }
    final value = rnd.nextInt(6) + 1;
    setState(() {
      dice = value;
      rolling = false;
      busy = true;
    });
    await _play(value);
  }

  Future<void> _play(int value) async {
    final g = gen;
    final p = turn;
    bool extra = value == 6;
    if (pos[p] + value > 100) {
      setState(() => msg = '${names[p]} يحتاج رقماً أقل للوصول إلى 100');
      extra = false;
    } else {
      for (int s = 0; s < value; s++) {
        await Future.delayed(const Duration(milliseconds: 170));
        if (!mounted || g != gen) return;
        setState(() => pos[p] = pos[p] + 1);
        if (p == 0) SoundManager.move();
      }
      final here = pos[p];
      if (kLadders.containsKey(here)) {
        await Future.delayed(const Duration(milliseconds: 350));
        if (!mounted || g != gen) return;
        setState(() {
          pos[p] = kLadders[here]!;
          msg = '${names[p]} صعد سلماً 🪜 إلى ${pos[p]}';
        });
        SoundManager.up();
      } else if (kSnakes.containsKey(here)) {
        await Future.delayed(const Duration(milliseconds: 350));
        if (!mounted || g != gen) return;
        setState(() {
          pos[p] = kSnakes[here]!;
          msg = '${names[p]} لدغه ثعبان 🐍 إلى ${pos[p]}';
        });
        SoundManager.oops();
        extra = false;
      } else {
        setState(() => msg = '${names[p]} وصل إلى $here');
      }
    }

    if (pos[p] == 100) {
      setState(() {
        gameOver = true;
        busy = false;
        msg = 'فاز ${names[p]}!';
      });
      if (p == 0) {
        UserData.win();
      } else {
        UserData.lose();
      }
      if (!mounted) return;
      showWinDialog(
        context,
        p == 0 ? '🏆 مبروك، لقد فزت!' : 'انتهت اللعبة',
        p == 0 ? 'ربحت 20 عملة. هل تلعب مرة أخرى؟' : 'خسرت 10 عملات. الفائز هو ${names[p]}. حظاً أوفر!',
        _reset,
      );
      return;
    }

    await Future.delayed(const Duration(milliseconds: 650));
    if (!mounted || g != gen) return;
    setState(() {
      if (!extra) turn = (turn + 1) % 4;
      busy = false;
    });
    if (turn != 0) {
      await Future.delayed(const Duration(milliseconds: 400));
      if (!mounted || g != gen) return;
      _doRoll();
    } else {
      setState(() => msg = 'دورك! اضغط على النرد');
    }
  }

  void _reset() {
    gen++;
    setState(() {
      pos = [0, 0, 0, 0];
      turn = 0;
      dice = 1;
      rolling = false;
      busy = false;
      gameOver = false;
      msg = 'اضغط على النرد لتبدأ';
    });
  }

  List<Widget> _tokens(double ce) {
    final res = <Widget>[];
    for (int p = 0; p < 4; p++) {
      final c = snakeCellCenter(pos[p]);
      final ox = ((p % 2) - 0.5) * 0.34;
      final oy = ((p ~/ 2) - 0.5) * 0.34;
      final sz = ce * 0.34;
      res.add(AnimatedPositioned(
        key: ValueKey('sl$p'),
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        left: (c.dx + ox) * ce - sz / 2,
        top: (c.dy + oy) * ce - sz / 2,
        width: sz,
        height: sz,
        child: IgnorePointer(
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: kSnakeColors[p],
              border: Border.all(color: turn == p ? const Color(0xFFFFD700) : Colors.white, width: turn == p ? 2.5 : 1.5),
              boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 3)],
            ),
          ),
        ),
      ));
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return GameFrame(
      boardFrac: 0.44,
      top: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(color: Pal.card, borderRadius: BorderRadius.circular(8)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(msg,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.amber, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 8),
              Text('الدور: ${names[turn]}', style: const TextStyle(color: Colors.white, fontSize: 11)),
            ],
          ),
        ),
      badges: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              4,
              (p) => PlayerBadge(
                name: names[p],
                avatar: seats[p].avatar,
                color: kSnakeColors[p],
                badge: '${pos[p]}',
                active: turn == p && !gameOver,
                seat: seats[p],
                onKick: p == 0 ? null : () => setState(() => seats[p] = Seats.replacement(seats)),
              ),
            ),
          ),
        ),
      board: LayoutBuilder(builder: (context, cons) {
            final bs = math.min(cons.maxWidth - 16, cons.maxHeight - 8);
            if (bs <= 0) return const SizedBox.shrink();
            return Center(
              child: Container(
                width: bs,
                height: bs,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFFFD700), width: 3),
                  boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 10)],
                ),
                child: LayoutBuilder(builder: (c, inner) {
                  final ce = inner.maxWidth / 10;
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Positioned.fill(child: CustomPaint(painter: SnakeBoardPainter())),
                      ..._tokens(ce),
                    ],
                  );
                }),
              ),
            );
          }),
      midH: 64,
      mid: Center(
          child: DiceFace(
            value: dice,
            size: 54,
            accent: kSnakeColors[turn],
            active: canRoll,
            rolling: rolling,
            onTap: roll,
          ),
      ),
      chat: ChatPanel(messages: publicChat),
      bar: ChatAndControlsBar(
          onSendChat: (txt) {
            setState(() => publicChat.add('${AppState.I.myName}: $txt'));
            Future.delayed(const Duration(milliseconds: 1200), () {
              if (!mounted) return;
              setState(() => publicChat.add('${names[1 + rnd.nextInt(3)]}: ${BotChat.random()}'));
            });
          },
          onSendEmoji: (em) => setState(() => publicChat.add('${AppState.I.myName}: $em')),
          onSendRose: () => showRoseFeedback(context),
        ),
    );
  }
}


// ================= تسجيل الدخول =================
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  int step = 0; // 0 اختيار ، 1 هاتف ، 2 رمز ، 3 الملف الشخصي
  int country = 0, avatar = 0;
  bool busy = false;
  String? error;
  String method = 'phone', contact = '';
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController otpCtrl = TextEditingController();
  final TextEditingController nameCtrl = TextEditingController();

  @override
  void dispose() {
    phoneCtrl.dispose();
    otpCtrl.dispose();
    nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    final raw = phoneCtrl.text.trim().replaceFirst(RegExp(r'^0+'), '');
    if (raw.length < 7 || raw.length > 12) {
      setState(() => error = 'أدخل رقم هاتف صحيحاً');
      return;
    }
    setState(() {
      busy = true;
      error = null;
    });
    final full = kCountries[country].dial + raw;
    final ok = await AuthService.sendCode(full);
    if (!mounted) return;
    setState(() {
      busy = false;
      if (ok) {
        contact = full;
        method = 'phone';
        step = 2;
      } else {
        error = 'تعذر إرسال الرمز، حاول لاحقاً';
      }
    });
  }

  Future<void> _verify() async {
    if (otpCtrl.text.trim().length != 6) {
      setState(() => error = 'أدخل الرمز المكوّن من 6 أرقام');
      return;
    }
    setState(() {
      busy = true;
      error = null;
    });
    final ok = await AuthService.verifyCode(contact, otpCtrl.text.trim());
    if (!mounted) return;
    setState(() {
      busy = false;
      if (ok) {
        step = 3;
      } else {
        error = 'الرمز غير صحيح';
      }
    });
  }

  Future<void> _google() async {
    setState(() {
      busy = true;
      error = null;
    });
    final p = await AuthService.signInWithGoogle();
    if (!mounted) return;
    setState(() {
      busy = false;
      if (p != null) {
        method = 'google';
        contact = p.contact;
        nameCtrl.text = p.name;
        avatar = p.avatar;
        step = 3;
      } else {
        error = 'تعذر الدخول بحساب جوجل حالياً';
      }
    });
  }

  void _finish() {
    final n = nameCtrl.text.trim();
    if (n.length < 2) {
      setState(() => error = 'اكتب اسماً من حرفين على الأقل');
      return;
    }
    AppState.I.setProfile(Profile(name: n, avatar: avatar, method: method, contact: contact));
  }

  @override
  Widget build(BuildContext context) {
    return rtl(Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2B0A3D), Pal.bg2, Pal.bg],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _logo(),
                    const SizedBox(height: 26),
                    if (step == 0) ..._choose(),
                    if (step == 1) ..._phone(),
                    if (step == 2) ..._otp(),
                    if (step == 3) ..._profile(),
                    if (error != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(error!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Pal.red, fontSize: 13)),
                      ),
                    if (kDemoMode)
                      const Padding(
                        padding: EdgeInsets.only(top: 18),
                        child: Text('نسخة تجريبية: الدخول محلي حتى يتم ربط الخادم',
                            textAlign: TextAlign.center, style: TextStyle(color: Colors.white30, fontSize: 11)),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ));
  }

  Widget _logo() => Column(children: [
        Container(
          width: 92,
          height: 92,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: const LinearGradient(
                begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFFFF5F8D), Pal.goldDeep, Pal.gold]),
            boxShadow: [BoxShadow(color: Pal.goldDeep.withOpacity(0.45), blurRadius: 26, offset: const Offset(0, 8))],
          ),
          child: const Text('🎲', style: TextStyle(fontSize: 46)),
        ),
        const SizedBox(height: 14),
        const Text('Play & Win',
            style: TextStyle(color: Pal.gold, fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
        const SizedBox(height: 4),
        const Text('لودو · كيرم · سلم وثعبان · دومينو', style: TextStyle(color: Pal.muted, fontSize: 13)),
      ]);

  Widget _title(String t, String sub) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(children: [
          Text(t, style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(sub, textAlign: TextAlign.center, style: const TextStyle(color: Pal.muted, fontSize: 13)),
        ]),
      );

  Widget _back(int to) => Align(
        alignment: AlignmentDirectional.centerStart,
        child: TextButton.icon(
          onPressed: busy
              ? null
              : () => setState(() {
                    step = to;
                    error = null;
                  }),
          icon: const Icon(Icons.arrow_forward, size: 18, color: Pal.muted),
          label: const Text('رجوع', style: TextStyle(color: Pal.muted)),
        ),
      );

  List<Widget> _choose() => [
        _title('أهلاً بك', 'اختر طريقة تسجيل الدخول'),
        GoldButton(
          label: 'الدخول برقم الهاتف',
          icon: Icons.phone_android,
          onTap: () => setState(() {
            step = 1;
            error = null;
          }),
        ),
        const SizedBox(height: 12),
        GoldButton(label: 'المتابعة بحساب جوجل', icon: Icons.account_circle, outlined: true, busy: busy, onTap: _google),
      ];

  List<Widget> _phone() => [
        _back(0),
        _title('رقم الهاتف', 'سنرسل لك رمز تحقق مكوّناً من 6 أرقام'),
        Row(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(color: Pal.card, borderRadius: BorderRadius.circular(14)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: country,
                dropdownColor: Pal.card,
                items: [
                  for (int i = 0; i < kCountries.length; i++)
                    DropdownMenuItem(
                      value: i,
                      child: Text('${kCountries[i].flag} ${kCountries[i].dial}',
                          style: const TextStyle(color: Colors.white, fontSize: 14)),
                    ),
                ],
                onChanged: (v) => setState(() => country = v ?? 0),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: phoneCtrl,
              keyboardType: TextInputType.phone,
              textDirection: TextDirection.ltr,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(12)],
              style: const TextStyle(color: Colors.white, fontSize: 17, letterSpacing: 1),
              decoration: InputDecoration(
                hintText: '7xx xxx xxxx',
                hintStyle: const TextStyle(color: Colors.white30),
                filled: true,
                fillColor: Pal.card,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
              ),
            ),
          ),
        ]),
        const SizedBox(height: 16),
        GoldButton(label: 'إرسال الرمز', busy: busy, onTap: _sendCode),
      ];

  List<Widget> _otp() => [
        _back(1),
        _title('رمز التحقق', 'أدخل الرمز المرسل إلى $contact'),
        TextField(
          controller: otpCtrl,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(6)],
          style: const TextStyle(color: Colors.white, fontSize: 26, letterSpacing: 10, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            hintText: '······',
            hintStyle: const TextStyle(color: Colors.white24),
            filled: true,
            fillColor: Pal.card,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
          ),
        ),
        if (kDemoMode)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text('في النسخة التجريبية يقبل أي رمز من 6 أرقام',
                textAlign: TextAlign.center, style: TextStyle(color: Pal.muted, fontSize: 12)),
          ),
        const SizedBox(height: 16),
        GoldButton(label: 'تأكيد', busy: busy, onTap: _verify),
      ];

  List<Widget> _profile() => [
        _title('ملفك الشخصي', 'اختر اسمك وصورتك الرمزية'),
        Center(child: AvatarView(id: avatar, size: 84, ring: true)),
        const SizedBox(height: 14),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 10,
          runSpacing: 10,
          children: [
            for (int i = 0; i < Avatars.emoji.length; i++)
              GestureDetector(
                onTap: () => setState(() => avatar = i),
                child: Opacity(opacity: avatar == i ? 1 : 0.55, child: AvatarView(id: i, size: 44, ring: avatar == i)),
              ),
          ],
        ),
        const SizedBox(height: 16),
        TextField(
          controller: nameCtrl,
          maxLength: 16,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 17),
          decoration: InputDecoration(
            hintText: 'اسمك في اللعبة',
            hintStyle: const TextStyle(color: Colors.white30),
            counterText: '',
            filled: true,
            fillColor: Pal.card,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
          ),
        ),
        const SizedBox(height: 16),
        GoldButton(label: 'ابدأ اللعب', icon: Icons.play_arrow_rounded, onTap: _finish),
      ];
}

void showWelcome(BuildContext context) {
  final name = AppState.I.myName;
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => rtl(Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.fromLTRB(22, 24, 22, 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          gradient: const LinearGradient(
              begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF4A1D63), Pal.card]),
          border: Border.all(color: Pal.gold.withOpacity(0.5)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AvatarView(id: AppState.I.myAvatar, size: 70, ring: true),
            const SizedBox(height: 12),
            Text('مرحباً بك يا $name 🎉',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Pal.gold, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text(
              'يسعدنا انضمامك إلى Play & Win.\nأربع ألعاب بانتظارك: لودو، كيرم، سلم وثعبان، ودومينو.\n'
              'اضغط على علامة التعجب في أي لعبة لتعرف طريقة اللعب، وأنشئ غرفة خاصة وادعُ أصدقاءك.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 14, height: 1.6),
            ),
            const SizedBox(height: 16),
            GoldButton(label: 'هيا نلعب', onTap: () => Navigator.of(ctx).pop()),
          ],
        ),
      ),
    )),
  );
}


// ================= التطبيق والواجهة الرئيسية =================
class PlayAndWinApp extends StatelessWidget {
  const PlayAndWinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Play and Win',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Pal.bg,
        colorScheme: ColorScheme.fromSeed(seedColor: Pal.gold, brightness: Brightness.dark),
      ),
      home: AnimatedBuilder(
        animation: AppState.I,
        builder: (context, _) => AppState.I.me == null ? const LoginScreen() : const MainShell(),
      ),
    );
  }
}

void openGame(BuildContext context, String gameId, {GameRoom? room}) {
  AppState.I.currentRoom = room;
  Navigator.of(context).push(MaterialPageRoute(builder: (_) => GameScreen(gameId: gameId, room: room)));
}

class GameScreen extends StatefulWidget {
  final String gameId;
  final GameRoom? room;
  const GameScreen({super.key, required this.gameId, this.room});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  void dispose() {
    AppState.I.currentRoom = null;
    super.dispose();
  }

  Widget _body() {
    switch (widget.gameId) {
      case 'ludo':
        return const LudoRoyalFull();
      case 'carrom':
        return const CarromProScreen();
      case 'snake':
        return const SnakeLadderRoyal();
      default:
        return const DominoGame();
    }
  }

  @override
  Widget build(BuildContext context) {
    final g = Games.byId(widget.gameId);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 48,
        backgroundColor: Pal.bg2,
        elevation: 0,
        titleSpacing: 0,
        title: Row(children: [
          Text(g.emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
          Text(g.title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          if (widget.room != null) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(10)),
              child: Text('🔒 ${widget.room!.code}', style: const TextStyle(fontSize: 11, color: Pal.gold)),
            ),
          ],
        ]),
        actions: [
          GestureDetector(
            onTap: () => setState(() {
              SoundManager.enabled = !SoundManager.enabled;
              if (SoundManager.enabled) SoundManager.coin();
            }),
            child: Icon(SoundManager.enabled ? Icons.volume_up : Icons.volume_off, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 10),
          HelpButton(gameId: widget.gameId),
          const SizedBox(width: 8),
          const Center(child: CoinChip()),
          const SizedBox(width: 10),
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: _body(),
    );
  }
}

// ---------- الهيكل الرئيسي ----------
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int tab = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || AppState.I.welcomeShown) return;
      AppState.I.welcomeShown = true;
      showWelcome(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return rtl(Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(children: [
          _topBar(),
          Expanded(
            child: IndexedStack(index: tab, children: [
              HomeTab(onShop: () => setState(() => tab = 2), onRooms: () => setState(() => tab = 1)),
              const RoomsTab(),
              const ShopView(),
            ]),
          ),
        ]),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        backgroundColor: Pal.bg2,
        indicatorColor: Pal.gold.withOpacity(0.25),
        onDestinationSelected: (i) => setState(() => tab = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home, color: Pal.gold), label: 'الرئيسية'),
          NavigationDestination(icon: Icon(Icons.meeting_room_outlined), selectedIcon: Icon(Icons.meeting_room, color: Pal.gold), label: 'الغرف الخاصة'),
          NavigationDestination(icon: Icon(Icons.storefront_outlined), selectedIcon: Icon(Icons.storefront, color: Pal.gold), label: 'المتجر'),
        ],
      ),
    ));
  }

  Widget _topBar() {
    return AnimatedBuilder(
      animation: AppState.I,
      builder: (context, _) => Padding(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 6),
        child: Row(children: [
          GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SettingsScreen())),
            child: AvatarView(id: AppState.I.myAvatar, size: 42, ring: true),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(AppState.I.myName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
              ValueListenableBuilder<int>(
                valueListenable: UserData.tick,
                builder: (context, _, __) => Text('🌹 ${UserData.freeRoses}',
                    style: const TextStyle(color: Pal.muted, fontSize: 12)),
              ),
            ]),
          ),
          CoinChip(onTap: () => setState(() => tab = 2)),
          const SizedBox(width: 6),
          IconButton(
            tooltip: 'الإعدادات',
            icon: const Icon(Icons.settings, color: Colors.white70),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SettingsScreen())),
          ),
        ]),
      ),
    );
  }
}

// ---------- الرئيسية ----------
class HomeTab extends StatelessWidget {
  final VoidCallback onShop;
  final VoidCallback onRooms;
  const HomeTab({super.key, required this.onShop, required this.onRooms});

  Widget _section(String t) => Padding(
        padding: const EdgeInsets.fromLTRB(2, 18, 2, 10),
        child: Text(t, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
      );

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
                begin: Alignment.topRight, end: Alignment.bottomLeft, colors: [Color(0xFF6A1B9A), Color(0xFFD81B60)]),
            boxShadow: [BoxShadow(color: const Color(0xFFD81B60).withOpacity(0.3), blurRadius: 18, offset: const Offset(0, 8))],
          ),
          child: Row(children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('العب واربح', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text('اختر لعبتك يا ${AppState.I.myName} وابدأ التحدي',
                    style: const TextStyle(color: Colors.white70, fontSize: 13)),
                const SizedBox(height: 4),
                Text('ID: ${AppState.I.myId}', textDirection: TextDirection.ltr, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
              ]),
            ),
            const Text('🏆', style: TextStyle(fontSize: 46)),
          ]),
        ),
        _section('القصص'),
        const StoriesBar(),
        ValueListenableBuilder<int>(
          valueListenable: UserData.tick,
          builder: (c, _, __) => UserData.coins < 10
              ? GestureDetector(
                  onTap: onShop,
                  child: Container(
                    margin: const EdgeInsets.only(top: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Pal.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: Pal.gold)),
                    child: const Text('🎡 انتهت عملاتك! ادخل المتجر ثم عجلة الحظ لتربح عملات مجانية', style: TextStyle(color: Pal.gold, fontWeight: FontWeight.bold)),
                  ),
                )
              : const SizedBox.shrink(),
        ),
        const AdBanner(),
        _section('الألعاب'),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.98,
          children: [for (final g in Games.list) _GameCard(info: g)],
        ),
        _section('الغرف الخاصة'),
        _ActionTile(
          emoji: '🔒',
          title: 'أنشئ غرفة خاصة',
          sub: 'العب مع أصدقائك فقط بدعوة منك',
          colors: const [Color(0xFF00897B), Color(0xFF26A69A)],
          onTap: () => showCreateRoom(context),
        ),
        const SizedBox(height: 10),
        _ActionTile(
          emoji: '💬',
          title: 'غرفة دردشة خاصة',
          sub: 'تحدث مع أصدقائك في غرفة مغلقة',
          colors: const [Color(0xFF5C6BC0), Color(0xFF7986CB)],
          onTap: () {
            final r = RoomService.create('chat');
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => RoomLobby(room: r)));
          },
        ),
        const SizedBox(height: 10),
        _ActionTile(
          emoji: '🪙',
          title: 'متجر العملات والهدايا',
          sub: 'اشحن رصيدك بكروت الموبايل',
          colors: const [Color(0xFFFF8F00), Color(0xFFFFCA28)],
          onTap: onShop,
        ),
      ],
    );
  }
}

class _GameCard extends StatelessWidget {
  final GameInfo info;
  const _GameCard({required this.info});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => openGame(context, info.id),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft, colors: info.colors),
          boxShadow: [BoxShadow(color: info.colors.first.withOpacity(0.35), blurRadius: 14, offset: const Offset(0, 6))],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            HelpButton(gameId: info.id),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(10)),
              child: const Text('العب الآن', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          ]),
          Expanded(
            child: Center(
              child: info.id == 'domino'
                  ? const DominoTile(a: 6, b: 3, w: 34, vertical: false)
                  : Text(info.emoji, style: const TextStyle(fontSize: 56)),
            ),
          ),
          Text(info.title, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w900)),
          Text(info.tagline, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ]),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final String emoji, title, sub;
  final List<Color> colors;
  final VoidCallback onTap;
  const _ActionTile({
    required this.emoji,
    required this.title,
    required this.sub,
    required this.colors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: Pal.card, borderRadius: BorderRadius.circular(20)),
        child: Row(children: [
          Container(
            width: 52,
            height: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(colors: colors),
            ),
            child: Text(emoji, style: const TextStyle(fontSize: 26)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 2),
              Text(sub, style: const TextStyle(color: Pal.muted, fontSize: 12)),
            ]),
          ),
          const Icon(Icons.chevron_left, color: Pal.muted),
        ]),
      ),
    );
  }
}

// ---------- الغرف الخاصة ----------
void showCreateRoom(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Pal.card,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (ctx) => rtl(SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('اختر اللعبة للغرفة الخاصة',
              style: TextStyle(color: Pal.gold, fontSize: 17, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          for (final g in Games.list)
            ListTile(
              leading: Text(g.emoji, style: const TextStyle(fontSize: 28)),
              title: Text(g.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              subtitle: Text(g.tagline, style: const TextStyle(color: Pal.muted, fontSize: 12)),
              trailing: const Icon(Icons.chevron_left, color: Pal.muted),
              onTap: () {
                Navigator.of(ctx).pop();
                final r = RoomService.create(g.id);
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => RoomLobby(room: r)));
              },
            ),
        ]),
      ),
    )),
  );
}

class RoomsTab extends StatefulWidget {
  const RoomsTab({super.key});

  @override
  State<RoomsTab> createState() => _RoomsTabState();
}

class _RoomsTabState extends State<RoomsTab> {
  final TextEditingController codeCtrl = TextEditingController();
  String? err;

  @override
  void dispose() {
    codeCtrl.dispose();
    super.dispose();
  }

  void _join() {
    final r = RoomService.find(codeCtrl.text);
    if (r == null) {
      setState(() => err = 'لا توجد غرفة بهذا الكود');
      return;
    }
    setState(() => err = null);
    codeCtrl.clear();
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => RoomLobby(room: r))).then((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final rooms = RoomService.rooms;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
      children: [
        GoldButton(
          label: 'إنشاء غرفة خاصة',
          icon: Icons.add_circle_outline,
          onTap: () {
            showCreateRoom(context);
          },
        ),
        const SizedBox(height: 14),
        Row(children: [
          Expanded(
            child: TextField(
              controller: codeCtrl,
              textCapitalization: TextCapitalization.characters,
              textDirection: TextDirection.ltr,
              style: const TextStyle(color: Colors.white, letterSpacing: 1.5),
              decoration: InputDecoration(
                hintText: 'كود الغرفة مثل LD-1234',
                hintStyle: const TextStyle(color: Colors.white30, letterSpacing: 0),
                filled: true,
                fillColor: Pal.card,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(width: 100, child: GoldButton(label: 'انضمام', outlined: true, onTap: _join)),
        ]),
        if (err != null)
          Padding(padding: const EdgeInsets.only(top: 8), child: Text(err!, style: const TextStyle(color: Pal.red, fontSize: 13))),
        const SizedBox(height: 18),
        const Text('غرفك', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        if (rooms.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: Pal.card, borderRadius: BorderRadius.circular(18)),
            child: const Column(children: [
              Text('🔒', style: TextStyle(fontSize: 36)),
              SizedBox(height: 8),
              Text('لا توجد غرف بعد. أنشئ غرفة وادعُ أصدقاءك للعب معاً.',
                  textAlign: TextAlign.center, style: TextStyle(color: Pal.muted, fontSize: 13)),
            ]),
          ),
        for (final r in rooms)
          GestureDetector(
            onTap: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => RoomLobby(room: r)))
                .then((_) {
              if (mounted) setState(() {});
            }),
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: Pal.card, borderRadius: BorderRadius.circular(18)),
              child: Row(children: [
                Text(r.emoji, style: const TextStyle(fontSize: 30)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(r.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    Text('الكود ${r.code} · ${r.members.length} لاعبين', style: const TextStyle(color: Pal.muted, fontSize: 12)),
                  ]),
                ),
                const Icon(Icons.chevron_left, color: Pal.muted),
              ]),
            ),
          ),
      ],
    );
  }
}

class RoomLobby extends StatefulWidget {
  final GameRoom room;
  const RoomLobby({super.key, required this.room});

  @override
  State<RoomLobby> createState() => _RoomLobbyState();
}

class _RoomLobbyState extends State<RoomLobby> {
  void _invite(SeatInfo f) {
    final r = widget.room;
    if ((r.invites[f.name] ?? 0) != 0) return;
    setState(() => r.invites[f.name] = 1);
    // في النسخة التجريبية ينضم الصديق تلقائياً بعد ثانيتين
    Future.delayed(const Duration(seconds: 2), () {
      if (r.invites[f.name] == 1) {
        r.invites[f.name] = 2;
        r.members.add(f);
        if (mounted) setState(() {});
      }
    });
  }

  void _copy() {
    final r = widget.room;
    Clipboard.setData(ClipboardData(text: 'انضم إلى ${r.title} في Play & Win. كود الغرفة: ${r.code}'));
    final m = ScaffoldMessenger.of(context);
    m.hideCurrentSnackBar();
    m.showSnackBar(SnackBar(duration: const Duration(milliseconds: 1500), content: rtl(const Text('تم نسخ رابط الدعوة'))));
  }

  void _start() {
    final r = widget.room;
    if (r.game == 'chat') {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => ChatRoomScreen(room: r)));
    } else {
      openGame(context, r.game, room: r);
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.room;
    final seatsCount = r.game == 'carrom' ? 2 : 4;
    return rtl(Scaffold(
      appBar: AppBar(backgroundColor: Pal.bg2, title: Text(r.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(colors: [Color(0xFF4A1D63), Pal.card]),
              border: Border.all(color: Pal.gold.withOpacity(0.4)),
            ),
            child: Column(children: [
              Text(r.emoji, style: const TextStyle(fontSize: 38)),
              const SizedBox(height: 6),
              const Text('كود الغرفة', style: TextStyle(color: Pal.muted, fontSize: 12)),
              Text(r.code,
                  textDirection: TextDirection.ltr,
                  style: const TextStyle(color: Pal.gold, fontSize: 30, fontWeight: FontWeight.w900, letterSpacing: 3)),
              const SizedBox(height: 10),
              GoldButton(label: 'نسخ رابط الدعوة', icon: Icons.copy, outlined: true, onTap: _copy),
            ]),
          ),
          const SizedBox(height: 18),
          Text(r.game == 'chat' ? 'الأعضاء' : 'المقاعد', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            for (int i = 0; i < seatsCount; i++)
              Column(children: [
                if (i < r.members.length)
                  AvatarView(id: r.members[i].avatar, size: 54, ring: r.members[i].isMe)
                else
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white24, width: 1.5),
                      color: Colors.white10,
                    ),
                    child: const Icon(Icons.person_add_alt_1, color: Colors.white38, size: 22),
                  ),
                const SizedBox(height: 4),
                Text(i < r.members.length ? r.members[i].name : 'فارغ',
                    style: TextStyle(color: i < r.members.length ? Colors.white : Colors.white38, fontSize: 12)),
              ]),
          ]),
          if (r.game != 'chat')
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text('المقاعد الفارغة يملؤها لاعبون آليون عند البدء',
                  textAlign: TextAlign.center, style: TextStyle(color: Pal.muted, fontSize: 12)),
            ),
          const SizedBox(height: 18),
          const Text('ادعُ أصدقاءك', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          for (final f in Friends.list)
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(color: Pal.card, borderRadius: BorderRadius.circular(16)),
              child: Row(children: [
                AvatarView(id: f.avatar, size: 40),
                const SizedBox(width: 10),
                Expanded(child: Text(f.name, style: const TextStyle(color: Colors.white, fontSize: 15))),
                Builder(builder: (context) {
                  final st = r.invites[f.name] ?? 0;
                  if (st == 2) return const Text('انضم ✓', style: TextStyle(color: Pal.green, fontWeight: FontWeight.bold));
                  if (st == 1) return const Text('تم الإرسال...', style: TextStyle(color: Pal.muted, fontSize: 13));
                  return SizedBox(
                    width: 84,
                    height: 36,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Pal.gold, foregroundColor: Colors.black87, padding: EdgeInsets.zero),
                      onPressed: () => _invite(f),
                      child: const Text('دعوة', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  );
                }),
              ]),
            ),
          const SizedBox(height: 14),
          GoldButton(
            label: r.game == 'chat' ? 'دخول الدردشة' : 'ابدأ اللعب',
            icon: Icons.play_arrow_rounded,
            onTap: _start,
          ),
        ],
      ),
    ));
  }
}

class ChatRoomScreen extends StatefulWidget {
  final GameRoom room;
  const ChatRoomScreen({super.key, required this.room});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoomScreen> {
  final List<String> msgs = [];
  final math.Random rnd = math.Random();

  void _reply() {
    final others = widget.room.members.where((m) => !m.isMe).toList();
    if (others.isEmpty) return;
    Future.delayed(const Duration(milliseconds: 1300), () {
      if (!mounted) return;
      final o = others[rnd.nextInt(others.length)];
      setState(() => msgs.add('${o.name}: ${BotChat.random()}'));
    });
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.room;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Pal.bg2,
        title: Text('${r.emoji} ${r.code}'),
        actions: [
          for (final m in r.members.take(4))
            Padding(padding: const EdgeInsets.only(left: 4), child: AvatarView(id: m.avatar, size: 30)),
          const SizedBox(width: 10),
        ],
      ),
      body: Column(children: [
        Expanded(child: ChatPanel(messages: msgs)),
        ChatAndControlsBar(
          onSendChat: (t) {
            setState(() => msgs.add('${AppState.I.myName}: $t'));
            _reply();
          },
          onSendEmoji: (e) {
            setState(() => msgs.add('${AppState.I.myName}: $e'));
            _reply();
          },
          onSendRose: () => showRoseFeedback(context),
        ),
      ]),
    );
  }
}

// ---------- الإعدادات ----------
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsState();
}

class _SettingsState extends State<SettingsScreen> {
  void _editName() {
    final ctrl = TextEditingController(text: AppState.I.myName);
    showDialog<void>(
      context: context,
      builder: (ctx) => rtl(AlertDialog(
        backgroundColor: Pal.card,
        title: const Text('تعديل الاسم', style: TextStyle(color: Pal.gold)),
        content: TextField(controller: ctrl, maxLength: 16, style: const TextStyle(color: Colors.white)),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('إلغاء')),
          TextButton(
            onPressed: () {
              final n = ctrl.text.trim();
              if (n.length >= 2) {
                AppState.I.me!.name = n;
                AppState.I.changed();
                setState(() {});
              }
              Navigator.of(ctx).pop();
            },
            child: const Text('حفظ'),
          ),
        ],
      )),
    );
  }

  void _pickAvatar() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Pal.card,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => rtl(SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text('اختر صورتك الرمزية', style: TextStyle(color: Pal.gold, fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 14),
            Wrap(spacing: 12, runSpacing: 12, alignment: WrapAlignment.center, children: [
              for (int i = 0; i < Avatars.emoji.length; i++)
                GestureDetector(
                  onTap: () {
                    AppState.I.me!.avatar = i;
                    AppState.I.changed();
                    setState(() {});
                    Navigator.of(ctx).pop();
                  },
                  child: AvatarView(id: i, size: 52, ring: AppState.I.myAvatar == i),
                ),
            ]),
          ]),
        ),
      )),
    );
  }

  Widget _row(IconData icon, String title, Widget trailing, {VoidCallback? onTap}) => ListTile(
        leading: Icon(icon, color: Pal.gold),
        title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 15)),
        trailing: trailing,
        onTap: onTap,
      );

  @override
  Widget build(BuildContext context) {
    final me = AppState.I.me;
    return rtl(Scaffold(
      appBar: AppBar(backgroundColor: Pal.bg2, title: const Text('الإعدادات')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Pal.card, borderRadius: BorderRadius.circular(20)),
            child: Row(children: [
              GestureDetector(onTap: _pickAvatar, child: AvatarView(id: AppState.I.myAvatar, size: 62, ring: true)),
              const SizedBox(width: 14),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(AppState.I.myName, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(me?.method == 'google' ? 'حساب جوجل' : (me?.contact ?? ''),
                      textDirection: TextDirection.ltr, style: const TextStyle(color: Pal.muted, fontSize: 12)),
                ]),
              ),
              IconButton(icon: const Icon(Icons.edit, color: Pal.gold), onPressed: _editName),
            ]),
          ),
          const SizedBox(height: 14),
          Container(
            decoration: BoxDecoration(color: Pal.card, borderRadius: BorderRadius.circular(20)),
            child: Column(children: [
              _row(
                Icons.vibration,
                'الأصوات والمؤثرات (إيقاف = كتم)',
                Switch(value: SoundManager.enabled, onChanged: (v) => setState(() => SoundManager.enabled = v)),
              ),
              const Divider(height: 1, color: Colors.white12),
              _row(
                Icons.volume_up,
                'مستوى الصوت',
                SizedBox(
                  width: 150,
                  child: Slider(
                    value: SoundManager.volume,
                    onChanged: (v) => setState(() => SoundManager.volume = v),
                    onChangeEnd: (_) => SoundManager.coin(),
                  ),
                ),
              ),
              const Divider(height: 1, color: Colors.white12),
              _row(
                Icons.sports_esports,
                'اتجاه التصويب في الكيرم',
                SegmentedButton<bool>(
                  showSelectedIcon: false,
                  segments: const [
                    ButtonSegment(value: true, label: Text('مباشر', style: TextStyle(fontSize: 12))),
                    ButtonSegment(value: false, label: Text('عكسي', style: TextStyle(fontSize: 12))),
                  ],
                  selected: {AppState.I.aimDirect},
                  onSelectionChanged: (s) => setState(() => AppState.I.aimDirect = s.first),
                ),
              ),
            ]),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(6, 8, 6, 0),
            child: Text('مباشر: القاطع يذهب في اتجاه سحبك. عكسي: تسحب للخلف ويذهب القاطع للأمام.',
                style: TextStyle(color: Pal.muted, fontSize: 12)),
          ),
          const SizedBox(height: 14),
          Container(
            decoration: BoxDecoration(color: Pal.card, borderRadius: BorderRadius.circular(20)),
            child: _row(Icons.logout, 'تسجيل الخروج', const Icon(Icons.chevron_left, color: Pal.muted), onTap: () {
              Navigator.of(context).popUntil((r) => r.isFirst);
              AppState.I.logout();
            }),
          ),
          const SizedBox(height: 20),
          const Center(child: Text('Play & Win', style: TextStyle(color: Colors.white24, fontSize: 12))),
        ],
      ),
    ));
  }
}


// ================= DOMINO =================
class DominoTile extends StatelessWidget {
  final int a, b;
  final double w; // عرض نصف القطعة (القطعة = 2w × w)
  final bool vertical;
  final bool highlight;
  final bool dim;
  final VoidCallback? onTap;
  const DominoTile({
    super.key,
    required this.a,
    required this.b,
    required this.w,
    this.vertical = false,
    this.highlight = false,
    this.dim = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final width = vertical ? w : w * 2;
    final height = vertical ? w * 2 : w;
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: dim ? 0.5 : 1,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(w * 0.18),
            gradient: const LinearGradient(
                begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFFFFFDF2), Color(0xFFEBE0C6)]),
            border: Border.all(color: highlight ? Pal.gold : Colors.black45, width: highlight ? 2.5 : 1),
            boxShadow: [
              BoxShadow(
                color: highlight ? Pal.gold.withOpacity(0.7) : Colors.black45,
                blurRadius: highlight ? 10 : 3,
                offset: highlight ? Offset.zero : const Offset(0, 2),
              ),
            ],
          ),
          child: CustomPaint(painter: _DominoPainter(a, b, vertical)),
        ),
      ),
    );
  }
}

class _DominoPainter extends CustomPainter {
  final int a, b;
  final bool vertical;
  _DominoPainter(this.a, this.b, this.vertical);

  @override
  void paint(Canvas canvas, Size size) {
    final side = vertical ? size.width : size.height;
    final r1 = vertical ? Rect.fromLTWH(0, 0, side, side) : Rect.fromLTWH(0, 0, side, side);
    final r2 = vertical ? Rect.fromLTWH(0, side, side, side) : Rect.fromLTWH(side, 0, side, side);
    final line = Paint()
      ..color = Colors.black38
      ..strokeWidth = 1.5;
    if (vertical) {
      canvas.drawLine(Offset(side * 0.12, side), Offset(side * 0.88, side), line);
    } else {
      canvas.drawLine(Offset(side, side * 0.12), Offset(side, side * 0.88), line);
    }
    canvas.drawCircle(vertical ? Offset(side / 2, side) : Offset(side, side / 2), side * 0.07, Paint()..color = const Color(0xFFB07A55));
    final pip = Paint()..color = const Color(0xFF212121);
    void draw(Rect r, int v) {
      final pips = _PipsPainter.layout[v];
      if (pips == null) return;
      for (final o in pips) {
        canvas.drawCircle(Offset(r.left + o.dx * r.width, r.top + o.dy * r.height), side * 0.09, pip);
      }
    }

    draw(r1, a);
    draw(r2, b);
  }

  @override
  bool shouldRepaint(covariant _DominoPainter old) => old.a != a || old.b != b || old.vertical != vertical;
}

class _DTile {
  final int a, b;
  const _DTile(this.a, this.b);
  int get sum => a + b;
  bool get isDouble => a == b;
  bool has(int v) => a == v || b == v;
}

class _DPlaced {
  final int l, r;
  const _DPlaced(this.l, this.r);
}

class DominoGame extends StatefulWidget {
  const DominoGame({super.key});

  @override
  State<DominoGame> createState() => _DominoState();
}

class _DominoState extends State<DominoGame> {
  final math.Random rnd = math.Random();
  late final List<SeatInfo> seats = Seats.players(4);
  List<List<_DTile>> hands = List.generate(4, (_) => <_DTile>[]);
  List<_DPlaced> chain = [];
  int turn = 0, passes = 0, gen = 0;
  bool over = false, started = false;
  _DTile? selected;
  List<int> pts = [0, 0, 0, 0];
  bool matchOver = false;
  String msg = 'جاري توزيع القطع...';
  final List<String> chat = ['سلطان: بالتوفيق للجميع 🍀'];

  List<String> get names => seats.map((s) => s.name).toList();
  int get leftEnd => chain.first.l;
  int get rightEnd => chain.last.r;

  @override
  void initState() {
    super.initState();
    _deal();
  }

  @override
  void dispose() {
    gen++;
    super.dispose();
  }

  bool _fits(_DTile t) => chain.isEmpty || t.has(leftEnd) || t.has(rightEnd);

  void _deal() {
    gen++;
    final all = <_DTile>[];
    for (int a = 0; a <= 6; a++) {
      for (int b = a; b <= 6; b++) {
        all.add(_DTile(a, b));
      }
    }
    all.shuffle(rnd);
    hands = List.generate(4, (i) => all.sublist(i * 7, i * 7 + 7));
    chain = [];
    passes = 0;
    over = false;
    started = false;
    selected = null;
    // البداية: صاحب أكبر قطعة مزدوجة وإلا أكبر مجموع
    int sp = 0;
    _DTile? st;
    int best = -1;
    for (int p = 0; p < 4; p++) {
      for (final t in hands[p]) {
        final score = t.isDouble ? 100 + t.a : t.sum;
        if (score > best) {
          best = score;
          sp = p;
          st = t;
        }
      }
    }
    turn = sp;
    msg = '${names[sp]} يبدأ بأكبر قطعة';
    final first = st!;
    final g = gen;
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted || g != gen) return;
      setState(() {
        _place(sp, first, false);
        started = true;
      });
      SoundManager.move();
      _afterMove(sp);
    });
  }

  void _place(int p, _DTile t, bool onLeft) {
    if (chain.isEmpty) {
      chain.add(_DPlaced(t.a, t.b));
    } else if (onLeft) {
      final l = leftEnd;
      chain.insert(0, t.b == l ? _DPlaced(t.a, t.b) : _DPlaced(t.b, t.a));
    } else {
      final r = rightEnd;
      chain.add(t.a == r ? _DPlaced(t.a, t.b) : _DPlaced(t.b, t.a));
    }
    hands[p].remove(t);
  }

  Future<void> _afterMove(int p) async {
    final g = gen;
    passes = 0;
    turn = -1;
    if (hands[p].isEmpty) {
      _finish(p, false);
      return;
    }
    await Future.delayed(const Duration(milliseconds: 450));
    if (!mounted || g != gen) return;
    turn = (p + 1) % 4;
    _run();
  }

  Future<void> _run() async {
    final g = gen;
    if (over) return;
    final p = turn;
    final playable = hands[p].where(_fits).toList();
    if (playable.isEmpty) {
      SoundManager.pass();
      setState(() => msg = '${names[p]} لا يملك قطعة مناسبة (دق) 🛑');
      passes++;
      await Future.delayed(const Duration(milliseconds: 1000));
      if (!mounted || g != gen) return;
      if (passes >= 4) {
        _finish(-1, true);
        return;
      }
      turn = (p + 1) % 4;
      _run();
      return;
    }
    if (p == 0) {
      setState(() => msg = 'دورك، اختر قطعة مضيئة');
      return;
    }
    setState(() => msg = 'دور ${names[p]}...');
    await Future.delayed(Duration(milliseconds: 800 + rnd.nextInt(500)));
    if (!mounted || g != gen || over) return;
    playable.sort((x, y) => (y.isDouble ? 20 + y.sum : y.sum).compareTo(x.isDouble ? 20 + x.sum : x.sum));
    final t = playable.first;
    bool onLeft;
    if (t.has(leftEnd) && t.has(rightEnd)) {
      onLeft = rnd.nextBool();
    } else {
      onLeft = t.has(leftEnd);
    }
    setState(() => _place(p, t, onLeft));
    _afterMove(p);
  }

  // ---------- حركة اللاعب ----------
  void _tapTile(_DTile t) {
    if (turn != 0 || over || !started) return;
    if (!_fits(t)) {
      setState(() => msg = 'هذه القطعة لا تناسب أي طرف');
      return;
    }
    final canL = t.has(leftEnd), canR = t.has(rightEnd);
    if (canL && canR && leftEnd != rightEnd) {
      setState(() => selected = t);
      return;
    }
    _human(t, canL && !canR);
  }

  void _human(_DTile t, bool onLeft) {
    SoundManager.move();
    setState(() {
      selected = null;
      _place(0, t, onLeft);
    });
    _afterMove(0);
  }

  // ---------- النهاية ----------
  void _finish(int p, bool blocked) {
    int s0 = 0, s1 = 0;
    for (final t in hands[0]) {
      s0 += t.sum;
    }
    for (final t in hands[2]) {
      s0 += t.sum;
    }
    for (final t in hands[1]) {
      s1 += t.sum;
    }
    for (final t in hands[3]) {
      s1 += t.sum;
    }
    int winTeam; // 0 فريقك ، 1 الخصم ، -1 تعادل
    String body;
    if (!blocked) {
      winTeam = p % 2;
      body = 'أنهى ${names[p]} قطعه. نقاط الخصوم المتبقية: ${winTeam == 0 ? s1 : s0}';
    } else if (s0 == s1) {
      winTeam = -1;
      body = 'انغلقت اللعبة وتعادل الفريقان ($s0 مقابل $s1)';
    } else {
      winTeam = s0 < s1 ? 0 : 1;
      body = 'انغلقت اللعبة. نقاط فريقك $s0 ونقاط الخصم $s1';
    }
    final gain = winTeam == 0 ? (blocked ? s1 - s0 : s1) : (winTeam == 1 ? (blocked ? s0 - s1 : s0) : 0);
    if (winTeam == 0) {
      pts[0] += gain;
      pts[2] += gain;
    } else if (winTeam == 1) {
      pts[1] += gain;
      pts[3] += gain;
    }
    matchOver = pts.any((x) => x >= 50);
    if (matchOver) body = '$body\nانتهت المباراة عند 50 نقطة!';
    setState(() {
      over = true;
      msg = winTeam == 0
          ? 'فاز فريقك! 🏆'
          : winTeam == 1
              ? 'فاز الفريق الآخر'
              : 'تعادل';
    });
    if (winTeam == 0) {
      UserData.win();
    } else if (winTeam == 1) {
      UserData.lose();
    }
    if (!mounted) return;
    showWinDialog(
      context,
      winTeam == 0 ? '🏆 مبروك، فاز فريقك!' : (winTeam == 1 ? 'انتهت اللعبة' : 'تعادل'),
      winTeam == 0 ? '$body\nربحت 20 عملة.' : (winTeam == 1 ? '$body\nخسرت 10 عملات.' : body),
      _newGame,
    );
  }

  void _newGame() {
    setState(() {
      if (matchOver) {
        pts = [0, 0, 0, 0];
        matchOver = false;
      }
      _deal();
    });
  }

  // ---------- الواجهة ----------
  Widget _player(int p) {
    final s = seats[p];
    final active = turn == p && !over;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => showPlayerProfile(
        context,
        s,
        onKick: p == 0 ? null : () => setState(() => seats[p] = Seats.replacement(seats)),
      ),
      child: SizedBox(
        width: 80,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Stack(clipBehavior: Clip.none, children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: active ? const Color(0xFFB2FF59) : Colors.white24, width: active ? 3 : 1.5),
                boxShadow: active ? [BoxShadow(color: const Color(0xFFB2FF59).withOpacity(0.6), blurRadius: 12)] : const [],
              ),
              child: AvatarView(id: s.avatar, size: 48),
            ),
            Positioned(
              top: -5,
              right: -8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(8)),
                child: Text('${hands[p].length}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black)),
              ),
            ),
          ]),
          const SizedBox(height: 3),
          Text(s.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: active ? Colors.white : Colors.white70, fontSize: 11)),
          const SizedBox(height: 2),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF0B3B3A),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white24),
            ),
            child: Text('${pts[p]}/50', style: const TextStyle(color: Color(0xFFFFE082), fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final me = hands[0];
    final myTurn = turn == 0 && !over && started;
    return GameFrame(
      boardFrac: 0.30,
      topH: 124,
      top: Column(children: [
        Container(
          height: 28,
          width: double.infinity,
          margin: const EdgeInsets.fromLTRB(10, 4, 10, 2),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(8)),
          child: Text(msg, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.amber, fontSize: 11, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [_player(0), _player(1), _player(2), _player(3)],
          ),
        ),
      ]),
      board: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: const RadialGradient(radius: 0.9, colors: [Color(0xFF1FB5AA), Color(0xFF0B6B66)]),
          border: Border.all(color: const Color(0xFF5D4037), width: 5),
          boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 10)],
        ),
        child: LayoutBuilder(builder: (context, cons) {
          if (chain.isEmpty) {
            return const Center(child: Text('DOMINO', style: TextStyle(fontSize: 34, color: Colors.white12, fontWeight: FontWeight.w900, letterSpacing: 4)));
          }
          final n = chain.length;
          final aw = cons.maxWidth - 20;
          final ah = cons.maxHeight - 14;
          double w = 12;
          int perRow = 1;
          for (double c = 30; c >= 12; c -= 1) {
            final pr = math.max(1, (aw / (2 * c + 3)).floor());
            final rows = (n / pr).ceil();
            w = c;
            perRow = pr;
            if (rows * (c + 6) <= ah) break;
          }
          final rows = <Widget>[];
          for (int r = 0; r * perRow < n; r++) {
            final from = r * perRow;
            final to = math.min(n, from + perRow);
            final rev = r.isOdd;
            final idx = [for (int i = from; i < to; i++) i];
            final order = rev ? idx.reversed.toList() : idx;
            rows.add(Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (final i in order)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 1.5),
                      child: DominoTile(
                        a: rev ? chain[i].r : chain[i].l,
                        b: rev ? chain[i].l : chain[i].r,
                        w: w,
                        highlight: myTurn && (i == 0 || i == n - 1),
                      ),
                    ),
                ],
              ),
            ));
          }
          return Center(child: Column(mainAxisSize: MainAxisSize.min, children: rows));
        }),
      ),
      midH: 150,
      mid: Column(
        children: [
          SizedBox(
            height: 46,
            child: selected == null
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                    child: Row(children: [
                      Expanded(child: GoldButton(label: 'الطرف الأيسر ($leftEnd)', outlined: true, onTap: () => _human(selected!, true))),
                      const SizedBox(width: 10),
                      Expanded(child: GoldButton(label: 'الطرف الأيمن ($rightEnd)', onTap: () => _human(selected!, false))),
                    ]),
                  ),
          ),
          SizedBox(
            height: 100,
            child: LayoutBuilder(builder: (context, cons) {
              final tw = math.max(20.0, math.min(40.0, (cons.maxWidth - 24) / 7 - 8));
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (final t in me)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: DominoTile(
                        a: t.a,
                        b: t.b,
                        w: tw,
                        vertical: true,
                        highlight: myTurn && _fits(t) && selected == null,
                        dim: myTurn && !_fits(t),
                        onTap: () => _tapTile(t),
                      ),
                    ),
                ],
              );
            }),
          ),
        ],
      ),
      badges: const SizedBox.shrink(),
      chat: ChatPanel(messages: chat),
      bar: ChatAndControlsBar(
        onSendChat: (txt) {
          setState(() => chat.add('${AppState.I.myName}: $txt'));
          Future.delayed(const Duration(milliseconds: 1200), () {
            if (!mounted) return;
            setState(() => chat.add('${names[1 + rnd.nextInt(3)]}: ${BotChat.random()}'));
          });
        },
        onSendEmoji: (em) => setState(() => chat.add('${AppState.I.myName}: $em')),
        onSendRose: () => showRoseFeedback(context),
      ),
    );
  }
}


// ================= المتجر: كروت شحن الموبايل + الهدايا =================
class Carrier {
  final String name;
  final Color color;
  const Carrier(this.name, this.color);
}

class Country {
  final String name;
  final String flag;
  final String dial;
  final String currency;
  final List<Carrier> carriers;
  final List<int> tiers; // قيمة الكرت بعملة الدولة
  const Country(this.name, this.flag, this.dial, this.currency, this.carriers, this.tiers);
}

const List<int> kTierCoins = [500, 1500, 5000, 12000];
const List<int> kTierRoses = [10, 30, 100, 250];

const List<Country> kCountries = [
  Country('العراق', '🇮🇶', '+964', 'د.ع', [Carrier('زين العراق', Color(0xFF8E24AA)),Carrier('آسياسيل', Color(0xFFE53935)),Carrier('كورك', Color(0xFF1E88E5))], [5000, 10000, 25000, 50000]),
  Country('السعودية', '🇸🇦', '+966', 'ر.س', [Carrier('STC', Color(0xFF8E24AA)),Carrier('موبايلي', Color(0xFF00897B)),Carrier('زين السعودية', Color(0xFFD81B60))], [10, 20, 50, 100]),
  Country('مصر', '🇪🇬', '+20', 'ج.م', [Carrier('فودافون', Color(0xFFE53935)),Carrier('أورنج', Color(0xFFFB8C00)),Carrier('اتصالات', Color(0xFF43A047)),Carrier('WE', Color(0xFF5E35B1))], [10, 25, 50, 100]),
  Country('الإمارات', '🇦🇪', '+971', 'د.إ', [Carrier('اتصالات e&', Color(0xFF43A047)),Carrier('دو du', Color(0xFF1E88E5))], [10, 25, 50, 100]),
  Country('الكويت', '🇰🇼', '+965', 'د.ك', [Carrier('زين', Color(0xFF8E24AA)),Carrier('أوريدو', Color(0xFFE53935)),Carrier('STC', Color(0xFF6A1B9A))], [2, 5, 10, 20]),
  Country('الأردن', '🇯🇴', '+962', 'د.أ', [Carrier('زين', Color(0xFF8E24AA)),Carrier('أورنج', Color(0xFFFB8C00)),Carrier('أمنية', Color(0xFF1E88E5))], [5, 10, 20, 50]),
  Country('قطر', '🇶🇦', '+974', 'ر.ق', [Carrier('أوريدو', Color(0xFFE53935)),Carrier('فودافون', Color(0xFFC62828))], [10, 20, 50, 100]),
  Country('المغرب', '🇲🇦', '+212', 'د.م', [Carrier('اتصالات المغرب', Color(0xFF1565C0)),Carrier('أورنج', Color(0xFFFB8C00)),Carrier('إنوي', Color(0xFF7E57C2))], [20, 50, 100, 200]),
  Country('السودان', '🇸🇩', '+249', 'ج.س', [Carrier('زين السودان', Color(0xFF8E24AA)),Carrier('MTN', Color(0xFFFBC02D)),Carrier('سوداني', Color(0xFF43A047))], [1000, 2000, 5000, 10000]),
  Country('ليبيا', '🇱🇾', '+218', 'د.ل', [Carrier('ليبيانا', Color(0xFFFB8C00)),Carrier('المدار', Color(0xFF1E88E5))], [5, 10, 20, 50]),
  Country('تونس', '🇹🇳', '+216', 'د.ت', [Carrier('أوريدو تونس', Color(0xFFE53935)),Carrier('تونس تيليكوم', Color(0xFF1E88E5)),Carrier('أورنج', Color(0xFFFB8C00))], [5, 10, 20, 50]),
  Country('الجزائر', '🇩🇿', '+213', 'د.ج', [Carrier('موبيليس', Color(0xFF43A047)),Carrier('جيزي', Color(0xFFE53935)),Carrier('أوريدو', Color(0xFFC62828))], [500, 1000, 2000, 5000]),
  Country('لبنان', '🇱🇧', '+961', 'دولار', [Carrier('ألفا', Color(0xFFE53935)),Carrier('تاتش', Color(0xFF1E88E5))], [5, 10, 20, 50]),
  Country('سوريا', '🇸🇾', '+963', 'ل.س', [Carrier('سيريتل', Color(0xFFE53935)),Carrier('MTN', Color(0xFFFBC02D))], [10000, 25000, 50000, 100000]),
  Country('اليمن', '🇾🇪', '+967', 'ر.ي', [Carrier('يمن موبايل', Color(0xFF43A047)),Carrier('سبأفون', Color(0xFF1E88E5)),Carrier('واي', Color(0xFFFB8C00))], [1000, 2000, 5000, 10000]),
  Country('عُمان', '🇴🇲', '+968', 'ر.ع', [Carrier('عمانتل', Color(0xFF1E88E5)),Carrier('أوريدو', Color(0xFFE53935))], [2, 5, 10, 20]),
  Country('البحرين', '🇧🇭', '+973', 'د.ب', [Carrier('بتلكو', Color(0xFF1E88E5)),Carrier('زين', Color(0xFF8E24AA)),Carrier('STC', Color(0xFF6A1B9A))], [2, 5, 10, 20]),
  Country('فلسطين', '🇵🇸', '+970', '₪', [Carrier('جوال', Color(0xFFFB8C00)),Carrier('أوريدو', Color(0xFFE53935))], [10, 20, 50, 100]),
  Country('موريتانيا', '🇲🇷', '+222', 'أوقية', [Carrier('ماتل', Color(0xFF43A047)),Carrier('شنقيتل', Color(0xFFFB8C00)),Carrier('موريتل', Color(0xFF1E88E5))], [200, 500, 1000, 2000]),
  Country('الصومال', '🇸🇴', '+252', 'دولار', [Carrier('هرمود', Color(0xFF43A047)),Carrier('تيليسوم', Color(0xFF1E88E5))], [2, 5, 10, 20]),
  Country('جيبوتي', '🇩🇯', '+253', 'ف.ج', [Carrier('جيبوتي تيليكوم', Color(0xFF1E88E5))], [500, 1000, 2000, 5000]),
  Country('جزر القمر', '🇰🇲', '+269', 'ف.ق', [Carrier('تيليما', Color(0xFFE53935)),Carrier('هورية', Color(0xFF43A047))], [1000, 2000, 5000, 10000]),
];

// ================= عجلة الحظ =================
const List<int> kWheel = [10, 0, 20, 0, 30, 0, 40, 0];

class _WheelPainter extends CustomPainter {
  const _WheelPainter();
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2 - 4;
    const cols = [Color(0xFF8E24AA), Color(0xFF37474F)];
    for (int i = 0; i < 8; i++) {
      final a0 = -math_pi / 2 + i * math_pi / 4;
      canvas.drawArc(Rect.fromCircle(center: c, radius: r), a0, math_pi / 4, true,
          Paint()..color = kWheel[i] == 0 ? cols[1] : (i % 4 == 0 ? const Color(0xFFE65100) : cols[0]));
      canvas.drawArc(
          Rect.fromCircle(center: c, radius: r),
          a0,
          math_pi / 4,
          true,
          Paint()
            ..color = Colors.white24
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2);
      final mid = a0 + math_pi / 8;
      final p = c + Offset(math.cos(mid), math.sin(mid)) * (r * 0.68);
      final tp = TextPainter(
        text: TextSpan(
            text: kWheel[i] == 0 ? '💀' : '${kWheel[i]}',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: kWheel[i] == 0 ? 26 : 24)),
        textDirection: TextDirection.ltr,
      )..layout();
      canvas.save();
      canvas.translate(p.dx, p.dy);
      canvas.rotate(mid + math_pi / 2);
      tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
      canvas.restore();
    }
    canvas.drawCircle(c, r * 0.14, Paint()..color = Pal.gold);
    canvas.drawCircle(
        c,
        r,
        Paint()
          ..color = Pal.gold
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class WheelView extends StatefulWidget {
  const WheelView({super.key});
  @override
  State<WheelView> createState() => _WheelViewState();
}

class _WheelViewState extends State<WheelView> with SingleTickerProviderStateMixin {
  late final AnimationController ctrl;
  double from = 0, to = 0;
  bool spinning = false;
  final math.Random rnd = math.Random();

  @override
  void initState() {
    super.initState();
    ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 4200));
  }

  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();
  }

  int _pick() {
    // أوزان قوية للفوز: 10(30) 20(25) 30(15) 40(5) جمجمة(25 موزعة على 4 خانات)
    final r = rnd.nextInt(100);
    if (r < 30) return 0;
    if (r < 55) return 2;
    if (r < 70) return 4;
    if (r < 75) return 6;
    return [1, 3, 5, 7][rnd.nextInt(4)];
  }

  void _spin() {
    if (spinning) return;
    if (!UserData.canSpin) {
      _toastCtx(context, 'استخدمت محاولتك اليوم. عد غداً 🎡');
      return;
    }
    UserData.markSpun();
    final i = _pick();
    final target = 2 * math_pi * 6 - (i + 0.5) * math_pi / 4;
    setState(() {
      spinning = true;
      from = to % (2 * math_pi);
      to = target;
    });
    ctrl.forward(from: 0).then((_) {
      if (!mounted) return;
      final prize = kWheel[i];
      setState(() => spinning = false);
      if (prize > 0) {
        UserData.addCoins(prize);
        SoundManager.coin();
        _toastCtx(context, '🎉 ربحت $prize عملة من عجلة الحظ!');
      } else {
        _toastCtx(context, '💀 جمجمة! حظ أوفر غداً');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final can = UserData.canSpin;
    return Column(children: [
      const SizedBox(height: 6),
      const Text('عجلة الحظ 🎡', style: TextStyle(color: Pal.gold, fontSize: 20, fontWeight: FontWeight.w900)),
      const SizedBox(height: 4),
      const Text('لفة واحدة يومياً، والجائزة الكبرى 40 عملة', style: TextStyle(color: Pal.muted, fontSize: 12)),
      const SizedBox(height: 14),
      SizedBox(
        width: 270,
        height: 290,
        child: Stack(alignment: Alignment.topCenter, children: [
          Positioned(
            top: 16,
            child: AnimatedBuilder(
              animation: ctrl,
              builder: (c, _) {
                final t = Curves.easeOutCubic.transform(ctrl.value);
                final ang = from + (to - from) * t;
                return Transform.rotate(
                  angle: ang,
                  child: const SizedBox(width: 260, height: 260, child: CustomPaint(painter: _WheelPainter())),
                );
              },
            ),
          ),
          const Icon(Icons.arrow_drop_down, color: Colors.white, size: 46),
        ]),
      ),
      const SizedBox(height: 8),
      GoldButton(label: can ? 'لُف العجلة' : 'عد غداً', icon: Icons.casino, busy: spinning, onTap: can ? _spin : null),
      const SizedBox(height: 22),
      ValueListenableBuilder<int>(
        valueListenable: UserData.tick,
        builder: (c, _, __) {
          final prog = (UserData.earned / 5000).clamp(0.0, 1.0).toDouble();
          return Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: Pal.card, borderRadius: BorderRadius.circular(18)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('مكافأة الإنجاز 🏅', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('كل 5000 عملة تربحها تحصل على 500 عملة ذهبية', style: const TextStyle(color: Pal.muted, fontSize: 12)),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(value: prog, minHeight: 10, backgroundColor: Colors.white12, color: Pal.gold),
              ),
              const SizedBox(height: 4),
              Text('${UserData.earned} / 5000', style: const TextStyle(color: Pal.muted, fontSize: 11)),
              const SizedBox(height: 10),
              GoldButton(
                label: 'استلام 500 عملة',
                onTap: UserData.earned >= 5000
                    ? () {
                        UserData.claimMilestone();
                        SoundManager.coin();
                        _toastCtx(context, '🎉 تم استلام 500 عملة ذهبية');
                      }
                    : null,
              ),
            ]),
          );
        },
      ),
    ]);
  }
}

const List<String> kPackUsd = ['0.99', '2.99', '7.99', '17.99'];

/// أنواع البطاقات المتاحة حسب الدولة (تقريبية، راجع مزوّد الدفع)
List<String> cardSchemes(String country) {
  switch (country) {
    case 'مصر':
      return ['Visa', 'Mastercard', 'Meeza ميزة'];
    case 'السعودية':
      return ['مدى mada', 'Visa', 'Mastercard'];
    case 'الكويت':
      return ['KNET كي نت', 'Visa', 'Mastercard'];
    case 'البحرين':
      return ['BENEFIT بنفت', 'Visa', 'Mastercard'];
    case 'عُمان':
      return ['OmanNet', 'Visa', 'Mastercard'];
    case 'قطر':
      return ['NAPS', 'Visa', 'Mastercard'];
    case 'المغرب':
      return ['CMI', 'Visa', 'Mastercard'];
    case 'الجزائر':
      return ['CIB', 'الذهبية Edahabia', 'Visa', 'Mastercard'];
    case 'تونس':
      return ['e-DINAR', 'Visa', 'Mastercard'];
    case 'العراق':
      return ['Visa', 'Mastercard', 'Qi Card'];
    default:
      return ['Visa', 'Mastercard'];
  }
}

class ShopView extends StatefulWidget {
  const ShopView({super.key});

  @override
  State<ShopView> createState() => _ShopViewState();
}

class _ShopViewState extends State<ShopView> {
  int seg = 0; // 0 شحن ، 1 هدايا
  int country = 0, carrier = 0, tier = 1;
  int mode = 0, scheme = 0, pack = 1;
  bool busy = false;
  final TextEditingController pin = TextEditingController();

  @override
  void dispose() {
    pin.dispose();
    super.dispose();
  }

  void _toast(String t) {
    final m = ScaffoldMessenger.of(context);
    m.hideCurrentSnackBar();
    m.showSnackBar(SnackBar(duration: const Duration(milliseconds: 1800), content: rtl(Text(t))));
  }

  Future<void> _redeem() async {
    final digits = pin.text.trim();
    if (digits.length < 12 || digits.length > 16) {
      _toast('رقم الكرت يجب أن يكون بين 12 و 16 رقماً');
      return;
    }
    setState(() => busy = true);
    final ok = await PaymentService.redeemCard(digits);
    if (!mounted) return;
    setState(() => busy = false);
    if (ok) {
      UserData.addCoins(kTierCoins[tier]);
      UserData.addRoses(kTierRoses[tier]);
      Stats.mine.kickCost += 10;
      pin.clear();
      showDialog<void>(
        context: context,
        builder: (ctx) => rtl(AlertDialog(
          backgroundColor: Pal.card,
          title: const Text('تم الشحن بنجاح 🎉', style: TextStyle(color: Pal.gold, fontWeight: FontWeight.bold)),
          content: Text('أضيف ${kTierCoins[tier]} عملة و ${kTierRoses[tier]} وردة إلى رصيدك.',
              style: const TextStyle(color: Colors.white)),
          actions: [TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('حسناً'))],
        )),
      );
    } else {
      _toast('تعذر التحقق من الكرت. تأكد من الرقم وحاول مجدداً');
    }
  }

  void _pickCountry() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Pal.card,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => rtl(SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(12),
          children: [
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text('اختر دولتك', style: TextStyle(color: Pal.gold, fontSize: 17, fontWeight: FontWeight.bold)),
            ),
            for (int i = 0; i < kCountries.length; i++)
              ListTile(
                leading: Text(kCountries[i].flag, style: const TextStyle(fontSize: 26)),
                title: Text(kCountries[i].name, style: const TextStyle(color: Colors.white)),
                trailing: i == country ? const Icon(Icons.check_circle, color: Pal.gold) : null,
                onTap: () {
                  setState(() {
                    country = i;
                    carrier = 0;
                    scheme = 0;
                  });
                  Navigator.of(ctx).pop();
                },
              ),
          ],
        ),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return rtl(ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(color: Pal.card, borderRadius: BorderRadius.circular(16)),
          child: Row(children: [
            _seg('شحن العملات', 0),
            _seg('الهدايا', 1),
            _seg('عجلة الحظ', 2),
          ]),
        ),
        const SizedBox(height: 16),
        if (seg == 0) ..._topup() else if (seg == 1) ..._gifts() else const WheelView(),
      ],
    ));
  }

  Widget _seg(String t, int i) => Expanded(
        child: GestureDetector(
          onTap: () => setState(() => seg = i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 11),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: seg == i ? const LinearGradient(colors: [Pal.gold, Pal.goldDeep]) : null,
            ),
            child: Text(t,
                style: TextStyle(
                    color: seg == i ? Colors.black87 : Pal.muted, fontWeight: FontWeight.bold, fontSize: 14)),
          ),
        ),
      );

  Widget _label(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 8, top: 4),
        child: Text(t, style: const TextStyle(color: Pal.muted, fontSize: 13, fontWeight: FontWeight.w600)),
      );

  Widget _modeBtn(String t, int i) => Expanded(
        child: GestureDetector(
          onTap: () => setState(() => mode = i),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: mode == i ? Pal.gold : Colors.white24, width: 1.5),
              color: mode == i ? Pal.card2 : Colors.transparent,
            ),
            child: Text(t, style: TextStyle(color: mode == i ? Pal.gold : Pal.muted, fontWeight: FontWeight.bold, fontSize: 13)),
          ),
        ),
      );

  List<Widget> _topup() => [
        Row(children: [
          _modeBtn('📱 كرت شحن موبايل', 0),
          const SizedBox(width: 10),
          _modeBtn('💳 فيزا / ماستر', 1),
        ]),
        const SizedBox(height: 14),
        ...(mode == 0 ? _topupMobile() : _topupCard()),
      ];

  Future<void> _payCard() async {
    final c = kCountries[country];
    final schemes = cardSchemes(c.name);
    final sc = schemes[scheme.clamp(0, schemes.length - 1)];
    setState(() => busy = true);
    final ok = await PaymentService.cardCheckout(c.name, sc, pack);
    if (!mounted) return;
    setState(() => busy = false);
    if (ok) {
      UserData.addCoins(kTierCoins[pack]);
      UserData.addRoses(kTierRoses[pack]);
      Stats.mine.kickCost += 10;
      showDialog<void>(
        context: context,
        builder: (ctx) => rtl(AlertDialog(
          backgroundColor: Pal.card,
          title: const Text('تمت العملية 🎉', style: TextStyle(color: Pal.gold, fontWeight: FontWeight.bold)),
          content: Text('أضيف ${kTierCoins[pack]} عملة و ${kTierRoses[pack]} وردة إلى رصيدك.', style: const TextStyle(color: Colors.white)),
          actions: [TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('حسناً'))],
        )),
      );
    } else {
      _toast('تعذر إتمام الدفع. حاول مجدداً');
    }
  }

  List<Widget> _topupCard() {
    final c = kCountries[country];
    final schemes = cardSchemes(c.name);
    final sIdx = scheme.clamp(0, schemes.length - 1);
    return [
      _label('1. اختر دولتك'),
      GestureDetector(
        onTap: _pickCountry,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(color: Pal.card, borderRadius: BorderRadius.circular(14)),
          child: Row(children: [
            Text(c.flag, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 10),
            Expanded(child: Text(c.name, style: const TextStyle(color: Colors.white, fontSize: 15))),
            const Icon(Icons.keyboard_arrow_down, color: Pal.muted),
          ]),
        ),
      ),
      const SizedBox(height: 14),
      _label('2. نوع البطاقة'),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (int i = 0; i < schemes.length; i++)
            GestureDetector(
              onTap: () => setState(() => scheme = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: sIdx == i ? Pal.card2 : Pal.card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: sIdx == i ? Pal.gold : Colors.white24, width: 1.5),
                ),
                child: Text('💳 ${schemes[i]}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
              ),
            ),
        ],
      ),
      const SizedBox(height: 14),
      _label('3. اختر الباقة'),
      GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.9,
        children: [
          for (int i = 0; i < 4; i++)
            GestureDetector(
              onTap: () => setState(() => pack = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: pack == i ? const LinearGradient(colors: [Color(0xFF5E2A7A), Color(0xFF8E3CB0)]) : null,
                  color: pack == i ? null : Pal.card,
                  border: Border.all(color: pack == i ? Pal.gold : Colors.transparent, width: 2),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${kTierCoins[i]} عملة', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 3),
                    Text('${kPackUsd[i]} USD  +  ${kTierRoses[i]} 🌹', style: const TextStyle(color: Pal.gold, fontSize: 12)),
                  ],
                ),
              ),
            ),
        ],
      ),
      const SizedBox(height: 16),
      GoldButton(label: 'ادفع بالبطاقة', icon: Icons.lock, busy: busy, onTap: _payCard),
      const SizedBox(height: 10),
      Text(
        kDemoMode
            ? 'وضع تجريبي: لا يُخصم أي مبلغ ولا تُدخل بيانات بطاقتك.'
            : 'يتم الدفع عبر صفحة آمنة من مزوّد الدفع، ولا يستقبل التطبيق بيانات بطاقتك.',
        textAlign: TextAlign.center,
        style: const TextStyle(color: Pal.muted, fontSize: 11),
      ),
    ];
  }

  List<Widget> _topupMobile() {
    final c = kCountries[country];
    return [
      _label('1. اختر دولتك'),
      GestureDetector(
        onTap: _pickCountry,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(color: Pal.card, borderRadius: BorderRadius.circular(14)),
          child: Row(children: [
            Text(c.flag, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 10),
            Expanded(child: Text(c.name, style: const TextStyle(color: Colors.white, fontSize: 15))),
            const Icon(Icons.keyboard_arrow_down, color: Pal.muted),
          ]),
        ),
      ),
      const SizedBox(height: 14),
      _label('2. اختر شبكة الاتصال'),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (int i = 0; i < c.carriers.length; i++)
            GestureDetector(
              onTap: () => setState(() => carrier = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: carrier == i ? c.carriers[i].color : Pal.card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: carrier == i ? Colors.white : c.carriers[i].color, width: 1.5),
                ),
                child: Text(c.carriers[i].name,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
              ),
            ),
        ],
      ),
      const SizedBox(height: 14),
      _label('3. اختر قيمة الكرت'),
      GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.9,
        children: [
          for (int i = 0; i < 4; i++)
            GestureDetector(
              onTap: () => setState(() => tier = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: tier == i
                      ? const LinearGradient(colors: [Color(0xFF5E2A7A), Color(0xFF8E3CB0)])
                      : null,
                  color: tier == i ? null : Pal.card,
                  border: Border.all(color: tier == i ? Pal.gold : Colors.transparent, width: 2),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${c.tiers[i]} ${c.currency}',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 3),
                    Text('${kTierCoins[i]} عملة + ${kTierRoses[i]} 🌹',
                        style: const TextStyle(color: Pal.gold, fontSize: 12)),
                  ],
                ),
              ),
            ),
        ],
      ),
      const SizedBox(height: 14),
      _label('4. أدخل رقم الكرت'),
      TextField(
        controller: pin,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(16)],
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, fontSize: 18, letterSpacing: 2),
        decoration: InputDecoration(
          hintText: '•••• •••• •••• ••••',
          hintStyle: const TextStyle(color: Colors.white30),
          filled: true,
          fillColor: Pal.card,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
        ),
      ),
      const SizedBox(height: 14),
      GoldButton(label: 'شحن الرصيد', icon: Icons.bolt, busy: busy, onTap: _redeem),
      const SizedBox(height: 10),
      Text(
        'كرت ${c.carriers[carrier].name} بقيمة ${c.tiers[tier]} ${c.currency}. يتم التحقق من الكرت قبل إضافة الرصيد.',
        textAlign: TextAlign.center,
        style: const TextStyle(color: Pal.muted, fontSize: 11),
      ),
    ];
  }

  Widget _gift(String emoji, String title, int roses, int cost) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: Pal.card, borderRadius: BorderRadius.circular(18)),
        child: Row(children: [
          Container(
            width: 54,
            height: 54,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(colors: [Color(0xFFFF5F8D), Color(0xFFC2185B)]),
            ),
            child: Text(emoji, style: const TextStyle(fontSize: 28)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 2),
              Text('$roses وردة تُرسل في الدردشة', style: const TextStyle(color: Pal.muted, fontSize: 12)),
            ]),
          ),
          SizedBox(
            width: 104,
            child: GoldButton(
              label: '$cost 🪙',
              onTap: () {
                if (UserData.coins < cost) {
                  _toast('رصيدك لا يكفي، اشحن العملات أولاً');
                  return;
                }
                UserData.addCoins(-cost);
                UserData.addRoses(roses);
                _toast('تم شراء $title');
              },
            ),
          ),
        ]),
      );

  List<Widget> _gifts() => [
        const Text('اختر هدية وأرسلها لأي لاعب أو صديق، أو أهدِ عملات مباشرة', style: TextStyle(color: Pal.muted, fontSize: 12)),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.9,
          children: [
            for (final g in kGifts)
              GestureDetector(
                onTap: () => showGiftSheet(context),
                child: Container(
                  decoration: BoxDecoration(color: Pal.card, borderRadius: BorderRadius.circular(16)),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(g.emoji, style: const TextStyle(fontSize: 34)),
                    const SizedBox(height: 4),
                    Text(g.name, style: const TextStyle(color: Colors.white, fontSize: 12)),
                    Text('🪙 ${g.cost}', style: const TextStyle(color: Pal.gold, fontWeight: FontWeight.bold, fontSize: 12)),
                  ]),
                ),
              ),
          ],
        ),
        const SizedBox(height: 14),
        GoldButton(label: 'إهداء الآن', icon: Icons.card_giftcard, onTap: () => showGiftSheet(context)),
      ];
}
