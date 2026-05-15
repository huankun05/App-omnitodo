import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/providers/task_provider.dart';
import '../../data/providers/tag_provider.dart';
import '../../data/models/task_models.dart';
import '../../data/models/time_point.dart';
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

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  final _searchController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedMonth = DateTime.now();
  List<TimePoint> _timePoints = [];
  final Map<String, List<Task>> _tasksByTimePoint = {};

  static const _tpStorageKey = 'omni_time_points';

  @override
  void initState() {
    super.initState();
    _loadTimePoints();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadTimePoints() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_tpStorageKey);
    setState(() {
      _timePoints = json != null && json.isNotEmpty
          ? TimePoint.fromJsonList(json)
          : List.of(TimePoint.defaultTimePoints);
    });
  }

  Future<void> _saveTimePoints() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tpStorageKey, TimePoint.toJsonList(_timePoints));
  }

  void _addTimePoint(String time) {
    final id = 'tp_${DateTime.now().millisecondsSinceEpoch}';
    setState(() {
      _timePoints.add(TimePoint(id: id, time: time));
      _timePoints.sort((a, b) => a.time.compareTo(b.time));
    });
    _saveTimePoints();
  }

  void _removeTimePoint(String id) {
    setState(() {
      _timePoints.removeWhere((t) => t.id == id);
    });
    _saveTimePoints();
  }

  void _renameTimePoint(String id, String newLabel) {
    final idx = _timePoints.indexWhere((t) => t.id == id);
    if (idx < 0) return;
    setState(() {
      _timePoints[idx] = _timePoints[idx].copyWith(label: newLabel);
    });
    _saveTimePoints();
  }

  void _initTaskGroups(List<Task> allTasks) {
    // Sync tags from all tasks into TagProvider
    _syncTagsFromTasks(allTasks);

    final selectedDateTasks = _getTasksForDate(allTasks, _selectedDate);
    final incomplete = selectedDateTasks.where((t) => !t.isCompleted).toList();
    _tasksByTimePoint.clear();
    for (final tp in _timePoints) {
      _tasksByTimePoint[tp.id] = [];
    }
    for (final t in incomplete) {
      final groupId = _assignToGroup(t);
      _tasksByTimePoint.putIfAbsent(groupId, () => []).add(t);
    }
  }

  void _syncTagsFromTasks(List<Task> allTasks) {
    final tagProv = ref.read(tagProviderProvider.notifier);
    final existingNames = tagProv.allTagNames.toSet();
    for (final task in allTasks) {
      if (task.category.isEmpty) continue;
      for (final tag in task.category.split('|')) {
        final name = tag.trim();
        if (name.isNotEmpty && !existingNames.contains(name)) {
          tagProv.addTag(name);
          existingNames.add(name);
        }
      }
    }
  }

  String _assignToGroup(Task task) {
    if (_timePoints.isEmpty) return '';
    if (task.dueDate == null || !task.dueDate!.contains('T')) {
      return _timePoints.first.id;
    }
    final d = DateTime.tryParse(task.dueDate!);
    if (d == null) return _timePoints.first.id;
    final taskMinutes = d.hour * 60 + d.minute;
    String bestId = _timePoints.first.id;
    int bestDiff = 99999;
    for (final tp in _timePoints) {
      final parts = tp.time.split(':');
      final tpMinutes = int.parse(parts[0]) * 60 + int.parse(parts[1]);
      final diff = (taskMinutes - tpMinutes).abs();
      if (taskMinutes >= tpMinutes && diff < bestDiff) {
        bestDiff = diff;
        bestId = tp.id;
      }
    }
    if (bestDiff == 99999) return _timePoints.first.id;
    return bestId;
  }

  void _moveTaskToGroup(String taskId, String fromGroupId, String toGroupId, int newIndex) {
    if (fromGroupId == toGroupId) {
      // within-group reorder
      final list = _tasksByTimePoint[fromGroupId];
      if (list == null) return;
      setState(() {
        final oldIdx = list.indexWhere((t) => t.id == taskId);
        if (oldIdx < 0) return;
        final item = list.removeAt(oldIdx);
        if (newIndex > oldIdx) newIndex--;
        list.insert(newIndex, item);
      });
    } else {
      // cross-group move
      final fromList = _tasksByTimePoint[fromGroupId];
      final toList = _tasksByTimePoint.putIfAbsent(toGroupId, () => []);
      setState(() {
        final oldIdx = fromList?.indexWhere((t) => t.id == taskId) ?? -1;
        if (oldIdx < 0) return;
        final item = fromList!.removeAt(oldIdx);
        toList.insert(newIndex.clamp(0, toList.length), item);
      });
    }
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
      child: AppBackground(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              clipBehavior: Clip.none,
              children: [
                // Content — Align gives it unbounded height for scrolling
                Align(
                  alignment: Alignment.topCenter,
                  child: tasksAsync.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (error, stack) => Center(child: Text('Error: $error')),
                    data: (tasks) => _buildContent(tasks, isLargeDesktop),
                  ),
                ),
                // FAB — fixed at viewport bottom-right
                Positioned(
                  right: 48,
                  bottom: 48,
                  child: _buildFAB(),
                ),
              ],
            );
          },
        ),
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
              horizontal: isLargeDesktop ? 48 : 32,
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
    _initTaskGroups(tasks);
    final tasksByDate = _groupTasksByDate(tasks, _focusedMonth);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 8, child: _buildCalendarSection(tasksByDate)),
        const SizedBox(width: 48),
        Expanded(
          flex: 4,
          child: _buildSidebarSection(),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(List<Task> tasks) {
    _initTaskGroups(tasks);
    final tasksByDate = _groupTasksByDate(tasks, _focusedMonth);
    return Column(
      children: [
        _buildCalendarSection(tasksByDate),
        const SizedBox(height: 32),
        _buildSidebarSection(),
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
      padding: const EdgeInsets.all(40),
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
              height: needsSixRows ? 100 : 128,
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

  Widget _buildSidebarSection() {
    final dateBadge = '${_selectedDate.day} ${DateFormat('MMM').format(_selectedDate)}';

    // Estimate timeline height: viewport - nav(~80) - header(~50) - padding(~96) - quote(~200) - gaps(~80)
    final viewportH = MediaQuery.of(context).size.height;
    final timelineH = (viewportH - 506).clamp(200.0, 600.0);

    return Column(
      children: [
        // Header: Today's Focus + date badge
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Today's Focus",
              style: TextStyle(
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
        // Timeline area
        SizedBox(
          height: timelineH,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(AppBorderRadius.defaultRadius),
            ),
            child: _buildTimeline(),
          ),
        ),
        const SizedBox(height: 16),
        _buildZenQuoteCard(),
      ],
    );
  }

  Widget _buildTimeline() {
    if (_timePoints.isEmpty) {
      return GestureDetector(
        onTap: _showAddTimePointDialog,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildEmptyDayState(),
              const SizedBox(height: 12),
              Text(
                'Tap to add a time point',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: AppColors.outline.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 8, left: 20),
      itemCount: _timePoints.length,
      itemBuilder: (context, index) {
        final tp = _timePoints[index];
        final tasks = _tasksByTimePoint[tp.id] ?? [];
        final isLast = index == _timePoints.length - 1;
        return _buildTimePointRow(tp, tasks, isLast, index);
      },
    );
  }

  Widget _buildTimePointRow(TimePoint tp, List<Task> tasks, bool isLast, int index) {
    final displayLabel = tp.label.isNotEmpty ? tp.label : tp.time;
    return GestureDetector(
      // Tap on the dot area to create a task at this time point
      onDoubleTap: () => _showCreateTaskAtTimePoint(tp),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline: continuous line + dot
          SizedBox(
            width: 20,
            child: Column(
              children: [
                const SizedBox(height: 6),
                // Dot
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                // Continuous line (or gap for last item)
                if (!isLast)
                  Container(
                    width: 2,
                    height: 60,
                    color: AppColors.primary.withValues(alpha: 0.25),
                  )
                else
                  const SizedBox(height: 60),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Tasks group
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Group label + actions
                Row(
                  children: [
                    Text(
                      displayLabel.toUpperCase(),
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: AppColors.outline,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: AppColors.outlineVariant.withValues(alpha: 0.15),
                      ),
                    ),
                    _buildTimePointActions(tp),
                  ],
                ),
                const SizedBox(height: 8),
                // Task cards
                if (tasks.isNotEmpty)
                  ReorderableListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: tasks.length,
                    onReorder: (oldIndex, newIndex) {
                      _moveTaskToGroup(tasks[oldIndex].id, tp.id, tp.id, newIndex);
                    },
                    itemBuilder: (context, index) {
                      return _CompactTaskCard(
                        key: ValueKey(tasks[index].id),
                        task: tasks[index],
                        categoryColor: _categoryColor,
                        tagColor: (name) => ref.read(tagProviderProvider).colorForTag(name),
                      );
                    },
                    proxyDecorator: (child, index, animation) {
                      return Material(
                        color: Colors.transparent,
                        child: child,
                      );
                    },
                  )
                else
                  GestureDetector(
                    onTap: () => _showCreateTaskAtTimePoint(tp),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Icon(Icons.add_rounded, size: 14, color: AppColors.outline.withValues(alpha: 0.4)),
                          const SizedBox(width: 4),
                          Text(
                            'Add task',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              color: AppColors.outline.withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                // Clickable gap to add new time point after this one
                GestureDetector(
                  onTap: () => _showAddTimePointDialog(afterIndex: index),
                  child: Container(
                    height: 20,
                    width: double.infinity,
                    color: Colors.transparent,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateTaskAtTimePoint(TimePoint tp) {
    final parts = tp.time.split(':');
    final h = int.parse(parts[0]);
    final m = int.parse(parts[1]);
    final date = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, h, m);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CreateTaskScreen(
        isModal: true,
        initialDueDate: date,
      ),
    );
  }

  Widget _buildTimePointActions(TimePoint tp) {
    return PopupMenuButton<String>(
      onSelected: (action) {
        if (action == 'rename') {
          _showRenameTimePointDialog(tp);
        } else if (action == 'delete') {
          _removeTimePoint(tp.id);
        }
      },
      itemBuilder: (_) => [
        const PopupMenuItem(value: 'rename', child: Text('Rename')),
        const PopupMenuItem(value: 'delete', child: Text('Delete')),
      ],
      child: Icon(
        Icons.more_horiz,
        size: 16,
        color: AppColors.outline.withValues(alpha: 0.5),
      ),
    );
  }

  void _showAddTimePointDialog({int? afterIndex}) {
    // Default time: after the previous point +1h, or 09:00
    String defaultTime = '09:00';
    if (afterIndex != null && afterIndex < _timePoints.length) {
      final prev = _timePoints[afterIndex].time;
      final parts = prev.split(':');
      final h = (int.parse(parts[0]) + 1).clamp(0, 23);
      defaultTime = '${h.toString().padLeft(2, '0')}:00';
    }
    final controller = TextEditingController(text: defaultTime);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Time Point'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'HH:mm (e.g. 14:30)',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              final time = controller.text.trim();
              if (RegExp(r'^\d{2}:\d{2}$').hasMatch(time)) {
                _addTimePoint(time);
              }
              Navigator.pop(ctx);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showRenameTimePointDialog(TimePoint tp) {
    final controller = TextEditingController(text: tp.label);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Rename Time Point'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Label (e.g. Morning)',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              _renameTimePoint(tp.id, controller.text.trim());
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
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
      padding: const EdgeInsets.all(40),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Decorative blur: top-right blue circle (simulates blur-3xl)
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.3),
                    AppColors.primary.withValues(alpha: 0.1),
                    AppColors.primary.withValues(alpha: 0.0),
                  ],
                  stops: const [0.0, 0.4, 1.0],
                ),
              ),
            ),
          ),
          // Decorative blur: bottom-left orange circle (simulates blur-2xl)
          Positioned(
            bottom: -48,
            left: -48,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.secondaryContainer.withValues(alpha: 0.3),
                    AppColors.secondaryContainer.withValues(alpha: 0.1),
                    AppColors.secondaryContainer.withValues(alpha: 0.0),
                  ],
                  stops: const [0.0, 0.4, 1.0],
                ),
              ),
            ),
          ),
          // Quote content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.format_quote, size: 36, color: AppColors.primaryContainer),
              const SizedBox(height: 16),
              Text(
                '"${q['quote']}"',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.italic,
                  color: Colors.white,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                '— ${q['author']}'.toUpperCase(),
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryContainer,
                  letterSpacing: 3,
                ),
              ),
            ],
          ),
        ],
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
        initialDueDate: _selectedDate,
      ),
    );
  }

  Widget _buildFAB() {
    return _AnimatedFAB(onTap: _showCreateTaskSheet);
  }
}

