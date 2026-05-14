// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SubTask _$SubTaskFromJson(Map<String, dynamic> json) {
  return _SubTask.fromJson(json);
}

/// @nodoc
mixin _$SubTask {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  bool get completed => throw _privateConstructorUsedError;
  int? get order => throw _privateConstructorUsedError;
  String? get createdAt => throw _privateConstructorUsedError;
  String? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this SubTask to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SubTask
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SubTaskCopyWith<SubTask> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubTaskCopyWith<$Res> {
  factory $SubTaskCopyWith(SubTask value, $Res Function(SubTask) then) =
      _$SubTaskCopyWithImpl<$Res, SubTask>;
  @useResult
  $Res call({
    String id,
    String title,
    bool completed,
    int? order,
    String? createdAt,
    String? updatedAt,
  });
}

/// @nodoc
class _$SubTaskCopyWithImpl<$Res, $Val extends SubTask>
    implements $SubTaskCopyWith<$Res> {
  _$SubTaskCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SubTask
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? completed = null,
    Object? order = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            completed: null == completed
                ? _value.completed
                : completed // ignore: cast_nullable_to_non_nullable
                      as bool,
            order: freezed == order
                ? _value.order
                : order // ignore: cast_nullable_to_non_nullable
                      as int?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SubTaskImplCopyWith<$Res> implements $SubTaskCopyWith<$Res> {
  factory _$$SubTaskImplCopyWith(
    _$SubTaskImpl value,
    $Res Function(_$SubTaskImpl) then,
  ) = __$$SubTaskImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    bool completed,
    int? order,
    String? createdAt,
    String? updatedAt,
  });
}

