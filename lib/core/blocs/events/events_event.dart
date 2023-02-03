import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:ppj/core/models/user.dart';
import 'package:ppj/ui/shared/event_filters.dart';
import '../../enums/events_tab.dart';

abstract class EventsEvent extends Equatable {
  const EventsEvent();

  @override
  List<Object> get props => [];
}

class Fetch extends EventsEvent {
  final EventFilter filters;

  Fetch({this.filters});

  @override
  List<Object> get props => [filters];

  @override
  String toString() => 'Loading { filters: $filters }';
}

class UpdateTabEvent extends EventsEvent {
  final EventsTab tab;

  const UpdateTabEvent({this.tab});
}

class ApplyEventsFilters extends EventsEvent {
  final EventFilter filters;

  ApplyEventsFilters({this.filters});

  @override
  List<Object> get props => [filters];

  @override
  String toString() => 'Loading { filters: $filters }';
}

class UpdateEvents extends EventsEvent {
  final User user;
  const UpdateEvents({@required this.user});

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'Loading { user: $user }';
}

class LoadEvents extends EventsEvent {
  final EventFilter filters;
  const LoadEvents({this.filters});

  @override
  List<Object> get props => [filters];

  @override
  String toString() => 'Loading { filters: $filters }';
}
