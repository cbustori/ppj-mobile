import 'package:equatable/equatable.dart';
import 'package:latlong/latlong.dart';
import 'package:ppj/core/models/event.dart';
import 'package:ppj/ui/shared/event_filters.dart';

abstract class EventsState extends Equatable {
  @override
  List<Object> get props => [];
}

class EventsUninitialized extends EventsState {}

class EventsLoading extends EventsState {}

class EventsFiltersStarted extends EventsState {
  final List<String> tags;

  EventsFiltersStarted({this.tags});
}

class EventsFiltersApplied extends EventsState {}

class EventsCompleted extends EventsState {
  final List<Event> events;
  final LatLng position;
  final EventFilter filters;
  final bool hasReachedMax;
  final int currentPage;

  EventsCompleted(
      {this.events,
      this.position,
      this.filters,
      this.hasReachedMax = false,
      this.currentPage = 0});

  EventsCompleted copyWith({
    List<Event> events,
    LatLng position,
    bool hasReachedMax,
    int currentPage,
  }) {
    return EventsCompleted(
        events: events ?? this.events,
        position: position ?? this.position,
        filters: filters ?? this.filters,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        currentPage: currentPage ?? this.currentPage);
  }

  @override
  List<Object> get props =>
      [events, position, filters, hasReachedMax, currentPage];
}

class EventsFiltersLoaded extends EventsState {
  final List<String> tags;

  EventsFiltersLoaded({this.tags});
}

class EventsError extends EventsState {
  final String errorMsg;

  EventsError({this.errorMsg});

  @override
  List<Object> get props => [errorMsg];
}
