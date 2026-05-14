// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SubTaskImpl _$$SubTaskImplFromJson(Map<String, dynamic> json) =>
    _$SubTaskImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      completed: json['completed'] as bool,
      order: (json['order'] as num?)?.toInt(),
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$$SubTaskImplToJson(_$SubTaskImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'completed': instance.completed,
      'order': instance.order,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

_$SubTaskCreateImpl _$$SubTaskCreateImplFromJson(Map<String, dynamic> json) =>
    _$SubTaskCreateImpl(
      title: json['title'] as String,
      order: (json['order'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$SubTaskCreateImplToJson(_$SubTaskCreateImpl instance) =>
    <String, dynamic>{'title': instance.title, 'order': instance.order};

_$SubTaskUpdateImpl _$$SubTaskUpdateImplFromJson(Map<String, dynamic> json) =>
    _$SubTaskUpdateImpl(
      title: json['title'] as String?,
      completed: json['completed'] as bool?,
      order: (json['order'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$SubTaskUpdateImplToJson(_$SubTaskUpdateImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'completed': instance.completed,
      'order': instance.order,
    };

_$ProjectInfoImpl _$$ProjectInfoImplFromJson(Map<String, dynamic> json) =>
    _$ProjectInfoImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      color: json['color'] as String,
      icon: json['icon'] as String?,
    );

Map<String, dynamic> _$$ProjectInfoImplToJson(_$ProjectInfoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'color': instance.color,
      'icon': instance.icon,
    };

_$TaskImpl _$$TaskImplFromJson(Map<String, dynamic> json) => _$TaskImpl(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String?,
  isCompleted: json['isCompleted'] as bool,
  priority: json['priority'] as String,
  category: json['category'] as String,
  dueDate: json['dueDate'] as String?,
  isStarred: json['isStarred'] as bool,
  createdAt: json['createdAt'] as String,
  updatedAt: json['updatedAt'] as String?,
  deletedAt: json['deletedAt'] as String?,
  originalCategory: json['originalCategory'] as String?,
  originalProjectId: json['originalProjectId'] as String?,
  projectId: json['projectId'] as String?,
  project: json['project'] == null
      ? null
      : ProjectInfo.fromJson(json['project'] as Map<String, dynamic>),
  subTasks:
      (json['subTasks'] as List<dynamic>?)
          ?.map((e) => SubTask.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$TaskImplToJson(_$TaskImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'isCompleted': instance.isCompleted,
      'priority': instance.priority,
      'category': instance.category,
      'dueDate': instance.dueDate,
      'isStarred': instance.isStarred,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'deletedAt': instance.deletedAt,
      'originalCategory': instance.originalCategory,
      'originalProjectId': instance.originalProjectId,
      'projectId': instance.projectId,
      'project': instance.project,
      'subTasks': instance.subTasks,
    };

_$TaskCreateImpl _$$TaskCreateImplFromJson(Map<String, dynamic> json) =>
    _$TaskCreateImpl(
      title: json['title'] as String,
      description: json['description'] as String?,
      priority: json['priority'] as String,
      category: json['category'] as String,
      dueDate: json['dueDate'] as String?,
      projectId: json['projectId'] as String?,
      subTasks: (json['subTasks'] as List<dynamic>?)
          ?.map((e) => SubTaskCreate.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$TaskCreateImplToJson(_$TaskCreateImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'priority': instance.priority,
      'category': instance.category,
      'dueDate': instance.dueDate,
      'projectId': instance.projectId,
      'subTasks': instance.subTasks,
    };

_$TaskUpdateImpl _$$TaskUpdateImplFromJson(Map<String, dynamic> json) =>
    _$TaskUpdateImpl(
      title: json['title'] as String?,
      description: json['description'] as String?,
      isCompleted: json['isCompleted'] as bool?,
      priority: json['priority'] as String?,
      category: json['category'] as String?,
      dueDate: json['dueDate'] as String?,
      isStarred: json['isStarred'] as bool?,
      deletedAt: json['deletedAt'] as String?,
      originalCategory: json['originalCategory'] as String?,
      originalProjectId: json['originalProjectId'] as String?,
      projectId: json['projectId'] as String?,
    );

Map<String, dynamic> _$$TaskUpdateImplToJson(_$TaskUpdateImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'isCompleted': instance.isCompleted,
      'priority': instance.priority,
      'category': instance.category,
      'dueDate': instance.dueDate,
      'isStarred': instance.isStarred,
      'deletedAt': instance.deletedAt,
      'originalCategory': instance.originalCategory,
      'originalProjectId': instance.originalProjectId,
      'projectId': instance.projectId,
    };

_$CategoryImpl _$$CategoryImplFromJson(Map<String, dynamic> json) =>
    _$CategoryImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      color: json['color'] as String,
      icon: json['icon'] as String?,
    );

Map<String, dynamic> _$$CategoryImplToJson(_$CategoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'color': instance.color,
      'icon': instance.icon,
    };

_$FocusSessionImpl _$$FocusSessionImplFromJson(Map<String, dynamic> json) =>
    _$FocusSessionImpl(
      id: json['id'] as String,
      taskId: json['taskId'] as String?,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String?,
      duration: (json['duration'] as num).toInt(),
      completed: json['completed'] as bool,
    );

Map<String, dynamic> _$$FocusSessionImplToJson(_$FocusSessionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'taskId': instance.taskId,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'duration': instance.duration,
      'completed': instance.completed,
    };

_$FocusStatsImpl _$$FocusStatsImplFromJson(Map<String, dynamic> json) =>
    _$FocusStatsImpl(
      totalSessions: (json['totalSessions'] as num).toInt(),
      totalMinutes: (json['totalMinutes'] as num).toInt(),
      completionRate: (json['completionRate'] as num).toInt(),
    );

Map<String, dynamic> _$$FocusStatsImplToJson(_$FocusStatsImpl instance) =>
    <String, dynamic>{
      'totalSessions': instance.totalSessions,
      'totalMinutes': instance.totalMinutes,
      'completionRate': instance.completionRate,
    };
