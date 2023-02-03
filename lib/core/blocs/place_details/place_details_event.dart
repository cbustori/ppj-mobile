import 'package:equatable/equatable.dart';
import 'package:ppj/core/models/place.dart';

abstract class PlaceDetailsEvent extends Equatable {
  const PlaceDetailsEvent();

  @override
  List<Object> get props => [];
}

class LoadEventDetails extends PlaceDetailsEvent {
  final Place place;
  const LoadEventDetails({this.place});

  @override
  List<Object> get props => [place];

  @override
  String toString() => 'Loading { place: $place }';
}

class UpdateFavorite extends PlaceDetailsEvent {
  final Place place;
  const UpdateFavorite({this.place});

  @override
  List<Object> get props => [place];

  @override
  String toString() => 'Loading { place: $place }';
}
