// features/auth/login/repository/login_repository.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.export.dart';

final loginRepositoryProvider = Provider<LoginRepository>((ref) {
  return LoginRepository(apiClient: ref.read(apiClientProvider));
});

class LoginRepository {
  final ApiClient apiClient;

  LoginRepository({required this.apiClient});

  Future<ApiResponse<dynamic>> login() async {
    return await apiClient.post(
      apiType: APIType.public,
      path: ApiEndpoints.topRatedEndpoint,
    );
  }

  Future<ApiResponse<dynamic>> createRequestToken() async {
    return await apiClient.get(
      apiType: APIType.private,
      tokenType: TokenType.bearerToken,
      path: ApiEndpoints.createRequestTokenEndpoint,
    );
  }

  Future<ApiResponse<dynamic>> createSession({required String requestToken}) async {
    return await apiClient.post(
      apiType: APIType.private,
      tokenType: TokenType.bearerToken,
      path: ApiEndpoints.createSessionEndpoint,
      query: {
        'request_token': requestToken
      }
    );
  }

  // Future<ApiResponse<dynamic>> deleteSession() async {
  //   return await apiClient.post(
  //       apiType: APIType.private,
  //       tokenType: TokenType.bearerToken,
  //       path: ApiEndpoints.deleteSessionEndpoint,
  //   );
  // }

  // DELETE /authentication/session  { "session_id": "..." }
  Future<ApiResponse<dynamic>> deleteSession({required String sessionId}) {
    return apiClient.delete(
      apiType: APIType.private,
      tokenType: TokenType.bearerToken,
      path: ApiEndpoints.deleteSessionEndpoint,
      data: {'session_id': sessionId},
    );
  }

}