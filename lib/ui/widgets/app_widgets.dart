import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/providers/theme_provider.dart';

// Design tokens from HTML mockups
class AppColors {
  // Primary colors
  static const primary = Color(0xFF004AC6);
  static const primaryContainer = Color(0xFF2563EB);
  static const onPrimary = Color(0xFFFFFFFF);
  static const onPrimaryContainer = Color(0xFFEEEFFF);
  static const primaryFixed = Color(0xFFDBE1FF);
  static const primaryFixedDim = Color(0xFFB4C5FF);

  // Secondary colors
  static const secondary = Color(0xFF9D4300);
  static const secondaryContainer = Color(0xFFFD761A);
  static const onSecondary = Color(0xFFFFFFFF);
  static const onSecondaryContainer = Color(0xFF5C2400);
  static const secondaryFixed = Color(0xFFFFDBCA);
  static const secondaryFixedDim = Color(0xFFFFB690);

  // Tertiary colors
  static const tertiary = Color(0xFF943700);
  static const tertiaryContainer = Color(0xFFBC4800);
  static const surfaceVariant = Color(0xFFE2E2E4);
  static const onTertiary = Color(0xFFFFFFFF);
  static const onTertiaryContainer = Color(0xFFFFEDE6);
  static const tertiaryFixed = Color(0xFFFFDBCD);
  static const tertiaryFixedDim = Color(0xFFFFB596);

  // Surface colors (light mode) - Brighter whites
  static const surface = Color(0xFFFAFAFC);
  static const surfaceDim = Color(0xFFD9DADC);
  static const surfaceBright = Color(0xFFFFFFFF);
  static const surfaceContainerLowest = Color(0xFFFFFFFF);
  static const surfaceContainerLow = Color(0xFFF8F8FA);
  static const surfaceContainer = Color(0xFFF3F3F6);
  static const surfaceContainerHigh = Color(0xFFEFEFf2);
  static const surfaceContainerHighest = Color(0xFFE8E8EC);

  // On colors
  static const onSurface = Color(0xFF1A1C1D);
  static const onSurfaceVariant = Color(0xFF434655);
  static const onBackground = Color(0xFF1A1C1D);
  static const background = Color(0xFFF9F9FB);
  static const inverseSurface = Color(0xFF2F3132);
  static const inverseOnSurface = Color(0xFFF0F0F2);
  static const inversePrimary = Color(0xFFB4C5FF);

  // Other
  static const outline = Color(0xFF737686);
  static const outlineVariant = Color(0xFFC3C6D7);
  static const error = Color(0xFFBA1A1A);
  static const onError = Color(0xFFFFFFFF);
  static const errorContainer = Color(0xFFFFDAD6);
  static const onErrorContainer = Color(0xFF93000A);
  static const surfaceTint = Color(0xFF0053DB);
}

class AppBorderRadius {
  static const defaultRadius = 24.0;  // 增大圆角
  static const lg = 40.0;             // 增大圆角
  static const xl = 56.0;             // 增大圆角
  static const full = 9999.0;
}

class AppShadows {
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: const Color(0xFF1E293B).withValues(alpha: 0.04),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> get navShadow => [
        BoxShadow(
          color: const Color(0xFF1E293B).withValues(alpha: 0.04),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> get fabShadow => [
        BoxShadow(
          color: const Color(0xFF2563EB).withValues(alpha: 0.4),
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
      ];

  // 发光效果阴影
  static List<BoxShadow> glowShadow(Color color, {double opacity = 0.3}) => [
        BoxShadow(
          color: color.withValues(alpha: opacity),
          blurRadius: 12,
          spreadRadius: 2,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: color.withValues(alpha: opacity * 0.5),
          blurRadius: 24,
          spreadRadius: 4,
          offset: const Offset(0, 8),
        ),
      ];
}

// ============ 带按压效果的渐变按钮 ============
class PressableGradientButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;

  const PressableGradientButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.isLoading = false,
    this.width,
  });

  @override
  State<PressableGradientButton> createState() => _PressableGradientButtonState();
}

