import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_core/src/core/utils/theme/app_tokens.dart';
import 'package:movies_core/src/feature/home/controller/home_controller.dart';
import 'package:movies_core/src/feature/home/view/components/popular_carousel.dart';
import 'components/carousel_shimmer.dart';
import 'components/movie_section.dart';


class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const String name = "home-screen";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final home = ref.watch(homeProvider);
    final isLoading = !home.hasValue && home.isLoading; // first load only

    return Scaffold(
      backgroundColor: AppColors.slate600,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 22),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(backgroundColor: Colors.red),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Aktaruzzaman"),
                        Text("Let's watch a movie"),
                      ],
                    ),
                    Spacer(),
                    Icon(Icons.search),
                    SizedBox(width: 6),
                    Icon(Icons.notifications_none_outlined),
                  ],
                ),
                SizedBox(height: 20),
                // Banner
                isLoading
                    ? const CarouselShimmer()
                    : PopularCarousel(movies: home.value?.popular ?? const []),
                const SizedBox(height: 20),

                MovieSection(
                  title: "Upcoming Movies",
                  movies: home.value?.upcoming ?? const [],
                  isLoading: isLoading,
                  onSeeAll: () {},
                ),
                const SizedBox(height: 20),

                MovieSection(
                  title: "Top Rated",
                  movies: home.value?.topRated ?? const [],
                  isLoading: isLoading,
                  onSeeAll: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
