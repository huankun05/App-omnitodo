import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../data/providers/task_provider.dart';
import '../../data/models/task_models.dart';
import 'create_task_screen.dart';
import '../widgets/app_widgets.dart';
import '../widgets/responsive_navigation.dart';
import '../widgets/project_nav_sidebar.dart';

// ═══════════════════════════════════════════════════════════════
// 带按下动画的图标按钮
// ═══════════════════════════════════════════════════════════════
class _AnimatedIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _AnimatedIconButton({required this.icon, required this.onTap});

  @override
  State<_AnimatedIconButton> createState() => _AnimatedIconButtonState();
}

class _AnimatedIconButtonState extends State<_AnimatedIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 120),
      vsync: this,
    );
    _scale = Tween<double>(begin: 1.0, end: 0.88).animate(
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
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) {
          _controller.reverse();
          widget.onTap();
        },
        onTapCancel: () => _controller.reverse(),
        child: AnimatedBuilder(
          animation: _scale,
          builder: (_, child) => Transform.scale(
            scale: _scale.value,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _isHovered
                    ? AppColors.surfaceContainerHigh
                    : AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(widget.icon, color: AppColors.onSurface, size: 20),
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// 带按下动画的 Today 按钮
// ═══════════════════════════════════════════════════════════════
class _AnimatedTodayButton extends StatefulWidget {
  final VoidCallback onTap;

  const _AnimatedTodayButton({required this.onTap});

  @override
  State<_AnimatedTodayButton> createState() => _AnimatedTodayButtonState();
}

class _AnimatedTodayButtonState extends State<_AnimatedTodayButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 120),
      vsync: this,
    );
    _scale = Tween<double>(begin: 1.0, end: 0.93).animate(
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
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) {
          _controller.reverse();
          widget.onTap();
        },
        onTapCancel: () => _controller.reverse(),
        child: AnimatedBuilder(
          animation: _scale,
          builder: (_, child) => Transform.scale(
            scale: _scale.value,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: _isHovered
                    ? AppColors.surfaceContainerHigh
                    : AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Text(
                'Today',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// 主屏幕
// ═══════════════════════════════════════════════════════════════

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen>
    with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedMonth = DateTime.now();
  late AnimationController _fabAnimationController;
  late Animation<double> _fabScaleAnimation;

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _fabScaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _fabAnimationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  List<Task> _getTasksForDate(List<Task> tasks, DateTime date) {
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    return tasks.where((task) {
      if (task.dueDate == null) return false;
      return task.dueDate!.startsWith(dateStr) && task.deletedAt == null;
    }).toList();
  }

  Map<String, List<Task>> _groupTasksByDate(List<Task> tasks, DateTime month) {
    final Map<String, List<Task>> grouped = {};
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);
    for (final task in tasks) {
      if (task.dueDate == null || task.deletedAt != null) continue;
      final dueDate = DateTime.tryParse(task.dueDate!);
      if (dueDate == null) continue;
      if (dueDate.isBefore(firstDay) || dueDate.isAfter(lastDay)) continue;
      final dateStr = DateFormat('yyyy-MM-dd').format(dueDate);
      grouped.putIfAbsent(dateStr, () => []).add(task);
    }
    return grouped;
  }

  Color _categoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'work':
        return AppColors.primary;
      case 'personal':
        return AppColors.secondaryContainer;
      case 'health':
        return AppColors.error;
      case 'learning':
        return const Color(0xFF8B5CF6);
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(taskNotifierProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeDesktop = screenWidth >= 1024;

    return ResponsiveNavigation(
      currentPage: 'calendar',
      searchController: _searchController,
      onSearchChanged: (value) {},
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: AppBackground(
          child: tasksAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Error: $error')),
            data: (tasks) => _buildContent(tasks, isLargeDesktop),
          ),
        ),
        floatingActionButton: _buildFAB(),
      ),
    );
  }

  Widget _buildContent(List<Task> tasks, bool isLargeDesktop) {
    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1600),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isLargeDesktop ? 64 : 32,
              vertical: 48,
            ),
            child: isLargeDesktop
                ? _buildDesktopLayout(tasks)
                : _buildMobileLayout(tasks),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(List<Task> tasks) {
    final tasksByDate = _groupTasksByDate(tasks, _focusedMonth);
    final selectedDateTasks = _getTasksForDate(tasks, _selectedDate);
    final incomplete =
        selectedDateTasks.where((t) => !t.isCompleted).toList();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 8, child: _buildCalendarSection(tasksByDate)),
        const SizedBox(width: 48),
        Expanded(flex: 4, child: _buildSidebarSection(incomplete)),
      ],
    );
  }

  Widget _buildMobileLayout(List<Task> tasks) {
    final tasksByDate = _groupTasksByDate(tasks, _focusedMonth);
    final selectedDateTasks = _getTasksForDate(tasks, _selectedDate);
    final incomplete =
        selectedDateTasks.where((t) => !t.isCompleted).toList();
    return Column(
      children: [
        _buildCalendarSection(tasksByDate),
        const SizedBox(height: 32),
        _buildSidebarSection(incomplete),
        const SizedBox(height: 120),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════
  // 日历头部
  // ═══════════════════════════════════════════════════════════

  Widget _buildCalendarSection(Map<String, List<Task>> tasksByDate) {
    final monthTaskCount = tasksByDate.values.fold<int>(0, (sum, list) => sum + list.length);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCalendarHeader(monthTaskCount),
        const SizedBox(height: 32),
        _buildCalendarCard(tasksByDate),
      ],
    );
  }

  Widget _buildCalendarHeader(int monthTaskCount) {
    final subtitle = monthTaskCount == 0
        ? 'No tasks scheduled this month.'
        : '$monthTaskCount ${monthTaskCount == 1 ? 'task' : 'tasks'} scheduled this month.';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat('MMMM').format(_focusedMonth),
              style: const TextStyle(
                fontFamily: 'Manrope',
                fontSize: 42,
                fontWeight: FontWeight.w800,
                color: AppColors.onSurface,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
        Row(
          children: [
            _AnimatedIconButton(
              icon: Icons.chevron_left,
              onTap: () {
                setState(() {
                  _focusedMonth = DateTime(
                    _focusedMonth.year,
                    _focusedMonth.month - 1,
                  );
                });
              },
            ),
            const SizedBox(width: 8),
            _AnimatedTodayButton(
              onTap: () {
                setState(() {
                  _focusedMonth = DateTime.now();
                  _selectedDate = DateTime.now();
                });
              },
            ),
            const SizedBox(width: 8),
            _AnimatedIconButton(
              icon: Icons.chevron_right,
              onTap: () {
                setState(() {
                  _focusedMonth = DateTime(
                    _focusedMonth.year,
                    _focusedMonth.month + 1,
                  );
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  // ── 日历卡片 ────────────────────────────────────────────────

  Widget _buildCalendarCard(Map<String, List<Task>> tasksByDate) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(28),
        boxShadow: AppShadows.cardShadow,
      ),
      child: Column(
        children: [
          _buildWeekdayHeader(),
          const SizedBox(height: 16),
          _buildCalendarGrid(tasksByDate),
        ],
      ),
    );
  }

  Widget _buildWeekdayHeader() {
    final days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    return Row(
      children: days.map((day) {
        final isWeekend = day == 'SAT' || day == 'SUN';
        return Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                day,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                  color: isWeekend
                      ? AppColors.secondaryContainer.withValues(alpha: 0.7)
                      : AppColors.outline,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── 日历网格 ──────────────────────────────────────────────

  Widget _buildCalendarGrid(Map<String, List<Task>> tasksByDate) {
    final firstDayOfMonth = DateTime(
      _focusedMonth.year,
      _focusedMonth.month,
      1,
    );
    final lastDayOfMonth = DateTime(
      _focusedMonth.year,
      _focusedMonth.month + 1,
      0,
    );
    final startingWeekday = (firstDayOfMonth.weekday - 1) % 7;
    final daysInMonth = lastDayOfMonth.day;
    final today = DateTime.now();

    final needsSixRows = startingWeekday + daysInMonth > 35;
    final totalCells = needsSixRows ? 42 : 35;

    final rows = <Widget>[];
    for (int row = 0; row < (needsSixRows ? 6 : 5); row++) {
      final cells = <Widget>[];
      for (int col = 0; col < 7; col++) {
        final index = row * 7 + col;
        if (index >= totalCells) {
          cells.add(const Expanded(child: SizedBox.shrink()));
          continue;
        }
        final date = firstDayOfMonth.subtract(
          Duration(days: startingWeekday - index),
        );
        final isCurrentMonth =
            index >= startingWeekday && index < startingWeekday + daysInMonth;
        cells.add(
          Expanded(
            child: SizedBox(
              height: needsSixRows ? 90 : 112,
              child: _DayCell(
                date: date,
                isCurrentMonth: isCurrentMonth,
                tasksByDate: tasksByDate,
                today: today,
                isSelected: date.year == _selectedDate.year &&
                    date.month == _selectedDate.month &&
                    date.day == _selectedDate.day,
                compact: needsSixRows,
                categoryColor: _categoryColor,
                onTap: () => setState(() => _selectedDate = date),
              ),
            ),
          ),
        );
      }
      rows.add(Row(children: cells));
      if (row < (needsSixRows ? 5 : 4)) {
        rows.add(Container(height: 1, color: AppColors.surfaceContainer));
      }
    }

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.surfaceContainer, width: 1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: rows),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // 侧边栏
  // ═══════════════════════════════════════════════════════════

  Widget _buildSidebarSection(List<Task> incomplete) {
    final morningTasks = incomplete.where((t) {
      if (t.dueDate == null) return false;
      final d = DateTime.tryParse(t.dueDate!);
      return d != null && d.hour < 12;
    }).toList();
    final afternoonTasks = incomplete.where((t) {
      if (t.dueDate == null) return false;
      final d = DateTime.tryParse(t.dueDate!);
      return d != null && d.hour >= 12 && d.hour < 17;
    }).toList();
    final eveningTasks = incomplete.where((t) {
      if (t.dueDate == null) return false;
      final d = DateTime.tryParse(t.dueDate!);
      return d != null && d.hour >= 17;
    }).toList();
    final isToday = _selectedDate.year == DateTime.now().year &&
        _selectedDate.month == DateTime.now().month &&
        _selectedDate.day == DateTime.now().day;

    return Column(
      children: [
        _buildTodayFocusCard(isToday, morningTasks, afternoonTasks, eveningTasks),
        const SizedBox(height: 24),
        _buildZenQuoteCard(),
      ],
    );
  }

  Widget _buildTodayFocusCard(
    bool isToday,
    List<Task> morningTasks,
    List<Task> afternoonTasks,
    List<Task> eveningTasks,
  ) {
    final dateLabel = isToday ? 'Today' : DateFormat('EEEE').format(_selectedDate);
    final dateBadge = '${_selectedDate.day} ${DateFormat('MMM').format(_selectedDate)}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              dateLabel,
              style: const TextStyle(
                fontFamily: 'Manrope',
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.onSurface,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                dateBadge,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // 任务卡片 —— 独立灰色背景，固定最小高度
        Container(
          padding: const EdgeInsets.all(24),
          constraints: const BoxConstraints(minHeight: 280),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(AppBorderRadius.defaultRadius),
          ),
          child: morningTasks.isEmpty && afternoonTasks.isEmpty && eveningTasks.isEmpty
              ? Center(child: _buildEmptyDayState())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (morningTasks.isNotEmpty) ...[
                      _buildTimeBlock('Morning', morningTasks),
                      if (afternoonTasks.isNotEmpty || eveningTasks.isNotEmpty)
                        const SizedBox(height: 24),
                    ],
                    if (afternoonTasks.isNotEmpty) ...[
                      _buildTimeBlock('Afternoon', afternoonTasks),
                      if (eveningTasks.isNotEmpty) const SizedBox(height: 24),
                    ],
                    if (eveningTasks.isNotEmpty)
                      _buildTimeBlock('Evening', eveningTasks),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _buildTimeBlock(String label, List<Task> tasks) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label.toUpperCase(),
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: AppColors.outline,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                height: 1,
                color: AppColors.outlineVariant.withValues(alpha: 0.2),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        ...tasks.map((task) => _SidebarTaskCard(
              task: task,
              isOngoing: _isTaskOngoing(task),
              categoryColor: _categoryColor,
            )),
      ],
    );
  }

  bool _isTaskOngoing(Task task) {
    if (task.dueDate == null) return false;
    final now = DateTime.now();
    final dueDate = DateTime.tryParse(task.dueDate!);
    if (dueDate == null) return false;
    final endTime = dueDate.add(const Duration(hours: 1));
    return now.isAfter(dueDate) && now.isBefore(endTime);
  }

  Widget _buildEmptyDayState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.event_available_outlined,
              size: 48, color: AppColors.outline),
          SizedBox(height: 12),
          Text('No tasks scheduled',
              style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.outline)),
          SizedBox(height: 4),
          Text('Enjoy your free day!',
              style: TextStyle(
                  fontSize: 12,
                  color: AppColors.outline)),
        ],
      ),
    );
  }

  // ── 名言卡片 ──────────────────────────────────────────────

  Widget _buildZenQuoteCard() {
    final quotes = [
      {'quote': 'Your mind is for having ideas, not holding them.', 'author': 'David Allen'},
      {'quote': 'The secret of getting ahead is getting started.', 'author': 'Mark Twain'},
      {'quote': 'Focus on being productive instead of busy.', 'author': 'Tim Ferriss'},
    ];
    final q = quotes[DateTime.now().day % quotes.length];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E293B), Color(0xFF334155)],
        ),
      ),
      child: ClipRect(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Decorative blurred circles
            Positioned(
              top: -20,
              right: -20,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryContainer.withValues(alpha: 0.15),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -20,
              left: -20,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryContainer.withValues(alpha: 0.15),
                  ),
                ),
              ),
            ),
            // Quote content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.format_quote, size: 32, color: AppColors.primaryContainer),
                const SizedBox(height: 14),
                Text(
                  '"${q['quote']}"',
                  style: const TextStyle(
                    fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.italic, color: Colors.white, height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '— ${q['author']}',
                  style: const TextStyle(
                    fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.w800,
                    color: AppColors.primaryContainer, letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── FAB ──────────────────────────────────────────────────

  void _showCreateTaskSheet() {
    final screenWidth = MediaQuery.of(context).size.width;
    final sheetWidth = screenWidth > 800 ? screenWidth * 0.65 : screenWidth;
    final selectedProjectId = ref.read(selectedProjectIdProvider);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      constraints: BoxConstraints(
        maxWidth: sheetWidth,
        minWidth: sheetWidth,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => CreateTaskScreen(
        isModal: true,
        initialProjectId: selectedProjectId,
      ),
    );
  }

  Widget _buildFAB() {
    return MouseRegion(
      onEnter: (_) => _fabAnimationController.reverse(),
      onExit: (_) => _fabAnimationController.forward(),
      child: GestureDetector(
        onTapDown: (_) => _fabAnimationController.forward(),
        onTapUp: (_) => _fabAnimationController.reverse(),
        onTapCancel: () => _fabAnimationController.reverse(),
        onTap: _showCreateTaskSheet,
        child: ScaleTransition(
          scale: ReverseAnimation(_fabScaleAnimation),
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 32,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            child: const Icon(Icons.add, color: Colors.white, size: 28),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// 带 hover + 按下动画的日期单元格
// ═══════════════════════════════════════════════════════════════
class _DayCell extends StatefulWidget {
  final DateTime date;
  final bool isCurrentMonth;
  final Map<String, List<Task>> tasksByDate;
  final DateTime today;
  final bool isSelected;
  final bool compact;
  final Color Function(String) categoryColor;
  final VoidCallback onTap;

  const _DayCell({
    required this.date,
    required this.isCurrentMonth,
    required this.tasksByDate,
    required this.today,
    required this.isSelected,
    required this.compact,
    required this.categoryColor,
    required this.onTap,
  });

  @override
  State<_DayCell> createState() => _DayCellState();
}

class _DayCellState extends State<_DayCell>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressCtrl;
  late Animation<double> _pressScale;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _pressCtrl = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _pressScale = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _pressCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dayNumber = widget.date.day;
    final isToday = widget.date.year == widget.today.year &&
        widget.date.month == widget.today.month &&
        widget.date.day == widget.today.day;
    final isWeekend =
        widget.date.weekday == 6 || widget.date.weekday == 7;

    final dateStr = DateFormat('yyyy-MM-dd').format(widget.date);
    final dayTasks = widget.tasksByDate[dateStr] ?? [];
    final incomplete = dayTasks.where((t) => !t.isCompleted).toList();

    // 非当前月
    if (!widget.isCurrentMonth) {
      return Container(
        color: AppColors.surfaceContainerLow,
        alignment: Alignment.topLeft,
        padding: EdgeInsets.all(widget.compact ? 8 : 14),
        child: Text(
          '$dayNumber',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: widget.compact ? 12 : 14,
            fontWeight: FontWeight.w600,
            color: AppColors.outline.withValues(alpha: 0.4),
          ),
        ),
      );
    }

    // 背景色
    final Color bgColor;
    if (widget.isSelected && isToday) {
      bgColor = AppColors.primary.withValues(alpha: 0.05);
    } else if (widget.isSelected) {
      bgColor = AppColors.primary.withValues(alpha: 0.08);
    } else if (_isHovered) {
      bgColor = AppColors.surfaceContainerLow;
    } else {
      bgColor = AppColors.surfaceContainerLowest;
    }

    // 日期颜色
    final Color dateColor;
    if (isToday) {
      dateColor = AppColors.primary;
    } else if (isWeekend) {
      dateColor = AppColors.secondaryContainer;
    } else {
      dateColor = AppColors.onSurface;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => _pressCtrl.forward(),
        onTapUp: (_) {
          _pressCtrl.reverse();
          widget.onTap();
        },
        onTapCancel: () => _pressCtrl.reverse(),
        child: AnimatedBuilder(
          animation: _pressScale,
          builder: (_, child) => Transform.scale(
            scale: _pressScale.value,
            child: Container(
              padding: EdgeInsets.all(widget.compact ? 6 : 10),
              decoration: isToday
                  ? BoxDecoration(
                      color: bgColor,
                      border: Border(
                        left: BorderSide(
                          color: AppColors.primary,
                          width: 2,
                        ),
                      ),
                    )
                  : BoxDecoration(color: bgColor),
              child: child!,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isToday)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$dayNumber',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: widget.compact ? 16 : 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          'TODAY',
                          style: TextStyle(
                            fontSize: widget.compact ? 7 : 8,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    )
                  else
                    Container(
                      width: widget.compact ? 28 : 32,
                      height: widget.compact ? 28 : 32,
                      alignment: Alignment.center,
                      decoration: widget.isSelected
                          ? BoxDecoration(
                              border: Border.all(
                                  color: AppColors.primary, width: 2),
                              borderRadius: BorderRadius.circular(widget.compact ? 6 : 8),
                            )
                          : null,
                      child: Text(
                        '$dayNumber',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: widget.compact ? 13 : 15,
                          fontWeight: FontWeight.w600,
                          color: dateColor,
                        ),
                      ),
                    ),
                ],
              ),
              if (incomplete.isNotEmpty) ...[
                const Spacer(),
                if (isToday)
                  _TodayTaskPills(tasks: incomplete, compact: widget.compact)
                else
                  _TaskDots(
                    tasks: incomplete,
                    compact: widget.compact,
                    categoryColor: widget.categoryColor,
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ── 今天的任务胶囊 ──────────────────────────────────────────

class _TodayTaskPills extends StatelessWidget {
  final List<Task> tasks;
  final bool compact;
  const _TodayTaskPills({required this.tasks, required this.compact});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: tasks.take(2).map((task) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 3),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            task.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: compact ? 9 : 10,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── 普通日期的彩色圆点 ─────────────────────────────────────

class _TaskDots extends StatelessWidget {
  final List<Task> tasks;
  final bool compact;
  final Color Function(String) categoryColor;
  const _TaskDots({
    required this.tasks,
    required this.compact,
    required this.categoryColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors =
        tasks.take(3).map((t) => categoryColor(t.category)).toList();
    final remaining = tasks.length - 3;
    return Row(
      children: [
        ...colors.map((color) => Container(
              width: compact ? 5 : 6,
              height: compact ? 5 : 6,
              margin: const EdgeInsets.only(right: 3),
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            )),
        if (remaining > 0)
          Text(
            '+$remaining',
            style: TextStyle(
              fontSize: compact ? 9 : 10,
              fontWeight: FontWeight.w600,
              color: AppColors.outline,
            ),
          ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// 侧边栏任务卡片（带 hover 平移动画）
// ═══════════════════════════════════════════════════════════════
class _SidebarTaskCard extends StatefulWidget {
  final Task task;
  final bool isOngoing;
  final Color Function(String) categoryColor;
  const _SidebarTaskCard({
    required this.task,
    required this.isOngoing,
    required this.categoryColor,
  });

  @override
  State<_SidebarTaskCard> createState() => _SidebarTaskCardState();
}

class _SidebarTaskCardState extends State<_SidebarTaskCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverCtrl;
  late Animation<Offset> _slide;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverCtrl = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _slide = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(4, 0),
    ).animate(CurvedAnimation(parent: _hoverCtrl, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _hoverCtrl.dispose();
    super.dispose();
  }

  void _onHover(bool hovered) {
    setState(() => _isHovered = hovered);
    if (hovered) {
      _hoverCtrl.forward();
    } else {
      _hoverCtrl.reverse();
    }
  }

  // 简单首字母大写
  String _cap(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.task;
    final hasTime = task.dueDate != null;
    final time = hasTime
        ? DateFormat('HH:mm').format(DateTime.parse(task.dueDate!))
        : null;
    final isMeeting = task.category.toLowerCase() == 'meeting';

    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: AnimatedBuilder(
        animation: _slide,
        builder: (_, child) => Transform.translate(
          offset: _slide.value,
          child: child,
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (time != null) ...[
                SizedBox(
                  width: 52,
                  child: Text(
                    time,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: widget.isOngoing
                          ? AppColors.primary
                          : AppColors.outline.withValues(alpha: 0.6),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _isHovered
                        ? AppColors.surfaceContainer
                        : AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(12),
                    border: Border(
                      left: BorderSide(
                        color: widget.isOngoing
                            ? AppColors.primary
                            : widget.categoryColor(task.category),
                        width: 4,
                      ),
                    ),
                    boxShadow: _isHovered
                        ? [
                            BoxShadow(
                              color: AppColors.onSurface.withValues(alpha: 0.06),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: AppColors.onSurface.withValues(alpha: 0.03),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              task.title,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.onSurface,
                              ),
                            ),
                          ),
                          if (isMeeting)
                            const Icon(Icons.video_camera_front,
                                size: 16, color: AppColors.primary),
                        ],
                      ),
                      if (task.description != null &&
                          task.description!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          task.description!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            color: AppColors.onSurfaceVariant,
                            height: 1.4,
                          ),
                        ),
                      ],
                      if (task.category.isNotEmpty || task.priority != 'low') ...[
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: [
                            _Tag(
                                task.category.isEmpty
                                    ? 'Internal'
                                    : _cap(task.category)),
                            if (task.priority != 'low') _Tag(_cap(task.priority)),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── 标签组件 ──────────────────────────────────────────────

class _Tag extends StatelessWidget {
  final String label;
  const _Tag(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: AppColors.onSurfaceVariant,
        ),
      ),
    );
  }
}
