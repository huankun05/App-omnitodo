import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/providers/task_provider.dart';
import '../../data/providers/project_provider.dart';
import '../../data/models/task_models.dart';
import '../../data/models/project_models.dart';
import '../../core/providers/theme_provider.dart';
import '../widgets/app_widgets.dart';

class CreateTaskScreen extends ConsumerStatefulWidget {
  final String? mode;
  final String? attachment;
  /// 是否以 modal bottom sheet 方式弹出（true: 关闭时 pop，false: go('/tasks')）
  final bool isModal;
  /// 创建任务时默认选中的项目 ID
  final String? initialProjectId;
  
  const CreateTaskScreen({
    super.key,
    this.mode,
    this.attachment,
    this.isModal = false,
    this.initialProjectId,
  });

  @override
  ConsumerState<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends ConsumerState<CreateTaskScreen>
    with SingleTickerProviderStateMixin {
  final _taskController = TextEditingController();
  final _notesController = TextEditingController();
  bool _isSubmitting = false;

  // 深度编辑模式：选中编辑的任务
  String? _selectedTaskId;

  // 浮动卡片动画控制器
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  // ── 标签系统 ─────────────────────────────────────────────
  final List<_TagDefinition> _allTagDefs = [
    const _TagDefinition(name: 'Today', icon: Icons.calendar_today, isDefault: true),
    const _TagDefinition(name: 'Work', icon: Icons.sell, isDefault: true),
    const _TagDefinition(name: 'Remind me', icon: Icons.notifications_active, isDefault: true),
    const _TagDefinition(name: 'High Priority', icon: Icons.flag, isDefault: true),
  ];
  final Set<String> _hiddenTagNames = {};
  final Set<String> _activeTags = {'Work'};

  List<_TagDefinition> get _visibleTagDefs =>
      _allTagDefs.where((t) => !_hiddenTagNames.contains(t.name)).toList();

  // 优先级选择
  String _selectedPriority = 'medium';

  // 截止日期
  DateTime? _dueDate;

  // 当前选中的项目
  String? _selectedProjectId;
  // Project 选择器按钮的 key
  final GlobalKey _projectButtonKey = GlobalKey();

  // 子任务列表（来自后端）
  List<SubTask> _subTasks = [];
  final _subTaskController = TextEditingController();

  bool get _isDeepEditMode => widget.mode == 'deep';

  @override
  void initState() {
    super.initState();
    
    // 初始化默认项目
    _selectedProjectId = widget.initialProjectId;
    
    // 如果有 attachment 参数，保持到 deep 模式中使用
    if (widget.attachment != null) {
      // attachment 参数由 deep edit 模式处理
    }

    // 初始化浮动卡片动画
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    ));

    // 启动时自动聚焦到输入框
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _slideController.forward();
      FocusScope.of(context).requestFocus(FocusNode());
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    _taskController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _toggleTag(String tag) {
    setState(() {
      if (_activeTags.contains(tag)) {
        _activeTags.remove(tag);
      } else {
        _activeTags.add(tag);
      }
    });
  }

  void _selectPriority(String priority) {
    setState(() {
      _selectedPriority = priority;
      if (priority == 'high') {
        _activeTags.add('High Priority');
      } else {
        _activeTags.remove('High Priority');
      }
    });
  }

  void _addCustomTag() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add New Tag'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Enter tag name',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (value) {
            final name = value.trim();
            if (name.isNotEmpty && !_allTagDefs.any((t) => t.name == name)) {
              setState(() {
                _allTagDefs.add(_TagDefinition(name: name, icon: Icons.label));
                _activeTags.add(name);
              });
            }
            Navigator.pop(ctx);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty && !_allTagDefs.any((t) => t.name == name)) {
                setState(() {
                  _allTagDefs.add(_TagDefinition(name: name, icon: Icons.label));
                  _activeTags.add(name);
                });
              }
              Navigator.pop(ctx);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _hideTag(String tag) {
    setState(() {
      _hiddenTagNames.add(tag);
      _activeTags.remove(tag);
    });
  }

