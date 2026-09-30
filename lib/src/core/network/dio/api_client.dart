part of '../api_client.export.dart';

enum APIType { public, private }

class ApiResponse<T> {
  ApiResponse.success(this.data, {this.statusCode, this.headers})
      : error = null;
  ApiResponse.failure(this.error, {this.statusCode, this.headers, this.data});
  final T? data;
  final int? statusCode;
  final Headers? headers;
  final DioException? error;

  bool get isSuccess => error == null;
}

final apiClientProvider = Provider<ApiClient>((ref) {
  final cacheService = ref.watch(cacheServiceProvider);
  return ApiClient()..init(
    baseUrl: ApiEndpoints.baseUrl,
    cacheService: cacheService,
    // refreshTokenUrl:
    // '${ApiEndpoints.baseUrl}${ApiEndpoints.refreshToken}', // 👈 single, fixed URL
    // onTokenRefresh: (json) => json['token'] as String,
    isConnected: () => ref.read(connectivityProvider),
  );
});

class ApiClient {
  ApiClient();

  late Dio _dio;
  late String baseUrl;
  late CacheService _cacheService;
  late CookieJar _cookieJar;
  bool Function()? _isConnected;

  Dio get dio => _dio;

  final Completer<void> _readyCompleter = Completer<void>();
  Future<void> get _ready => _readyCompleter.future;

  Future<void> init({
    required String baseUrl,
    required CacheService cacheService,
    int connectionTimeout = 15000, //15 seconds
    int receiveTimeout = 15000, // 15 seconds
    String? refreshTokenUrl,
    String Function(Map<String, dynamic>)? onTokenRefresh,
    bool Function()? isConnected,
    List<Interceptor>? extraInterceptors,
  }) async {
    this.baseUrl = baseUrl;
    _cacheService = cacheService;
    _isConnected = isConnected;

    final appDocDir = await getApplicationDocumentsDirectory();
    _cookieJar = PersistCookieJar(
      storage: FileStorage('${appDocDir.path}/.cookies/'),
    );

    final options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: Duration(milliseconds: connectionTimeout),
      receiveTimeout: Duration(milliseconds: receiveTimeout),
      validateStatus: (status) =>
      status != null && status >= 200 && status < 300,
    );

    _dio = Dio(options);
    _dio.interceptors.addAll([
      CookieManager(_cookieJar),
      if (kDebugMode) PrettyDioLogger(requestHeader: true, requestBody: true),
      DynamicInterceptor(
        baseUrl: baseUrl,
        cacheService: cacheService,
        refreshTokenUrl: refreshTokenUrl,
        dio: _dio,
        onTokenRefresh: onTokenRefresh,
      ),
      ...?extraInterceptors,
    ]);

    _readyCompleter.complete();
  }

  // Add this helper — used at the top of every HTTP method
  ApiResponse<T>? _checkConnectivity<T>() {
    if (_isConnected != null && !_isConnected!()) {
      return ApiResponse.failure(
        DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.connectionError,
          error: "No internet connection. Please check your network.",
        ),
      );
    }
    return null;
  }

  /// GET
  Future<ApiResponse<dynamic>> get({
    required APIType apiType,
    required String path,
    TokenType? tokenType,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
  }) async {
    await _ready;
    final connectivityFailure = _checkConnectivity();
    if (connectivityFailure != null) return connectivityFailure;
    try {
      final options = await _getOptions(
        apiType: apiType,
        extraHeaders: {
          ...?headers,
        },
        tokenType: tokenType,
      );
      final response = await _dio.get(
        path,
        queryParameters: query,
        options: options,
        cancelToken: cancelToken,
      );
      return ApiResponse.success(
        response.data,
        statusCode: response.statusCode,
        headers: response.headers,
      );
    } on DioException catch (e) {
      return _handleDioException(e);
    }
  }

  /// POST
  Future<ApiResponse<dynamic>> post({
    required APIType apiType,
    required String path,
    TokenType? tokenType,
    dynamic data,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
  }) async {
    await _ready;
    final connectivityFailure = _checkConnectivity();
    if (connectivityFailure != null) return connectivityFailure;
    try {
      final options = await _getOptions(
        apiType: apiType,
        extraHeaders: {
          ...?headers,
        },
        tokenType: tokenType,
      );
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: query,
        options: options,
        cancelToken: cancelToken,
      );
      return ApiResponse.success(
        response.data,
        statusCode: response.statusCode,
        headers: response.headers,
      );
    } on DioException catch (e) {
      return _handleDioException(e);
    }
  }

  /// PUT
  Future<ApiResponse<dynamic>> put({
    required APIType apiType,
    required String path,
    TokenType? tokenType,
    dynamic data,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
  }) async {
    await _ready;
    final connectivityFailure = _checkConnectivity();
    if (connectivityFailure != null) return connectivityFailure;
    try {
      final options = await _getOptions(
        apiType: apiType,
        extraHeaders: {
          ...?headers,
        },
        tokenType: tokenType,
      );
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: query,
        options: options,
        cancelToken: cancelToken,
      );
      return ApiResponse.success(
        response.data,
        statusCode: response.statusCode,
        headers: response.headers,
      );
    } on DioException catch (e) {
      return _handleDioException(e);
    }
  }

  Future<Options> _getOptions({
    required APIType apiType,
    TokenType? tokenType,
    Map<String, dynamic>? extraHeaders,
  }) async {
    await _ready;
    final baseOptions = switch (apiType) {
      APIType.public => PublicApiOptions().options,
      APIType.private => await ProtectedApiOptions(
        cacheService: _cacheService,
        tokenType: tokenType,
      ).options,
    };
    if (extraHeaders != null) {
      baseOptions.headers?.addAll(extraHeaders);
    }

    return baseOptions;
  }

  ApiResponse<T> _handleDioException<T>(DioException e) {
    final responseData = e.response?.data;
    final backendMessage =
    (responseData is Map && responseData['message'] != null)
        ? responseData['message']
        : 'Something went wrong';

    return ApiResponse.failure(
      DioException(
        requestOptions: e.requestOptions,
        response: e.response,
        type: e.type,
        error: backendMessage,
      ),
      statusCode: e.response?.statusCode,
      data: responseData as T?,
    );
  }
}