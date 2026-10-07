import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/constant/assets_path.dart';
import '../../../../core/utils/theme/app_tokens.dart';
import '../controller/splash_controller.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  static const String name = "splash-screen";

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _upperRotation;
  late final Animation<double> _upperOpacity;
  late final Animation<double> _lowerScale;
  late final Animation<double> _lowerOpacity;
  late final Animation<double> _textSlide;
  late final Animation<double> _textOpacity;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // -----------------------------------------
    // UPPER PART
    // -----------------------------------------
    //
    // Starts slightly closed and opens upward
    // from the bottom-left hinge.
    //
    _upperRotation = Tween<double>(
      begin: 0.45,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.0,
          0.45,
          curve: Curves.easeOutBack,
        ),
      ),
    );

    _upperOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.0,
          0.20,
          curve: Curves.easeOut,
        ),
      ),
    );

    // -----------------------------------------
    // LOWER PART
    // -----------------------------------------

    _lowerScale = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.15,
          0.55,
          curve: Curves.easeOutBack,
        ),
      ),
    );

    _lowerOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.15,
          0.35,
          curve: Curves.easeOut,
        ),
      ),
    );

    // -----------------------------------------
    // TEXT
    // -----------------------------------------
    //
    // Text starts inside the logo and moves down
    // out of the box.
    //
    _textSlide = Tween<double>(
      begin: -25,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.50,
          0.90,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    _textOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.55,
          0.80,
          curve: Curves.easeOut,
        ),
      ),
    );

    // Delay before starting the animation
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    // Side effect only — navigates once splashNextRouteProvider resolves.
    // No animation/timing logic lives in the widget; it just reacts.
    ref.listen(splashNextRouteProvider, (previous, next) {
      next.whenData((route) {
        if (mounted) context.go(route);
      });
    });

    return Scaffold(
      backgroundColor: AppColors.primary50,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      // --------------------------------
                      // LOWER PART
                      // --------------------------------

                      Opacity(
                        opacity: _lowerOpacity.value,
                        child: Transform.scale(
                          scale: _lowerScale.value,
                          child: Image.asset(
                            AssetsPath.appLogo,
                            width: 120,
                            height: 120,
                          ),
                        ),
                      ),

                      // --------------------------------
                      // UPPER PART
                      // --------------------------------

                      Positioned(
                        top: -62,
                        left: -5,
                        right: 0,
                        child: Opacity(
                          opacity: _upperOpacity.value,
                          child: Transform.rotate(
                            angle: _upperRotation.value,
                            alignment: Alignment.bottomLeft,
                            child: Image.asset(
                              AssetsPath.appLogoUpper,
                              width: 120,
                              height: 120,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // const SizedBox(height: 10),

                // --------------------------------
                // TEXT COMES OUT FROM THE BOX
                // --------------------------------

                ClipRect(
                  child: Opacity(
                    opacity: _textOpacity.value,
                    child: Transform.translate(
                      offset: Offset(0, _textSlide.value),
                      child: const Text(
                        'Movies Core',
                        style: TextStyle(
                          color: AppColors.primary800,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}