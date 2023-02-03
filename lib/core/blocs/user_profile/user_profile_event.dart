import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:ppj/core/models/user.dart';

abstract class UserProfileEvent extends Equatable {
  const UserProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadUserProfile extends UserProfileEvent {}

class UpdateUserProfile extends UserProfileEvent {
  final User user;
  const UpdateUserProfile({@required this.user});

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'Loading { user: $user }';
}
