import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  @override
  DashboardState get initialState => InitialDashboardState();

  @override
  Stream<DashboardState> mapEventToState(
    DashboardEvent event,
  ) async* {
  }
}
