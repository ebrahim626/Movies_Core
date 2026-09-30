import 'package:hive_ce/hive.dart';


class CacheService {
  CacheService._();

  static final CacheService instance = CacheService._();

  static bool _initialized = false;
  static late Box<dynamic> _box;
}