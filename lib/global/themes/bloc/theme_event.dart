import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:mpmc/global/themes/custom_themes.dart';

@immutable
abstract class ThemeEvent extends Equatable {
  ThemeEvent([List props = const <dynamic>[]]) : super(props);
}

class ThemeChaned extends ThemeEvent {
  final AppTheme theme;

  ThemeChaned({@required this.theme}) : super([theme]);
}