class _PressableGradientButtonState extends State<PressableGradientButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse();
    widget.onPressed?.call();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.isLoading ? null : _onTapDown,
      onTapUp: widget.isLoading ? null : _onTapUp,
      onTapCancel: widget.isLoading ? null : _onTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.width,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryContainer],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppBorderRadius.full),
                // 发光效果
                boxShadow: AppShadows.glowShadow(
                  _isPressed ? AppColors.primaryContainer : AppColors.primary,
                  opacity: _isPressed ? 0.5 : 0.3,
                ),
              ),
              child: widget.isLoading
                  ? const Center(
                      child: SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: widget.width != null
                          ? MainAxisSize.max
                          : MainAxisSize.min,
                      children: [
                        Text(
                          widget.label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700, // 更粗
                            fontSize: 16,
                          ),
                        ),
                        if (widget.icon != null) ...[
                          const SizedBox(width: 8),
                          Icon(
                            widget.icon,
                            color: Colors.white,
                            size: 18,
                          ),
                        ],
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }
}

// ============ 优化后的输入框（白框蓝边/蓝框发光） ============
class StyledTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final bool obscureText;
  final Widget? suffixIcon;
  final int maxLines;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final FocusNode? focusNode;

  const StyledTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.obscureText = false,
    this.suffixIcon,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
    this.focusNode,
  });

  @override
  State<StyledTextField> createState() => _StyledTextFieldState();
}

