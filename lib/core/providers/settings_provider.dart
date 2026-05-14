import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'shared_preferences_provider.dart';

class AppSettings {
  final bool notificationsEnabled;
  final bool soundEnabled;
  final double focusDuration;
  final double breakDuration;

  const AppSettings({
    this.notificationsEnabled = true,
    this.soundEnabled = true,
    this.focusDuration = 25,
    this.breakDuration = 5,
  });

  AppSettings copyWith({
    bool? notificationsEnabled,
    bool? soundEnabled,
    double? focusDuration,
    double? breakDuration,
  }) {
    return AppSettings(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      focusDuration: focusDuration ?? this.focusDuration,
      breakDuration: breakDuration ?? this.breakDuration,
    );
  }
}

final settingsProvider =
    AsyncNotifierProvider<SettingsNotifier, AppSettings>(SettingsNotifier.new);

class SettingsNotifier extends AsyncNotifier<AppSettings> {
  static const String _notificationsKey = 'notificationsEnabled';
  static const String _soundKey = 'soundEnabled';
  static const String _focusDurationKey = 'focusDuration';
  static const String _breakDurationKey = 'breakDuration';

  @override
  Future<AppSettings> build() async {
    final prefs = await ref.watch(sharedPreferencesProvider.future);
    return AppSettings(
      notificationsEnabled: prefs.getBool(_notificationsKey) ?? true,
      soundEnabled: prefs.getBool(_soundKey) ?? true,
      focusDuration: prefs.getDouble(_focusDurationKey) ?? 25.0,
      breakDuration: prefs.getDouble(_breakDurationKey) ?? 5.0,
    );
  }

  Future<void> updateNotifications(bool value) async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    await prefs.setBool(_notificationsKey, value);
    final current = state.valueOrNull ?? const AppSettings();
    state = AsyncData(current.copyWith(notificationsEnabled: value));
  }

  Future<void> updateSound(bool value) async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    await prefs.setBool(_soundKey, value);
    final current = state.valueOrNull ?? const AppSettings();
    state = AsyncData(current.copyWith(soundEnabled: value));
  }

  Future<void> updateFocusDuration(double value) async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    await prefs.setDouble(_focusDurationKey, value);
    final current = state.valueOrNull ?? const AppSettings();
    state = AsyncData(current.copyWith(focusDuration: value));
  }

  Future<void> updateBreakDuration(double value) async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    await prefs.setDouble(_breakDurationKey, value);
    final current = state.valueOrNull ?? const AppSettings();
    state = AsyncData(current.copyWith(breakDuration: value));
  }
}