import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ppj/core/blocs/events_planner/events_planner_bloc.dart';

import 'views/events_list_tab/event_details.dart';
import 'views/events_list_tab/event_filter_view.dart';
import 'views/favorites_tab/place_details_view.dart';
import 'views/planning_tab/add_event.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case 'event-filter':
        return MaterialPageRoute(
            builder: (_) => EventFilterView(
                  filter: settings.arguments,
                ));
      case 'add-event':
        var params = settings.arguments as List;
        return MaterialPageRoute(
            builder: (context) => AddEvent(
                eventsPlannerBloc: BlocProvider.of<EventsPlannerBloc>(context),
                date: params[0],
                event: params[1]));
      case 'event-details':
        return MaterialPageRoute(
            builder: (_) => EventDetailsView(
                  event: settings.arguments,
                ));
      case 'place-details':
        var params = settings.arguments as List;
        return MaterialPageRoute(
            builder: (_) => PlaceDetailsView(
                  favoritesBloc: params[0],
                  place: params[1],
                ));
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ));
    }
  }
}
