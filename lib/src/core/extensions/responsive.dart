import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Drop-in replacement for `.sp` that stops growing past a sane cap,
/// so text doesn't balloon on tablets/iPads.
extension ResponsiveFontSize on num {
  /// Getter version — use this directly as `16.rsp`.
  /// Never renders more than 30% bigger than the base value,
  /// no matter how wide the screen gets.
  double get rsp => clampedSp(1.3);

  /// Call this directly if you want a custom cap, e.g. `16.clampedSp(1.15)`.
  double clampedSp(double maxScale) {
    final scaled = ScreenUtil().setSp(toDouble());
    final cap = toDouble() * maxScale;
    return scaled > cap ? cap : scaled;
  }
}

/// Drop-in replacements for `.w` / `.h` / `.r` that stop growing past a
/// sane cap, so buttons, cards, and radii don't balloon on tablets/iPads.
extension ResponsiveSize on num {
  /// Use as `200.rw` instead of `200.w`.
  double get rw => clampedW(1.3);

  /// Use as `48.rh` instead of `48.h`.
  double get rh => clampedH(1.3);

  /// Use as `12.rr` instead of `12.r`. Radii usually want a tighter cap
  /// since a "bigger rounded corner" reads as a style change, not a fix.
  double get rr => clampedR(1.15);

  double clampedW(double maxScale) {
    final scaled = ScreenUtil().setWidth(toDouble());
    final cap = toDouble() * maxScale;
    return scaled > cap ? cap : scaled;
  }

  double clampedH(double maxScale) {
    final scaled = ScreenUtil().setHeight(toDouble());
    final cap = toDouble() * maxScale;
    return scaled > cap ? cap : scaled;
  }

  double clampedR(double maxScale) {
    final scaled = ScreenUtil().radius(toDouble());
    final cap = toDouble() * maxScale;
    return scaled > cap ? cap : scaled;
  }
}
