import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ppj/core/models/event.dart';
import 'package:ppj/core/models/place.dart';
import 'package:ppj/ui/widgets/google_map.dart';

class TabPlaceDetails extends StatelessWidget {
  final Place place;
  final dateFormatter = new DateFormat('dd/MM/yyyy');
  final TabController nestedTabController;
  final List<Event> events;
  final LatLng targetPosition;
  final Map<String, Marker> markers;
  final VoidCallback onMapCreated;

  TabPlaceDetails(
      {this.place,
      this.nestedTabController,
      this.events,
      this.targetPosition,
      this.markers,
      this.onMapCreated});

  ListView makeBody(BuildContext context, List<Event> events) =>
      ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: events.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: Icon(events[index].icon),
            title: Text(
              events[index].description,
            ),
            subtitle: Text(dateFormatter.format(events[index].availableOn)),
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      TabBar(
        controller: nestedTabController,
        tabs: <Widget>[
          Tab(
            child: Text("Derniers évènements",
                style: TextStyle(color: Colors.black)),
          ),
          Tab(
            child: Text("Localisation", style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
      Expanded(
          child: TabBarView(controller: nestedTabController, children: <Widget>[
        Container(child: makeBody(context, events)),
        GoogleMapWidget(
          targetPosition: targetPosition,
          markers: markers,
          onMapCreated: onMapCreated,
        )
      ]))
    ]);
  }
}
