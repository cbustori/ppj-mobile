import 'dart:async';

import 'package:meta/meta.dart';
import 'package:ppj/core/blocs/navigation/navigation_bloc.dart';
import 'package:ppj/core/enums/app_tab.dart';
import 'package:ppj/core/models/place.dart';
import 'package:ppj/core/models/user.dart';
import 'package:ppj/core/services/user_service.dart';
import 'package:ppj/locator.dart';
import 'package:bloc/bloc.dart';
import 'package:ppj/core/exceptions/app_exception.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  UserService _userService = locator<UserService>();
  StreamSubscription navigationSubscription;
  final NavigationBloc navigationBloc;

  FavoritesBloc({@required this.navigationBloc}) {
    navigationSubscription = navigationBloc.listen((navigationState) {
      if (navigationState == AppTab.favorites &&
          state is FavoritesUninitialized) {
        add(LoadFavorites());
      }
    });
  }

  @override
  FavoritesState get initialState => FavoritesUninitialized();

  @override
  Stream<FavoritesState> mapEventToState(FavoritesEvent event) async* {
    if (event is LoadFavorites) {
      try {
        yield FavoritesLoading();
        User user = await _userService.getCurrentUser();
        yield FavoritesLoaded(places: user.favoritePlaces);
      } on AppException catch (e) {
        yield FavoritesError(errorMsg: e.toString());
      }
    } else if (event is AddOrRemoveFavorite) {
      List<Place> places;
      if (state is FavoritesLoaded) {
        places = List.from((state as FavoritesLoaded).places);
      } else {
        User user = await _userService.getCurrentUser();
        places = user.favoritePlaces;
      }
      yield FavoritesLoading();
      try {
        await _userService.likePlace(event.place);
        if (places.where((p) => p.id == event.place.id).isNotEmpty) {
          places..removeWhere((p) => p.id == event.place.id);
        } else {
          places..add(event.place);
        }
        yield FavoritesLoaded(places: places);
      } on AppException catch (e) {
        yield FavoritesError(errorMsg: e.toString());
      }
    }
  }

  @override
  Future<void> close() {
    navigationSubscription.cancel();
    return super.close();
  }
}
