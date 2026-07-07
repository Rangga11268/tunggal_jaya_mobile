import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_exceptions.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../../core/config/api_endpoints.dart';

class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final String? error;
  final Map<String, dynamic>? user;

  const AuthState({
    this.isAuthenticated = false,
    this.isLoading = false,
    this.error,
    this.user,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    String? error,
    Map<String, dynamic>? user,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      user: user ?? this.user,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final ApiClient _apiClient;
  final SecureStorageService _secureStorage;

  AuthNotifier(this._apiClient, this._secureStorage)
      : super(const AuthState(isLoading: true)) {
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final token = await _secureStorage.getToken();
    if (token != null) {
      final user = await _secureStorage.getUserData();
      state = AuthState(isAuthenticated: true, user: user);
    } else {
      state = const AuthState();
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _apiClient.post(ApiEndpoints.login, data: {
        'email': email,
        'password': password,
      });

      final data = response['data'] as Map<String, dynamic>;
      final token = data['token'] as String;
      final user = data['user'] as Map<String, dynamic>;

      await _secureStorage.saveToken(token);
      await _secureStorage.saveUserData(user);

      state = AuthState(isAuthenticated: true, user: user);
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Terjadi kesalahan, silakan coba lagi',
      );
    }
  }

  Future<void> register(Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _apiClient.post(ApiEndpoints.register, data: data);

      final responseData = response['data'] as Map<String, dynamic>;
      final token = responseData['token'] as String;
      final user = responseData['user'] as Map<String, dynamic>;

      await _secureStorage.saveToken(token);
      await _secureStorage.saveUserData(user);

      state = AuthState(isAuthenticated: true, user: user);
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Terjadi kesalahan, silakan coba lagi',
      );
    }
  }

  Future<void> logout() async {
    try {
      await _apiClient.post(ApiEndpoints.logout);
    } catch (_) {}

    await _secureStorage.clearAll();
    state = const AuthState();
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final apiClient = ref.read(apiClientProvider);
  final secureStorage = ref.read(secureStorageProvider);
  return AuthNotifier(apiClient, secureStorage);
});
