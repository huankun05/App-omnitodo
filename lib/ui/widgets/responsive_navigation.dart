import 'dart:ui';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/providers/theme_provider.dart';

/// ═══════════════════════════════════════════════════════════════════════════
/// 导航栏配置系统
/// ═══════════════════════════════════════════════════════════════════════════
/// 
/// 配置规则：
/// 1. defaultConfig - 统一默认配置（修改这个会同步修改所有平台）
/// 2. webConfig     - Web端单独配置（覆盖默认）
/// 3. desktopConfig - 桌面端单独配置（覆盖默认）
/// 4. mobileConfig  - 移动端单独配置（覆盖默认）
/// 
/// 您只需要修改上面 4 个配置对象即可！
/// ═══════════════════════════════════════════════════════════════════════════

/// ═══════════════════════════════════════════════════════════════════════════
/// 🎯 统一默认配置 - 修改这里会同步影响所有平台
/// ═══════════════════════════════════════════════════════════════════════════
const GlassConfig defaultConfig = GlassConfig(
  blur: 12,                          // 模糊程度（更细腻的磨砂感）
  opacityLight: 0.06,               // 亮色模式背景透明度：非常通透
  opacityDark: 0.05,                // 暗黑模式背景透明度
  shadowOpacity: 0.04,              // 阴影透明度
  shadowBlurRadius: 16,             // 阴影模糊半径
  shadowOffsetY: 2,                 // 阴影垂直偏移
  borderOpacityLight: 0.04,         // 亮色模式边框透明度
  borderOpacityDark: 0.05,          // 暗黑模式边框透明度
  borderWidth: 0.5,                 // 边框宽度
  innerGlowOpacityLight: 0.06,      // 亮色模式内发光透明度
  innerGlowOpacityDark: 0.04,       // 暗黑模式内发光透明度
  innerGlowBlurRadius: 8,           // 内发光模糊半径
);

/// ═══════════════════════════════════════════════════════════════════════════
/// 🌐 Web端单独配置 - 修改这里只影响 Web 端（平板模式）
/// ═══════════════════════════════════════════════════════════════════════════
const GlassConfig webConfig = GlassConfig(
  blur: 12,
  opacityLight: 0.06,
  opacityDark: 0.05,
);

/// ═══════════════════════════════════════════════════════════════════════════
/// 🖥️ 桌面端单独配置 - 修改这里只影响桌面端
/// ═══════════════════════════════════════════════════════════════════════════
const GlassConfig desktopConfig = GlassConfig(
  blur: 12,
  opacityLight: 0.06,
  opacityDark: 0.05,
);

/// ═══════════════════════════════════════════════════════════════════════════
/// 📱 移动端单独配置 - 修改这里只影响移动端
/// ═══════════════════════════════════════════════════════════════════════════
const GlassConfig mobileConfig = GlassConfig(
  blur: 14,
  opacityLight: 0.08,
  opacityDark: 0.07,
);

/// ═══════════════════════════════════════════════════════════════════════════
/// 毛玻璃配置类
/// ═══════════════════════════════════════════════════════════════════════════
class GlassConfig {
  final double blur;
  final double opacityLight;
  final double opacityDark;
  final double shadowOpacity;
  final double shadowBlurRadius;
  final double shadowOffsetY;
  final double borderOpacityLight;
  final double borderOpacityDark;
  final double borderWidth;
  final double innerGlowOpacityLight;
  final double innerGlowOpacityDark;
  final double innerGlowBlurRadius;

  const GlassConfig({
    required this.blur,
    required this.opacityLight,
    required this.opacityDark,
    this.shadowOpacity = 0.06,
    this.shadowBlurRadius = 20,
    this.shadowOffsetY = 4,
    this.borderOpacityLight = 0.04,
    this.borderOpacityDark = 0.08,
    this.borderWidth = 0.5,
    this.innerGlowOpacityLight = 0.06,
    this.innerGlowOpacityDark = 0.03,
    this.innerGlowBlurRadius = 8,
  });

