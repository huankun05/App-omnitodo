// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'config_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CreateConfigDto _$CreateConfigDtoFromJson(Map<String, dynamic> json) {
  return _CreateConfigDto.fromJson(json);
}

/// @nodoc
mixin _$CreateConfigDto {
  String get appKey => throw _privateConstructorUsedError;
  String get configKey => throw _privateConstructorUsedError;
  String get configValue => throw _privateConstructorUsedError;
  int get version => throw _privateConstructorUsedError;

  /// Serializes this CreateConfigDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateConfigDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateConfigDtoCopyWith<CreateConfigDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateConfigDtoCopyWith<$Res> {
  factory $CreateConfigDtoCopyWith(
    CreateConfigDto value,
    $Res Function(CreateConfigDto) then,
  ) = _$CreateConfigDtoCopyWithImpl<$Res, CreateConfigDto>;
  @useResult
  $Res call({String appKey, String configKey, String configValue, int version});
}

/// @nodoc
class _$CreateConfigDtoCopyWithImpl<$Res, $Val extends CreateConfigDto>
    implements $CreateConfigDtoCopyWith<$Res> {
  _$CreateConfigDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateConfigDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appKey = null,
    Object? configKey = null,
    Object? configValue = null,
    Object? version = null,
  }) {
    return _then(
      _value.copyWith(
            appKey: null == appKey
                ? _value.appKey
                : appKey // ignore: cast_nullable_to_non_nullable
                      as String,
            configKey: null == configKey
                ? _value.configKey
                : configKey // ignore: cast_nullable_to_non_nullable
                      as String,
            configValue: null == configValue
                ? _value.configValue
                : configValue // ignore: cast_nullable_to_non_nullable
                      as String,
            version: null == version
                ? _value.version
                : version // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CreateConfigDtoImplCopyWith<$Res>
    implements $CreateConfigDtoCopyWith<$Res> {
  factory _$$CreateConfigDtoImplCopyWith(
    _$CreateConfigDtoImpl value,
    $Res Function(_$CreateConfigDtoImpl) then,
  ) = __$$CreateConfigDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String appKey, String configKey, String configValue, int version});
}

/// @nodoc
class __$$CreateConfigDtoImplCopyWithImpl<$Res>
    extends _$CreateConfigDtoCopyWithImpl<$Res, _$CreateConfigDtoImpl>
    implements _$$CreateConfigDtoImplCopyWith<$Res> {
  __$$CreateConfigDtoImplCopyWithImpl(
    _$CreateConfigDtoImpl _value,
    $Res Function(_$CreateConfigDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreateConfigDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appKey = null,
    Object? configKey = null,
    Object? configValue = null,
    Object? version = null,
  }) {
    return _then(
      _$CreateConfigDtoImpl(
        appKey: null == appKey
            ? _value.appKey
            : appKey // ignore: cast_nullable_to_non_nullable
                  as String,
        configKey: null == configKey
            ? _value.configKey
            : configKey // ignore: cast_nullable_to_non_nullable
                  as String,
        configValue: null == configValue
            ? _value.configValue
            : configValue // ignore: cast_nullable_to_non_nullable
                  as String,
        version: null == version
            ? _value.version
            : version // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateConfigDtoImpl implements _CreateConfigDto {
  const _$CreateConfigDtoImpl({
    required this.appKey,
    required this.configKey,
    required this.configValue,
    required this.version,
  });

  factory _$CreateConfigDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateConfigDtoImplFromJson(json);

  @override
  final String appKey;
  @override
  final String configKey;
  @override
  final String configValue;
  @override
  final int version;

  @override
  String toString() {
    return 'CreateConfigDto(appKey: $appKey, configKey: $configKey, configValue: $configValue, version: $version)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateConfigDtoImpl &&
            (identical(other.appKey, appKey) || other.appKey == appKey) &&
            (identical(other.configKey, configKey) ||
                other.configKey == configKey) &&
            (identical(other.configValue, configValue) ||
                other.configValue == configValue) &&
            (identical(other.version, version) || other.version == version));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, appKey, configKey, configValue, version);

  /// Create a copy of CreateConfigDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateConfigDtoImplCopyWith<_$CreateConfigDtoImpl> get copyWith =>
      __$$CreateConfigDtoImplCopyWithImpl<_$CreateConfigDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateConfigDtoImplToJson(this);
  }
}

abstract class _CreateConfigDto implements CreateConfigDto {
  const factory _CreateConfigDto({
    required final String appKey,
    required final String configKey,
    required final String configValue,
    required final int version,
  }) = _$CreateConfigDtoImpl;

  factory _CreateConfigDto.fromJson(Map<String, dynamic> json) =
      _$CreateConfigDtoImpl.fromJson;

  @override
  String get appKey;
  @override
  String get configKey;
  @override
  String get configValue;
  @override
  int get version;

  /// Create a copy of CreateConfigDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateConfigDtoImplCopyWith<_$CreateConfigDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UpdateConfigDto _$UpdateConfigDtoFromJson(Map<String, dynamic> json) {
  return _UpdateConfigDto.fromJson(json);
}

/// @nodoc
mixin _$UpdateConfigDto {
  String get configValue => throw _privateConstructorUsedError;
  int get version => throw _privateConstructorUsedError;

  /// Serializes this UpdateConfigDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateConfigDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateConfigDtoCopyWith<UpdateConfigDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateConfigDtoCopyWith<$Res> {
  factory $UpdateConfigDtoCopyWith(
    UpdateConfigDto value,
    $Res Function(UpdateConfigDto) then,
  ) = _$UpdateConfigDtoCopyWithImpl<$Res, UpdateConfigDto>;
  @useResult
  $Res call({String configValue, int version});
}

/// @nodoc
class _$UpdateConfigDtoCopyWithImpl<$Res, $Val extends UpdateConfigDto>
    implements $UpdateConfigDtoCopyWith<$Res> {
  _$UpdateConfigDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateConfigDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? configValue = null, Object? version = null}) {
    return _then(
      _value.copyWith(
            configValue: null == configValue
                ? _value.configValue
                : configValue // ignore: cast_nullable_to_non_nullable
                      as String,
            version: null == version
                ? _value.version
                : version // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UpdateConfigDtoImplCopyWith<$Res>
    implements $UpdateConfigDtoCopyWith<$Res> {
  factory _$$UpdateConfigDtoImplCopyWith(
    _$UpdateConfigDtoImpl value,
    $Res Function(_$UpdateConfigDtoImpl) then,
  ) = __$$UpdateConfigDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String configValue, int version});
}

/// @nodoc
class __$$UpdateConfigDtoImplCopyWithImpl<$Res>
    extends _$UpdateConfigDtoCopyWithImpl<$Res, _$UpdateConfigDtoImpl>
    implements _$$UpdateConfigDtoImplCopyWith<$Res> {
  __$$UpdateConfigDtoImplCopyWithImpl(
    _$UpdateConfigDtoImpl _value,
    $Res Function(_$UpdateConfigDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UpdateConfigDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? configValue = null, Object? version = null}) {
    return _then(
      _$UpdateConfigDtoImpl(
        configValue: null == configValue
            ? _value.configValue
            : configValue // ignore: cast_nullable_to_non_nullable
                  as String,
        version: null == version
            ? _value.version
            : version // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateConfigDtoImpl implements _UpdateConfigDto {
  const _$UpdateConfigDtoImpl({
    required this.configValue,
    required this.version,
  });

  factory _$UpdateConfigDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdateConfigDtoImplFromJson(json);

  @override
  final String configValue;
  @override
  final int version;

  @override
  String toString() {
    return 'UpdateConfigDto(configValue: $configValue, version: $version)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateConfigDtoImpl &&
            (identical(other.configValue, configValue) ||
                other.configValue == configValue) &&
            (identical(other.version, version) || other.version == version));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, configValue, version);

  /// Create a copy of UpdateConfigDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateConfigDtoImplCopyWith<_$UpdateConfigDtoImpl> get copyWith =>
      __$$UpdateConfigDtoImplCopyWithImpl<_$UpdateConfigDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateConfigDtoImplToJson(this);
  }
}

abstract class _UpdateConfigDto implements UpdateConfigDto {
  const factory _UpdateConfigDto({
    required final String configValue,
    required final int version,
  }) = _$UpdateConfigDtoImpl;

  factory _UpdateConfigDto.fromJson(Map<String, dynamic> json) =
      _$UpdateConfigDtoImpl.fromJson;

  @override
  String get configValue;
  @override
  int get version;

  /// Create a copy of UpdateConfigDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateConfigDtoImplCopyWith<_$UpdateConfigDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ConfigItem _$ConfigItemFromJson(Map<String, dynamic> json) {
  return _ConfigItem.fromJson(json);
}

/// @nodoc
mixin _$ConfigItem {
  String get id => throw _privateConstructorUsedError;
  String get appKey => throw _privateConstructorUsedError;
  String get configKey => throw _privateConstructorUsedError;
  dynamic get configValue => throw _privateConstructorUsedError;
  int get version => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ConfigItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConfigItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConfigItemCopyWith<ConfigItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConfigItemCopyWith<$Res> {
  factory $ConfigItemCopyWith(
    ConfigItem value,
    $Res Function(ConfigItem) then,
  ) = _$ConfigItemCopyWithImpl<$Res, ConfigItem>;
  @useResult
  $Res call({
    String id,
    String appKey,
    String configKey,
    dynamic configValue,
    int version,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$ConfigItemCopyWithImpl<$Res, $Val extends ConfigItem>
    implements $ConfigItemCopyWith<$Res> {
  _$ConfigItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConfigItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? appKey = null,
    Object? configKey = null,
    Object? configValue = freezed,
    Object? version = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            appKey: null == appKey
                ? _value.appKey
                : appKey // ignore: cast_nullable_to_non_nullable
                      as String,
            configKey: null == configKey
                ? _value.configKey
                : configKey // ignore: cast_nullable_to_non_nullable
                      as String,
            configValue: freezed == configValue
                ? _value.configValue
                : configValue // ignore: cast_nullable_to_non_nullable
                      as dynamic,
            version: null == version
                ? _value.version
                : version // ignore: cast_nullable_to_non_nullable
                      as int,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ConfigItemImplCopyWith<$Res>
    implements $ConfigItemCopyWith<$Res> {
  factory _$$ConfigItemImplCopyWith(
    _$ConfigItemImpl value,
    $Res Function(_$ConfigItemImpl) then,
  ) = __$$ConfigItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String appKey,
    String configKey,
    dynamic configValue,
    int version,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$ConfigItemImplCopyWithImpl<$Res>
    extends _$ConfigItemCopyWithImpl<$Res, _$ConfigItemImpl>
    implements _$$ConfigItemImplCopyWith<$Res> {
  __$$ConfigItemImplCopyWithImpl(
    _$ConfigItemImpl _value,
    $Res Function(_$ConfigItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ConfigItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? appKey = null,
    Object? configKey = null,
    Object? configValue = freezed,
    Object? version = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$ConfigItemImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        appKey: null == appKey
            ? _value.appKey
            : appKey // ignore: cast_nullable_to_non_nullable
                  as String,
        configKey: null == configKey
            ? _value.configKey
            : configKey // ignore: cast_nullable_to_non_nullable
                  as String,
        configValue: freezed == configValue
            ? _value.configValue
            : configValue // ignore: cast_nullable_to_non_nullable
                  as dynamic,
        version: null == version
            ? _value.version
            : version // ignore: cast_nullable_to_non_nullable
                  as int,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ConfigItemImpl implements _ConfigItem {
  const _$ConfigItemImpl({
    required this.id,
    required this.appKey,
    required this.configKey,
    required this.configValue,
    required this.version,
    this.createdAt,
    this.updatedAt,
  });

  factory _$ConfigItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConfigItemImplFromJson(json);

  @override
  final String id;
  @override
  final String appKey;
  @override
  final String configKey;
  @override
  final dynamic configValue;
  @override
  final int version;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'ConfigItem(id: $id, appKey: $appKey, configKey: $configKey, configValue: $configValue, version: $version, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConfigItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.appKey, appKey) || other.appKey == appKey) &&
            (identical(other.configKey, configKey) ||
                other.configKey == configKey) &&
            const DeepCollectionEquality().equals(
              other.configValue,
              configValue,
            ) &&
            (identical(other.version, version) || other.version == version) &&
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
    appKey,
    configKey,
    const DeepCollectionEquality().hash(configValue),
    version,
    createdAt,
    updatedAt,
  );

  /// Create a copy of ConfigItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConfigItemImplCopyWith<_$ConfigItemImpl> get copyWith =>
      __$$ConfigItemImplCopyWithImpl<_$ConfigItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConfigItemImplToJson(this);
  }
}

abstract class _ConfigItem implements ConfigItem {
  const factory _ConfigItem({
    required final String id,
    required final String appKey,
    required final String configKey,
    required final dynamic configValue,
    required final int version,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$ConfigItemImpl;

  factory _ConfigItem.fromJson(Map<String, dynamic> json) =
      _$ConfigItemImpl.fromJson;

  @override
  String get id;
  @override
  String get appKey;
  @override
  String get configKey;
  @override
  dynamic get configValue;
  @override
  int get version;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of ConfigItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConfigItemImplCopyWith<_$ConfigItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
