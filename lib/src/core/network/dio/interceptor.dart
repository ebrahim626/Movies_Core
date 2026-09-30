part of '../api_client.export.dart';

class DynamicInterceptor extends Interceptor {
  DynamicInterceptor({
    required this.baseUrl,
    required this.cacheService,
    required this.dio,
    this.refreshTokenUrl,
    this.onTokenRefresh,
  });

  final String baseUrl;
  final CacheService cacheService;
  final String? refreshTokenUrl;
  final Dio dio;
  final String Function(Map<String, dynamic>)? onTokenRefresh;

  @override
  Future<void> onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    try {
      final token = await cacheService.bearerToken;

      if (token != null && options.path.contains(baseUrl)) {
        options.headers['Authorization'] = 'Bearer $token';
      }

      handler.next(options); // Proceed with the request
    } catch (e) {
      // If any error occurs, proceed anyway
      handler.next(options);
    }
  }

  bool _shouldAttemptRefresh(DioException err) {
    final isRefreshCall =
        refreshTokenUrl != null &&
            err.requestOptions.path.contains(refreshTokenUrl!);
    return err.response?.statusCode == 401 && !isRefreshCall;
  }

  @override
  Future<void> onError(
      DioException err,
      ErrorInterceptorHandler handler,
      ) async {
    final alreadyRetried = err.requestOptions.extra['retried'] == true;

    if (_shouldAttemptRefresh(err) && !alreadyRetried) {
      try {
        final newToken = await _refreshToken();
        if (newToken != null) {
          await cacheService.setBearerToken(newToken);
          final newRequest = await _retryRequest(err.requestOptions, newToken);
          return handler.resolve(newRequest);
        }
      } catch (e) {
        return handler.next(err);
      }
    }
    return handler.next(err);
  }

  Future<Response<dynamic>> _retryRequest(
      RequestOptions requestOptions,
      String newToken,
      ) {
    final headers = {...requestOptions.headers}..remove('cookie');
    final options = Options(
      method: requestOptions.method,
      headers: {...headers, 'Authorization': 'Bearer $newToken'},
      extra: {...requestOptions.extra, 'retried': true},
    );
    return dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  Future<String?> _refreshToken() async {
    if (kDebugMode) log('🟡 _refreshToken called, url: $refreshTokenUrl');
    if (refreshTokenUrl == null || refreshTokenUrl!.isEmpty) {
      if (kDebugMode) log('❌ refreshTokenUrl missing');
      return null;
    }
    try {
      final response = await dio.post(refreshTokenUrl!);
      if (kDebugMode) {
        log('🔄 refresh response: ${response.statusCode} ${response.data}');
      }
      if (kDebugMode) {
        log('🍪 new set-cookie: ${response.headers['set-cookie']}');
      }

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final json = response.data as Map<String, dynamic>;
        final newToken = onTokenRefresh?.call(json);
        if (kDebugMode) log('✅ new token: $newToken');
        return newToken;
      }
    } catch (e) {
      if (e is DioException) {
        if (kDebugMode) {
          log(
            '💥 refresh failed: ${e.response?.statusCode} → ${e.response?.data}',
          );
        }
      } else {
        if (kDebugMode) log('💥 refresh threw: $e');
      }
      return null;
    }
    return null;
  }

// bool _shouldAttemptRefresh(DioException err) {
//   return err.response?.statusCode == 401;
// }
}
