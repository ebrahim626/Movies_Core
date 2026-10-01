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
      path: ApiEndpoints.loginEndpoint,
    );
  }
}