import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class RegisterEvent extends Equatable {
  RegisterEvent([List props = const <dynamic>[]]) : super(props);
}

class SignUpWithGoogle extends RegisterEvent {
  final String name;

  SignUpWithGoogle({@required this.name}) : super([name]);
}

class RegisterWithCredentials extends RegisterEvent {
  final String name, email, number, password;

  RegisterWithCredentials(
      {@required this.name,
      @required this.email,
      @required this.number,
      @required this.password})
      : super([name, email, number, password]);
}
