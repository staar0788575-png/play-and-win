import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';
import 'package:flutter/services.dart';

void main() {
  runApp(const PlayAndWinApp());
}



// ================= الأساسيات: الألوان والنماذج والخدمات =================

/// وضع تجريبي: الدخول والغرف والدفع تعمل محلياً بدون خادم.
/// اجعلها false بعد ربط خدمات حقيقية (Firebase أو خادم خاص).
const bool kDemoMode = true;

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
  static const List<SeatInfo> pool = [
    SeatInfo('سلطان', 1),
    SeatInfo('نورة', 10),
    SeatInfo('ليث', 2),
    SeatInfo('ريم', 6),
    SeatInfo('فهد', 3),
    SeatInfo('هديل', 9),
    SeatInfo('زياد', 7),
    SeatInfo('لمى', 11),
  ];
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
    int k = 0;
    while (res.length < n && k < 60) {
      final b = Bots.pool[k % Bots.pool.length];
      k++;
      if (res.any((s) => s.name == b.name)) continue;
      res.add(b);
    }
    return res;
  }
}

// ---------- حالة التطبيق ----------
class AppState extends ChangeNotifier {
  AppState._();
  static final AppState I = AppState._();

  Profile? me;
  bool aimDirect = true;
  bool welcomeShown = false;
  GameRoom? currentRoom;

  String get myName => me?.name ?? 'أنت';
  int get myAvatar => me?.avatar ?? 0;

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
  static void dice() {
    if (enabled) HapticFeedback.mediumImpact();
  }

  static void move() {
    if (enabled) HapticFeedback.lightImpact();
  }

