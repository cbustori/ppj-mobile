import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:ppj/core/enums/app_tab.dart';
import 'navigation_event.dart';

class NavigationBloc extends Bloc<NavigationEvent, AppTab> {
  AppTab get initialState => AppTab.events;

  @override
  Stream<AppTab> mapEventToState(NavigationEvent event) async* {
    if (event is UpdateTab) {
      yield event.tab;
    }
  }
}
