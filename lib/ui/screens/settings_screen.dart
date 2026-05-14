import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/app_widgets.dart';
import '../widgets/responsive_navigation.dart';
import '../../core/providers/theme_provider.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/l10n/app_localizations.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 768;

    final themeMode = ref.watch(themeModeProvider).valueOrNull ?? ThemeMode.light;
    final isDark = themeMode == ThemeMode.dark;
    final settingsAsync = ref.watch(settingsProvider);
    final localeAsync = ref.watch(localeProvider);
    final l10n = AppLocalizations.of(context) ?? AppLocalizations(const Locale('en'));

    final settings = settingsAsync.valueOrNull ?? const AppSettings();
    final locale = localeAsync.valueOrNull ?? const Locale('en');

    return ResponsiveNavigation(
      currentPage: 'settings',
      child: AppBackground(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 64 : 24,
            vertical: 32,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.settings,
                  style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 40),
                _buildSettingsSection(
                  title: l10n.general,
                  children: [
                    _buildSettingItem(
                      icon: Icons.notifications_outlined,
                      title: l10n.notifications,
                      subtitle: l10n.notificationsDesc,
                      trailing: Switch(
                        value: settings.notificationsEnabled,
                        onChanged: (value) {
                          ref.read(settingsProvider.notifier).updateNotifications(value);
                        },
                        activeThumbColor: AppColors.primary,
                      ),
                    ),
                    _buildSettingItem(
                      icon: Icons.dark_mode_outlined,
                      title: l10n.darkMode,
                      subtitle: l10n.darkModeDesc,
                      trailing: Switch(
                        value: isDark,
                        onChanged: (value) async {
                          await ref.read(themeModeProvider.notifier).toggle();
                        },
                        activeThumbColor: AppColors.primary,
                      ),
                    ),
                    _buildSettingItem(
                      icon: Icons.volume_up_outlined,
                      title: l10n.soundEffects,
                      subtitle: l10n.soundEffectsDesc,
                      trailing: Switch(
                        value: settings.soundEnabled,
                        onChanged: (value) {
                          ref.read(settingsProvider.notifier).updateSound(value);
                        },
                        activeThumbColor: AppColors.primary,
                      ),
                    ),
                    _buildSettingItem(
                      icon: Icons.language_outlined,
                      title: l10n.language,
                      subtitle: l10n.languageDesc,
                      trailing: DropdownButton<String>(
                        value: locale.languageCode,
                        underline: const SizedBox(),
                        items: const [
                          DropdownMenuItem(value: 'en', child: Text('English')),
                          DropdownMenuItem(value: 'zh', child: Text('中文')),
                        ],
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            ref.read(localeProvider.notifier).setLocale(Locale(newValue));
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                _buildSettingsSection(
                  title: l10n.focusSession,
                  children: [
                    _buildSliderSetting(
                      icon: Icons.timer_outlined,
                      title: l10n.focusDuration,
                      subtitle: '${settings.focusDuration.round()} ${l10n.minutes}',
                      value: settings.focusDuration,
                      min: 5,
                      max: 60,
                      onChanged: (value) {
                        ref.read(settingsProvider.notifier).updateFocusDuration(value);
                      },
                    ),
                    _buildSliderSetting(
                      icon: Icons.coffee_outlined,
                      title: l10n.breakDuration,
                      subtitle: '${settings.breakDuration.round()} ${l10n.minutes}',
                      value: settings.breakDuration,
                      min: 1,
                      max: 30,
                      onChanged: (value) {
                        ref.read(settingsProvider.notifier).updateBreakDuration(value);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                _buildSettingsSection(
                  title: l10n.account,
                  children: [
                    _buildSettingItem(
                      icon: Icons.person_outline,
                      title: l10n.profile,
                      subtitle: l10n.profileDesc,
                      onTap: () {},
                    ),
                    _buildSettingItem(
                      icon: Icons.logout_outlined,
                      title: l10n.logout,
                      subtitle: l10n.logoutDesc,
                      onTap: () {
                        context.go('/login');
                      },
                      isDanger: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppBorderRadius.defaultRadius),
        boxShadow: AppShadows.cardShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Manrope',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 24),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    bool isDanger = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDanger
                    ? AppColors.error.withValues(alpha: 0.1)
                    : AppColors.primaryContainer.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isDanger ? AppColors.error : AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDanger ? AppColors.error : AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null)
              trailing
            else if (onTap != null)
              Icon(
                Icons.chevron_right,
                color: isDanger ? AppColors.error : AppColors.onSurfaceVariant,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliderSetting({
    required IconData icon,
    required String title,
    required String subtitle,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: (max - min).toInt(),
            activeColor: AppColors.primary,
            inactiveColor: AppColors.outline.withValues(alpha: 0.5),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
