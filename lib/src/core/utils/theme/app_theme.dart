import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../extensions/responsive.dart';
import 'app_tokens.dart';

/// System status/nav bar styling per brightness. Swap this along with
/// the ThemeMode when the user toggles dark mode.
const lightUiConfig = SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  statusBarBrightness: Brightness.light,
  statusBarIconBrightness: Brightness.dark,
  systemNavigationBarColor: AppColors.white,
  systemNavigationBarIconBrightness: Brightness.dark,
);

const darkUiConfig = SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  statusBarBrightness: Brightness.dark,
  statusBarIconBrightness: Brightness.light,
  systemNavigationBarColor: AppColors.darkBackground,
  systemNavigationBarIconBrightness: Brightness.light,
);

/// For screens whose background follows the app's ThemeMode (most screens):
/// wrap the Scaffold in `AnnotatedRegion(value: AppStatusBar.of(context), ...)`
/// and it flips between lightUiConfig/darkUiConfig automatically.
///
/// Screens with a fixed-color background regardless of theme — like
/// CourseProgressHeader's navy hero — should NOT use this. Pass
/// lightUiConfig/darkUiConfig directly instead, since the status bar
/// icon color there depends on the header's fixed color, not on
/// whether the app is in light or dark mode.
class AppStatusBar {
  AppStatusBar._();

  static SystemUiOverlayStyle of(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? darkUiConfig : lightUiConfig;
  }
}

bool get isTablet => ScreenUtil().screenWidth >= 600;

const _pageTransitionTheme = PageTransitionsTheme(
  builders: {
    TargetPlatform.android: ZoomPageTransitionsBuilder(),
    TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
  },
);

TextTheme _textTheme({required Color titleColor, required Color bodyColor}) {
  return TextTheme(
    titleSmall: TextStyle(fontWeight: FontWeight.w700, color: titleColor, fontSize: 14.0.rsp),
    titleMedium: TextStyle(fontWeight: FontWeight.w700, color: titleColor, fontSize: 16.0.rsp),
    titleLarge: TextStyle(fontWeight: FontWeight.w700, fontSize: 20.0.rsp, color: titleColor),
    labelSmall: TextStyle(color: bodyColor, fontWeight: FontWeight.w600, fontSize: 12.rsp),
    labelMedium: TextStyle(color: bodyColor, fontWeight: FontWeight.w600, fontSize: 16.rsp),
    labelLarge: TextStyle(color: bodyColor, fontWeight: FontWeight.w700),
    bodySmall: TextStyle(color: bodyColor, fontWeight: FontWeight.w500, fontSize: 12.rsp),
    bodyMedium: TextStyle(color: bodyColor, fontSize: 16.rsp, fontWeight: FontWeight.w500),
    bodyLarge: TextStyle(color: bodyColor, fontSize: 18.rsp, fontWeight: FontWeight.w500),
    headlineLarge: TextStyle(fontWeight: FontWeight.w900, color: titleColor),
    headlineMedium: TextStyle(fontWeight: FontWeight.w900, color: titleColor),
    headlineSmall: TextStyle(fontWeight: FontWeight.w700, fontSize: 28.rsp, color: titleColor),
  ).apply(fontFamily: "Montserrat");
}

