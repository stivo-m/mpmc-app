import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:mpmc/authentication/auth.dart';

@immutable
abstract class LoginEvent extends Equatable {}

class LoginWithCredentials extends LoginEvent {
  final String email, password;
  final AuthState authState;
  LoginWithCredentials(
      {@required this.authState,
      @required this.email,
      @required this.password});
}

class LoginWithGoogle extends LoginEvent {
  final String name;
  LoginWithGoogle({@required this.name});
}

class LoginIssue extends LoginEvent {
  final String error;
  LoginIssue({@required this.error});
}