// ═══════════════════════════════════════════════════════════════
// FAB 带 hover + press 动画
// ═══════════════════════════════════════════════════════════════
class _AnimatedFAB extends StatefulWidget {
  final VoidCallback onTap;
  const _AnimatedFAB({required this.onTap});

  @override
  State<_AnimatedFAB> createState() => _AnimatedFABState();
}

class _AnimatedFABState extends State<_AnimatedFAB>
    with TickerProviderStateMixin {
  late AnimationController _pressCtrl;
  late Animation<double> _pressScale;
  late AnimationController _expandCtrl;
  late Animation<double> _expandAnim;
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    _pressCtrl = AnimationController(
      duration: const Duration(milliseconds: 120),
      vsync: this,
    );
    _pressScale = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _pressCtrl, curve: Curves.easeInOut),
    );
    _expandCtrl = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _expandAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _expandCtrl, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    _expandCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _hovered = true);
        _expandCtrl.forward();
      },
      onExit: (_) {
        setState(() => _hovered = false);
        _expandCtrl.reverse();
      },
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
            child: child,
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: _hovered
                  ? AppColors.primaryContainer
                  : AppColors.primary,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 32,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.add, color: Colors.white, size: 28),
                ClipRect(
                  child: AnimatedBuilder(
                    animation: _expandAnim,
                    builder: (_, child) => SizedBox(
                      width: 120 * _expandAnim.value,
                      child: child,
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 12),
                      child: Text(
                        'Create Event',
                        maxLines: 1,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
// 紧凑任务卡片（标题 + 标签）
// ═══════════════════════════════════════════════════════════════
class _CompactTaskCard extends StatelessWidget {
  final Task task;
  final Color Function(String) categoryColor;
  final Color Function(String) tagColor;
  const _CompactTaskCard({
    super.key,
    required this.task,
    required this.categoryColor,
    required this.tagColor,
  });

  String _cap(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    final tagNames = task.category
        .split('|')
        .where((t) => t.trim().isNotEmpty)
        .map((t) => t.trim())
        .toList();
    if (task.priority != 'low') tagNames.add(task.priority);

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(10),
          border: Border(
            left: BorderSide(
              color: categoryColor(task.category),
              width: 3,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.onSurface.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface,
              ),
            ),
            if (tagNames.isNotEmpty) ...[
              const SizedBox(height: 6),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: tagNames.map((t) {
                  return _Tag(_cap(t), color: tagColor(t));
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── 标签组件 ──────────────────────────────────────────────

class _Tag extends StatelessWidget {
  final String label;
  final Color? color;
  const _Tag(this.label, {this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: c,
        ),
      ),
    );
  }
}
