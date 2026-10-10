import 'package:flutter/material.dart';
import '../../../../core/service/helper/shimmer_box.dart';

class CarouselShimmer extends StatelessWidget {
  const CarouselShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        ShimmerBox(height: 180, width: double.infinity),
        SizedBox(height: 16),
        ShimmerBox(height: 8, width: 40, radius: 10),
      ],
    );
  }
}
