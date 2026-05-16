import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../data/providers/task_provider.dart';
import '../../data/providers/project_provider.dart';
import '../../data/models/task_models.dart';
import '../../data/models/project_models.dart';
import '../widgets/app_widgets.dart';
import '../widgets/responsive_navigation.dart';
import '../widgets/project_nav_sidebar.dart';
import 'create_task_screen.dart';

/// My Workspace 页面 - 现代化重新设计
/// 
/// 设计特点：
/// - 玻璃拟态效果 (Glassmorphism)
/// - 柔和的渐变背景
/// - 精致的卡片阴影
/// - 流畅的微交互动画

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  
  // ── 搜索 ─────────────────────────────────────────────────
  final _searchController = TextEditingController();
  String _searchQuery = '';
  List<Task> _searchResults = [];
  Timer? _searchDebounce;
  bool _isSearching = false;

  // ── 排序 ─────────────────────────────────────────────────
  String _sortBy = 'name';
  bool _isAscending = true;

  // ── Tab 导航 ─────────────────────────────────────────────
  int _selectedTabIndex = 0;

  // ── 延时完成 ──────────────────────────────────────────────
  final Map<String, Timer> _pendingCompleteTimers = {};
  static const _completeDelaySeconds = 10;

  // ── 多选操作 ───────────────────────────────────────────────
  final Set<String> _selectedTaskIds = {};
  bool _isMultiSelectMode = false;
  bool _showSelectAllOption = false;

  void _toggleTaskSelection(String taskId) {
    setState(() {
      if (_selectedTaskIds.contains(taskId)) {
        _selectedTaskIds.remove(taskId);
      } else {
        _selectedTaskIds.add(taskId);
      }
      _showSelectAllOption = false;
    });
  }

  void _exitMultiSelectMode() {
    _drawerController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _isMultiSelectMode = false;
          _selectedTaskIds.clear();
          _showSelectAllOption = false;
        });
      }
    });
  }

  void _toggleSelectAll(List<Task> tasks) {
    setState(() {
      if (tasks == null || tasks.isEmpty) {
        _selectedTaskIds.clear();
        return;
      }
      if (_selectedTaskIds.length == tasks.length) {
        _selectedTaskIds.clear();
      } else {
        _selectedTaskIds.clear();
        for (final task in tasks) {
          if (task != null && task.id != null) {
            _selectedTaskIds.add(task.id);
          }
        }
      }
    });
  }

  // ── 动画控制器 ───────────────────────────────────────────
  late AnimationController _rippleController;
  late Animation<double> _rippleAnimation;
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _drawerController;

  @override
  void initState() {
    super.initState();

    // 波纹动画
    _rippleController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();
    _rippleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _rippleController, curve: Curves.linear),
    );

    // 浮动动画
    _floatController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat(reverse: true);
    _floatAnimation = Tween<double>(begin: 0, end: 20).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    // 淡入动画
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();

    // 多选抽屉动画
    _drawerController = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchDebounce?.cancel();
    _rippleController.dispose();
    _floatController.dispose();
    _fadeController.dispose();
    _drawerController.dispose();
    for (final timer in _pendingCompleteTimers.values) {
      timer.cancel();
    }
    super.dispose();
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
      _searchResults = [];
      _isSearching = false;
    });
  }

  void _onSearchChanged(String value) {
    if (_searchDebounce?.isActive ?? false) _searchDebounce!.cancel();
    
    if (value.isEmpty) {
      _clearSearch();
      return;
    }

    setState(() => _isSearching = true);

    _searchDebounce = Timer(const Duration(milliseconds: 300), () async {
      final tasksAsync = ref.read(taskNotifierProvider);
      final allTasks = tasksAsync.valueOrNull ?? [];
      
      final results = allTasks.where((task) =>
        task.title.toLowerCase().contains(value.toLowerCase())
      ).toList();

      setState(() {
        _searchQuery = value;
        _searchResults = results;
        _isSearching = false;
      });
    });
  }

  void _toggleTaskCompletionDelayed(Task task) {
    final id = task.id;
    final willComplete = !task.isCompleted;

    // 如果正在取消中，立即恢复完成状态
    if (_pendingCompleteTimers.containsKey(id)) {
      _pendingCompleteTimers[id]!.cancel();
      _pendingCompleteTimers.remove(id);
      ref.read(taskNotifierProvider.notifier).toggleTaskCompletion(id);
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      return;
    }

    // 如果要取消完成（uncomplete），立即执行
    if (!willComplete) {
      ref.read(taskNotifierProvider.notifier).toggleTaskCompletion(id);
      return;
    }

    // 延时完成：先在 UI 上标记为完成，10s 后才持久化
    ref.read(taskNotifierProvider.notifier).toggleTaskCompletion(id);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    int remaining = _completeDelaySeconds;
    final snackBar = SnackBar(
      duration: Duration(seconds: _completeDelaySeconds + 1),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
      content: StatefulBuilder(
        builder: (context, setSnackBarState) {
          return Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Task completed (${remaining}s to undo)',
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  _pendingCompleteTimers[id]?.cancel();
                  _pendingCompleteTimers.remove(id);
                  ref.read(taskNotifierProvider.notifier).toggleTaskCompletion(id);
                },
                child: const Text('Undo', style: TextStyle(color: Colors.white70)),
              ),
            ],
          );
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    _pendingCompleteTimers[id] = Timer.periodic(const Duration(seconds: 1), (timer) {
      remaining--;
      if (remaining <= 0) {
        timer.cancel();
        _pendingCompleteTimers.remove(id);
        if (mounted) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        }
      }
    });
  }

  List<Task> _applySort(List<Task> tasks) {
    final sorted = List<Task>.from(tasks);
    final multiplier = _isAscending ? 1 : -1;

    sorted.sort((a, b) {
      if (a.isCompleted != b.isCompleted) return a.isCompleted ? 1 : -1;

      int result;
      switch (_sortBy) {
        case 'name':
          result = a.title.toLowerCase().compareTo(b.title.toLowerCase());
          break;
        case 'createdAt':
          result = a.createdAt.compareTo(b.createdAt);
          break;
        case 'dueDate':
          if (a.dueDate == null && b.dueDate == null) {
            result = 0;
          } else if (a.dueDate == null) {
            result = 1;
          } else if (b.dueDate == null) {
            result = -1;
          } else {
            result = a.dueDate!.compareTo(b.dueDate!);
          }
          break;
        case 'category':
          result = a.category.toLowerCase().compareTo(b.category.toLowerCase());
          break;
        default:
          result = a.createdAt.compareTo(b.createdAt);
      }
      return result * multiplier;
    });

    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    // 切换到 Completed 时，若当前是 Expired tab 则自动切回 All
    ref.listen<String?>(selectedProjectIdProvider, (prev, next) {
      if (next == '__completed__' && _selectedTabIndex == 2) {
        setState(() => _selectedTabIndex = 0);
      }
    });

    final tasksAsync = ref.watch(taskNotifierProvider);
    final focusStatsAsync = ref.watch(focusNotifierProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final deviceType = Responsive.getDeviceType(screenWidth);

    // 根据设备类型构建不同的布局
    switch (deviceType) {
      case DeviceType.mobile:
        return _buildMobileScaffold(tasksAsync, focusStatsAsync);
      case DeviceType.tablet:
        return _buildTabletScaffold(tasksAsync, focusStatsAsync);
      case DeviceType.desktop:
        return _buildDesktopScaffold(tasksAsync, focusStatsAsync);
    }
  }

  // ══════════════════════════════════════════════════════════════
  // 移动端布局
  // ══════════════════════════════════════════════════════════════
  Widget _buildMobileScaffold(AsyncValue<List<Task>> tasksAsync, AsyncValue<FocusStats> focusStatsAsync) {
    return ResponsiveNavigation(
      currentPage: 'tasks',
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: AppBackground(
          child: SafeArea(
            bottom: false,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildPageHeader(),
                        const SizedBox(height: 24),
                        _buildMobileLayout(tasksAsync, focusStatsAsync),
                        const SizedBox(height: 100),
                      ],
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

  // ══════════════════════════════════════════════════════════════
  // Web端/平板布局
  // ══════════════════════════════════════════════════════════════
  Widget _buildTabletScaffold(AsyncValue<List<Task>> tasksAsync, AsyncValue<FocusStats> focusStatsAsync) {
    return ResponsiveNavigation(
      currentPage: 'tasks',
      searchController: _searchController,
      onSearchChanged: _onSearchChanged,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: AppBackground(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildPageHeader(),
                          const SizedBox(height: 32),
                          _buildDesktopLayout(tasksAsync, focusStatsAsync),
                          const SizedBox(height: 100),
                        ],
                      ),
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

  // ══════════════════════════════════════════════════════════════
  // 桌面端布局
  // ══════════════════════════════════════════════════════════════
  Widget _buildDesktopScaffold(AsyncValue<List<Task>> tasksAsync, AsyncValue<FocusStats> focusStatsAsync) {
    return ResponsiveNavigation(
      currentPage: 'tasks',
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: AppBackground(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1400),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildPageHeader(),
                          const SizedBox(height: 32),
                          _buildDesktopLayout(tasksAsync, focusStatsAsync),
                          const SizedBox(height: 100),
                        ],
                      ),
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

  // ══════════════════════════════════════════════════════════════
  // 页面标题
  // ══════════════════════════════════════════════════════════════
  Widget _buildPageHeader() {
    final now = DateTime.now();
    final dateFormatter = DateFormat('EEEE, MMMM d', 'en_US');
    final formattedDate = dateFormatter.format(now);

    final headerAnim = CurvedAnimation(
      parent: _fadeController,
      curve: const Interval(0, 0.3, curve: Curves.easeOut),
    );
    return AnimatedBuilder(
      animation: headerAnim,
      builder: (context, child) => Opacity(
        opacity: headerAnim.value,
        child: Transform.translate(
          offset: Offset(0, -20 * (1 - headerAnim.value)),
          child: child,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
            // 左侧：标题和副标题
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'My Workspace',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 42,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Organize, track, and achieve your goals',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF334155),
                  ),
                ),
              ],
            ),
            // 右侧：日期标签
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF3B82F6).withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                formattedDate,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
    );
  }

  // ══════════════════════════════════════════════════════════════
  // 桌面端主布局 - 简洁双栏设计
  // ══════════════════════════════════════════════════════════════
  Widget _buildDesktopLayout(
    AsyncValue<List<Task>> tasksAsync,
    AsyncValue<FocusStats> focusStatsAsync,
  ) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _fadeController, curve: const Interval(0.2, 0.5, curve: Curves.easeOut)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 左侧：项目导航
          SizedBox(
            width: 240,
            child: ProjectNavSidebar(
              onNewTask: _showCreateTaskSheet,
              onNewProject: () => _showCreateProjectSheet(),
            ),
          ),
          const SizedBox(width: 32),
          // 右侧：任务列表（占据剩余空间）
          Expanded(
            child: _buildTaskManagementArea(tasksAsync),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════
  // 移动端布局 - 简洁单栏设计
  // ══════════════════════════════════════════════════════════════
  Widget _buildMobileLayout(
    AsyncValue<List<Task>> tasksAsync,
    AsyncValue<FocusStats> focusStatsAsync,
  ) {
    return _buildTaskManagementArea(tasksAsync);
  }

  // ══════════════════════════════════════════════════════════════
  // 任务管理区域
  // ══════════════════════════════════════════════════════════════
  Widget _buildTaskManagementArea(AsyncValue<List<Task>> tasksAsync) {
    final selectedProjectId = ref.watch(selectedProjectIdProvider);

    final listContent = tasksAsync.when(
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: CircularProgressIndicator(
            color: Color(0xFF3B82F6),
            strokeWidth: 3,
          ),
        ),
      ),
      error: (error, stack) => _buildErrorState(error.toString()),
      data: (tasks) {
        // 如果是 Trash Tab，需要额外获取回收站任务
        if (_selectedTabIndex == 3) {
          return _buildTrashTaskList(selectedProjectId);
        }

        // 先按项目过滤
        var filteredTasks = selectedProjectId == null
            ? tasks.where((t) => !t.isCompleted).toList()
            : (selectedProjectId == '__completed__'
                ? tasks.where((t) => t.isCompleted).toList()
                : (selectedProjectId == '__uncategorized__'
                    ? tasks.where((t) => t.projectId == null).toList()
                    : tasks.where((t) => t.projectId == selectedProjectId).toList()));

        // 再按 Tab 过滤
        switch (_selectedTabIndex) {
          case 0: // All - 所有未删除任务
            break;
          case 1: // Important - 收藏的任务
            filteredTasks = filteredTasks.where((t) => t.isStarred).toList();
            break;
          case 2: // Expired - 过期任务（未完成且已过期）
            filteredTasks = filteredTasks.where((t) {
              if (t.isCompleted) return false;
              if (t.dueDate == null) return false;
              final dueDate = DateTime.tryParse(t.dueDate!);
              if (dueDate == null) return false;
              return dueDate.isBefore(DateTime.now());
            }).toList();
            break;
        }

        final baseTasks = _searchQuery.isNotEmpty ? _searchResults : filteredTasks;
        final displayTasks = _applySort(baseTasks);

        if (_searchQuery.isNotEmpty && displayTasks.isEmpty && !_isSearching) {
          return _buildNoSearchResults();
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final hasBoundedHeight = constraints.maxHeight != double.infinity;
            final taskList = _buildTaskList(
              displayTasks,
              displayTasks.isEmpty,
              tabLabel: _getTabLabel(_selectedTabIndex),
              scrollable: hasBoundedHeight,
            );
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: const BoxConstraints(maxWidth: 1280),
                  child: _buildTabAndSortBar(),
                ),
                const SizedBox(height: 20),
                if (hasBoundedHeight)
                  Expanded(child: taskList)
                else
                  SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 80),
                    child: taskList,
                  ),
              ],
            );
          },
        );
      },
    );

    return listContent;
  }

  String _getTabLabel(int index) {
    switch (index) {
      case 0:
        return 'All';
      case 1:
        return 'Important';
      case 2:
        return 'Expired';
      case 3:
        return 'Trash';
      default:
        return 'Tasks';
    }
  }

  // 回收站任务列表（使用 trashNotifierProvider 自动刷新状态）
  Widget _buildTrashTaskList(String? selectedProjectId) {
    final trashTasksAsync = ref.watch(trashNotifierProvider);

    Widget body;
    switch (trashTasksAsync) {
      case AsyncData(:final value):
        // 过滤回收站任务（交叉筛选：project × trash）
        var trashTasks = value.where((t) => t.deletedAt != null).toList();

        if (selectedProjectId == null) {
          // To Do: 未完成的回收站任务
          trashTasks = trashTasks.where((t) => !t.isCompleted).toList();
        } else if (selectedProjectId == '__completed__') {
          // Completed: 已完成的回收站任务
          trashTasks = trashTasks.where((t) => t.isCompleted).toList();
        } else if (selectedProjectId == '__uncategorized__') {
          trashTasks = trashTasks.where((t) => t.projectId == null).toList();
        } else {
          trashTasks = trashTasks.where((t) => t.projectId == selectedProjectId).toList();
        }

        final displayTasks = _applySort(trashTasks);

        body = LayoutBuilder(
          builder: (context, constraints) {
            final hasBoundedHeight = constraints.maxHeight != double.infinity;
            final taskList = _buildTaskList(
              displayTasks,
              displayTasks.isEmpty,
              tabLabel: 'Trash',
              scrollable: hasBoundedHeight,
            );
            return hasBoundedHeight
                ? Expanded(child: taskList)
                : SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 80),
                    child: taskList,
                  );
          },
        );
        break;
      case AsyncError(:final error):
        body = _buildErrorState(error.toString());
        break;
      default:
        body = const Center(
          child: Padding(
            padding: EdgeInsets.all(40),
            child: CircularProgressIndicator(
              color: Color(0xFF3B82F6),
              strokeWidth: 3,
            ),
          ),
        );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: _buildTabAndSortBar(),
        ),
        const SizedBox(height: 20),
        body,
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════
  // Tab 导航 + 排序栏
  // ══════════════════════════════════════════════════════════════
  Widget _buildTabAndSortBar() {
    final isCompletedProject = ref.read(selectedProjectIdProvider) == '__completed__';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Tab 导航
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    _buildTabItem('All', Icons.list_alt, 0),
                    _buildTabItem('Important', Icons.star_outline, 1),
                    if (!isCompletedProject)
                      _buildTabItem('Expired', Icons.warning_amber_outlined, 2),
                    _buildTabItem('Trash', Icons.delete_outline, 3),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            // 排序按钮
            _buildSortButton(),
          ],
        ),
      ],
    );
  }

  Widget _buildMultiSelectAction(IconData icon, String label, VoidCallback onTap) {
    return TextButton.icon(
      onPressed: onTap,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      icon: Icon(icon, color: Colors.white, size: 16),
      label: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildSelectTrigger({bool whiteColors = false}) {
    final isActive = _isMultiSelectMode || _drawerController.status == AnimationStatus.reverse;

    return GestureDetector(
      onTap: () {
        if (_isMultiSelectMode) {
          _exitMultiSelectMode();
        } else {
          setState(() => _isMultiSelectMode = true);
          _drawerController.forward();
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: isActive && whiteColors ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: whiteColors ? Colors.white70 : const Color(0xFF94A3B8),
                width: 2,
              ),
            ),
            child: isActive && whiteColors
                ? const Icon(Icons.check, size: 12, color: Color(0xFF004AC6))
                : null,
          ),
          const SizedBox(width: 12),
          Text(
            isActive ? 'Cancel' : 'Select',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: whiteColors ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortButton() {
    // 固定宽度，确保所有选项标签都能完整显示
    const buttonWidth = 150.0;

    return PopupMenuButton<String>(
      offset: const Offset(0, 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: buttonWidth,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _isAscending ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 16,
                  color: const Color(0xFF64748B),
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    _getSortLabel(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF334155),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: Color(0xFF334155),
            ),
          ],
        ),
      ),
      onSelected: (value) {
        if (value == 'toggle') {
          setState(() => _isAscending = !_isAscending);
        } else {
          setState(() => _sortBy = value);
        }
      },
      itemBuilder: (context) => [
        _buildSortMenuItem('name', 'Name'),
        _buildSortMenuItem('createdAt', 'Created Date'),
        _buildSortMenuItem('dueDate', 'Due Date'),
        _buildSortMenuItem('category', 'Category'),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: 'toggle',
          child: SizedBox(
            width: 150,
            child: Row(
              children: [
                Icon(
                  _isAscending ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 18,
                  color: const Color(0xFF3B82F6),
                ),
                const SizedBox(width: 12),
                Text(_isAscending ? 'Ascending' : 'Descending'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  PopupMenuItem<String> _buildSortMenuItem(String value, String label) {
    final isSelected = _sortBy == value;
    return PopupMenuItem(
      value: value,
      child: SizedBox(
        width: 150,
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              size: 18,
              color: isSelected ? const Color(0xFF3B82F6) : const Color(0xFF94A3B8),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? const Color(0xFF0F172A) : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getSortLabel() {
    switch (_sortBy) {
      case 'name':
        return 'Name';
      case 'createdAt':
        return 'Created Date';
      case 'dueDate':
        return 'Due Date';
      case 'category':
        return 'Category';
      default:
        return 'Sort';
    }
  }

  Widget _buildTabItem(String label, IconData icon, int index) {
    final isActive = _selectedTabIndex == index;
    
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTabIndex = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isActive ? const Color(0xFF3B82F6) : const Color(0xFF64748B),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isActive ? const Color(0xFF0F172A) : const Color(0xFF64748B),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════
  // 任务列表
  // ══════════════════════════════════════════════════════════════
  Widget _buildTaskList(List<Task> tasks, bool isEmpty, {String tabLabel = 'Tasks', bool scrollable = false}) {
    if (isEmpty || tasks == null || tasks.isEmpty) {
      return _buildEmptyTaskList(tabLabel);
    }

    final isTrash = tabLabel == 'Trash';
    final isExpired = tabLabel == 'Expired';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 选择栏 - 合并多选操作，抽屉式展开
        if (tasks.isNotEmpty)
          LayoutBuilder(
            builder: (context, constraints) {
              final barWidth = constraints.maxWidth;
              return SizedBox(
                height: 44,
                child: Stack(
                  children: [
                    // 底层："Select" 触发器（无背景，与蓝色抽屉内容左对齐）
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: _buildSelectTrigger(),
                      ),
                    ),
                    // 顶层：蓝色抽屉（从左向右展开，覆盖触发器）
                    if (_isMultiSelectMode || _drawerController.status == AnimationStatus.reverse)
                      Positioned(
                        left: 0,
                        top: 0,
                        bottom: 0,
                        child: AnimatedBuilder(
                          animation: _drawerController,
                          builder: (context, _) {
                            final t = Curves.easeOutCubic.transform(_drawerController.value);
                            return ClipRect(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                widthFactor: t,
                                child: Container(
                                  width: barWidth,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF004AC6),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF004AC6).withAlpha(30),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.only(left: 16, right: 16),
                                  child: Row(
                                    children: [
                                      _buildSelectTrigger(whiteColors: true),
                                      const SizedBox(width: 16),
                                      const VerticalDivider(
                                        color: Colors.white30,
                                        width: 1,
                                        thickness: 1,
                                      ),
                                      const SizedBox(width: 12),
                                      // Select All
                                      MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: GestureDetector(
                                          onTap: () => _toggleSelectAll(tasks),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Checkbox(
                                                value: tasks.isNotEmpty && (_selectedTaskIds.length == tasks.length),
                                                onChanged: (_) => _toggleSelectAll(tasks),
                                                activeColor: Colors.white,
                                                checkColor: const Color(0xFF004AC6),
                                                visualDensity: VisualDensity.compact,
                                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                              ),
                                              const Text(
                                                'Select All',
                                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        '${_selectedTaskIds.length} selected',
                                        style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(width: 12),
                                      if (_selectedTabIndex == 3)
                                        _buildMultiSelectAction(Icons.restore, 'Restore', () => _batchRestoreTasks())
                                      else
                                        _buildMultiSelectAction(Icons.check, 'Complete', () => _batchCompleteTasks()),
                                      const SizedBox(width: 4),
                                      if (_selectedTabIndex != 3)
                                        _buildMultiSelectAction(Icons.move_to_inbox, 'Move', () => _batchMoveTasks()),
                                      const SizedBox(width: 4),
                                      _selectedTabIndex == 3
                                          ? _buildMultiSelectAction(Icons.delete_forever, 'Delete', () => _batchPermanentDeleteTasks())
                                          : _buildMultiSelectAction(Icons.delete_outline, 'Delete', () => _batchDeleteTasks()),
                                    ],
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
            },
          ),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: !scrollable,
          physics: scrollable
              ? const AlwaysScrollableScrollPhysics()
              : const NeverScrollableScrollPhysics(),
          padding: scrollable ? const EdgeInsets.only(bottom: 80) : null,
          itemCount: tasks.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final task = tasks[index];
            final isOverdue = task.dueDate != null &&
                DateTime.parse(task.dueDate!).isBefore(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)) &&
                !task.isCompleted;

            return _buildModernTaskCard(task, isOverdue, index, isTrash: isTrash, isExpired: isExpired);
          },
        ),
      ],
    );
  }

  Widget _buildModernTaskCard(Task task, bool isOverdue, int index, {bool isTrash = false, bool isExpired = false}) {
    return isTrash
        ? _buildSwipeableCard(task, isOverdue, index, isTrash: true)
        : _buildSwipeableCard(task, isOverdue, index, isTrash: false, isExpired: isExpired);
  }

  /// 滑动卡片（使用 Dismissible，修复 Flutter Web 崩溃）
  Widget _buildSwipeableCard(Task task, bool isOverdue, int index, {bool isTrash = false, bool isExpired = false}) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.horizontal,
      dismissThresholds: const {
        DismissDirection.startToEnd: 0.4,
        DismissDirection.endToStart: 0.4,
      },
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: isTrash 
              ? const Color(0xFF10B981).withValues(alpha: 0.15) 
              : const Color(0xFFEF4444).withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 24),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isTrash ? Icons.restore : Icons.delete_outline,
              color: isTrash ? const Color(0xFF10B981) : const Color(0xFFEF4444),
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              isTrash ? 'Restore' : 'Delete',
              style: TextStyle(
                color: isTrash ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
      secondaryBackground: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: isTrash 
              ? const Color(0xFFEF4444).withValues(alpha: 0.15) 
              : const Color(0xFF10B981).withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isTrash ? 'Delete' : (task.isCompleted ? 'Undo' : 'Complete'),
              style: TextStyle(
                color: isTrash ? const Color(0xFFEF4444) : const Color(0xFF10B981),
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              isTrash ? Icons.delete_forever : (task.isCompleted ? Icons.refresh : Icons.check),
              color: isTrash ? const Color(0xFFEF4444) : const Color(0xFF10B981),
              size: 24,
            ),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        return true;
      },
      onDismissed: (direction) {
        if (isTrash) {
          if (direction == DismissDirection.startToEnd) {
            ref.read(trashNotifierProvider.notifier).restoreTask(task.id);
          } else {
            ref.read(trashNotifierProvider.notifier).permanentDelete(task.id);
          }
        } else {
          if (direction == DismissDirection.startToEnd) {
            ref.read(taskNotifierProvider.notifier).moveToTrash(task.id);
          } else {
            _toggleTaskCompletionDelayed(task);
          }
        }
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.95, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              ),
              child: child,
            ),
          );
        },
        child: KeyedSubtree(
          key: ValueKey('${task.id}-${task.isCompleted}'),
          child: _buildCardContent(task, isOverdue, isTrash, isExpired: isExpired),
        ),
      ),
    );
  }

  /// 卡片内容（通用）
  Widget _buildCardContent(Task task, bool isOverdue, bool isTrash, {bool isExpired = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isTrash
            ? Border.all(color: const Color(0xFFEF4444).withValues(alpha: 0.3), width: 1.5)
            : (isOverdue
                ? Border.all(color: const Color(0xFFF59E0B), width: 1.5)
                : null),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: isTrash ? null : () => context.push('/task-details/${task.id}'),
          onLongPress: isTrash ? null : () => _showMoveToProjectSheet(context, ref, task),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 多选选择框
                if (_isMultiSelectMode)
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Checkbox(
                      value: _selectedTaskIds.contains(task.id),
                      onChanged: (_) => _toggleTaskSelection(task.id),
                      activeColor: const Color(0xFF004AC6),
                      checkColor: Colors.white,
                    ),
                  ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 2),
                    if (!isTrash)
                      GestureDetector(
                        onTap: () => _toggleTaskCompletionDelayed(task),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: task.isCompleted ? const Color(0xFF10B981) : Colors.transparent,
                            border: Border.all(
                              color: task.isCompleted ? const Color(0xFF10B981) : const Color(0xFF94A3B8),
                              width: 2,
                            ),
                          ),
                          child: task.isCompleted
                              ? const Icon(Icons.check, color: Colors.white, size: 14)
                              : null,
                        ),
                      )
                    else
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFEF4444).withValues(alpha: 0.1),
                        ),
                        child: const Icon(Icons.delete_outline, color: Color(0xFFEF4444), size: 14),
                      ),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              task.title,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: task.isCompleted ? const Color(0xFF94A3B8) : const Color(0xFF0F172A),
                                decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                              ),
                            ),
                          ),
                          if (isTrash && task.deletedAt != null) ...[
                            const SizedBox(width: 8),
                            _buildDaysRemainingBadge(task.deletedAt!),
                          ],
                          if (isOverdue && !task.isCompleted) ...[
                            const SizedBox(width: 8),
                            _buildExpiredDaysBadge(task.dueDate!),
                          ],
                        ],
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          // 支持 | 分隔的多标签
                          ...task.category.split('|').where((t) => t.trim().isNotEmpty).map((tag) => _buildModernChip(tag.trim(), _getCategoryColor(tag.trim()))),
                          if (isTrash && task.originalCategory != null && task.originalCategory != task.category)
                            _buildModernChip('was: ${task.originalCategory}', const Color(0xFF94A3B8)),
                          if (task.priority != 'low')
                            _buildModernChip(
                              task.priority,
                              task.priority == 'high' ? const Color(0xFFEF4444) : const Color(0xFFF59E0B),
                            ),
                          if (task.dueDate != null)
                            _buildInfoChip(
                              Icons.calendar_today_outlined,
                              _formatDueDate(task.dueDate!),
                              isOverdue && !task.isCompleted ? const Color(0xFFF59E0B) : const Color(0xFF64748B),
                            ),
                          if (task.project != null)
                            _buildInfoChip(
                              Icons.folder_outlined,
                              task.project!.name,
                              const Color(0xFF3B82F6),
                            ),
                          if (task.subTasks.isNotEmpty)
                            _buildInfoChip(
                              Icons.checklist,
                              '${task.subTasks.where((s) => s.completed).length}/${task.subTasks.length}',
                              const Color(0xFF64748B),
                            ),
                        ],
                      ),
                      if (task.description != null && task.description!.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          task.description!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (!isTrash) ...[
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => ref.read(taskNotifierProvider.notifier).toggleTaskStar(task.id),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: task.isStarred ? const Color(0xFFFEF3C7) : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        task.isStarred ? Icons.star : Icons.star_border,
                        color: task.isStarred ? const Color(0xFFF59E0B) : const Color(0xFF94A3B8),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 计算并显示距离自动删除的剩余天数
  Widget _buildDaysRemainingBadge(String deletedAt) {
    final deleted = DateTime.parse(deletedAt);
    final deletedDate = DateTime(deleted.year, deleted.month, deleted.day);
    final expiresAt = deletedDate.add(const Duration(days: 30));
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final remaining = expiresAt.difference(todayDate).inDays;
    
    final color = remaining <= 3 
        ? const Color(0xFFEF4444) 
        : (remaining <= 7 
            ? const Color(0xFFF59E0B) 
            : const Color(0xFF64748B));
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        remaining <= 0 
            ? 'Expires today' 
            : '$remaining days left',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  /// 计算并显示过期天数
  Widget _buildExpiredDaysBadge(String dueDate) {
    final due = DateTime.parse(dueDate);
    final dueDateOnly = DateTime(due.year, due.month, due.day);
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final overdueDays = todayDate.difference(dueDateOnly).inDays;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFEF4444).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        overdueDays < 0 
            ? 'Due in ${-overdueDays} day${-overdueDays > 1 ? 's' : ''}' 
            : overdueDays == 0 
                ? 'Due today' 
                : overdueDays == 1 
                    ? '1 day overdue' 
                    : '$overdueDays days overdue',
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Color(0xFFEF4444),
        ),
      ),
    );
  }

  Widget _buildModernChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  /// 带图标的标签（用于截止日期、项目、子任务等）
  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  static const _tagColors = [
    Color(0xFF3B82F6), // blue
    Color(0xFF10B981), // green
    Color(0xFFEF4444), // red
    Color(0xFF8B5CF6), // purple
    Color(0xFFF59E0B), // amber
    Color(0xFFEC4899), // pink
    Color(0xFF06B6D4), // cyan
    Color(0xFF84CC16), // lime
  ];

  Color _getCategoryColor(String category) {
    final hash = category.toLowerCase().codeUnits.fold(0, (sum, c) => sum + c);
    return _tagColors[hash % _tagColors.length];
  }

  // ══════════════════════════════════════════════════════════════
  // 空任务列表状态（内嵌显示，带动画，tab-aware 文案）
  // ══════════════════════════════════════════════════════════════
  Widget _buildEmptyTaskList(String tabLabel) {
    final (title, subtitle, icon) = _getEmptyStateContent(tabLabel);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 动画图标容器（复用全屏空状态的动画效果）
          FadeTransition(
            opacity: _fadeAnimation,
            child: AnimatedBuilder(
              animation: _floatAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, -_floatAnimation.value * 0.5),
                  child: child,
                );
              },
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [Color(0xFFEEF2FF), Colors.white],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF004AC6).withValues(alpha: 0.08),
                      blurRadius: 30,
                      spreadRadius: 0,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // 波纹
                    AnimatedBuilder(
                      animation: _rippleAnimation,
                      builder: (context, child) {
                        return Stack(
                          alignment: Alignment.center,
                          children: List.generate(3, (i) {
                            final delay = i * 0.33;
                            final progress = (_rippleAnimation.value + delay) % 1.0;
                            return Opacity(
                              opacity: (1.0 - progress).clamp(0.0, 1.0) * 0.3,
                              child: Transform.scale(
                                scale: 1.0 + progress * 0.4,
                                child: Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFF004AC6),
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        );
                      },
                    ),
                    // 主图标
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2563EB),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF2563EB).withValues(alpha: 0.25),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Icon(icon, color: Colors.white, size: 32),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),
          FadeTransition(
            opacity: _fadeAnimation,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                fontFamily: 'Manrope',
                color: Color(0xFF0F172A),
                letterSpacing: -0.3,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 10),
          FadeTransition(
            opacity: _fadeAnimation,
            child: Text(
              subtitle,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF334155),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  (String title, String subtitle, IconData icon) _getEmptyStateContent(String tabLabel) {
    switch (tabLabel) {
      case 'All':
        return (
          'No tasks yet',
          'Create your first task to get started.',
          Icons.add_task,
        );
      case 'Important':
        return (
          'No important tasks',
          'Star some tasks to mark them as important.',
          Icons.star_outline,
        );
      case 'Expired':
        return (
          'No expired tasks',
          'Great! All your tasks are on schedule.',
          Icons.check_circle_outline,
        );
      case 'Trash':
        return (
          'Trash is empty',
          'Deleted tasks will appear here.',
          Icons.delete_outline,
        );
      default:
        return (
          'No tasks yet',
          'Create your first task to get started.',
          Icons.add_task,
        );
    }
  }

  void _showMoveToProjectSheet(BuildContext context, WidgetRef ref, Task task) {
    final projectsAsync = ref.read(projectNotifierProvider);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Move to Project',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Manrope',
                  ),
                ),
              ),
              const Divider(height: 1),
              projectsAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.all(40),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text('Error: $e'),
                ),
                data: (projects) {
                  return ListView(
                    shrinkWrap: true,
                    children: [
                      ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF94A3B8).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.folder_off_outlined,
                            color: Color(0xFF64748B),
                            size: 20,
                          ),
                        ),
                        title: const Text('Uncategorized'),
                        trailing: task.projectId == null
                            ? const Icon(Icons.check, color: Color(0xFF004AC6))
                            : null,
                        onTap: () {
                          ref.read(taskNotifierProvider.notifier).updateTask(
                            task.id,
                            TaskUpdate(projectId: null),
                          );
                          Navigator.pop(context);
                        },
                      ),
                      ...projects.map((project) {
                        return ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: _parseColor(project.color).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.folder_outlined,
                              color: _parseColor(project.color),
                              size: 20,
                            ),
                          ),
                          title: Text(project.name),
                          trailing: task.projectId == project.id
                              ? const Icon(Icons.check, color: Color(0xFF004AC6))
                              : null,
                          onTap: () {
                            ref.read(taskNotifierProvider.notifier).updateTask(
                              task.id,
                              TaskUpdate(projectId: project.id),
                            );
                            Navigator.pop(context);
                          },
                        );
                      }),
                    ],
                  );
                },
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
            ],
          ),
        );
      },
    );
  }

  void _batchCompleteTasks() {
    final tasks = ref.read(taskNotifierProvider).valueOrNull ?? [];
    final selectedTasks = tasks.where((t) => _selectedTaskIds.contains(t.id)).toList();
    final allCompleted = selectedTasks.isNotEmpty && selectedTasks.every((t) => t.isCompleted);
    final newState = !allCompleted;
    for (final taskId in _selectedTaskIds) {
      ref.read(taskNotifierProvider.notifier).updateTask(taskId, TaskUpdate(isCompleted: newState));
    }
    _exitMultiSelectMode();
  }

  void _batchRestoreTasks() {
    for (final taskId in _selectedTaskIds) {
      ref.read(trashNotifierProvider.notifier).restoreTask(taskId);
    }
    _exitMultiSelectMode();
  }

  void _batchPermanentDeleteTasks() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Permanent Delete'),
          content: Text('Are you sure you want to permanently delete ${_selectedTaskIds.length} tasks? This cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                for (final taskId in _selectedTaskIds) {
                  ref.read(trashNotifierProvider.notifier).permanentDelete(taskId);
                }
                Navigator.pop(ctx);
                _exitMultiSelectMode();
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _batchMoveTasks() {
    final projectsAsync = ref.read(projectNotifierProvider);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Move ${_selectedTaskIds.length} tasks to Project',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Manrope',
                  ),
                ),
              ),
              const Divider(height: 1),
              projectsAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.all(40),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text('Error: $e'),
                ),
                data: (projects) {
                  return ListView(
                    shrinkWrap: true,
                    children: [
                      ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF94A3B8).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.folder_off_outlined,
                            color: Color(0xFF64748B),
                            size: 20,
                          ),
                        ),
                        title: const Text('Uncategorized'),
                        onTap: () {
                          for (final taskId in _selectedTaskIds) {
                            ref.read(taskNotifierProvider.notifier).updateTask(
                              taskId,
                              TaskUpdate(projectId: null),
                            );
                          }
                          Navigator.pop(ctx);
                          _exitMultiSelectMode();
                        },
                      ),
                      ...projects.map((project) {
                        return ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: _parseColor(project.color).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.folder_outlined,
                              color: _parseColor(project.color),
                              size: 20,
                            ),
                          ),
                          title: Text(project.name),
                          onTap: () {
                            for (final taskId in _selectedTaskIds) {
                              ref.read(taskNotifierProvider.notifier).updateTask(
                                taskId,
                                TaskUpdate(projectId: project.id),
                              );
                            }
                            Navigator.pop(ctx);
                            _exitMultiSelectMode();
                          },
                        );
                      }),
                    ],
                  );
                },
              ),
              SizedBox(height: MediaQuery.of(ctx).padding.bottom + 16),
            ],
          ),
        );
      },
    );
  }

  void _batchDeleteTasks() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Move to Trash'),
          content: Text('Are you sure you want to move ${_selectedTaskIds.length} tasks to trash?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                  for (final taskId in _selectedTaskIds) {
                    ref.read(taskNotifierProvider.notifier).moveToTrash(taskId);
                  }
                  Navigator.pop(ctx);
                  _exitMultiSelectMode();
                },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Move to Trash'),
            ),
          ],
        );
      },
    );
  }

  // ══════════════════════════════════════════════════════════════
  // 其他辅助方法
  // ══════════════════════════════════════════════════════════════
  Color _parseColor(String color) {
    try {
      return Color(int.parse(color.replaceFirst('#', '0xFF')));
    } catch (_) {
      return const Color(0xFF004AC6);
    }
  }

  Widget _buildNoSearchResults() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Icon(
              Icons.search_off_outlined,
              size: 48,
              color: const Color(0xFF94A3B8),
            ),
            const SizedBox(height: 16),
            Text(
              'No results for "$_searchQuery"',
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF334155),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _clearSearch,
              child: const Text('Clear search'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            const Icon(
              Icons.cloud_off_outlined,
              size: 48,
              color: Color(0xFF64748B),
            ),
            const SizedBox(height: 16),
            const Text(
              'Failed to load tasks',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF334155),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => ref.refresh(taskNotifierProvider),
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDueDate(String dueDate) {
    final dt = DateTime.parse(dueDate);
    final diff = dt.difference(DateTime.now());
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Tomorrow';
    if (diff.inDays < 7) return DateFormat('EEE').format(dt);
    return DateFormat('MMM d').format(dt);
  }



  // ══════════════════════════════════════════════════════════════
  // 弹窗方法
  // ══════════════════════════════════════════════════════════════
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

  void _showCreateProjectSheet() {
    showCreateProjectDialog(
      context,
      (name, color) async {
        try {
          await ref.read(projectNotifierProvider.notifier).addProject(
                ProjectCreate(name: name, color: color),
              );
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Project created successfully'),
                backgroundColor: const Color(0xFF10B981),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                margin: const EdgeInsets.all(16),
              ),
            );
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to create project: $e'),
                backgroundColor: const Color(0xFFEF4444),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                margin: const EdgeInsets.all(16),
              ),
            );
          }
        }
      },
    );
  }
}
