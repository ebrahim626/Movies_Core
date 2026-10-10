import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../config/constant/app_constants.dart';

class CacheService {
  CacheService._();

  static final CacheService instance = CacheService._();

  static bool _initialized = false;
  static late Box<dynamic> _box;

  /// Ensures Hive box is open — safe to call multiple times
  static Future<void> ensureInitialized() async {
    if (_initialized) return;

    try {
      // Use application documents directory (safe default)
      final dir = await getApplicationDocumentsDirectory();
      Hive.init(dir.path);

      _box = await Hive.openBox<dynamic>(AppConstants.hiveKey);
      _initialized = true;
    } catch (e) {
      // Fallback to temp directory if something goes wrong
      _box = await Hive.openBox<dynamic>(
        AppConstants.hiveKey,
        path: (await getTemporaryDirectory()).path,
      );
      _initialized = true;
    }
  }

  Future<Box<dynamic>> get _safeBox async {
    await ensureInitialized();
    return _box;
  }

  // ====================== KEYS ======================
  static const _bearerToken = 'bearerToken';
  static const _sessionId = 'sessionId';
  static const _refreshToken = 'refreshToken';
  static const _authToken = 'authToken';
  static const _isLoggedIn = 'isLoggedIn';

  // ====================== HELPERS ======================
  Future<T?> _get<T>(String key, {T? defaultValue}) async {
    final box = await _safeBox;
    return box.get(key, defaultValue: defaultValue) as T?;
  }

  Future<void> _put(String key, dynamic value) async {
    final box = await _safeBox;
    await box.put(key, value);
  }

  Future<String?> get bearerToken async => await _get<String>(_bearerToken);
  Future<void> setBearerToken(String? value) async =>
      await _put(_bearerToken, value);

  Future<String?> get sessionId async => await _get<String>(_sessionId);
  Future<void> setSessionId(String? value) async =>
      await _put(_sessionId, value);

  Future<String?> get refreshToken async => await _get<String>(_refreshToken);
  Future<void> setRefreshToken(String? value) async =>
      await _put(_refreshToken, value);

  Future<String?> get authToken async => await _get<String>(_authToken);
  Future<void> setAuthToken(String? value) async =>
      await _put(_authToken, value);

  Future<bool> get isLoggedIn async => await read<bool>(_isLoggedIn) ?? false;
  Future<void> setLoggedIn(bool value) async => save(_isLoggedIn, value);

  // ====================== UTILS ======================
  Future<void> delete(String key) async {
    final box = await _safeBox;
    await box.delete(key);
  }

  Future<void> save(String key, dynamic value) async {
    final box = await _safeBox;
    await box.put(key, value);
  }

  Future<T?> read<T>(String key) async {
    final box = await _safeBox;
    final value = box.get(key);
    if (value is T) return value;
    return null;
  }

  Future<void> clearAll() async {
    final box = await _safeBox;
    await box.clear();
  }

  Future<void> clearAuthTokens() async {
    await Future.wait([
      delete(_bearerToken),
      delete(_sessionId),
      delete(_refreshToken),
      delete(_authToken),
      delete(_isLoggedIn),
    ]);
  }
}

// ====================== PROVIDERS ======================
final cacheServiceProvider = Provider<CacheService>((ref) {
  // This will never throw — safe lazy init
  return CacheService.instance;
});

final isLoggedInProvider = StateProvider<bool>((ref) {
  // Try to read from cache synchronously, default to false
  try {
    final box = Hive.box<dynamic>(AppConstants.hiveKey);
    return box.get('isLoggedIn', defaultValue: false);
  } catch (e) {
    return false;
  }
});
