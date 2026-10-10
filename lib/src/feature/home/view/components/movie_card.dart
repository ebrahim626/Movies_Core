import 'package:flutter/material.dart';
import 'package:movies_core/src/core/extensions/context.dart';
import 'package:movies_core/src/core/service/helper/tmdb_helper.dart';

import '../../model/movie_model.dart';

class MovieCard extends StatelessWidget {
  const MovieCard({super.key, required this.movie, this.onTap});

  final Movie movie;
  final VoidCallback? onTap;

  static const double width = 111;
  static const double imageHeight = 135;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        child: Column(
          children: [
            Container(
              height: imageHeight,
              width: width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: NetworkImage(TmdbImage.poster(movie.posterPath)),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              movie.title ?? '',
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.text.bodySmall?.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}