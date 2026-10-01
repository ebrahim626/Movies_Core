part of '../api_client.export.dart';

class ApiEndpoints {
  ApiEndpoints._();

  static const String _v1 = "https://api.themoviedb.org/3/";

  //static const String baseUrl = "https://obliged-cytoplast-cornhusk.ngrok-free.dev";
  static const String baseUrl = "https://dev.drivableed.com";

  static const String loginEndpoint = "$_v1/auth/login";

  static const  String exploreCourseEndpoint = "$_v1/basic-course/open/all";

  static const String courseProgressEndpoint = "$_v1/student-course-progress/my-progress";

}