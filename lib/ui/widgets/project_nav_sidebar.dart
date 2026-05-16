import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/project_models.dart';
import '../../data/models/task_models.dart';
import '../../data/providers/project_provider.dart';
import '../../data/providers/task_provider.dart';

/// 当前选中的项目 ID（null = 所有项目）
final selectedProjectIdProvider = StateProvider<String?>((_) => null);

/// 项目导航侧边栏
class ProjectNavSidebar extends ConsumerWidget {
  final VoidCallback onNewTask;
  final VoidCallback onNewProject;

  const ProjectNavSidebar({
    super.key,
    required this.onNewTask,
    required this.onNewProject,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(projectNotifierProvider);
    final tasksAsync = ref.watch(taskNotifierProvider);
    final selectedId = ref.watch(selectedProjectIdProvider);

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          width: 280,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.5),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1E293B).withValues(alpha: 0.06),
                blurRadius: 32,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 标题栏
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF004AC6), Color(0xFF2563EB)],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.folder_outlined,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Projects',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1C1D),
                          letterSpacing: -0.3,
                        ),
                      ),
                    ],
                  ),
                  _AddButton(onTap: onNewProject),
                ],
              ),
              const SizedBox(height: 20),

              // To Do 行（不含已完成任务）
              _ProjectNavItem(
                icon: Icons.layers_outlined,
                label: 'To Do',
                color: const Color(0xFF2563EB),
                count: _pendingCount(tasksAsync),
                isSelected: selectedId == null,
                onTap: () => ref.read(selectedProjectIdProvider.notifier).state = null,
              ),
              const SizedBox(height: 4),

              // Completed 行
              _ProjectNavItem(
                icon: Icons.check_circle_outline,
                label: 'Completed',
                color: const Color(0xFF10B981),
                count: _completedCount(tasksAsync),
                isSelected: selectedId == '__completed__',
                onTap: () => ref.read(selectedProjectIdProvider.notifier).state = '__completed__',
              ),
              const SizedBox(height: 4),

              // 分割线
              Container(
                height: 1,
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      const Color(0xFFE2E8F0).withValues(alpha: 0.5),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // 项目列表标题
              const Padding(
                padding: EdgeInsets.only(left: 4, bottom: 8),
                child: Text(
                  'MY PROJECTS',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF8E8EA0),
                    letterSpacing: 1.2,
                  ),
                ),
              ),

              // 项目列表
              // 不使用 Expanded，因为 BackdropFilter 在无界约束下无法正确布局
              projectsAsync.when(
                loading: () => SizedBox(
                  height: 120,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF2563EB),
                      strokeWidth: 2,
                    ),
                  ),
                ),
                error: (e, _) => SizedBox(
                  height: 80,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.red.shade300,
                          size: 24,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Failed to load',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.red.shade400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                data: (projects) {
                  if (projects.isEmpty) {
                    return SizedBox(
                      height: 120,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Color(0xFFF1F5F9),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.folder_open,
                                color: Color(0xFF64748B),
                                size: 24,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              'No projects yet',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF334155),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Tap + to create one',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  final uncategorizedCount = _uncategorizedCount(tasksAsync);
                  final hasUncategorized = uncategorizedCount > 0;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: projects.length + (hasUncategorized ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (hasUncategorized && index == projects.length) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: _ProjectNavItem(
                            icon: Icons.folder_off_outlined,
                            label: 'Uncategorized',
                            color: const Color(0xFF64748B),
                            count: uncategorizedCount,
                            isSelected: selectedId == '__uncategorized__',
                            onTap: () => ref.read(selectedProjectIdProvider.notifier).state = '__uncategorized__',
                          ),
                        );
                      }
                      final project = projects[index];
                      final count = _projectCount(tasksAsync, project.id);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: _ProjectNavItem(
                          icon: Icons.folder_outlined,
                          label: project.name,
                          color: _parseColor(project.color),
                          count: count,
                          isSelected: selectedId == project.id,
                          onTap: () =>
                              ref.read(selectedProjectIdProvider.notifier).state = project.id,
                          onEdit: () => _showEditProjectDialog(context, ref, project),
                          onDelete: () => _confirmDeleteProject(context, ref, project),
                        ),
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 16),

              // New Task 快捷按钮
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF004AC6), Color(0xFF2563EB)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2563EB).withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onNewTask,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'New Task',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
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

  int _pendingCount(AsyncValue<List<Task>> tasksAsync) {
    return tasksAsync.valueOrNull
            ?.where((t) => !t.isCompleted && t.deletedAt == null)
            .length ??
        0;
  }

  int _projectCount(AsyncValue<List<Task>> tasksAsync, String projectId) {
    return tasksAsync.valueOrNull
            ?.where((t) => t.projectId == projectId && t.deletedAt == null)
            .length ??
        0;
  }

  int _completedCount(AsyncValue<List<Task>> tasksAsync) {
    return tasksAsync.valueOrNull
            ?.where((t) => t.isCompleted && t.deletedAt == null)
            .length ??
        0;
  }

  int _uncategorizedCount(AsyncValue<List<Task>> tasksAsync) {
    return tasksAsync.valueOrNull
            ?.where((t) => t.projectId == null && t.deletedAt == null)
            .length ??
        0;
  }

  Color _parseColor(String color) {
    try {
      return Color(int.parse(color.replaceFirst('#', '0xFF')));
    } catch (_) {
      return const Color(0xFF004AC6);
    }
  }

  void _showEditProjectDialog(BuildContext context, WidgetRef ref, Project project) {
    showDialog(
      context: context,
      builder: (_) => _ProjectDialog(
        initialName: project.name,
        initialColor: project.color,
        title: 'Edit Project',
        onSave: (name, color) {
          ref.read(projectNotifierProvider.notifier).updateProject(
                project.id,
                ProjectUpdate(name: name, color: color),
              );
        },
      ),
    );
  }

  void _confirmDeleteProject(BuildContext context, WidgetRef ref, Project project) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.delete_outline, color: Colors.red.shade400, size: 20),
            ),
            const SizedBox(width: 12),
            const Text('Delete Project?'),
          ],
        ),
        content: Text(
          'Delete "${project.name}"? Tasks will remain but move to "All Tasks".',
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(projectNotifierProvider.notifier).deleteProject(project.id);
              if (ref.read(selectedProjectIdProvider) == project.id) {
                ref.read(selectedProjectIdProvider.notifier).state = null;
              }
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

/// 单个项目导航行
class _ProjectNavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const _ProjectNavItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.count,
    required this.isSelected,
    required this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  State<_ProjectNavItem> createState() => _ProjectNavItemState();
}

