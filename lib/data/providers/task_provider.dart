import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/task_service.dart';
import '../models/task_models.dart';
import '../../core/network/network_manager.dart';

final taskServiceProvider = FutureProvider<TaskService>((ref) async {
  final dio = await ref.watch(dioProvider.future);
  final service = TaskService(dio);
  await service.ensureDatabaseInitialized();
  return service;
});

final taskNotifierProvider = AsyncNotifierProvider<TaskNotifier, List<Task>>(() {
  return TaskNotifier();
});

class TaskNotifier extends AsyncNotifier<List<Task>> {
  @override
  Future<List<Task>> build() async {
    final service = await ref.watch(taskServiceProvider.future);
    return service.getTasks();
  }

  Future<void> refreshTasks() async {
    final service = await ref.watch(taskServiceProvider.future);
    state = await AsyncValue.guard(() => service.getTasks());
  }

  /// 获取所有任务（包括已删除的）
  Future<List<Task>> getAllTasks() async {
    final service = await ref.watch(taskServiceProvider.future);
    return service.getAllTasks();
  }

  Future<void> addTask(TaskCreate taskCreate) async {
    final service = await ref.watch(taskServiceProvider.future);
    final newTask = await service.createTask(taskCreate);

    state = state.whenData((tasks) => [newTask, ...tasks]);
  }

  Future<void> updateTask(String id, TaskUpdate taskUpdate) async {
    final service = await ref.watch(taskServiceProvider.future);
    final updatedTask = await service.updateTask(id, taskUpdate);

    state = state.whenData((tasks) => tasks.map((task) {
      return task.id == id ? updatedTask : task;
    }).toList());
  }

  Future<void> deleteTask(String id) async {
    final service = await ref.watch(taskServiceProvider.future);
    await service.deleteTask(id);

    state = state.whenData((tasks) => tasks.where((task) => task.id != id).toList());
  }

  Future<void> toggleTaskCompletion(String id) async {
    // 立即更新UI状态（同步操作）
    if (state is AsyncData<List<Task>>) {
      final currentTasks = (state as AsyncData<List<Task>>).value;
      final updatedTasks = currentTasks.map((task) {
        if (task.id == id) {
          return task.copyWith(isCompleted: !task.isCompleted);
        }
        return task;
      }).toList();
      state = AsyncValue.data(updatedTasks);
    }

    // 然后在后台执行服务操作
    try {
      final service = await ref.watch(taskServiceProvider.future);
      await service.toggleTaskCompletion(id);
      // 不再更新状态，因为我们已经在本地同步更新了
    } catch (e) {
      // 操作失败时可以考虑恢复任务状态
      // 这里暂时不处理，因为任务状态已经在UI中更新
    }
  }

  Future<void> toggleTaskStar(String id) async {
    final service = await ref.watch(taskServiceProvider.future);
    final updatedTask = await service.toggleTaskStar(id);

    state = state.whenData((tasks) => tasks.map((task) {
      return task.id == id ? updatedTask : task;
    }).toList());
  }

  Future<Task> getTaskById(String id) async {
    final service = await ref.watch(taskServiceProvider.future);
    return service.getTaskById(id);
  }

  /// 按关键词搜索任务（优先本地 SQLite）
  Future<List<Task>> searchTasks(String query) async {
    final service = await ref.watch(taskServiceProvider.future);
    return service.searchTasks(query);
  }

  // ─── 回收站方法 ───────────────────────────────────────────

  /// 移动任务到回收站（软删除）
  Future<void> moveToTrash(String id) async {
    // 立即从列表中移除（同步操作）
    if (state is AsyncData<List<Task>>) {
      final currentTasks = (state as AsyncData<List<Task>>).value;
      final updatedTasks = currentTasks.where((task) => task.id != id).toList();
      state = AsyncValue.data(updatedTasks);
    }

    // 然后在后台执行服务操作
    try {
      final service = await ref.watch(taskServiceProvider.future);
      await service.moveToTrash(id);
      // 通知回收站刷新
      await ref.read(trashNotifierProvider.notifier).refreshTrash();
    } catch (e) {
      // 操作失败时可以考虑恢复任务
      // 这里暂时不处理，因为任务已经从UI中移除
    }
  }

  /// 从回收站恢复任务
  Future<void> restoreTask(String id) async {
    final service = await ref.watch(taskServiceProvider.future);
    final restoredTask = await service.restoreTask(id);

    // 只有当任务成功恢复时才添加回列表
    if (restoredTask != null) {
      if (state is AsyncData<List<Task>>) {
        final currentTasks = (state as AsyncData<List<Task>>).value;
        final updatedTasks = [restoredTask, ...currentTasks];
        state = AsyncValue.data(updatedTasks);
      }
    }
  }

