import 'package:freezed_annotation/freezed_annotation.dart';

part 'config_models.freezed.dart';
part 'config_models.g.dart';

@freezed
class CreateConfigDto with _$CreateConfigDto {
  const factory CreateConfigDto({
    required String appKey,
    required String configKey,
    required String configValue,
    required int version,
  }) = _CreateConfigDto;

  factory CreateConfigDto.fromJson(Map<String, dynamic> json) =>
      _$CreateConfigDtoFromJson(json);
}

@freezed
class UpdateConfigDto with _$UpdateConfigDto {
  const factory UpdateConfigDto({
    required String configValue,
    required int version,
  }) = _UpdateConfigDto;

  factory UpdateConfigDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateConfigDtoFromJson(json);
}

@freezed
class ConfigItem with _$ConfigItem {
  const factory ConfigItem({
    required String id,
    required String appKey,
    required String configKey,
    required dynamic configValue,
    required int version,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ConfigItem;

  factory ConfigItem.fromJson(Map<String, dynamic> json) =>
      _$ConfigItemFromJson(json);
}
