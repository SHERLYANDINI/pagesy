import 'package:dio/dio.dart';

class AppException implements Exception {
  final String message;
  const AppException(this.message);

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  const NetworkException([super.message = 'Tidak dapat terhubung ke server']);
}

class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message = 'Sesi berakhir, silakan login lagi']);
}

class ValidationException extends AppException {
  final Map<String, List<String>> errors;
  const ValidationException(super.message, this.errors);
}

class ServerException extends AppException {
  const ServerException([super.message = 'Terjadi kesalahan pada server']);
}

/// Ubah DioException (termasuk format error Laravel) jadi AppException.
AppException mapDioError(DioException e) {
  const networkTypes = [
    DioExceptionType.connectionTimeout,
    DioExceptionType.sendTimeout,
    DioExceptionType.receiveTimeout,
    DioExceptionType.connectionError,
  ];
  if (networkTypes.contains(e.type)) return const NetworkException();

  final status = e.response?.statusCode;
  final data = e.response?.data;
  final message = (data is Map && data['message'] is String)
      ? data['message'] as String
      : null;

  if (status == 401) {
    return message != null ? UnauthorizedException(message) : const UnauthorizedException();
  }

  if (status == 422 && data is Map) {
    final errors = <String, List<String>>{};
    final raw = data['errors'];
    if (raw is Map) {
      raw.forEach((key, value) {
        errors[key.toString()] = List<String>.from(value as List);
      });
    }
    return ValidationException(message ?? 'Data tidak valid', errors);
  }

  return message != null ? ServerException(message) : const ServerException();
}