class _StyledTextFieldState extends State<StyledTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;
  bool _hasText = false;
  // 内部存储最新的错误文字（由 FormField 回调出来）
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
    _hasText = widget.controller?.text.isNotEmpty ?? false;
    widget.controller?.addListener(_onTextChange);
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  void _onTextChange() {
    setState(() {
      _hasText = widget.controller?.text.isNotEmpty ?? false;
      // 有内容输入时清除错误提示
      if (_hasText) _errorText = null;
    });
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    widget.controller?.removeListener(_onTextChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool hasError = _errorText != null;

    // 三种状态：
    // 1. 默认（未输入）：灰色背景 + 透明边框
    // 2. 聚焦：白色背景 + 蓝色边框
    // 3. 填写后：灰色背景 + 蓝色边框 + 发光效果
    // 4. 错误：灰色背景 + 红色边框
    final Color bgColor = _isFocused
        ? AppColors.surfaceContainerLowest
        : AppColors.surfaceContainerHigh;

    final Color borderColor = hasError
        ? AppColors.error
        : (_hasText || _isFocused ? AppColors.primary : Colors.transparent);

    final List<BoxShadow>? glowEffect = hasError
        ? [
            BoxShadow(
              color: AppColors.error.withValues(alpha: 0.15),
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, 2),
            ),
          ]
        : (_hasText && !hasError
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  blurRadius: 8,
                  spreadRadius: 1,
                  offset: const Offset(0, 2),
                ),
              ]
            : null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        if (widget.label != null) ...[
          SizedBox(
            height: 18,
            child: Text(
              widget.label!.toUpperCase(),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
                color: hasError
                    ? AppColors.error
                    : (_isFocused
                        ? AppColors.primary
                        : AppColors.onSurfaceVariant),
              ),
            ),
          ),
          const SizedBox(height: 6),
        ],

        // Input Container
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: glowEffect,
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: borderColor, width: 2.0),
            ),
            // 使用 TextFormField 接入 Form 的 validate()
            child: TextFormField(
              controller: widget.controller,
              focusNode: _focusNode,
              obscureText: widget.obscureText,
              maxLines: widget.maxLines,
              keyboardType: widget.keyboardType,
              onChanged: widget.onChanged,
              validator: widget.validator == null
                  ? null
                  : (value) {
                      final error = widget.validator!(value);
                      // 将错误同步回 State 以便驱动边框颜色
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          setState(() => _errorText = error);
                        }
                      });
                      return null; // 不使用 FormField 原生错误渲染
                    },
              style: const TextStyle(
                color: AppColors.onSurface,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: const TextStyle(
                  color: AppColors.outline,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                filled: true,
                fillColor: bgColor,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                // 隐藏 FormField 默认的错误文字（我们自己渲染）
                errorStyle: const TextStyle(height: 0, fontSize: 0),
                suffixIcon: widget.suffixIcon,
              ),
            ),
          ),
        ),

        // 内联错误文字（自定义样式）
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          child: _errorText != null
              ? Padding(
                  padding: const EdgeInsets.only(top: 6, left: 4),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 14,
                        color: AppColors.error,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          _errorText!,
                          style: const TextStyle(
                            color: AppColors.error,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

// ============ 带按压效果的文字按钮 ============
class PressableTextButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color? color;
  final double fontSize;
  final FontWeight fontWeight;

  const PressableTextButton({
    super.key,
    required this.label,
    this.onPressed,
    this.color,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w600,
  });

  @override
  State<PressableTextButton> createState() => _PressableTextButtonState();
}

class _PressableTextButtonState extends State<PressableTextButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onPressed?.call();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Text(
              widget.label,
              style: TextStyle(
                color: widget.color ?? AppColors.primary,
                fontSize: widget.fontSize,
                fontWeight: widget.fontWeight,
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Top Navigation Bar widget matching HTML design
class TopNavBar extends ConsumerWidget {
  final int currentIndex;

  const TopNavBar({
    super.key,
    this.currentIndex = 0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode.when(
      data: (mode) => mode == ThemeMode.dark,
      loading: () => false,
      error: (_, _) => false,
    );

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1E293B).withValues(alpha: 0.8)
            : const Color(0xFFF7F7F9).withValues(alpha: 0.8),
        boxShadow: AppShadows.navShadow,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          child: Row(
            children: [
              // Logo
              Text(
                'OmniTodo',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                ),
              ),
              const SizedBox(width: 32),
              // Desktop Navigation
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth < 768) {
                      return const SizedBox.shrink();
                    }
                    return Row(
                      children: [
                        _NavItem(
                          label: 'Tasks',
                          icon: Icons.task_alt,
                          isActive: currentIndex == 0,
                          onTap: () => context.go('/tasks'),
                        ),
                        _NavItem(
                          label: 'Calendar',
                          icon: Icons.calendar_today,
                          isActive: currentIndex == 1,
                          onTap: () => context.go('/calendar'),
                        ),
                        _NavItem(
                          label: 'Focus',
                          icon: Icons.adjust,
                          isActive: currentIndex == 2,
                          onTap: () => context.go('/focus'),
                        ),
                        _NavItem(
                          label: 'Settings',
                          icon: Icons.settings,
                          isActive: currentIndex == 3,
                          onTap: () => context.go('/settings'),
                        ),
                      ],
                    );
                  },
                ),
              ),
              // Right side actions
              Row(
                children: [
                  _IconButton(
                    icon: Icons.calendar_month,
                    onTap: () {},
                  ),
                  _IconButton(
                    icon: Icons.more_vert,
                    onTap: () {},
                  ),
                  const SizedBox(width: 8),
                  // Avatar
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primaryFixed,
                        width: 2,
                      ),
                    ),
                    child: const CircleAvatar(
                      backgroundColor: AppColors.surfaceContainerHigh,
                      child: Icon(
                        Icons.person,
                        color: AppColors.onSurfaceVariant,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: isActive
            ? BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.primaryContainer,
                    width: 2,
                  ),
                ),
              )
            : null,
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isActive
                  ? AppColors.primaryContainer
                  : (isDark
                      ? Colors.white.withValues(alpha: 0.6)
                      : const Color(0xFF1E293B).withValues(alpha: 0.6)),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                color: isActive
                    ? AppColors.primaryContainer
                    : (isDark
                        ? Colors.white.withValues(alpha: 0.6)
                        : const Color(0xFF1E293B).withValues(alpha: 0.6)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Icon(
          icon,
          size: 24,
          color: isDark
              ? Colors.white.withValues(alpha: 0.6)
              : const Color(0xFF1E293B).withValues(alpha: 0.6),
        ),
      ),
    );
  }
}

/// Bottom Navigation Bar for mobile
class BottomNavBar extends StatelessWidget {
  final int currentIndex;

