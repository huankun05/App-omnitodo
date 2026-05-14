import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/services/auth_service.dart';
import '../../data/models/auth_models.dart';
import '../../data/providers/task_provider.dart';
import '../../data/providers/project_provider.dart';
import '../../core/providers/shared_preferences_provider.dart';
import '../../core/l10n/app_localizations.dart';
import '../widgets/app_widgets.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'test@test.com');  // 预填写邮箱
  final _passwordController = TextEditingController(text: '200513');    // 预填写密码
  bool _isLoading = false;
  String? _errorMessage;
  bool _rememberMe = true;  // 默认勾选 Remember Me

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    final savedEmail = prefs.getString('saved_email');
    final savedPassword = prefs.getString('saved_password');
    final rememberMe = prefs.getBool('remember_me') ?? false;

    if (rememberMe && savedEmail != null) {
      setState(() {
        _emailController.text = savedEmail;
        if (savedPassword != null) {
          _passwordController.text = savedPassword;
        }
        _rememberMe = true;
      });
    }
  }

  Future<void> _saveCredentials() async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    if (_rememberMe) {
      await prefs.setString('saved_email', _emailController.text.trim());
      await prefs.setString('saved_password', _passwordController.text);
      await prefs.setBool('remember_me', true);
    } else {
      await prefs.remove('saved_email');
      await prefs.remove('saved_password');
      await prefs.setBool('remember_me', false);
    }
  }

  void _showHelpDialog() {
    final l10n = AppLocalizations.of(context) ?? AppLocalizations(const Locale('en'));
    
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 320),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 应用图标
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF2563EB), Color(0xFF004AC6)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Icon(
                    Icons.check_circle_outline,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // 应用名称
              Text(
                l10n.appName,
                style: const TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w800,
                  fontSize: 28,
                  color: Color(0xFF1A1C1D),
                ),
              ),
              const SizedBox(height: 16),
              // 应用描述
              Text(
                'A premium task management application that helps you organize your tasks, focus on what matters, and boost your productivity.',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  height: 1.6,
                  color: const Color(0xFF434655),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              // 关闭按钮
              SizedBox(
                width: 160,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    l10n.ok,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 底部悬浮成功提示卡片
  void _showFloatingSuccess(String message) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: MediaQuery.of(context).padding.bottom + 50, // 底部安全区上方留出间距
        left: 24,
        right: 24,
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutBack,
              builder: (context, scale, child) {
                return Transform.scale(
                  scale: scale,
                  child: Opacity(
                    opacity: scale.clamp(0.0, 1.0),
                    child: child,
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Color.alphaBlend(AppColors.primary.withAlpha(77), Colors.transparent),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color.alphaBlend(AppColors.primary.withAlpha(64), Colors.transparent),
                      blurRadius: 20,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Color.alphaBlend(Colors.white.withAlpha(51), Colors.transparent),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.check_circle,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        message,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);
    Future.delayed(const Duration(seconds: 3), () {
      if (entry.mounted) entry.remove();
    });
  }

  void _forgotPassword() {
    final emailController = TextEditingController();
    final l10n = AppLocalizations.of(context) ?? AppLocalizations(const Locale('en'));

    showDialog(
      context: context,
      builder: (context) {
        String? emailError;

        bool validateEmail(String value) {
          return RegExp(r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$')
              .hasMatch(value.trim());
        }

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                l10n.forgotPassword,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.forgotPasswordDesc,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // 输入框
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: emailError != null
                          ? [
                              BoxShadow(
                                color: Color.alphaBlend(AppColors.error.withAlpha(38), Colors.transparent),
                                blurRadius: 6,
                                spreadRadius: 1,
                              )
                            ]
                          : null,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: emailError != null
                              ? AppColors.error
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (val) {
                          if (emailError != null) {
                            setDialogState(() => emailError = null);
                          }
                        },
                        decoration: InputDecoration(
                          hintText: l10n.emailHint,
                          hintStyle: const TextStyle(
                            color: AppColors.outline,
                            fontSize: 16,
                          ),
                          filled: true,
                          fillColor: Colors.transparent,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                        ),
                        style: const TextStyle(
                          color: AppColors.onSurface,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  // 错误提示
                  AnimatedSize(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    child: emailError != null
                        ? Padding(
                            padding: const EdgeInsets.only(top: 6, left: 4),
                            child: Row(
                              children: [
                                const Icon(Icons.error_outline,
                                    size: 14, color: AppColors.error),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    emailError!,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.error,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    l10n.cancel,
                    style: const TextStyle(
                      color: AppColors.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    final email = emailController.text.trim();
                    // 空校验
                    if (email.isEmpty) {
                      setDialogState(
                          () => emailError = 'Please enter your email address');
                      return;
                    }
                    // 格式校验
                    if (!validateEmail(email)) {
                      setDialogState(() => emailError =
                          'Please enter a valid email (e.g. name@example.com)');
                      return;
                    }
                    // 校验通过，关闭弹窗后在顶部显示悬浮成功提示
                    Navigator.of(context).pop();
                    Future.delayed(const Duration(milliseconds: 100), () {
                      if (mounted) {
                        _showFloatingSuccess(l10n.resetLinkSent);
                      }
                    });
                  },
                  child: Text(
                    l10n.resetPassword,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        final authService = await ref.read(authServiceProvider.future);
        await authService.login(
          LoginDto(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          ),
        );

        // 保存凭据
        await _saveCredentials();

        // 登录成功，预加载 HomeScreen 所需的数据
        await Future.wait([
          ref.read(taskNotifierProvider.future),
          ref.read(projectNotifierProvider.future),
        ]);

        // 导航到主页
        if (mounted) {
          context.go('/tasks');
        }
      } catch (e) {
        setState(() {
          String raw = e.toString();
          if (raw.startsWith('Exception:')) {
            raw = raw.substring('Exception:'.length).trim();
          }
          // 精确匹配 auth_service 抛出的细分错误码
          if (raw.startsWith('LOGIN_USER_NOT_FOUND')) {
            _errorMessage = 'No account found with this email address.';
          } else if (raw.startsWith('LOGIN_INVALID_PASSWORD')) {
            _errorMessage = 'Incorrect password. Please try again.';
          } else if (raw.startsWith('LOGIN_INVALID_CREDENTIALS')) {
            _errorMessage = 'Incorrect email or password. Please try again.';
          } else if (raw.startsWith('NETWORK_ERROR')) {
            _errorMessage = 'Network error. Please check your connection and try again.';
          } else if (raw.startsWith('LOGIN_FAILED:')) {
            // 提取服务器原始消息
            final detail = raw.substring('LOGIN_FAILED:'.length).trim();
            _errorMessage = detail.isNotEmpty ? detail : 'Sign in failed. Please try again.';
          } else {
            _errorMessage = 'Sign in failed. Please try again.';
          }
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context) ?? AppLocalizations(const Locale('en'));

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: AppBackground(
        child: Column(
          children: [
            // Top Navigation Bar
            _buildNavBar(l10n),
            // Main content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: Column(
                      children: [
                        const SizedBox(height: 32),
                        // Login card
                        _buildLoginCard(l10n),
                        const SizedBox(height: 48),
                        // Removed feature cards as requested
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Mobile bottom nav
            _buildMobileBottomNav(),
          ],
        ),
      ),
    );
  }

  Widget _buildNavBar(AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color.alphaBlend(AppColors.surface.withAlpha(204), Colors.transparent),
        boxShadow: AppShadows.navShadow,
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.appName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                  color: AppColors.onSurface,
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: _showHelpDialog,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.help_outline,
                        color: AppColors.onSurfaceVariant,
                        size: 24,
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

  Widget _buildLoginCard(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppBorderRadius.defaultRadius),
        boxShadow: AppShadows.cardShadow,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Column(
              children: [
                Text(
                  'OmniTodo',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                    color: AppColors.onSurface,
                    fontFamily: 'Inter',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.welcomeBack,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const SizedBox(height: 40),
            
            // Error message
            if (_errorMessage != null)
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: AppColors.errorContainer,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Color.alphaBlend(AppColors.error.withAlpha(77), Colors.transparent)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline,
                        size: 18, color: AppColors.error),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(
                          color: AppColors.onErrorContainer,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            
            // Email field
            StyledTextField(
              label: l10n.emailAddress,
              hint: l10n.emailHint,
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your email address';
                }
                if (!RegExp(r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$')
                    .hasMatch(value.trim())) {
                  return 'Please enter a valid email (e.g. name@example.com)';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            
            // Password field
            StyledTextField(
              label: l10n.password,
              hint: l10n.passwordHint,
              controller: _passwordController,
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Remember me & Forgot password row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Remember me with animation
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _rememberMe = !_rememberMe;
                    });
                  },
                  child: Row(
                    children: [
                      AnimatedCheckbox(
                        value: _rememberMe,
                        activeColor: AppColors.primaryContainer,
                        borderColor: AppColors.outlineVariant,
                        onChanged: (val) {
                          setState(() => _rememberMe = val);
                        },
                      ),
                      const SizedBox(width: 12),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _rememberMe
                              ? AppColors.primary
                              : AppColors.onSurfaceVariant,
                        ),
                        child: Text(l10n.rememberMe),
                      ),
                    ],
                  ),
                ),
                // Forgot password
                PressableTextButton(
                  label: l10n.forgotPassword,
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  onPressed: _forgotPassword,
                ),
              ],
            ),
            const SizedBox(height: 32),
            
            // Sign In Button - 带按压效果和发光
            PressableGradientButton(
              label: l10n.signIn,
              icon: Icons.arrow_forward,
              isLoading: _isLoading,
              onPressed: _login,
            ),
            const SizedBox(height: 40),
            
            // Divider
            Container(
              height: 1,
              color: AppColors.surfaceContainerHigh,
            ),
            const SizedBox(height: 16),
            
            // Create account link
            Text.rich(
              TextSpan(
                text: '${l10n.dontHaveAccount}   ',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.onSurfaceVariant,
                ),
                children: [
                  TextSpan(
                    text: l10n.createAccount,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        context.go('/register');
                      },
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileBottomNav() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 768) {
          return const SizedBox.shrink();
        }
        return Container(
          decoration: BoxDecoration(
            color: Color.alphaBlend(AppColors.surface.withAlpha(204), Colors.transparent),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            boxShadow: AppShadows.navShadow,
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Active Login button
                  Column(
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
                        child: const Icon(
                          Icons.login,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurface,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                  // Register button
                  GestureDetector(
                    onTap: () => context.go('/register'),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          child: const Icon(
                            Icons.person_add,
                            color: AppColors.onSurfaceVariant,
                            size: 24,
                          ),
                        ),
                        const Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.onSurfaceVariant,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
