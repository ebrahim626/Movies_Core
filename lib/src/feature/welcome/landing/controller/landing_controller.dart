// import 'dart:developer';
//
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
// import 'package:movies_core/src/core/config/constant/app_key.dart';
// import '../../../../core/database/hive_service.dart';
// import '../../../../core/network/api_client.export.dart';
// import '../repository/login_repository.dart';
//
// final loginProvider =
// NotifierProvider.autoDispose<LoginController, AsyncValue<void>>(
//   LoginController.new,
// );
//
// class LoginController extends Notifier<AsyncValue<void>> {
//   static const _scheme = 'moviescore';
//
//   @override
//   AsyncValue<void> build() => const AsyncData(null);
//
//   /// Full TMDB login. Returns true on success.
//   Future<bool> logIn() async {
//     state = const AsyncLoading();
//     state = await AsyncValue.guard(_logIn);
//
//     if (state.hasError) {
//       log('Login failed: ${state.error}', stackTrace: state.stackTrace);
//     }
//
//     final err = state.error;
//     if (err is PlatformException && err.code == 'CANCELED') {
//       state = const AsyncData(null);
//       return false;
//     }
//     return !state.hasError;
//   }
//
//   Future<void> _logIn() async {
//     final cache = ref.read(cacheServiceProvider);
//     final repo = ref.read(loginRepositoryProvider);
//
//     // App-level token, needed to call the private auth endpoints.
//     await cache.setBearerToken(AppKey.readAccessToken);
//
//     // 1. Request token
//     final tokenData = _unwrap(await repo.createRequestToken());
//     final requestToken = tokenData['request_token'] as String;
//
//
//     // 2. User approves (or signs up) on TMDB
//     final callback = await FlutterWebAuth2.authenticate(
//       url: 'https://www.themoviedb.org/authenticate/$requestToken'
//           '?redirect_to=$_scheme://auth',
//       callbackUrlScheme: _scheme,
//     );
//     final approved = Uri.parse(callback).queryParameters['approved'] == 'true';
//     if (!approved) throw Exception('Login was not approved');
//
//     // 3. Session id
//     final sessionData = _unwrap(await repo.createSession(requestToken: requestToken));
//     await cache.setSessionId(sessionData['session_id'] as String);
//     await cache.setLoggedIn(true);
//   }
//
//   /// Visitor: bearer token only, no session.
//   Future<void> continueAsVisitor() async {
//     final cache = ref.read(cacheServiceProvider);
//     await cache.setBearerToken(AppKey.readAccessToken);
//     await cache.setLoggedIn(false);
//   }
//
//   Future<void> logOut() async {
//     final cache = ref.read(cacheServiceProvider);
//     final sessionId = await cache.sessionId ?? ""; // add to your cache service
//     await ref.read(loginRepositoryProvider).deleteSession(sessionId: sessionId);
//     await cache.clearAuthTokens(); // add to your cache service
//     await cache.setLoggedIn(false);
//   }
//
//   Map<String, dynamic> _unwrap(ApiResponse<dynamic> res) {
//     if (!res.isSuccess) {
//       throw Exception('${res.error?.error ?? 'Something went wrong'}');
//     }
//     return Map<String, dynamic>.from(res.data as Map);
//   }
// }











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