  const BottomNavBar({
    super.key,
    this.currentIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F9).withValues(alpha: 0.8),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: AppShadows.navShadow,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _BottomNavItem(
                icon: Icons.task_alt,
                label: 'Tasks',
                isActive: currentIndex == 0,
                isPrimary: true,
                onTap: () => context.go('/tasks'),
              ),
              _BottomNavItem(
                icon: Icons.calendar_today,
                label: 'Calendar',
                isActive: currentIndex == 1,
                onTap: () => context.go('/calendar'),
              ),
              _BottomNavItem(
                icon: Icons.adjust,
                label: 'Focus',
                isActive: currentIndex == 2,
                onTap: () => context.go('/focus'),
              ),
              _BottomNavItem(
                icon: Icons.settings,
                label: 'Settings',
                isActive: currentIndex == 3,
                onTap: () => context.go('/settings'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final bool isPrimary;
  final VoidCallback onTap;

  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    this.isPrimary = false,
    required this.onTap,
  });

  @override
  State<_BottomNavItem> createState() => _BottomNavItemState();
}

class _BottomNavItemState extends State<_BottomNavItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isPrimary) {
      return GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) {
          _controller.reverse();
          widget.onTap();
        },
        onTapCancel: () => _controller.reverse(),
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryContainer],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: AppShadows.glowShadow(AppColors.primary),
                    ),
                    child: Icon(
                      widget.icon,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.label,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700, // 加粗
                      color: AppColors.onSurface,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    }

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  widget.icon,
                  size: 24,
                  color: widget.isActive
                      ? AppColors.primaryContainer
                      : const Color(0xFF1E293B).withValues(alpha: 0.4),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: widget.isActive
                        ? FontWeight.w700
                        : FontWeight.w500,
                    color: widget.isActive
                        ? AppColors.primaryContainer
                        : const Color(0xFF1E293B).withValues(alpha: 0.4),
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// ============ 带动画的任务卡片 ============
class AnimatedTaskCard extends StatefulWidget {
  final String title;
  final String? subtitle;
  final List<String> tags;
  final bool isCompleted;
  final bool isOverdue;
  final bool isStarred;
  final VoidCallback? onTap;
  final VoidCallback? onComplete;
  final VoidCallback? onStar;

  const AnimatedTaskCard({
    super.key,
    required this.title,
    this.subtitle,
    this.tags = const [],
    this.isCompleted = false,
    this.isOverdue = false,
    this.isStarred = false,
    this.onTap,
    this.onComplete,
    this.onStar,
  });

  @override
  State<AnimatedTaskCard> createState() => _AnimatedTaskCardState();
}