/// Builds a full ThemeData from a small set of semantic inputs, so light
/// and dark stay structurally identical and only the tokens differ.
ThemeData _buildTheme({
  required Brightness brightness,
  required Color scaffoldBackground,
  required Color cardBackground,
  required Color titleColor,
  required Color bodyColor,
  required Color borderColor,
  required Color shadowColor,
  required Color inputFill,
  required Color unselectedColor,
}) {
  final textTheme = _textTheme(titleColor: titleColor, bodyColor: bodyColor);

  // primary700 (dark navy) has poor contrast against dark backgrounds —
  // same issue already fixed in SetupTabSelector's active tab color.
  // Anywhere primary700 is used as an "active/selected" indicator color
  // against a background that itself goes dark needs this same swap.
  final activeAccentColor = brightness == Brightness.dark ? AppColors.primary400 : AppColors.primary700;

  OutlineInputBorder border(Color color, [double width = 1.0]) => OutlineInputBorder(
    borderRadius: AppRadius.input,
    gapPadding: 10,
    borderSide: BorderSide(color: color, width: width),
  );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    primaryColor: AppColors.primary700,
    primaryColorDark: AppColors.primary900,
    scaffoldBackgroundColor: scaffoldBackground,
    cardColor: cardBackground,
    shadowColor: shadowColor,
    dividerColor: brightness == Brightness.light ? AppColors.neutral200 : AppColors.darkBorder,
    unselectedWidgetColor: unselectedColor,
    secondaryHeaderColor: AppColors.primary700,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    pageTransitionsTheme: _pageTransitionTheme,
    textTheme: textTheme,

    colorScheme: ColorScheme(
      brightness: brightness,
      primary: AppColors.primary700,
      onPrimary: AppColors.white,
      secondary: AppColors.slate600,
      onSecondary: AppColors.white,
      error: AppColors.error600,
      onError: AppColors.white,
      surface: cardBackground,
      onSurface: titleColor,
    ),

    cardTheme: CardThemeData(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.card),
      shadowColor: shadowColor,
      color: cardBackground,
      elevation: 0,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: scaffoldBackground,
      elevation: 0,
      titleTextStyle: textTheme.titleLarge,
      surfaceTintColor: cardBackground,
      shadowColor: cardBackground,
    ),

    tabBarTheme: TabBarThemeData(
      labelColor: AppColors.primary700,
      unselectedLabelColor: unselectedColor,
      indicatorSize: TabBarIndicatorSize.label,
      indicator: BoxDecoration(borderRadius: AppRadius.chip),
    ),

    dialogTheme: DialogThemeData(shape: RoundedRectangleBorder(borderRadius: AppRadius.dialog)),

    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all(AppColors.primary700),
      trackColor: WidgetStateProperty.all(AppColors.primary700.withValues(alpha: 0.5)),
    ),

    tooltipTheme: TooltipThemeData(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.r12),
        color: AppColors.primary700.withValues(alpha: 0.8),
      ),
      textStyle: textTheme.titleSmall!.copyWith(color: AppColors.white),
    ),

    listTileTheme: ListTileThemeData(shape: RoundedRectangleBorder(borderRadius: AppRadius.chip)),

    snackBarTheme: SnackBarThemeData(
      actionTextColor: textTheme.labelSmall!.color,
      contentTextStyle: textTheme.labelSmall,
      backgroundColor: Colors.transparent,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.chip),
      elevation: 0.0,
    ),

    dividerTheme: DividerThemeData(color: unselectedColor.withValues(alpha: 0.4), thickness: 0.4),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      unselectedItemColor: unselectedColor,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: activeAccentColor,
      showUnselectedLabels: true,
      elevation: 30,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.w700, color: activeAccentColor, fontSize: 10),
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600, color: unselectedColor, fontSize: 10),
      backgroundColor: cardBackground,
    ),

    // Was AppColors.warning500 (amber) — switched to activeAccentColor so
    // selection/cursor matches the brand navy used everywhere else,
    // with the same dark-mode contrast fix as the bottom nav.
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: activeAccentColor,
      selectionColor: activeAccentColor.withValues(alpha: 0.3),
      selectionHandleColor: activeAccentColor,
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: BorderSide.none,
        foregroundColor: AppColors.warning500,
        textStyle: textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w700),
        backgroundColor: inputFill,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.button),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 48),
        backgroundColor: AppColors.primary700,
        foregroundColor: AppColors.white,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.button),
      ),
    ),

    progressIndicatorTheme: ProgressIndicatorThemeData(
      refreshBackgroundColor: AppColors.primary700,
      circularTrackColor: AppColors.primary700.withValues(alpha: 0.2),
      linearTrackColor: AppColors.primary700.withValues(alpha: 0.2),
      color: AppColors.primary700,
    ),

    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(16),
      hintStyle: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400),
      enabledBorder: border(borderColor),
      border: border(borderColor),
      disabledBorder: border(borderColor),
      focusedBorder: border(titleColor),
      errorBorder: border(AppColors.error600),
      focusedErrorBorder: border(AppColors.error600),
      floatingLabelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.primary700),
      fillColor: inputFill,
      suffixIconColor: bodyColor,
      prefixIconColor: bodyColor,
      errorMaxLines: 3,
      floatingLabelBehavior: FloatingLabelBehavior.never,
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary700,
      foregroundColor: AppColors.white,
      elevation: 0,
    ),

    chipTheme: ChipThemeData(
      backgroundColor: cardBackground,
      labelStyle: textTheme.bodyMedium!.copyWith(color: AppColors.primary700, fontWeight: FontWeight.w600),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.chip),
      side: BorderSide.none,
      labelPadding: const EdgeInsets.symmetric(horizontal: 5),
      elevation: 5.0,
      shadowColor: AppColors.primary700.withValues(alpha: 0.5),
    ),

    datePickerTheme: DatePickerThemeData(
      backgroundColor: scaffoldBackground,
      surfaceTintColor: cardBackground,
      elevation: 0,
      headerBackgroundColor: AppColors.primary700,
      headerForegroundColor: AppColors.white,
      todayBackgroundColor: WidgetStateProperty.all(AppColors.primary700.withValues(alpha: 0.2)),
      todayForegroundColor: WidgetStateProperty.all(AppColors.primary700),
      dayBackgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) return AppColors.primary700;
        return Colors.transparent;
      }),
      dayForegroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.disabled)) return bodyColor.withValues(alpha: 0.5);
        if (states.contains(WidgetState.selected)) return AppColors.white;
        return bodyColor;
      }),
      dayOverlayColor: WidgetStateProperty.all(AppColors.primary700.withValues(alpha: 0.1)),
      rangePickerBackgroundColor: unselectedColor,
      dayStyle: TextStyle(color: bodyColor, fontWeight: FontWeight.w500),
      weekdayStyle: TextStyle(color: bodyColor, fontWeight: FontWeight.w600),
      yearStyle: TextStyle(color: bodyColor, fontWeight: FontWeight.w500),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.r12)),
      cancelButtonStyle: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.pressed)) return AppColors.primary700.withValues(alpha: 0.8);
          return AppColors.primary700;
        }),
        textStyle: WidgetStateProperty.all(const TextStyle(fontWeight: FontWeight.w600)),
      ),
      confirmButtonStyle: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.pressed)) return AppColors.primary700.withValues(alpha: 0.8);
          return AppColors.primary700;
        }),
        foregroundColor: WidgetStateProperty.all(AppColors.white),
        textStyle: WidgetStateProperty.all(const TextStyle(fontWeight: FontWeight.w600)),
        padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 16)),
        shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.r8))),
      ),
    ),

    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) return AppColors.primary700;
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(AppColors.white),
      side: BorderSide(color: unselectedColor.withValues(alpha: 0.5), width: 1.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.r8 / 2)),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      splashRadius: 0,
      overlayColor: WidgetStateProperty.all(AppColors.primary700.withValues(alpha: 0.1)),
    ),

    bottomSheetTheme: BottomSheetThemeData(backgroundColor: cardBackground, surfaceTintColor: cardBackground),
    popupMenuTheme: PopupMenuThemeData(color: cardBackground),

    cupertinoOverrideTheme: CupertinoThemeData(
      primaryColor: AppColors.primary700,
      barBackgroundColor: scaffoldBackground,
      textTheme: CupertinoTextThemeData(
        dateTimePickerTextStyle: TextStyle(color: bodyColor, fontSize: 16.rsp),
        actionTextStyle: const TextStyle(color: AppColors.primary700, fontWeight: FontWeight.w600),
      ),
    ),
  );
}

final lightTheme = _buildTheme(
  brightness: Brightness.light,
  scaffoldBackground: const Color(0xFFF6FAFA),
  cardBackground: AppColors.white,
  titleColor: const Color(0xFF111827),
  bodyColor: const Color(0xFF6B7280),
  borderColor: const Color(0xFFE5E5E5),
  shadowColor: const Color(0xFF6B7280).withValues(alpha: 0.3),
  inputFill: const Color(0xFFE2EEFF).withValues(alpha: 0.5),
  unselectedColor: const Color(0xFF6F6C6A),
);

final darkTheme = _buildTheme(
  brightness: Brightness.dark,
  scaffoldBackground: AppColors.darkBackground,
  cardBackground: AppColors.darkSurface,
  titleColor: AppColors.darkTitleText,
  bodyColor: AppColors.darkBodyText,
  borderColor: AppColors.darkBorder,
  shadowColor: AppColors.black.withValues(alpha: 0.5),
  inputFill: AppColors.darkSurfaceAlt,
  unselectedColor: const Color(0xFF7B8394),
);