/// @nodoc
class __$$SubTaskImplCopyWithImpl<$Res>
    extends _$SubTaskCopyWithImpl<$Res, _$SubTaskImpl>
    implements _$$SubTaskImplCopyWith<$Res> {
  __$$SubTaskImplCopyWithImpl(
    _$SubTaskImpl _value,
    $Res Function(_$SubTaskImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SubTask
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? completed = null,
    Object? order = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$SubTaskImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        completed: null == completed
            ? _value.completed
            : completed // ignore: cast_nullable_to_non_nullable
                  as bool,
        order: freezed == order
            ? _value.order
            : order // ignore: cast_nullable_to_non_nullable
                  as int?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SubTaskImpl implements _SubTask {
  const _$SubTaskImpl({
    required this.id,
    required this.title,
    required this.completed,
    this.order,
    this.createdAt,
    this.updatedAt,
  });

  factory _$SubTaskImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubTaskImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final bool completed;
  @override
  final int? order;
  @override
  final String? createdAt;
  @override
  final String? updatedAt;

  @override
  String toString() {
    return 'SubTask(id: $id, title: $title, completed: $completed, order: $order, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubTaskImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.completed, completed) ||
                other.completed == completed) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    completed,
    order,
    createdAt,
    updatedAt,
  );

  /// Create a copy of SubTask
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubTaskImplCopyWith<_$SubTaskImpl> get copyWith =>
      __$$SubTaskImplCopyWithImpl<_$SubTaskImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SubTaskImplToJson(this);
  }
}

abstract class _SubTask implements SubTask {
  const factory _SubTask({
    required final String id,
    required final String title,
    required final bool completed,
    final int? order,
    final String? createdAt,
    final String? updatedAt,
  }) = _$SubTaskImpl;

  factory _SubTask.fromJson(Map<String, dynamic> json) = _$SubTaskImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  bool get completed;
  @override
  int? get order;
  @override
  String? get createdAt;
  @override
  String? get updatedAt;

  /// Create a copy of SubTask
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubTaskImplCopyWith<_$SubTaskImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SubTaskCreate _$SubTaskCreateFromJson(Map<String, dynamic> json) {
  return _SubTaskCreate.fromJson(json);
}

/// @nodoc
mixin _$SubTaskCreate {
  String get title => throw _privateConstructorUsedError;
  int? get order => throw _privateConstructorUsedError;

  /// Serializes this SubTaskCreate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SubTaskCreate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SubTaskCreateCopyWith<SubTaskCreate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubTaskCreateCopyWith<$Res> {
  factory $SubTaskCreateCopyWith(
    SubTaskCreate value,
    $Res Function(SubTaskCreate) then,
  ) = _$SubTaskCreateCopyWithImpl<$Res, SubTaskCreate>;
  @useResult
  $Res call({String title, int? order});
}

/// @nodoc
class _$SubTaskCreateCopyWithImpl<$Res, $Val extends SubTaskCreate>
    implements $SubTaskCreateCopyWith<$Res> {
  _$SubTaskCreateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SubTaskCreate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? title = null, Object? order = freezed}) {
    return _then(
      _value.copyWith(
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
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
abstract class _$$SubTaskCreateImplCopyWith<$Res>
    implements $SubTaskCreateCopyWith<$Res> {
  factory _$$SubTaskCreateImplCopyWith(
    _$SubTaskCreateImpl value,
    $Res Function(_$SubTaskCreateImpl) then,
  ) = __$$SubTaskCreateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String title, int? order});
}

/// @nodoc
class __$$SubTaskCreateImplCopyWithImpl<$Res>
    extends _$SubTaskCreateCopyWithImpl<$Res, _$SubTaskCreateImpl>
    implements _$$SubTaskCreateImplCopyWith<$Res> {
  __$$SubTaskCreateImplCopyWithImpl(
    _$SubTaskCreateImpl _value,
    $Res Function(_$SubTaskCreateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SubTaskCreate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? title = null, Object? order = freezed}) {
    return _then(
      _$SubTaskCreateImpl(
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
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
class _$SubTaskCreateImpl implements _SubTaskCreate {
  const _$SubTaskCreateImpl({required this.title, this.order});

  factory _$SubTaskCreateImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubTaskCreateImplFromJson(json);

  @override
  final String title;
  @override
  final int? order;

  @override
  String toString() {
    return 'SubTaskCreate(title: $title, order: $order)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubTaskCreateImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.order, order) || other.order == order));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, title, order);

  /// Create a copy of SubTaskCreate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubTaskCreateImplCopyWith<_$SubTaskCreateImpl> get copyWith =>
      __$$SubTaskCreateImplCopyWithImpl<_$SubTaskCreateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SubTaskCreateImplToJson(this);
  }
}

abstract class _SubTaskCreate implements SubTaskCreate {
  const factory _SubTaskCreate({
    required final String title,
    final int? order,
  }) = _$SubTaskCreateImpl;

  factory _SubTaskCreate.fromJson(Map<String, dynamic> json) =
      _$SubTaskCreateImpl.fromJson;

  @override
  String get title;
  @override
  int? get order;

  /// Create a copy of SubTaskCreate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubTaskCreateImplCopyWith<_$SubTaskCreateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SubTaskUpdate _$SubTaskUpdateFromJson(Map<String, dynamic> json) {
  return _SubTaskUpdate.fromJson(json);
}

/// @nodoc
mixin _$SubTaskUpdate {
  String? get title => throw _privateConstructorUsedError;
  bool? get completed => throw _privateConstructorUsedError;
  int? get order => throw _privateConstructorUsedError;

  /// Serializes this SubTaskUpdate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SubTaskUpdate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SubTaskUpdateCopyWith<SubTaskUpdate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubTaskUpdateCopyWith<$Res> {
  factory $SubTaskUpdateCopyWith(
    SubTaskUpdate value,
    $Res Function(SubTaskUpdate) then,
  ) = _$SubTaskUpdateCopyWithImpl<$Res, SubTaskUpdate>;
  @useResult
  $Res call({String? title, bool? completed, int? order});
}

/// @nodoc
class _$SubTaskUpdateCopyWithImpl<$Res, $Val extends SubTaskUpdate>
    implements $SubTaskUpdateCopyWith<$Res> {
  _$SubTaskUpdateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SubTaskUpdate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = freezed,
    Object? completed = freezed,
    Object? order = freezed,
  }) {
    return _then(
      _value.copyWith(
            title: freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String?,
            completed: freezed == completed
                ? _value.completed
                : completed // ignore: cast_nullable_to_non_nullable
                      as bool?,
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
abstract class _$$SubTaskUpdateImplCopyWith<$Res>
    implements $SubTaskUpdateCopyWith<$Res> {
  factory _$$SubTaskUpdateImplCopyWith(
    _$SubTaskUpdateImpl value,
    $Res Function(_$SubTaskUpdateImpl) then,
  ) = __$$SubTaskUpdateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? title, bool? completed, int? order});
}

/// @nodoc
class __$$SubTaskUpdateImplCopyWithImpl<$Res>
    extends _$SubTaskUpdateCopyWithImpl<$Res, _$SubTaskUpdateImpl>
    implements _$$SubTaskUpdateImplCopyWith<$Res> {
  __$$SubTaskUpdateImplCopyWithImpl(
    _$SubTaskUpdateImpl _value,
    $Res Function(_$SubTaskUpdateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SubTaskUpdate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = freezed,
    Object? completed = freezed,
    Object? order = freezed,
  }) {
    return _then(
      _$SubTaskUpdateImpl(
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
        completed: freezed == completed
            ? _value.completed
            : completed // ignore: cast_nullable_to_non_nullable
                  as bool?,
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
class _$SubTaskUpdateImpl implements _SubTaskUpdate {
  const _$SubTaskUpdateImpl({this.title, this.completed, this.order});

  factory _$SubTaskUpdateImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubTaskUpdateImplFromJson(json);

  @override
  final String? title;
  @override
  final bool? completed;
  @override
  final int? order;

  @override
  String toString() {
    return 'SubTaskUpdate(title: $title, completed: $completed, order: $order)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubTaskUpdateImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.completed, completed) ||
                other.completed == completed) &&
            (identical(other.order, order) || other.order == order));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, title, completed, order);

  /// Create a copy of SubTaskUpdate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubTaskUpdateImplCopyWith<_$SubTaskUpdateImpl> get copyWith =>
      __$$SubTaskUpdateImplCopyWithImpl<_$SubTaskUpdateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SubTaskUpdateImplToJson(this);
  }
}

abstract class _SubTaskUpdate implements SubTaskUpdate {
  const factory _SubTaskUpdate({
    final String? title,
    final bool? completed,
    final int? order,
  }) = _$SubTaskUpdateImpl;

  factory _SubTaskUpdate.fromJson(Map<String, dynamic> json) =
      _$SubTaskUpdateImpl.fromJson;

  @override
  String? get title;
  @override
  bool? get completed;
  @override
  int? get order;

  /// Create a copy of SubTaskUpdate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubTaskUpdateImplCopyWith<_$SubTaskUpdateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProjectInfo _$ProjectInfoFromJson(Map<String, dynamic> json) {
  return _ProjectInfo.fromJson(json);
}

/// @nodoc
mixin _$ProjectInfo {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get color => throw _privateConstructorUsedError;
  String? get icon => throw _privateConstructorUsedError;

  /// Serializes this ProjectInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProjectInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProjectInfoCopyWith<ProjectInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProjectInfoCopyWith<$Res> {
  factory $ProjectInfoCopyWith(
    ProjectInfo value,
    $Res Function(ProjectInfo) then,
  ) = _$ProjectInfoCopyWithImpl<$Res, ProjectInfo>;
  @useResult
  $Res call({String id, String name, String color, String? icon});
}

/// @nodoc
class _$ProjectInfoCopyWithImpl<$Res, $Val extends ProjectInfo>
    implements $ProjectInfoCopyWith<$Res> {
  _$ProjectInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProjectInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? color = null,
    Object? icon = freezed,
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProjectInfoImplCopyWith<$Res>
    implements $ProjectInfoCopyWith<$Res> {
  factory _$$ProjectInfoImplCopyWith(
    _$ProjectInfoImpl value,
    $Res Function(_$ProjectInfoImpl) then,
  ) = __$$ProjectInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, String color, String? icon});
}

/// @nodoc
class __$$ProjectInfoImplCopyWithImpl<$Res>
    extends _$ProjectInfoCopyWithImpl<$Res, _$ProjectInfoImpl>
    implements _$$ProjectInfoImplCopyWith<$Res> {
  __$$ProjectInfoImplCopyWithImpl(
    _$ProjectInfoImpl _value,
    $Res Function(_$ProjectInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProjectInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? color = null,
    Object? icon = freezed,
  }) {
    return _then(
      _$ProjectInfoImpl(
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
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProjectInfoImpl implements _ProjectInfo {
  const _$ProjectInfoImpl({
    required this.id,
    required this.name,
    required this.color,
    this.icon,
  });

  factory _$ProjectInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProjectInfoImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String color;
  @override
  final String? icon;

  @override
  String toString() {
    return 'ProjectInfo(id: $id, name: $name, color: $color, icon: $icon)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProjectInfoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.icon, icon) || other.icon == icon));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, color, icon);

  /// Create a copy of ProjectInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProjectInfoImplCopyWith<_$ProjectInfoImpl> get copyWith =>
      __$$ProjectInfoImplCopyWithImpl<_$ProjectInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProjectInfoImplToJson(this);
  }
}

abstract class _ProjectInfo implements ProjectInfo {
  const factory _ProjectInfo({
    required final String id,
    required final String name,
    required final String color,
    final String? icon,
  }) = _$ProjectInfoImpl;

  factory _ProjectInfo.fromJson(Map<String, dynamic> json) =
      _$ProjectInfoImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get color;
  @override
  String? get icon;

  /// Create a copy of ProjectInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProjectInfoImplCopyWith<_$ProjectInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Task _$TaskFromJson(Map<String, dynamic> json) {
  return _Task.fromJson(json);
}

/// @nodoc
mixin _$Task {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;
  String get priority => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String? get dueDate => throw _privateConstructorUsedError;
  bool get isStarred => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  String? get updatedAt => throw _privateConstructorUsedError;
  String? get deletedAt => throw _privateConstructorUsedError; // 回收站：删除时间
  String? get originalCategory =>
      throw _privateConstructorUsedError; // 删除前的分类，恢复时使用
  String? get originalProjectId =>
      throw _privateConstructorUsedError; // 删除前的项目，恢复时使用
  String? get projectId => throw _privateConstructorUsedError;
  ProjectInfo? get project => throw _privateConstructorUsedError;
  List<SubTask> get subTasks => throw _privateConstructorUsedError;

  /// Serializes this Task to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskCopyWith<Task> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskCopyWith<$Res> {
  factory $TaskCopyWith(Task value, $Res Function(Task) then) =
      _$TaskCopyWithImpl<$Res, Task>;
  @useResult
  $Res call({
    String id,
    String title,
    String? description,
    bool isCompleted,
    String priority,
    String category,
    String? dueDate,
    bool isStarred,
    String createdAt,
    String? updatedAt,
    String? deletedAt,
    String? originalCategory,
    String? originalProjectId,
    String? projectId,
    ProjectInfo? project,
    List<SubTask> subTasks,
  });

  $ProjectInfoCopyWith<$Res>? get project;
}

/// @nodoc
class _$TaskCopyWithImpl<$Res, $Val extends Task>
    implements $TaskCopyWith<$Res> {
  _$TaskCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? isCompleted = null,
    Object? priority = null,
    Object? category = null,
    Object? dueDate = freezed,
    Object? isStarred = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
    Object? originalCategory = freezed,
    Object? originalProjectId = freezed,
    Object? projectId = freezed,
    Object? project = freezed,
    Object? subTasks = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            isCompleted: null == isCompleted
                ? _value.isCompleted
                : isCompleted // ignore: cast_nullable_to_non_nullable
                      as bool,
            priority: null == priority
                ? _value.priority
                : priority // ignore: cast_nullable_to_non_nullable
                      as String,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            dueDate: freezed == dueDate
                ? _value.dueDate
                : dueDate // ignore: cast_nullable_to_non_nullable
                      as String?,
            isStarred: null == isStarred
                ? _value.isStarred
                : isStarred // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            deletedAt: freezed == deletedAt
                ? _value.deletedAt
                : deletedAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            originalCategory: freezed == originalCategory
                ? _value.originalCategory
                : originalCategory // ignore: cast_nullable_to_non_nullable
                      as String?,
            originalProjectId: freezed == originalProjectId
                ? _value.originalProjectId
                : originalProjectId // ignore: cast_nullable_to_non_nullable
                      as String?,
            projectId: freezed == projectId
                ? _value.projectId
                : projectId // ignore: cast_nullable_to_non_nullable
                      as String?,
            project: freezed == project
                ? _value.project
                : project // ignore: cast_nullable_to_non_nullable
                      as ProjectInfo?,
            subTasks: null == subTasks
                ? _value.subTasks
                : subTasks // ignore: cast_nullable_to_non_nullable
                      as List<SubTask>,
          )
          as $Val,
    );
  }

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProjectInfoCopyWith<$Res>? get project {
    if (_value.project == null) {
      return null;
    }

    return $ProjectInfoCopyWith<$Res>(_value.project!, (value) {
      return _then(_value.copyWith(project: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TaskImplCopyWith<$Res> implements $TaskCopyWith<$Res> {
  factory _$$TaskImplCopyWith(
    _$TaskImpl value,
    $Res Function(_$TaskImpl) then,
  ) = __$$TaskImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String? description,
    bool isCompleted,
    String priority,
    String category,
    String? dueDate,
    bool isStarred,
    String createdAt,
    String? updatedAt,
    String? deletedAt,
    String? originalCategory,
    String? originalProjectId,
    String? projectId,
    ProjectInfo? project,
    List<SubTask> subTasks,
  });

  @override
  $ProjectInfoCopyWith<$Res>? get project;
}

/// @nodoc
class __$$TaskImplCopyWithImpl<$Res>
    extends _$TaskCopyWithImpl<$Res, _$TaskImpl>
    implements _$$TaskImplCopyWith<$Res> {
  __$$TaskImplCopyWithImpl(_$TaskImpl _value, $Res Function(_$TaskImpl) _then)
    : super(_value, _then);

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? isCompleted = null,
    Object? priority = null,
    Object? category = null,
    Object? dueDate = freezed,
    Object? isStarred = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
    Object? originalCategory = freezed,
    Object? originalProjectId = freezed,
    Object? projectId = freezed,
    Object? project = freezed,
    Object? subTasks = null,
  }) {
    return _then(
      _$TaskImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        isCompleted: null == isCompleted
            ? _value.isCompleted
            : isCompleted // ignore: cast_nullable_to_non_nullable
                  as bool,
        priority: null == priority
            ? _value.priority
            : priority // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        dueDate: freezed == dueDate
            ? _value.dueDate
            : dueDate // ignore: cast_nullable_to_non_nullable
                  as String?,
        isStarred: null == isStarred
            ? _value.isStarred
            : isStarred // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        deletedAt: freezed == deletedAt
            ? _value.deletedAt
            : deletedAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        originalCategory: freezed == originalCategory
            ? _value.originalCategory
            : originalCategory // ignore: cast_nullable_to_non_nullable
                  as String?,
        originalProjectId: freezed == originalProjectId
            ? _value.originalProjectId
            : originalProjectId // ignore: cast_nullable_to_non_nullable
                  as String?,
        projectId: freezed == projectId
            ? _value.projectId
            : projectId // ignore: cast_nullable_to_non_nullable
                  as String?,
        project: freezed == project
            ? _value.project
            : project // ignore: cast_nullable_to_non_nullable
                  as ProjectInfo?,
        subTasks: null == subTasks
            ? _value._subTasks
            : subTasks // ignore: cast_nullable_to_non_nullable
                  as List<SubTask>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskImpl implements _Task {
  const _$TaskImpl({
    required this.id,
    required this.title,
    this.description,
    required this.isCompleted,
    required this.priority,
    required this.category,
    this.dueDate,
    required this.isStarred,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.originalCategory,
    this.originalProjectId,
    this.projectId,
    this.project,
    final List<SubTask> subTasks = const [],
  }) : _subTasks = subTasks;

  factory _$TaskImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String? description;
  @override
  final bool isCompleted;
  @override
  final String priority;
  @override
  final String category;
  @override
  final String? dueDate;
  @override
  final bool isStarred;
  @override
  final String createdAt;
  @override
  final String? updatedAt;
  @override
  final String? deletedAt;
  // 回收站：删除时间
  @override
  final String? originalCategory;
  // 删除前的分类，恢复时使用
  @override
  final String? originalProjectId;
  // 删除前的项目，恢复时使用
  @override
  final String? projectId;
  @override
  final ProjectInfo? project;
  final List<SubTask> _subTasks;
  @override
  @JsonKey()
  List<SubTask> get subTasks {
    if (_subTasks is EqualUnmodifiableListView) return _subTasks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_subTasks);
  }

  @override
  String toString() {
    return 'Task(id: $id, title: $title, description: $description, isCompleted: $isCompleted, priority: $priority, category: $category, dueDate: $dueDate, isStarred: $isStarred, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, originalCategory: $originalCategory, originalProjectId: $originalProjectId, projectId: $projectId, project: $project, subTasks: $subTasks)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.isStarred, isStarred) ||
                other.isStarred == isStarred) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt) &&
            (identical(other.originalCategory, originalCategory) ||
                other.originalCategory == originalCategory) &&
            (identical(other.originalProjectId, originalProjectId) ||
                other.originalProjectId == originalProjectId) &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
            (identical(other.project, project) || other.project == project) &&
            const DeepCollectionEquality().equals(other._subTasks, _subTasks));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    description,
    isCompleted,
    priority,
    category,
    dueDate,
    isStarred,
    createdAt,
    updatedAt,
    deletedAt,
    originalCategory,
    originalProjectId,
    projectId,
    project,
    const DeepCollectionEquality().hash(_subTasks),
  );

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskImplCopyWith<_$TaskImpl> get copyWith =>
      __$$TaskImplCopyWithImpl<_$TaskImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskImplToJson(this);
  }
}

abstract class _Task implements Task {
  const factory _Task({
    required final String id,
    required final String title,
    final String? description,
    required final bool isCompleted,
    required final String priority,
    required final String category,
    final String? dueDate,
    required final bool isStarred,
    required final String createdAt,
    final String? updatedAt,
    final String? deletedAt,
    final String? originalCategory,
    final String? originalProjectId,
    final String? projectId,
    final ProjectInfo? project,
    final List<SubTask> subTasks,
  }) = _$TaskImpl;

  factory _Task.fromJson(Map<String, dynamic> json) = _$TaskImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String? get description;
  @override
  bool get isCompleted;
  @override
  String get priority;
  @override
  String get category;
  @override
  String? get dueDate;
  @override
  bool get isStarred;
  @override
  String get createdAt;
  @override
  String? get updatedAt;
  @override
  String? get deletedAt; // 回收站：删除时间
  @override
  String? get originalCategory; // 删除前的分类，恢复时使用
  @override
  String? get originalProjectId; // 删除前的项目，恢复时使用
  @override
  String? get projectId;
  @override
  ProjectInfo? get project;
  @override
  List<SubTask> get subTasks;

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskImplCopyWith<_$TaskImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TaskCreate _$TaskCreateFromJson(Map<String, dynamic> json) {
  return _TaskCreate.fromJson(json);
}

/// @nodoc
mixin _$TaskCreate {
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String get priority => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String? get dueDate => throw _privateConstructorUsedError;
  String? get projectId => throw _privateConstructorUsedError;
  List<SubTaskCreate>? get subTasks => throw _privateConstructorUsedError;

  /// Serializes this TaskCreate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TaskCreate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskCreateCopyWith<TaskCreate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskCreateCopyWith<$Res> {
  factory $TaskCreateCopyWith(
    TaskCreate value,
    $Res Function(TaskCreate) then,
  ) = _$TaskCreateCopyWithImpl<$Res, TaskCreate>;
  @useResult
  $Res call({
    String title,
    String? description,
    String priority,
    String category,
    String? dueDate,
    String? projectId,
    List<SubTaskCreate>? subTasks,
  });
}

/// @nodoc
class _$TaskCreateCopyWithImpl<$Res, $Val extends TaskCreate>
    implements $TaskCreateCopyWith<$Res> {
  _$TaskCreateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaskCreate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = freezed,
    Object? priority = null,
    Object? category = null,
    Object? dueDate = freezed,
    Object? projectId = freezed,
    Object? subTasks = freezed,
  }) {
    return _then(
      _value.copyWith(
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            priority: null == priority
                ? _value.priority
                : priority // ignore: cast_nullable_to_non_nullable
                      as String,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            dueDate: freezed == dueDate
                ? _value.dueDate
                : dueDate // ignore: cast_nullable_to_non_nullable
                      as String?,
            projectId: freezed == projectId
                ? _value.projectId
                : projectId // ignore: cast_nullable_to_non_nullable
                      as String?,
            subTasks: freezed == subTasks
                ? _value.subTasks
                : subTasks // ignore: cast_nullable_to_non_nullable
                      as List<SubTaskCreate>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TaskCreateImplCopyWith<$Res>
    implements $TaskCreateCopyWith<$Res> {
  factory _$$TaskCreateImplCopyWith(
    _$TaskCreateImpl value,
    $Res Function(_$TaskCreateImpl) then,
  ) = __$$TaskCreateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String title,
    String? description,
    String priority,
    String category,
    String? dueDate,
    String? projectId,
    List<SubTaskCreate>? subTasks,
  });
}

/// @nodoc
class __$$TaskCreateImplCopyWithImpl<$Res>
    extends _$TaskCreateCopyWithImpl<$Res, _$TaskCreateImpl>
    implements _$$TaskCreateImplCopyWith<$Res> {
  __$$TaskCreateImplCopyWithImpl(
    _$TaskCreateImpl _value,
    $Res Function(_$TaskCreateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TaskCreate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = freezed,
    Object? priority = null,
    Object? category = null,
    Object? dueDate = freezed,
    Object? projectId = freezed,
    Object? subTasks = freezed,
  }) {
    return _then(
      _$TaskCreateImpl(
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        priority: null == priority
            ? _value.priority
            : priority // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        dueDate: freezed == dueDate
            ? _value.dueDate
            : dueDate // ignore: cast_nullable_to_non_nullable
                  as String?,
        projectId: freezed == projectId
            ? _value.projectId
            : projectId // ignore: cast_nullable_to_non_nullable
                  as String?,
        subTasks: freezed == subTasks
            ? _value._subTasks
            : subTasks // ignore: cast_nullable_to_non_nullable
                  as List<SubTaskCreate>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskCreateImpl implements _TaskCreate {
  const _$TaskCreateImpl({
    required this.title,
    this.description,
    required this.priority,
    required this.category,
    this.dueDate,
    this.projectId,
    final List<SubTaskCreate>? subTasks,
  }) : _subTasks = subTasks;

  factory _$TaskCreateImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskCreateImplFromJson(json);

  @override
  final String title;
  @override
  final String? description;
  @override
  final String priority;
  @override
  final String category;
  @override
  final String? dueDate;
  @override
  final String? projectId;
  final List<SubTaskCreate>? _subTasks;
  @override
  List<SubTaskCreate>? get subTasks {
    final value = _subTasks;
    if (value == null) return null;
    if (_subTasks is EqualUnmodifiableListView) return _subTasks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'TaskCreate(title: $title, description: $description, priority: $priority, category: $category, dueDate: $dueDate, projectId: $projectId, subTasks: $subTasks)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskCreateImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
            const DeepCollectionEquality().equals(other._subTasks, _subTasks));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    title,
    description,
    priority,
    category,
    dueDate,
    projectId,
    const DeepCollectionEquality().hash(_subTasks),
  );

  /// Create a copy of TaskCreate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskCreateImplCopyWith<_$TaskCreateImpl> get copyWith =>
      __$$TaskCreateImplCopyWithImpl<_$TaskCreateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskCreateImplToJson(this);
  }
}

abstract class _TaskCreate implements TaskCreate {
  const factory _TaskCreate({
    required final String title,
    final String? description,
    required final String priority,
    required final String category,
    final String? dueDate,
    final String? projectId,
    final List<SubTaskCreate>? subTasks,
  }) = _$TaskCreateImpl;

  factory _TaskCreate.fromJson(Map<String, dynamic> json) =
      _$TaskCreateImpl.fromJson;

  @override
  String get title;
  @override
  String? get description;
  @override
  String get priority;
  @override
  String get category;
  @override
  String? get dueDate;
  @override
  String? get projectId;
  @override
  List<SubTaskCreate>? get subTasks;

  /// Create a copy of TaskCreate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskCreateImplCopyWith<_$TaskCreateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TaskUpdate _$TaskUpdateFromJson(Map<String, dynamic> json) {
  return _TaskUpdate.fromJson(json);
}

/// @nodoc
mixin _$TaskUpdate {
  String? get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  bool? get isCompleted => throw _privateConstructorUsedError;
  String? get priority => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  String? get dueDate => throw _privateConstructorUsedError;
  bool? get isStarred => throw _privateConstructorUsedError;
  String? get deletedAt => throw _privateConstructorUsedError; // 用于软删除/恢复
  String? get originalCategory =>
      throw _privateConstructorUsedError; // 删除时保存，恢复时使用
  String? get originalProjectId =>
      throw _privateConstructorUsedError; // 删除时保存，恢复时使用
  String? get projectId => throw _privateConstructorUsedError;

  /// Serializes this TaskUpdate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TaskUpdate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskUpdateCopyWith<TaskUpdate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskUpdateCopyWith<$Res> {
  factory $TaskUpdateCopyWith(
    TaskUpdate value,
    $Res Function(TaskUpdate) then,
  ) = _$TaskUpdateCopyWithImpl<$Res, TaskUpdate>;
  @useResult
  $Res call({
    String? title,
    String? description,
    bool? isCompleted,
    String? priority,
    String? category,
    String? dueDate,
    bool? isStarred,
    String? deletedAt,
    String? originalCategory,
    String? originalProjectId,
    String? projectId,
  });
}

/// @nodoc
class _$TaskUpdateCopyWithImpl<$Res, $Val extends TaskUpdate>
    implements $TaskUpdateCopyWith<$Res> {
  _$TaskUpdateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaskUpdate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = freezed,
    Object? description = freezed,
    Object? isCompleted = freezed,
    Object? priority = freezed,
    Object? category = freezed,
    Object? dueDate = freezed,
    Object? isStarred = freezed,
    Object? deletedAt = freezed,
    Object? originalCategory = freezed,
    Object? originalProjectId = freezed,
    Object? projectId = freezed,
  }) {
    return _then(
      _value.copyWith(
            title: freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            isCompleted: freezed == isCompleted
                ? _value.isCompleted
                : isCompleted // ignore: cast_nullable_to_non_nullable
                      as bool?,
            priority: freezed == priority
                ? _value.priority
                : priority // ignore: cast_nullable_to_non_nullable
                      as String?,
            category: freezed == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String?,
            dueDate: freezed == dueDate
                ? _value.dueDate
                : dueDate // ignore: cast_nullable_to_non_nullable
                      as String?,
            isStarred: freezed == isStarred
                ? _value.isStarred
                : isStarred // ignore: cast_nullable_to_non_nullable
                      as bool?,
            deletedAt: freezed == deletedAt
                ? _value.deletedAt
                : deletedAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            originalCategory: freezed == originalCategory
                ? _value.originalCategory
                : originalCategory // ignore: cast_nullable_to_non_nullable
                      as String?,
            originalProjectId: freezed == originalProjectId
                ? _value.originalProjectId
                : originalProjectId // ignore: cast_nullable_to_non_nullable
                      as String?,
            projectId: freezed == projectId
                ? _value.projectId
                : projectId // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TaskUpdateImplCopyWith<$Res>
    implements $TaskUpdateCopyWith<$Res> {
  factory _$$TaskUpdateImplCopyWith(
    _$TaskUpdateImpl value,
    $Res Function(_$TaskUpdateImpl) then,
  ) = __$$TaskUpdateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? title,
    String? description,
    bool? isCompleted,
    String? priority,
    String? category,
    String? dueDate,
    bool? isStarred,
    String? deletedAt,
    String? originalCategory,
    String? originalProjectId,
    String? projectId,
  });
}

/// @nodoc
class __$$TaskUpdateImplCopyWithImpl<$Res>
    extends _$TaskUpdateCopyWithImpl<$Res, _$TaskUpdateImpl>
    implements _$$TaskUpdateImplCopyWith<$Res> {
  __$$TaskUpdateImplCopyWithImpl(
    _$TaskUpdateImpl _value,
    $Res Function(_$TaskUpdateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TaskUpdate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = freezed,
    Object? description = freezed,
    Object? isCompleted = freezed,
    Object? priority = freezed,
    Object? category = freezed,
    Object? dueDate = freezed,
    Object? isStarred = freezed,
    Object? deletedAt = freezed,
    Object? originalCategory = freezed,
    Object? originalProjectId = freezed,
    Object? projectId = freezed,
  }) {
    return _then(
      _$TaskUpdateImpl(
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        isCompleted: freezed == isCompleted
            ? _value.isCompleted
            : isCompleted // ignore: cast_nullable_to_non_nullable
                  as bool?,
        priority: freezed == priority
            ? _value.priority
            : priority // ignore: cast_nullable_to_non_nullable
                  as String?,
        category: freezed == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String?,
        dueDate: freezed == dueDate
            ? _value.dueDate
            : dueDate // ignore: cast_nullable_to_non_nullable
                  as String?,
        isStarred: freezed == isStarred
            ? _value.isStarred
            : isStarred // ignore: cast_nullable_to_non_nullable
                  as bool?,
        deletedAt: freezed == deletedAt
            ? _value.deletedAt
            : deletedAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        originalCategory: freezed == originalCategory
            ? _value.originalCategory
            : originalCategory // ignore: cast_nullable_to_non_nullable
                  as String?,
        originalProjectId: freezed == originalProjectId
            ? _value.originalProjectId
            : originalProjectId // ignore: cast_nullable_to_non_nullable
                  as String?,
        projectId: freezed == projectId
            ? _value.projectId
            : projectId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskUpdateImpl implements _TaskUpdate {
  const _$TaskUpdateImpl({
    this.title,
    this.description,
    this.isCompleted,
    this.priority,
    this.category,
    this.dueDate,
    this.isStarred,
    this.deletedAt,
    this.originalCategory,
    this.originalProjectId,
    this.projectId,
  });

  factory _$TaskUpdateImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskUpdateImplFromJson(json);

  @override
  final String? title;
  @override
  final String? description;
  @override
  final bool? isCompleted;
  @override
  final String? priority;
  @override
  final String? category;
  @override
  final String? dueDate;
  @override
  final bool? isStarred;
  @override
  final String? deletedAt;
  // 用于软删除/恢复
  @override
  final String? originalCategory;
  // 删除时保存，恢复时使用
  @override
  final String? originalProjectId;
  // 删除时保存，恢复时使用
  @override
  final String? projectId;

  @override
  String toString() {
    return 'TaskUpdate(title: $title, description: $description, isCompleted: $isCompleted, priority: $priority, category: $category, dueDate: $dueDate, isStarred: $isStarred, deletedAt: $deletedAt, originalCategory: $originalCategory, originalProjectId: $originalProjectId, projectId: $projectId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskUpdateImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.isStarred, isStarred) ||
                other.isStarred == isStarred) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt) &&
            (identical(other.originalCategory, originalCategory) ||
                other.originalCategory == originalCategory) &&
            (identical(other.originalProjectId, originalProjectId) ||
                other.originalProjectId == originalProjectId) &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    title,
    description,
    isCompleted,
    priority,
    category,
    dueDate,
    isStarred,
    deletedAt,
    originalCategory,
    originalProjectId,
    projectId,
  );

  /// Create a copy of TaskUpdate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskUpdateImplCopyWith<_$TaskUpdateImpl> get copyWith =>
      __$$TaskUpdateImplCopyWithImpl<_$TaskUpdateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskUpdateImplToJson(this);
  }
}

abstract class _TaskUpdate implements TaskUpdate {
  const factory _TaskUpdate({
    final String? title,
    final String? description,
    final bool? isCompleted,
    final String? priority,
    final String? category,
    final String? dueDate,
    final bool? isStarred,
    final String? deletedAt,
    final String? originalCategory,
    final String? originalProjectId,
    final String? projectId,
  }) = _$TaskUpdateImpl;

  factory _TaskUpdate.fromJson(Map<String, dynamic> json) =
      _$TaskUpdateImpl.fromJson;

  @override
  String? get title;
  @override
  String? get description;
  @override
  bool? get isCompleted;
  @override
  String? get priority;
  @override
  String? get category;
  @override
  String? get dueDate;
  @override
  bool? get isStarred;
  @override
  String? get deletedAt; // 用于软删除/恢复
  @override
  String? get originalCategory; // 删除时保存，恢复时使用
  @override
  String? get originalProjectId; // 删除时保存，恢复时使用
  @override
  String? get projectId;

  /// Create a copy of TaskUpdate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskUpdateImplCopyWith<_$TaskUpdateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Category _$CategoryFromJson(Map<String, dynamic> json) {
  return _Category.fromJson(json);
}

/// @nodoc
mixin _$Category {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get color => throw _privateConstructorUsedError;
  String? get icon => throw _privateConstructorUsedError;

  /// Serializes this Category to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Category
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CategoryCopyWith<Category> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryCopyWith<$Res> {
  factory $CategoryCopyWith(Category value, $Res Function(Category) then) =
      _$CategoryCopyWithImpl<$Res, Category>;
  @useResult
  $Res call({String id, String name, String color, String? icon});
}

/// @nodoc
class _$CategoryCopyWithImpl<$Res, $Val extends Category>
    implements $CategoryCopyWith<$Res> {
  _$CategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Category
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? color = null,
    Object? icon = freezed,
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CategoryImplCopyWith<$Res>
    implements $CategoryCopyWith<$Res> {
  factory _$$CategoryImplCopyWith(
    _$CategoryImpl value,
    $Res Function(_$CategoryImpl) then,
  ) = __$$CategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, String color, String? icon});
}

/// @nodoc
class __$$CategoryImplCopyWithImpl<$Res>
    extends _$CategoryCopyWithImpl<$Res, _$CategoryImpl>
    implements _$$CategoryImplCopyWith<$Res> {
  __$$CategoryImplCopyWithImpl(
    _$CategoryImpl _value,
    $Res Function(_$CategoryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Category
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? color = null,
    Object? icon = freezed,
  }) {
    return _then(
      _$CategoryImpl(
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
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CategoryImpl implements _Category {
  const _$CategoryImpl({
    required this.id,
    required this.name,
    required this.color,
    this.icon,
  });

  factory _$CategoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$CategoryImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String color;
  @override
  final String? icon;

  @override
  String toString() {
    return 'Category(id: $id, name: $name, color: $color, icon: $icon)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.icon, icon) || other.icon == icon));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, color, icon);

  /// Create a copy of Category
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryImplCopyWith<_$CategoryImpl> get copyWith =>
      __$$CategoryImplCopyWithImpl<_$CategoryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CategoryImplToJson(this);
  }
}

abstract class _Category implements Category {
  const factory _Category({
    required final String id,
    required final String name,
    required final String color,
    final String? icon,
  }) = _$CategoryImpl;

  factory _Category.fromJson(Map<String, dynamic> json) =
      _$CategoryImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get color;
  @override
  String? get icon;

  /// Create a copy of Category
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategoryImplCopyWith<_$CategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FocusSession _$FocusSessionFromJson(Map<String, dynamic> json) {
  return _FocusSession.fromJson(json);
}

/// @nodoc
mixin _$FocusSession {
  String get id => throw _privateConstructorUsedError;
  String? get taskId => throw _privateConstructorUsedError;
  String get startTime => throw _privateConstructorUsedError;
  String? get endTime => throw _privateConstructorUsedError;
  int get duration => throw _privateConstructorUsedError;
  bool get completed => throw _privateConstructorUsedError;

  /// Serializes this FocusSession to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FocusSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FocusSessionCopyWith<FocusSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FocusSessionCopyWith<$Res> {
  factory $FocusSessionCopyWith(
    FocusSession value,
    $Res Function(FocusSession) then,
  ) = _$FocusSessionCopyWithImpl<$Res, FocusSession>;
  @useResult
  $Res call({
    String id,
    String? taskId,
    String startTime,
    String? endTime,
    int duration,
    bool completed,
  });
}

/// @nodoc
class _$FocusSessionCopyWithImpl<$Res, $Val extends FocusSession>
    implements $FocusSessionCopyWith<$Res> {
  _$FocusSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FocusSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? taskId = freezed,
    Object? startTime = null,
    Object? endTime = freezed,
    Object? duration = null,
    Object? completed = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            taskId: freezed == taskId
                ? _value.taskId
                : taskId // ignore: cast_nullable_to_non_nullable
                      as String?,
            startTime: null == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                      as String,
            endTime: freezed == endTime
                ? _value.endTime
                : endTime // ignore: cast_nullable_to_non_nullable
                      as String?,
            duration: null == duration
                ? _value.duration
                : duration // ignore: cast_nullable_to_non_nullable
                      as int,
            completed: null == completed
                ? _value.completed
                : completed // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FocusSessionImplCopyWith<$Res>
    implements $FocusSessionCopyWith<$Res> {
  factory _$$FocusSessionImplCopyWith(
    _$FocusSessionImpl value,
    $Res Function(_$FocusSessionImpl) then,
  ) = __$$FocusSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String? taskId,
    String startTime,
    String? endTime,
    int duration,
    bool completed,
  });
}

/// @nodoc
class __$$FocusSessionImplCopyWithImpl<$Res>
    extends _$FocusSessionCopyWithImpl<$Res, _$FocusSessionImpl>
    implements _$$FocusSessionImplCopyWith<$Res> {
  __$$FocusSessionImplCopyWithImpl(
    _$FocusSessionImpl _value,
    $Res Function(_$FocusSessionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FocusSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? taskId = freezed,
    Object? startTime = null,
    Object? endTime = freezed,
    Object? duration = null,
    Object? completed = null,
  }) {
    return _then(
      _$FocusSessionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        taskId: freezed == taskId
            ? _value.taskId
            : taskId // ignore: cast_nullable_to_non_nullable
                  as String?,
        startTime: null == startTime
            ? _value.startTime
            : startTime // ignore: cast_nullable_to_non_nullable
                  as String,
        endTime: freezed == endTime
            ? _value.endTime
            : endTime // ignore: cast_nullable_to_non_nullable
                  as String?,
        duration: null == duration
            ? _value.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as int,
        completed: null == completed
            ? _value.completed
            : completed // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FocusSessionImpl implements _FocusSession {
  const _$FocusSessionImpl({
    required this.id,
    this.taskId,
    required this.startTime,
    this.endTime,
    required this.duration,
    required this.completed,
  });

  factory _$FocusSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$FocusSessionImplFromJson(json);

  @override
  final String id;
  @override
  final String? taskId;
  @override
  final String startTime;
  @override
  final String? endTime;
  @override
  final int duration;
  @override
  final bool completed;

  @override
  String toString() {
    return 'FocusSession(id: $id, taskId: $taskId, startTime: $startTime, endTime: $endTime, duration: $duration, completed: $completed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FocusSessionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.taskId, taskId) || other.taskId == taskId) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.completed, completed) ||
                other.completed == completed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    taskId,
    startTime,
    endTime,
    duration,
    completed,
  );

  /// Create a copy of FocusSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FocusSessionImplCopyWith<_$FocusSessionImpl> get copyWith =>
      __$$FocusSessionImplCopyWithImpl<_$FocusSessionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FocusSessionImplToJson(this);
  }
}

abstract class _FocusSession implements FocusSession {
  const factory _FocusSession({
    required final String id,
    final String? taskId,
    required final String startTime,
    final String? endTime,
    required final int duration,
    required final bool completed,
  }) = _$FocusSessionImpl;

  factory _FocusSession.fromJson(Map<String, dynamic> json) =
      _$FocusSessionImpl.fromJson;

  @override
  String get id;
  @override
  String? get taskId;
  @override
  String get startTime;
  @override
  String? get endTime;
  @override
  int get duration;
  @override
  bool get completed;

  /// Create a copy of FocusSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FocusSessionImplCopyWith<_$FocusSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FocusStats _$FocusStatsFromJson(Map<String, dynamic> json) {
  return _FocusStats.fromJson(json);
}

/// @nodoc
mixin _$FocusStats {
  int get totalSessions => throw _privateConstructorUsedError;
  int get totalMinutes => throw _privateConstructorUsedError;
  int get completionRate => throw _privateConstructorUsedError;

  /// Serializes this FocusStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FocusStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FocusStatsCopyWith<FocusStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FocusStatsCopyWith<$Res> {
  factory $FocusStatsCopyWith(
    FocusStats value,
    $Res Function(FocusStats) then,
  ) = _$FocusStatsCopyWithImpl<$Res, FocusStats>;
  @useResult
  $Res call({int totalSessions, int totalMinutes, int completionRate});
}

/// @nodoc
class _$FocusStatsCopyWithImpl<$Res, $Val extends FocusStats>
    implements $FocusStatsCopyWith<$Res> {
  _$FocusStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FocusStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalSessions = null,
    Object? totalMinutes = null,
    Object? completionRate = null,
  }) {
    return _then(
      _value.copyWith(
            totalSessions: null == totalSessions
                ? _value.totalSessions
                : totalSessions // ignore: cast_nullable_to_non_nullable
                      as int,
            totalMinutes: null == totalMinutes
                ? _value.totalMinutes
                : totalMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            completionRate: null == completionRate
                ? _value.completionRate
                : completionRate // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FocusStatsImplCopyWith<$Res>
    implements $FocusStatsCopyWith<$Res> {
  factory _$$FocusStatsImplCopyWith(
    _$FocusStatsImpl value,
    $Res Function(_$FocusStatsImpl) then,
  ) = __$$FocusStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int totalSessions, int totalMinutes, int completionRate});
}

/// @nodoc
class __$$FocusStatsImplCopyWithImpl<$Res>
    extends _$FocusStatsCopyWithImpl<$Res, _$FocusStatsImpl>
    implements _$$FocusStatsImplCopyWith<$Res> {
  __$$FocusStatsImplCopyWithImpl(
    _$FocusStatsImpl _value,
    $Res Function(_$FocusStatsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FocusStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalSessions = null,
    Object? totalMinutes = null,
    Object? completionRate = null,
  }) {
    return _then(
      _$FocusStatsImpl(
        totalSessions: null == totalSessions
            ? _value.totalSessions
            : totalSessions // ignore: cast_nullable_to_non_nullable
                  as int,
        totalMinutes: null == totalMinutes
            ? _value.totalMinutes
            : totalMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        completionRate: null == completionRate
            ? _value.completionRate
            : completionRate // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FocusStatsImpl implements _FocusStats {
  const _$FocusStatsImpl({
    required this.totalSessions,
    required this.totalMinutes,
    required this.completionRate,
  });

  factory _$FocusStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$FocusStatsImplFromJson(json);

  @override
  final int totalSessions;
  @override
  final int totalMinutes;
  @override
  final int completionRate;

  @override
  String toString() {
    return 'FocusStats(totalSessions: $totalSessions, totalMinutes: $totalMinutes, completionRate: $completionRate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FocusStatsImpl &&
            (identical(other.totalSessions, totalSessions) ||
                other.totalSessions == totalSessions) &&
            (identical(other.totalMinutes, totalMinutes) ||
                other.totalMinutes == totalMinutes) &&
            (identical(other.completionRate, completionRate) ||
                other.completionRate == completionRate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, totalSessions, totalMinutes, completionRate);

  /// Create a copy of FocusStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FocusStatsImplCopyWith<_$FocusStatsImpl> get copyWith =>
      __$$FocusStatsImplCopyWithImpl<_$FocusStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FocusStatsImplToJson(this);
  }
}

abstract class _FocusStats implements FocusStats {
  const factory _FocusStats({
    required final int totalSessions,
    required final int totalMinutes,
    required final int completionRate,
  }) = _$FocusStatsImpl;

  factory _FocusStats.fromJson(Map<String, dynamic> json) =
      _$FocusStatsImpl.fromJson;

  @override
  int get totalSessions;
  @override
  int get totalMinutes;
  @override
  int get completionRate;

  /// Create a copy of FocusStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FocusStatsImplCopyWith<_$FocusStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
