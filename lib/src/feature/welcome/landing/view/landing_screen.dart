import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../../core/config/constant/assets_path.dart';
import '../../../../core/extensions/gap.dart';
import '../../../../core/extensions/responsive.dart';
import '../../../../core/utils/theme/app_tokens.dart';
import '../../../common/widgets/button/app_button.dart';

/// Splash / onboarding entry screen.
/// Matches "Splash Screen 02" design — illustration, title, subtitle,
/// primary "Explore Courses" CTA, secondary "Login" outline button,
/// and a "Need Help? Support" footer link.
class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  static const String name = "landing-screen";

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // Was hardcoded Colors.white — now tracks light/dark scaffoldBackground.
      backgroundColor: Theme.of(context).cardColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.rw),
          child: Column(
            children: [
              SizedBox(height: 40.rh),

              // Illustration
              Expanded(
                child: Center(
                  child: Image.asset(
                    AssetsPath.loginArt,
                    //width: 280.rw,
                  ),
                  // child: SvgPicture.asset(
                  //   "assets/svgs/login_vector.svg",
                  //   width: 280.rw,
                  //   fit: BoxFit.contain,
                  // ),
                ),
              ),

              // Title — was raw TextStyle(color: Colors.black), dropping
              // the Montserrat font entirely. headlineSmall already
              // carries the right font + theme-aware title color.
              Text(
                'Texas Online Drivers Ed',
                textAlign: TextAlign.center,
                style: textTheme.headlineSmall?.copyWith(fontSize: 24.rsp),
              ),
              16.ph,
              // Subtitle — bodyMedium already resolves to your
              // theme-aware bodyColor token, not a fixed grey.
              Text(
                'Learn online at your own pace. Choose a course or '
                    'continue one you already purchased.',
                textAlign: TextAlign.center,
                style: textTheme.bodySmall,
              ),
              24.ph,

              // Primary CTA — reuses AppButton instead of a hand-rolled
              // ElevatedButton, so it stays in sync with every other
              // primary button in the app if that style ever changes.
              AppButton(
                variant: AppButtonVariant.primary,
                onPressed: () {},
                child: const Text('Explore Courses'),
              ),
              40.ph,

              // Secondary — Login
              AppButton(
                variant: AppButtonVariant.outline,
                onPressed: () async {

                },
                child: const Text('Login'),
              ),
              SizedBox(height: 20.rh),

              // Footer — Need Help? Support
              Padding(
                padding: EdgeInsets.only(bottom: 16.rh),
                child: RichText(
                  text: TextSpan(
                    style: textTheme.bodySmall?.copyWith(fontSize: 14.rsp),
                    children: [
                      const TextSpan(text: 'Need Help? '),
                      TextSpan(
                        text: 'Support',
                        // Brand color, fixed in both themes — same
                        // reasoning as the tab selector's active color
                        // and the back button's foreground color.
                        style: TextStyle(
                          color: isDark
                              ? AppColors.primary400
                              : AppColors.primary700,
                          fontWeight: FontWeight.w600,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {},
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
