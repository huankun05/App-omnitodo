import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/api_constants.dart';
import '../providers/shared_preferences_provider.dart';
import 'auth_interceptor.dart';
import 'response_interceptor.dart';

final dioProvider = FutureProvider<Dio>((ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);

  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl + ApiConstants.apiVersion,
      connectTimeout: ApiConstants.connectTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  dio.interceptors.add(AuthInterceptor(prefs));
  dio.interceptors.add(
    ResponseInterceptor(
      prefs,
      onUnauthorized: () {},
    ),
  );

  return dio;
});
