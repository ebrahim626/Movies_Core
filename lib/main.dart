import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:movies_core/src/core/config/constant/assets_path.dart';
import 'package:movies_core/src/core/config/size/size.dart';
import 'package:movies_core/src/core/extensions/context.dart';
import 'package:movies_core/src/core/extensions/gap.dart';
import 'package:movies_core/src/core/router/go_router.dart';
import 'package:movies_core/src/core/utils/theme/app_theme.dart';
import 'package:movies_core/src/core/utils/theme/app_tokens.dart';
import 'package:movies_core/src/feature/home/view/home_screen.dart';
import 'package:movies_core/src/feature/welcome/landing/view/landing_screen.dart';
import 'package:movies_core/src/feature/welcome/splash/view/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  // await CacheService.ensureInitialized();

  runApp(ProviderScope(child: const MyApp()));
}

void configEasyLoading(BuildContext context, {bool isDark = false}) {
  EasyLoading.instance
    ..loadingStyle = EasyLoadingStyle.custom
    ..backgroundColor = Colors.transparent
    ..boxShadow = const <BoxShadow>[]
    ..indicatorColor = Colors.teal
    ..progressColor = Colors.teal
    ..textColor = Colors.white
    ..textStyle = const TextStyle(
      fontSize: 16.0,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    )
    ..dismissOnTap = false
    ..userInteractions = false
    ..maskType = EasyLoadingMaskType.custom
    ..maskColor = Colors.black.withValues(alpha: 0.8)
    ..indicatorWidget = SizedBox(
      height: 100.h,
      width: 100.w,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              AssetsPath.appLogo,
              height: 50,
              width: 50,
              fit: BoxFit.contain,
            ),
          ),
          8.ph,
          SpinKitThreeBounce(color: AppColors.primary700, size: 30.0),
        ],
      ),
    )
    ..indicatorType = EasyLoadingIndicatorType.spinningCircle;
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ScreenUtilInit(
      designSize: const Size(375, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      builder: (context, child) => MaterialApp.router(
        title: "Movies Core",
        scaffoldMessengerKey: rootScaffoldMessengerKey,
        routerConfig: ref.watch(goRouterProvider),
        theme: lightTheme,
        darkTheme: darkTheme,
        builder: EasyLoading.init(
          builder: (context, child) {
            configEasyLoading(context, isDark: isDark);
            topBarSize = context.padding.top;
            bottomViewPadding = context.padding.bottom;
            return MediaQuery(
              data: context.mq.copyWith(
                devicePixelRatio: 1.0,
                textScaler: const TextScaler.linear(1.0),
              ),
              child: child!,
            );
          },
        ),
      ),
    );
  }
}