  /// 合并两个配置 - 以另一个配置优先
  GlassConfig merge(GlassConfig? other) {
    if (other == null) return this;
    return GlassConfig(
      blur: other.blur,
      opacityLight: other.opacityLight,
      opacityDark: other.opacityDark,
      shadowOpacity: other.shadowOpacity,
      shadowBlurRadius: other.shadowBlurRadius,
      shadowOffsetY: other.shadowOffsetY,
      borderOpacityLight: other.borderOpacityLight,
      borderOpacityDark: other.borderOpacityDark,
      borderWidth: other.borderWidth,
      innerGlowOpacityLight: other.innerGlowOpacityLight,
      innerGlowOpacityDark: other.innerGlowOpacityDark,
      innerGlowBlurRadius: other.innerGlowBlurRadius,
    );
  }
}

/// ═══════════════════════════════════════════════════════════════════════════
/// 根据设备类型获取配置
/// ═══════════════════════════════════════════════════════════════════════════
GlassConfig getConfigForDevice(DeviceType deviceType) {
  switch (deviceType) {
    case DeviceType.tablet:
      return defaultConfig.merge(webConfig);
    case DeviceType.desktop:
      return defaultConfig.merge(desktopConfig);
    case DeviceType.mobile:
      return defaultConfig.merge(mobileConfig);
  }
}

/// ═══════════════════════════════════════════════════════════════════════════
/// 开发模式开关 - 调试特定平台时启用
/// ═══════════════════════════════════════════════════════════════════════════
/// 
/// TODO(Developer): 设置为 true 可强制使用指定平台进行调试
/// 
const bool kForcePlatformMode = false; // TODO(Developer): 改为 true 启用强制模式
const DeviceType kForcedDeviceType = DeviceType.tablet; // TODO(Developer): 选择要调试的平台

/// ═══════════════════════════════════════════════════════════════════════════

/// 响应式断点常量
class Breakpoints {
  /// 移动端最大宽度（底部导航栏）
  static const double mobile = 600;
  
  /// 平板/Web端最大宽度（顶部导航栏）
  static const double tablet = 1400;
  
  /// 桌面端最小宽度（左侧导航栏）
  static const double desktop = 1400;
}

/// 响应式工具类
class Responsive {
  /// 判断是否为移动端
  static bool isMobile(double width) => width < Breakpoints.mobile;
  
  /// 判断是否为平板/Web端
  static bool isTablet(double width) => width >= Breakpoints.mobile && width < Breakpoints.desktop;
  
  /// 判断是否为桌面端
  static bool isDesktop(double width) => width >= Breakpoints.desktop;
  
  /// 获取当前设备类型（智能检测）
  /// 
  /// 检测逻辑：
  /// 1. 如果启用了强制模式 (kForcePlatformMode=true)，使用指定的平台
  /// 2. Web 平台始终返回 tablet（顶部导航栏）
  /// 3. 其他平台根据屏幕宽度判断
  static DeviceType getDeviceType(double width) {
    // 开发模式：强制使用指定平台
    if (kForcePlatformMode) {
      return kForcedDeviceType;
    }
    
    // Web 平台使用顶部导航栏
    if (kIsWeb) {
      return DeviceType.tablet;
    }
    
    // 原有的屏幕宽度判断逻辑
    if (isMobile(width)) return DeviceType.mobile;
    if (isTablet(width)) return DeviceType.tablet;
    return DeviceType.desktop;
  }
}

/// 设备类型枚举
enum DeviceType {
  mobile,  // 移动端 - 底部导航栏
  tablet,  // 平板/Web端 - 顶部导航栏
  desktop, // 桌面端 - 左侧导航栏
}

// ══════════════════════════════════════════════════════════════
// 毛玻璃效果封装
// ══════════════════════════════════════════════════════════════

/// 带苹果风格液态玻璃效果的容器
class GlassContainer extends StatelessWidget {
  final Widget child;
  final GlassConfig config;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final Color? darkColor;
  final Color? lightColor;

