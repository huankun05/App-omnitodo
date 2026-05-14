import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/api_constants.dart';
import '../../core/network/network_manager.dart';
import '../../core/providers/shared_preferences_provider.dart';
import '../models/auth_models.dart';

final authServiceProvider = FutureProvider<AuthService>((ref) async {
  final dio = await ref.watch(dioProvider.future);
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return AuthService(dio, prefs);
});

class AuthService {
  final Dio _dio;
  final SharedPreferences _prefs;

  AuthService(this._dio, this._prefs);

  Future<AuthResponse> login(LoginDto loginDto) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: loginDto.toJson(),
      );

      final data = response.data;
      if (data == null) {
        throw Exception('LOGIN_FAILED: server returned empty data');
      }

      if (data['token'] == null && data['access_token'] == null) {
        throw Exception('LOGIN_FAILED: missing auth token');
      }

      if (data['access_token'] != null && data['access_token'] is String) {
        await _prefs.setString(ApiConstants.tokenKey, data['access_token']);
        return AuthResponse(
          token: data['access_token'],
          userId: data['userId'] ?? '',
          email: data['email'] ?? loginDto.email,
          name: data['name'] ?? '',
        );
      } else if (data['token'] != null && data['token'] is String) {
        await _prefs.setString(ApiConstants.tokenKey, data['token']);
        return AuthResponse(
          token: data['token'],
          userId: data['userId'] ?? '',
          email: data['email'] ?? loginDto.email,
          name: data['name'] ?? '',
        );
      } else {
        throw Exception('LOGIN_FAILED: missing auth token');
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response?.statusCode ?? 0;
          final respData = e.response?.data;
          // 尝试解析结构化错误 { code, message }
          final serverMsg = (respData is Map ? respData['message'] : null);
          String? errorCode;
          String? errorText;
          if (serverMsg is Map) {
            errorCode = serverMsg['code'] as String?;
            errorText = serverMsg['message'] as String?;
          } else if (serverMsg is String) {
            errorText = serverMsg;
          }

          if (statusCode == 401) {
            if (errorCode == 'USER_NOT_FOUND') {
              throw Exception('LOGIN_USER_NOT_FOUND');
            } else if (errorCode == 'INVALID_PASSWORD') {
              throw Exception('LOGIN_INVALID_PASSWORD');
            } else {
              throw Exception('LOGIN_INVALID_CREDENTIALS: $errorText');
            }
          } else {
            throw Exception('LOGIN_FAILED: $errorText');
          }
        } else {
          throw Exception('NETWORK_ERROR');
        }
      } else if (e is TypeError) {
        throw Exception('LOGIN_FAILED: server data format error');
      } else if (e is Exception) {
        rethrow;
      } else {
        throw Exception('LOGIN_FAILED: ${e.toString()}');
      }
    }
  }

  Future<AuthResponse> register(RegisterDto registerDto) async {
    try {
      final response = await _dio.post(
        '/auth/register',
        data: registerDto.toJson(),
      );

      final data = response.data;
      
      // 检查响应数据是否有效
      if (data == null) {
        throw Exception('服务器返回数据无效，请稍后再试');
      }
      
      // 确保token存在
      if (data['token'] == null && data['access_token'] == null) {
        throw Exception('服务器返回数据不完整，缺少认证信息');
      }
      
      // 保存访问令牌
      if (data['access_token'] != null && data['access_token'] is String) {
        await _prefs.setString(ApiConstants.tokenKey, data['access_token']);
        // 即使缺少其他字段，也能成功注册
        return AuthResponse(
          token: data['access_token'],
          userId: data['userId'] ?? '',
          email: data['email'] ?? registerDto.email,
          name: data['name'] ?? registerDto.name,
        );
      } else if (data['token'] != null && data['token'] is String) {
        // 兼容不同的token字段名
        await _prefs.setString(ApiConstants.tokenKey, data['token']);
        // 即使缺少其他字段，也能成功注册
        return AuthResponse(
          token: data['token'],
          userId: data['userId'] ?? '',
          email: data['email'] ?? registerDto.email,
          name: data['name'] ?? registerDto.name,
        );
      } else {
        throw Exception('服务器返回数据不完整，缺少认证信息');
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response?.statusCode ?? 0;
          final serverMsg = (e.response?.data is Map
                  ? e.response?.data['message']
                  : null) ??
              '';
          if (statusCode == 409 ||
              serverMsg.toString().toLowerCase().contains('already') ||
              serverMsg.toString().toLowerCase().contains('exists') ||
              serverMsg.toString().toLowerCase().contains('duplicate')) {
            throw Exception('EMAIL_ALREADY_EXISTS');
          } else if (statusCode == 400) {
            throw Exception('INVALID_REGISTER_DATA: $serverMsg');
          } else {
            throw Exception('REGISTER_FAILED: $serverMsg');
          }
        } else {
          throw Exception('NETWORK_ERROR');
        }
      } else if (e is TypeError) {
        throw Exception('REGISTER_FAILED: server data format error');
      } else if (e is Exception) {
        // 已经是我们自己抛出的 Exception，直接 rethrow
        rethrow;
      } else {
        throw Exception('REGISTER_FAILED: ${e.toString()}');
      }
    }
  }

  Future<void> logout() async {
    await _prefs.remove(ApiConstants.tokenKey);
  }

  bool get isLoggedIn => _prefs.getString(ApiConstants.tokenKey) != null;
}
