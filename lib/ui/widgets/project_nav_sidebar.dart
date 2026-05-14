import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

              // All Tasks 行
              _ProjectNavItem(
                icon: Icons.layers_outlined,
                label: 'All Tasks',
                color: const Color(0xFF2563EB),
                count: _totalCount(tasksAsync),
                isSelected: selectedId == null,
                onTap: () => ref.read(selectedProjectIdProvider.notifier).state = null,
              ),
              const SizedBox(height: 8),

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
                                color: Color(0xFF94A3B8),
                                size: 24,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              'No projects yet',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF64748B),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Tap + to create one',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF94A3B8),
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
                            color: const Color(0xFF94A3B8),
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

  int _totalCount(AsyncValue<List<Task>> tasksAsync) {
    return tasksAsync.valueOrNull?.where((t) => t.deletedAt == null).length ?? 0;
  }

  int _projectCount(AsyncValue<List<Task>> tasksAsync, String projectId) {
    return tasksAsync.valueOrNull
            ?.where((t) => t.projectId == projectId && t.deletedAt == null)
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
            color: color ?? const Color(0xFF94A3B8),
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
  late String _selectedColor;

  static const _colorOptions = [
    '#004AC6', '#2563EB', '#7C3AED', '#DB2777',
    '#DC2626', '#EA580C', '#CA8A04', '#16A34A',
    '#0D9488', '#64748B',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName ?? '');
    _selectedColor = widget.initialColor ?? _colorOptions[0];
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 380,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _parseColor(_selectedColor),
                        _parseColor(_selectedColor).withValues(alpha: 0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    widget.initialName == null ? Icons.create_new_folder : Icons.edit,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1C1D),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 项目名称输入
            TextField(
              controller: _nameController,
              autofocus: true,
              style: const TextStyle(fontSize: 15),
              decoration: InputDecoration(
                labelText: 'Project Name',
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF64748B),
                ),
                hintText: 'Enter project name...',
                hintStyle: TextStyle(color: const Color(0xFF94A3B8)),
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF2563EB), width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
            const SizedBox(height: 20),

            // 颜色选择
            const Text(
              'Choose Color',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Color(0xFF334155),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _colorOptions.map((color) {
                final c = _parseColor(color);
                final isSelected = _selectedColor == color;
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = color),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: c,
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(color: Colors.white, width: 3)
                          : null,
                      boxShadow: isSelected
                          ? [
                              BoxShadow(color: c.withValues(alpha: 0.5), blurRadius: 8),
                            ]
                          : [
                              BoxShadow(
                                color: c.withValues(alpha: 0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white, size: 18)
                        : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 28),

            // 操作按钮
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    final name = _nameController.text.trim();
                    if (name.isEmpty) return;
                    widget.onSave(name, _selectedColor);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _parseColor(String color) {
    try {
      return Color(int.parse(color.replaceFirst('#', '0xFF')));
    } catch (_) {
      return const Color(0xFF004AC6);
    }
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