  void _showManageTagsDialog() {
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Manage Tags'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _allTagDefs.length,
              itemBuilder: (_, index) {
                final def = _allTagDefs[index];
                final isVisible = !_hiddenTagNames.contains(def.name);
                return SwitchListTile(
                  title: Row(
                    children: [
                      Icon(def.icon, size: 18),
                      const SizedBox(width: 8),
                      Text(def.name),
                    ],
                  ),
                  value: isVisible,
                  onChanged: (v) {
                    setState(() {
                      if (v) {
                        _hiddenTagNames.remove(def.name);
                      } else {
                        _hiddenTagNames.add(def.name);
                        _activeTags.remove(def.name);
                      }
                    });
                    setDialogState(() {});
                  },
                  secondary: def.isDefault
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.delete_outline, size: 18, color: Color(0xFFBA1A1A)),
                          onPressed: () {
                            setState(() {
                              _allTagDefs.removeAt(index);
                              _hiddenTagNames.remove(def.name);
                              _activeTags.remove(def.name);
                            });
                            setDialogState(() {});
                          },
                        ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Done'),
            ),
          ],
        ),
      ),
    );
  }

  void _createTask() async {
    final taskTitle = _taskController.text.trim();
    if (taskTitle.isEmpty) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // 确保数据库已初始化
      await ref.read(taskServiceProvider.future);

      // 根据选中的标签确定 category 和 priority
      String category = 'work';
      String priority = _selectedPriority;

      if (_activeTags.contains('Work')) category = 'work';
      if (_activeTags.contains('Today') && _dueDate == null) {
        _dueDate = DateTime.now();
      }

      final taskCreate = TaskCreate(
        title: taskTitle,
        description: _notesController.text.trim(),
        priority: priority,
        category: category,
        dueDate: _dueDate?.toIso8601String(),
        projectId: _selectedProjectId,
        // 如果是新任务创建，需要先创建任务再创建子任务
        subTasks: _selectedTaskId == null ? _subTasks
            .where((st) => st.id.isEmpty || st.id.startsWith('local_'))  // 只创建本地新增的子任务
            .map((st) => SubTaskCreate(title: st.title, order: st.order))
            .toList() : null,
      );

      await ref.read(taskNotifierProvider.notifier).addTask(taskCreate);

      if (!mounted) return;
      if (widget.isModal) {
        Navigator.of(context).pop();
      } else {
        context.go('/tasks');
      }
    } catch (e) {
      // 错误处理已通过 SnackBar 显示

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create task: $e'),
          duration: const Duration(seconds: 2),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  // 加载选中任务的子任务
  void _loadSubTasks(String taskId) async {
    try {
      final taskService = await ref.read(taskServiceProvider.future);
      final subTasks = await taskService.getSubTasks(taskId);
      setState(() {
        _subTasks = subTasks;
      });
    } catch (e) {
      // 错误处理
    }
  }

  /// 构建底部面板内容（modal 模式直接使用，无 Scaffold 包裹）
  Widget _buildProjectSelector() {
    return Consumer(
      builder: (context, ref, _) {
        final projectsAsync = ref.watch(projectNotifierProvider);
        final selectedId = _selectedProjectId;
        final selectedProject = projectsAsync.valueOrNull
            ?.where((p) => p.id == selectedId)
            .firstOrNull;

        return projectsAsync.when(
          loading: () => const SizedBox.shrink(),
          error: (_, _) => const SizedBox.shrink(),
          data: (projects) {
            if (projects.isEmpty) return const SizedBox.shrink();
            return GestureDetector(
              key: _projectButtonKey,
              onTap: () => _showProjectPicker(context, projects),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: selectedProject != null
                      ? Color(int.parse(selectedProject.color.replaceFirst('#', '0xFF')))
                          .withValues(alpha: 0.1)
                      : const Color(0xFFF1F1F4),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: selectedProject != null
                        ? Color(int.parse(selectedProject.color.replaceFirst('#', '0xFF')))
                            .withValues(alpha: 0.3)
                        : const Color(0xFFE0E0E6),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.folder_outlined,
                      size: 16,
                      color: selectedProject != null
                          ? Color(int.parse(selectedProject.color.replaceFirst('#', '0xFF')))
                          : const Color(0xFF737686),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      selectedProject?.name ?? 'No Project',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: selectedProject != null
                            ? Color(int.parse(selectedProject.color.replaceFirst('#', '0xFF')))
                            : const Color(0xFF737686),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      size: 16,
                      color: Color(0xFF737686),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  static const String _noProjectSentinel = '__no_project__';

  void _showProjectPicker(BuildContext context, List<Project> projects) {
    final RenderBox? renderBox = _projectButtonKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final List<PopupMenuEntry<String?>> items = [
      PopupMenuItem<String?>(
        enabled: false,
        height: 32,
        child: Text(
          'Select Project',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF737686),
            letterSpacing: 1,
          ),
        ),
      ),
      const PopupMenuDivider(),
      PopupMenuItem<String?>(
        value: _noProjectSentinel,
        child: Row(
          children: [
            const Icon(Icons.layers_outlined, size: 18, color: Color(0xFF737686)),
            const SizedBox(width: 12),
            Text(
              'No Project',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: _selectedProjectId == null ? const Color(0xFF004AC6) : const Color(0xFF1A1C1D),
              ),
            ),
            if (_selectedProjectId == null)
              const Spacer()
            else
              const Spacer(),
            if (_selectedProjectId == null)
              const Icon(Icons.check, size: 16, color: Color(0xFF004AC6)),
          ],
        ),
      ),
      const PopupMenuDivider(),
      if (projects.isEmpty)
        const PopupMenuItem<String?>(
          enabled: false,
          child: Text('No projects yet', style: TextStyle(fontSize: 13, color: Color(0xFF737686))),
        )
      else
        ...projects.map((p) {
          final color = Color(int.parse(p.color.replaceFirst('#', '0xFF')));
          final isSelected = _selectedProjectId == p.id;
          return PopupMenuItem<String?>(
            value: p.id,
            child: Row(
              children: [
                Icon(Icons.folder, size: 18, color: isSelected ? const Color(0xFF004AC6) : color),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    p.name,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? const Color(0xFF004AC6) : const Color(0xFF1A1C1D),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isSelected)
                  const Icon(Icons.check, size: 16, color: Color(0xFF004AC6)),
              ],
            ),
          );
        }),
    ];

    final buttonRect = renderBox.localToGlobal(Offset.zero) & renderBox.size;
    showMenu<String?>(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromLTWH(buttonRect.left, buttonRect.bottom, buttonRect.width, 0),
        Offset.zero & MediaQuery.of(context).size,
      ),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      items: items,
    ).then((value) {
      if (value == null) return; // dismissed
      if (value == _noProjectSentinel) {
        setState(() => _selectedProjectId = null);
      } else {
        setState(() => _selectedProjectId = value);
      }
    });
  }

  Widget _buildPanel(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 48,
      ),
      decoration: const BoxDecoration(
        color: Color(0xffffffff),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 拖拽指示器
          Container(
            width: 48,
            height: 6,
            margin: const EdgeInsets.only(bottom: 40),
            decoration: BoxDecoration(
              color: const Color(0xffc3c6d7).withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(3),
            ),
          ),

          // 输入区域和发送按钮
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 输入区域
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 任务标题输入框（带聚焦效果）
                    _AnimatedTextField(
                      controller: _taskController,
                      hint: 'What are you planning?',
                      onSubmitted: (_) => _createTask(),
                    ),

                    const SizedBox(height: 32),

                    // 上下文微芯片 + 项目选择器（带选中动画）
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        ..._visibleTagDefs.map((def) {
                          return _AnimatedChip(
                            icon: def.icon,
                            label: def.name,
                            isSelected: _activeTags.contains(def.name),
                            onTap: () => _toggleTag(def.name),
                            onLongPress: () => _hideTag(def.name),
                          );
                        }),
                        // 添加标签按钮
                        GestureDetector(
                          onTap: _addCustomTag,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerHigh,
                              borderRadius: BorderRadius.circular(9999),
                            ),
                            child: const Icon(Icons.add, size: 16, color: Color(0xff434655)),
                          ),
                        ),
                        // 管理标签按钮
                        GestureDetector(
                          onTap: _showManageTagsDialog,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerHigh,
                              borderRadius: BorderRadius.circular(9999),
                            ),
                            child: const Icon(Icons.tune, size: 16, color: Color(0xff434655)),
                          ),
                        ),
                        // 项目选择器
                        _buildProjectSelector(),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              // 发送按钮（带按压动画）
              _AnimatedSendButton(
                isLoading: _isSubmitting,
                onTap: _createTask,
              ),
            ],
          ),

          const SizedBox(height: 48),

          // 底部操作按钮和提示
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 详情编辑按钮
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.go('/task-details/new');
                },
                icon: const Icon(Icons.edit_note),
                color: const Color(0xff434655).withValues(alpha: 0.6),
                tooltip: 'Detail Edit',
              ),

              // 提示文字
              Text(
                'Press Enter to Create',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff434655).withValues(alpha: 0.4),
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Modal 模式：只返回底部面板，由 showModalBottomSheet 负责背景和动画
    if (widget.isModal) {
      return _buildPanel(context);
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // 背景模糊效果
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xfff9f9fb),
              ),
              child: Column(
                children: [
                  // 顶部导航栏（苹果风格液态玻璃效果）
                  ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        decoration: BoxDecoration(
                          // 液态玻璃渐变背景 - 非常通透
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: ref.watch(themeModeProvider).valueOrNull == ThemeMode.dark
                                ? [
                                    Colors.black.withValues(alpha: 0.15),
                                    Colors.black.withValues(alpha: 0.08),
                                  ]
                                : [
                                    Colors.white.withValues(alpha: 0.18),
                                    Colors.white.withValues(alpha: 0.1),
                                  ],
                          ),
                          boxShadow: [
                            // 外阴影 - 更柔和
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.06),
                              blurRadius: 20,
                              offset: const Offset(0, 4),
                              spreadRadius: -3,
                            ),
                            // 内发光 - 更细腻
                            BoxShadow(
                              color: ref.watch(themeModeProvider).valueOrNull == ThemeMode.dark
                                  ? Colors.white.withValues(alpha: 0.03)
                                  : Colors.white.withValues(alpha: 0.06),
                              blurRadius: 8,
                              spreadRadius: 0,
                              offset: const Offset(0, 0),
                            ),
                          ],
                          border: Border(
                            bottom: BorderSide(
                              color: ref.watch(themeModeProvider).valueOrNull == ThemeMode.dark
                                  ? Colors.white.withValues(alpha: 0.08)
                                  : Colors.black.withValues(alpha: 0.04),
                              width: 0.5,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    if (widget.isModal) {
                                      Navigator.of(context).pop();
                                    } else {
                                      context.go('/tasks');
                                    }
                                  },
                                  icon: const Icon(Icons.arrow_back),
                                  color: const Color(0xff1e293b),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _isDeepEditMode ? 'Task Detail' : 'New Task',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Manrope',
                                    color: Color(0xff1e293b),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                if (_isDeepEditMode)
                                  TextButton(
                                    onPressed: _createTask,
                                    child: const Text(
                                      'Save Changes',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF004AC6),
                                      ),
                                    ),
                                  ),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.more_vert,
                                    color: Color(0xff1e293b),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // 模拟任务列表（模糊效果）
                  if (!_isDeepEditMode)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Today',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Manrope',
                              color: Color(0xff1a1c1d),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'You have 8 tasks for today.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xff434655),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 48),
                          // 模拟任务项
                          _buildMockTask('Morning Yoga Session', '08:00 AM'),
                          const SizedBox(height: 16),
                          _buildMockTask('Weekly Growth Meeting', '10:30 AM'),
                          const SizedBox(height: 16),
                          _buildMockTask('Design System Review', '02:00 PM'),
                        ],
                      ),
                    ),
                  // 深度编辑模式：左右分栏布局
                  if (_isDeepEditMode)
                    Expanded(
                      child: Row(
                        children: [
                          // 左侧：可滑动的任务列表 (1/3)
                          _buildTaskListPanel(),
                          // 右侧：编辑面板 (2/3)
                          Expanded(
                            flex: 2,
                            child: _buildDetailEditPanel(),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            // 半透明遮罩（带动画）
            AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (context, child) {
                return Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xff1a1c1d).withValues(alpha: 0.1 * _fadeAnimation.value),
                  ),
                );
              },
            ),

            // 深度编辑模式：底部不显示创建面板，只显示任务详情
            if (!_isDeepEditMode)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 800),
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.only(
                      left: 24,
                      right: 24,
                      top: 16,
                      bottom: 48,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xffffffff),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          spreadRadius: 0,
                          blurRadius: 24,
                          offset: const Offset(0, -8),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 拖拽指示器
                        Container(
                          width: 48,
                          height: 6,
                          margin: const EdgeInsets.only(bottom: 40),
                          decoration: BoxDecoration(
                            color: const Color(0xffc3c6d7).withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),

                        // 输入区域和发送按钮
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 输入区域
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // 任务标题输入框（带聚焦效果）
                                  _AnimatedTextField(
                                    controller: _taskController,
                                    hint: 'What are you planning?',
                                    onSubmitted: (_) => _createTask(),
                                  ),

                                  const SizedBox(height: 32),

                                  // 上下文微芯片 + 项目选择器（带选中动画）
                                  Wrap(
                                    spacing: 12,
                                    runSpacing: 12,
                                    children: [
                                      ..._visibleTagDefs.map((def) {
                                        return _AnimatedChip(
                                          icon: def.icon,
                                          label: def.name,
                                          isSelected: _activeTags.contains(def.name),
                                          onTap: () => _toggleTag(def.name),
                                          onLongPress: () => _hideTag(def.name),
                                        );
                                      }),
                                      // 添加标签按钮
                                      GestureDetector(
                                        onTap: _addCustomTag,
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: AppColors.surfaceContainerHigh,
                                            borderRadius: BorderRadius.circular(9999),
                                          ),
                                          child: const Icon(Icons.add, size: 16, color: Color(0xff434655)),
                                        ),
                                      ),
                                      // 管理标签按钮
                                      GestureDetector(
                                        onTap: _showManageTagsDialog,
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: AppColors.surfaceContainerHigh,
                                            borderRadius: BorderRadius.circular(9999),
                                          ),
                                          child: const Icon(Icons.tune, size: 16, color: Color(0xff434655)),
                                        ),
                                      ),
                                      // 项目选择器
                                      _buildProjectSelector(),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 16),

                            // 发送按钮（带按压动画）
                            _AnimatedSendButton(
                              isLoading: _isSubmitting,
                              onTap: _createTask,
                            ),
                          ],
                        ),

                        const SizedBox(height: 48),

                        // 底部操作按钮和提示
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // 详情编辑按钮
                            IconButton(
                              onPressed: () {
                                context.go('/task-details/new');
                              },
                              icon: const Icon(Icons.edit_note),
                              color: const Color(0xff434655).withValues(alpha: 0.6),
                              tooltip: 'Detail Edit',
                            ),

                            // 提示文字
                            Text(
                              'Press Enter to Create',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xff434655).withValues(alpha: 0.4),
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityButton(String value, String label, Color color) {
    final isSelected = _selectedPriority == value;
    return GestureDetector(
      onTap: () => _selectPriority(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(9999),
          boxShadow: isSelected ? [
            BoxShadow(
              color: color.withAlpha(51),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ] : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : const Color(0xFF434655),
          ),
        ),
      ),
    );
  }

  Widget _buildMockTask(String title, String time) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xffffffff),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                margin: const EdgeInsets.only(right: 24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xff2563eb), width: 2),
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff1a1c1d),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: const Color(0xffe8e8ea),
              borderRadius: BorderRadius.circular(9999),
            ),
            child: Text(
              time,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xff1a1c1d),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============ 左侧任务列表面板 ============
  Widget _buildTaskListPanel() {
    return Container(
      width: 360,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F5).withValues(alpha: 0.5),
        border: Border(
          right: BorderSide(
            color: const Color(0xFFC3C6D7).withAlpha(26),
          ),
        ),
      ),
      child: Column(
        children: [
          // 面板标题
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: const Color(0xFFC3C6D7).withAlpha(26),
                ),
              ),
            ),
            child: Row(
              children: [
                const Text(
                  'All Tasks',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF434655),
                    letterSpacing: 1,
                  ),
                ),
                const Spacer(),
                Consumer(
                  builder: (context, ref, _) {
                    final tasksAsync = ref.watch(taskNotifierProvider);
                    return tasksAsync.when(
                      data: (tasks) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF004AC6).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(9999),
                        ),
                        child: Text(
                          '${tasks.length}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF004AC6),
                          ),
                        ),
                      ),
                      loading: () => const SizedBox.shrink(),
                      error: (_, _) => const SizedBox.shrink(),
                    );
                  },
                ),
              ],
            ),
          ),
          // 任务列表（可滚动）
          Expanded(
            child: Consumer(
              builder: (context, ref, _) {
                final tasksAsync = ref.watch(taskNotifierProvider);
                return tasksAsync.when(
                  data: (tasks) {
                    if (tasks.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.inbox_outlined,
                              size: 48,
                              color: const Color(0xFF737686).withAlpha(77),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No tasks yet',
                              style: TextStyle(
                                fontSize: 14,
                                color: const Color(0xFF737686).withAlpha(128),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        final isSelected = _selectedTaskId == task.id;
                        return _buildTaskListItem(task, isSelected);
                      },
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF004AC6),
                    ),
                  ),
                  error: (error, _) => Center(
                    child: Text(
                      'Error loading tasks',
                      style: TextStyle(
                        fontSize: 14,
                        color: const Color(0xFFBA1A1A).withAlpha(179),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 单个任务列表项
  Widget _buildTaskListItem(dynamic task, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTaskId = task.id;
          _taskController.text = task.title ?? '';
          _notesController.text = task.description ?? '';
          if (task.dueDate != null) {
            _dueDate = DateTime.tryParse(task.dueDate!);
          }
          _selectedPriority = task.priority ?? 'medium';
          // 加载任务的子任务
          if (task.subTasks != null && task.subTasks.isNotEmpty) {
            _subTasks = List<SubTask>.from(task.subTasks);
          } else {
            _loadSubTasks(task.id);
          }
        });
      },
      child: MouseRegion(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFFFFFF) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: isSelected
                ? Border.all(color: const Color(0xFF004AC6).withValues(alpha: 0.3), width: 1.5)
                : null,
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFF004AC6).withValues(alpha: 0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              // 完成状态圆圈
              GestureDetector(
                onTap: () {
                  ref.read(taskNotifierProvider.notifier).toggleTaskCompletion(task.id);
                },
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: task.completed
                          ? const Color(0xFF004AC6)
                          : const Color(0xFFC3C6D7),
                      width: 2,
                    ),
                    color: task.completed ? const Color(0xFF004AC6) : Colors.transparent,
                  ),
                  child: task.completed
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              // 任务信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title ?? 'Untitled',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: task.completed
                            ? const Color(0xFF737686)
                            : const Color(0xFF1A1C1D),
                        decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (task.dueDate != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            size: 12,
                            color: const Color(0xFF737686).withAlpha(128),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatDate(task.dueDate!),
                            style: TextStyle(
                              fontSize: 12,
                              color: const Color(0xFF737686).withAlpha(128),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              // 优先级指示
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _getPriorityColor(task.priority ?? 'medium'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return const Color(0xFFBA1A1A);
      case 'medium':
        return const Color(0xFFFD761A);
      case 'low':
        return const Color(0xFF737686);
      default:
        return const Color(0xFF737686);
    }
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final diff = date.difference(now);

      if (diff.inDays == 0) return 'Today';
      if (diff.inDays == 1) return 'Tomorrow';
      if (diff.inDays == -1) return 'Yesterday';
      if (diff.inDays > 0 && diff.inDays < 7) return 'In ${diff.inDays} days';

      return '${date.month}/${date.day}/${date.year}';
    } catch (e) {
      return dateStr;
    }
  }

  // ============ 右侧编辑面板 ============
  Widget _buildDetailEditPanel() {
    return Container(
      color: const Color(0xFFFFFFFF),
      child: Column(
        children: [
          // 面板 Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: const Color(0xFFC3C6D7).withAlpha(26),
                ),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => context.go('/tasks'),
                  icon: const Icon(Icons.close),
                  color: const Color(0xFF737686),
                  iconSize: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Task Detail',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF737686),
                    letterSpacing: 1,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: _createTask,
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF004AC6),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.more_vert),
                  color: const Color(0xFF737686),
                  iconSize: 20,
                ),
              ],
            ),
          ),
          // 可滚动的编辑内容 + 底部操作按钮
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 任务标题
                        TextField(
                          controller: _taskController,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Manrope',
                            color: Color(0xFF1A1C1D),
                          ),
                          decoration: InputDecoration(
                            hintText: 'Untitled Task',
                            hintStyle: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Manrope',
                              color: const Color(0xFF434655).withAlpha(77),
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.schedule, size: 16, color: const Color(0xFF737686).withAlpha(179)),
                            const SizedBox(width: 4),
                            Text(
                              _selectedTaskId != null ? 'Created just now' : 'Creating new task',
                              style: TextStyle(
                                fontSize: 14,
                                color: const Color(0xFF737686).withAlpha(179),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Bento Grid: 标签 & 优先级 + 日期
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 标签 & 优先级
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3F3F5),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Tags',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF737686),
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: _visibleTagDefs.map((def) {
                                        final isSelected = _activeTags.contains(def.name);
                                        return GestureDetector(
                                          onTap: () => _toggleTag(def.name),
                                          child: AnimatedContainer(
                                            duration: const Duration(milliseconds: 200),
                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                            decoration: BoxDecoration(
                                              color: isSelected ? const Color(0xFF004AC6) : Colors.white,
                                              borderRadius: BorderRadius.circular(9999),
                                              boxShadow: isSelected ? [
                                                BoxShadow(
                                                  color: const Color(0xFF004AC6).withAlpha(51),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ] : null,
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  def.icon,
                                                  size: 14,
                                                  color: isSelected ? Colors.white : const Color(0xFF434655),
                                                ),
                                                const SizedBox(width: 6),
                                                Text(
                                                  def.name,
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                    color: isSelected ? Colors.white : const Color(0xFF434655),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                    const SizedBox(height: 24),
                                    const Text(
                                      'Priority',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF737686),
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withAlpha(128),
                                        borderRadius: BorderRadius.circular(9999),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          _buildPriorityButton('high', 'High', const Color(0xFFBA1A1A)),
                                          _buildPriorityButton('medium', 'Medium', const Color(0xFFFD761A)),
                                          _buildPriorityButton('low', 'Low', const Color(0xFF737686)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // 日期选择
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3F3F5),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Due Date',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF737686),
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    GestureDetector(
                                      onTap: () async {
                                        final date = await showDatePicker(
                                          context: context,
                                          initialDate: _dueDate ?? DateTime.now(),
                                          firstDate: DateTime.now().subtract(const Duration(days: 365)),
                                          lastDate: DateTime.now().add(const Duration(days: 365)),
                                        );
                                        if (date != null) {
                                          setState(() => _dueDate = date);
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: const Color(0xFFC3C6D7).withAlpha(26),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 48,
                                              height: 48,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF004AC6).withAlpha(26),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: const Icon(
                                                Icons.calendar_today,
                                                color: Color(0xFF004AC6),
                                                size: 24,
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    _dueDate != null
                                                        ? '${_dueDate!.month}/${_dueDate!.day}/${_dueDate!.year}'
                                                        : 'Select Date',
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      color: Color(0xFF1A1C1D),
                                                    ),
                                                  ),
                                                  if (_dueDate != null)
                                                    Text(
                                                      _getWeekdayName(_dueDate!.weekday),
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: const Color(0xFF737686).withAlpha(179),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // Sub-Tasks 区域
                        _buildSubTasksSection(),

                        const SizedBox(height: 32),

                        // 备注区域
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F3F5),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: TextField(
                            controller: _notesController,
                            maxLines: 6,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF1A1C1D),
                              height: 1.6,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Add some context, links, or resources here...',
                              hintStyle: TextStyle(
                                fontSize: 16,
                                color: const Color(0xFF434655).withAlpha(77),
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(24),
                            ),
                          ),
                        ),

                        // 底部留白（为底部按钮腾出空间）
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),

                // 底部操作按钮
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F3F5),
                    border: Border(
                      top: BorderSide(
                        color: const Color(0xFFC3C6D7).withAlpha(26),
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Discard 按钮
                      TextButton(
                        onPressed: () {
                          // 重置表单
                          setState(() {
                            _taskController.clear();
                            _notesController.clear();
                            _selectedTaskId = null;
                            _dueDate = null;
                            _selectedPriority = 'medium';
                            _activeTags.clear();
                            _activeTags.add('Work');
                            _subTasks.clear();
                          });
                        },
                        child: const Text(
                          'Discard',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF737686),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Update Task 按钮
                      _AnimatedUpdateButton(
                        isLoading: _isSubmitting,
                        onTap: _createTask,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getWeekdayName(int weekday) {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[weekday - 1];
  }

  // ============ Sub-Tasks 区域 ============
  Widget _buildSubTasksSection() {
    final completedCount = _subTasks.where((t) => t.completed).length;
    final progress = _subTaskProgress;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header: 标题 + 进度
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Text(
                  'Sub-Tasks',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF737686),
                    letterSpacing: 1,
                  ),
                ),
                if (_subTasks.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  Text(
                    '($completedCount/${_subTasks.length})',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF737686),
                    ),
                  ),
                ],
              ],
            ),
            if (_subTasks.isNotEmpty)
              Text(
                '${(progress * 100).toInt()}% Complete',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF004AC6),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),

        // 进度条
        if (_subTasks.isNotEmpty) ...[
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: const Color(0xFFE8E8EA),
              borderRadius: BorderRadius.circular(3),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF004AC6),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],

        // 子任务列表
        ..._subTasks.map((subTask) => _buildSubTaskItem(subTask)),

        // 添加子任务输入框
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFC3C6D7).withValues(alpha: 0.3),
                  ),
                ),
                child: TextField(
                  controller: _subTaskController,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF1A1C1D),
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Add sub-task...',
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF737686),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  onSubmitted: (_) => _addSubTask(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _addSubTask,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF004AC6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.add,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 单个子任务项
  Widget _buildSubTaskItem(SubTask subTask) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          // 完成状态
          GestureDetector(
            onTap: () => _toggleSubTask(subTask.id),
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: subTask.completed
                      ? const Color(0xFF004AC6)
                      : const Color(0xFFC3C6D7),
                  width: 2,
                ),
                color: subTask.completed ? const Color(0xFF004AC6) : Colors.transparent,
              ),
              child: subTask.completed
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          // 子任务文字
          Expanded(
            child: Text(
              subTask.title,
              style: TextStyle(
                fontSize: 14,
                color: subTask.completed
                    ? const Color(0xFF737686)
                    : const Color(0xFF1A1C1D),
                decoration: subTask.completed ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
          // 删除按钮
          GestureDetector(
            onTap: () => _deleteSubTask(subTask.id),
            child: Icon(
              Icons.close,
              size: 18,
              color: const Color(0xFF737686).withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  // 添加子任务
  void _addSubTask() {
    final text = _subTaskController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _subTasks.add(SubTask(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: text,
          completed: false,
          order: _subTasks.length,
        ));
        _subTaskController.clear();
      });
    }
  }

  // 切换子任务完成状态
  void _toggleSubTask(String id) {
    setState(() {
      final index = _subTasks.indexWhere((t) => t.id == id);
      if (index != -1) {
        _subTasks[index] = _subTasks[index].copyWith(
          completed: !_subTasks[index].completed,
        );
      }
    });
  }

  // 删除子任务
  void _deleteSubTask(String id) {
    setState(() {
      _subTasks.removeWhere((t) => t.id == id);
    });
  }

  // 计算子任务完成进度
  double get _subTaskProgress {
    if (_subTasks.isEmpty) return 0;
    final completed = _subTasks.where((t) => t.completed).length;
    return completed / _subTasks.length;
  }
}

// ============ 带动画的输入框 ============
class _AnimatedTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final ValueChanged<String>? onSubmitted;

  const _AnimatedTextField({
    required this.controller,
    required this.hint,
    this.onSubmitted,
  });

  @override
  State<_AnimatedTextField> createState() => _AnimatedTextFieldState();
}

