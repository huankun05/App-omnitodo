import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import '../constants/api_constants.dart';
import '../exceptions.dart';

typedef OnUnauthorized = void Function();

class ResponseInterceptor extends Interceptor {
  final SharedPreferences prefs;
  final OnUnauthorized? onUnauthorized;

  ResponseInterceptor(this.prefs, {this.onUnauthorized});

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      prefs.remove(ApiConstants.tokenKey);
      onUnauthorized?.call();
      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          response: err.response,
          type: DioExceptionType.badResponse,
          error: UnauthorizedException(),
        ),
      );
      return;
    }

    final statusCode = err.response?.statusCode;
    final message = _extractErrorMessage(err);

    // 显示错误信息
    BotToast.showText(
      text: message,
      duration: Duration(seconds: 3),
      contentColor: Color(0xFFD32F2F),
      textStyle: TextStyle(color: Color(0xFFFFFFFF)),
    );

    AppException exception;
    if (statusCode != null && statusCode >= 500) {
      exception = ServerException(message: message, statusCode: statusCode);
    } else {
      exception = NetworkException(message: message);
    }

    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: DioExceptionType.badResponse,
        error: exception,
      ),
    );
  }

  String _extractErrorMessage(DioException err) {
    if (err.response?.data is Map) {
      final data = err.response!.data as Map;
      return data['message'] ?? data['error'] ?? 'Unknown error';
    }
    if (err.type == DioExceptionType.connectionTimeout) {
      return '网络连接超时，请检查网络';
    }
    if (err.type == DioExceptionType.receiveTimeout) {
      return '服务器响应超时';
    }
    if (err.type == DioExceptionType.connectionError) {
      return '网络连接错误，请检查网络';
    }
    return '请求失败，请稍后重试';
  }
}
