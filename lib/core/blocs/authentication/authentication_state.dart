import 'package:equatable/equatable.dart';
import 'package:ppj/core/models/user.dart';

abstract class AuthenticationState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthenticationUninitialized extends AuthenticationState {}

class AuthenticationAuthenticated extends AuthenticationState {
  final User user;

  AuthenticationAuthenticated({this.user});

  @override
  List<Object> get props => [this.user];
}

class AuthenticationUnauthenticated extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}
