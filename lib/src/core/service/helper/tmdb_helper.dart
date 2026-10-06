class TmdbImage {
  static const String _baseUrl = "https://image.tmdb.org/t/p";

  static String poster(String? path, {String size = "w342"}) {
    if (path == null || path.isEmpty) return "";
    return "$_baseUrl/$size$path";
  }
}