part of '../api_client.export.dart';

class ApiEndpoints {
  ApiEndpoints._();

  static const String _v1 = "/drivable-api/v1";

  //static const String baseUrl = "https://obliged-cytoplast-cornhusk.ngrok-free.dev";
  static const String baseUrl = "https://dev.drivableed.com";

  static const String loginEndpoint = "$_v1/auth/login";

  static const  String exploreCourseEndpoint = "$_v1/basic-course/open/all";

  static const String courseProgressEndpoint = "$_v1/student-course-progress/my-progress";

  static const String profileEndpoint = "$_v1/auth/me";

  static String courseDetailsEndpoint({required String slug})  => "$_v1/basic-course/open/$slug";

  static const String publishableKeyEndpoint = "$_v1/payment/stripe-public-key";

  static const String processPaymentEndpoint = "$_v1/payment/process";

  static const String createIntentEndpoint = "$_v1/payment/create-intent";

  static String couponValidate({required String coupon}) => "$_v1/coupons/validate/$coupon";

  static const String forgotPasswordEndpoint = "$_v1/auth/forgot-password";

  static const String otpVerifyEndpoint = "$_v1/auth/verify-forgot-password-otp";

  static const String createNewPasswordEndpoint = "$_v1/auth/reset-password";

  static String courseLevelEndpoint({required int courseId}) =>
      "$_v1/student-course-progress/course/$courseId/levels";

  static String courseOverviewProgressEndpoint({required int courseId}) =>
      "$_v1/student-course-progress/$courseId/progress";

  static String courseLevelChaptersEndpoint({required int levelId}) => "$_v1/student-course-progress/level/$levelId/chapters";

  static String courseGettingStartedProfileCompleteEndpoint({required int courseId}) => "$_v1/student-course-progress/getting-started/$courseId/profile-complete";

  static String courseGettingStartedVerificationCompletedEndpoint({required int courseId}) => "$_v1/student-course-progress/getting-started/$courseId/verification-complete";

  static String chapterPagesEndpoint({required int chapterId}) => "$_v1/student-course-progress/chapter/$chapterId/pages";

  static String pageDetailsEndpoint({required int chapterId, required int pageId}) => "$_v1/student-course-progress/chapter/$chapterId/pages/$pageId";

  static const String presignedEndpoint = "$_v1/video/presigned-url";

  static String pageCompleteEndpoint({required int pageId}) => "$_v1/student-course-progress/page/$pageId/complete";

  static String quizStartEndpoint({required int quizId}) => "$_v1/student-course-progress/quiz/$quizId/attempt";

  static String answerQuizEndpoint({required int id}) => "$_v1/student-course-progress/quiz/attempt/$id/answer";

  static String submitQuizEndpoint({required int id}) => "$_v1/student-course-progress/quiz/attempt/$id/submit";
}