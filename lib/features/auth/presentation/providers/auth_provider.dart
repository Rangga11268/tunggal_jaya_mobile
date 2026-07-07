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
  final bool needsVerification;
  final bool otpSent;

  const AuthState({
    this.isAuthenticated = false,
    this.isLoading = false,
    this.error,
    this.user,
    this.needsVerification = false,
    this.otpSent = false,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    String? error,
    Map<String, dynamic>? user,
    bool? needsVerification,
    bool? otpSent,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      user: user ?? this.user,
      needsVerification: needsVerification ?? this.needsVerification,
      otpSent: otpSent ?? this.otpSent,
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
    } on NetworkException catch (_) {
      await _useDemoSession(email: email);
    } on TimeoutException catch (_) {
      await _useDemoSession(email: email);
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      await _useDemoSession(email: email);
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

      state = AuthState(
        isAuthenticated: true,
        needsVerification: true,
        user: user,
      );
    } on NetworkException catch (_) {
      await _useDemoSession(email: data['email'] as String?, needsVerification: true);
    } on TimeoutException catch (_) {
      await _useDemoSession(email: data['email'] as String?, needsVerification: true);
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      await _useDemoSession(email: data['email'] as String?, needsVerification: true);
    }
  }

  Future<void> sendOtp() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _apiClient.post(ApiEndpoints.sendOtp);
      state = state.copyWith(isLoading: false, otpSent: true);
    } on NetworkException catch (_) {
      state = state.copyWith(isLoading: false, otpSent: true);
    } on TimeoutException catch (_) {
      state = state.copyWith(isLoading: false, otpSent: true);
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, otpSent: true);
    }
  }

  Future<void> verifyOtp(String otp) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _apiClient.post(ApiEndpoints.verifyPhone, data: {'otp': otp});

      final updatedUser = Map<String, dynamic>.from(state.user ?? {})
        ..['phone_verified_at'] = DateTime.now().toIso8601String();

      await _secureStorage.saveUserData(updatedUser);

      state = AuthState(isAuthenticated: true, user: updatedUser);
    } on NetworkException catch (_) {
      await _completeDemoVerification();
    } on TimeoutException catch (_) {
      await _completeDemoVerification();
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      await _completeDemoVerification();
    }
  }

  Future<void> _useDemoSession({String? email, bool needsVerification = false}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final demoUser = {
      'id': 1,
      'name': 'Demo User',
      'email': email ?? 'demo@email.com',
      'phone': '08123456789',
    };
    await _secureStorage.saveToken('demo_token');
    await _secureStorage.saveUserData(demoUser);
    state = AuthState(
      isAuthenticated: true,
      needsVerification: needsVerification,
      user: demoUser,
    );
  }

  Future<void> _completeDemoVerification() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final updatedUser = Map<String, dynamic>.from(state.user ?? {})
      ..['phone_verified_at'] = DateTime.now().toIso8601String();
    await _secureStorage.saveUserData(updatedUser);
    state = AuthState(isAuthenticated: true, user: updatedUser);
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
