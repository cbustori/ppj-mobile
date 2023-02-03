import 'package:latlong/latlong.dart';
import 'package:ppj/core/models/event.dart';
import 'package:ppj/core/services/location_service.dart';
import 'package:ppj/core/exceptions/app_exception.dart';
import 'package:ppj/locator.dart';
import 'package:bloc/bloc.dart';
import 'package:ppj/ui/shared/event_filters.dart';
import 'package:rxdart/rxdart.dart';

import 'events.dart';

abstract class AbstractEventsBloc extends Bloc<EventsEvent, EventsState> {
  LocationService _locationService = locator<LocationService>();
  final limit = 20;

  @override
  EventsState get initialState => EventsUninitialized();

  @override
  Stream<EventsState> transformEvents(Stream<EventsEvent> events,
      Stream<EventsState> Function(EventsEvent event) next) {
    return (events as Observable<EventsEvent>)
        .debounceTime(
          Duration(milliseconds: 500),
        )
        .switchMap(next);
  }

  @override
  Stream<EventsState> mapEventToState(EventsEvent event) async* {
    try {
      if (event is LoadEvents) {
        yield EventsLoading();
        LatLng position = await _getPosition();
        List<Event> events = await fetchEvents(position, event.filters, 0);
        yield EventsCompleted(
            events: events,
            position: position,
            hasReachedMax: events.length < limit,
            filters: event.filters);
      } else if (event is Fetch && !_hasReachedMax(state)) {
        if (state is EventsCompleted) {
          EventsCompleted currentState = state as EventsCompleted;
          final events = await fetchEvents(currentState.position,
              currentState.filters, currentState.currentPage);
          yield events.isEmpty
              ? currentState.copyWith(hasReachedMax: true)
              : currentState.copyWith(
                  events: currentState.events + events,
                  currentPage: currentState.currentPage + 1);
        }
      }
    } on AppException catch (e) {
      yield EventsError(errorMsg: e.toString());
    }
  }

  bool _hasReachedMax(EventsState state) =>
      state is EventsCompleted && state.hasReachedMax;

  Future<LatLng> _getPosition() async {
    LatLng pos = await _locationService.getCurrentPosition();
    if (pos != null) {
      return pos;
    } else {
      throw GPSDisableException(
          "La localisation n'est pas activée. Veuillez vérifier les paramètres.");
    }
  }

  Future<List<Event>> fetchEvents(
      LatLng position, EventFilter filters, int currentPage);
}
