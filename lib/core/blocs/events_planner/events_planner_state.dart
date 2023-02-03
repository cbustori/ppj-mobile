import 'package:equatable/equatable.dart';
import 'package:ppj/core/models/event.dart';

abstract class EventsPlannerState extends Equatable {
  @override
  List<Object> get props => [];
}

class EventsPlannerUninitialized extends EventsPlannerState {}

class EventsPlannerLoading extends EventsPlannerState {}

class EventsPlannerLoaded extends EventsPlannerState {
  final List<Event> events;

  EventsPlannerLoaded({this.events});

  @override
  List<Object> get props => [events];
}

class EventsPlannerError extends EventsPlannerState {
  final String errorMsg;

  EventsPlannerError({this.errorMsg});

  @override
  List<Object> get props => [errorMsg];
}
