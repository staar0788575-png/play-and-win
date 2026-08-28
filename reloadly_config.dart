class ReloadlyConfig {
  ReloadlyConfig._();

  static const String clientId = String.fromEnvironment(
    'RELOADLY_CLIENT_ID',
    defaultValue: 'your_reloadly_client_id',
  );

  static const String clientSecret = String.fromEnvironment(
    'RELOADLY_CLIENT_SECRET',
    defaultValue: 'your_reloadly_client_secret',
  );

  static const bool sandbox = bool.fromEnvironment(
    'RELOADLY_SANDBOX',
    defaultValue: true,
  );

  // API endpoints
  static const String authBaseUrl = sandbox
      ? 'https://auth.reloadly.com'
      : 'https://auth.reloadly.com';

  static const String giftCardsBaseUrl = sandbox
      ? 'https://giftcards-sandbox.reloadly.com'
      : 'https://giftcards.reloadly.com';

  static const String topupsBaseUrl = sandbox
      ? 'https://topups-sandbox.reloadly.com'
      : 'https://topups.reloadly.com';

  // Token endpoint
  static const String tokenEndpoint = '$authBaseUrl/oauth/token';
  static const String tokenAudience = sandbox
      ? 'https://giftcards-sandbox.reloadly.com'
      : 'https://giftcards.reloadly.com';

  // Gift card endpoints
  static const String giftCardsEndpoint = '$giftCardsBaseUrl/gift-cards';
  static const String redeemEndpoint = '$giftCardsBaseUrl/orders';

  // Mobile top-up endpoints
  static const String topupsEndpoint = '$topupsBaseUrl/topups';
  static const String operatorsEndpoint = '$topupsBaseUrl/operators';
  static const String countriesEndpoint = '$topupsBaseUrl/countries';

  // Request timeout
  static const Duration requestTimeout = Duration(seconds: 30);
}
