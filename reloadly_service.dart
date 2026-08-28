import 'package:dio/dio.dart';
import '../../core/constants/reloadly_config.dart';

class ReloadlyService {
  ReloadlyService._();

  static final ReloadlyService instance = ReloadlyService._();

  String? _accessToken;
  DateTime? _tokenExpiry;

  final Dio _dio = Dio(BaseOptions(
    connectTimeout: ReloadlyConfig.requestTimeout,
    receiveTimeout: ReloadlyConfig.requestTimeout,
  sendTimeout: ReloadlyConfig.requestTimeout,
  headers: {'Content-Type': 'application/json'},
  ));

  bool get _hasValidToken =>
      _accessToken != null &&
      _tokenExpiry != null &&
      DateTime.now().isBefore(_tokenExpiry!);

  Future<String> _getAccessToken() async {
    if (_hasValidToken) return _accessToken!;

    final response = await _dio.post(
      ReloadlyConfig.tokenEndpoint,
      data: {
        'client_id': ReloadlyConfig.clientId,
        'client_secret': ReloadlyConfig.clientSecret,
        'grant_type': 'client_credentials',
        'audience': ReloadlyConfig.tokenAudience,
      },
    );

    _accessToken = response.data['access_token'] as String;
    final expiresIn = response.data['expires_in'] as int;
    _tokenExpiry = DateTime.now().add(Duration(seconds: expiresIn - 60));
    return _accessToken!;
  }

  Future<Map<String, dynamic>> _authenticatedGet(String url) async {
    final token = await _getAccessToken();
    final response = await _dio.get(
      url,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> _authenticatedPost(
    String url,
    Map<String, dynamic> data,
  ) async {
    final token = await _getAccessToken();
    final response = await _dio.post(
      url,
      data: data,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return response.data as Map<String, dynamic>;
  }

  Future<List<Map<String, dynamic>>> getGiftCards({
    int page = 1,
    int size = 50,
  }) async {
    final token = await _getAccessToken();
    final response = await _dio.get(
      '${ReloadlyConfig.giftCardsEndpoint}?size=$size&page=$page',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return (response.data['content'] as List)
        .map((e) => e as Map<String, dynamic>)
        .toList();
  }

  Future<Map<String, dynamic>> getGiftCard(int productId) async {
    return _authenticatedGet('${ReloadlyConfig.giftCardsEndpoint}/$productId');
  }

  Future<Map<String, dynamic>> redeemGiftCard({
    required int productId,
    required String recipientEmail,
    required double amount,
    String? customIdentifier,
  }) async {
    return _authenticatedPost(ReloadlyConfig.redeemEndpoint, {
      'productId': productId,
      'recipient': {'email': recipientEmail},
      'amount': amount,
      'customIdentifier': customIdentifier ?? 'play_and_win_${DateTime.now().millisecondsSinceEpoch}',
    });
  }

  Future<List<Map<String, dynamic>>> getOperators({
    int page = 1,
    int size = 50,
  }) async {
    final token = await _getAccessToken();
    final response = await _dio.get(
      '${ReloadlyConfig.operatorsEndpoint}?size=$size&page=$page',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return (response.data['content'] as List)
        .map((e) => e as Map<String, dynamic>)
        .toList();
  }

  Future<Map<String, dynamic>> mobileTopUp({
    required String operatorId,
    required String recipientPhone,
    required double amount,
    String? senderPhone,
    String? customIdentifier,
  }) async {
    return _authenticatedPost(ReloadlyConfig.topupsEndpoint, {
      'operator': operatorId,
      'recipient': {'mobile': recipientPhone},
      'amount': amount,
      'sender': senderPhone != null ? {'mobile': senderPhone} : null,
      'customIdentifier': customIdentifier ?? 'play_and_win_${DateTime.now().millisecondsSinceEpoch}',
    });
  }

  Future<List<Map<String, dynamic>>> getCountries() async {
    final token = await _getAccessToken();
    final response = await _dio.get(
      '${ReloadlyConfig.countriesEndpoint}?size=200',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return (response.data['content'] as List)
        .map((e) => e as Map<String, dynamic>)
        .toList();
  }
}
