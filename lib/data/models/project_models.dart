import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_models.freezed.dart';
part 'project_models.g.dart';

@freezed
class Project with _$Project {
  const factory Project({
    required String id,
    required String name,
    required String color,
    String? icon,
    required int order,
    required String createdAt,
    String? updatedAt,
    @Default(0) int taskCount,
  }) = _Project;

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);
}

@freezed
class ProjectCreate with _$ProjectCreate {
  const factory ProjectCreate({
    required String name,
    String? color,
    String? icon,
    int? order,
  }) = _ProjectCreate;

  factory ProjectCreate.fromJson(Map<String, dynamic> json) =>
      _$ProjectCreateFromJson(json);
}

@freezed
class ProjectUpdate with _$ProjectUpdate {
  const factory ProjectUpdate({
    String? name,
    String? color,
    String? icon,
    int? order,
  }) = _ProjectUpdate;

  factory ProjectUpdate.fromJson(Map<String, dynamic> json) =>
      _$ProjectUpdateFromJson(json);
}
