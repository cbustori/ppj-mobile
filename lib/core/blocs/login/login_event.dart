import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:ppj/core/enums/social_type.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginButtonPressed extends LoginEvent {
  final String email;
  final String password;

  const LoginButtonPressed({
    @required this.email,
    @required this.password,
  });

  @override
  List<Object> get props => [email, password];

  @override
  String toString() =>
      'LoginButtonPressed { username: $email, password: $password }';
}

class LoginSocialButtonPressed extends LoginEvent {
  final SocialType type;

  const LoginSocialButtonPressed({@required this.type});

  @override
  List<Object> get props => [type];

  @override
  String toString() => 'LoginSocialButtonPressed { type: $type }';
}
