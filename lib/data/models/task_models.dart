import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_models.freezed.dart';
part 'task_models.g.dart';

@freezed
class SubTask with _$SubTask {
  const factory SubTask({
    required String id,
    required String title,
    required bool completed,
    int? order,
    String? createdAt,
    String? updatedAt,
  }) = _SubTask;

  factory SubTask.fromJson(Map<String, dynamic> json) => _$SubTaskFromJson(json);
}

@freezed
class SubTaskCreate with _$SubTaskCreate {
  const factory SubTaskCreate({
    required String title,
    int? order,
  }) = _SubTaskCreate;

  factory SubTaskCreate.fromJson(Map<String, dynamic> json) => _$SubTaskCreateFromJson(json);
}

@freezed
class SubTaskUpdate with _$SubTaskUpdate {
  const factory SubTaskUpdate({
    String? title,
    bool? completed,
    int? order,
  }) = _SubTaskUpdate;

  factory SubTaskUpdate.fromJson(Map<String, dynamic> json) => _$SubTaskUpdateFromJson(json);
}

/// 任务中引用的轻量项目信息（只含 id/name/color）
@freezed
class ProjectInfo with _$ProjectInfo {
  const factory ProjectInfo({
    required String id,
    required String name,
    required String color,
    String? icon,
  }) = _ProjectInfo;

  factory ProjectInfo.fromJson(Map<String, dynamic> json) =>
      _$ProjectInfoFromJson(json);
}

@freezed
class Task with _$Task {
  const factory Task({
    required String id,
    required String title,
    String? description,
    required bool isCompleted,
    required String priority,
    required String category,
    String? dueDate,
    required bool isStarred,
    required String createdAt,
    String? updatedAt,
    String? deletedAt,           // 回收站：删除时间
    String? originalCategory,    // 删除前的分类，恢复时使用
    String? originalProjectId,   // 删除前的项目，恢复时使用
    String? projectId,
    ProjectInfo? project,
    @Default([]) List<SubTask> subTasks,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
}

@freezed
class TaskCreate with _$TaskCreate {
  const factory TaskCreate({
    required String title,
    String? description,
    required String priority,
    required String category,
    String? dueDate,
    String? projectId,
    List<SubTaskCreate>? subTasks,
  }) = _TaskCreate;

  factory TaskCreate.fromJson(Map<String, dynamic> json) => _$TaskCreateFromJson(json);
}

@freezed
class TaskUpdate with _$TaskUpdate {
  const factory TaskUpdate({
    String? title,
    String? description,
    bool? isCompleted,
    String? priority,
    String? category,
    String? dueDate,
    bool? isStarred,
    String? deletedAt,         // 用于软删除/恢复
    String? originalCategory,  // 删除时保存，恢复时使用
    String? originalProjectId, // 删除时保存，恢复时使用
    String? projectId,         // null = 移出项目
  }) = _TaskUpdate;

  factory TaskUpdate.fromJson(Map<String, dynamic> json) => _$TaskUpdateFromJson(json);
}

@freezed
class Category with _$Category {
  const factory Category({
    required String id,
    required String name,
    required String color,
    String? icon,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);
}

@freezed
class FocusSession with _$FocusSession {
  const factory FocusSession({
    required String id,
    String? taskId,
    required String startTime,
    String? endTime,
    required int duration,
    required bool completed,
  }) = _FocusSession;

  factory FocusSession.fromJson(Map<String, dynamic> json) => _$FocusSessionFromJson(json);
}

@freezed
class FocusStats with _$FocusStats {
  const factory FocusStats({
    required int totalSessions,
    required int totalMinutes,
    required int completionRate,
  }) = _FocusStats;

  factory FocusStats.fromJson(Map<String, dynamic> json) => _$FocusStatsFromJson(json);
}

class DailyFocusStats {
  final int focusMinutes;
  final int focusSessions;
  final int completedTasks;

  const DailyFocusStats({
    required this.focusMinutes,
    required this.focusSessions,
    required this.completedTasks,
  });
}