class _AnimatedTextFieldState extends State<_AnimatedTextField>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _borderAnimation;
  late Animation<double> _glowAnimation;
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);

    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _borderAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    widget.controller.addListener(_onTextChange);
  }

  void _onFocusChange() {
    setState(() => _isFocused = _focusNode.hasFocus);
    if (_focusNode.hasFocus || widget.controller.text.isNotEmpty) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  void _onTextChange() {
    if (widget.controller.text.isNotEmpty && !_isFocused) {
      _controller.forward();
    } else if (widget.controller.text.isEmpty && !_isFocused) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    widget.controller.removeListener(_onTextChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: _glowAnimation.value > 0
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.15 * _glowAnimation.value),
                      blurRadius: 8 * _glowAnimation.value,
                      spreadRadius: 1 * _glowAnimation.value,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Color.lerp(
                  Colors.transparent,
                  AppColors.primary,
                  _borderAnimation.value,
                )!,
                width: 2,
              ),
            ),
            child: TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              onSubmitted: widget.onSubmitted,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Manrope',
                color: Color(0xff1a1c1d),
              ),
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Manrope',
                  color: const Color(0xff434655).withValues(alpha: 0.3),
                ),
                filled: true,
                fillColor: AppColors.surfaceContainerLowest,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ============ 标签定义 ============
