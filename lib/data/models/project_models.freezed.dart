// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Project _$ProjectFromJson(Map<String, dynamic> json) {
  return _Project.fromJson(json);
}

/// @nodoc
mixin _$Project {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get color => throw _privateConstructorUsedError;
  String? get icon => throw _privateConstructorUsedError;
  int get order => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  String? get updatedAt => throw _privateConstructorUsedError;
  int get taskCount => throw _privateConstructorUsedError;

  /// Serializes this Project to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Project
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProjectCopyWith<Project> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProjectCopyWith<$Res> {
  factory $ProjectCopyWith(Project value, $Res Function(Project) then) =
      _$ProjectCopyWithImpl<$Res, Project>;
  @useResult
  $Res call({
    String id,
    String name,
    String color,
    String? icon,
    int order,
    String createdAt,
    String? updatedAt,
    int taskCount,
  });
}

/// @nodoc
class _$ProjectCopyWithImpl<$Res, $Val extends Project>
    implements $ProjectCopyWith<$Res> {
  _$ProjectCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Project
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? color = null,
    Object? icon = freezed,
    Object? order = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? taskCount = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            color: null == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                      as String,
            icon: freezed == icon
                ? _value.icon
                : icon // ignore: cast_nullable_to_non_nullable
                      as String?,
            order: null == order
                ? _value.order
                : order // ignore: cast_nullable_to_non_nullable
                      as int,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            taskCount: null == taskCount
                ? _value.taskCount
                : taskCount // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProjectImplCopyWith<$Res> implements $ProjectCopyWith<$Res> {
  factory _$$ProjectImplCopyWith(
    _$ProjectImpl value,
    $Res Function(_$ProjectImpl) then,
  ) = __$$ProjectImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String color,
    String? icon,
    int order,
    String createdAt,
    String? updatedAt,
    int taskCount,
  });
}

/// @nodoc
class __$$ProjectImplCopyWithImpl<$Res>
    extends _$ProjectCopyWithImpl<$Res, _$ProjectImpl>
    implements _$$ProjectImplCopyWith<$Res> {
  __$$ProjectImplCopyWithImpl(
    _$ProjectImpl _value,
    $Res Function(_$ProjectImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Project
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? color = null,
    Object? icon = freezed,
    Object? order = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? taskCount = null,
  }) {
    return _then(
      _$ProjectImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        color: null == color
            ? _value.color
            : color // ignore: cast_nullable_to_non_nullable
                  as String,
        icon: freezed == icon
            ? _value.icon
            : icon // ignore: cast_nullable_to_non_nullable
                  as String?,
        order: null == order
            ? _value.order
            : order // ignore: cast_nullable_to_non_nullable
                  as int,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        taskCount: null == taskCount
            ? _value.taskCount
            : taskCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProjectImpl implements _Project {
  const _$ProjectImpl({
    required this.id,
    required this.name,
    required this.color,
    this.icon,
    required this.order,
    required this.createdAt,
    this.updatedAt,
    this.taskCount = 0,
  });

  factory _$ProjectImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProjectImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String color;
  @override
  final String? icon;
  @override
  final int order;
  @override
  final String createdAt;
  @override
  final String? updatedAt;
  @override
  @JsonKey()
  final int taskCount;

  @override
  String toString() {
    return 'Project(id: $id, name: $name, color: $color, icon: $icon, order: $order, createdAt: $createdAt, updatedAt: $updatedAt, taskCount: $taskCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProjectImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.taskCount, taskCount) ||
                other.taskCount == taskCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    color,
    icon,
    order,
    createdAt,
    updatedAt,
    taskCount,
  );

  /// Create a copy of Project
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProjectImplCopyWith<_$ProjectImpl> get copyWith =>
      __$$ProjectImplCopyWithImpl<_$ProjectImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProjectImplToJson(this);
  }
}

abstract class _Project implements Project {
  const factory _Project({
    required final String id,
    required final String name,
    required final String color,
    final String? icon,
    required final int order,
    required final String createdAt,
    final String? updatedAt,
    final int taskCount,
  }) = _$ProjectImpl;

  factory _Project.fromJson(Map<String, dynamic> json) = _$ProjectImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get color;
  @override
  String? get icon;
  @override
  int get order;
  @override
  String get createdAt;
  @override
  String? get updatedAt;
  @override
  int get taskCount;

  /// Create a copy of Project
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProjectImplCopyWith<_$ProjectImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProjectCreate _$ProjectCreateFromJson(Map<String, dynamic> json) {
  return _ProjectCreate.fromJson(json);
}

/// @nodoc
mixin _$ProjectCreate {
  String get name => throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;
  String? get icon => throw _privateConstructorUsedError;
  int? get order => throw _privateConstructorUsedError;

  /// Serializes this ProjectCreate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProjectCreate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProjectCreateCopyWith<ProjectCreate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProjectCreateCopyWith<$Res> {
  factory $ProjectCreateCopyWith(
    ProjectCreate value,
    $Res Function(ProjectCreate) then,
  ) = _$ProjectCreateCopyWithImpl<$Res, ProjectCreate>;
  @useResult
  $Res call({String name, String? color, String? icon, int? order});
}

/// @nodoc
class _$ProjectCreateCopyWithImpl<$Res, $Val extends ProjectCreate>
    implements $ProjectCreateCopyWith<$Res> {
  _$ProjectCreateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProjectCreate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? color = freezed,
    Object? icon = freezed,
    Object? order = freezed,
  }) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            color: freezed == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                      as String?,
            icon: freezed == icon
                ? _value.icon
                : icon // ignore: cast_nullable_to_non_nullable
                      as String?,
            order: freezed == order
                ? _value.order
                : order // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProjectCreateImplCopyWith<$Res>
    implements $ProjectCreateCopyWith<$Res> {
  factory _$$ProjectCreateImplCopyWith(
    _$ProjectCreateImpl value,
    $Res Function(_$ProjectCreateImpl) then,
  ) = __$$ProjectCreateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String? color, String? icon, int? order});
}

