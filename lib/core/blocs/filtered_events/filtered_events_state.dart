import 'package:equatable/equatable.dart';
import 'package:ppj/ui/shared/event_filters.dart';

abstract class FilteredEventsState extends Equatable {
  @override
  List<Object> get props => [];
}

class EventsFiltersUninitialized extends FilteredEventsState {}

class EventsFiltersLoading extends FilteredEventsState {}

class EventsFiltersStarted extends FilteredEventsState {
  final List<String> tags;

  EventsFiltersStarted({this.tags});
}

class EventsFiltersLoaded extends FilteredEventsState {
  final EventFilter filter;
  final List<String> tags;

  EventsFiltersLoaded({this.filter, this.tags});
}

class EventsFiltersError extends FilteredEventsState {
  final String errorMsg;

  EventsFiltersError({this.errorMsg});

  @override
  List<Object> get props => [errorMsg];
}
