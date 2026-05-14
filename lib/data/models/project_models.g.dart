// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProjectImpl _$$ProjectImplFromJson(Map<String, dynamic> json) =>
    _$ProjectImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      color: json['color'] as String,
      icon: json['icon'] as String?,
      order: (json['order'] as num).toInt(),
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String?,
      taskCount: (json['taskCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$ProjectImplToJson(_$ProjectImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'color': instance.color,
      'icon': instance.icon,
      'order': instance.order,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'taskCount': instance.taskCount,
    };

_$ProjectCreateImpl _$$ProjectCreateImplFromJson(Map<String, dynamic> json) =>
    _$ProjectCreateImpl(
      name: json['name'] as String,
      color: json['color'] as String?,
      icon: json['icon'] as String?,
      order: (json['order'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$ProjectCreateImplToJson(_$ProjectCreateImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'color': instance.color,
      'icon': instance.icon,
      'order': instance.order,
    };

_$ProjectUpdateImpl _$$ProjectUpdateImplFromJson(Map<String, dynamic> json) =>
    _$ProjectUpdateImpl(
      name: json['name'] as String?,
      color: json['color'] as String?,
      icon: json['icon'] as String?,
      order: (json['order'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$ProjectUpdateImplToJson(_$ProjectUpdateImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'color': instance.color,
      'icon': instance.icon,
      'order': instance.order,
    };