/// @nodoc
class __$$ProjectCreateImplCopyWithImpl<$Res>
    extends _$ProjectCreateCopyWithImpl<$Res, _$ProjectCreateImpl>
    implements _$$ProjectCreateImplCopyWith<$Res> {
  __$$ProjectCreateImplCopyWithImpl(
    _$ProjectCreateImpl _value,
    $Res Function(_$ProjectCreateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProjectCreate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? color = freezed,
    Object? icon = freezed,
    Object? order = freezed,
  }) {
    return _then(
      _$ProjectCreateImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        color: freezed == color
            ? _value.color
            : color // ignore: cast_nullable_to_non_nullable
                  as String?,
        icon: freezed == icon
            ? _value.icon
            : icon // ignore: cast_nullable_to_non_nullable
                  as String?,
        order: freezed == order
            ? _value.order
            : order // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProjectCreateImpl implements _ProjectCreate {
  const _$ProjectCreateImpl({
    required this.name,
    this.color,
    this.icon,
    this.order,
  });

  factory _$ProjectCreateImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProjectCreateImplFromJson(json);

  @override
  final String name;
  @override
  final String? color;
  @override
  final String? icon;
  @override
  final int? order;

  @override
  String toString() {
    return 'ProjectCreate(name: $name, color: $color, icon: $icon, order: $order)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProjectCreateImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.order, order) || other.order == order));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, color, icon, order);

  /// Create a copy of ProjectCreate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProjectCreateImplCopyWith<_$ProjectCreateImpl> get copyWith =>
      __$$ProjectCreateImplCopyWithImpl<_$ProjectCreateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProjectCreateImplToJson(this);
  }
}

abstract class _ProjectCreate implements ProjectCreate {
  const factory _ProjectCreate({
    required final String name,
    final String? color,
    final String? icon,
    final int? order,
  }) = _$ProjectCreateImpl;

  factory _ProjectCreate.fromJson(Map<String, dynamic> json) =
      _$ProjectCreateImpl.fromJson;

  @override
  String get name;
  @override
  String? get color;
  @override
  String? get icon;
  @override
  int? get order;

  /// Create a copy of ProjectCreate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProjectCreateImplCopyWith<_$ProjectCreateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProjectUpdate _$ProjectUpdateFromJson(Map<String, dynamic> json) {
  return _ProjectUpdate.fromJson(json);
}

/// @nodoc
mixin _$ProjectUpdate {
  String? get name => throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;
  String? get icon => throw _privateConstructorUsedError;
  int? get order => throw _privateConstructorUsedError;

  /// Serializes this ProjectUpdate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProjectUpdate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProjectUpdateCopyWith<ProjectUpdate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProjectUpdateCopyWith<$Res> {
  factory $ProjectUpdateCopyWith(
    ProjectUpdate value,
    $Res Function(ProjectUpdate) then,
  ) = _$ProjectUpdateCopyWithImpl<$Res, ProjectUpdate>;
  @useResult
  $Res call({String? name, String? color, String? icon, int? order});
}

/// @nodoc
class _$ProjectUpdateCopyWithImpl<$Res, $Val extends ProjectUpdate>
    implements $ProjectUpdateCopyWith<$Res> {
  _$ProjectUpdateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProjectUpdate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? color = freezed,
    Object? icon = freezed,
    Object? order = freezed,
  }) {
    return _then(
      _value.copyWith(
            name: freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String?,
            color: freezed == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                      as String?,
            icon: freezed == icon
                ? _value.icon
                : icon // ignore: cast_nullable_to_non_nullable
                      as String?,
            order: freezed == order
                ? _value.order
                : order // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProjectUpdateImplCopyWith<$Res>
    implements $ProjectUpdateCopyWith<$Res> {
  factory _$$ProjectUpdateImplCopyWith(
    _$ProjectUpdateImpl value,
    $Res Function(_$ProjectUpdateImpl) then,
  ) = __$$ProjectUpdateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? name, String? color, String? icon, int? order});
}

/// @nodoc
class __$$ProjectUpdateImplCopyWithImpl<$Res>
    extends _$ProjectUpdateCopyWithImpl<$Res, _$ProjectUpdateImpl>
    implements _$$ProjectUpdateImplCopyWith<$Res> {
  __$$ProjectUpdateImplCopyWithImpl(
    _$ProjectUpdateImpl _value,
    $Res Function(_$ProjectUpdateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProjectUpdate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? color = freezed,
    Object? icon = freezed,
    Object? order = freezed,
  }) {
    return _then(
      _$ProjectUpdateImpl(
        name: freezed == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
        color: freezed == color
            ? _value.color
            : color // ignore: cast_nullable_to_non_nullable
                  as String?,
        icon: freezed == icon
            ? _value.icon
            : icon // ignore: cast_nullable_to_non_nullable
                  as String?,
        order: freezed == order
            ? _value.order
            : order // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProjectUpdateImpl implements _ProjectUpdate {
  const _$ProjectUpdateImpl({this.name, this.color, this.icon, this.order});

  factory _$ProjectUpdateImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProjectUpdateImplFromJson(json);

  @override
  final String? name;
  @override
  final String? color;
  @override
  final String? icon;
  @override
  final int? order;

  @override
  String toString() {
    return 'ProjectUpdate(name: $name, color: $color, icon: $icon, order: $order)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProjectUpdateImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.order, order) || other.order == order));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, color, icon, order);

  /// Create a copy of ProjectUpdate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProjectUpdateImplCopyWith<_$ProjectUpdateImpl> get copyWith =>
      __$$ProjectUpdateImplCopyWithImpl<_$ProjectUpdateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProjectUpdateImplToJson(this);
  }
}

abstract class _ProjectUpdate implements ProjectUpdate {
  const factory _ProjectUpdate({
    final String? name,
    final String? color,
    final String? icon,
    final int? order,
  }) = _$ProjectUpdateImpl;

  factory _ProjectUpdate.fromJson(Map<String, dynamic> json) =
      _$ProjectUpdateImpl.fromJson;

  @override
  String? get name;
  @override
  String? get color;
  @override
  String? get icon;
  @override
  int? get order;

  /// Create a copy of ProjectUpdate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProjectUpdateImplCopyWith<_$ProjectUpdateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
