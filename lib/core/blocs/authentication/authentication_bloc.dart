import 'dart:async';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:ppj/core/models/user.dart';
import 'package:ppj/core/repositories/user_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ppj/core/services/token_service.dart';
import 'package:ppj/locator.dart';

import 'authentication_event.dart';
import 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository;
  final googleSignIn = new GoogleSignIn();
  final facebookSignIn = new FacebookLogin();
  final _tokenService = locator<TokenService>();

  AuthenticationBloc({@required this.userRepository})
      : assert(userRepository != null);

  @override
  AuthenticationState get initialState => AuthenticationUninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      final bool hasToken = await userRepository.hasToken();

      if (hasToken) {
        User _user = await userRepository.getUser();
        yield AuthenticationAuthenticated(user: _user);
      } else {
        yield AuthenticationUnauthenticated();
      }
    }

    if (event is LoggedIn) {
      yield AuthenticationLoading();
      Map<String, dynamic> payload = _tokenService.parseJwt(event.token);
      await userRepository.persistToken(
          event.token, payload['sub'], payload['exp']);
      User _user = await userRepository.getUser();
      yield AuthenticationAuthenticated(user: _user);
    }

    if (event is LoggedOut) {
      yield AuthenticationLoading();
      await userRepository.deleteToken();
      if (await googleSignIn.isSignedIn()) {
        googleSignIn.disconnect();
      }
      if (await facebookSignIn.isLoggedIn) {
        facebookSignIn.logOut();
      }
      yield AuthenticationUnauthenticated();
    }
  }
}
