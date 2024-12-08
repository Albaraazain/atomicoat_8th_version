import 'package:freezed_annotation/freezed_annotation.dart';
import '../models/user.dart';

part 'auth_event.freezed.dart';

@freezed
class AuthEvent with _$AuthEvent {
  // Notice we use 'const factory' for each event
  const factory AuthEvent.started() = Started;
  const factory AuthEvent.signIn({
    required String email,
    required String password,
  }) = SignIn;
  const factory AuthEvent.signUp({
    required String email,
    required String password,
    required String name,
    required String machineSerial,
  }) = SignUp;
  const factory AuthEvent.signOut() = SignOut;
  const factory AuthEvent.userChanged(User? user) = UserChanged;
}
