import 'package:flutter/material.dart';

import 'app_tokens.dart';

/// ThemeData only lets you register ONE look per button widget type
/// (one ElevatedButtonTheme, one OutlinedButtonTheme, etc). To support
/// the full variant set from the design system — Primary, Secondary,
/// Outline, Ghost, Text, Destructive, Success, Warning, Link — each
/// variant is a `ButtonStyle` you pass directly to the button widget:
///
///   ElevatedButton(style: AppButtonStyles.primary(context), ...)
///   ElevatedButton(style: AppButtonStyles.destructive(context), ...)
///
/// Disabled and pressed/hover states are handled via WidgetStateProperty
/// so they work automatically — no separate "state" widgets needed.
class AppButtonStyles {
  AppButtonStyles._();

  static const _minSize = Size(double.infinity, 48);
  static final _shape = RoundedRectangleBorder(borderRadius: AppRadius.button);

  static ButtonStyle _filled({required Color base, required Color hover, required Color onColor}) {
    return ButtonStyle(
      minimumSize: WidgetStateProperty.all(_minSize),
      shape: WidgetStateProperty.all(_shape),
      elevation: WidgetStateProperty.all(0),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) return onColor.withValues(alpha: 0.6);
        return onColor;
      }),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) return base.withValues(alpha: 0.4);
        if (states.contains(WidgetState.pressed) || states.contains(WidgetState.hovered)) return hover;
        return base;
      }),
    );
  }

  static ButtonStyle primary(BuildContext context) =>
      _filled(base: AppColors.primary700, hover: AppColors.primary800, onColor: AppColors.white);

  static ButtonStyle secondary(BuildContext context) =>
      _filled(base: AppColors.slate600, hover: AppColors.slate700, onColor: AppColors.white);

  static ButtonStyle destructive(BuildContext context) =>
      _filled(base: AppColors.error600, hover: AppColors.error700, onColor: AppColors.white);

  static ButtonStyle success(BuildContext context) =>
      _filled(base: AppColors.success600, hover: AppColors.success700, onColor: AppColors.white);

  static ButtonStyle warning(BuildContext context) =>
      _filled(base: AppColors.warning600, hover: AppColors.warning700, onColor: AppColors.white);

  static ButtonStyle outline(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.neutral200;
    // Same primary700-on-dark contrast issue fixed in the bottom nav and
    // tab selector — primary700 is a dark navy, invisible against a
    // near-black background.
    final accentColor = isDark ? AppColors.primary400 : AppColors.primary700;
    return ButtonStyle(
      minimumSize: WidgetStateProperty.all(_minSize),
      shape: WidgetStateProperty.all(_shape),
      elevation: WidgetStateProperty.all(0),
      side: WidgetStateProperty.all(BorderSide(color: borderColor, width: 1)),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed) || states.contains(WidgetState.hovered)) {
          return accentColor.withValues(alpha: 0.06);
        }
        return Colors.transparent;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) return theme.disabledColor;
        return accentColor;
      }),
    );
  }

  static ButtonStyle ghost(BuildContext context) => ButtonStyle(
    minimumSize: WidgetStateProperty.all(_minSize),
    shape: WidgetStateProperty.all(_shape),
    elevation: WidgetStateProperty.all(0),
    backgroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.pressed) || states.contains(WidgetState.hovered)) {
        return AppColors.slate500.withValues(alpha: 0.08);
      }
      return Colors.transparent;
    }),
    foregroundColor: WidgetStateProperty.all(AppColors.slate600),
  );

  static ButtonStyle text(BuildContext context) => TextButton.styleFrom(
    foregroundColor: AppColors.slate600,
    padding: EdgeInsets.zero,
    textStyle: const TextStyle(fontWeight: FontWeight.w600),
  );

  static ButtonStyle link(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return TextButton.styleFrom(
      foregroundColor: isDark ? AppColors.primary400 : AppColors.primary700,
      padding: EdgeInsets.zero,
      textStyle: TextStyle(fontWeight: FontWeight.w700, decoration: TextDecoration.underline,
        color: isDark ? AppColors.primary400 : AppColors.primary700
      ),
    );
  }

  /// Icon-only circular button (see "Icon Only · Circle" in the screenshot).
  static ButtonStyle iconCircle(BuildContext context) => IconButton.styleFrom(
    backgroundColor: AppColors.primary700,
    foregroundColor: AppColors.white,
    shape: const CircleBorder(),
    fixedSize: const Size(48, 48),
  );
}

/// For the "Loading…" state in the screenshot: keep the button's normal
/// style, set `onPressed: null` to disable it, and swap the label for a
/// small spinner — e.g.:
///
///   ElevatedButton(
///     style: AppButtonStyles.primary(context),
///     onPressed: isLoading ? null : onSubmit,
///     child: isLoading
///         ? const SizedBox(height: 18, width: 18,
///             child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
///         : const Text('Button'),
///   )