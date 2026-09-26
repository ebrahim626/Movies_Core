import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../feature/welcome/landing/view/landing_screen.dart';
import '../../feature/welcome/splash/view/splash_screen.dart';
import 'app_routes.dart';
import 'main_shell.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();



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
        builder: (context, state) => LandingScreen(),
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
