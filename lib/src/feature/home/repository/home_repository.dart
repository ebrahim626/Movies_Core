import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.export.dart';

final homeRepository = Provider<HomeRepository>((ref) {
  return HomeRepository(apiClient: ref.read(apiClientProvider));
});

class HomeRepository {
  final ApiClient apiClient;

  HomeRepository({required this.apiClient});

  Future<ApiResponse<dynamic>> topRatedMovies() async {
    return await apiClient.get(
      apiType: APIType.private,
      tokenType: TokenType.bearerToken,
      path: ApiEndpoints.topRatedEndpoint,
    );
  }

  Future<ApiResponse<dynamic>> popularMovies() async {
    return await apiClient.get(
      apiType: APIType.private,
      tokenType: TokenType.bearerToken,
      path: ApiEndpoints.popularMoviesEndpoint,
    );
  }

  Future<ApiResponse<dynamic>> upcomingMovies() async {
    return await apiClient.get(
      apiType: APIType.private,
      tokenType: TokenType.bearerToken,
      path: ApiEndpoints.upcomingMoviesEndpoint,
    );
  }

  Future<ApiResponse<dynamic>> nowPlayingMovies() async {
    return await apiClient.get(
      apiType: APIType.private,
      tokenType: TokenType.bearerToken,
      path: ApiEndpoints.nowPlayingMoviesEndpoint,
    );
  }
}