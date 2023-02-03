import 'package:equatable/equatable.dart';
import 'package:ppj/core/models/user.dart';

abstract class UserProfileState extends Equatable {
  @override
  List<Object> get props => [];
}

class UserProfileUnitialized extends UserProfileState {}

class UserProfileLoading extends UserProfileState {}

class UserProfileUpdating extends UserProfileState {}

class UserProfileCompleted extends UserProfileState {
  final User user;

  UserProfileCompleted({this.user});

  @override
  List<Object> get props => [user];
}

class UserProfileError extends UserProfileState {
  final String errorMsg;

  UserProfileError({this.errorMsg});

  @override
  List<Object> get props => [errorMsg];
}
