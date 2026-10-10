import 'package:flutter/material.dart';
import 'package:movies_core/src/core/extensions/context.dart';

import '../../model/movie_model.dart';
import 'movie_card.dart';
import 'movie_row_shimmer.dart';

class MovieSection extends StatelessWidget {
  const MovieSection({
    super.key,
    required this.title,
    required this.movies,
    this.isLoading = false,
    this.onSeeAll,
    this.onMovieTap,
  });

  final String title;
  final List<Movie> movies;
  final bool isLoading;
  final VoidCallback? onSeeAll;
  final ValueChanged<Movie>? onMovieTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: context.text.titleMedium?.copyWith(color: Colors.white),
            ),
            const Spacer(),
            GestureDetector(
              onTap: onSeeAll,
              child: Text(
                "See all",
                style: context.text.titleMedium
                    ?.copyWith(color: Colors.blueAccent),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (isLoading)
          const MovieRowShimmer()
        else
          SizedBox(
            height: 195, // image (135) + gap (6) + 2 lines of text
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: movies.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final movie = movies[index];
                return MovieCard(
                  movie: movie,
                  onTap: onMovieTap == null ? null : () => onMovieTap!(movie),
                );
              },
            ),
          ),
      ],
    );
  }
}