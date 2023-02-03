import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:ppj/core/blocs/events_planner/events_planner.dart';
import 'package:ppj/core/blocs/navigation/navigation.dart';
import 'package:ppj/core/exceptions/app_exception.dart';
import 'package:ppj/core/enums/app_tab.dart';
import 'package:ppj/core/models/event.dart';
import 'package:ppj/core/models/user.dart';
import 'package:ppj/core/services/event_service.dart';
import 'package:ppj/core/services/user_service.dart';
import 'package:ppj/locator.dart';

class EventsPlannerBloc extends Bloc<EventsPlannerEvent, EventsPlannerState> {
  EventService _eventService = locator<EventService>();
  UserService _userService = locator<UserService>();
  final NavigationBloc navigationBloc;
  StreamSubscription navigationSubscription;

  EventsPlannerBloc({@required this.navigationBloc}) {
    navigationSubscription = navigationBloc.listen((navigationState) {
      if (navigationState == AppTab.calendar &&
          state is EventsPlannerUninitialized) {
        add(LoadEventByDate(date: DateTime.now()));
      }
    });
  }

  @override
  get initialState => EventsPlannerUninitialized();

  @override
  Stream<EventsPlannerState> mapEventToState(EventsPlannerEvent event) async* {
    if (event is LoadEventByDate) {
      yield EventsPlannerLoading();
      try {
        List<Event> events =
            await _eventService.getEventsByUserAndDate(event.date);
        yield EventsPlannerLoaded(events: events);
      } on AppException catch (e) {
        yield EventsPlannerError(errorMsg: e.toString());
      }
    } else if (event is AddEventToDate) {
      List<Event> events = List.from((state as EventsPlannerLoaded).events);
      yield EventsPlannerLoading();
      events.add(event.event);
      yield EventsPlannerLoaded(events: events);
    } else if (event is UpdateEvent) {
      final List<Event> updatedEvents =
          (state as EventsPlannerLoaded).events.map((e) {
        return e.id == event.event.id ? event.event : e;
      }).toList();
      yield EventsPlannerLoaded(events: updatedEvents);
    } else if (event is DeleteEvent) {
      final List<Event> updatedEvents = (state as EventsPlannerLoaded)
          .events
          .where((e) => e.id != event.event.id)
          .toList();
      yield EventsPlannerLoaded(events: updatedEvents);
      _eventService.deleteEvent(event.event);
    }
  }

  @override
  Future<void> close() {
    navigationSubscription.cancel();
    return super.close();
  }
}
