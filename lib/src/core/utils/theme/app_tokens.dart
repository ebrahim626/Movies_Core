import 'package:flutter/material.dart';

/// Design tokens — single source of truth for colors, radius, and spacing.
/// Mirrors the numbered scale (50–900) convention from the design system,
/// so any new UI can reference `AppColors.primary600` instead of hex values.
class AppColors {
  AppColors._();

  // ---- Primary (Brand Navy) ----
  static const primary50 = Color(0xFFEEF2FF);
  static const primary200 = Color(0xFFC7D2FE);
  static const primary400 = Color(0xFF818CF8);
  static const primary500 = Color(0xFF8366F1);
  static const primary600 = Color(0xFF4F46E5);
  static const primary700 = Color(0xFF1A2B8A); // brand base
  static const primary800 = Color(0xFF1E1E4B);
  static const primary900 = Color(0xFF0F0F2E);

  // ---- Secondary (Slate) ----
  static const slate50 = Color(0xFFF8FAFC);
  static const slate200 = Color(0xFFE2E8F0);
  static const slate500 = Color(0xFF64748B);
  static const slate600 = Color(0xFF475569);
  static const slate700 = Color(0xFF334155);
  static const slate800 = Color(0xFF1E293B);

  // ---- Success ----
  static const success50 = Color(0xFFF0FDF4);
  static const success500 = Color(0xFF22C55E);
  static const success600 = Color(0xFF16A34A);
  static const success700 = Color(0xFF15803D);

  // ---- Warning ----
  static const warning50 = Color(0xFFFFFBEB);
  static const warning500 = Color(0xFFF59E0B);
  static const warning600 = Color(0xFFD97706);
  static const warning700 = Color(0xFFB45309);

  // ---- Error / Destructive ----
  static const error50 = Color(0xFFFFF1F2);
  static const error500 = Color(0xFFEF4444);
  static const error600 = Color(0xFFDC2626);
  static const error700 = Color(0xFFB91C1C);

  // ---- Neutral ----
  static const white = Color(0xFFFFFFFF);
  static const neutral100 = Color(0xFFF5F5F5);
  static const neutral200 = Color(0xFFE5E5E5);
  static const neutral400 = Color(0xFFA3A3A3);
  static const neutral500 = Color(0xFF737373);
  static const neutral800 = Color(0xFF262626);
  static const black = Color(0xFF000000);

  // ---- Surface tints ----
  static const chipBackground = Color(0xFFF5F6FA);

  // ---- Dark-mode surface set ----
  // Kept separate rather than inverting math on the light palette —
  // dark surfaces need their own tuned neutrals, not just "light in reverse".
  static const darkBackground = Color(0xFF0F1115);
  static const darkSurface = Color(0xFF171A21);
  static const darkSurfaceAlt = Color(0xFF1F232C);
  static const darkBorder = Color(0xFF2A2F3A);
  static const darkBodyText = Color(0xFFA1A7B3);
  static const darkTitleText = Color(0xFFF5F6F8);
}

class AppRadius {
  AppRadius._();

  static const r8 = 8.0;
  static const r12 = 12.0;
  static const r16 = 16.0;
  static const r20 = 20.0;
  static const pill = 999.0;

  static BorderRadius get card => BorderRadius.circular(r12);
  static BorderRadius get button => BorderRadius.circular(r12);
  static BorderRadius get input => BorderRadius.circular(r12);
  static BorderRadius get dialog => BorderRadius.circular(r20);
  static BorderRadius get chip => BorderRadius.circular(pill);
}

class AppElevation {
  AppElevation._();

  static const none = <BoxShadow>[];

  static List<BoxShadow> small(Color shadowColor) => [
    BoxShadow(color: shadowColor.withValues(alpha: 0.08), blurRadius: 4, offset: const Offset(0, 2)),
  ];

  static List<BoxShadow> medium(Color shadowColor) => [
    BoxShadow(color: shadowColor.withValues(alpha: 0.12), blurRadius: 12, offset: const Offset(0, 4)),
  ];
}

// core/utils/theme/app_tokens.dart
class AppSizes {
  AppSizes._();
  static const double fieldHeight = 48; // shared height: buttons + text fields
}