part of '../api_client.export.dart';

class ApiEndpoints {
  ApiEndpoints._();

  static const String _v1 = "https://api.themoviedb.org/3/";

  //static const String baseUrl = "https://obliged-cytoplast-cornhusk.ngrok-free.dev";
  static const String baseUrl = "https://dev.drivableed.com";

  static const String topRatedEndpoint = "$_v1/movie/top_rated";

  static const  String popularMoviesEndpoint = "$_v1/movie/popular";

  static const String upcomingMoviesEndpoint = "$_v1/movie/upcoming";

}