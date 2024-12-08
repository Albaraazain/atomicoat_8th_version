// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      role: $enumDecode(_$UserRoleEnumMap, json['role']),
      status: json['status'] as String,
      machineSerial: json['machineSerial'] as String,
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'role': _$UserRoleEnumMap[instance.role]!,
      'status': instance.status,
      'machineSerial': instance.machineSerial,
    };

const _$UserRoleEnumMap = {
  UserRole.operator: 'operator',
  UserRole.engineer: 'engineer',
  UserRole.admin: 'admin',
  UserRole.user: 'user',
};
