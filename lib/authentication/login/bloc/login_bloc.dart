import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:mpmc/authentication/Utils.dart';
import 'package:mpmc/enums/auth_state_enums.dart';
import './bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  @override
  LoginState get initialState => InitialLoginState(state: MpmcAuthState.IDLE);

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginWithCredentials) {
      yield LoginProcessing(state: MpmcAuthState.PROCESSING);
      FirebaseUser user = await respository.signInWithEmailAndPassword(
          event.email, event.password);
      yield user == null
          ? LoginCompleted(state: MpmcAuthState.FAILED)
          : LoginCompleted(state: MpmcAuthState.SUCCESSFUL);
    }

    if (event is LoginWithGoogle) {
      yield LoginProcessing(state: MpmcAuthState.PROCESSING);
      FirebaseUser user = await respository.googleSignin();
      yield user == null
          ? LoginCompleted(state: MpmcAuthState.FAILED)
          : LoginCompleted(state: MpmcAuthState.SUCCESSFUL);
    }
  }
}
