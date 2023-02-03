import 'dart:async';

import 'package:meta/meta.dart';
import 'package:ppj/core/blocs/navigation/navigation_bloc.dart';
import 'package:ppj/core/enums/app_tab.dart';
import 'package:ppj/core/models/user.dart';
import 'package:ppj/core/services/user_service.dart';
import 'package:ppj/locator.dart';
import 'package:bloc/bloc.dart';
import 'package:ppj/core/exceptions/app_exception.dart';

import 'user_profile_event.dart';
import 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  UserService _userService = locator<UserService>();
  final NavigationBloc navigationBloc;
  StreamSubscription navigationSubscription;

  UserProfileBloc({@required this.navigationBloc}) {
    navigationSubscription = navigationBloc.listen((navigationState) {
      if (navigationState == AppTab.profile &&
          state is UserProfileUnitialized) {
        add(LoadUserProfile());
      }
    });
  }

  @override
  UserProfileState get initialState => UserProfileUnitialized();

  @override
  Stream<UserProfileState> mapEventToState(UserProfileEvent event) async* {
    if (event is LoadUserProfile) {
      yield UserProfileLoading();
      try {
        User user = await _userService.getCurrentUser();
        yield UserProfileCompleted(user: user);
      } on AppException catch (e) {
        yield UserProfileError(errorMsg: e.toString());
      }
    }
    if (event is UpdateUserProfile) {
      try {
        User user = await _userService.saveUser(event.user);
        yield UserProfileCompleted(user: user);
      } on AppException catch (e) {
        yield UserProfileError(errorMsg: e.toString());
      }
    }
  }

  @override
  Future<void> close() {
    navigationSubscription.cancel();
    return super.close();
  }
}
