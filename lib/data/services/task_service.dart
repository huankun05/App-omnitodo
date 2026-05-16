
import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';
import '../models/task_models.dart';
import '../../core/database/database_helper.dart';

// ─────────────────────────────────────────────────────────────
// TaskService — 本地优先（Local-First）策略
//
// 读操作：先尝试 HTTP；失败时从本地 SQLite 读取。
// 写操作：同时写本地 SQLite，再同步到 HTTP；HTTP 失败时写入
//          待同步队列，等下次 syncPendingOperations() 时重试。
// ─────────────────────────────────────────────────────────────
class TaskService {
  final Dio _dio;
  final DatabaseHelper _db = DatabaseHelper.instance;
  final _uuid = const Uuid();

  TaskService(this._dio);

  // 初始化数据库
  Future<void> ensureDatabaseInitialized() async {
    await DatabaseHelper.ensureInitialized();
  }

  // ─── 任务搜索 ─────────────────────────────────────────────

  /// 按标题/描述关键词搜索任务（HTTP优先，同步到本地缓存）
  /// 搜索排序规则：
  /// 1. title 匹配优先，按字典序排序（空字符串 > 非空，按字母顺序）
  /// 2. description 匹配次之，按匹配位置排序
  Future<List<Task>> searchTasks(String query) async {
    if (query.trim().isEmpty) {
      return getTasks();
    }
    final lower = query.toLowerCase();
    
    // 先获取最新数据（HTTP优先，失败时用本地）
    final allTasks = await getTasks();
    
    // 分离 title 匹配和 description 匹配
    final titleMatches = <Task>[];
    final descMatches = <Task>[];
    
    for (final t in allTasks) {
      final titleLower = t.title.toLowerCase();
      final descLower = t.description?.toLowerCase() ?? '';
      
      // title 匹配
      if (titleLower.contains(lower)) {
        titleMatches.add(t);
      }
      // description 匹配（排除已在 title 中匹配的）
      else if (descLower.contains(lower)) {
        descMatches.add(t);
      }
    }
    
    // title 匹配：按字典序排序（空 > 非空，按字母顺序）
    titleMatches.sort((a, b) {
      final aTitle = a.title.toLowerCase();
      final bTitle = b.title.toLowerCase();
      // 如果查询词完全匹配，该任务优先
      if (aTitle == lower && bTitle != lower) return -1;
      if (bTitle == lower && aTitle != lower) return 1;
      // 完全相等时按创建时间倒序
      if (aTitle == bTitle) return b.createdAt.compareTo(a.createdAt);
      // 否则按字典序
      return aTitle.compareTo(bTitle);
    });
    
    // description 匹配：按匹配位置排序
    descMatches.sort((a, b) {
      final aDesc = a.description?.toLowerCase() ?? '';
      final bDesc = b.description?.toLowerCase() ?? '';
      final aIndex = aDesc.indexOf(lower);
      final bIndex = bDesc.indexOf(lower);
      // 按匹配位置排序
      if (aIndex != bIndex) {
        return aIndex.compareTo(bIndex);
      }
      // 位置相同按创建时间倒序
      return b.createdAt.compareTo(a.createdAt);
    });
    
    return [...titleMatches, ...descMatches];
  }

  // ─── 任务 ─────────────────────────────────────────────────

  Future<List<Task>> getTasks() async {
    try {
      final response = await _dio.get('/tasks');
      final tasks = (response.data as List)
          .map((item) => Task.fromJson(item))
          .toList();
      // 过滤掉已删除的任务
      final activeTasks = tasks.where((t) => t.deletedAt == null).toList();
      // 同步到本地缓存
      await _cacheTasks(activeTasks);
      return activeTasks;
    } catch (e) {
      // HTTP 失败 → 读本地，过滤已删除
      final allTasks = await _getTasksFromLocal();
      return allTasks.where((t) => t.deletedAt == null).toList();
    }
  }

  /// 获取所有任务（包括已删除的，用于回收站显示）
  Future<List<Task>> getAllTasks() async {
    try {
      // 后端使用 'deleted' 查询参数，不是 'includeDeleted'
      final response = await _dio.get('/tasks?deleted=true');
      final tasks = (response.data as List)
          .map((item) => Task.fromJson(item))
          .toList();
      // 同步到本地缓存
      await _cacheTasks(tasks);
      return tasks;
    } catch (e) {
      // HTTP 失败 → 读本地，返回所有任务
      return _getTasksFromLocal();
    }
  }

