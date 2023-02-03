import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ppj/core/blocs/events_map/events_map.dart';
import 'package:ppj/core/models/event.dart';
import 'package:ppj/ui/shared/event_filters.dart';
import 'package:ppj/ui/widgets/app_bar.dart';
import 'package:ppj/ui/widgets/google_map.dart';

class EventOnMapView extends StatefulWidget {
  @override
  EventOnMapState createState() => new EventOnMapState();
}

class EventOnMapState extends State<EventOnMapView> {
  EventFilter _filters;
  BitmapDescriptor _pinLocationIcon;
  @override
  void initState() {
    super.initState();
    //_setCustomMapPin();
  }

/*   void _setCustomMapPin() async {
    _pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/custom_marker.png');
  } */

  void _onMapCreated(GoogleMapController controller, LatLng currentPosition) {
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: currentPosition,
      tilt: 50.0,
      zoom: 15.0,
    )));
  }

  Map<String, Marker> _getMarkers(List<Event> events) {
    var markers = new Map<String, Marker>();
    for (final event in events) {
      if (event != null) {
        final marker = Marker(
          // icon: _pinLocationIcon,
          markerId: MarkerId(event.description),
          position: LatLng(event.place.address.location.lat,
              event.place.address.location.lng),
          infoWindow: InfoWindow(
            title: event.description,
            snippet: event.place.address.street,
          ),
        );
        markers[event.description] = marker;
      }
    }
    return markers;
  }

  _filterView() async {
    var filter = await Navigator.of(context)
        .pushNamed('event-filter', arguments: _filters);
    if (filter != null) {
      _filters = filter;
      BlocProvider.of<EventsOnMapBloc>(context)
          .add(new ApplyFiltersOnMap(filters: _filters));
    }
  }

  Widget _getWidgetByState(EventsOnMapState state) {
    if (state is EventsOnMapLoading) {
      return Container(
          color: Theme.of(context).primaryColorDark,
          child: Center(child: CircularProgressIndicator()));
    } else if (state is EventsOnMapLoaded) {
      final position = new LatLng(
          state.currentPosition.latitude, state.currentPosition.longitude);
      return Scaffold(
          appBar: PPJAppBar(
              titleName: "Evènements à proximité",
              trailingButton: IconButton(
                  onPressed: state is EventsOnMapLoading ? null : _filterView,
                  icon: Icon(Icons.filter_list))),
          body: GoogleMapWidget(
            targetPosition: position,
            onMapCreated: (controller) => _onMapCreated(controller, position),
            markers: _getMarkers(state.events),
          ));
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EventsOnMapBloc, EventsOnMapState>(
        listener: (context, state) {
      if (state is EventsOnMapError) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('${state.errorMsg}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }, child: BlocBuilder<EventsOnMapBloc, EventsOnMapState>(
            builder: (context, state) {
      return _getWidgetByState(state);
    }));
  }
}
