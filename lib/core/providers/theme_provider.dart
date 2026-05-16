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
  fontFamily: 'Inter',
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontFamily: 'Manrope', fontSize: 57, fontWeight: FontWeight.w800, color: Color(0xFF0F0F0F)),
    displayMedium: TextStyle(fontFamily: 'Manrope', fontSize: 45, fontWeight: FontWeight.w800, color: Color(0xFF0F0F0F)),
    displaySmall: TextStyle(fontFamily: 'Manrope', fontSize: 36, fontWeight: FontWeight.w700, color: Color(0xFF0F0F0F)),
    headlineLarge: TextStyle(fontFamily: 'Manrope', fontSize: 32, fontWeight: FontWeight.w700, color: Color(0xFF0F0F0F)),
    headlineMedium: TextStyle(fontFamily: 'Manrope', fontSize: 28, fontWeight: FontWeight.w700, color: Color(0xFF0F0F0F)),
    headlineSmall: TextStyle(fontFamily: 'Manrope', fontSize: 24, fontWeight: FontWeight.w600, color: Color(0xFF0F0F0F)),
    titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Color(0xFF0F0F0F)),
    titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF0F0F0F)),
    titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF0F0F0F)),
    bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF0F0F0F)),
    bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF1A1A1A)),
    bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF333333)),
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF0F0F0F)),
    labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A)),
    labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF333333)),
  ),
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
  fontFamily: 'Inter',
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontFamily: 'Manrope', fontSize: 57, fontWeight: FontWeight.w800, color: Color(0xFFF0F0F0)),
    displayMedium: TextStyle(fontFamily: 'Manrope', fontSize: 45, fontWeight: FontWeight.w800, color: Color(0xFFF0F0F0)),
    displaySmall: TextStyle(fontFamily: 'Manrope', fontSize: 36, fontWeight: FontWeight.w700, color: Color(0xFFF0F0F0)),
    headlineLarge: TextStyle(fontFamily: 'Manrope', fontSize: 32, fontWeight: FontWeight.w700, color: Color(0xFFF0F0F0)),
    headlineMedium: TextStyle(fontFamily: 'Manrope', fontSize: 28, fontWeight: FontWeight.w700, color: Color(0xFFF0F0F0)),
    headlineSmall: TextStyle(fontFamily: 'Manrope', fontSize: 24, fontWeight: FontWeight.w600, color: Color(0xFFF0F0F0)),
    titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Color(0xFFF0F0F0)),
    titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFFF0F0F0)),
    titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFFF0F0F0)),
    bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFFE0E0E0)),
    bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFFE0E0E0)),
    bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFFB0B0B0)),
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFFF0F0F0)),
    labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFFE0E0E0)),
    labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFFB0B0B0)),
  ),
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