class _TagDefinition {
  final String name;
  final IconData icon;
  final bool isDefault;

  const _TagDefinition({
    required this.name,
    required this.icon,
    this.isDefault = false,
  });
}

// ============ 带动画的上下文芯片 ============
class _AnimatedChip extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const _AnimatedChip({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.onLongPress,
  });

  @override
  State<_AnimatedChip> createState() => _AnimatedChipState();
}

class _AnimatedChipState extends State<_AnimatedChip>
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _controller.forward();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _controller.reverse();
      },
      onLongPress: widget.onLongPress,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: widget.isSelected
                    ? AppColors.primaryFixed.withValues(alpha: 0.5)
                    : (_isPressed
                        ? AppColors.surfaceContainerHigh.withValues(alpha: 0.8)
                        : AppColors.surfaceContainerHigh),
                borderRadius: BorderRadius.circular(9999),
                boxShadow: widget.isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.2),
                          blurRadius: 8,
                          spreadRadius: 1,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      widget.icon,
                      key: ValueKey(widget.isSelected),
                      size: 16,
                      color: widget.isSelected
                          ? const Color(0xff003ea8)
                          : const Color(0xff434655),
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: widget.isSelected
                          ? const Color(0xff003ea8)
                          : const Color(0xff434655),
                    ),
                    child: Text(widget.label),
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

