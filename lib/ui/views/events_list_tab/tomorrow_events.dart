import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong/latlong.dart';
import 'package:ppj/core/blocs/events/events.dart';
import 'package:ppj/core/models/event.dart';
import 'event_list_widget.dart';
import '../../widgets/bottom_loader.dart';

class TomorrowEvents extends StatefulWidget {
  final VoidCallback onRefresh;
  TomorrowEvents({this.onRefresh});

  @override
  State<StatefulWidget> createState() => TomorrowEventsState();
}

class TomorrowEventsState extends State<TomorrowEvents> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;

  @override
  void initState() {
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      BlocProvider.of<TomorrowEventsBloc>(context).add(Fetch());
    }
  }

  @override
  Widget build(BuildContext context) {
    ListView _buildList(
        bool hasReachedMax, List<Event> events, LatLng position) {
      return ListView.builder(
        scrollDirection: Axis.vertical,
        physics: AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: hasReachedMax ? events.length : events.length + 1,
        controller: _scrollController,
        itemBuilder: (BuildContext context, int index) {
          return index >= events.length
              ? BottomLoader()
              : EventListWidget(events[index], position);
        },
      );
    }

    return BlocListener<TomorrowEventsBloc, EventsState>(listener:
        (context, state) {
      if (state is EventsError) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('${state.errorMsg}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }, child:
        BlocBuilder<TomorrowEventsBloc, EventsState>(builder: (context, state) {
      if (state is EventsCompleted) {
        return RefreshIndicator(
            onRefresh: widget.onRefresh,
            child: state.events.isNotEmpty
                ? _buildList(state.hasReachedMax, state.events, state.position)
                : SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Container(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: Center(
                            child: Text(
                          'Aucun plat du jour à proximité',
                          style: TextStyle(fontSize: 20),
                        )))));
      } else if (state is EventsLoading) {
        return Center(child: CircularProgressIndicator());
      }
      return Container();
    }));
  }
}