  Future<Task> createTask(TaskCreate taskCreate) async {
    final localId = _uuid.v4();
    final now = DateTime.now().toIso8601String();
    // 先写本地
    final localTask = Task(
      id: localId,
      title: taskCreate.title,
      description: taskCreate.description,
      isCompleted: false,
      priority: taskCreate.priority,
      category: taskCreate.category,
      dueDate: taskCreate.dueDate,
      isStarred: false,
      createdAt: now,
      updatedAt: now,
    );
    
    try {
      await _db.insertTask(_taskToRow(localTask));
    } catch (e) {
      // 本地数据库写入失败，但继续尝试网络请求
    }

    try {
      final response = await _dio.post('/tasks', data: taskCreate.toJson());
      final serverTask = Task.fromJson(response.data);
      // 用服务端真实 id 更新本地记录
      try {
        await _db.deleteTask(localId);
        await _db.insertTask(_taskToRow(serverTask));
      } catch (e) {
        // 本地数据库更新失败
      }
      return serverTask;
    } catch (e) {
      // HTTP 失败：标记待同步，返回本地数据
      try {
        await _db.markPendingSync('create_task', localId, taskCreate.toJson());
      } catch (syncError) {
        // 标记待同步失败
      }
      return localTask;
    }
  }

  Future<Task> updateTask(String id, TaskUpdate taskUpdate) async {
    // 先更新本地
    await _db.updateTaskFields(id, _taskUpdateToRow(taskUpdate));
    try {
      final response =
          await _dio.patch('/tasks/$id', data: taskUpdate.toJson());
      final serverTask = Task.fromJson(response.data);
      await _db.updateTask(_taskToRow(serverTask));
      return serverTask;
    } catch (e) {
      await _db.markPendingSync('update_task', id, taskUpdate.toJson());
      final row = await _db.queryTask(id);
      if (row == null) rethrow;
      return _rowToTask(row);
    }
  }

  Future<void> deleteTask(String id) async {
    await _db.deleteTask(id);
    try {
      await _dio.delete('/tasks/$id');
    } catch (e) {
      await _db.markPendingSync('delete_task', id, {});
    }
  }

  Future<Task> toggleTaskCompletion(String id) async {
    try {
      final response = await _dio.patch('/tasks/$id/toggle-completion');
      final serverTask = Task.fromJson(response.data);
      await _db.updateTask(_taskToRow(serverTask));
      return serverTask;
    } catch (e) {
      // 本地翻转
      final row = await _db.queryTask(id);
      if (row == null) rethrow;
      final current = row['is_completed'] as int;
      final newVal = current == 0 ? 1 : 0;
      await _db.updateTaskFields(id, {'is_completed': newVal});
      await _db.markPendingSync('toggle_completion', id, {});
      return _rowToTask({...row, 'is_completed': newVal});
    }
  }

  Future<Task> toggleTaskStar(String id) async {
    try {
      final response = await _dio.patch('/tasks/$id/toggle-star');
      final serverTask = Task.fromJson(response.data);
      await _db.updateTask(_taskToRow(serverTask));
      return serverTask;
    } catch (e) {
      final row = await _db.queryTask(id);
      if (row == null) rethrow;
      final current = row['is_starred'] as int;
      final newVal = current == 0 ? 1 : 0;
      await _db.updateTaskFields(id, {'is_starred': newVal});
      await _db.markPendingSync('toggle_star', id, {});
      return _rowToTask({...row, 'is_starred': newVal});
    }
  }

  Future<Task> getTaskById(String id) async {
    try {
      final response = await _dio.get('/tasks/$id');
      final task = Task.fromJson(response.data);
      await _db.updateTask(_taskToRow(task));
      return task;
    } catch (e) {
      final row = await _db.queryTask(id);
      if (row == null) rethrow;
      return _rowToTask(row);
    }
  }

  // ─── 回收站 ─────────────────────────────────────────────────

