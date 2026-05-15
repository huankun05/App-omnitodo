import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';
import 'package:bot_toast/bot_toast.dart';
import 'core/router.dart';
import 'core/providers/shared_preferences_provider.dart';
import 'core/providers/theme_provider.dart';
import 'core/l10n/app_localizations.dart';
import 'data/providers/tag_provider.dart';

// 条件导入 sqflite_ffi（仅非 Web 平台）
import 'core/database/database_helper.dart' as db_helper;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 加载环境变量
  await dotenv.load();
  
  // 初始化数据库（平台适配：Web 使用空实现）
  await db_helper.DatabaseHelper.ensureInitialized();
  
  final sharedPreferences = await SharedPreferences.getInstance();
  
  // 配置崩溃日志自动上报
  FlutterError.onError = (FlutterErrorDetails details) {
    _reportError(details.exception, details.stack ?? StackTrace.current);
  };
  
  // 配置平台级错误处理
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    _reportError(error, stack);
    return true;
  };

  final tagProvider = TagProvider();
  await tagProvider.load();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWith((ref) async => sharedPreferences),
        tagProviderProvider.overrideWith((ref) => tagProvider),
      ],
      child: const MyApp(),
    ),
  );
}

void _reportError(Object error, StackTrace stack) {
  if (kDebugMode) {
    debugPrint('App crashed: $error');
    debugPrint('Stack trace: $stack');
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeModeAsync = ref.watch(themeModeProvider);
    final themeMode = themeModeAsync.valueOrNull ?? ThemeMode.light;
    final localeAsync = ref.watch(localeProvider);
    final locale = localeAsync.valueOrNull ?? const Locale('en');

    return MaterialApp.router(
      title: 'OmniTodo',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      routerConfig: router,
      locale: locale,
      supportedLocales: const [
        Locale('en'),
        Locale('zh'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: BotToastInit(), // 初始化 BotToast
    );
  }
}
