import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ppj/core/blocs/events_planner/events_planner.dart';
import 'package:ppj/core/blocs/events_to_add/events_to_add.dart';
import 'package:ppj/core/models/event.dart';
import 'add_event_view.dart';

class AddEvent extends StatelessWidget {
  final DateTime date;
  final Event event;
  final EventsPlannerBloc eventsPlannerBloc;

  AddEvent({@required this.eventsPlannerBloc, this.date, this.event});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EventsToAddBloc>(
      builder: (context) =>
          EventsToAddBloc(eventsPlannerBloc: eventsPlannerBloc)
            ..add(LoadEventsToAdd()),
      child: AddEventView(date: date, event: event),
    );
  }
}
