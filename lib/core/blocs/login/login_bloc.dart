import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:ppj/core/blocs/authentication/authentication_bloc.dart';
import 'package:ppj/core/blocs/authentication/authentication_event.dart';
import 'package:ppj/core/enums/social_type.dart';
import 'package:ppj/core/repositories/user_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository;
  final AuthenticationBloc authenticationBloc;
  final googleSignIn = new GoogleSignIn();
  final facebookSignIn = new FacebookLogin();

  LoginBloc({
    @required this.userRepository,
    @required this.authenticationBloc,
  })  : assert(userRepository != null),
        assert(authenticationBloc != null);

  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();

      try {
        final token = await userRepository.authenticate(
          email: event.email,
          password: event.password,
        );

        if (token != null) {
          authenticationBloc.add(LoggedIn(token: token));
          yield LoginInitial();
        } else {
          yield LoginFailure(error: "Email ou mot de passe incorrect");
        }
      } catch (error) {
        yield LoginFailure(error: error.toString());
      }
    }

    if (event is LoginSocialButtonPressed) {
      yield LoginLoading();

      try {
        String tokenId;
        if (event.type == SocialType.GOOGLE) {
          final GoogleSignInAccount googleAccount = await googleSignIn.signIn();
          if (googleAccount != null) {
            final GoogleSignInAuthentication googleAuth =
                await googleAccount.authentication;
            tokenId = googleAuth.idToken;
          }
        } else if (event.type == SocialType.FACEBOOK) {
          final FacebookLoginResult facebookAccount = await facebookSignIn
              .logIn([
            'public_profile',
            'email',
            'user_birthday',
            'user_location'
          ]);
          if (facebookAccount != null) {
            tokenId = facebookAccount.accessToken.token;
          }
        }

        if (tokenId == null) {
          yield LoginFailure(
              error: "Authentification " +
                  SocialTypeHelper.getValueToString(event.type) +
                  " annulée.");
        } else {
          final token = await userRepository.authenticateSocial(
            type: event.type,
            tokenId: tokenId,
          );

          if (token != null) {
            authenticationBloc.add(LoggedIn(token: token));
            yield LoginInitial();
          } else {
            yield LoginFailure(
                error: "Impossible de vous connecter avec " +
                    SocialTypeHelper.getValueToString(event.type));
          }
        }
      } catch (error) {
        yield LoginFailure(error: error.toString());
      }
    }
  }
}
