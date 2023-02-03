import 'package:equatable/equatable.dart';
import 'package:ppj/core/models/event.dart';

abstract class EventsToAddEvent extends Equatable {
  const EventsToAddEvent();

  @override
  List<Object> get props => [];
}

class LoadEventsToAdd extends EventsToAddEvent {
  final DateTime date;
  const LoadEventsToAdd({this.date});

  @override
  List<Object> get props => [date];

  @override
  String toString() => 'Loading { date: $date }';
}

class AddEvent extends EventsToAddEvent {
  final Event event;
  const AddEvent({this.event});

  @override
  List<Object> get props => [event];

  @override
  String toString() => 'Add { event: $event }';
}
