import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class DashboardEvent extends Equatable {
  DashboardEvent([List props = const <dynamic>[]]) : super(props);
}
