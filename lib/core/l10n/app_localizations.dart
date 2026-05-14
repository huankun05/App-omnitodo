import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/shared_preferences_provider.dart';

final localeProvider =
    AsyncNotifierProvider<LocaleNotifier, Locale>(LocaleNotifier.new);

class LocaleNotifier extends AsyncNotifier<Locale> {
  static const String _languageCodeKey = 'languageCode';

  @override
  Future<Locale> build() async {
    final prefs = await ref.watch(sharedPreferencesProvider.future);
    final languageCode = prefs.getString(_languageCodeKey);
    if (languageCode != null) {
      return Locale(languageCode);
    }
    return const Locale('en');
  }

  Future<void> setLocale(Locale locale) async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    await prefs.setString(_languageCodeKey, locale.languageCode);
    state = AsyncData(locale);
  }
}

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'settings': 'Settings',
      'general': 'General',
      'notifications': 'Notifications',
      'notificationsDesc': 'Receive task reminders and updates',
      'darkMode': 'Dark Mode',
      'darkModeDesc': 'Enable dark theme',
      'soundEffects': 'Sound Effects',
      'soundEffectsDesc': 'Play sounds for task completion',
      'language': 'Language',
      'languageDesc': 'Select app language',
      'focusSession': 'Focus Session',
      'focusDuration': 'Focus Duration',
      'breakDuration': 'Break Duration',
      'minutes': 'minutes',
      'account': 'Account',
      'profile': 'Profile',
      'profileDesc': 'View and edit your profile',
      'logout': 'Logout',
      'logoutDesc': 'Sign out of your account',
      'focus': 'Focus',
      'stayPresent': 'Stay present.',
      'deepFocusMode': 'Deep Focus Mode',
      'minutesRemaining': 'Minutes Remaining',
      'readyToStart': 'Ready to Start',
      'startSession': 'Start Session',
      'pause': 'Pause',
      'resume': 'Resume',
      'currentTask': 'Current Task',
      'appName': 'OmniTodo',
      'ok': 'OK',
      'forgotPassword': 'Forgot Password?',
      'forgotPasswordDesc': 'Enter your email address to reset your password.',
      'emailHint': 'Enter your email',
      'cancel': 'Cancel',
      'resetPassword': 'Reset Password',
      'resetLinkSent': 'Password reset link sent to your email',
      'welcomeBack': 'Welcome back to your curated space.',
      'emailAddress': 'Email Address',
      'password': 'Password',
      'passwordHint': 'Enter your password',
      'rememberMe': 'Remember me',
      'signIn': 'Sign In',
      'dontHaveAccount': 'Don\'t have an account?',
      'createAccount': 'Create an Account',
      'fullName': 'Full Name',
      'nameHint': 'Enter your full name',
      'confirmPassword': 'Confirm Password',
      'alreadyHaveAccount': 'Already have an account?',
      'signInLink': 'Sign In',
    },
    'zh': {
      'settings': '设置',
      'general': '通用',
      'notifications': '通知',
      'notificationsDesc': '接收任务提醒和更新',
      'darkMode': '深色模式',
      'darkModeDesc': '开启深色主题',
      'soundEffects': '音效',
      'soundEffectsDesc': '完成任务时播放音效',
      'language': '语言',
      'languageDesc': '选择应用语言',
      'focusSession': '专注设置',
      'focusDuration': '专注时长',
      'breakDuration': '休息时长',
      'minutes': '分钟',
      'account': '账号',
      'profile': '个人资料',
      'profileDesc': '查看和编辑个人资料',
      'logout': '退出登录',
      'logoutDesc': '退出当前账号',
      'focus': '专注',
      'stayPresent': '保持当下。',
      'deepFocusMode': '深度专注模式',
      'minutesRemaining': '分钟剩余',
      'readyToStart': '准备开始',
      'startSession': '开始专注',
      'pause': '暂停',
      'resume': '恢复',
      'currentTask': '当前任务',
      'appName': 'OmniTodo',
      'ok': '确定',
      'forgotPassword': '忘记密码？',
      'forgotPasswordDesc': '输入您的电子邮箱以重置密码。',
      'emailHint': '请输入电子邮箱',
      'cancel': '取消',
      'resetPassword': '重置密码',
      'resetLinkSent': '密码重置链接已发送到您的邮箱',
      'welcomeBack': '欢迎回来',
      'emailAddress': '电子邮箱',
      'password': '密码',
      'passwordHint': '请输入密码',
      'rememberMe': '记住我',
      'signIn': '登录',
      'dontHaveAccount': '还没有账号？',
      'createAccount': '创建账号',
      'fullName': '姓名',
      'nameHint': '请输入您的姓名',
      'confirmPassword': '确认密码',
      'alreadyHaveAccount': '已有账号？',
      'signInLink': '立即登录',
    },
  };

  String get settings => _localizedValues[locale.languageCode]?['settings'] ?? 'Settings';
  String get general => _localizedValues[locale.languageCode]?['general'] ?? 'General';
  String get notifications => _localizedValues[locale.languageCode]?['notifications'] ?? 'Notifications';
  String get notificationsDesc => _localizedValues[locale.languageCode]?['notificationsDesc'] ?? 'Receive task reminders and updates';
  String get darkMode => _localizedValues[locale.languageCode]?['darkMode'] ?? 'Dark Mode';
  String get darkModeDesc => _localizedValues[locale.languageCode]?['darkModeDesc'] ?? 'Enable dark theme';
  String get soundEffects => _localizedValues[locale.languageCode]?['soundEffects'] ?? 'Sound Effects';
  String get soundEffectsDesc => _localizedValues[locale.languageCode]?['soundEffectsDesc'] ?? 'Play sounds for task completion';
  String get language => _localizedValues[locale.languageCode]?['language'] ?? 'Language';
  String get languageDesc => _localizedValues[locale.languageCode]?['languageDesc'] ?? 'Select app language';
  String get focusSession => _localizedValues[locale.languageCode]?['focusSession'] ?? 'Focus Session';
  String get focusDuration => _localizedValues[locale.languageCode]?['focusDuration'] ?? 'Focus Duration';
  String get breakDuration => _localizedValues[locale.languageCode]?['breakDuration'] ?? 'Break Duration';
  String get minutes => _localizedValues[locale.languageCode]?['minutes'] ?? 'minutes';
  String get account => _localizedValues[locale.languageCode]?['account'] ?? 'Account';
  String get profile => _localizedValues[locale.languageCode]?['profile'] ?? 'Profile';
  String get profileDesc => _localizedValues[locale.languageCode]?['profileDesc'] ?? 'View and edit your profile';
  String get logout => _localizedValues[locale.languageCode]?['logout'] ?? 'Logout';
  String get logoutDesc => _localizedValues[locale.languageCode]?['logoutDesc'] ?? 'Sign out of your account';
  String get focus => _localizedValues[locale.languageCode]?['focus'] ?? 'Focus';
  String get stayPresent => _localizedValues[locale.languageCode]?['stayPresent'] ?? 'Stay present.';
  String get deepFocusMode => _localizedValues[locale.languageCode]?['deepFocusMode'] ?? 'Deep Focus Mode';
  String get minutesRemaining => _localizedValues[locale.languageCode]?['minutesRemaining'] ?? 'Minutes Remaining';
  String get readyToStart => _localizedValues[locale.languageCode]?['readyToStart'] ?? 'Ready to Start';
  String get startSession => _localizedValues[locale.languageCode]?['startSession'] ?? 'Start Session';
  String get pause => _localizedValues[locale.languageCode]?['pause'] ?? 'Pause';
  String get resume => _localizedValues[locale.languageCode]?['resume'] ?? 'Resume';
  String get currentTask => _localizedValues[locale.languageCode]?['currentTask'] ?? 'Current Task';
  String get appName => _localizedValues[locale.languageCode]?['appName'] ?? 'OmniTodo';
  String get ok => _localizedValues[locale.languageCode]?['ok'] ?? 'OK';
  String get forgotPassword => _localizedValues[locale.languageCode]?['forgotPassword'] ?? 'Forgot Password?';
  String get forgotPasswordDesc => _localizedValues[locale.languageCode]?['forgotPasswordDesc'] ?? 'Enter your email address to reset your password.';
  String get emailHint => _localizedValues[locale.languageCode]?['emailHint'] ?? 'Enter your email';
  String get cancel => _localizedValues[locale.languageCode]?['cancel'] ?? 'Cancel';
  String get resetPassword => _localizedValues[locale.languageCode]?['resetPassword'] ?? 'Reset Password';
  String get resetLinkSent => _localizedValues[locale.languageCode]?['resetLinkSent'] ?? 'Password reset link sent to your email';
  String get welcomeBack => _localizedValues[locale.languageCode]?['welcomeBack'] ?? 'Welcome back';
  String get emailAddress => _localizedValues[locale.languageCode]?['emailAddress'] ?? 'Email Address';
  String get password => _localizedValues[locale.languageCode]?['password'] ?? 'Password';
  String get passwordHint => _localizedValues[locale.languageCode]?['passwordHint'] ?? 'Enter your password';
  String get rememberMe => _localizedValues[locale.languageCode]?['rememberMe'] ?? 'Remember me';
  String get signIn => _localizedValues[locale.languageCode]?['signIn'] ?? 'Sign In';
  String get dontHaveAccount => _localizedValues[locale.languageCode]?['dontHaveAccount'] ?? 'Don\'t have an account?';
  String get createAccount => _localizedValues[locale.languageCode]?['createAccount'] ?? 'Create Account';
  String get fullName => _localizedValues[locale.languageCode]?['fullName'] ?? 'Full Name';
  String get nameHint => _localizedValues[locale.languageCode]?['nameHint'] ?? 'Enter your full name';
  String get confirmPassword => _localizedValues[locale.languageCode]?['confirmPassword'] ?? 'Confirm Password';
  String get alreadyHaveAccount => _localizedValues[locale.languageCode]?['alreadyHaveAccount'] ?? 'Already have an account?';
  String get signInLink => _localizedValues[locale.languageCode]?['signInLink'] ?? 'Sign In';
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'zh'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}