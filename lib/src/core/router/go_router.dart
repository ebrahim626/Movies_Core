import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_core/src/core/utils/reusable_transition/slide_down_reveal_page.dart';
import 'package:movies_core/src/feature/home/view/home_screen.dart';
import '../../feature/welcome/landing/view/landing_screen.dart';
import '../../feature/welcome/splash/view/splash_screen.dart';
import '../utils/reusable_transition/cinematic_reveal_page.dart';
import 'app_routes.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
GlobalKey<ScaffoldMessengerState>();


final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splashRoute,
    navigatorKey: rootNavigatorKey,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: AppRoutes.splashRoute,
        name: SplashScreen.name,
        builder: (context, state) => SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.landingRoute,
        name: LandingScreen.name,
        pageBuilder: (context, state) => cinematicRevealPage(
          state: state,
          child: const LandingScreen(),
        ),
      ),

      // router when need 2 types of transition --
      // GoRoute(
      //   path: '/home',
      //   pageBuilder: (context, state) {
      //     final child = const HomeScreen();
      //     return state.extra == 'fromSplash'
      //         ? fadeScaleTransitionPage(state: state, child: child)
      //         : MaterialPage(key: state.pageKey, child: child);
      //   },
      // ),

      GoRoute(
        path: AppRoutes.homeRoute,
        name: HomeScreen.name,
        pageBuilder: (context, state) => slideDownRevealPage(
          state: state,
          child: const HomeScreen(),
        ),
      ),

      // StatefulShellRoute.indexedStack(
      //   builder: (context, state, navigationShell) =>
      //       MainShell(navigationShell: navigationShell),
      //   branches: [
      //     StatefulShellBranch(
      //       routes: [
      //         GoRoute(
      //           path: AppRoutes.studentCourseProgressRoute,
      //           name: StudentCourseProgressScreen.name,
      //           builder: (context, state) => StudentCourseProgressScreen(),
      //         ),
      //       ],
      //     ),
      //     StatefulShellBranch(
      //       routes: [
      //         GoRoute(
      //           path: AppRoutes.profileRoute,
      //           name: ProfileScreen.name,
      //           builder: (context, state) => ProfileScreen(),
      //         ),
      //       ],
      //     ),
      //   ],
      // ),

    ],
  );
});
