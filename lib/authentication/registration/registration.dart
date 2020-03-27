import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mpmc/home/home.dart';

import 'bloc/bloc.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String email, password, name, number;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false, isAuthenticating = false;
  String error = '';
  Color errorColor = Colors.transparent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 50),
        constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
            maxWidth: MediaQuery.of(context).size.width),
        child: BlocProvider(
          builder: (context) => RegisterBloc(),
          child: BlocBuilder<RegisterBloc, RegisterState>(
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
      child: BlocListener<RegisterBloc, RegisterState>(
        listener: (BuildContext context, RegisterState state) {
          if (state is RegisterSuccess) {
            if (state.isLoggedIn) {
              isAuthenticating = false;
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

          if (state is RegisterProcessing) {
            if (!state.isLoggedIn) {
              isAuthenticating = true;
              error = "Processing...";
              errorColor = Colors.blue;
            }
          }

          if (state is RegisterError) {
            if (!state.isLoggedIn) {
              isAuthenticating = false;
              error = "Error Occured While Loging In";
              errorColor = Colors.red;
              Scaffold.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.red,
                content: Text(
                  "Login Error: ${state.error}",
                  style: TextStyle(color: Colors.white),
                ),
              ));

              Navigator.pop(context);
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (BuildContext context) => Home()));
            }
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "Welcome to MPMC",
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
                "Register Below",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .display1
                    .copyWith(fontSize: 30, fontWeight: FontWeight.w100),
              ),
              SizedBox(
                height: 30,
              ),
              isAuthenticating
                  ? CircularProgressIndicator()
                  : FlutterLogo(
                      size: 130,
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
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            labelText: "Enter Your Name",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ))),
                        validator: (String arg) {
                          if (arg.length < 2) {
                            return 'Name cannot be epty';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (String val) {
                          name = val;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        enabled: !isAuthenticating,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: "Enter Your Number",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ))),
                        validator: (String arg) {
                          if (!arg.startsWith("254")) {
                            return 'Number must start with 254..';
                          } else if (arg.length < 1) {
                            return 'Number cannot be empty';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (String val) {
                          number = val;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
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
                        height: 20,
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
                        height: 20,
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
        _googleSigninButton(context),
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
    return MaterialButton(
      disabledColor: Theme.of(context).highlightColor,
      elevation: 5,
      minWidth: double.infinity,
      color: Theme.of(context).buttonColor,
      onPressed: isAuthenticating
          ? null
          : () {
              _doSignUp("credentials", context);
            },
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Text("REGISTER")),
    );
  }

  _googleSigninButton(BuildContext context) {
    return MaterialButton(
      disabledColor: Theme.of(context).highlightColor,
      elevation: 5,
      minWidth: double.infinity,
      color: Theme.of(context).buttonTheme.colorScheme.onPrimary,
      onPressed: isAuthenticating
          ? null
          : () {
              // _doSignUp("google", context);
            },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              FontAwesomeIcons.google,
              color: Colors.black, //Theme.of(context).textTheme.display1.color,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              "Google",
              style: Theme.of(context)
                  .textTheme
                  .display1
                  .copyWith(color: Colors.black, fontSize: 23),
            ),
          ],
        ),
      ),
    );
  }

  _doSignUp(String methodType, BuildContext context) {
    if (methodType == "google") {
      BlocProvider.of<RegisterBloc>(context)
          .dispatch(SignUpWithGoogle(name: methodType));
    } else if (methodType == "credentials") {
      if (_formKey.currentState.validate()) {
        if (_autoValidate) {}
        _formKey.currentState.save();

        BlocProvider.of<RegisterBloc>(context).dispatch(RegisterWithCredentials(
            name: name, number: number, email: email, password: password));
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
