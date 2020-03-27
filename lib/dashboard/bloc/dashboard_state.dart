import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class DashboardState extends Equatable {
  DashboardState([List props = const <dynamic>[]]) : super(props);
}

class InitialDashboardState extends DashboardState {}
