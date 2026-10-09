import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:movies_core/src/core/service/helper/tmdb_helper.dart';
import 'package:movies_core/src/feature/common/widgets/button/app_button.dart';

import '../../model/movie_model.dart';

class PopularCarousel extends StatefulWidget {
  const PopularCarousel({super.key, required this.movies});

  // Replace `Movie` with your actual model class
  final List<Movie> movies;

  @override
  State<PopularCarousel> createState() => _PopularCarouselState();
}

class _PopularCarouselState extends State<PopularCarousel> {
  final _controller = PageController();
  Timer? _timer;
  int _current = 0;

  int get _count => math.min(5, widget.movies.length); // show first 5

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!_controller.hasClients || _count < 2) return;
      final next = (_current + 1) % _count;
      _controller.animateToPage(
        next,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_count == 0) {
      return const SizedBox(height: 180);
    }

    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _controller,
            itemCount: _count,
            onPageChanged: (i) => setState(() => _current = i),
            itemBuilder: (context, index) {
              final movie = widget.movies[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: NetworkImage(TmdbImage.poster(movie.backdropPath)),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Watch popular movies : ${movie.title}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    const Text("Lyrics are the words that make up a song."),
                    const Spacer(),
                    AppButton(
                      onPressed: () {},
                      width: 133,
                      child: const Text("Clicked Here"),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_count, (i) {
            final active = i == _current;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: active ? 16 : 6,
              height: active ? 8 : 6,
              decoration: BoxDecoration(
                color: active ? Colors.blue : Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
            );
          }),
        ),
      ],
    );
  }
}