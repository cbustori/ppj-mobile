import 'package:latlong/latlong.dart';
import 'package:ppj/core/enums/event_date_filter.dart';
import 'package:ppj/core/models/event.dart';
import 'package:ppj/core/exceptions/app_exception.dart';
import 'package:ppj/core/services/event_service.dart';
import 'package:ppj/ui/shared/event_filters.dart';

import '../../../locator.dart';
import 'abstract_events_bloc.dart';

class TodayEventsBloc extends AbstractEventsBloc {
  EventService _eventService = locator<EventService>();

  @override
  Future<List<Event>> fetchEvents(
      LatLng position, EventFilter filters, int currentPage) async {
    try {
      List<Event> events = await _eventService.getEvents(
          EventDateFilterEnum.TODAY, position, filters, currentPage, super.limit);
      return events;
    } on AppException catch (e) {
      throw FetchDataException(e.toString());
    }
  }
}
