// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreateConfigDtoImpl _$$CreateConfigDtoImplFromJson(
  Map<String, dynamic> json,
) => _$CreateConfigDtoImpl(
  appKey: json['appKey'] as String,
  configKey: json['configKey'] as String,
  configValue: json['configValue'] as String,
  version: (json['version'] as num).toInt(),
);

Map<String, dynamic> _$$CreateConfigDtoImplToJson(
  _$CreateConfigDtoImpl instance,
) => <String, dynamic>{
  'appKey': instance.appKey,
  'configKey': instance.configKey,
  'configValue': instance.configValue,
  'version': instance.version,
};

_$UpdateConfigDtoImpl _$$UpdateConfigDtoImplFromJson(
  Map<String, dynamic> json,
) => _$UpdateConfigDtoImpl(
  configValue: json['configValue'] as String,
  version: (json['version'] as num).toInt(),
);

Map<String, dynamic> _$$UpdateConfigDtoImplToJson(
  _$UpdateConfigDtoImpl instance,
) => <String, dynamic>{
  'configValue': instance.configValue,
  'version': instance.version,
};

_$ConfigItemImpl _$$ConfigItemImplFromJson(Map<String, dynamic> json) =>
    _$ConfigItemImpl(
      id: json['id'] as String,
      appKey: json['appKey'] as String,
      configKey: json['configKey'] as String,
      configValue: json['configValue'],
      version: (json['version'] as num).toInt(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ConfigItemImplToJson(_$ConfigItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'appKey': instance.appKey,
      'configKey': instance.configKey,
      'configValue': instance.configValue,
      'version': instance.version,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