  /// 永久删除任务
  Future<void> permanentDelete(String id) async {
    // 立即从列表中移除（同步操作）
    if (state is AsyncData<List<Task>>) {
      final currentTasks = (state as AsyncData<List<Task>>).value;
      final updatedTasks = currentTasks.where((task) => task.id != id).toList();
      state = AsyncValue.data(updatedTasks);
    }

    // 然后在后台执行服务操作
    try {
      final service = await ref.watch(taskServiceProvider.future);
      await service.permanentDelete(id);
    } catch (e) {
      // 操作失败时可以考虑恢复任务
      // 这里暂时不处理，因为任务已经从UI中移除
    }
  }

  /// 获取回收站任务
  Future<List<Task>> getTrashTasks() async {
    final service = await ref.watch(taskServiceProvider.future);
    return service.getTrashTasks();
  }

  /// 自动清理超过 30 天的回收站任务
  Future<void> autoCleanupTrash() async {
    final service = await ref.watch(taskServiceProvider.future);
    await service.autoCleanupTrash();
  }
}

// ─── 回收站 Provider ───────────────────────────────────────
final trashNotifierProvider = AsyncNotifierProvider<TrashNotifier, List<Task>>(() {
  return TrashNotifier();
});

class TrashNotifier extends AsyncNotifier<List<Task>> {
  @override
  Future<List<Task>> build() async {
    final service = await ref.watch(taskServiceProvider.future);
    // 自动清理超过 30 天的任务
    await service.autoCleanupTrash();
    return service.getTrashTasks();
  }

  Future<void> refreshTrash() async {
    final service = await ref.watch(taskServiceProvider.future);
    state = await AsyncValue.guard(() => service.getTrashTasks());
  }

  Future<void> restoreTask(String id) async {
    // 立即从回收站移除（同步操作）
    if (state is AsyncData<List<Task>>) {
      final currentTasks = (state as AsyncData<List<Task>>).value;
      final updatedTasks = currentTasks.where((task) => task.id != id).toList();
      state = AsyncValue.data(updatedTasks);
    }

    // 然后在后台执行服务操作
    try {
      final service = await ref.watch(taskServiceProvider.future);
      final restoredTask = await service.restoreTask(id);

      // 只有当任务成功恢复时才更新主列表
      if (restoredTask != null) {
        // 添加到主列表（这已经会更新状态了，不需要再调用refreshTasks）
        ref.read(taskNotifierProvider.notifier).restoreTask(id);
      }
    } catch (e) {
      // 操作失败时可以考虑恢复任务
      // 这里暂时不处理，因为任务已经从UI中移除
    }
  }

  Future<void> permanentDelete(String id) async {
    // 立即从回收站移除（同步操作）
    if (state is AsyncData<List<Task>>) {
      final currentTasks = (state as AsyncData<List<Task>>).value;
      final updatedTasks = currentTasks.where((task) => task.id != id).toList();
      state = AsyncValue.data(updatedTasks);
    }

    // 然后在后台执行服务操作
    try {
      final service = await ref.watch(taskServiceProvider.future);
      await service.permanentDelete(id);
    } catch (e) {
      // 操作失败时可以考虑恢复任务
      // 这里暂时不处理，因为任务已经从UI中移除
    }
  }

  Future<void> emptyTrash() async {
    final tasks = state.valueOrNull ?? [];
    for (final task in tasks) {
      await permanentDelete(task.id);
    }
  }
}

final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  final service = await ref.watch(taskServiceProvider.future);
  return service.getCategories();
});

final focusNotifierProvider = AsyncNotifierProvider<FocusNotifier, FocusStats>(() {
  return FocusNotifier();
});

class FocusNotifier extends AsyncNotifier<FocusStats> {
  @override
  Future<FocusStats> build() async {
    final service = await ref.watch(taskServiceProvider.future);
    return service.getFocusStats();
  }

  Future<FocusSession> startFocusSession(String? taskId, int duration) async {
    final service = await ref.watch(taskServiceProvider.future);
    return service.startFocusSession(taskId, duration);
  }

  Future<FocusSession> endFocusSession(String id) async {
    final service = await ref.watch(taskServiceProvider.future);
    final session = await service.endFocusSession(id);
    state = await AsyncValue.guard(() => service.getFocusStats());
    return session;
  }

  Future<void> refreshStats() async {
    state = const AsyncValue.loading();
    final service = await ref.watch(taskServiceProvider.future);
    state = await AsyncValue.guard(() => service.getFocusStats());
  }

  Future<List<FocusSession>> getFocusSessions() async {
    final service = await ref.watch(taskServiceProvider.future);
    return service.getFocusSessions();
  }
}