  static void capture() {
    if (enabled) HapticFeedback.heavyImpact();
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
    widget.onSendChat(text);
    chatCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      color: Pal.bg,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 40,
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
class PlayerBadge extends StatelessWidget {
  final String name;
  final Color color;
  final String badge;
  final bool active;
  final int avatar;

  const PlayerBadge({
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
              SoundManager.capture();
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
      if (p == 0) UserData.addCoins(100);
      if (!mounted) return;
      showWinDialog(
        context,
        p == 0 ? '🏆 مبروك، لقد فزت!' : 'انتهت اللعبة',
        p == 0 ? 'ربحت 100 عملة. هل تلعب مرة أخرى؟' : 'الفائز هو ${names[p]}. حظاً أوفر في المرة القادمة!',
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
    return Column(
      children: [
        Container(
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
        Padding(
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
              ),
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: LayoutBuilder(builder: (context, cons) {
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
        ),
        Expanded(flex: 2, child: ChatPanel(messages: publicChat)),
        ChatAndControlsBar(
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
      ],
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
      SoundManager.capture();
    } else if (shotByMe && eng.lastImpact > 1.2) {
      SoundManager.move();
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
      if (iWon) UserData.addCoins(100);
      eng.striker.out = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        showWinDialog(
          context,
          iWon ? '🏆 مبروك، لقد فزت!' : 'انتهت المباراة',
          iWon ? 'أسقطت كل قطعك البيضاء وربحت 100 عملة.' : 'أسقط الخصم كل قطعه. حاول مرة أخرى!',
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
    SoundManager.dice();
    setState(() {
      _launch(dir * (0.9 + power * 2.9), true);
      msg = 'تم التصويب...';
    });
  }

  // ---------- الواجهة ----------
  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
        Expanded(
          flex: 4,
          child: Center(
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
        ),
        // شريط تحريك القاطع
        Padding(
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              PlayerBadge(name: '${seats[0].name} ⚪', color: Colors.blueGrey, avatar: seats[0].avatar, badge: '$myScore', active: myTurn && !over),
              Text('${_count(CKind.white, out: true)} / ${_count(CKind.white)}   ·   ${_count(CKind.black, out: true)} / ${_count(CKind.black)}',
                  style: const TextStyle(color: Colors.white54, fontSize: 11)),
              PlayerBadge(name: '${seats[1].name} ⚫', color: Colors.deepPurple, avatar: seats[1].avatar, badge: '$botScore', active: !myTurn && !over),
            ],
          ),
        ),
        Expanded(
          flex: 3,
          child: ChatPanel(messages: messages.map((m) => "${m['user']}: ${m['text']}").toList()),
        ),
        ChatAndControlsBar(
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
      ],
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

    // الثعابين
    int k = 0;
    kSnakes.forEach((a, b) {
      final head = snakeCellCenter(a) * ce;
      final tail = snakeCellCenter(b) * ce;
      final v = tail - head;
      final len = v.distance;
      final d = v / len;
      final nrm = Offset(-d.dy, d.dx);
      final sign = k.isEven ? 1.0 : -1.0;
      k++;
      final amp = ce * 0.9 * sign;
      final path = Path()..moveTo(head.dx, head.dy);
      const seg = 24;
      for (int i = 1; i <= seg; i++) {
        final t = i / seg;
        final off = math.sin(t * math.pi * 3) * amp * (1 - 0.3 * t);
        final pt = head + v * t + nrm * off;
        path.lineTo(pt.dx, pt.dy);
      }
      canvas.drawPath(
        path,
        Paint()
          ..color = const Color(0xFF2E7D32)
          ..style = PaintingStyle.stroke
          ..strokeWidth = ce * 0.22
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
      canvas.drawPath(
        path,
        Paint()
          ..color = const Color(0xFF81C784)
          ..style = PaintingStyle.stroke
          ..strokeWidth = ce * 0.08
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
      canvas.drawCircle(head, ce * 0.2, Paint()..color = const Color(0xFF1B5E20));
      canvas.drawCircle(head + const Offset(-3, -2), 2, Paint()..color = Colors.white);
      canvas.drawCircle(head + const Offset(3, -2), 2, Paint()..color = Colors.white);
      canvas.drawCircle(head + const Offset(-3, -2), 1, Paint()..color = Colors.black);
      canvas.drawCircle(head + const Offset(3, -2), 1, Paint()..color = Colors.black);
      canvas.drawCircle(tail, ce * 0.07, Paint()..color = const Color(0xFF2E7D32));
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
        SoundManager.capture();
      } else if (kSnakes.containsKey(here)) {
        await Future.delayed(const Duration(milliseconds: 350));
        if (!mounted || g != gen) return;
        setState(() {
          pos[p] = kSnakes[here]!;
          msg = '${names[p]} لدغه ثعبان 🐍 إلى ${pos[p]}';
        });
        SoundManager.capture();
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
      if (p == 0) UserData.addCoins(100);
      if (!mounted) return;
      showWinDialog(
        context,
        p == 0 ? '🏆 مبروك، لقد فزت!' : 'انتهت اللعبة',
        p == 0 ? 'ربحت 100 عملة. هل تلعب مرة أخرى؟' : 'الفائز هو ${names[p]}. حظاً أوفر!',
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
    return Column(
      children: [
        Container(
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
        Padding(
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
              ),
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: LayoutBuilder(builder: (context, cons) {
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
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: DiceFace(
            value: dice,
            size: 54,
            accent: kSnakeColors[turn],
            active: canRoll,
            rolling: rolling,
            onTap: roll,
          ),
        ),
        Expanded(flex: 2, child: ChatPanel(messages: publicChat)),
        ChatAndControlsBar(
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
      ],
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
          HelpButton(gameId: widget.gameId),
          const SizedBox(width: 8),
          const Center(child: CoinChip()),
          const SizedBox(width: 10),
        ],
      ),
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
              ]),
            ),
            const Text('🏆', style: TextStyle(fontSize: 46)),
          ]),
        ),
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
                'الاهتزاز والمؤثرات',
                Switch(value: SoundManager.enabled, onChanged: (v) => setState(() => SoundManager.enabled = v)),
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
                begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFFFFFFFF), Color(0xFFEDE3CC)]),
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
    setState(() {
      over = true;
      msg = winTeam == 0
          ? 'فاز فريقك! 🏆'
          : winTeam == 1
              ? 'فاز الفريق الآخر'
              : 'تعادل';
    });
    if (winTeam == 0) UserData.addCoins(100);
    if (!mounted) return;
    showWinDialog(
      context,
      winTeam == 0 ? '🏆 مبروك، فاز فريقك!' : (winTeam == 1 ? 'انتهت اللعبة' : 'تعادل'),
      winTeam == 0 ? '$body\nربحت 100 عملة.' : body,
      _newGame,
    );
  }

  void _newGame() {
    setState(() {
      _deal();
    });
  }

  // ---------- الواجهة ----------
  Widget _badge(int p) => PlayerBadge(
        name: names[p],
        color: Colors.blueGrey,
        avatar: seats[p].avatar,
        badge: '${hands[p].length}',
        active: turn == p && !over,
      );

  @override
  Widget build(BuildContext context) {
    final me = hands[0];
    final myTurn = turn == 0 && !over && started;
    return Column(
      children: [
        Container(
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
              const Text('أنت وشريكك (المقابل) ضد الخصمين', style: TextStyle(color: Colors.white54, fontSize: 10)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [_badge(3), _badge(2), _badge(1)],
          ),
        ),
        Expanded(
          flex: 5,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: const RadialGradient(colors: [Color(0xFF1B7A4B), Color(0xFF0B4A2C)]),
              border: Border.all(color: const Color(0xFFFFD700), width: 3),
              boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 10)],
            ),
            child: LayoutBuilder(builder: (context, cons) {
              final w = math.max(16.0, math.min(30.0, (cons.maxWidth - 28) / 14));
              if (chain.isEmpty) {
                return const Center(child: Text('🀄', style: TextStyle(fontSize: 40, color: Colors.white24)));
              }
              return Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(10),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    runAlignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 3,
                    runSpacing: 5,
                    children: [
                      for (int i = 0; i < chain.length; i++)
                        DominoTile(
                          a: chain[i].l,
                          b: chain[i].r,
                          w: w,
                          vertical: chain[i].l == chain[i].r,
                          highlight: myTurn && (i == 0 || i == chain.length - 1),
                        ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
        if (selected != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            child: Row(children: [
              Expanded(child: GoldButton(label: 'الطرف الأيسر ($leftEnd)', outlined: true, onTap: () => _human(selected!, true))),
              const SizedBox(width: 10),
              Expanded(child: GoldButton(label: 'الطرف الأيمن ($rightEnd)', onTap: () => _human(selected!, false))),
            ]),
          ),
        SizedBox(
          height: 74,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            children: [
              for (final t in me)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: DominoTile(
                    a: t.a,
                    b: t.b,
                    w: 32,
                    vertical: true,
                    highlight: myTurn && _fits(t) && selected == null,
                    dim: myTurn && !_fits(t),
                    onTap: () => _tapTile(t),
                  ),
                ),
            ],
          ),
        ),
        Expanded(flex: 2, child: ChatPanel(messages: chat)),
        ChatAndControlsBar(
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
      ],
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
  Country('العراق', '🇮🇶', '+964', 'د.ع', [
    Carrier('زين العراق', Color(0xFF8E24AA)),
    Carrier('آسياسيل', Color(0xFFE53935)),
    Carrier('كورك', Color(0xFF1E88E5)),
  ], [5000, 10000, 25000, 50000]),
  Country('السعودية', '🇸🇦', '+966', 'ر.س', [
    Carrier('STC', Color(0xFF6A1B9A)),
    Carrier('موبايلي', Color(0xFF00897B)),
    Carrier('زين السعودية', Color(0xFFD81B60)),
  ], [10, 20, 50, 100]),
  Country('مصر', '🇪🇬', '+20', 'ج.م', [
    Carrier('فودافون', Color(0xFFE53935)),
    Carrier('أورنج', Color(0xFFFB8C00)),
    Carrier('اتصالات', Color(0xFF43A047)),
    Carrier('WE', Color(0xFF5E35B1)),
  ], [10, 25, 50, 100]),
  Country('الإمارات', '🇦🇪', '+971', 'د.إ', [
    Carrier('اتصالات e&', Color(0xFF43A047)),
    Carrier('دو du', Color(0xFF1E88E5)),
  ], [10, 25, 50, 100]),
  Country('الكويت', '🇰🇼', '+965', 'د.ك', [
    Carrier('زين', Color(0xFF8E24AA)),
    Carrier('أوريدو', Color(0xFFE53935)),
    Carrier('STC', Color(0xFF6A1B9A)),
  ], [2, 5, 10, 20]),
  Country('الأردن', '🇯🇴', '+962', 'د.أ', [
    Carrier('زين', Color(0xFF8E24AA)),
    Carrier('أورنج', Color(0xFFFB8C00)),
    Carrier('أمنية', Color(0xFF1E88E5)),
  ], [5, 10, 20, 50]),
  Country('قطر', '🇶🇦', '+974', 'ر.ق', [
    Carrier('أوريدو', Color(0xFFE53935)),
    Carrier('فودافون', Color(0xFFC62828)),
  ], [10, 20, 50, 100]),
  Country('المغرب', '🇲🇦', '+212', 'د.م', [
    Carrier('اتصالات المغرب', Color(0xFF1565C0)),
    Carrier('أورنج', Color(0xFFFB8C00)),
    Carrier('إنوي', Color(0xFF7E57C2)),
  ], [20, 50, 100, 200]),
];

class ShopView extends StatefulWidget {
  const ShopView({super.key});

  @override
  State<ShopView> createState() => _ShopViewState();
}

class _ShopViewState extends State<ShopView> {
  int seg = 0; // 0 شحن ، 1 هدايا
  int country = 0, carrier = 0, tier = 1;
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
            _seg('متجر الهدايا', 1),
          ]),
        ),
        const SizedBox(height: 16),
        if (seg == 0) ..._topup() else ..._gifts(),
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

  List<Widget> _topup() {
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
        _gift('🌹', 'وردة', 1, 10),
        _gift('💐', 'باقة ورد', 5, 45),
        _gift('🌹', 'حديقة ورد', 20, 160),
        _gift('👑', 'صندوق التاج', 50, 350),
      ];
}
