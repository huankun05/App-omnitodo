import 'dart:convert';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/api_constants.dart';
import '../../core/providers/shared_preferences_provider.dart';
import '../../core/network/network_manager.dart';

const String _kPendingEventsKey = 'local_telemetry_events';
const int _kBatchSize = 20; // 每次最多上报条数
const Duration _kSyncInterval = Duration(seconds: 30);

final telemetryManagerProvider =
    FutureProvider<TelemetryManager>((ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  final dio = await ref.watch(dioProvider.future);
  return TelemetryManager(prefs, dio);
});

class TelemetryManager {
  final SharedPreferences _prefs;
  final Dio _dio;
  Timer? _syncTimer;

  TelemetryManager(this._prefs, this._dio) {
    _startSyncTimer();
  }

  // ─── 公共 API ──────────────────────────────────────────────

  /// 记录一个遥测事件（先存本地，定时批量上报）
  Future<void> track(String eventType, Map<String, dynamic> payload) async {
    final event = {
      'event_type': eventType,
      'payload': payload,
      'created_at': DateTime.now().toIso8601String(),
    };
    _saveEventLocally(event);
  }

  /// 立即触发一次同步（如应用切到后台时调用）
  Future<void> flush() async {
    await _syncEvents();
  }

  int get pendingCount {
    final events = _loadLocalEvents();
    return events.length;
  }

  void dispose() {
    _syncTimer?.cancel();
  }

  // ─── 定时器 ────────────────────────────────────────────────

  void _startSyncTimer() {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(_kSyncInterval, (_) async {
      await _syncEvents();
    });
  }

  // ─── 本地存储 ──────────────────────────────────────────────

  void _saveEventLocally(Map<String, dynamic> event) {
    final events = _loadLocalEvents();
    events.add(event);
    _prefs.setString(_kPendingEventsKey, jsonEncode(events));
  }

  List<Map<String, dynamic>> _loadLocalEvents() {
    final raw = _prefs.getString(_kPendingEventsKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      return List<Map<String, dynamic>>.from(
        (jsonDecode(raw) as List)
            .map((e) => Map<String, dynamic>.from(e as Map)),
      );
    } catch (_) {
      return [];
    }
  }

  void _clearLocalEvents(int count) {
    final events = _loadLocalEvents();
    if (count >= events.length) {
      _prefs.remove(_kPendingEventsKey);
    } else {
      final remaining = events.sublist(count);
      _prefs.setString(_kPendingEventsKey, jsonEncode(remaining));
    }
  }

  // ─── 网络同步 ──────────────────────────────────────────────

  Future<void> _syncEvents() async {
    // 未登录则跳过
    final token = _prefs.getString(ApiConstants.tokenKey);
    if (token == null || token.isEmpty) return;

    final events = _loadLocalEvents();
    if (events.isEmpty) return;

    // 分批上报
    final batch = events.take(_kBatchSize).toList();
    try {
      await _dio.post(
        '/telemetry/batch',
        data: {'events': batch},
      );
      _clearLocalEvents(batch.length);
    } on DioException catch (e) {
      // 4xx 错误（如 token 过期）：清空本地，避免无限积压
      if (e.response != null &&
          e.response!.statusCode != null &&
          e.response!.statusCode! >= 400 &&
          e.response!.statusCode! < 500) {
        _clearLocalEvents(batch.length);
      }
      // 5xx / 网络错误：保留事件，下次再试
    } catch (_) {
      // 其他错误保留
    }
  }
}
