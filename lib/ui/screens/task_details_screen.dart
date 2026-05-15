import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../data/providers/task_provider.dart';
import '../../data/providers/tag_provider.dart';
import '../../data/models/task_models.dart';
import '../widgets/responsive_navigation.dart';
import '../widgets/manage_tags_dialog.dart';

// ─────────────────────────────────────────────────────────────────────────────
// 可编辑子任务行的本地状态模型
// ─────────────────────────────────────────────────────────────────────────────
class _SubTaskRow {
  final String? id; // null = 新建未保存
  final TextEditingController controller;
  bool completed;
  bool isSaving;

  _SubTaskRow({
    this.id,
    required String title,
    this.completed = false,
    this.isSaving = false,
  }) : controller = TextEditingController(text: title);

  void dispose() => controller.dispose();
}

// ─────────────────────────────────────────────────────────────────────────────
class TaskDetailsScreen extends ConsumerStatefulWidget {
  final String taskId;
  final String? initialDate;

  const TaskDetailsScreen({super.key, required this.taskId, this.initialDate});

  @override
  ConsumerState<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends ConsumerState<TaskDetailsScreen>
    with SingleTickerProviderStateMixin {
  // ── 任务状态 ─────────────────────────────────────────────
  bool _isLoading = true;
  Task? _task;
  bool get _isNewTask => widget.taskId == 'new';

  // ── 编辑控制器 ───────────────────────────────────────────
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _newSubTaskController = TextEditingController();

  // ── 属性选择状态 ──────────────────────────────────────────
  String _selectedPriority = 'medium';
  final List<String> _selectedTags = [];
  DateTime? _selectedDueDate;
  String? _hoveredPriority;

  // ── 子任务 ────────────────────────────────────────────────
  // 声明时立即初始化，避免 Web DDC 热重载后变为 undefined
  final List<_SubTaskRow> _subTaskRows = [];
  bool _subTasksLoading = false;
  bool _isAddingSubTask = false;
  final FocusNode _newSubTaskFocus = FocusNode();
  

  // ── 动画 ──────────────────────────────────────────────────
  AnimationController? _fadeCtrl;
  Animation<double>? _fadeAnim;

  // ── 常量 (参考 UI/task_details/code.html) ─────────────────
  static const _primaryBlue = Color(0xFF004AC6);
  static const _accentBlue = Color(0xFF2563EB);
  static const _onSurface = Color(0xFF1A1C1D);
  static const _outline = Color(0xFF737686);
  static const _surfaceLow = Color(0xFFF3F3F5);
  static const _surfaceLowest = Color(0xFFFFFFFF);
  static const _outlineVariant = Color(0xFFC3C6D7);
  static const _background = Color(0xFFF9F9FB);

  // ─────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl!, curve: Curves.easeOut);
    _loadTask();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    _newSubTaskController.dispose();
    _newSubTaskFocus.dispose();
    _fadeCtrl?.dispose();
    for (final row in _subTaskRows) {
      row.dispose();
    }
    super.dispose();
  }

