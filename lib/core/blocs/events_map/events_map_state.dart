import 'package:equatable/equatable.dart';
import 'package:latlong/latlong.dart';
import 'package:meta/meta.dart';
import 'package:ppj/core/models/event.dart';

abstract class EventsOnMapState extends Equatable {
  @override
  List<Object> get props => [];
}

class EventsOnMapUninitialized extends EventsOnMapState {}

class EventsOnMapLoading extends EventsOnMapState {}

class EventsOnMapLoaded extends EventsOnMapState {
  final List<Event> events;
  final LatLng currentPosition;

  EventsOnMapLoaded({@required this.currentPosition, this.events});

  @override
  List<Object> get props => [events];
}

class EventsOnMapError extends EventsOnMapState {
  final String errorMsg;

  EventsOnMapError({this.errorMsg});

  @override
  List<Object> get props => [errorMsg];
}
