import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Slow, cinematic "curtain drop": the old page is pulled DOWN and away,
/// revealing the new page from the top edge.
///
/// Use it on BOTH routes involved:
///  - the new page (e.g. Home): default settings
///  - the old page (e.g. Splash/Login): default settings, so it slides down
///
/// For Home, pass `slideOutOnCover: false` so Home does not slide down
/// when you later push other pages on top of it.
CustomTransitionPage<T> slideDownRevealPage<T>({
  required GoRouterState state,
  required Widget child,
  Duration duration = const Duration(milliseconds: 1800),
  Duration reverseDuration = const Duration(milliseconds: 700),
  double parallax = 0.12, // new page starts this far above its final spot
  double startScale = 1.12, // new page settles from a zoom
  double dimAmount = 0.45, // darkness on the new page at the start
  double outgoingDim = 0.35, // darkness on the old page as it leaves
  double cornerRadius = 32, // old page's top corners while sliding
  bool showEdgeShadow = true,
  bool slideOutOnCover = true,
}) {
  // Slow start, long smooth glide, very soft landing.
  const curve = Cubic(0.70, 0.0, 0.20, 1.0);

  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: duration,
    reverseTransitionDuration: reverseDuration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final reveal = CurvedAnimation(
        parent: animation,
        curve: curve,
        reverseCurve: Curves.easeInOutCubic,
      );
      final exit = CurvedAnimation(
        parent: secondaryAnimation,
        curve: curve,
        reverseCurve: Curves.easeInOutCubic,
      );

      // ---- Incoming layer: revealed from the top edge ----
      final incoming = AnimatedBuilder(
        animation: reveal,
        child: child,
        builder: (context, child) {
          final t = reveal.value.clamp(0.0, 1.0);

          return LayoutBuilder(
            builder: (context, constraints) {
              final h = constraints.maxHeight;
              const shadowHeight = 90.0;
              // Content settles a bit later than the curtain for depth.
              final settle = Curves.easeOutCubic.transform(
                ((t - 0.1) / 0.9).clamp(0.0, 1.0),
              );

              return ClipRect(
                clipper: _TopRevealClipper(t),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    FractionalTranslation(
                      translation: Offset(0, -parallax * (1 - settle)),
                      child: Transform.scale(
                        scale: startScale + (1.0 - startScale) * settle,
                        child: child,
                      ),
                    ),

                    // Dim fades out as the page is uncovered
                    if (dimAmount > 0)
                      IgnorePointer(
                        child: ColoredBox(
                          color: Color.fromRGBO(
                            0,
                            0,
                            0,
                            dimAmount * (1 - settle),
                          ),
                        ),
                      ),

                    if (showEdgeShadow) ...[
                      // Soft shadow cast by the old page onto the new one
                      Positioned(
                        left: 0,
                        right: 0,
                        top: h * t - shadowHeight,
                        height: shadowHeight,
                        child: IgnorePointer(
                          child: Opacity(
                            opacity: math.sin(t * math.pi).clamp(0.0, 1.0),
                            child: const DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0x00000000),
                                    Color(0x80000000),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Thin highlight on the leading edge
                      Positioned(
                        left: 0,
                        right: 0,
                        top: h * t - 1.5,
                        height: 1.5,
                        child: IgnorePointer(
                          child: Opacity(
                            opacity: math.sin(t * math.pi).clamp(0.0, 1.0),
                            child: const ColoredBox(color: Color(0x40FFFFFF)),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          );
        },
      );

      if (!slideOutOnCover) return incoming;

      // ---- Outgoing: this page is pulled down when covered ----
      return AnimatedBuilder(
        animation: exit,
        child: incoming,
        builder: (context, child) {
          final e = exit.value.clamp(0.0, 1.0);
          return FractionalTranslation(
            translation: Offset(0, e),
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(cornerRadius * e),
              ),
              child: Stack(
                fit: StackFit.passthrough,
                children: [
                  child!,
                  if (outgoingDim > 0)
                    Positioned.fill(
                      child: IgnorePointer(
                        child: ColoredBox(
                          color: Color.fromRGBO(0, 0, 0, outgoingDim * e),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

class _TopRevealClipper extends CustomClipper<Rect> {
  _TopRevealClipper(this.progress);

  final double progress;

  @override
  Rect getClip(Size size) =>
      Rect.fromLTWH(0, 0, size.width, size.height * progress);

  @override
  bool shouldReclip(_TopRevealClipper old) => old.progress != progress;
}

/// Wrap home elements (header, cards, sections) so they rise and fade in
/// one after another while the curtain opens.
///
/// [index] controls the order: 0 appears first, 1 next, and so on.
class RouteStagger extends StatelessWidget {
  const RouteStagger({
    super.key,
    required this.index,
    required this.child,
    this.step = 0.07,
    this.offset = 28,
  });

  final int index;
  final Widget child;
  final double step; // delay between items (fraction of the transition)
  final double offset; // pixels to travel upward

  @override
  Widget build(BuildContext context) {
    final route = ModalRoute.of(context);
    final animation = route?.animation;
    if (animation == null) return child;

    // Items start after the curtain is ~35% open.
    final start = (0.35 + index * step).clamp(0.0, 0.9);
    final end = (start + 0.4).clamp(0.0, 1.0);
    final curved = CurvedAnimation(
      parent: animation,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    );

    return AnimatedBuilder(
      animation: curved,
      child: child,
      builder: (context, child) => Opacity(
        opacity: curved.value,
        child: Transform.translate(
          offset: Offset(0, offset * (1 - curved.value)),
          child: child,
        ),
      ),
    );
  }
}