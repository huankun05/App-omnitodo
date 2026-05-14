import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_constants.dart';

class AuthInterceptor extends Interceptor {
  final SharedPreferences prefs;

  AuthInterceptor(this.prefs);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final appKey = prefs.getString(ApiConstants.appKeyKey);
    if (appKey != null && appKey.isNotEmpty) {
      options.headers[ApiConstants.appKeyHeader] = appKey;
    }

    final token = prefs.getString(ApiConstants.tokenKey);
    if (token != null && token.isNotEmpty) {
      options.headers[ApiConstants.authorizationHeader] =
          '${ApiConstants.bearerPrefix} $token';
    }

    handler.next(options);
  }
}
