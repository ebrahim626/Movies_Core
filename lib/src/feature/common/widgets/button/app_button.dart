import 'package:flutter/material.dart';
import '../../../../core/utils/theme/app_button_styles.dart';
import '../../../../core/utils/theme/app_tokens.dart';

/// Maps 1:1 to the "Button Styles" row in the design system.
enum AppButtonVariant { primary, secondary, outline, ghost, text, destructive, success, warning, warningFilled, link }

/// Maps to "Icon Variants": how an icon-only button is shaped.
enum AppIconShape { square, rounded, circle }

/// Single button widget for the whole app. Variant + state in, styled
/// button out — call sites shouldn't be passing raw colors anymore.
///
/// Text button:
///   AppButton(variant: AppButtonVariant.primary, onPressed: _submit, child: Text('Save'))
///
/// With icon:
///   AppButton(variant: AppButtonVariant.primary, leadingIcon: Icons.add, onPressed: _add, child: Text('Button'))
///
/// Loading:
///   AppButton(variant: AppButtonVariant.primary, isLoading: _saving, onPressed: _submit, child: Text('Save'))
///
/// Custom corner radius (defaults to 99, i.e. pill-shaped):
///   AppButton(variant: AppButtonVariant.primary, radius: 12, onPressed: _submit, child: Text('Save'))
///
/// Icon-only (circle):
///   AppButton.icon(variant: AppButtonVariant.primary, icon: Icons.add, shape: AppIconShape.circle, onPressed: _add)
class AppButton extends StatelessWidget {
  final Widget? child;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final double? width;
  final double? height;
  final EdgeInsets? padding;

  /// Corner radius for the button shape. Defaults to 99 (pill-shaped).
  final double radius;

  /// Escape hatch for one-off overrides. Prefer a new [AppButtonVariant]
  /// over reaching for this on every call site.
  final ButtonStyle? styleOverride;

  const AppButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.leadingIcon,
    this.trailingIcon,
    this.width,
    this.height,
    this.padding,
    this.radius = 99,
    this.styleOverride,
  });

  // Icon-only constructor — see AppIconShape for the three shapes in the screenshot.
  const factory AppButton.icon({
    Key? key,
    required IconData icon,
    required VoidCallback? onPressed,
    AppButtonVariant variant,
    AppIconShape shape,
    bool isLoading,
    ButtonStyle? styleOverride,
  }) = _AppIconButton;

  ButtonStyle _resolveStyle(BuildContext context) {
    final base = switch (variant) {
      AppButtonVariant.primary => AppButtonStyles.primary(context),
      AppButtonVariant.secondary => AppButtonStyles.secondary(context),
      AppButtonVariant.outline => AppButtonStyles.outline(context),
      AppButtonVariant.ghost => AppButtonStyles.ghost(context),
      AppButtonVariant.text => AppButtonStyles.text(context),
      AppButtonVariant.destructive => AppButtonStyles.destructive(context),
      AppButtonVariant.success => AppButtonStyles.success(context),
      AppButtonVariant.warning => AppButtonStyles.warning(context),
      AppButtonVariant.warningFilled => AppButtonStyles.warning(context),
      AppButtonVariant.link => AppButtonStyles.link(context),
    };

    var style = base;
    if (width != null || height != null) {
      style = style.copyWith(minimumSize: WidgetStateProperty.all(Size(width ?? double.infinity, height ?? AppSizes.fieldHeight)));
    }
    if (padding != null) {
      style = style.copyWith(padding: WidgetStateProperty.all(padding));
    }
    if (!_isTextLike) {
      style = style.copyWith(
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
        ),
      );
    }
    if (styleOverride != null) {
      style = style.merge(styleOverride!);
    }
    return style;
  }

  Widget _buildChild(BuildContext context, Color spinnerColor) {
    if (isLoading) {
      return SizedBox(
        height: 18,
        width: 18,
        child: CircularProgressIndicator(strokeWidth: 2, color: spinnerColor),
      );
    }
    if (leadingIcon == null && trailingIcon == null) return child ?? const SizedBox.shrink();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (leadingIcon != null) ...[Icon(leadingIcon, size: 18), const SizedBox(width: 8)],
        if (child != null) child!,
        if (trailingIcon != null) ...[const SizedBox(width: 8), Icon(trailingIcon, size: 18)],
      ],
    );
  }

  bool get _isTextLike => variant == AppButtonVariant.text || variant == AppButtonVariant.link;

  @override
  Widget build(BuildContext context) {
    final style = _resolveStyle(context);
    final onColor = style.foregroundColor?.resolve({}) ?? AppColors.white;
    final effectiveOnPressed = isLoading ? null : onPressed;
    final child = _buildChild(context, onColor);

    if (_isTextLike) {
      return TextButton(onPressed: effectiveOnPressed, style: style, child: child);
    }
    return ElevatedButton(onPressed: effectiveOnPressed, style: style, child: child);
  }
}

class _AppIconButton extends AppButton {
  final IconData icon;
  final AppIconShape shape;

  const _AppIconButton({
    super.key,
    required this.icon,
    required super.onPressed,
    super.variant = AppButtonVariant.primary,
    this.shape = AppIconShape.rounded,
    super.isLoading = false,
    super.styleOverride,
  }) : super(child: null);

  @override
  Widget build(BuildContext context) {
    final baseStyle = _resolveStyle(context);
    final size = shape == AppIconShape.circle ? 48.0 : 44.0;

    final shapeOverride = switch (shape) {
      AppIconShape.circle => const CircleBorder(),
      AppIconShape.rounded => RoundedRectangleBorder(borderRadius: AppRadius.button),
      AppIconShape.square => RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.r8)),
    };

    final style = baseStyle.copyWith(
      shape: WidgetStateProperty.all(shapeOverride),
      minimumSize: WidgetStateProperty.all(Size(size, size)),
      padding: WidgetStateProperty.all(EdgeInsets.zero),
    );

    final onColor = style.foregroundColor?.resolve({}) ?? AppColors.white;

    return IconButton(
      onPressed: isLoading ? null : onPressed,
      style: style,
      icon: isLoading
          ? SizedBox(
        height: 18,
        width: 18,
        child: CircularProgressIndicator(strokeWidth: 2, color: onColor),
      )
          : Icon(icon, size: 20),
    );
  }
}