  const GlassContainer({
    super.key,
    required this.child,
    required this.config,
    this.borderRadius,
    this.padding,
    this.darkColor,
    this.lightColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark 
        ? (darkColor ?? Colors.black).withValues(alpha: config.opacityDark)
        : (lightColor ?? Colors.white).withValues(alpha: config.opacityLight);
    
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: config.blur, sigmaY: config.blur),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            color: bgColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: config.shadowOpacity),
                blurRadius: config.shadowBlurRadius,
                offset: Offset(0, config.shadowOffsetY),
                spreadRadius: -2,
              ),
            ],
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: config.borderOpacityDark)
                  : Colors.black.withValues(alpha: config.borderOpacityLight),
              width: config.borderWidth,
            ),
          ),
          child: Stack(
            children: [
              // 顶部高光渐变
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 60,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: borderRadius != null
                        ? BorderRadius.only(
                            topLeft: borderRadius!.topLeft,
                            topRight: borderRadius!.topRight,
                          )
                        : null,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withValues(alpha: isDark ? 0.06 : 0.12),
                        Colors.white.withValues(alpha: 0),
                      ],
                    ),
                  ),
                ),
              ),
              // 内容
              Padding(
                padding: padding ?? EdgeInsets.zero,
                child: child,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// 移动端底部导航栏
// ══════════════════════════════════════════════════════════════

/// 移动端底部导航栏
class BottomNavBar extends ConsumerStatefulWidget {
  final String currentPage;

  const BottomNavBar({
    super.key,
    required this.currentPage,
  });

  @override
  ConsumerState<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends ConsumerState<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      config: getConfigForDevice(DeviceType.mobile),
      borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      darkColor: Colors.black,
      lightColor: Colors.white,
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 8),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(
              icon: Icons.task_alt,
              label: 'Tasks',
              isActive: widget.currentPage == 'tasks',
              onTap: () => context.go('/tasks'),
            ),
            _NavItem(
              icon: Icons.calendar_today,
              label: 'Calendar',
              isActive: widget.currentPage == 'calendar',
              onTap: () => context.go('/calendar'),
            ),
            _NavItem(
              icon: Icons.adjust,
              label: 'Focus',
              isActive: widget.currentPage == 'focus',
              onTap: () => context.go('/focus'),
            ),
            _NavItem(
              icon: Icons.insights,
              label: 'Insights',
              isActive: widget.currentPage == 'insights',
              onTap: () => context.go('/insights'),
            ),
            _NavItem(
              icon: Icons.settings,
              label: 'Settings',
              isActive: widget.currentPage == 'settings',
              onTap: () => context.go('/settings'),
            ),
          ],
        ),
      ),
    );
  }
}

