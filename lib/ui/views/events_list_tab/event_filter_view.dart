import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ppj/core/blocs/filtered_events/filtered_events.dart';
import 'package:ppj/ui/shared/event_filters.dart';

import 'event_filter_form.dart';

class EventFilterView extends StatelessWidget {
  final EventFilter filter;
  EventFilterView({this.filter});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FilteredEventsBloc>(
        builder: (context) =>
            FilteredEventsBloc()..add(new LoadEventsFilters(filter: filter)),
        child: EventFilterForm(filter: filter));
  }
}
