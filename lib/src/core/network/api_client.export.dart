import 'dart:async';
import 'dart:developer';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../database/hive_service.dart';
import '../service/connectivity_service.dart';

part 'dio/api_client.dart';
part 'dio/api_endpoints.dart';
part 'dio/api_options.dart';
part 'dio/interceptor.dart';
