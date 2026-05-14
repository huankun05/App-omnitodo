// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoginDtoImpl _$$LoginDtoImplFromJson(Map<String, dynamic> json) =>
    _$LoginDtoImpl(
      email: json['email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$$LoginDtoImplToJson(_$LoginDtoImpl instance) =>
    <String, dynamic>{'email': instance.email, 'password': instance.password};

_$RegisterDtoImpl _$$RegisterDtoImplFromJson(Map<String, dynamic> json) =>
    _$RegisterDtoImpl(
      email: json['email'] as String,
      password: json['password'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$$RegisterDtoImplToJson(_$RegisterDtoImpl instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'name': instance.name,
    };

_$AuthResponseImpl _$$AuthResponseImplFromJson(Map<String, dynamic> json) =>
    _$AuthResponseImpl(
      token: json['token'] as String,
      userId: json['userId'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$$AuthResponseImplToJson(_$AuthResponseImpl instance) =>
    <String, dynamic>{
      'token': instance.token,
      'userId': instance.userId,
      'email': instance.email,
      'name': instance.name,
    };
