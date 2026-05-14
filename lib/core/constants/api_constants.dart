import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static String get baseUrl => dotenv.env['API_BASE_URL'] ?? 'http://localhost:3000';
  static String get apiVersion => dotenv.env['API_VERSION'] ?? '/api/v1';

  static Duration get connectTimeout => Duration(seconds: int.parse(dotenv.env['CONNECT_TIMEOUT'] ?? '30'));
  static Duration get receiveTimeout => Duration(seconds: int.parse(dotenv.env['RECEIVE_TIMEOUT'] ?? '30'));

  static const String appKeyHeader = 'X-App-Key';
  static const String authorizationHeader = 'Authorization';
  static const String bearerPrefix = 'Bearer';

  static const String tokenKey = 'jwt_token';
  static String get appKeyKey => dotenv.env['APP_KEY'] ?? 'omni_client_app_key';
}
