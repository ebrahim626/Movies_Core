class Movie {
  final int id;
  final String title;
  final String? posterPath;
  final double voteAverage;

  const Movie({
    required this.id,
    required this.title,
    this.posterPath,
    required this.voteAverage,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
    id: json['id'] as int,
    title: json['title'] as String? ?? '',
    posterPath: json['poster_path'] as String?,
    voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0,
  );

}

class HomeData {
  final List<Movie> popular;
  final List<Movie> upcoming;
  final List<Movie> topRated;

  const HomeData({
    required this.popular,
    required this.upcoming,
    required this.topRated,
  });
}

