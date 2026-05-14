import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/api_constants.dart';
import '../core/database/database_helper.dart';
import '../data/services/config_service.dart';
import '../data/services/telemetry_manager.dart';
import '../data/providers/task_provider.dart';
import './providers/shared_preferences_provider.dart';

final isLoggedInProvider = FutureProvider<bool>((ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  final token = prefs.getString(ApiConstants.tokenKey);
  return token != null && token.isNotEmpty;
});

final configProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final configService = await ref.watch(configServiceProvider.future);
  try {
    return await configService.getConfigs();
  } catch (e) {
    return {};
  }
});

final appBootstrapProvider = FutureProvider<void>((ref) async {
  // 1. 初始化 SharedPreferences
  await ref.watch(sharedPreferencesProvider.future);

  // 2. 初始化本地数据库
  await DatabaseHelper.instance.database;

  // 3. 检查用户登录状态
  await ref.watch(isLoggedInProvider.future);

  // 4. 获取 RemoteConfig（失败不阻断启动）
  try {
    await ref.watch(configProvider.future);
  } catch (_) {}

  // 5. 启动 TelemetryManager（自动开启定时上报）
  try {
    await ref.watch(telemetryManagerProvider.future);
  } catch (_) {}

  // 6. 尝试同步 pending 离线操作（网络恢复场景）
  try {
    final service = await ref.watch(taskServiceProvider.future);
    final pendingCount = await DatabaseHelper.instance.getPendingSyncCount();
    if (pendingCount > 0) {
      await service.syncPendingOperations();
    }
  } catch (_) {}
});