class _ProjectNavItemState extends State<_ProjectNavItem> {
  bool _isHovered = false;

  /// Safe setState that prevents _debugDuringDeviceUpdate assertion failure
  void _safeSetState(VoidCallback fn) {
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(fn);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _safeSetState(() => _isHovered = true),
      onExit: (_) => _safeSetState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? widget.color.withValues(alpha: 0.12)
                : _isHovered
                    ? const Color(0xFFF1F5F9)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: widget.isSelected
                ? Border.all(color: widget.color.withValues(alpha: 0.2), width: 1)
                : null,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: widget.color.withValues(alpha: widget.isSelected ? 0.15 : 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(widget.icon, size: 16, color: widget.color),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.label,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: widget.isSelected ? widget.color : const Color(0xFF334155),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (widget.count > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: widget.isSelected
                        ? widget.color.withValues(alpha: 0.15)
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '${widget.count}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: widget.isSelected ? widget.color : const Color(0xFF64748B),
                    ),
                  ),
                ),
              if (_isHovered && (widget.onEdit != null || widget.onDelete != null)) ...[
                const SizedBox(width: 6),
                _SmallIconBtn(
                  icon: Icons.edit_outlined,
                  onTap: widget.onEdit,
                  tooltip: 'Edit',
                ),
                _SmallIconBtn(
                  icon: Icons.delete_outline,
                  onTap: widget.onDelete,
                  tooltip: 'Delete',
                  color: Colors.red.shade400,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SmallIconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final String tooltip;
  final Color? color;

  const _SmallIconBtn({
    required this.icon,
    this.onTap,
    required this.tooltip,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(
            icon,
            size: 14,
            color: color ?? const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AddButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF004AC6), Color(0xFF2563EB)],
            ),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2563EB).withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(
            Icons.add,
            size: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

/// 创建/编辑项目弹窗
class _ProjectDialog extends StatefulWidget {
  final String? initialName;
  final String? initialColor;
  final String title;
  final void Function(String name, String color) onSave;

  const _ProjectDialog({
    this.initialName,
    this.initialColor,
    required this.title,
    required this.onSave,
  });

  @override
  State<_ProjectDialog> createState() => _ProjectDialogState();
}

class _ProjectDialogState extends State<_ProjectDialog> {
  late final TextEditingController _nameController;
  String? _selectedColorHex;
  double _hue = 217;

  static const _colorOptions = [
    Color(0xFF004AC6),
    Color(0xFF2563EB),
    Color(0xFF7C3AED),
    Color(0xFFDB2777),
    Color(0xFFDC2626),
    Color(0xFFEA580C),
    Color(0xFFCA8A04),
    Color(0xFF16A34A),
    Color(0xFF0D9488),
    Color(0xFF64748B),
  ];

  Color get _currentColor {
    if (_selectedColorHex != null) {
      try {
        return Color(int.parse(_selectedColorHex!.replaceFirst('#', '0xFF')));
      } catch (_) {}
    }
    return _colorOptions[0];
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName ?? '');
    _selectedColorHex = widget.initialColor;
    if (_selectedColorHex != null) {
      final c = _currentColor;
      _hue = HSLColor.fromColor(c).hue;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  String _colorToHex(Color c) =>
      '#${c.toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';

  @override
  Widget build(BuildContext context) {
    final currentColor = _currentColor;
    final screenWidth = MediaQuery.of(context).size.width;
    final dialogWidth = screenWidth > 600 ? 400.0 : screenWidth * 0.88;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      elevation: 0,
      backgroundColor: const Color(0xFFFFFFFF),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: dialogWidth),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          currentColor,
                          currentColor.withAlpha(180),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: currentColor.withAlpha(50),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(
                      widget.initialName == null
                          ? Icons.create_new_folder_rounded
                          : Icons.edit_rounded,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    widget.title,
                    style: GoogleFonts.nunito(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1A1C1D),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),

              // ── Name input ──
              TextField(
                controller: _nameController,
                autofocus: true,
                style: GoogleFonts.nunito(
                    fontSize: 14, fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                  hintText: 'Project name...',
                  hintStyle: GoogleFonts.nunito(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF434655).withAlpha(150),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF3F3F6),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                        color: Color(0xFFD8D8E0), width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                        color: Color(0xFFD8D8E0), width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                        color: Color(0xFF2563EB), width: 1.5),
                  ),
                ),
                onSubmitted: (_) => _save(),
              ),
              const SizedBox(height: 20),

              // ── Color picker (inline) ──
              // Base color row
              Row(
                children: [
                  for (final c in _colorOptions)
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: GestureDetector(
                        onTap: () {
                          final hsl = HSLColor.fromColor(c);
                          setState(() {
                            _selectedColorHex = _colorToHex(c);
                            _hue = hsl.hue;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            color: c,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _colorToHex(c) == _selectedColorHex
                                  ? Colors.white
                                  : Colors.transparent,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: c.withAlpha(
                                    _colorToHex(c) == _selectedColorHex ? 70 : 25),
                                blurRadius:
                                    _colorToHex(c) == _selectedColorHex ? 6 : 3,
                              ),
                            ],
                          ),
                          child: _colorToHex(c) == _selectedColorHex
                              ? const Icon(Icons.check_rounded,
                                  size: 14, color: Colors.white)
                              : null,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),

              // Hue slider
              Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: currentColor,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: currentColor.withAlpha(60),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Container(
                            height: 12,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              gradient: LinearGradient(
                                colors: List.generate(
                                  36,
                                  (i) =>
                                      HSLColor.fromAHSL(1, i * 10.0, 1, 0.5)
                                          .toColor(),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SliderTheme(
                          data: SliderThemeData(
                            trackHeight: 12,
                            thumbShape:
                                const RoundSliderThumbShape(enabledThumbRadius: 8),
                            overlayShape:
                                const RoundSliderOverlayShape(overlayRadius: 14),
                            activeTrackColor: Colors.transparent,
                            inactiveTrackColor: Colors.transparent,
                          ),
                          child: Slider(
                            value: _hue,
                            min: 0,
                            max: 360,
                            onChanged: (v) {
                              setState(() {
                                _hue = v;
                                final c = HSLColor.fromAHSL(1, v, 0.7, 0.55)
                                    .toColor();
                                _selectedColorHex = _colorToHex(c);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ── Buttons ──
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFEFF2),
                          borderRadius: BorderRadius.circular(9999),
                        ),
                        child: Center(
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.nunito(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF434655),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: _save,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF2563EB),
                              Color(0xFF4A8AF5),
                            ],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(9999)),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x402563EB),
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Save',
                            style: GoogleFonts.nunito(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
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
    );
  }

  void _save() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    final color = _selectedColorHex ?? _colorToHex(_colorOptions[0]);
    widget.onSave(name, color);
    Navigator.pop(context);
  }
}

/// 供外部调用创建项目弹窗
void showCreateProjectDialog(BuildContext context, void Function(String name, String color) onSave) {
  showDialog(
    context: context,
    builder: (_) => _ProjectDialog(
      title: 'New Project',
      onSave: onSave,
    ),
  );
}
