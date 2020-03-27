import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LoginEvent extends Equatable {}

class LoginWithCredentials extends LoginEvent {
  final String email, password;
  LoginWithCredentials({@required this.email, @required this.password});
}

class LoginWithGoogle extends LoginEvent {
  final String name;
  LoginWithGoogle({@required this.name});
}

class LoginIssue extends LoginEvent {
  final String error;
  LoginIssue({@required this.error});
}
