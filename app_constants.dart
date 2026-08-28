class AppConstants {
  AppConstants._();

  static const String appName = 'Play and Win';
  static const String appVersion = '1.0.0';
  static const int appVersionCode = 1;

  // Firestore collection names
  static const String usersCollection = 'users';
  static const String tournamentsCollection = 'tournaments';
  static const String gamesCollection = 'games';
  static const String matchesCollection = 'matches';
  static const String transactionsCollection = 'transactions';
  static const String prizesCollection = 'prizes';
  static const String leaderboardCollection = 'leaderboard';
  static const String notificationsCollection = 'notifications';

  // Animation durations
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration splashDuration = Duration(seconds: 3);

  // Pagination
  static const int pageSize = 20;

  // Tournament settings
  static const int maxPlayersPerRoom = 100;
  static const int minPlayersPerTournament = 2;
  static const Duration tournamentStartBuffer = Duration(minutes: 5);

  // Wallet
  static const double minWithdrawalAmount = 5.0;
  static const double maxWithdrawalAmount = 1000.0;
  static const double platformFeePercentage = 10.0;

  // Storage paths
  static const String userAvatarsPath = 'user_avatars';
  static const String gameImagesPath = 'game_images';
  static const String tournamentBannersPath = 'tournament_banners';
}