class _AnimatedTaskCardState extends State<AnimatedTaskCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;
  bool _isCompleting = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onComplete() async {
    if (_isCompleting) return;
    setState(() => _isCompleting = true);
    await _controller.forward();
    widget.onComplete?.call();
    await Future.delayed(const Duration(milliseconds: 200));
    if (mounted) {
      _controller.reverse();
      setState(() => _isCompleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: widget.isCompleted
                    ? AppColors.surfaceContainerLow.withValues(alpha: 0.5)
                    : _isPressed
                        ? AppColors.surfaceContainerLow
                        : AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(20),
                boxShadow: widget.isCompleted
                    ? null
                    : [
                        BoxShadow(
                          color: _isPressed
                              ? Colors.black.withValues(alpha: 0.08)
                              : Colors.black.withValues(alpha: 0.04),
                          blurRadius: _isPressed ? 32 : 24,
                          offset: Offset(0, _isPressed ? 12 : 8),
                        ),
                      ],
                border: widget.isOverdue
                    ? Border(
                        left: BorderSide(
                          color: AppColors.secondary,
                          width: 4,
                        ),
                      )
                    : null,
              ),
              child: Row(
                children: [
                  // Checkbox with animation
                  GestureDetector(
                    onTap: _onComplete,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: widget.isCompleted
                              ? AppColors.primary
                              : AppColors.outline,
                          width: 2,
                        ),
                        color: widget.isCompleted
                            ? AppColors.primary
                            : Colors.transparent,
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: widget.isCompleted
                            ? const Icon(
                                Icons.check,
                                key: ValueKey('check'),
                                color: Colors.white,
                                size: 16,
                              )
                            : const SizedBox.shrink(key: ValueKey('empty')),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: widget.isCompleted
                                ? AppColors.outline
                                : AppColors.onSurface,
                            decoration: widget.isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            decorationThickness: 1.5,
                            decorationColor: AppColors.onSurface.withValues(alpha: 0.2),
                          ),
                          child: Text(widget.title),
                        ),
                        if (widget.subtitle != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            widget.subtitle!,
                            style: TextStyle(
                              fontSize: 12,
                              color: widget.isOverdue
                                  ? AppColors.secondary
                                  : AppColors.onSurfaceVariant,
                              fontWeight:
                                  widget.isOverdue ? FontWeight.bold : FontWeight.w500,
                            ),
                          ),
                        ],
                        if (widget.tags.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: widget.tags.map((tag) {
                              return _AnimatedTag(tag: tag);
                            }).toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Star with animation
                  if (widget.onStar != null && !widget.isCompleted)
                    _AnimatedStarButton(
                      isStarred: widget.isStarred,
                      onTap: widget.onStar!,
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _AnimatedTag extends StatelessWidget {
  final String tag;

  const _AnimatedTag({required this.tag});

  Color _getTagColor() {
    switch (tag.toLowerCase()) {
      case 'work':
        return AppColors.primary;
      case 'personal':
        return AppColors.tertiary;
      case 'high priority':
      case 'priority 1':
        return AppColors.error;
      case 'health':
        return AppColors.secondary;
      default:
        return AppColors.onSurfaceVariant;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getTagColor();
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        tag.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

class _AnimatedStarButton extends StatefulWidget {
  final bool isStarred;
  final VoidCallback onTap;

  const _AnimatedStarButton({
    required this.isStarred,
    required this.onTap,
  });

  @override
  State<_AnimatedStarButton> createState() => _AnimatedStarButtonState();
}

class _AnimatedStarButtonState extends State<_AnimatedStarButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _controller.forward(from: 0);
        widget.onTap();
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Icon(
                widget.isStarred ? Icons.star : Icons.star_border,
                key: ValueKey(widget.isStarred),
                color: widget.isStarred
                    ? AppColors.primary
                    : AppColors.outline.withValues(alpha: 0.4),
                size: 24,
              ),
            ),
          );
        },
      ),
    );
  }
}

/// ============ 记住我复选框 ============
class AnimatedCheckbox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color? activeColor;
  final Color? borderColor;

  const AnimatedCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.activeColor,
    this.borderColor,
  });

  @override
  State<AnimatedCheckbox> createState() => _AnimatedCheckboxState();
}

class _AnimatedCheckboxState extends State<AnimatedCheckbox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _checkAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.9), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _checkAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );
    
    // Set initial animation state based on value
    if (widget.value) {
      _checkAnimation = Tween<double>(begin: 1.0, end: 1.0).animate(_controller);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = widget.activeColor ?? AppColors.primary;
    final borderColor = widget.borderColor ?? AppColors.outlineVariant;

    return GestureDetector(
      onTap: () {
        _controller.forward(from: 0);
        widget.onChanged?.call(!widget.value);
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: widget.value ? activeColor : AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: widget.value ? activeColor : borderColor,
                  width: 1.5,
                ),
              ),
              child: widget.value
                  ? CustomPaint(
                      painter: _CheckPainter(
                        progress: _checkAnimation.value,
                        color: Colors.white,
                      ),
                    )
                  : null,
            ),
          );
        },
      ),
    );
  }
}

class _CheckPainter extends CustomPainter {
  final double progress;
  final Color color;

  _CheckPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    final startX = size.width * 0.25;
    final startY = size.height * 0.5;
    final midX = size.width * 0.45;
    final midY = size.height * 0.7;
    final endX = size.width * 0.75;
    final endY = size.height * 0.35;

    if (progress <= 0.5) {
      final t = progress * 2;
      path.moveTo(startX, startY);
      path.lineTo(
        startX + (midX - startX) * t,
        startY + (midY - startY) * t,
      );
    } else {
      final t = (progress - 0.5) * 2;
      path.moveTo(startX, startY);
      path.lineTo(midX, midY);
      path.lineTo(
        midX + (endX - midX) * t,
        midY + (endY - midY) * t,
      );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_CheckPainter oldDelegate) =>
      progress != oldDelegate.progress;
}

