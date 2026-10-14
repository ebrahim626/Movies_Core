import 'dart:ffi';

class Movie {
  final int id;
  final String title;
  final String? posterPath;
  final String? backdropPath;
  final String? releaseDate;
  final num? popularity;
  final double voteAverage;

  const Movie({
    required this.id,
    required this.title,
    this.posterPath,
    this.backdropPath,
    this.releaseDate,
    required this.voteAverage,
    this.popularity,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
    id: json['id'] as int,
    title: json['title'] as String? ?? '',
    posterPath: json['poster_path'] as String?,
    backdropPath: json['backdrop_path'] as String?,
    releaseDate: json['release_date'] as String?,
    popularity: json['popularity'] as double?,
    voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0,
  );

}

class HomeData {
  final List<Movie> popular;
  final List<Movie> upcoming;
  final List<Movie> topRated;
  final List<Movie> nowPlaying;

  const HomeData({
    required this.popular,
    required this.upcoming,
    required this.topRated,
    required this.nowPlaying,
  });
}

