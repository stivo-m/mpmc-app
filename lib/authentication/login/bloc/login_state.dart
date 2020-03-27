import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:mpmc/enums/auth_state_enums.dart';

@immutable
abstract class LoginState extends Equatable {}

class InitialLoginState extends LoginState {
  final MpmcAuthState state;
  InitialLoginState({this.state});
}

class LoginProcessing extends LoginState {
  final MpmcAuthState state;
  LoginProcessing({this.state});
}

class LoginCompleted extends LoginState {
  final MpmcAuthState state;
  LoginCompleted({@required this.state});
}
