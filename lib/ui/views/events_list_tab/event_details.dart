import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ppj/core/models/dish.dart';
import 'package:ppj/core/models/event.dart';
import 'package:ppj/ui/widgets/app_bar.dart';
import 'package:ppj/ui/widgets/google_map.dart';

class EventDetailsView extends StatefulWidget {
  final Event event;
  const EventDetailsView({Key key, this.event}) : super(key: key);

  @override
  State<StatefulWidget> createState() => EventDetailsViewState();
}

class EventDetailsViewState extends State<EventDetailsView> {
  final NumberFormat _formatter = new NumberFormat('0.##€', 'fr_FR');
  var _position;

  @override
  void initState() {
    _position = new LatLng(widget.event.place.address.location.lat,
        widget.event.place.address.location.lng);
    super.initState();
  }

  Map<String, Marker> _getMarker() {
    var markers = new Map<String, Marker>();
    Event event = widget.event;
    final marker = Marker(
      // icon: _pinLocationIcon,
      markerId: MarkerId(event.description),
      position: LatLng(
          event.place.address.location.lat, event.place.address.location.lng),
      infoWindow: InfoWindow(
        title: event.description,
        snippet: event.place.address.street,
      ),
    );
    markers[event.description] = marker;
    return markers;
  }

  @override
  Widget build(BuildContext context) {
    void _loadMap(GoogleMapController controller) {
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: _position,
        tilt: 50.0,
        zoom: 15.0,
      )));
    }

    return Scaffold(
        appBar: PPJAppBar(
          backButtonVisible: true,
          titleName: 'Détails',
        ),
        body: SingleChildScrollView(
            child: Container(
          margin: EdgeInsets.all(15.0),
          child: (new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Card(
                child: ListTile(
                  title: new Text(
                    widget.event.description,
                    style: new TextStyle(
                        fontSize: 18.0, fontWeight: FontWeight.w700),
                  ),
                  subtitle: new Text(
                    widget.event.place.name,
                    style: new TextStyle(
                        fontSize: 15.0, fontWeight: FontWeight.normal),
                  ),
                  trailing: new Text(
                      _formatter.format((widget.event as Dish)?.price) ?? '',
                      style: new TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ),
              new SizedBox(
                height: 10.0,
              ),
              Container(
                  height: 300,
                  child: Card(
                      child: GoogleMapWidget(
                    targetPosition: _position,
                    markers: _getMarker(),
                    onMapCreated: _loadMap,
                  ))),
              new SizedBox(
                height: 30.0,
              ),
              new Card(
                clipBehavior: Clip.antiAlias,
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(8.0)),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      ...widget.event.tags
                          ?.map((t) => Chip(label: Text(t)))
                          ?.toList()
                    ],
                  ),
                ),
              )
            ],
          )),
        )));
  }
}
