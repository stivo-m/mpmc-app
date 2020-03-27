import 'package:mpmc/authentication/Utils.dart';

enum AuthState { Uninitiated, Unauthenticated, Authenticated, Processing }

class Authentication {
  bool checkIfAuthenticated() {
    bool authenticated = false;
    if(respository.currentUser() != null){
      authenticated = false;
    }else{
      authenticated = true;
    }

    return authenticated;
  }


  
}