  // ── 数据加载 ─────────────────────────────────────────────
  Future<void> _loadTask() async {
    try {
      if (_isNewTask) {
        // 新建任务模式：初始化空状态，支持从路由接收初始日期
        final initialDate = widget.initialDate;
        setState(() {
          _titleController.text = '';
          _notesController.text = '';
          _selectedPriority = 'medium';
          _selectedTags.clear();
          _selectedDueDate =
              initialDate != null ? DateTime.tryParse(initialDate) : null;
        });
      } else {
        // 编辑已有任务模式
        final task = await ref
            .read(taskNotifierProvider.notifier)
            .getTaskById(widget.taskId);
        if (!mounted) return;
        setState(() {
          _task = task;
          _titleController.text = task.title;
          _notesController.text = task.description ?? '';
          _selectedPriority =
              task.priority.isEmpty ? 'medium' : task.priority.toLowerCase();

          // 用 category 初始化 tags（| 分隔）
          _selectedTags.clear();
          if (task.category.isNotEmpty) {
            _selectedTags.addAll(
              task.category.split('|').where((t) => t.trim().isNotEmpty),
            );
          }

          _selectedDueDate =
              task.dueDate != null ? DateTime.tryParse(task.dueDate!) : null;
        });

        // 初始化子任务行（先用任务自带的 subTasks，再异步刷新）
        _initSubTaskRowsFrom(task.subTasks);

        // 异步拉取最新子任务
        await _loadSubTasks();
      }
    } catch (_) {
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
        _fadeCtrl?.forward();
      }
    }
  }

  void _initSubTaskRowsFrom(List<SubTask> subTasks) {
    for (final row in _subTaskRows) {
      row.dispose();
    }
    _subTaskRows.clear();
    for (final st in subTasks) {
      _subTaskRows.add(_SubTaskRow(
        id: st.id,
        title: st.title,
        completed: st.completed,
      ));
    }
    if (mounted) setState(() {});
  }

  Future<void> _loadSubTasks() async {
    if (!mounted) return;
    setState(() => _subTasksLoading = true);
    try {
      final service = await ref.read(taskServiceProvider.future);
      final subTasks = await service.getSubTasks(widget.taskId);
      if (!mounted) return;
      _initSubTaskRowsFrom(subTasks);
    } catch (_) {
    } finally {
      if (mounted) setState(() => _subTasksLoading = false);
    }
  }

  // ── 保存任务 ─────────────────────────────────────────────
  Future<void> _saveChanges() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      _showSnack('Please enter a task title', isError: true);
      return;
    }

    final tagsStr = _selectedTags.isNotEmpty ? _selectedTags.join('|') : 'work';

    try {
      if (_isNewTask) {
        // 新建任务模式
        final taskService = await ref.read(taskServiceProvider.future);
        final createdTask = await taskService.createTask(
          TaskCreate(
            title: title,
            description: _notesController.text.isEmpty ? null : _notesController.text,
            priority: _selectedPriority,
            category: tagsStr,
            dueDate: _selectedDueDate?.toIso8601String().split('T').first,
            projectId: null,
          ),
        );
        if (!mounted) return;
        _showSnack('Task created successfully', isError: false);
        context.go('/tasks');
      } else {
        // 编辑已有任务模式
        if (_task == null) return;
        final update = TaskUpdate(
          title: title,
          description: _notesController.text.isEmpty ? null : _notesController.text,
          priority: _selectedPriority,
          category: tagsStr,
          dueDate: _selectedDueDate?.toIso8601String().split('T').first,
        );
        await ref
            .read(taskNotifierProvider.notifier)
            .updateTask(_task!.id, update);
        if (!mounted) return;
        _showSnack('Task updated successfully', isError: false);
        context.go('/tasks');
      }
    } catch (e) {
      if (!mounted) return;
      _showSnack('Failed to save task: $e', isError: true);
    }
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: isError ? const Color(0xFFBA1A1A) : _primaryBlue,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
  }

  // ── 子任务操作 ────────────────────────────────────────────

  void _addSubTaskIfNotEmpty() {
    final title = _newSubTaskController.text.trim();
    if (title.isNotEmpty) {
      _addSubTask();
    } else {
      setState(() {
        _isAddingSubTask = false;
        _newSubTaskController.clear();
      });
    }
  }



  Future<void> _addSubTask() async {
    final title = _newSubTaskController.text.trim();
    if (title.isEmpty) {
      setState(() => _isAddingSubTask = false);
      return;
    }

    final service = await ref.read(taskServiceProvider.future);
    final placeholder = _SubTaskRow(
      title: title,
      completed: false,
      isSaving: true,
    );
    setState(() {
      _subTaskRows.add(placeholder);
      _newSubTaskController.clear();
      _isAddingSubTask = false;
    });

    try {
      final created = await service.createSubTask(
        widget.taskId,
        SubTaskCreate(title: title, order: _subTaskRows.length),
      );
      final idx = _subTaskRows.indexOf(placeholder);
      if (!mounted) return;
      if (idx >= 0) {
        placeholder.dispose();
        setState(() {
          _subTaskRows[idx] = _SubTaskRow(
            id: created.id,
            title: created.title,
            completed: created.completed,
          );
        });
      }
    } catch (_) {
      if (!mounted) return;
      final idx = _subTaskRows.indexOf(placeholder);
      if (idx >= 0) {
        setState(() => _subTaskRows.removeAt(idx));
        placeholder.dispose();
      }
      _showSnack('Failed to add sub-task', isError: true);
    }
  }

  Future<void> _toggleSubTask(int idx) async {
    if (idx < 0 || idx >= _subTaskRows.length) return;
    final row = _subTaskRows[idx];
    if (row.id == null) return;

    final prevCompleted = row.completed;
    setState(() => row.completed = !prevCompleted);

    try {
      final service = await ref.read(taskServiceProvider.future);
      await service.toggleSubTaskCompletion(widget.taskId, row.id!);
    } catch (_) {
      if (!mounted) return;
      setState(() => row.completed = prevCompleted);
      _showSnack('Failed to toggle sub-task', isError: true);
    }
  }

  Future<void> _updateSubTaskTitle(int idx) async {
    if (idx < 0 || idx >= _subTaskRows.length) return;
    final row = _subTaskRows[idx];
    if (row.id == null) return;
    final newTitle = row.controller.text.trim();
    if (newTitle.isEmpty) {
      await _deleteSubTask(idx);
      return;
    }

    try {
      final service = await ref.read(taskServiceProvider.future);
      await service.updateSubTask(
        widget.taskId,
        row.id!,
        SubTaskUpdate(title: newTitle),
      );
    } catch (_) {
      if (!mounted) return;
      _showSnack('Failed to update sub-task', isError: true);
    }
  }

  Future<void> _deleteSubTask(int idx) async {
    if (idx < 0 || idx >= _subTaskRows.length) return;
    final row = _subTaskRows[idx];
    setState(() => _subTaskRows.removeAt(idx));
    if (row.id == null) {
      row.dispose();
      return;
    }

    try {
      final service = await ref.read(taskServiceProvider.future);
      await service.deleteSubTask(widget.taskId, row.id!);
      row.dispose();
    } catch (_) {
      if (!mounted) return;
      _showSnack('Failed to delete sub-task', isError: true);
      // 回滚
      setState(() => _subTaskRows.insert(idx, row));
    }
  }

  void _showDeleteSubTaskDialog(int idx) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _surfaceLowest,
        title: const Text('Delete Sub-task'),
        content: const Text('Are you sure you want to delete this sub-task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteSubTask(idx);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _updateSubTaskOrder() async {
    try {
      final service = await ref.read(taskServiceProvider.future);
      for (int i = 0; i < _subTaskRows.length; i++) {
        final row = _subTaskRows[i];
        if (row.id != null) {
          await service.updateSubTask(
            widget.taskId,
            row.id!,
            SubTaskUpdate(
              title: row.controller.text.trim(),
              completed: row.completed,
              order: i + 1,
            ),
          );
        }
      }
    } catch (_) {
      _showSnack('Failed to update order', isError: true);
    }
  }

  // ── 日期选择 ──────────────────────────────────────────────
  Future<void> _selectDueDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: _primaryBlue,
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: _onSurface,
          ),
        ),
        child: child!,
      ),
    );
    if (date != null && mounted) setState(() => _selectedDueDate = date);
  }

  // ── 辅助 ─────────────────────────────────────────────────
  String _formatCreatedAt(String createdAt) {
    try {
      final date = DateTime.parse(createdAt);
      final diff = DateTime.now().difference(date);
      if (diff.inDays == 0) return 'today';
      if (diff.inDays == 1) return 'yesterday';
      if (diff.inDays < 7) return '${diff.inDays} days ago';
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (_) {
      return createdAt;
    }
  }

  int get _completedCount =>
      _subTaskRows.where((r) => r.completed).length;

  // ═══════════════════════════════════════════════════════════
  //  BUILD
  // ═══════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    final fadeOpacity = (_fadeAnim ?? const AlwaysStoppedAnimation(1.0));

    if (_isLoading) {
      return ResponsiveNavigation(
        currentPage: 'tasks',
        child: const Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: CircularProgressIndicator(color: _primaryBlue),
          ),
        ),
      );
    }

    if (!_isNewTask && _task == null) {
      return ResponsiveNavigation(
        currentPage: 'tasks',
        child: _buildNotFound(),
      );
    }

    return ResponsiveNavigation(
      currentPage: 'tasks',
      child: Scaffold(
        backgroundColor: _background,
        body: FadeTransition(
          opacity: fadeOpacity,
          child: Column(
            children: [
              Expanded(child: _buildBody()),
              if (!_isLoading) _buildBottomBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotFound() => Scaffold(
        backgroundColor: _background,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.search_off_rounded, size: 64, color: _outline),
              const SizedBox(height: 16),
              const Text('Task not found',
                  style: TextStyle(fontSize: 18, color: _outline)),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => context.go('/tasks'),
                child: const Text('Back to Tasks'),
              ),
            ],
          ),
        ),
      );

  // ── 主体 ───────────────────────────────────────────────────
  Widget _buildBody() {
    return LayoutBuilder(builder: (ctx, constraints) {
      final isWide = constraints.maxWidth > 700;
      return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1152),
          child: isWide ? _buildWideLayout() : _buildNarrowLayout(),
        ),
      );
    });
  }

  // 宽屏：左主内容 + 右侧边栏
  Widget _buildWideLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 120),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 主内容区
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitleCard(),
                const SizedBox(height: 32),
                _buildSubTasksSection(),
                const SizedBox(height: 32),
                _buildNotesSection(),
              ],
            ),
          ),
          const SizedBox(width: 48),
          // 侧边栏
          SizedBox(
            width: 320,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildDueDateCard(),
                const SizedBox(height: 24),
                _buildPriorityCard(),
                const SizedBox(height: 24),
                _buildTagsCard(),
                const SizedBox(height: 24),
                _buildResourcesCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 窄屏：纵向堆叠
  Widget _buildNarrowLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitleCard(),
          const SizedBox(height: 24),
          _buildDueDateCard(),
          const SizedBox(height: 16),
          _buildPriorityCard(),
          const SizedBox(height: 16),
          _buildTagsCard(),
          const SizedBox(height: 24),
          _buildResourcesCard(),
          const SizedBox(height: 24),
          _buildSubTasksSection(),
          const SizedBox(height: 24),
          _buildNotesSection(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ── 标题卡片 ───────────────────────────────────────────────
  Widget _buildTitleCard() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: _surfaceLowest,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _titleController,
            style: const TextStyle(
              fontSize: 44,
              fontWeight: FontWeight.w800,
              fontFamily: 'Manrope',
              color: _onSurface,
              letterSpacing: -0.5,
              height: 1.15,
            ),
            maxLines: null,
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                borderSide: BorderSide.none,
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                borderSide: BorderSide.none,
              ),
              filled: false,
              hintText: 'Task Title...',
              hintStyle: TextStyle(
                fontSize: 44,
                fontWeight: FontWeight.w800,
                fontFamily: 'Manrope',
                color: _outlineVariant,
                letterSpacing: -0.5,
              ),
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
          if (!_isNewTask && _task != null) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.schedule_rounded, size: 14, color: _outline),
                const SizedBox(width: 6),
                Text(
                  'Created ${_formatCreatedAt(_task!.createdAt)}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: _outline,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // ── Sub-Tasks ──────────────────────────────────────────────
  Widget _buildSubTasksSection() {
    final total = _subTaskRows.length;
    final done = _completedCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 标题行
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Text(
                  'Sub-tasks',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Manrope',
                    color: _onSurface,
                  ),
                ),
                if (_subTasksLoading) ...[
                  const SizedBox(width: 8),
                  const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: _primaryBlue,
                    ),
                  ),
                ],
              ],
            ),
            Text(
              '$done of $total Completed',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: _outline,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // 子任务列表容器
        Container(
          decoration: BoxDecoration(
            color: _surfaceLowest,
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Column(
            children: [
              // 现有子任务行
              for (int i = 0; i < _subTaskRows.length; i++)
                _buildSubTaskRow(i),

              // Add 切换动画
              AnimatedCrossFade(
                firstChild: _buildAddSubTaskBtn(),
                secondChild: _buildInlineAddRow(),
                crossFadeState: _isAddingSubTask
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 200),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSubTaskRow(int idx) {
    if (idx < 0 || idx >= _subTaskRows.length) {
      return const SizedBox.shrink();
    }
    final row = _subTaskRows[idx];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _toggleSubTask(idx),
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: row.completed ? _primaryBlue : Colors.transparent,
                border: Border.all(
                  color: row.completed ? _primaryBlue : _outlineVariant,
                  width: 2,
                ),
              ),
              child: row.completed
                  ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: row.controller,
              style: TextStyle(
                fontSize: 15,
                color: row.completed ? _outline : _onSurface,
                decoration: row.completed
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                fontWeight: FontWeight.w500,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              onSubmitted: (_) => _updateSubTaskTitle(idx),
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () => _showDeleteSubTaskDialog(idx),
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.red.withAlpha(15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.delete_outline_rounded,
                  size: 16, color: Color(0xFFBA1A1A)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInlineAddRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      child: Row(
        children: [
          const Icon(Icons.add_circle_rounded, color: _primaryBlue, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _newSubTaskController,
              focusNode: _newSubTaskFocus,
              autofocus: true,
              style: const TextStyle(
                fontSize: 15,
                color: _primaryBlue,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide.none,
                ),
                disabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: _primaryBlue.withAlpha(10),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                hintText: 'Add another sub-task...',
                hintStyle: TextStyle(
                  fontSize: 15,
                  color: _outlineVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onSubmitted: (_) => _addSubTask(),
              onTapOutside: (_) => _addSubTaskIfNotEmpty(),
            ),
          ),
          GestureDetector(
            onTap: () => _addSubTask(),
            child: const Icon(Icons.add_circle_rounded,
                size: 20, color: _primaryBlue),
          ),
        ],
      ),
    );
  }

  Widget _buildAddSubTaskBtn() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
      child: _PressScale(
        onTap: () {
          // 先保存所有正在编辑的子任务
          for (int i = 0; i < _subTaskRows.length; i++) {
            _updateSubTaskTitle(i);
          }
          setState(() => _isAddingSubTask = true);
          WidgetsBinding.instance
              .addPostFrameCallback((_) => _newSubTaskFocus.requestFocus());
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(
              color: _outlineVariant.withAlpha(60),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_circle_rounded, size: 20, color: _primaryBlue),
              SizedBox(width: 8),
              Text(
                'Add another sub-task...',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: _outlineVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Notes ──────────────────────────────────────────────────
  Widget _buildNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Notes',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            fontFamily: 'Manrope',
            color: _onSurface,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: _surfaceLowest,
            borderRadius: BorderRadius.circular(24),
          ),
          child: TextField(
            controller: _notesController,
            maxLines: 8,
            style: const TextStyle(
              fontSize: 15,
              color: _onSurface,
              height: 1.65,
            ),
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(24)),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(24)),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(24)),
                borderSide: BorderSide.none,
              ),
              filled: false,
              fillColor: Colors.transparent,
              hintText: 'Add more details, links, or resources here...',
              hintStyle: TextStyle(
                fontSize: 15,
                color: _outlineVariant,
                height: 1.65,
              ),
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
      ],
    );
  }

  // ── Due Date 卡片 ─────────────────────────────────────────
  Widget _buildDueDateCard() {
    final hasDate = _selectedDueDate != null;
    final displayDate = _selectedDueDate ?? DateTime.now();
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _surfaceLowest,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'DUE DATE',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: _outline,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          // 日期显示行：日期文字 + 日历图标按钮
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: _selectDueDate,
                  child: Text(
                    hasDate
                        ? DateFormat('MMM dd, yyyy').format(_selectedDueDate!)
                        : 'Select date',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: _onSurface,
                      fontFamily: 'Manrope',
                    ),
                  ),
                ),
              ),
              _PressScale(
                scaleTo: 0.85,
                onTap: _selectDueDate,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _primaryBlue.withAlpha(18),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.calendar_today_rounded,
                      color: _primaryBlue, size: 18),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // 小型日历（始终显示）
          _buildMiniCalendar(displayDate),
        ],
      ),
    );
  }

  Widget _buildMiniCalendar(DateTime d) {
    final firstDay = DateTime(d.year, d.month, 1);
    final daysInMonth = DateTime(d.year, d.month + 1, 0).day;
    final startWeekday = firstDay.weekday; // 1=Mon, 7=Sun
    const weekHeaders = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final today = DateTime.now();
    final hasSelected = _selectedDueDate != null;
    final selectedDay = _selectedDueDate?.day;

    return Column(
      children: [
        // 周头
        Row(
          children: List.generate(7, (i) {
            final isSat = i == 5;
            return Expanded(
              child: Center(
                child: Text(
                  weekHeaders[i],
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isSat ? FontWeight.w700 : FontWeight.w600,
                    color: isSat ? _primaryBlue : _outline,
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        // 日期格
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 7,
          childAspectRatio: 0.95,
          children: List.generate((startWeekday - 1) + daysInMonth, (i) {
            if (i < startWeekday - 1) return const SizedBox.shrink();
            final day = i - (startWeekday - 1) + 1;
            final isSelectedDay = hasSelected && day == selectedDay;
            final isToday = !hasSelected &&
                day == today.day &&
                d.year == today.year &&
                d.month == today.month;
            final highlight = isSelectedDay || isToday;

            return _PressScale(
              scaleTo: 0.85,
              onTap: () => setState(
                  () => _selectedDueDate = DateTime(d.year, d.month, day)),
              child: Material(
                color: Colors.transparent,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => setState(() =>
                      _selectedDueDate = DateTime(d.year, d.month, day)),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelectedDay
                          ? _primaryBlue
                          : (isToday ? _primaryBlue.withAlpha(25) : Colors.transparent),
                    ),
                    child: Center(
                      child: Text(
                        '$day',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: highlight ? FontWeight.w700 : FontWeight.w400,
                          color: isSelectedDay
                              ? Colors.white
                              : (isToday ? _primaryBlue : _onSurface),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  // ── Priority 卡片 ─────────────────────────────────────────
  Widget _buildPriorityCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _surfaceLowest,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PRIORITY',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: _outline,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: _surfaceLow,
              borderRadius: BorderRadius.circular(9999),
            ),
            child: Row(
              children: [
                _priorityBtn('Low', value: 'low'),
                _priorityBtn('Med', value: 'medium'),
                _priorityBtn('High', value: 'high'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _priorityBtn(String label, {required String value}) {
    final isSelected = _selectedPriority == value;
    final isHovered = _hoveredPriority == value && !isSelected;
    return Expanded(
      child: MouseRegion(
        onEnter: (_) => setState(() => _hoveredPriority = value),
        onExit: (_) => setState(() => _hoveredPriority = null),
        child: _PressScale(
          onTap: () => setState(() => _selectedPriority = value),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? _surfaceLowest : Colors.transparent,
              borderRadius: BorderRadius.circular(9999),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: const Color(0xFF1E293B).withAlpha(13),
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isSelected
                      ? _primaryBlue
                      : (isHovered ? _onSurface : _outline),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Tags 卡片 ─────────────────────────────────────────────
  Widget _buildTagsCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _surfaceLowest,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'TAGS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: _outline,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              // 已选标签（带 × 删除）
              for (final tag in _selectedTags)
                _tagChip(tag, selected: true),

              // 添加标签按钮
              _PressScale(
                onTap: _showTagPicker,
                scaleTo: 0.8,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _surfaceLow,
                  ),
                  child: const Icon(Icons.add_rounded,
                      size: 16, color: _outline),
                ),
              ),
            ],
          ),
          if (_selectedTags.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 4),
              child: Text(
                'No tags yet. Tap + to add.',
                style: TextStyle(fontSize: 12, color: _outlineVariant),
              ),
            ),
        ],
      ),
    );
  }

  Widget _tagChip(String tag, {required bool selected}) {
    final color = ref.read(tagProviderProvider.notifier).colorForTag(tag);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha(22),
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            tag,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(width: 4),
          _PressScale(
            scaleTo: 0.75,
            onTap: () => setState(() => _selectedTags.remove(tag)),
            child: Icon(Icons.close_rounded, size: 13, color: color),
          ),
        ],
      ),
    );
  }

  void _showTagPicker() {
    final customController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Consumer(
          builder: (ctx, ref, _) {
            final tagProv = ref.watch(tagProviderProvider);
            final allTagNames = tagProv.allTags.map((t) => t.name).toList();
            final visibleTagNames = tagProv.visibleTags.map((t) => t.name).toList();
            return Padding(
              padding: EdgeInsets.fromLTRB(24, 20, 24, MediaQuery.of(ctx).viewInsets.bottom + 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Select Tags',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Manrope',
                          ),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          Navigator.pop(ctx);
                          ManageTagsDialog.show(context);
                        },
                        icon: const Icon(Icons.tune_rounded, size: 16),
                        label: const Text('Manage'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: customController,
                          style: const TextStyle(fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'Custom tag...',
                            hintStyle: const TextStyle(fontSize: 14, color: _outlineVariant),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(9999),
                              borderSide: const BorderSide(color: _outlineVariant),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(9999),
                              borderSide: const BorderSide(color: _outlineVariant),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(9999),
                              borderSide: const BorderSide(color: _primaryBlue),
                            ),
                            isDense: true,
                          ),
                          onSubmitted: (v) {
                            final name = v.trim();
                            if (name.isNotEmpty && !_selectedTags.contains(name)) {
                              ref.read(tagProviderProvider.notifier).addTag(name);
                              setModalState(() {
                                _selectedTags.add(name);
                              });
                              setState(() {});
                              customController.clear();
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      _PressScale(
                        scaleTo: 0.85,
                        onTap: () {
                          final name = customController.text.trim();
                          if (name.isNotEmpty && !_selectedTags.contains(name)) {
                            ref.read(tagProviderProvider.notifier).addTag(name);
                            setModalState(() {
                              _selectedTags.add(name);
                            });
                            setState(() {});
                            customController.clear();
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: _primaryBlue,
                            borderRadius: BorderRadius.circular(9999),
                          ),
                          child: const Icon(Icons.add_rounded, size: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      ...visibleTagNames,
                      ..._selectedTags.where((t) => !allTagNames.contains(t)),
                    ].map((tag) {
                      final isSelected = _selectedTags.contains(tag);
                      return _PressScale(
                        onTap: () {
                          setModalState(() {
                            if (isSelected) {
                              _selectedTags.remove(tag);
                            } else {
                              _selectedTags.add(tag);
                            }
                          });
                          setState(() {});
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? _primaryBlue : _surfaceLow,
                            borderRadius: BorderRadius.circular(9999),
                          ),
                          child: Text(
                            tag,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? Colors.white : _onSurface,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text('Done', style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ── Resources 卡片 ───────────────────────────────────────
  Widget _buildResourcesCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _surfaceLowest,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'RESOURCES',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: _outline,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          // 空态提示
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 28),
            decoration: BoxDecoration(
              border: Border.all(
                color: _outlineVariant.withAlpha(60),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Icon(Icons.cloud_upload_outlined,
                    size: 28, color: _outlineVariant),
                const SizedBox(height: 8),
                const Text(
                  'Drop files or tap to browse',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: _outline,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── 底部操作栏 ──────────────────────────────────────────────
  Widget _buildBottomBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: _outlineVariant.withAlpha(26),
            width: 0.5,
          ),
        ),
      ),
      child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1152),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(32, 16, 32, 24),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                // 自动保存提示
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.info_outline_rounded,
                        size: 14, color: _outlineVariant),
                    const SizedBox(width: 6),
                    Text(
                      'Last autosaved at ${DateFormat('h:mm a').format(DateTime.now())}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: _outlineVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                // 按钮区域
                Row(
                  children: [
                    // Discard 按钮
                    _PressScale(
                      onTap: () => context.go('/tasks'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 14),
                        decoration: BoxDecoration(
                          color: _surfaceLow,
                          borderRadius: BorderRadius.circular(9999),
                        ),
                        child: const Text(
                          'Discard',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: _onSurface,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Update Task 按钮
                    _PressScale(
                      onTap: _saveChanges,
                      scaleTo: 0.95,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 14),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [_primaryBlue, _accentBlue],
                          ),
                          borderRadius: BorderRadius.circular(9999),
                        ),
                        child: const Text(
                          'Update Task',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
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
}

// ═══════════════════════════════════════════════════════════════
// 通用按压缩放组件
// ═══════════════════════════════════════════════════════════════
class _PressScale extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double scaleTo;

  const _PressScale({
    required this.child,
    this.onTap,
    this.scaleTo = 0.94,
  });

  @override
  State<_PressScale> createState() => _PressScaleState();
}

class _PressScaleState extends State<_PressScale>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: widget.scaleTo).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.onTap != null ? (_) => _ctrl.forward() : null,
      onTapUp: widget.onTap != null
          ? (_) {
              _ctrl.reverse();
              Future.delayed(const Duration(milliseconds: 120), () {
                widget.onTap?.call();
              });
            }
          : null,
      onTapCancel: widget.onTap != null ? () => _ctrl.reverse() : null,
      child: AnimatedBuilder(
        animation: _scaleAnim,
        builder: (_, child) => Transform.scale(
          scale: _scaleAnim.value,
          child: child,
        ),
        child: widget.child,
      ),
    );
  }
}
