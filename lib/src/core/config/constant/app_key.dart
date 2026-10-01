// core/constant/app_key.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppKey {
  static String get apiKey => dotenv.env['API_KEY'] ?? '';
  static String get readAccessToken => dotenv.env['API_READ_ACCESS_TOKEN'] ?? '';
}