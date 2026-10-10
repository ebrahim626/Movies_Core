import 'package:flutter/material.dart';
import '../../../../core/service/helper/shimmer_box.dart';


class MovieRowShimmer extends StatelessWidget {
  const MovieRowShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 195,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, __) => const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerBox(width: 111, height: 135),
            SizedBox(height: 8),
            ShimmerBox(width: 90, height: 10, radius: 6),
            SizedBox(height: 6),
            ShimmerBox(width: 60, height: 10, radius: 6),
          ],
        ),
      ),
    );
  }
}