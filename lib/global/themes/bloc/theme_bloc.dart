import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:mpmc/global/themes/custom_themes.dart';
import './bloc.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  @override
  ThemeState get initialState =>
      ThemeState(themeData: appThemes[AppTheme.LightTheme]);

  @override
  Stream<ThemeState> mapEventToState(
    ThemeEvent event,
  ) async* {
    if (event is ThemeChaned) {
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // prefs.setString("theme", event.theme.toString());
      yield ThemeState(themeData: appThemes[event.theme]);
    }
  }
}