/// 导航项组件
class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive
                  ? (isDark ? Colors.white : const Color(0xFF004AC6))
                  : (isDark ? Colors.grey[600] : const Color(0xFF64748B)),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive
                    ? (isDark ? Colors.white : const Color(0xFF004AC6))
                    : (isDark ? Colors.grey[600] : const Color(0xFF64748B)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// Web端顶部导航栏
// ══════════════════════════════════════════════════════════════

/// Web端顶部导航栏
class TopNavBar extends ConsumerStatefulWidget {
  final String currentPage;
  final TextEditingController? searchController;
  final ValueChanged<String>? onSearchChanged;

  const TopNavBar({
    super.key,
    required this.currentPage,
    this.searchController,
    this.onSearchChanged,
  });

  @override
  ConsumerState<TopNavBar> createState() => _TopNavBarState();
}

class _TopNavBarState extends ConsumerState<TopNavBar> with SingleTickerProviderStateMixin {
  late AnimationController _themeAnimController;
  late Animation<double> _themeAnimation;

  @override
  void initState() {
    super.initState();
    _themeAnimController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _themeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _themeAnimController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _themeAnimController.dispose();
    super.dispose();
  }

  void _toggleTheme() async {
    _themeAnimController.forward(from: 0.0);
    await ref.read(themeModeProvider.notifier).toggle();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isNarrow = screenWidth < 900;

    return GlassContainer(
      config: getConfigForDevice(DeviceType.tablet),
      darkColor: Colors.black,
      lightColor: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: isNarrow ? 16 : 48,
        vertical: 16,
      ),
      child: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1400),
            child: isNarrow
                ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildLogo(),
                        const SizedBox(width: 16),
                        _buildNav(),
                        const SizedBox(width: 16),
                        _buildThemeToggle(),
                        const SizedBox(width: 4),
                        _buildSettingsButton(),
                        const SizedBox(width: 4),
                        _buildUserAvatar(),
                      ],
                    ),
                  )
                : Row(
                    children: [
                      _buildLogo(),
                      const SizedBox(width: 48),
                      _buildNav(),
                      const Spacer(),
                      _buildSearchBar(),
                      const SizedBox(width: 16),
                      _buildThemeToggle(),
                      const SizedBox(width: 8),
                      _buildSettingsButton(),
                      const SizedBox(width: 8),
                      _buildUserAvatar(),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF004AC6), Color(0xFF2563EB)],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.task_alt, color: Colors.white, size: 22),
        ),
        const SizedBox(width: 12),
        Text(
          'OmniTodo',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildNav() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _NavLink(
          icon: Icons.task_alt,
          label: 'Tasks',
          isActive: widget.currentPage == 'tasks',
          onTap: () => context.go('/tasks'),
        ),
        const SizedBox(width: 8),
        _NavLink(
          icon: Icons.calendar_today,
          label: 'Calendar',
          isActive: widget.currentPage == 'calendar',
          onTap: () => context.go('/calendar'),
        ),
        const SizedBox(width: 8),
        _NavLink(
          icon: Icons.adjust,
          label: 'Focus',
          isActive: widget.currentPage == 'focus',
          onTap: () => context.go('/focus'),
        ),
        const SizedBox(width: 8),
        _NavLink(
          icon: Icons.insights,
          label: 'Insights',
          isActive: widget.currentPage == 'insights',
          onTap: () => context.go('/insights'),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.12)
              : Colors.black.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: TextField(
        controller: widget.searchController,
        onChanged: widget.onSearchChanged,
        style: TextStyle(
          color: isDark ? Colors.white : const Color(0xFF0F172A),
          fontSize: 14,
        ),
        decoration: InputDecoration(
          hintText: 'Search tasks...',
          hintStyle: TextStyle(
            color: isDark ? Colors.grey[500] : const Color(0xFF64748B),
            fontSize: 14,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: isDark ? Colors.grey[500] : const Color(0xFF64748B),
            size: 20,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide.none,
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildThemeToggle() {
    final isDark = ref.watch(themeModeProvider).valueOrNull == ThemeMode.dark;
    
    return InkWell(
      onTap: _toggleTheme,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: RotationTransition(
          turns: _themeAnimation,
          child: Icon(
            isDark ? Icons.light_mode : Icons.dark_mode,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
            size: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsButton() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return InkWell(
      onTap: () => context.go('/settings'),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(
          Icons.settings,
          color: isDark ? Colors.white : const Color(0xFF0F172A),
          size: 24,
        ),
      ),
    );
  }

  Widget _buildUserAvatar() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF6366F1), const Color(0xFF8B5CF6)]
              : [const Color(0xFF004AC6), const Color(0xFF2563EB)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Icon(Icons.person, color: Colors.white, size: 20),
    );
  }
}

/// 导航链接组件
class _NavLink extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavLink({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: isActive
                  ? (isDark ? Colors.white : const Color(0xFF004AC6))
                  : (isDark ? Colors.grey[500] : const Color(0xFF64748B)),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: isActive
                    ? (isDark ? Colors.white : const Color(0xFF004AC6))
                    : (isDark ? Colors.grey[500] : const Color(0xFF64748B)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// 桌面端左侧导航栏
// ══════════════════════════════════════════════════════════════

/// 桌面端左侧导航栏
class SideNavBar extends ConsumerStatefulWidget {
  final String currentPage;
  final bool isExpanded;
  final VoidCallback? onToggle;

  const SideNavBar({
    super.key,
    required this.currentPage,
    this.isExpanded = true,
    this.onToggle,
  });

  @override
  ConsumerState<SideNavBar> createState() => _SideNavBarState();
}

class _SideNavBarState extends ConsumerState<SideNavBar> with SingleTickerProviderStateMixin {
  late AnimationController _themeAnimController;

  @override
  void initState() {
    super.initState();
    _themeAnimController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _themeAnimController.dispose();
    super.dispose();
  }

  void _toggleTheme() async {
    _themeAnimController.forward(from: 0.0);
    await ref.read(themeModeProvider.notifier).toggle();
  }

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      config: getConfigForDevice(DeviceType.desktop),
      darkColor: Colors.black,
      lightColor: Colors.white,
      child: SizedBox(
        width: widget.isExpanded ? 240 : 72,
        child: Column(
          children: [
            _buildHeader(),
            _buildDivider(),
            _buildNavItems(),
            const Spacer(),
            _buildDivider(),
            _buildBottomSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF004AC6), Color(0xFF2563EB)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.task_alt, color: Colors.white, size: 22),
          ),
          if (widget.isExpanded) ...[
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'OmniTodo',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                  letterSpacing: -0.5,
                ),
              ),
            ),
            const SizedBox(width: 8),
            _ToggleButton(
              isExpanded: widget.isExpanded,
              onTap: widget.onToggle,
            ),
          ],
          if (!widget.isExpanded) ...[
            const Spacer(),
            _ToggleButton(
              isExpanded: widget.isExpanded,
              onTap: widget.onToggle,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDivider() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Divider(
        color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.06),
        thickness: 1,
      ),
    );
  }

  Widget _buildNavItems() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        children: [
          _SideNavItem(
            icon: Icons.task_alt,
            label: 'Tasks',
            isActive: widget.currentPage == 'tasks',
            isExpanded: widget.isExpanded,
            onTap: () => context.go('/tasks'),
          ),
          _SideNavItem(
            icon: Icons.calendar_today,
            label: 'Calendar',
            isActive: widget.currentPage == 'calendar',
            isExpanded: widget.isExpanded,
            onTap: () => context.go('/calendar'),
          ),
          _SideNavItem(
            icon: Icons.adjust,
            label: 'Focus',
            isActive: widget.currentPage == 'focus',
            isExpanded: widget.isExpanded,
            onTap: () => context.go('/focus'),
          ),
          _SideNavItem(
            icon: Icons.insights,
            label: 'Insights',
            isActive: widget.currentPage == 'insights',
            isExpanded: widget.isExpanded,
            onTap: () => context.go('/insights'),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection() {
    final isDark = ref.watch(themeModeProvider).valueOrNull == ThemeMode.dark;
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: _toggleTheme,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  RotationTransition(
                    turns: _themeAnimController,
                    child: Icon(
                      isDark ? Icons.light_mode : Icons.dark_mode,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                      size: 22,
                    ),
                  ),
                  if (widget.isExpanded) ...[
                    const SizedBox(width: 12),
                    Text(
                      isDark ? 'Light Mode' : 'Dark Mode',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () => context.go('/settings'),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Icon(
                    Icons.settings,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                    size: 22,
                  ),
                  if (widget.isExpanded) ...[
                    const SizedBox(width: 12),
                    Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [const Color(0xFF6366F1), const Color(0xFF8B5CF6)]
                        : [const Color(0xFF004AC6), const Color(0xFF2563EB)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.person, color: Colors.white, size: 20),
              ),
              if (widget.isExpanded) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'User',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      Text(
                        'user@example.com',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: isDark ? Colors.grey[400] : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// 侧边导航项组件
class _SideNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final bool isExpanded;
  final VoidCallback onTap;

  const _SideNavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isActive
                ? (isDark
                    ? Colors.white.withValues(alpha: 0.12)
                    : const Color(0xFF004AC6).withValues(alpha: 0.12))
                : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 22,
                color: isActive
                    ? (isDark ? Colors.white : const Color(0xFF004AC6))
                    : (isDark ? Colors.grey[500] : const Color(0xFF64748B)),
              ),
              if (isExpanded) ...[
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    color: isActive
                        ? (isDark ? Colors.white : const Color(0xFF004AC6))
                        : (isDark ? Colors.grey[500] : const Color(0xFF64748B)),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// 展开/折叠切换按钮
class _ToggleButton extends StatefulWidget {
  final bool isExpanded;
  final VoidCallback? onTap;

  const _ToggleButton({
    required this.isExpanded,
    this.onTap,
  });

  @override
  State<_ToggleButton> createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<_ToggleButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _isHovered
                ? (isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.black.withValues(alpha: 0.04))
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: AnimatedRotation(
            duration: const Duration(milliseconds: 300),
            turns: widget.isExpanded ? 0.5 : 0,
            child: Icon(
              Icons.chevron_left,
              color: isDark ? Colors.grey[400] : const Color(0xFF64748B),
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// 响应式导航主组件
// ══════════════════════════════════════════════════════════════

/// 响应式导航组件
class ResponsiveNavigation extends ConsumerStatefulWidget {
  final String currentPage;
  final Widget child;
  final TextEditingController? searchController;
  final ValueChanged<String>? onSearchChanged;

  const ResponsiveNavigation({
    super.key,
    required this.currentPage,
    required this.child,
    this.searchController,
    this.onSearchChanged,
  });

  @override
  ConsumerState<ResponsiveNavigation> createState() => _ResponsiveNavigationState();
}

class _ResponsiveNavigationState extends ConsumerState<ResponsiveNavigation> {
  bool _sideNavExpanded = true;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final deviceType = Responsive.getDeviceType(width);

    switch (deviceType) {
      case DeviceType.mobile:
        // 移动端：底部导航栏 + 内容
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: widget.child,
          bottomNavigationBar: BottomNavBar(currentPage: widget.currentPage),
        );
      case DeviceType.tablet:
        // Web端：顶部导航栏 + 内容
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              // 内容层
              Column(
                children: [
                  const SizedBox(height: 80), // 给导航栏留空间
                  Expanded(child: widget.child),
                ],
              ),
              // 导航栏层（置顶）
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 80,
                child: TopNavBar(
                  currentPage: widget.currentPage,
                  searchController: widget.searchController,
                  onSearchChanged: widget.onSearchChanged,
                ),
              ),
            ],
          ),
        );
      case DeviceType.desktop:
        // 桌面端：左侧导航栏 + 内容
        return _DesktopLayout(
          currentPage: widget.currentPage,
          onToggleSideNav: () => setState(() => _sideNavExpanded = !_sideNavExpanded),
          sideNavExpanded: _sideNavExpanded,
          child: widget.child,
        );
    }
  }
}

/// 桌面端布局
class _DesktopLayout extends ConsumerStatefulWidget {
  final String currentPage;
  final VoidCallback onToggleSideNav;
  final bool sideNavExpanded;
  final Widget child;

  const _DesktopLayout({
    required this.currentPage,
    required this.onToggleSideNav,
    required this.sideNavExpanded,
    required this.child,
  });

  @override
  ConsumerState<_DesktopLayout> createState() => _DesktopLayoutState();
}

class _DesktopLayoutState extends ConsumerState<_DesktopLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Row(
        children: [
          SideNavBar(
            currentPage: widget.currentPage,
            isExpanded: widget.sideNavExpanded,
            onToggle: widget.onToggleSideNav,
          ),
          Expanded(child: widget.child),
        ],
      ),
    );
  }
}
