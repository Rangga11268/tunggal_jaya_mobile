class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, dynamic>? errors;

  const ApiException({
    required this.message,
    this.statusCode,
    this.errors,
  });

  @override
  String toString() => message;
}

class UnauthorizedException extends ApiException {
  const UnauthorizedException({super.message = 'Sesi habis, silakan login ulang', super.statusCode = 401});
}

class ValidationException extends ApiException {
  const ValidationException({
    super.message = 'Validasi gagal',
    super.statusCode = 422,
    super.errors,
  });
}

class ServerException extends ApiException {
  const ServerException({super.message = 'Terjadi kesalahan server', super.statusCode = 500});
}

class NetworkException extends ApiException {
  const NetworkException({super.message = 'Tidak ada koneksi internet'});
}

class TimeoutException extends ApiException {
  const TimeoutException({super.message = 'Koneksi timeout, silakan coba lagi'});
}

class NotFoundException extends ApiException {
  const NotFoundException({super.message = 'Data tidak ditemukan', super.statusCode = 404});
}
