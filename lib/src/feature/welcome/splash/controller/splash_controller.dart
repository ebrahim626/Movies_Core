import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_core/src/core/database/hive_service.dart';
import 'package:movies_core/src/core/router/app_routes.dart';
import '../../../../core/config/constant/app_key.dart';

final splashNextRouteProvider = FutureProvider.autoDispose<String>((ref) async {
  await Future.delayed(const Duration(milliseconds: 2800));

  final cacheService = ref.read(cacheServiceProvider);
  final isLoggedIn = await cacheService.isLoggedIn;
  final String apiKey = AppKey.readAccessToken;
  // await cacheService.setBearerToken(apiKey);
  // await cacheService.setLoggedIn(true);
  // log("Bearer Token set");
  //
  // cacheService.clearAuthTokens();
  // cacheService.setLoggedIn(false);

  debugPrint("Splash: isLoggedIn = $isLoggedIn");

  if (!isLoggedIn) {
    return AppRoutes.landingRoute;
  }else {
    return AppRoutes.homeRoute;
  }

});