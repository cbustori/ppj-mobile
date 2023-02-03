import 'package:bloc/bloc.dart';
import '../../enums/events_tab.dart';
import 'events_event.dart';

class EventsBloc extends Bloc<EventsEvent, EventsTab> {
  @override
  EventsTab get initialState => EventsTab.today;

  @override
  Stream<EventsTab> mapEventToState(EventsEvent event) async* {
    if (event is UpdateTabEvent) {
      yield event.tab;
    }
  }
}
