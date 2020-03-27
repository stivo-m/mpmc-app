import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:mpmc/authentication/Utils.dart';
import './bloc.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  @override
  EventsState get initialState => InitialEventsState();

  @override
  Stream<EventsState> mapEventToState(
    EventsEvent event,
  ) async* {
    if (event is AddEvent) {
      yield AddingEventState("Adding Event");
      await respository.addEventToList(event);
      yield EventAdded("Success: Your Event was Addedd Successfully");
    }

    if (event is DeleteEvent) {
      await respository.detleteEvent(event.id);
      yield EventAdded("Success Event Deleted");
    }

    if (event is ScheduleMeeting) {
      yield AddingEventState("meeting");
      await respository.scheduleMeeting(
          event.agenda, event.venue, event.date, event.discussions);
      yield EventAdded("Success: Meeting Scheduled Successfully");
    }
  }
}
