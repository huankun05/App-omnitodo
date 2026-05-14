// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LoginDto _$LoginDtoFromJson(Map<String, dynamic> json) {
  return _LoginDto.fromJson(json);
}

/// @nodoc
mixin _$LoginDto {
  String get email => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;

  /// Serializes this LoginDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LoginDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LoginDtoCopyWith<LoginDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginDtoCopyWith<$Res> {
  factory $LoginDtoCopyWith(LoginDto value, $Res Function(LoginDto) then) =
      _$LoginDtoCopyWithImpl<$Res, LoginDto>;
  @useResult
  $Res call({String email, String password});
}

/// @nodoc
class _$LoginDtoCopyWithImpl<$Res, $Val extends LoginDto>
    implements $LoginDtoCopyWith<$Res> {
  _$LoginDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoginDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? email = null, Object? password = null}) {
    return _then(
      _value.copyWith(
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            password: null == password
                ? _value.password
                : password // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LoginDtoImplCopyWith<$Res>
    implements $LoginDtoCopyWith<$Res> {
  factory _$$LoginDtoImplCopyWith(
    _$LoginDtoImpl value,
    $Res Function(_$LoginDtoImpl) then,
  ) = __$$LoginDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String email, String password});
}

/// @nodoc
class __$$LoginDtoImplCopyWithImpl<$Res>
    extends _$LoginDtoCopyWithImpl<$Res, _$LoginDtoImpl>
    implements _$$LoginDtoImplCopyWith<$Res> {
  __$$LoginDtoImplCopyWithImpl(
    _$LoginDtoImpl _value,
    $Res Function(_$LoginDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LoginDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? email = null, Object? password = null}) {
    return _then(
      _$LoginDtoImpl(
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        password: null == password
            ? _value.password
            : password // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LoginDtoImpl implements _LoginDto {
  const _$LoginDtoImpl({required this.email, required this.password});

  factory _$LoginDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoginDtoImplFromJson(json);

  @override
  final String email;
  @override
  final String password;

  @override
  String toString() {
    return 'LoginDto(email: $email, password: $password)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginDtoImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, email, password);

  /// Create a copy of LoginDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoginDtoImplCopyWith<_$LoginDtoImpl> get copyWith =>
      __$$LoginDtoImplCopyWithImpl<_$LoginDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LoginDtoImplToJson(this);
  }
}

abstract class _LoginDto implements LoginDto {
  const factory _LoginDto({
    required final String email,
    required final String password,
  }) = _$LoginDtoImpl;

  factory _LoginDto.fromJson(Map<String, dynamic> json) =
      _$LoginDtoImpl.fromJson;

  @override
  String get email;
  @override
  String get password;

  /// Create a copy of LoginDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoginDtoImplCopyWith<_$LoginDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RegisterDto _$RegisterDtoFromJson(Map<String, dynamic> json) {
  return _RegisterDto.fromJson(json);
}

/// @nodoc
mixin _$RegisterDto {
  String get email => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  /// Serializes this RegisterDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RegisterDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RegisterDtoCopyWith<RegisterDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegisterDtoCopyWith<$Res> {
  factory $RegisterDtoCopyWith(
    RegisterDto value,
    $Res Function(RegisterDto) then,
  ) = _$RegisterDtoCopyWithImpl<$Res, RegisterDto>;
  @useResult
  $Res call({String email, String password, String name});
}

/// @nodoc
class _$RegisterDtoCopyWithImpl<$Res, $Val extends RegisterDto>
    implements $RegisterDtoCopyWith<$Res> {
  _$RegisterDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RegisterDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? password = null,
    Object? name = null,
  }) {
    return _then(
      _value.copyWith(
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            password: null == password
                ? _value.password
                : password // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RegisterDtoImplCopyWith<$Res>
    implements $RegisterDtoCopyWith<$Res> {
  factory _$$RegisterDtoImplCopyWith(
    _$RegisterDtoImpl value,
    $Res Function(_$RegisterDtoImpl) then,
  ) = __$$RegisterDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String email, String password, String name});
}

/// @nodoc
class __$$RegisterDtoImplCopyWithImpl<$Res>
    extends _$RegisterDtoCopyWithImpl<$Res, _$RegisterDtoImpl>
    implements _$$RegisterDtoImplCopyWith<$Res> {
  __$$RegisterDtoImplCopyWithImpl(
    _$RegisterDtoImpl _value,
    $Res Function(_$RegisterDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RegisterDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? password = null,
    Object? name = null,
  }) {
    return _then(
      _$RegisterDtoImpl(
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        password: null == password
            ? _value.password
            : password // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RegisterDtoImpl implements _RegisterDto {
  const _$RegisterDtoImpl({
    required this.email,
    required this.password,
    required this.name,
  });

  factory _$RegisterDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$RegisterDtoImplFromJson(json);

  @override
  final String email;
  @override
  final String password;
  @override
  final String name;

  @override
  String toString() {
    return 'RegisterDto(email: $email, password: $password, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegisterDtoImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, email, password, name);

  /// Create a copy of RegisterDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RegisterDtoImplCopyWith<_$RegisterDtoImpl> get copyWith =>
      __$$RegisterDtoImplCopyWithImpl<_$RegisterDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RegisterDtoImplToJson(this);
  }
}

abstract class _RegisterDto implements RegisterDto {
  const factory _RegisterDto({
    required final String email,
    required final String password,
    required final String name,
  }) = _$RegisterDtoImpl;

  factory _RegisterDto.fromJson(Map<String, dynamic> json) =
      _$RegisterDtoImpl.fromJson;

  @override
  String get email;
  @override
  String get password;
  @override
  String get name;

  /// Create a copy of RegisterDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RegisterDtoImplCopyWith<_$RegisterDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AuthResponse _$AuthResponseFromJson(Map<String, dynamic> json) {
  return _AuthResponse.fromJson(json);
}

/// @nodoc
mixin _$AuthResponse {
  String get token => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  /// Serializes this AuthResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AuthResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthResponseCopyWith<AuthResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthResponseCopyWith<$Res> {
  factory $AuthResponseCopyWith(
    AuthResponse value,
    $Res Function(AuthResponse) then,
  ) = _$AuthResponseCopyWithImpl<$Res, AuthResponse>;
  @useResult
  $Res call({String token, String userId, String email, String name});
}

/// @nodoc
class _$AuthResponseCopyWithImpl<$Res, $Val extends AuthResponse>
    implements $AuthResponseCopyWith<$Res> {
  _$AuthResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? userId = null,
    Object? email = null,
    Object? name = null,
  }) {
    return _then(
      _value.copyWith(
            token: null == token
                ? _value.token
                : token // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AuthResponseImplCopyWith<$Res>
    implements $AuthResponseCopyWith<$Res> {
  factory _$$AuthResponseImplCopyWith(
    _$AuthResponseImpl value,
    $Res Function(_$AuthResponseImpl) then,
  ) = __$$AuthResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String token, String userId, String email, String name});
}

/// @nodoc
class __$$AuthResponseImplCopyWithImpl<$Res>
    extends _$AuthResponseCopyWithImpl<$Res, _$AuthResponseImpl>
    implements _$$AuthResponseImplCopyWith<$Res> {
  __$$AuthResponseImplCopyWithImpl(
    _$AuthResponseImpl _value,
    $Res Function(_$AuthResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? userId = null,
    Object? email = null,
    Object? name = null,
  }) {
    return _then(
      _$AuthResponseImpl(
        token: null == token
            ? _value.token
            : token // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AuthResponseImpl implements _AuthResponse {
  const _$AuthResponseImpl({
    required this.token,
    required this.userId,
    required this.email,
    required this.name,
  });

  factory _$AuthResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthResponseImplFromJson(json);

  @override
  final String token;
  @override
  final String userId;
  @override
  final String email;
  @override
  final String name;

  @override
  String toString() {
    return 'AuthResponse(token: $token, userId: $userId, email: $email, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthResponseImpl &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, token, userId, email, name);

  /// Create a copy of AuthResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthResponseImplCopyWith<_$AuthResponseImpl> get copyWith =>
      __$$AuthResponseImplCopyWithImpl<_$AuthResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthResponseImplToJson(this);
  }
}

abstract class _AuthResponse implements AuthResponse {
  const factory _AuthResponse({
    required final String token,
    required final String userId,
    required final String email,
    required final String name,
  }) = _$AuthResponseImpl;

  factory _AuthResponse.fromJson(Map<String, dynamic> json) =
      _$AuthResponseImpl.fromJson;

  @override
  String get token;
  @override
  String get userId;
  @override
  String get email;
  @override
  String get name;

  /// Create a copy of AuthResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthResponseImplCopyWith<_$AuthResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
