// lib/features/auth/models/user.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../enums/user_role.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String email,
    required String name,
    required UserRole role,
    required String status,
    required String machineSerial,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
