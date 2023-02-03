import 'dart:async';

import 'package:meta/meta.dart';
import 'package:ppj/core/blocs/favorites/favorites.dart';
import 'package:ppj/core/blocs/favorites/favorites_bloc.dart';
import 'package:ppj/core/models/event.dart';
import 'package:ppj/core/models/place.dart';
import 'package:ppj/core/models/user.dart';
import 'package:ppj/core/services/event_service.dart';
import 'package:ppj/core/exceptions/app_exception.dart';
import 'package:ppj/core/services/user_service.dart';
import 'package:ppj/locator.dart';
import 'package:bloc/bloc.dart';
import 'place_details.dart';

class PlaceDetailsBloc extends Bloc<PlaceDetailsEvent, PlaceDetailsState> {
  EventService _eventService = locator<EventService>();
  UserService _userService = locator<UserService>();
  final FavoritesBloc favoritesBloc;

  PlaceDetailsBloc({@required this.favoritesBloc});

  @override
  PlaceDetailsState get initialState => PlaceDetailsUninitialized();

  @override
  Stream<PlaceDetailsState> mapEventToState(PlaceDetailsEvent event) async* {
    if (event is LoadEventDetails) {
      yield PlaceDetailsLoading();
      try {
        bool isFavorite = await _isFavorite(event.place);
        List<Event> events =
            await _eventService.getEventsByPlace(event.place, 0, 20);
        yield PlaceDetailsLoaded(
            events: events, place: event.place, isFavorite: isFavorite);
      } on AppException catch (e) {
        yield PlaceDetailsError(errorMsg: e.toString());
      }
    } else if (event is UpdateFavorite) {
      List<Event> events = (state as PlaceDetailsLoaded).events;
      bool isFavorite = (state as PlaceDetailsLoaded).isFavorite;
      favoritesBloc.add(AddOrRemoveFavorite(place: event.place));
      yield PlaceDetailsLoaded(
          events: events, place: event.place, isFavorite: isFavorite);
    }
  }

  Future<bool> _isFavorite(Place place) async {
    User user = await _userService.getCurrentUser();
    bool isFavorite =
        user.favoritePlaces?.where((p) => p.id == place.id)?.isNotEmpty ??
            false;
    return isFavorite;
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
