import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/app_config.dart';
import '../storage/secure_storage.dart';
import 'api_exceptions.dart';

class ApiClient {
  late final Dio _dio;
  final SecureStorageService _secureStorage;

  ApiClient(this._secureStorage) {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiUrl,
        connectTimeout: AppConfig.requestTimeout,
        receiveTimeout: AppConfig.requestTimeout,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _secureStorage.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) {
          handler.next(error);
        },
      ),
    );
  }

  Future<Map<String, dynamic>> _handleResponse(Response response) async {
    return response.data as Map<String, dynamic>;
  }

  ApiException _handleError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return const TimeoutException();
    }

    if (error.type == DioExceptionType.connectionError) {
      return const NetworkException();
    }

    final statusCode = error.response?.statusCode;
    final data = error.response?.data;

    if (statusCode == 401) {
      _secureStorage.clearToken();
      return UnauthorizedException(
        message: (data is Map) ? (data['message'] as String? ?? 'Sesi habis') : 'Sesi habis',
      );
    }

    if (statusCode == 404) {
      return NotFoundException(
        message: (data is Map) ? (data['message'] as String? ?? 'Data tidak ditemukan') : 'Data tidak ditemukan',
      );
    }

    if (statusCode == 422) {
      return ValidationException(
        message: (data is Map) ? (data['message'] as String? ?? 'Validasi gagal') : 'Validasi gagal',
        errors: (data is Map) ? data['errors'] as Map<String, dynamic>? : null,
      );
    }

    if (statusCode != null && statusCode >= 500) {
      return const ServerException();
    }

    final message = (data is Map) ? (data['message'] as String? ?? 'Terjadi kesalahan') : 'Terjadi kesalahan';
    return ApiException(message: message, statusCode: statusCode);
  }

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await _dio.post(path, data: data);
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> put(
    String path, {
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await _dio.put(path, data: data);
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> delete(String path) async {
    try {
      final response = await _dio.delete(path);
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
}

final apiClientProvider = Provider<ApiClient>((ref) {
  final secureStorage = ref.read(secureStorageProvider);
  return ApiClient(secureStorage);
});
