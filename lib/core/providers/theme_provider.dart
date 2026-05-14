import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'shared_preferences_provider.dart';

const String _kDarkModeKey = 'is_dark_mode';

/// 全局主题模式 Provider（持久化到 SharedPreferences）
final themeModeProvider =
    AsyncNotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);

class ThemeModeNotifier extends AsyncNotifier<ThemeMode> {
  late SharedPreferences _prefs;

  @override
  Future<ThemeMode> build() async {
    _prefs = await ref.watch(sharedPreferencesProvider.future);
    final isDark = _prefs.getBool(_kDarkModeKey) ?? false;
    return isDark ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> toggle() async {
    final current = state.valueOrNull ?? ThemeMode.light;
    final next =
        current == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await _prefs.setBool(_kDarkModeKey, next == ThemeMode.dark);
    state = AsyncData(next);
  }

  bool get isDark =>
      (state.valueOrNull ?? ThemeMode.light) == ThemeMode.dark;
}

// ─────────────────────────────────────────────
// Light Theme
// ─────────────────────────────────────────────
final lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xff004ac6),
    brightness: Brightness.light,
  ),
  scaffoldBackgroundColor: const Color(0xFFF9F9FB),
  fontFamily: 'Roboto',
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFF7F7F9),
    foregroundColor: Color(0xff1e293b),
    elevation: 0,
  ),
  cardTheme: CardThemeData(
    color: Colors.white,
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFFF3F3F5),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
  ),
);

// ─────────────────────────────────────────────
// Dark Theme
// ─────────────────────────────────────────────
final darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xff004ac6),
    brightness: Brightness.dark,
  ),
  scaffoldBackgroundColor: const Color(0xFF0F0F12),
  fontFamily: 'Roboto',
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1A1A1F),
    foregroundColor: Color(0xFFE2E2E8),
    elevation: 0,
  ),
  cardTheme: CardThemeData(
    color: const Color(0xFF1E1E26),
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF2A2A35),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
  ),
);
