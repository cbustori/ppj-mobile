import 'dart:async';

import 'package:latlong/latlong.dart';
import 'package:meta/meta.dart';
import 'package:ppj/core/blocs/events/abstract_events_bloc.dart';
import 'package:ppj/core/enums/event_date_filter.dart';
import 'package:ppj/core/enums/events_tab.dart';
import 'package:ppj/core/models/event.dart';
import 'package:ppj/core/services/event_service.dart';
import 'package:ppj/core/exceptions/app_exception.dart';
import 'package:ppj/locator.dart';
import 'package:ppj/ui/shared/event_filters.dart';

import 'events.dart';

class SoonEventsBloc extends AbstractEventsBloc {
  EventService _eventService = locator<EventService>();
  StreamSubscription eventSubscription;
  final EventsBloc eventsBloc;

  SoonEventsBloc({@required this.eventsBloc}) {
    eventSubscription = eventsBloc.listen((eventState) {
      if (eventState == EventsTab.soon && state is EventsUninitialized) {
        add(LoadEvents());
      }
    });
  }

  @override
  Future<List<Event>> fetchEvents(
      LatLng position, EventFilter filters, int currentPage) async {
    try {
      List<Event> events = await _eventService.getEvents(
          EventDateFilterEnum.SOON, position, filters, currentPage, super.limit);
      return events;
    } on AppException catch (e) {
      throw FetchDataException(e.toString());
    }
  }

  @override
  Future<void> close() {
    eventSubscription.cancel();
    return super.close();
  }
}
