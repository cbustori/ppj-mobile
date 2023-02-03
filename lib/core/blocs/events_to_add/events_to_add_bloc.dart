import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:ppj/core/blocs/events_planner/events_planner.dart';
import 'package:ppj/core/exceptions/app_exception.dart';
import 'package:ppj/core/models/dish.dart';
import 'package:ppj/core/models/user.dart';
import 'package:ppj/core/services/event_service.dart';
import 'package:ppj/core/services/tag_service.dart';
import 'package:ppj/core/services/user_service.dart';
import 'package:ppj/locator.dart';
import 'events_to_add.dart';

class EventsToAddBloc extends Bloc<EventsToAddEvent, EventsToAddState> {
  EventService _eventService = locator<EventService>();
  UserService _userService = locator<UserService>();
  TagService _tagService = locator<TagService>();
  final EventsPlannerBloc eventsPlannerBloc;

  EventsToAddBloc({@required this.eventsPlannerBloc});

  @override
  get initialState => EventsToAddLoading();

  @override
  Stream<EventsToAddState> mapEventToState(EventsToAddEvent event) async* {
    if (event is LoadEventsToAdd) {
      yield EventsToAddLoading();
      try {
        User user = await _userService.getCurrentUser();
        List<String> tags = await _tagService.getTags('food-type');
        yield EventsToAddLoaded(
            places: user.managedPlaces.map((m) => m.place).toList(),
            tags: tags);
      } on AppException catch (e) {
        yield EventsToAddError(errorMsg: e.toString());
      }
    } else if (event is AddEvent) {
      if (event.event is Dish) {
        Dish dish = await _eventService.createDish(event.event);
        eventsPlannerBloc.add(UpdateEvent(event: dish));
        yield EventAdded(event: dish);
      }
    }
  }
}
