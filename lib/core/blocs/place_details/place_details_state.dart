import 'package:equatable/equatable.dart';
import 'package:ppj/core/models/event.dart';
import 'package:ppj/core/models/place.dart';

abstract class PlaceDetailsState extends Equatable {
  @override
  List<Object> get props => [];
}

class PlaceDetailsUninitialized extends PlaceDetailsState {}

class PlaceDetailsLoading extends PlaceDetailsState {}

class PlaceDetailsUpatingFavorite extends PlaceDetailsState {}

class PlaceDetailsLoaded extends PlaceDetailsState {
  final List<Event> events;
  final Place place;
  final bool isFavorite;

  PlaceDetailsLoaded({this.events, this.place, this.isFavorite});

  @override
  List<Object> get props => [events];
}

class PlaceDetailsFavoriteUpdated extends PlaceDetailsState {
  final bool isFavorite;
  final Place place;

  PlaceDetailsFavoriteUpdated({this.isFavorite, this.place});

  @override
  List<Object> get props => [isFavorite, place];
}

class PlaceDetailsError extends PlaceDetailsState {
  final String errorMsg;

  PlaceDetailsError({this.errorMsg});

  @override
  List<Object> get props => [errorMsg];
}
