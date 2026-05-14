import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/network_manager.dart';
import '../models/config_models.dart';

final configServiceProvider = FutureProvider<ConfigService>((ref) async {
  final dio = await ref.watch(dioProvider.future);
  return ConfigService(dio);
});

class ConfigService {
  final Dio _dio;

  ConfigService(this._dio);

  Future<Map<String, dynamic>> getConfigs() async {
    final response = await _dio.get('/config');
    final data = response.data;

    if (data is Map && data['data'] is Map) {
      return data['data'] as Map<String, dynamic>;
    }

    return {};
  }

  Future<ConfigItem> createConfig(CreateConfigDto configDto) async {
    final response = await _dio.post(
      '/config',
      data: configDto.toJson(),
    );

    return ConfigItem.fromJson(response.data['data']);
  }

  Future<ConfigItem> updateConfig(String id, UpdateConfigDto configDto) async {
    final response = await _dio.put(
      '/config/$id',
      data: configDto.toJson(),
    );

    return ConfigItem.fromJson(response.data['data']);
  }

  Future<void> deleteConfig(String id) async {
    await _dio.delete('/config/$id');
  }
}