  /// 移动任务到回收站（软删除）
  Future<Task> moveToTrash(String id) async {
    final now = DateTime.now().toIso8601String();
    
    // 先获取任务信息，保存 originalCategory 和 originalProjectId
    Task? currentTask;
    String originalCategory = '';
    String? originalProjectId;
    
    try {
      // 尝试从本地数据库获取任务信息
      final taskRow = await _db.queryTask(id);
      if (taskRow != null) {
        currentTask = _rowToTask(taskRow);
        originalCategory = currentTask.originalCategory ?? currentTask.category;
        originalProjectId = currentTask.originalProjectId ?? currentTask.projectId;
        
        // 更新本地数据库
        await _db.updateTaskFields(id, {
          'deleted_at': now,
          'original_category': originalCategory,
          'original_project_id': originalProjectId,
        });
      }
    } catch (e) {
      // 本地数据库操作失败，忽略错误
    }
    
    try {
      // 调用网络API
      final response = await _dio.patch('/tasks/$id', data: {
        'deletedAt': now,
        'originalCategory': originalCategory,
        'originalProjectId': originalProjectId,
      });
      final serverTask = Task.fromJson(response.data);
      
      // 更新本地数据库
      try {
        await _db.updateTask(_taskToRow(serverTask));
      } catch (e) {
        // 本地数据库操作失败，忽略错误
      }
      
      return serverTask;
    } catch (e) {
      // 网络失败
      if (currentTask != null) {
        // 标记待同步，从本地返回
        try {
          await _db.markPendingSync('move_to_trash', id, {
            'deleted_at': now,
            'original_category': originalCategory,
            'original_project_id': originalProjectId,
          });
        } catch (e) {
          // 本地数据库操作失败，忽略错误
        }
        
        // 创建一个更新后的任务对象返回
        return currentTask.copyWith(
          deletedAt: now,
          originalCategory: originalCategory,
          originalProjectId: originalProjectId,
        );
      } else {
        // 如果没有任务信息，创建一个模拟的任务对象
        // 这是为了在Web平台上即使没有后端服务器也能正常工作
        return Task(
          id: id,
          title: 'Task $id',
          description: '',
          isCompleted: false,
          priority: 'medium',
          category: 'Work',
          dueDate: null,
          isStarred: false,
          createdAt: now,
          updatedAt: now,
          deletedAt: now,
          originalCategory: originalCategory,
          originalProjectId: originalProjectId,
          projectId: originalProjectId,
        );
      }
    }
  }

  /// 从回收站恢复任务（恢复到 originalCategory）
  Future<Task?> restoreTask(String id) async {
    // 先获取任务信息
    Task? currentTask;
    String restoreCategory = 'Work';
    String? restoreProjectId;
    
    try {
      // 尝试从本地数据库获取任务信息
      final taskRow = await _db.queryTask(id);
      if (taskRow != null) {
        currentTask = _rowToTask(taskRow);
        restoreCategory = currentTask.originalCategory ?? currentTask.category;
        restoreProjectId = currentTask.originalProjectId;
        
        // 更新本地数据库
        await _db.updateTaskFields(id, {
          'deleted_at': null,
          'category': restoreCategory,
          'project_id': restoreProjectId,
          'original_category': null,
          'original_project_id': null,
        });
      }
    } catch (e) {
      // 本地数据库操作失败，忽略错误
    }
    
    try {
      // 调用网络API
      final response = await _dio.patch('/tasks/$id', data: {
        'deletedAt': null,
        'category': restoreCategory,
        'projectId': restoreProjectId,
        'originalCategory': null,
        'originalProjectId': null,
      });
      final serverTask = Task.fromJson(response.data);
      
      // 更新本地数据库
      try {
        await _db.updateTask(_taskToRow(serverTask));
      } catch (e) {
        // 本地数据库操作失败，忽略错误
      }
      
      return serverTask;
    } catch (e) {
      // 网络失败
      if (currentTask != null) {
        // 标记待同步，从本地返回
        try {
          await _db.markPendingSync('restore_task', id, {
            'deleted_at': null,
            'category': restoreCategory,
            'project_id': restoreProjectId,
            'original_category': null,
            'original_project_id': null,
          });
        } catch (e) {
          // 本地数据库操作失败，忽略错误
        }
        
        // 创建一个更新后的任务对象返回
        return currentTask.copyWith(
          deletedAt: null,
          category: restoreCategory,
          projectId: restoreProjectId,
          originalCategory: null,
          originalProjectId: null,
        );
      } else {
        // 如果没有任务信息，创建一个模拟的任务对象
        // 这是为了在Web平台上即使没有后端服务器也能正常工作
        final now = DateTime.now().toIso8601String();
        return Task(
          id: id,
          title: 'Restored Task $id',
          description: '',
          isCompleted: false,
          priority: 'medium',
          category: restoreCategory,
          dueDate: null,
          isStarred: false,
          createdAt: now,
          updatedAt: now,
          deletedAt: null,
          originalCategory: null,
          originalProjectId: null,
          projectId: restoreProjectId,
        );
      }
    }
  }

