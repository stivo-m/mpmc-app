import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../auth.dart';

@immutable
abstract class RegisterState extends Equatable {
  RegisterState([List props = const <dynamic>[]]) : super(props);
}

class InitialRegisterState extends RegisterState {}

class RegisterProcessing extends RegisterState {
  final bool isLoggedIn;
  final AuthState status;

  RegisterProcessing(
      {this.isLoggedIn = false, this.status = AuthState.Processing});
}

class RegisterSuccess extends RegisterState {
  final String name;
  final FirebaseUser user;
  final bool isLoggedIn;
  final AuthState status;

  RegisterSuccess(
      {@required this.name,
      this.isLoggedIn = true,
      @required this.user,
      this.status = AuthState.Authenticated});
}

class RegisterError extends RegisterState {
  final String error;
  final bool isLoggedIn;
  final AuthState status;

  RegisterError(
      {@required this.error,
      this.isLoggedIn = false,
      this.status = AuthState.Unauthenticated});
}
