import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_core/src/core/config/constant/app_key.dart';
import 'package:movies_core/src/core/router/app_routes.dart';
import '../../../../core/database/hive_service.dart';

final loginProvider = NotifierProvider.autoDispose<LoginProvider, void>(LoginProvider.new);

class LoginProvider extends Notifier<void> {

  @override
  void build() async {

  }

  void logIn (BuildContext context) async {
    final String apiKey = AppKey.readAccessToken;
    final cacheService = ref.read(cacheServiceProvider);
    await cacheService.setBearerToken(apiKey);
    await cacheService.setLoggedIn(true);
    log("Bearer Token set");

    if (!context.mounted) {
      return;
    }
    context.push(AppRoutes.homeRoute);
  }

}