import 'package:equatable/equatable.dart';
import 'package:ppj/ui/shared/event_filters.dart';

abstract class EventsMapEvent extends Equatable {
  const EventsMapEvent();

  @override
  List<Object> get props => [];
}

class LoadEventsOnMap extends EventsMapEvent {}

class ApplyFiltersOnMap extends EventsMapEvent {
  final EventFilter filters;
  const ApplyFiltersOnMap({this.filters});

  @override
  List<Object> get props => [filters];

  @override
  String toString() => 'Loading { filters: $filters }';
}
