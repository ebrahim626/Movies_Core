part of '../api_client.export.dart';

class ApiEndpoints {
  ApiEndpoints._();

  static const String _v1 = "https://api.themoviedb.org/3/";

  //static const String baseUrl = "https://obliged-cytoplast-cornhusk.ngrok-free.dev";
  static const String baseUrl = "https://dev.drivableed.com";

  static const String createRequestTokenEndpoint = "$_v1/authentication/token/new";

  static const String createSessionEndpoint = "$_v1/authentication/session/new";

  static const String deleteSessionEndpoint = "$_v1/authentication/session";

  static const String topRatedEndpoint = "$_v1/movie/top_rated";

  static const  String popularMoviesEndpoint = "$_v1/movie/popular";

  static const String upcomingMoviesEndpoint = "$_v1/movie/upcoming";

  static const String nowPlayingMoviesEndpoint = "$_v1/movie/now_playing";


}