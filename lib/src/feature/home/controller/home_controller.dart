import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.export.dart';

final loginRepositoryProvider = Provider<HomeController>((ref) {
  return HomeController(apiClient: ref.read(apiClientProvider));
});

class HomeController {
  final ApiClient apiClient;

  HomeController({required this.apiClient});

  Future<ApiResponse<dynamic>> topRatedMovies() async {
    return await apiClient.get(
      apiType: APIType.private,
      tokenType: TokenType.bearerToken,
      path: ApiEndpoints.topRatedEndpoint,
    );
  }
}