import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ppj/core/blocs/events_planner/events_planner.dart';
import 'events_bottom_sheet.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:ppj/ui/widgets/app_bar.dart';

import 'add_event.dart';

class PlanningEventView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PlanningEventViewState();
}

class _PlanningEventViewState extends State<PlanningEventView> {
  CalendarController _calendarController;
  var _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
  }

  void _addEvent() async {
    final event = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => AddEvent(
                eventsPlannerBloc: BlocProvider.of<EventsPlannerBloc>(context),
                date: _selectedDate,
                event: null)));
    if (event != null) {
      BlocProvider.of<EventsPlannerBloc>(context)
          .add(AddEventToDate(event: event));
    }
  }

  void _onDaySelected(DateTime selectedDate, List events) {
    _selectedDate = selectedDate;
    if (events.isNotEmpty) {
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (BuildContext bc) {
            return StatefulBuilder(
                builder: (BuildContext ctx, StateSetter setBottomSheetState) {
              return Container(
                  child: Wrap(children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Center(
                      child: Container(
                    height: 4.0,
                    width: 80.0,
                    color: Theme.of(context).dividerColor,
                  )),
                ),
                Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: ListView(
                      children: events
                          .map((event) => EventsBottomSheet(
                                event: event,
                                onTap: () {
                                  Navigator.of(context).pop();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => AddEvent(
                                              eventsPlannerBloc: BlocProvider
                                                  .of<EventsPlannerBloc>(
                                                      context),
                                              date: event.availableOn,
                                              event: event)));
                                },
                                onDismissed: (direction) {
                                  BlocProvider.of<EventsPlannerBloc>(context)
                                      .add(DeleteEvent(event: event));
                                  setBottomSheetState(() {
                                    events.removeWhere((e) => e.id == event.id);
                                    if (events.isEmpty) {
                                      Navigator.pop(context);
                                    }
                                  });
                                },
                              ))
                          .toList(),
                    ))
              ]));
            });
          });
    }
  }

  Widget _getWidgetByState(EventsPlannerState state) {
    if (state is EventsPlannerLoading) {
      return Container(
          color: Theme.of(context).primaryColorDark,
          child: Center(child: CircularProgressIndicator()));
    } else if (state is EventsPlannerLoaded) {
      return Scaffold(
          appBar: PPJAppBar(
            titleName: "Planning",
            trailingButton: IconButton(
              onPressed: _addEvent,
              icon: Icon(Icons.add),
            ),
          ),
          body: SingleChildScrollView(
            child: TableCalendar(
              calendarController: _calendarController,
              locale: 'fr_FR',
              calendarStyle: CalendarStyle(markersMaxAmount: 3),
              startingDayOfWeek: StartingDayOfWeek.monday,
              availableCalendarFormats: const {CalendarFormat.month: 'Mois'},
              events: Map.fromIterable(state.events,
                  key: (e) => e.availableOn,
                  value: (e) => state.events
                      .where((filter) =>
                          filter.availableOn.compareTo(e.availableOn) == 0)
                      .toList()),
              onDaySelected: _onDaySelected,
            ),
          ));
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EventsPlannerBloc, EventsPlannerState>(
        listener: (context, state) {
      if (state is EventsPlannerError) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('${state.errorMsg}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }, child: BlocBuilder<EventsPlannerBloc, EventsPlannerState>(
            builder: (context, state) {
      return _getWidgetByState(state);
    }));
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }
}
