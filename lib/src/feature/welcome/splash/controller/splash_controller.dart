import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_core/src/core/database/hive_service.dart';
import 'package:movies_core/src/core/router/app_routes.dart';

final splashNextRouteProvider = FutureProvider.autoDispose<String>((ref) async {
  await Future.delayed(const Duration(milliseconds: 2200));

  final cacheService = ref.read(cacheServiceProvider);
  final isLoggedIn = await cacheService.isLoggedIn;

  debugPrint("Splash: isLoggedIn = $isLoggedIn");

  if (!isLoggedIn) {
    return AppRoutes.landingRoute;
  }else {
    return AppRoutes.homeRoute;
  }

});