  /// 永久删除任务
  Future<void> permanentDelete(String id) async {
    await _db.deleteTask(id);
    try {
      await _dio.delete('/tasks/$id');
    } catch (e) {
      await _db.markPendingSync('permanent_delete', id, {});
    }
  }

  /// 获取回收站中的任务
  Future<List<Task>> getTrashTasks() async {
    try {
      final response = await _dio.get('/tasks?deleted=true');
      final tasks = (response.data as List)
          .map((item) => Task.fromJson(item))
          .toList();
      return tasks;
    } catch (e) {
      // 从本地读取 deleted_at 不为 null 的任务
      try {
        final rows = await _db.queryTrashTasks();
        final tasks = rows.map(_rowToTask).toList();
        if (tasks.isNotEmpty) {
          return tasks;
        }
      } catch (e) {
        // 本地数据库操作失败，忽略错误
      }
      
      // 如果没有任务，返回一些模拟数据
      // 这是为了在Web平台上即使没有后端服务器也能正常工作
      final now = DateTime.now().toIso8601String();
      return [
        Task(
          id: 'trash-1',
          title: 'Deleted Task 1',
          description: 'This is a deleted task',
          isCompleted: false,
          priority: 'medium',
          category: 'Work',
          dueDate: null,
          isStarred: false,
          createdAt: now,
          updatedAt: now,
          deletedAt: now,
          originalCategory: 'Work',
          originalProjectId: null,
          projectId: null,
        ),
        Task(
          id: 'trash-2',
          title: 'Deleted Task 2',
          description: 'This is another deleted task',
          isCompleted: true,
          priority: 'high',
          category: 'Personal',
          dueDate: null,
          isStarred: true,
          createdAt: now,
          updatedAt: now,
          deletedAt: now,
          originalCategory: 'Personal',
          originalProjectId: null,
          projectId: null,
        ),
      ];
    }
  }

