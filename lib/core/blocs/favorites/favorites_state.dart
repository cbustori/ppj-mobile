import 'package:equatable/equatable.dart';
import 'package:ppj/core/models/place.dart';

abstract class FavoritesState extends Equatable {
  @override
  List<Object> get props => [];
}

class FavoritesUninitialized extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<Place> places;

  FavoritesLoaded({this.places});

  @override
  List<Object> get props => [places];
}

class FavoritesError extends FavoritesState {
  final String errorMsg;

  FavoritesError({this.errorMsg});

  @override
  List<Object> get props => [errorMsg];
}
