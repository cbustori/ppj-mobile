import 'package:equatable/equatable.dart';
import 'package:ppj/core/models/place.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object> get props => [];
}

class LoadFavorites extends FavoritesEvent {}

class AddOrRemoveFavorite extends FavoritesEvent {
  final Place place;
  const AddOrRemoveFavorite({this.place});

  @override
  List<Object> get props => [place];

  @override
  String toString() => 'AddOrRemoveFavorite { place: $place}';
}
