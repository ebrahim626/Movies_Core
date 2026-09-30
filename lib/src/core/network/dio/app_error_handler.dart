// src/core/utils/error_handler.dart
import 'package:dio/dio.dart';

class AppErrorHandler {
  static String getErrorMessage(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionError:
        case DioExceptionType.unknown:
          return "No internet connection. Please check your network.";
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
          return "Request timed out. Please try again.";
        case DioExceptionType.badResponse:
          return _handleStatusCode(error.response?.statusCode);
        default:
          return "Something went wrong. Please try again.";
      }
    }
    return "An unexpected error occurred.";
  }

  static String _handleStatusCode(int? statusCode) {
    switch (statusCode) {
      case 500:
      case 502:
      case 503:
        return "Server is currently unavailable. Try again later.";
      case 404:
        return "Requested data not found.";
      case 401:
      case 403:
        return "You are not authorized to view this content.";
      default:
        return "Server error (${statusCode ?? 'unknown'}). Please try again.";
    }
  }
}
