import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpmc/authentication/Utils.dart';
import 'package:mpmc/authentication/login/login.dart';
import 'package:mpmc/home/home.dart';

import 'global/themes/bloc/bloc.dart';

void main() => runApp(new MyApp());

// runApp(
//       DevicePreview(
//         child: MyApp(),
//       ),
//     );

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        builder: (context) => ThemeBloc(),
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: buildMain,
        ));
  }

  Widget buildMain(BuildContext context, ThemeState state) {
    return MaterialApp(
        //builder: DevicePreview.appBuilder,
        title: 'MPMC APP',
        debugShowCheckedModeBanner: false,
        theme: state.themeData,
        home: FutureBuilder(
          future: respository.currentUser(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              respository.handleMpesaInitialization();
              return snapshot.data.uid == null ? LoginScreen() : Home();
            } else {
              return LoginScreen();
            }
          },
        ));
  }
}
