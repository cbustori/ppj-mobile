import 'package:equatable/equatable.dart';
import 'package:ppj/ui/shared/event_filters.dart';

abstract class FilteredEventsEvent extends Equatable {
  const FilteredEventsEvent();

  @override
  List<Object> get props => [];
}

class LoadEventsFilters extends FilteredEventsEvent {
  final EventFilter filter;
  LoadEventsFilters({this.filter});

  @override
  List<Object> get props => [filter];

  @override
  String toString() => 'Loading { filter: $filter }';
}

class UpdateEventsFilter extends FilteredEventsEvent {}

class ApplyEventsFilters extends FilteredEventsEvent {
  final EventFilter filters;

  ApplyEventsFilters({this.filters});

  @override
  List<Object> get props => [filters];

  @override
  String toString() => 'Loading { filters: $filters }';
}
