import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:ppj/core/blocs/events/events_event.dart';
import 'package:ppj/core/repositories/user_repository.dart';
import 'package:ppj/ui/shared/theme.dart';
import 'package:ppj/ui/views/home_view.dart';
import 'package:ppj/ui/views/login_view.dart';
import 'package:ppj/ui/router.dart';
import 'package:catcher/catcher_plugin.dart';

import 'core/blocs/authentication/authentication.dart';
import 'core/blocs/events/events_bloc.dart';
import 'core/blocs/events_map/events_map_bloc.dart';
import 'core/blocs/events_planner/events_planner_bloc.dart';
import 'core/blocs/favorites/favorites_bloc.dart';
import 'core/blocs/navigation/navigation_bloc.dart';
import 'core/blocs/user_profile/user_profile_bloc.dart';
import 'locator.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    print(error);
  }
}

void main() {
  setupLocator();
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final userRepository = UserRepository();
  runApp(
    BlocProvider<AuthenticationBloc>(
      builder: (context) {
        return AuthenticationBloc(userRepository: userRepository)
          ..add(AppStarted());
      },
      child: App(userRepository: userRepository),
    ),
  );
  // Catcher config (handle error to popup for all exceptions)
  /* CatcherOptions debugOptions =
      CatcherOptions(PageReportMode(showStackTrace: false), [
    ConsoleHandler(
        enableStackTrace: true,
        enableApplicationParameters: false,
        enableCustomParameters: false)
  ]);
  Catcher(w, debugConfig: debugOptions);

   */
}

class App extends StatelessWidget {
  final UserRepository userRepository;
  final ThemeData _theme = PPJTheme.theme;

  App({Key key, @required this.userRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [const Locale('fr', 'FR')],
      navigatorKey: Catcher.navigatorKey,
      title: 'PlaPlaJour',
      theme: _theme,
      onGenerateRoute: Router.generateRoute,
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationUninitialized) {
            return Container(
                color: Theme.of(context).primaryColorDark,
                child: Center(child: Image.asset('assets/logo_ppj.png')));
          }
          if (state is AuthenticationAuthenticated) {
            return MultiBlocProvider(providers: [
              BlocProvider<NavigationBloc>(
                builder: (context) => NavigationBloc(),
              ),
              BlocProvider<EventsBloc>(
                builder: (context) => EventsBloc(),
              ),
              BlocProvider<EventsOnMapBloc>(
                builder: (context) => EventsOnMapBloc(
                    navigationBloc: BlocProvider.of<NavigationBloc>(context)),
              ),
              BlocProvider<FavoritesBloc>(
                builder: (context) => FavoritesBloc(
                    navigationBloc: BlocProvider.of<NavigationBloc>(context)),
              ),
              BlocProvider<EventsPlannerBloc>(
                builder: (context) => EventsPlannerBloc(
                    navigationBloc: BlocProvider.of<NavigationBloc>(context)),
              ),
              BlocProvider<UserProfileBloc>(
                builder: (context) => UserProfileBloc(
                    navigationBloc: BlocProvider.of<NavigationBloc>(context)),
              ),
            ], child: HomePage(user: state.user));
          }
          if (state is AuthenticationUnauthenticated) {
            return LoginView(userRepository: userRepository);
          }
          if (state is AuthenticationLoading) {
            return Container(
                color: Theme.of(context).primaryColorDark,
                child: Center(child: CircularProgressIndicator()));
          }
          return Container();
        },
      ),
    );
  }
}
