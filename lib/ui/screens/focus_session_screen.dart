import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/app_widgets.dart';
import '../widgets/responsive_navigation.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/l10n/app_localizations.dart';

class FocusSessionScreen extends ConsumerStatefulWidget {
  const FocusSessionScreen({super.key});

  @override
  ConsumerState<FocusSessionScreen> createState() => _FocusSessionScreenState();
}

class _FocusSessionScreenState extends ConsumerState<FocusSessionScreen>
    with TickerProviderStateMixin {
  bool _isSessionActive = false;
  bool _isPaused = false;
  late int _timeRemaining;
  late int _totalTime;
  Timer? _timer;
  
  // Animation controllers
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _resetRotationController;

  @override
  void initState() {
    super.initState();
    _totalTime = 25 * 60;
    _timeRemaining = _totalTime;

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    
    _resetRotationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    _resetRotationController.dispose();
    super.dispose();
  }

  void _startSession() {
    setState(() {
      _isSessionActive = true;
      _isPaused = false;
    });
    _pulseController.repeat(reverse: true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeRemaining > 0) {
        setState(() {
          _timeRemaining--;
        });
      } else {
        _completeSession();
      }
    });
  }

  void _pauseSession() {
    setState(() {
      _isPaused = true;
    });
    _timer?.cancel();
    _pulseController.stop();
  }

  void _resumeSession() {
    setState(() {
      _isPaused = false;
    });
    _pulseController.repeat(reverse: true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeRemaining > 0) {
        setState(() {
          _timeRemaining--;
        });
      } else {
        _completeSession();
      }
    });
  }

  void _completeSession() {
    _timer?.cancel();
    _pulseController.stop();
    setState(() {
      _isSessionActive = false;
      _isPaused = false;
      _timeRemaining = _totalTime;
    });
    _showCompletionDialog();
  }

  void _resetSession() {
    _timer?.cancel();
    _pulseController.stop();
    _resetRotationController.forward(from: 0);
    setState(() {
      _isSessionActive = false;
      _isPaused = false;
      _timeRemaining = _totalTime;
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.celebration,
              size: 64,
              color: AppColors.primaryContainer,
            ),
            const SizedBox(height: 16),
            const Text(
              'Session Complete!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You focused for ${_totalTime ~/ 60} minutes. Great job!',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.onSurfaceVariant),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    return '${(seconds ~/ 60).toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}';
  }

  double get _progress => 1 - (_timeRemaining / _totalTime);

  @override
  Widget build(BuildContext context) {
    final formattedTime = _formatTime(_timeRemaining);
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 768;

    // Listen for settings changes
    ref.listen<AsyncValue<AppSettings>>(settingsProvider, (previous, next) {
      next.whenData((settings) {
        if (!_isSessionActive && previous?.valueOrNull?.focusDuration != settings.focusDuration) {
          setState(() {
            _totalTime = (settings.focusDuration * 60).toInt();
            _timeRemaining = _totalTime;
          });
        }
      });
    });

    final l10n = AppLocalizations.of(context);

    return ResponsiveNavigation(
      currentPage: 'focus',
      child: Scaffold(
        backgroundColor: AppColors.surface,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 0 : 24,
                vertical: isDesktop ? 48 : 32,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Column(
                    children: [
                      // Content area - max-w-2xl centered
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: Column(
                          children: [
                            const SizedBox(height: 24),
                            _buildFocusModeLabel(l10n),
                            const SizedBox(height: 16),
                            _buildTitle(l10n),
                            const SizedBox(height: 48),
                            _buildTimer(formattedTime, isDesktop, l10n),
                            const SizedBox(height: 48),
                            _buildControlButtons(l10n),
                            const SizedBox(height: 64),
                            _buildCurrentTaskCard(l10n),
                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }



  // ── Deep Focus Mode Label ─────────────────────────────────────
  Widget _buildFocusModeLabel(AppLocalizations? l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppBorderRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated ping dot
          SizedBox(
            width: 8,
            height: 8,
            child: Stack(
              alignment: Alignment.center,
              children: [
                _PulsingDot(),
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Text(
            l10n?.deepFocusMode ?? 'Deep Focus Mode',
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  // ── Title ────────────────────────────────────────────────────
  Widget _buildTitle(AppLocalizations? l10n) {
    return Text(
      l10n?.stayPresent ?? 'Stay present.',
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontFamily: 'Manrope',
        fontSize: 56,
        fontWeight: FontWeight.w700,
        letterSpacing: 1,
        color: AppColors.onSurface,
      ),
    );
  }

  // ── Timer Circle ─────────────────────────────────────────────
  Widget _buildTimer(String formattedTime, bool isDesktop, AppLocalizations? l10n) {
    final size = isDesktop ? 380.0 : 280.0;
    final timeFontSize = isDesktop ? 96.0 : 72.0;
    
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        // Breathing glow effect
        final glowOpacity = _isSessionActive 
            ? 0.08 + (_pulseAnimation.value * 0.12)
            : 0.04;
        
        return Stack(
          alignment: Alignment.center,
          children: [
            // Breathing glow
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: glowOpacity),
                    blurRadius: 60,
                    spreadRadius: 10,
                  ),
                ],
              ),
            ),
            
            // Timer container
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.surfaceContainer,
                  width: 3,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // SVG Progress Arc
                  SizedBox(
                    width: size,
                    height: size,
                    child: Transform.rotate(
                      angle: -math.pi / 2,
                      child: CustomPaint(
                        painter: _ProgressArcPainter(
                          progress: _progress,
                          radius: size / 2 - 8,
                          strokeWidth: 6,
                          backgroundColor: AppColors.surfaceContainerHighest,
                          progressColor: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  
                  // Time and label
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: timeFontSize,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                          color: AppColors.onSurface,
                        ),
                        child: Text(formattedTime),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _isSessionActive
                            ? (l10n?.minutesRemaining ?? 'Minutes')
                            : (l10n?.readyToStart ?? 'Ready to Start'),
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: _isSessionActive
                              ? AppColors.primary
                              : AppColors.onSurfaceVariant,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  // ── Control Buttons ──────────────────────────────────────────
  Widget _buildControlButtons(AppLocalizations? l10n) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Wrap(
        key: ValueKey(_isSessionActive),
        alignment: WrapAlignment.center,
        spacing: 16,
        runSpacing: 16,
        children: [
          // Start Session Button
          if (!_isSessionActive)
            _buildStartButton(l10n),
          // Pause Button
          if (_isSessionActive && !_isPaused)
            _buildPauseButton(l10n),
          // Resume Button
          if (_isSessionActive && _isPaused)
            _buildResumeButton(l10n),
          // Reset Button
          AnimatedBuilder(
            animation: _resetRotationController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _resetRotationController.value * math.pi,
                child: _buildResetButton(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStartButton(AppLocalizations? l10n) {
    return GestureDetector(
      onTap: _startSession,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, AppColors.primaryContainer],
          ),
          borderRadius: BorderRadius.circular(AppBorderRadius.full),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.play_arrow, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            Text(
              l10n?.startSession ?? 'Start Session',
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPauseButton(AppLocalizations? l10n) {
    return GestureDetector(
      onTap: _pauseSession,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(AppBorderRadius.full),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.pause, color: AppColors.onSurface, size: 24),
            const SizedBox(width: 12),
            Text(
              l10n?.pause ?? 'Pause',
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResumeButton(AppLocalizations? l10n) {
    return GestureDetector(
      onTap: _resumeSession,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, AppColors.primaryContainer],
          ),
          borderRadius: BorderRadius.circular(AppBorderRadius.full),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.play_arrow, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            Text(
              l10n?.resume ?? 'Resume',
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResetButton() {
    return GestureDetector(
      onTap: _resetSession,
      child: Container(
        width: 56,
        height: 56,
        decoration: const BoxDecoration(
          color: AppColors.surfaceContainer,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.refresh,
          color: AppColors.onSurfaceVariant,
          size: 24,
        ),
      ),
    );
  }

  // ── Current Task Card ────────────────────────────────────────
  Widget _buildCurrentTaskCard(AppLocalizations? l10n) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 500),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n?.currentTask ?? 'Current Task',
                  style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurface,
                  ),
                ),
                const Text(
                  'Task 3 of 8',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(12),
                border: const Border(
                  left: BorderSide(
                    color: AppColors.primary,
                    width: 4,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    margin: const EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.task_alt,
                      size: 18,
                      color: AppColors.primary,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Design System Documentation',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Focusing on color architecture and tonal layering rules.',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            color: AppColors.onSurfaceVariant,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          children: [
                            _buildTag('Design'),
                            _buildTag('Priority 1'),
                          ],
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
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: AppColors.onSurfaceVariant,
          letterSpacing: 1,
        ),
      ),
    );
  }

}

// ── Helper Widgets ─────────────────────────────────────────────

class _PulsingDot extends StatefulWidget {
  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 2.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    
    _opacityAnimation = Tween<double>(begin: 0.75, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ProgressArcPainter extends CustomPainter {
  final double progress;
  final double radius;
  final double strokeWidth;
  final Color backgroundColor;
  final Color progressColor;

  _ProgressArcPainter({
    required this.progress,
    required this.radius,
    required this.strokeWidth,
    required this.backgroundColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    // Background arc
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    
    canvas.drawCircle(center, radius, backgroundPaint);
    
    // Progress arc
    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ProgressArcPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