/// Task Card matching HTML design
class TaskCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<String> tags;
  final bool isCompleted;
  final bool isOverdue;
  final bool isStarred;
  final VoidCallback? onTap;
  final VoidCallback? onComplete;
  final VoidCallback? onStar;

  const TaskCard({
    super.key,
    required this.title,
    this.subtitle,
    this.tags = const [],
    this.isCompleted = false,
    this.isOverdue = false,
    this.isStarred = false,
    this.onTap,
    this.onComplete,
    this.onStar,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedTaskCard(
      title: title,
      subtitle: subtitle,
      tags: tags,
      isCompleted: isCompleted,
      isOverdue: isOverdue,
      isStarred: isStarred,
      onTap: onTap,
      onComplete: onComplete,
      onStar: onStar,
    );
  }
}

/// ============ 带动画的设置开关 ============
class AnimatedSettingsSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color? activeColor;

  const AnimatedSettingsSwitch({
    super.key,
    required this.value,
    this.onChanged,
    this.activeColor,
  });

  @override
  State<AnimatedSettingsSwitch> createState() => _AnimatedSettingsSwitchState();
}

class _AnimatedSettingsSwitchState extends State<AnimatedSettingsSwitch>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    
    if (widget.value) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(AnimatedSettingsSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      if (widget.value) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = widget.activeColor ?? AppColors.primary;
    
    return GestureDetector(
      onTap: () => widget.onChanged?.call(!widget.value),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            width: 52,
            height: 32,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Color.lerp(
                AppColors.surfaceVariant,
                activeColor,
                _animation.value,
              ),
            ),
            child: Stack(
              children: [
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  left: 2 + (_animation.value * 20),
                  top: 2,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ============================================================
// ===       全局背景组件（从登录页提取，供所有页面复用）       ===
// ============================================================

/// 背景样式枚举，供后续设置页面切换
enum AppBackgroundStyle {
  /// 动态光晕浮球（默认）
  floatingOrbs,

  /// 纯净无效果背景
  plain,
}

/// 单个浮动光晕球（带随机游荡动画）
///
/// 用法：置于 [Stack] 中，通过 [Positioned] 确定初始锚点。
/// 光晕球会以多个正弦波叠加的方式在锚点附近**连续**游荡，
/// 动画基于全局流逝时间（[Ticker]），不分段重置，永不跳变。
class AppFloatingDecoration extends StatefulWidget {
  /// 圆形直径
  final double size;

  /// 光晕主色
  final Color color;

  /// 不透明度倍率（0.0~1.0），最终透明度 = opacity * 内部系数
  final double opacity;

  /// 模糊半径基数（实际 blurRadius = blur * 5）
  final int blur;

  /// 相位偏移种子，用于让多个球错开节拍（任意整数即可）
  final int phaseSeed;

  /// 仅显示描边圆环（默认 false = 实心光晕）
  final bool borderOnly;

  const AppFloatingDecoration({
    super.key,
    required this.size,
    required this.color,
    required this.opacity,
    required this.blur,
    required this.phaseSeed,
    this.borderOnly = false,
  });

  @override
  State<AppFloatingDecoration> createState() => _AppFloatingDecorationState();
}

class _AppFloatingDecorationState extends State<AppFloatingDecoration>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;

  /// 连续流逝时间（秒），由 Ticker 驱动，永不重置
  double _elapsed = 0;

  // ── 每个球独立的随机运动参数，在 initState 中固定，不再改变 ──

  /// X 轴三层正弦波的频率（rad/s）
  late final double _freqX1, _freqX2, _freqX3;

  /// Y 轴三层余弦波的频率（rad/s）
  late final double _freqY1, _freqY2, _freqY3;

  /// X 轴三层波的初始相位（rad）
  late final double _phaseX1, _phaseX2, _phaseX3;

  /// Y 轴三层波的初始相位（rad）
  late final double _phaseY1, _phaseY2, _phaseY3;

  /// X 轴三层波的振幅（px）
  late final double _ampX1, _ampX2, _ampX3;

  /// Y 轴三层波的振幅（px）
  late final double _ampY1, _ampY2, _ampY3;

  /// 每个球静止锚点的随机偏移
  late final double _anchorDX, _anchorDY;

  @override
  void initState() {
    super.initState();

    final rng = Random(widget.phaseSeed * 1327 + 9973);

    // 随机频率：0.12 ~ 0.35 rad/s（对应约 18~52 秒一个完整周期）
    // 三层不同频率叠加，保证路径无规则感
    _freqX1 = 0.12 + rng.nextDouble() * 0.23;
    _freqX2 = _freqX1 * (1.6 + rng.nextDouble() * 0.8);
    _freqX3 = _freqX1 * (2.9 + rng.nextDouble() * 1.2);

    _freqY1 = 0.10 + rng.nextDouble() * 0.25;
    _freqY2 = _freqY1 * (1.5 + rng.nextDouble() * 0.9);
    _freqY3 = _freqY1 * (2.7 + rng.nextDouble() * 1.3);

    // 随机初始相位：确保多球启动时位置各异
    _phaseX1 = rng.nextDouble() * 2 * pi;
    _phaseX2 = rng.nextDouble() * 2 * pi;
    _phaseX3 = rng.nextDouble() * 2 * pi;
    _phaseY1 = rng.nextDouble() * 2 * pi;
    _phaseY2 = rng.nextDouble() * 2 * pi;
    _phaseY3 = rng.nextDouble() * 2 * pi;

    // 振幅：主波大、谐波小
    _ampX1 = 40.0 + rng.nextDouble() * 30.0;
    _ampX2 = 18.0 + rng.nextDouble() * 16.0;
    _ampX3 = 8.0 + rng.nextDouble() * 10.0;

    _ampY1 = 40.0 + rng.nextDouble() * 30.0;
    _ampY2 = 18.0 + rng.nextDouble() * 16.0;
    _ampY3 = 8.0 + rng.nextDouble() * 10.0;

    // 锚点偏移（轻微分散，避免所有球堆在同一位置）
    _anchorDX = rng.nextDouble() * 60 - 30;
    _anchorDY = rng.nextDouble() * 60 - 30;

    // Ticker 驱动连续时间，每帧只更新 _elapsed，不重置任何参数
    _ticker = createTicker((elapsed) {
      setState(() {
        _elapsed = elapsed.inMicroseconds / 1e6;
      });
    });
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  /// X 方向位移（像素）：连续、无跳变
  double get _dx =>
      sin(_freqX1 * _elapsed + _phaseX1) * _ampX1 +
      sin(_freqX2 * _elapsed + _phaseX2) * _ampX2 +
      sin(_freqX3 * _elapsed + _phaseX3) * _ampX3 +
      _anchorDX;

  /// Y 方向位移（像素）：连续、无跳变
  double get _dy =>
      cos(_freqY1 * _elapsed + _phaseY1) * _ampY1 +
      cos(_freqY2 * _elapsed + _phaseY2) * _ampY2 +
      cos(_freqY3 * _elapsed + _phaseY3) * _ampY3 +
      _anchorDY;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(_dx, _dy),
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: widget.borderOnly
              ? Colors.transparent
              : widget.color.withValues(alpha: widget.opacity * 0.05),
          shape: BoxShape.circle,
          boxShadow: widget.borderOnly
              ? []
              : [
                  BoxShadow(
                    color: widget.color.withValues(alpha: widget.opacity * 0.2),
                    blurRadius: widget.blur.toDouble() * 5,
                    spreadRadius: widget.blur.toDouble() * 2,
                  ),
                  BoxShadow(
                    color: widget.color.withValues(alpha: widget.opacity * 0.1),
                    blurRadius: widget.blur.toDouble() * 3,
                    spreadRadius: widget.blur.toDouble() * 1.5,
                  ),
                ],
          border: widget.borderOnly
              ? Border.all(
                  color: widget.color.withValues(alpha: 0.05), width: 1)
              : null,
        ),
      ),
    );
  }
}

