class AppException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic originalError;

  AppException(this.message, {this.statusCode, this.originalError});

  @override
  String toString() => 'AppException: $message (status: $statusCode)';
}

class UnauthorizedException extends AppException {
  UnauthorizedException({String message = 'Unauthorized'})
      : super(message, statusCode: 401);
}

class NetworkException extends AppException {
  NetworkException({String message = 'Network error occurred'})
      : super(message, statusCode: null);
}

class ServerException extends AppException {
  ServerException({String message = 'Server error occurred', int? statusCode})
      : super(message, statusCode: statusCode);
}
