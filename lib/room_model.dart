class GameRoom {
  final String roomId;
  final String roomName;
  bool isLocked;
  int lockCost; // التكلفة بالعملات لإغلاق الغرفة
  List<String> waitingPlayers; // غرفة انتظار الأصدقاء أعلى شاشة اللعب
  List<String> activeMics; // المستخدمين الفاتحين للمايك للدردشة الصوتية
  bool isPublicVoiceGroup; // دردشة صوتية جماعية عامة أم خاصة

  GameRoom({
    required this.roomId,
    required this.roomName,
    this.isLocked = false,
    this.lockCost = 100, // 100 عملة لإغلاق الغرفة
    List<String>? waitingPlayers,
    List<String>? activeMics,
    this.isPublicVoiceGroup = false,
  })  : waitingPlayers = waitingPlayers ?? [],
        activeMics = activeMics ?? [];

  // إغلاق الغرفة مقابل العملات
  bool lockRoom(int userCoins) {
    if (!isLocked && userCoins >= lockCost) {
      isLocked = true;
      return true;
    }
    return false;
  }

  // إضافة لاعب لغرفة الانتظار أعلى شاشة اللعب
  void addPlayerToWaitingRoom(String playerName) {
    if (!waitingPlayers.contains(playerName)) {
      waitingPlayers.add(playerName);
    }
  }

  // فتح المايك للدردشة الصوتية
  void toggleMic(String playerName) {
    if (activeMics.contains(playerName)) {
      activeMics.remove(playerName);
    } else {
      activeMics.add(playerName);
    }
  }
}
