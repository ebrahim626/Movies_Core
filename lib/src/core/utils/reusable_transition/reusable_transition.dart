import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

CustomTransitionPage<T> cinematicRevealPage<T>({
  required GoRouterState state,
  required Widget child,
  Duration duration = const Duration(milliseconds: 900),
  Alignment origin = Alignment.center,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: duration,
    reverseTransitionDuration: const Duration(milliseconds: 350),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Circle expansion: slow start, fast middle, soft landing
      final reveal = animation.drive(
        CurveTween(curve: Curves.easeInOutCubic),
      );

      // Content settles from a slight zoom-in
      final scale = animation.drive(
        Tween<double>(begin: 1.15, end: 1.0).chain(
          CurveTween(curve: Curves.easeOutCubic),
        ),
      );

      // Content fades in during the first half
      final fade = animation.drive(
        CurveTween(curve: const Interval(0.0, 0.5, curve: Curves.easeOut)),
      );

      return AnimatedBuilder(
        animation: animation,
        builder: (context, _) {
          return ClipPath(
            clipper: _CircleRevealClipper(
              fraction: reveal.value,
              origin: origin,
            ),
            child: FadeTransition(
              opacity: fade,
              child: ScaleTransition(scale: scale, child: child),
            ),
          );
        },
      );
    },
  );
}

class _CircleRevealClipper extends CustomClipper<Path> {
  _CircleRevealClipper({required this.fraction, required this.origin});

  final double fraction;
  final Alignment origin;

  @override
  Path getClip(Size size) {
    final center = origin.alongSize(size);

    // Radius needed to cover the farthest corner from the origin
    final maxRadius = [
      (center - Offset.zero).distance,
      (center - Offset(size.width, 0)).distance,
      (center - Offset(0, size.height)).distance,
      (center - Offset(size.width, size.height)).distance,
    ].reduce((a, b) => a > b ? a : b);

    return Path()
      ..addOval(Rect.fromCircle(center: center, radius: maxRadius * fraction));
  }

  @override
  bool shouldReclip(_CircleRevealClipper old) =>
      old.fraction != fraction || old.origin != origin;
}