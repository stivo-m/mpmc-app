import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpmc/authentication/auth.dart';
import 'package:mpmc/authentication/login/bloc/bloc.dart';
import 'package:mpmc/authentication/registration/registration.dart';
import 'package:mpmc/home/home.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email, password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false, isAuthenticating = false;
  String error = '';
  Color errorColor = Colors.transparent;
  double minImageSize = 150, maxImageSize = 150;
  AuthState _authState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 50),
        constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
            maxWidth: MediaQuery.of(context).size.width),
        child: BlocProvider(
          builder: (context) => LoginBloc(),
          child: BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) {
              return buildSingleChildScrollView(context);
            },
          ),
        ),
      ),
    );
  }

  SingleChildScrollView buildSingleChildScrollView(BuildContext context) {
    return SingleChildScrollView(
      child: BlocListener<LoginBloc, LoginState>(
        listener: (BuildContext context, LoginState state) {
          if (state is LoginSuccess) {
            if (state.isLoggedIn) {
              isAuthenticating = state.isLoggedIn;
              print("Status: $isAuthenticating");
              error = "Success";
              errorColor = Colors.green;
              Scaffold.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.green,
                content: Text(
                  "SignedIn as : ${state.name}, ${state.user.email}",
                  style: TextStyle(color: Colors.white),
                ),
              ));
              Navigator.pop(context);
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (BuildContext context) => Home()));
            }
          }

          if (state is LoginProcessing) {
            if (state.processing) {
              isAuthenticating = state.processing;
              print("Processing State: $isAuthenticating");
              errorColor = Colors.blue;
            }
          }

          if (state is LoginError) {
            if (state.isLoggedIn) {
              isAuthenticating = state.isLoggedIn;
              print("Error Status: $isAuthenticating");
              error = "Error Occured While Loging In";
              errorColor = Colors.red;
              Scaffold.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.red,
                content: Text(
                  "Login Error: ${state.error}",
                  style: TextStyle(color: Colors.white),
                ),
              ));
            }
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "Welcome Back,",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .display1
                    .copyWith(fontSize: 50, fontWeight: FontWeight.w200),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Login Below",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .display1
                    .copyWith(fontSize: 30, fontWeight: FontWeight.w100),
              ),
              SizedBox(
                height: 30,
              ),
              AnimatedContainer(
                height: _authState == AuthState.Processing
                    ? maxImageSize
                    : minImageSize,
                width: _authState == AuthState.Processing
                    ? maxImageSize
                    : minImageSize,
                duration: Duration(milliseconds: 200),
                child: Image.asset(
                  "assets/logo.png",
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        enabled: !isAuthenticating,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: "Enter Your Email",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ))),
                        validator: _validateEmail,
                        onSaved: (String val) {
                          email = val;
                        },
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      TextFormField(
                        enabled: !isAuthenticating,
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        decoration: InputDecoration(
                            labelText: "Enter Your Password",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ))),
                        validator: (String arg) {
                          if (arg.length < 9)
                            return 'Password must be at least 9 Characters';
                          else
                            return null;
                        },
                        onSaved: (String val) {
                          password = val;
                        },
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      _buttons(context),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        error.toString(),
                        style: TextStyle(color: errorColor, fontSize: 18),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buttons(BuildContext context) {
    return Column(
      children: <Widget>[
        _normalButtons(context),
        SizedBox(
          height: 40,
        ),
        //_googleSigninButton(context),
        SizedBox(
          height: 20,
        ),
        InkWell(
          onTap: isAuthenticating
              ? null
              : () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => RegistrationScreen()));
                },
          child: Container(
            width: MediaQuery.of(context).size.width / 2,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Text(
              "New Here? \n Create Account",
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  String _validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  _normalButtons(context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(70), bottomRight: Radius.circular(70)),
      child: MaterialButton(
        disabledColor: Theme.of(context).highlightColor,
        elevation: 5,
        minWidth: double.infinity,
        color: Theme.of(context).buttonColor,
        onPressed: () {
          _doSignIn("credentials", context);
        },
        // onPressed: isAuthenticating
        //     ? null
        //     : () {
        //         _doSignIn("credentials", context);
        //       },
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Text("LOGIN")),
      ),
    );
  }

  _doSignIn(String methodType, BuildContext context) {
    if (methodType == "google") {
      BlocProvider.of<LoginBloc>(context)
          .dispatch(LoginWithGoogle(name: methodType));
    } else if (methodType == "credentials") {
      if (_formKey.currentState.validate()) {
        if (_autoValidate) {}
        _formKey.currentState.save();

        BlocProvider.of<LoginBloc>(context).dispatch(LoginWithCredentials(
            authState: _authState, email: email, password: password));
      } else {
        //If all data are not valid then start auto validation.
        setState(() {
          isAuthenticating = false;
          _autoValidate = true;
        });
      }
    }
  }
}
