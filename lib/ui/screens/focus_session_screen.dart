import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/app_widgets.dart';
import '../widgets/responsive_navigation.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/l10n/app_localizations.dart';
import '../../data/providers/task_provider.dart';
import '../../data/models/task_models.dart';

class FocusSessionScreen extends ConsumerStatefulWidget {
  const FocusSessionScreen({super.key});

  @override
  ConsumerState<FocusSessionScreen> createState() => _FocusSessionScreenState();
}

enum TimerMode { pomodoro, stopwatch, countdown }

class _FocusSessionScreenState extends ConsumerState<FocusSessionScreen>
    with TickerProviderStateMixin {
  bool _isSessionActive = false;
  bool _isPaused = false;
  late int _timeRemaining;
  late int _totalTime;
  Timer? _timer;

  TimerMode _selectedMode = TimerMode.pomodoro;
  double _duration = 25;
  bool _autoStartBreaks = true;
  bool _muteNotifications = false;
  String? _currentFocusTaskId;
  String? _currentSessionId;

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

  void _startSession() async {
    final durationMinutes = _duration.toInt();
    try {
      final session = await ref.read(focusNotifierProvider.notifier)
          .startFocusSession(_currentFocusTaskId, durationMinutes);
      _currentSessionId = session.id;
    } catch (_) {}

    setState(() {
      _isSessionActive = true;
      _isPaused = false;
    });
    _pulseController.repeat(reverse: true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_selectedMode == TimerMode.stopwatch) {
        setState(() {
          _timeRemaining++;
        });
      } else {
        if (_timeRemaining > 0) {
          setState(() {
            _timeRemaining--;
          });
        } else {
          _completeSession();
        }
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
      if (_selectedMode == TimerMode.stopwatch) {
        setState(() {
          _timeRemaining++;
        });
      } else {
        if (_timeRemaining > 0) {
          setState(() {
            _timeRemaining--;
          });
        } else {
          _completeSession();
        }
      }
    });
  }

  void _completeSession() async {
    _timer?.cancel();
    _pulseController.stop();

    if (_currentSessionId != null) {
      try {
        await ref.read(focusNotifierProvider.notifier)
            .endFocusSession(_currentSessionId!);
      } catch (_) {}
      _currentSessionId = null;
    }

    final elapsedMinutes = _timeRemaining ~/ 60;
    setState(() {
      _isSessionActive = false;
      _isPaused = false;
      _timeRemaining = _selectedMode == TimerMode.stopwatch ? 0 : _totalTime;
    });
    _showCompletionDialog(elapsedMinutes);
  }

  void _resetSession() {
    _timer?.cancel();
    _pulseController.stop();
    _resetRotationController.forward(from: 0);
    _currentSessionId = null;
    setState(() {
      _isSessionActive = false;
      _isPaused = false;
      _timeRemaining = _selectedMode == TimerMode.stopwatch ? 0 : _totalTime;
    });
  }

  void _showCompletionDialog(int elapsedMinutes) {
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
              'You focused for $elapsedMinutes minutes. Great job!',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.onSurfaceVariant),
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

    ref.listen<AsyncValue<AppSettings>>(settingsProvider, (previous, next) {
      next.whenData((settings) {
        if (!_isSessionActive && previous?.valueOrNull?.focusDuration != settings.focusDuration) {
          setState(() {
            _totalTime = (settings.focusDuration * 60).toInt();
            _timeRemaining = _totalTime;
            _duration = settings.focusDuration.toDouble();
          });
        }
      });
    });

    ref.read(settingsProvider.future).then((settings) {
      if (mounted && !_isSessionActive) {
        final newTotal = (settings.focusDuration * 60).toInt();
        if (_totalTime != newTotal) {
          setState(() {
            _totalTime = newTotal;
            _timeRemaining = newTotal;
            _duration = settings.focusDuration.toDouble();
          });
        }
      }
    });

    final dailyStatsAsync = ref.watch(dailyFocusStatsProvider);
    final focusTaskQueue = ref.watch(focusTaskQueueProvider);
    final l10n = AppLocalizations.of(context);

    return ResponsiveNavigation(
      currentPage: 'focus',
      child: Scaffold(
        backgroundColor: AppColors.surfaceContainer,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          bottom: false,
          child: isDesktop
              ? _buildDesktopLayout(formattedTime, dailyStatsAsync.valueOrNull, focusTaskQueue, l10n)
              : _buildMobileLayout(formattedTime, dailyStatsAsync.valueOrNull, focusTaskQueue, l10n),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(String formattedTime, DailyFocusStats? dailyStats, List<Task> queue, AppLocalizations? l10n) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 48),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: _buildLeftPanel(dailyStats, queue, l10n),
                ),
                const SizedBox(width: 48),
                Expanded(
                  flex: 6,
                  child: _buildCenterPanel(formattedTime, true, l10n),
                ),
                const SizedBox(width: 48),
                Expanded(
                  flex: 3,
                  child: _buildRightPanel(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(String formattedTime, DailyFocusStats? dailyStats, List<Task> queue, AppLocalizations? l10n) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          children: [
            _buildCenterPanel(formattedTime, false, l10n),
            const SizedBox(height: 32),
            _buildLeftPanel(dailyStats, queue, l10n),
            const SizedBox(height: 32),
            _buildRightPanel(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }



  // ── Center Panel (Timer) ─────────────────────────────────────
  Widget _buildCenterPanel(String formattedTime, bool isDesktop, AppLocalizations? l10n) {
    return Column(
      children: [
        const SizedBox(height: 24),
        _buildFocusModeLabel(l10n),
        const SizedBox(height: 16),
        _buildTitle(l10n),
        SizedBox(height: isDesktop ? 48 : 40),
        _buildTimer(formattedTime, isDesktop, l10n),
        SizedBox(height: isDesktop ? 48 : 40),
        _buildControlButtons(l10n),
      ],
    );
  }

  // ── Left Panel (Stats & Queue) ───────────────────────────────
  Widget _buildLeftPanel(DailyFocusStats? dailyStats, List<Task> queue, AppLocalizations? l10n) {
    return Column(
      children: [
        _buildStatsCard(dailyStats, l10n),
        const SizedBox(height: 32),
        _buildTaskQueue(queue, l10n),
      ],
    );
  }

  String _formatDailyFocusTime(int totalMinutes) {
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    if (hours > 0) return '${hours}h ${minutes}m';
    return '${minutes}m';
  }

  Widget _buildStatsCard(DailyFocusStats? stats, AppLocalizations? l10n) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceContainerHighest),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.analytics_outlined, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                'Daily Overview',
                style: TextStyle(
                  fontFamily: GoogleFonts.nunito().fontFamily,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildStatItem('Focus Time', _formatDailyFocusTime(stats?.focusMinutes ?? 0)),
          const SizedBox(height: 12),
          _buildStatItem('Completed', '${stats?.completedTasks ?? 0} Tasks'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontFamily: GoogleFonts.nunito().fontFamily,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: AppColors.onSurface,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontFamily: GoogleFonts.nunito().fontFamily,
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskQueue(List<Task> queue, AppLocalizations? l10n) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceContainerHighest),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Queue',
                style: TextStyle(
                  fontFamily: GoogleFonts.nunito().fontFamily,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.onSurface,
                ),
              ),
              Text(
                'View All',
                style: TextStyle(
                  fontFamily: GoogleFonts.nunito().fontFamily,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (queue.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  'No tasks in queue',
                  style: TextStyle(
                    fontFamily: GoogleFonts.nunito().fontFamily,
                    fontSize: 13,
                    color: AppColors.onSurface,
                  ),
                ),
              ),
            )
          else ...[
            _buildQueueItem(
              status: 'Current',
              subtitle: queue[0].priority,
              title: queue[0].title,
              isActive: _currentFocusTaskId == null || _currentFocusTaskId == queue[0].id,
              onTap: () => _selectFocusTask(queue[0].id),
            ),
            if (queue.length > 1) ...[
              const SizedBox(height: 12),
              _buildQueueItem(
                status: 'Next',
                subtitle: queue[1].priority,
                title: queue[1].title,
                isActive: _currentFocusTaskId == queue[1].id,
                onTap: () => _selectFocusTask(queue[1].id),
              ),
            ],
            if (queue.length > 2) ...[
              const SizedBox(height: 12),
              _buildQueueItem(
                status: 'Upcoming',
                subtitle: queue[2].priority,
                title: queue[2].title,
                isActive: false,
              ),
            ],
          ],
        ],
      ),
    );
  }

  void _selectFocusTask(String taskId) {
    if (_isSessionActive) return;
    setState(() {
      _currentFocusTaskId = taskId;
    });
  }

  Widget _buildQueueItem({
    required String status,
    required String subtitle,
    required String title,
    required bool isActive,
    VoidCallback? onTap,
  }) {
    final card = Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.primary.withValues(alpha: 0.05)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                status.toUpperCase(),
                style: TextStyle(
                  fontFamily: GoogleFonts.nunito().fontFamily,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: isActive ? AppColors.primary : AppColors.onSurface,
                  letterSpacing: 1,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontFamily: GoogleFonts.nunito().fontFamily,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: AppColors.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: TextStyle(
              fontFamily: GoogleFonts.nunito().fontFamily,
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.onSurface,
            ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: card);
    }
    return card;
  }

  // ── Right Panel (Configuration) ──────────────────────────────
  Widget _buildRightPanel() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceContainerHighest),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.settings_suggest_outlined, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                'Configuration',
                style: TextStyle(
                  fontFamily: GoogleFonts.nunito().fontFamily,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Timer Mode
          _buildModeSelector(),
          const SizedBox(height: 24),
          // Duration
          _buildDurationControl(),
          const SizedBox(height: 24),
          // Settings toggles
          Container(
            padding: const EdgeInsets.only(top: 16),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.surfaceContainerHighest, width: 0.5)),
            ),
            child: Column(
              children: [
                _buildToggleRow(
                  'Auto-start Breaks',
                  _autoStartBreaks,
                  (v) => setState(() => _autoStartBreaks = v),
                ),
                const SizedBox(height: 16),
                _buildToggleRow(
                  'Mute Notifications',
                  _muteNotifications,
                  (v) => setState(() => _muteNotifications = v),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TIMER MODE',
          style: TextStyle(
            fontFamily: GoogleFonts.nunito().fontFamily,
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: AppColors.onSurface,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        _buildModeButton('Pomodoro', TimerMode.pomodoro),
        const SizedBox(height: 8),
        _buildModeButton('Stopwatch', TimerMode.stopwatch),
        const SizedBox(height: 8),
        _buildModeButton('Countdown', TimerMode.countdown),
      ],
    );
  }

  Widget _buildModeButton(String label, TimerMode mode) {
    final isSelected = _selectedMode == mode;
    return GestureDetector(
      onTap: () => _onModeChanged(mode),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? null
              : Border.all(color: AppColors.surfaceContainerHighest),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: GoogleFonts.nunito().fontFamily,
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: isSelected ? Colors.white : AppColors.onSurface,
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, size: 18, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildDurationControl() {
    final mode = _selectedMode;
    if (mode == TimerMode.stopwatch) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'DURATION',
              style: TextStyle(
                fontFamily: GoogleFonts.nunito().fontFamily,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: AppColors.onSurface,
                letterSpacing: 1.2,
              ),
            ),
            Text(
              '${_duration.toInt()}m',
              style: TextStyle(
                fontFamily: GoogleFonts.nunito().fontFamily,
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: AppColors.primary,
            inactiveTrackColor: AppColors.surfaceContainer,
            thumbColor: AppColors.primary,
            overlayColor: AppColors.primary.withValues(alpha: 0.1),
            trackHeight: 6,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
          ),
          child: Slider(
            value: _duration,
            min: 5,
            max: 120,
            divisions: 23,
            onChanged: _onDurationChanged,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildDurationPreset(25),
            const SizedBox(width: 8),
            _buildDurationPreset(45),
            const SizedBox(width: 8),
            _buildDurationPreset(60),
          ],
        ),
      ],
    );
  }

  Widget _buildDurationPreset(int minutes) {
    final isSelected = _duration.toInt() == minutes;
    return Expanded(
      child: GestureDetector(
        onTap: () => _onDurationChanged(minutes.toDouble()),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: isSelected
                ? null
                : Border.all(color: AppColors.surfaceContainerHighest),
          ),
          alignment: Alignment.center,
          child: Text(
            '$minutes',
            style: TextStyle(
              fontFamily: GoogleFonts.nunito().fontFamily,
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: isSelected ? Colors.white : AppColors.onSurface,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToggleRow(String label, bool value, ValueChanged<bool> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: GoogleFonts.nunito().fontFamily,
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.onSurface,
          ),
        ),
        GestureDetector(
          onTap: () => onChanged(!value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 44,
            height: 24,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: value ? AppColors.primary : AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Handlers ─────────────────────────────────────────────────
  void _onModeChanged(TimerMode mode) {
    if (_isSessionActive) return;
    setState(() {
      _selectedMode = mode;
      if (mode == TimerMode.stopwatch) {
        _timeRemaining = 0;
        _totalTime = 0;
      } else {
        _totalTime = (_duration * 60).toInt();
        _timeRemaining = _totalTime;
      }
    });
  }

  void _onDurationChanged(double value) {
    if (_isSessionActive) return;
    setState(() {
      _duration = value;
      _totalTime = (value * 60).toInt();
      _timeRemaining = _totalTime;
    });
    ref.read(settingsProvider.notifier).updateFocusDuration(value);
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
            style: TextStyle(
              fontFamily: GoogleFonts.nunito().fontFamily,
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
      style: TextStyle(
        fontFamily: GoogleFonts.nunito().fontFamily,
        fontSize: 56,
        fontWeight: FontWeight.w800,
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
                          fontFamily: GoogleFonts.nunito().fontFamily,
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
                            ? (_selectedMode == TimerMode.stopwatch
                                ? 'Minutes Elapsed'
                                : (l10n?.minutesRemaining ?? 'Minutes Remaining'))
                            : (l10n?.readyToStart ?? 'Ready to Start'),
                        style: TextStyle(
                          fontFamily: GoogleFonts.nunito().fontFamily,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: _isSessionActive
                              ? AppColors.primary
                              : AppColors.onSurface,
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
              style: TextStyle(
                fontFamily: GoogleFonts.nunito().fontFamily,
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
              style: TextStyle(
                fontFamily: GoogleFonts.nunito().fontFamily,
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
              style: TextStyle(
                fontFamily: GoogleFonts.nunito().fontFamily,
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
