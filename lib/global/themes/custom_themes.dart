import 'package:flutter/material.dart';

enum AppTheme {
  DarkTheme,
  LightTheme,
}

final appThemes = {
  AppTheme.LightTheme: ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.blue,
      scaffoldBackgroundColor: Colors.white,
      bottomAppBarColor: Colors.blueAccent,
      bottomAppBarTheme: BottomAppBarTheme(
        color: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        iconTheme: IconThemeData(color: Colors.black),
        textTheme:
            TextTheme(display1: TextStyle(color: Colors.black, fontSize: 11)),
        brightness: Brightness.light,
        color: Colors.transparent,
        elevation: 0,
      )),
  AppTheme.DarkTheme: ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.green,
      scaffoldBackgroundColor: Colors.black,
      bottomAppBarColor: Colors.blueAccent,
      bottomAppBarTheme: BottomAppBarTheme(
        color: Colors.black,
      ),
      appBarTheme: AppBarTheme(
        iconTheme: IconThemeData(color: Colors.white),
        brightness: Brightness.dark,
        color: Colors.transparent,
        elevation: 0,
      )),
};
