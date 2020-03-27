import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:mpmc/authentication/Utils.dart';
import 'package:mpmc/authentication/auth.dart';
import './bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  @override
  LoginState get initialState =>
      InitialLoginState(isLoggedIn: false, status: AuthState.Processing);

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginWithCredentials) {
      yield LoginProcessing(status: event.authState);
      FirebaseUser user = await respository.signInWithEmailAndPassword(
          event.email, event.password);
      yield user == null
          ? LoginError(error: "Something is Wrong")
          : LoginSuccess(user: user, name: user.displayName);
    }

    if (event is LoginWithGoogle) {
      yield LoginProcessing(status: AuthState.Processing);
      FirebaseUser user = await respository.googleSignin();
      yield user == null
          ? LoginError(error: "Something Went Wrong")
          : LoginSuccess(isLoggedIn: true, name: user.displayName, user: user);
    }

    if (event is LoginIssue) {}
  }
}