/// 全局应用背景
///
/// 将登录页的动态光晕背景封装为可复用组件。
/// 在任意页面的 [Scaffold.backgroundColor] 配合 [Stack] 使用，
/// 或直接用本组件包裹页面内容：
///
/// ```dart
/// AppBackground(child: YourPageContent())
/// ```
///
/// 后续在设置页面实现背景样式切换时，传入 [style] 参数即可：
/// ```dart
/// AppBackground(style: AppBackgroundStyle.plain, child: ...)
/// ```
class AppBackground extends StatelessWidget {
  /// 前景内容
  final Widget child;

  /// 背景底色（默认 AppColors.surface）
  final Color? backgroundColor;

  /// 背景样式（默认 [AppBackgroundStyle.floatingOrbs]）
  final AppBackgroundStyle style;

  const AppBackground({
    super.key,
    required this.child,
    this.backgroundColor,
    this.style = AppBackgroundStyle.floatingOrbs,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? AppColors.surface;

    if (style == AppBackgroundStyle.plain) {
      return ColoredBox(color: bgColor, child: child);
    }

    // ── floatingOrbs 样式 ──
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return ColoredBox(
      color: bgColor,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ── 蓝色光晕：左上 ──
          Positioned(
            top: h * 0.15,
            left: w * 0.1,
            child: const AppFloatingDecoration(
              size: 180,
              color: Color(0xFF2563EB),
              opacity: 0.5,
              blur: 100,
              phaseSeed: 1,
            ),
          ),
          // ── 橙色光晕：右下 ──
          Positioned(
            bottom: h * 0.1,
            right: w * 0.12,
            child: const AppFloatingDecoration(
              size: 220,
              color: Color(0xFFFD761A),
              opacity: 0.6,
              blur: 100,
              phaseSeed: 2,
            ),
          ),
          // ── 蓝色光晕：右中 ──
          Positioned(
            top: h * 0.5,
            left: w * 0.6,
            child: const AppFloatingDecoration(
              size: 150,
              color: Color(0xFF2563EB),
              opacity: 0.4,
              blur: 80,
              phaseSeed: 3,
            ),
          ),
          // ── 橙色光晕：左下中 ──
          Positioned(
            top: h * 0.7,
            left: w * 0.2,
            child: const AppFloatingDecoration(
              size: 100,
              color: Color(0xFFFD761A),
              opacity: 0.35,
              blur: 70,
              phaseSeed: 4,
            ),
          ),
          // ── 蓝色描边圆：右上 ──
          Positioned(
            top: h * 0.25,
            right: w * 0.05,
            child: const AppFloatingDecoration(
              size: 80,
              color: Color(0xFF2563EB),
              opacity: 0.25,
              blur: 0,
              borderOnly: true,
              phaseSeed: 5,
            ),
          ),
          // ── 橙色描边圆：左下 ──
          Positioned(
            bottom: h * 0.3,
            left: w * 0.08,
            child: const AppFloatingDecoration(
              size: 120,
              color: Color(0xFFFD761A),
              opacity: 0.2,
              blur: 0,
              borderOnly: true,
              phaseSeed: 6,
            ),
          ),
          // ── 前景内容 ──
          child,
        ],
      ),
    );
  }
}

