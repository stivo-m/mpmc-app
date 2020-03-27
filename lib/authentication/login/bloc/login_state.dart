import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mpmc/authentication/auth.dart';

@immutable
abstract class LoginState extends Equatable {}

class InitialLoginState extends LoginState {
  final bool isLoggedIn;
  final AuthState status;

  InitialLoginState({this.isLoggedIn, this.status});
}

class LoginProcessing extends LoginState {
  final bool processing;
  final AuthState status;

  LoginProcessing({this.processing = true, this.status = AuthState.Processing});
}

class LoginSuccess extends LoginState {
  final String name;
  final FirebaseUser user;
  final bool isLoggedIn;
  final AuthState status;

  LoginSuccess(
      {@required this.name,
      this.isLoggedIn = true,
      @required this.user,
      this.status = AuthState.Authenticated});
}

class LoginError extends LoginState {
  final String error;
  final bool isLoggedIn;
  final AuthState status;

  LoginError(
      {@required this.error,
      this.isLoggedIn = false,
      this.status = AuthState.Unauthenticated});
}