// ============ 带动画的发送按钮 ============
class _AnimatedSendButton extends StatefulWidget {
  final bool isLoading;
  final VoidCallback onTap;

  const _AnimatedSendButton({
    required this.isLoading,
    required this.onTap,
  });

  @override
  State<_AnimatedSendButton> createState() => _AnimatedSendButtonState();
}

class _AnimatedSendButtonState extends State<_AnimatedSendButton>
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
    return GestureDetector(
      onTapDown: widget.isLoading
          ? null
          : (_) {
              setState(() => _isPressed = true);
              _controller.forward();
            },
      onTapUp: widget.isLoading
          ? null
          : (_) {
              setState(() => _isPressed = false);
              _controller.reverse();
              widget.onTap();
            },
      onTapCancel: widget.isLoading
          ? null
          : () {
              setState(() => _isPressed = false);
              _controller.reverse();
            },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xff004ac6),
                    Color(0xff2563eb),
                  ],
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: AppShadows.glowShadow(
                  _isPressed ? const Color(0xff2563eb) : const Color(0xff004ac6),
                  opacity: _isPressed ? 0.5 : 0.3,
                ),
              ),
              child: widget.isLoading
                  ? const Center(
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    )
                  : const Icon(
                      Icons.send,
                      size: 24,
                      color: Colors.white,
                    ),
            ),
          );
        },
      ),
    );
  }
}

// ============ 底部更新按钮 ============
class _AnimatedUpdateButton extends StatefulWidget {
  final bool isLoading;
  final VoidCallback onTap;

  const _AnimatedUpdateButton({
    required this.isLoading,
    required this.onTap,
  });

  @override
  State<_AnimatedUpdateButton> createState() => _AnimatedUpdateButtonState();
}

class _AnimatedUpdateButtonState extends State<_AnimatedUpdateButton>
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.isLoading
          ? null
          : (_) {
              setState(() => _isPressed = true);
              _controller.forward();
            },
      onTapUp: widget.isLoading
          ? null
          : (_) {
              setState(() => _isPressed = false);
              _controller.reverse();
              widget.onTap();
            },
      onTapCancel: widget.isLoading
          ? null
          : () {
              setState(() => _isPressed = false);
              _controller.reverse();
            },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xff004ac6),
                    Color(0xff2563eb),
                  ],
                ),
                borderRadius: BorderRadius.circular(9999),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xff004ac6).withValues(alpha: _isPressed ? 0.5 : 0.25),
                    blurRadius: _isPressed ? 16 : 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: widget.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Update Task',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}
