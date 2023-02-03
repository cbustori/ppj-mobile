import 'dart:async';
import 'package:latlong/latlong.dart';
import 'package:meta/meta.dart';
import 'package:ppj/core/blocs/events_map/events_map.dart';
import 'package:ppj/core/blocs/navigation/navigation_bloc.dart';
import 'package:ppj/core/enums/app_tab.dart';
import 'package:ppj/core/enums/event_date_filter.dart';
import 'package:ppj/core/models/event.dart';
import 'package:ppj/core/services/event_service.dart';
import 'package:ppj/core/services/location_service.dart';
import 'package:ppj/locator.dart';
import 'package:bloc/bloc.dart';
import 'package:ppj/core/exceptions/app_exception.dart';
import 'package:ppj/ui/shared/event_filters.dart';

class EventsOnMapBloc extends Bloc<EventsMapEvent, EventsOnMapState> {
  EventService _eventService = locator<EventService>();
  LocationService _locationService = locator<LocationService>();
  StreamSubscription navigationSubscription;
  final NavigationBloc navigationBloc;

  EventsOnMapBloc({@required this.navigationBloc}) {
    navigationSubscription = navigationBloc.listen((navigationState) {
      if (navigationState == AppTab.map && state is EventsOnMapUninitialized) {
        add(LoadEventsOnMap());
      }
    });
  }

  @override
  EventsOnMapState get initialState => EventsOnMapUninitialized();

  @override
  Stream<EventsOnMapState> mapEventToState(EventsMapEvent event) async* {
    if (event is LoadEventsOnMap) {
      yield EventsOnMapLoading();
      yield* getEvents(null);
    } else if (event is ApplyFiltersOnMap) {
      yield* getEvents(event.filters);
    }
  }

  Stream<EventsOnMapState> getEvents(EventFilter filters) async* {
    try {
      LatLng pos = await _locationService.getCurrentPosition();
      if (pos != null) {
        //TODO rajouter une méthode pour récupérer tous les events dans un certain périmètre
        List<Event> events =
            await _eventService.getEvents(EventDateFilterEnum.TODAY, pos, filters, 0, 50);
        yield EventsOnMapLoaded(currentPosition: pos, events: events);
      } else {
        yield EventsOnMapError(
            errorMsg:
                "La localisation n'est pas activée. Veuillez vérifier les paramètres.");
      }
    } on AppException catch (e) {
      yield EventsOnMapError(errorMsg: e.toString());
    }
  }

  @override
  Future<void> close() {
    navigationSubscription.cancel();
    return super.close();
  }
}
