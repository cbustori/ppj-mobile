import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ppj/core/blocs/events/events.dart';
import 'package:ppj/ui/views/events_list_tab/event_list_view.dart';

class EventList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TodayEventsBloc>(
          builder: (context) => TodayEventsBloc()..add(LoadEvents()),
        ),
        BlocProvider<TomorrowEventsBloc>(
          builder: (context) => TomorrowEventsBloc(
              eventsBloc: BlocProvider.of<EventsBloc>(context)),
        ),
        BlocProvider<SoonEventsBloc>(
          builder: (context) =>
              SoonEventsBloc(eventsBloc: BlocProvider.of<EventsBloc>(context)),
        ),
      ],
      child: EventListView(),
    );
  }
}
