import 'package:equatable/equatable.dart';
import 'package:ppj/core/models/event.dart';

abstract class EventsPlannerEvent extends Equatable {
  const EventsPlannerEvent();

  @override
  List<Object> get props => [];
}

class LoadEventByDate extends EventsPlannerEvent {
  final DateTime date;
  const LoadEventByDate({this.date});

  @override
  List<Object> get props => [date];

  @override
  String toString() => 'Loading { date: $date }';
}

class AddEventToDate extends EventsPlannerEvent {
  final Event event;
  const AddEventToDate({this.event});

  @override
  List<Object> get props => [event];

  @override
  String toString() => 'Adding event to date { event: $event }';
}

class UpdateEvent extends EventsPlannerEvent {
  final Event event;
  const UpdateEvent({this.event});

  @override
  List<Object> get props => [event];

  @override
  String toString() => 'Update event { event: $event }';
}

class DeleteEvent extends EventsPlannerEvent {
  final Event event;
  const DeleteEvent({this.event});

  @override
  List<Object> get props => [event];

  @override
  String toString() => 'Update event { event: $event }';
}
