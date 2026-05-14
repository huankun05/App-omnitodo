import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/services/auth_service.dart';
import '../../data/models/auth_models.dart';
import '../../core/l10n/app_localizations.dart';
import '../widgets/app_widgets.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController(text: 'test@test.com');  // 预填写邮箱
  final _passwordController = TextEditingController(text: '200513');       // 预填写密码
  final _confirmPasswordController = TextEditingController(text: '200513');
  bool _isLoading = false;
  String? _errorMessage;
  bool _agreedToTerms = true;  // 默认勾选条款
  bool _termsError = false;

  Future<void> _register() async {
    setState(() => _termsError = false);

    final isFormValid = _formKey.currentState?.validate() ?? false;

    if (!_agreedToTerms) {
      setState(() => _termsError = true);
    }

    if (!isFormValid || !_agreedToTerms) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authService = await ref.read(authServiceProvider.future);
      await authService.register(
        RegisterDto(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );

      // 注册成功，导航到登录页面
      if (mounted) {
        context.go('/login');
      }
    } catch (e) {
      setState(() {
        String raw = e.toString();
        if (raw.startsWith('Exception:')) {
          raw = raw.substring('Exception:'.length).trim();
        }
        // 匹配 auth_service 抛出的标记码
        if (raw.startsWith('EMAIL_ALREADY_EXISTS') ||
            raw.toLowerCase().contains('already') ||
            raw.toLowerCase().contains('exists') ||
            raw.toLowerCase().contains('duplicate') ||
            raw.contains('409')) {
          _errorMessage = 'An account with this email already exists. Please sign in instead.';
        } else if (raw.startsWith('NETWORK_ERROR') ||
            raw.toLowerCase().contains('network') ||
            raw.toLowerCase().contains('connect') ||
            raw.toLowerCase().contains('timeout')) {
          _errorMessage = 'Network error. Please check your connection and try again.';
        } else if (raw.startsWith('INVALID_REGISTER_DATA')) {
          // 提取服务器具体原因
          final detail = raw.contains(':') ? raw.split(':').skip(1).join(':').trim() : '';
          _errorMessage = detail.isNotEmpty
              ? 'Invalid data: $detail'
              : 'Please check your details and try again.';
        } else {
          // 兜底：展示原始消息（去掉技术前缀）
          final detail = raw.startsWith('REGISTER_FAILED:')
              ? raw.substring('REGISTER_FAILED:'.length).trim()
              : raw;
          _errorMessage = detail.isNotEmpty && detail.length < 120
              ? 'Registration failed: $detail'
              : 'Registration failed. Please try again.';
        }
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
                        // Register card
                        _buildRegisterCard(l10n),
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
        color: AppColors.surface.withValues(alpha: 0.8),
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
              const SizedBox(width: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterCard(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
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
            // Header - 简洁设计
            Column(
              children: [
                const Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                    color: AppColors.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Start your productivity journey today',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
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
                  border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                ),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(
                    color: AppColors.onErrorContainer,
                    fontSize: 14,
                  ),
                ),
              ),
            
            // Full Name field
            StyledTextField(
              label: l10n.fullName,
              hint: l10n.nameHint,
              controller: _nameController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your full name';
                }
                if (value.trim().length < 2) {
                  return 'Name must be at least 2 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            
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
            
            // Password & Confirm Password - 横向并排
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Password field
                Expanded(
                  child: StyledTextField(
                    label: l10n.password,
                    hint: 'Min. 6 chars',
                    controller: _passwordController,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter a password';
                      }
                      if (value.length < 6) {
                        return 'Min. 6 characters';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                // Confirm Password field
                Expanded(
                  child: StyledTextField(
                    label: l10n.confirmPassword,
                    hint: 'Repeat password',
                    controller: _confirmPasswordController,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Confirm password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Terms and Privacy Policy
            GestureDetector(
              onTap: () {
                setState(() {
                  _agreedToTerms = !_agreedToTerms;
                });
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedCheckbox(
                    value: _agreedToTerms,
                    activeColor: AppColors.primaryContainer,
                    borderColor: _termsError
                        ? AppColors.error
                        : AppColors.outlineVariant,
                    onChanged: (val) {
                      setState(() {
                        _agreedToTerms = val;
                        if (val) _termsError = false;
                      });
                    },
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            text: 'I agree to the ',
                            style: TextStyle(
                              fontSize: 13,
                              color: _termsError
                                  ? AppColors.error
                                  : AppColors.onSurfaceVariant,
                            ),
                            children: [
                              TextSpan(
                                text: 'Terms',
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {},
                              ),
                              TextSpan(
                                text: ' and ',
                                style: TextStyle(
                                  color: _termsError
                                      ? AppColors.error
                                      : AppColors.onSurfaceVariant,
                                ),
                              ),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {},
                              ),
                            ],
                          ),
                        ),
                        // 条款错误提示
                        if (_termsError)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Row(
                              children: const [
                                Icon(Icons.error_outline,
                                    size: 14, color: AppColors.error),
                                SizedBox(width: 4),
                                Text(
                                  'You must agree to the Terms to continue',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.error,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            // Create Account Button - 带按压效果和发光
            PressableGradientButton(
              label: l10n.createAccount,
              icon: Icons.arrow_forward,
              isLoading: _isLoading,
              onPressed: _register,
            ),
            const SizedBox(height: 40),
            
            // Divider
            Container(
              height: 1,
              color: AppColors.surfaceContainerHigh,
            ),
            const SizedBox(height: 16),
            
            // Back to Login link
            Text.rich(
              TextSpan(
                text: '${l10n.alreadyHaveAccount} ',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.onSurfaceVariant,
                ),
                children: [
                  TextSpan(
                    text: l10n.signInLink,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        context.go('/login');
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
            color: AppColors.surface.withValues(alpha: 0.8),
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
                  // Login button
                  GestureDetector(
                    onTap: () => context.go('/login'),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          child: const Icon(
                            Icons.login,
                            color: AppColors.onSurfaceVariant,
                            size: 24,
                          ),
                        ),
                        const Text(
                          'Login',
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
                  // Active Register button
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
                          Icons.person_add,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Register',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurface,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
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