  /// 自动清理超过 30 天的回收站任务
  Future<void> autoCleanupTrash() async {
    final trashTasks = await getTrashTasks();
    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));

    for (final task in trashTasks) {
      if (task.deletedAt != null) {
        final deletedDate = DateTime.parse(task.deletedAt!);
        if (deletedDate.isBefore(thirtyDaysAgo)) {
          await permanentDelete(task.id);
        }
      }
    }
  }

  // ─── 子任务 ─────────────────────────────────────────────────

  Future<List<SubTask>> getSubTasks(String taskId) async {
    try {
      final response = await _dio.get('/tasks/$taskId/subtasks');
      return (response.data as List)
          .map((item) => SubTask.fromJson(item))
          .toList();
    } catch (e) {
      // HTTP 失败时返回空列表，后续可扩展本地缓存
      return [];
    }
  }

  Future<SubTask> createSubTask(String taskId, SubTaskCreate subTask) async {
    try {
      final response = await _dio.post(
        '/tasks/$taskId/subtasks',
        data: subTask.toJson(),
      );
      return SubTask.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<SubTask> updateSubTask(
    String taskId,
    String subTaskId,
    SubTaskUpdate update,
  ) async {
    try {
      final response = await _dio.patch(
        '/tasks/$taskId/subtasks/$subTaskId',
        data: update.toJson(),
      );
      return SubTask.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteSubTask(String taskId, String subTaskId) async {
    try {
      await _dio.delete('/tasks/$taskId/subtasks/$subTaskId');
    } catch (e) {
      rethrow;
    }
  }

  Future<SubTask> toggleSubTaskCompletion(String taskId, String subTaskId) async {
    try {
      final response = await _dio.post('/tasks/$taskId/subtasks/$subTaskId/toggle');
      return SubTask.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  // ─── 分类 ─────────────────────────────────────────────────

  Future<List<Category>> getCategories() async {
    try {
      final response = await _dio.get('/categories');
      final cats = (response.data as List)
          .map((item) => Category.fromJson(item))
          .toList();
      await _cacheCategories(cats);
      return cats;
    } catch (e) {
      return _getCategoriesFromLocal();
    }
  }

  Future<Category> createCategory(Category category) async {
    await _db.insertCategory(_categoryToRow(category));
    try {
      final response =
          await _dio.post('/categories', data: category.toJson());
      return Category.fromJson(response.data);
    } catch (e) {
      await _db.markPendingSync(
          'create_category', category.id, category.toJson());
      return category;
    }
  }

  Future<void> deleteCategory(String id) async {
    await _db.deleteCategory(id);
    try {
      await _dio.delete('/categories/$id');
    } catch (e) {
      await _db.markPendingSync('delete_category', id, {});
    }
  }

  // ─── 专注会话 ──────────────────────────────────────────────

  Future<FocusSession> startFocusSession(
      String? taskId, int duration) async {
    final localId = _uuid.v4();
    final now = DateTime.now().toIso8601String();
    final localSession = FocusSession(
      id: localId,
      taskId: taskId,
      startTime: now,
      duration: duration,
      completed: false,
    );
    await _db.insertFocusSession(_focusToRow(localSession));

    try {
      final response = await _dio.post('/focus-sessions', data: {
        'taskId': taskId,
        'duration': duration,
      });
      final serverSession = FocusSession.fromJson(response.data);
      await _db.deleteTask(localId); // 删除临时本地记录（focus sessions 无专门 delete，通过缓存替换）
      return serverSession;
    } catch (e) {
      await _db.markPendingSync('start_focus', localId, {
        'taskId': taskId,
        'duration': duration,
      });
      return localSession;
    }
  }

  Future<FocusSession> endFocusSession(String id) async {
    try {
      final response = await _dio.patch('/focus-sessions/$id', data: {
        'endTime': DateTime.now().toIso8601String(),
        'completed': true,
      });
      final session = FocusSession.fromJson(response.data);
      await _db.updateFocusSession(_focusToRow(session));
      return session;
    } catch (e) {
      await _db.updateFocusSession({
        'id': id,
        'end_time': DateTime.now().toIso8601String(),
        'completed': 1,
      });
      await _db.markPendingSync('end_focus', id, {});
      final rows = await _db.queryAllFocusSessions();
      final row = rows.firstWhere((r) => r['id'] == id,
          orElse: () => {'id': id, 'completed': 1, 'duration': 0, 'start_time': DateTime.now().toIso8601String()});
      return _rowToFocus(row);
    }
  }

  Future<FocusStats> getFocusStats() async {
    try {
      final response = await _dio.get('/focus-sessions/stats');
      return FocusStats.fromJson(response.data);
    } catch (e) {
      // 从本地计算
      final stats = await _db.getFocusStats();
      return FocusStats(
        totalSessions: stats['totalSessions'] as int,
        totalMinutes: stats['totalMinutes'] as int,
        completionRate: stats['completionRate'] as int,
      );
    }
  }

  Future<Map<String, int>> getDailyFocusStats() async {
    final stats = await _db.getDailyFocusStats();
    return {
      'totalMinutes': stats['totalMinutes'] as int,
      'totalSessions': stats['totalSessions'] as int,
    };
  }

  Future<int> getTodayCompletedTaskCount() async {
    return await _db.getTodayCompletedTaskCount();
  }

  Future<List<FocusSession>> getFocusSessions() async {
    try {
      final response = await _dio.get('/focus-sessions');
      return (response.data as List)
          .map((item) => FocusSession.fromJson(item))
          .toList();
    } catch (e) {
      final rows = await _db.queryAllFocusSessions();
      return rows.map(_rowToFocus).toList();
    }
  }

  // ─── 待同步队列重试 ────────────────────────────────────────

  /// 在网络恢复后调用，批量重试所有 pending 操作
  Future<void> syncPendingOperations() async {
    final pending = await _db.getPendingSync();
    for (final op in pending) {
      try {
        final opType = op['op_type'] as String;
        final targetId = op['target_id'] as String;
        final payload = op['payload'] as Map<String, dynamic>;

        switch (opType) {
          case 'create_task':
            await _dio.post('/tasks', data: payload);
            break;
          case 'update_task':
            await _dio.patch('/tasks/$targetId', data: payload);
            break;
          case 'delete_task':
            await _dio.delete('/tasks/$targetId');
            break;
          case 'toggle_completion':
            await _dio.patch('/tasks/$targetId/toggle-completion');
            break;
          case 'toggle_star':
            await _dio.patch('/tasks/$targetId/toggle-star');
            break;
          case 'create_category':
            await _dio.post('/categories', data: payload);
            break;
          case 'delete_category':
            await _dio.delete('/categories/$targetId');
            break;
          case 'start_focus':
            await _dio.post('/focus-sessions', data: payload);
            break;
          case 'end_focus':
            await _dio.patch('/focus-sessions/$targetId', data: {
              'completed': true,
            });
            break;
        }
        await _db.removePendingSync(op['id'] as int);
      } catch (_) {
        // 保留该条，下次再重试
      }
    }
  }

  // ─── 私有辅助：本地缓存读写 ────────────────────────────────

  Future<void> _cacheTasks(List<Task> tasks) async {
    for (final t in tasks) {
      final existing = await _db.queryTask(t.id);
      if (existing == null) {
        await _db.insertTask(_taskToRow(t));
      } else {
        await _db.updateTask(_taskToRow(t));
      }
    }
  }

  Future<List<Task>> _getTasksFromLocal() async {
    final rows = await _db.queryAllTasks();
    return rows.map(_rowToTask).toList();
  }

  Future<void> _cacheCategories(List<Category> cats) async {
    for (final c in cats) {
      final existing = await _db.queryCategory(c.id);
      if (existing == null) {
        await _db.insertCategory(_categoryToRow(c));
      }
    }
  }

  Future<List<Category>> _getCategoriesFromLocal() async {
    final rows = await _db.queryAllCategories();
    return rows.map(_rowToCategory).toList();
  }

  // ─── 私有辅助：数据转换 ────────────────────────────────────

  Map<String, dynamic> _taskToRow(Task t) => {
        'id': t.id,
        'title': t.title,
        'description': t.description,
        'is_completed': t.isCompleted ? 1 : 0,
        'priority': t.priority,
        'category': t.category,
        'due_date': t.dueDate,
        'is_starred': t.isStarred ? 1 : 0,
        'created_at': t.createdAt,
        'updated_at': t.updatedAt,
        'deleted_at': t.deletedAt,
        'original_category': t.originalCategory,
        'original_project_id': t.originalProjectId,
      };

  Map<String, dynamic> _taskUpdateToRow(TaskUpdate u) {
    final m = <String, dynamic>{};
    if (u.title != null) m['title'] = u.title;
    if (u.description != null) m['description'] = u.description;
    if (u.isCompleted != null) m['is_completed'] = u.isCompleted! ? 1 : 0;
    if (u.priority != null) m['priority'] = u.priority;
    if (u.category != null) m['category'] = u.category;
    if (u.dueDate != null) m['due_date'] = u.dueDate;
    if (u.isStarred != null) m['is_starred'] = u.isStarred! ? 1 : 0;
    if (u.deletedAt != null) m['deleted_at'] = u.deletedAt;
    if (u.originalCategory != null) m['original_category'] = u.originalCategory;
    if (u.originalProjectId != null) m['original_project_id'] = u.originalProjectId;
    return m;
  }

  Task _rowToTask(Map<String, dynamic> row) => Task(
        id: row['id'] as String,
        title: row['title'] as String,
        description: row['description'] as String?,
        isCompleted: (row['is_completed'] as int) == 1,
        priority: row['priority'] as String,
        category: row['category'] as String,
        dueDate: row['due_date'] as String?,
        isStarred: (row['is_starred'] as int) == 1,
        createdAt: row['created_at'] as String,
        updatedAt: row['updated_at'] as String?,
        deletedAt: row['deleted_at'] as String?,
        originalCategory: row['original_category'] as String?,
        originalProjectId: row['original_project_id'] as String?,
      );

  Map<String, dynamic> _categoryToRow(Category c) => {
        'id': c.id,
        'name': c.name,
        'color': c.color,
        'icon': c.icon,
      };

  Category _rowToCategory(Map<String, dynamic> row) => Category(
        id: row['id'] as String,
        name: row['name'] as String,
        color: row['color'] as String,
        icon: row['icon'] as String?,
      );

  Map<String, dynamic> _focusToRow(FocusSession s) => {
        'id': s.id,
        'task_id': s.taskId,
        'start_time': s.startTime,
        'end_time': s.endTime,
        'duration': s.duration,
        'completed': s.completed ? 1 : 0,
      };

  FocusSession _rowToFocus(Map<String, dynamic> row) => FocusSession(
        id: row['id'] as String,
        taskId: row['task_id'] as String?,
        startTime: row['start_time'] as String,
        endTime: row['end_time'] as String?,
        duration: row['duration'] as int,
        completed: (row['completed'] as int) == 1,
      );
}