/// ============ 带动画的设置列表项 ============
class AnimatedSettingsItem extends StatefulWidget {
  final Widget? leading;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showDivider;

  const AnimatedSettingsItem({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.showDivider = true,
  });

  @override
  State<AnimatedSettingsItem> createState() => _AnimatedSettingsItemState();
}

class _AnimatedSettingsItemState extends State<AnimatedSettingsItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTapDown: (_) {
            setState(() => _isPressed = true);
            _controller.forward();
          },
          onTapUp: (_) {
            setState(() => _isPressed = false);
            _controller.reverse();
            widget.onTap?.call();
          },
          onTapCancel: () {
            setState(() => _isPressed = false);
            _controller.reverse();
          },
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _isPressed
                        ? AppColors.surfaceContainerLow
                        : Colors.transparent,
                  ),
                  child: Row(
                    children: [
                      if (widget.leading != null) ...[
                        widget.leading!,
                        const SizedBox(width: 16),
                      ],
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.onSurface,
                              ),
                            ),
                            if (widget.subtitle != null) ...[
                              const SizedBox(height: 2),
                              Text(
                                widget.subtitle!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (widget.trailing != null) widget.trailing!,
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        if (widget.showDivider)
          Container(
            height: 1,
            margin: const EdgeInsets.only(left: 76),
            color: AppColors.surfaceContainerHigh,
          ),
      ],
    );
  }
}
