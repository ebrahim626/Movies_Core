import 'package:flutter/material.dart';

import '../../../../core/config/constant/assets_path.dart';
import '../../../../core/utils/theme/app_tokens.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  static const String name = "splash-screen";

  @override
  Widget build(BuildContext context,) {

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // Fixed light background, not theme-driven — the logo's ring and
        // letters are navy, so it needs a light backdrop regardless of
        // the app's own light/dark mode.
        color: Colors.white70,
        child: Center(
          // Single TweenAnimationBuilder drives the whole timeline as a
          // raw 0.0–1.0 progress value — no AnimationController, no
          // vsync, no State class. Interval/TweenSequence.transform(t)
          // reproduce the exact same staggered-curve math that
          // CurvedAnimation + AnimationController did before.
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 1400),
            curve: Curves.linear,
            builder: (context, t, child) {
              final logoT = const Interval(0.0, 0.7).transform(t);
              final logoScale = TweenSequence<double>([
                TweenSequenceItem(
                  tween: Tween(
                    begin: 0.6,
                    end: 1.08,
                  ).chain(CurveTween(curve: Curves.easeOutCubic)),
                  weight: 65,
                ),
                TweenSequenceItem(
                  tween: Tween(
                    begin: 1.08,
                    end: 1.0,
                  ).chain(CurveTween(curve: Curves.easeOut)),
                  weight: 35,
                ),
              ]).transform(logoT);
              final logoOpacity = const Interval(0.0, 0.4).transform(t);

              final textT = const Interval(0.45, 0.85).transform(t);
              final textOpacity = textT;
              final textSlideY = Tween<double>(
                begin: 0.25,
                end: 0.0,
              ).transform(textT);

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Opacity(
                    opacity: logoOpacity,
                    child: Transform.scale(
                      scale: logoScale,
                      child: Image.asset(
                        AssetsPath.appLogo,
                        width: 120,
                        height: 120,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Opacity(
                    opacity: textOpacity,
                    child: Transform.translate(
                      offset: Offset(0, textSlideY * 40),
                      child: const Text(
                        'Texas Online Drivers Ed',
                        style: TextStyle(
                          color: AppColors.primary900,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
