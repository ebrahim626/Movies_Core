

import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_core/src/core/config/constant/app_key.dart';
import '../../../../core/database/hive_service.dart';

final loginProvider = NotifierProvider.autoDispose<LoginProvider, void>(LoginProvider.new);

class LoginProvider extends Notifier<void> {

  @override
  void build() async {
    final String apiKey = AppKey.readAccessToken;
    final cacheService = ref.read(cacheServiceProvider);
    // await cacheService.setBearerToken(apiKey);
    // log("Bearer Token set");

  }

}