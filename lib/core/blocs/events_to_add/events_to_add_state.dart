import 'package:equatable/equatable.dart';
import 'package:ppj/core/models/event.dart';
import 'package:ppj/core/models/place.dart';

abstract class EventsToAddState extends Equatable {
  @override
  List<Object> get props => [];
}

class EventsToAddLoading extends EventsToAddState {}

class EventsToAddLoaded extends EventsToAddState {
  final List<Place> places;
  final List<String> tags;

  EventsToAddLoaded({this.places, this.tags});

  @override
  List<Object> get props => [places, tags];
}

class EventAdded extends EventsToAddState {
  final Event event;

  EventAdded({this.event});

  @override
  List<Object> get props => [event];
}

class EventsToAddError extends EventsToAddState {
  final String errorMsg;

  EventsToAddError({this.errorMsg});

  @override
  List<Object> get props => [errorMsg];
}
