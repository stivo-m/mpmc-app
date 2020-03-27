import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:mpmc/authentication/Utils.dart';
import '../../auth.dart';
import './bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  @override
  RegisterState get initialState => InitialRegisterState();

  @override
  Stream<RegisterState> mapEventToState(
    RegisterEvent event,
  ) async* {
    if (event is RegisterWithCredentials) {
      yield RegisterProcessing(isLoggedIn: false, status: AuthState.Processing);
      FirebaseUser user = await respository.signUpWithEmailAndPassword(
          event.email, event.password, event.name, event.number);
      yield user == null
          ? RegisterError(error: "Something is Wrong")
          : RegisterSuccess(user: user, name: user.displayName);
    }

    if (event is SignUpWithGoogle) {
      yield RegisterProcessing(isLoggedIn: false, status: AuthState.Processing);
      FirebaseUser user = await respository.googleSignin();
      yield user == null
          ? RegisterError(error: "Something Went Wrong")
          : RegisterSuccess(
              isLoggedIn: true, name: user.displayName, user: user);
    }
  }
}
