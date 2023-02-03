import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../core/enums/events_tab.dart';
import '../../../core/blocs/events/events.dart';
import '../../shared/event_filters.dart';
import '../../widgets/app_bar.dart';
import 'today_events.dart';
import 'tomorrow_events.dart';
import 'soon_events.dart';

class EventListView extends StatefulWidget {
  EventListView({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => EventListViewState();
}

class EventListViewState extends State<EventListView>
    with TickerProviderStateMixin {
  TabController _nestedTabController;
  EventFilter _filters;

  @override
  void initState() {
    _nestedTabController = new TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _filterView() async {
      var filter = await Navigator.of(context)
          .pushNamed('event-filter', arguments: _filters);
      if (filter != null) {
        _filters = filter;
        EventsTab activeTab =
            EventsTabHelper.getTabByIndex(_nestedTabController.index);
        if (activeTab == EventsTab.today) {
          BlocProvider.of<TodayEventsBloc>(context)
              .add(new LoadEvents(filters: _filters));
        } else if (activeTab == EventsTab.tomorrow) {
          BlocProvider.of<TomorrowEventsBloc>(context)
              .add(new LoadEvents(filters: _filters));
        } else if (activeTab == EventsTab.soon) {
          BlocProvider.of<SoonEventsBloc>(context)
              .add(new LoadEvents(filters: _filters));
        }
      }
    }

    return BlocBuilder<EventsBloc, EventsTab>(builder: (context, state) {
      return Scaffold(
          appBar: PPJAppBar(
              bottomTab: TabBar(
                controller: _nestedTabController,
                onTap: (index) => BlocProvider.of<EventsBloc>(context).add(
                    UpdateTabEvent(tab: EventsTabHelper.getTabByIndex(index))),
                tabs: <Widget>[
                  Tab(
                    text: "Aujourd'hui",
                  ),
                  Tab(
                    text: "Demain",
                  ),
                  Tab(text: "Prochainement")
                ],
              ),
              titleName: "Plats du jour",
              trailingButton: IconButton(
                  onPressed: state is EventsLoading ? null : _filterView,
                  icon: Icon(Icons.filter_list))),
          body: Column(children: [
            Expanded(
                child: TabBarView(
                    controller: _nestedTabController,
                    children: <Widget>[
                  TodayEvents(onRefresh: () async {
                    BlocProvider.of<TodayEventsBloc>(context)
                        .add(LoadEvents(filters: _filters));
                  }),
                  TomorrowEvents(onRefresh: () async {
                    BlocProvider.of<TomorrowEventsBloc>(context)
                        .add(LoadEvents(filters: _filters));
                  }),
                  SoonEvents(onRefresh: () async {
                    BlocProvider.of<SoonEventsBloc>(context)
                        .add(LoadEvents(filters: _filters));
                  }),
                ]))
          ]));
    });
  }
}
