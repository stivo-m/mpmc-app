import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class EventsState extends Equatable {
  EventsState([List props = const <dynamic>[]]) : super(props);
}

class InitialEventsState extends EventsState {}

class AddingEventState extends EventsState {
  final String state;
  final bool processing = true;
  AddingEventState(this.state);
}

class EventAdded extends EventsState {
  final String state;
  final bool success = true;

  EventAdded(this.state);
}

class EventError extends EventsState {
  final String state;
  final bool success = false;

  EventError(this.state);
}
