import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ppj/core/blocs/place_details/place_details.dart';
import 'package:ppj/core/models/place.dart';
import 'tab_place_details.dart';

typedef void VoidCallback(GoogleMapController controller);

class PlaceDetails extends StatefulWidget {
  final Place place;

  PlaceDetails({@required this.place}) : assert(place != null);

  @override
  State<PlaceDetails> createState() => PlaceDetailsViewState();
}

class PlaceDetailsViewState extends State<PlaceDetails>
    with TickerProviderStateMixin {
  TabController _nestedTabController;
  final Map<String, Marker> _markers = {};
  var _placePosition = new LatLng(0, 0);
  bool _isFavorite;
  VoidCallback _onMapCreated;

  void _loadMap(GoogleMapController controller) {
    _placePosition = new LatLng(
        widget.place.address.location.lat, widget.place.address.location.lng);
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: _placePosition,
      tilt: 50.0,
      zoom: 15.0,
    )));
  }

  @override
  void initState() {
    _isFavorite = null;
    _nestedTabController = new TabController(length: 2, vsync: this);
    _onMapCreated = _loadMap;
    final marker = Marker(
      markerId: MarkerId(widget.place.id),
      position: LatLng(
          widget.place.address.location.lat, widget.place.address.location.lng),
      infoWindow: InfoWindow(
        title: widget.place.name,
        snippet: widget.place.address.street,
      ),
    );
    _markers[widget.place.id] = marker;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void _favorite() {
      BlocProvider.of<PlaceDetailsBloc>(context)
          .add(UpdateFavorite(place: widget.place));
      setState(() {
        _isFavorite = _isFavorite ? false : true;
      });
    }

    Widget _getWidgetByState(PlaceDetailsState state) {
      if (state is PlaceDetailsLoading) {
        return Container(
            color: Theme.of(context).primaryColorDark,
            child: Center(child: CircularProgressIndicator()));
      } else if (state is PlaceDetailsLoaded) {
        if (_isFavorite == null) {
          _isFavorite = state.isFavorite;
        }
        return Scaffold(
            appBar: AppBar(
              title: Text(widget.place.name),
              actions: <Widget>[Container()],
            ),
            body: Column(children: <Widget>[
              new Container(
                color: Colors.black12,
                child: new Stack(
                  children: <Widget>[
                    widget.place.picture != null
                        ? Image.network(widget.place.picture,
                            width: double.infinity, fit: BoxFit.fill)
                        : Image.asset(
                            'assets/background.png',
                            width: double.infinity,
                            height: 200.0,
                            fit: BoxFit.cover,
                          ),
                    new Positioned(
                      child: new Material(
                        child: new IconButton(
                          onPressed: _favorite,
                          icon: Icon(_isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border),
                          padding: new EdgeInsets.all(0.0),
                          //highlightColor: Colors.black,
                          iconSize: 30.0,
                        ),
                        borderRadius:
                            new BorderRadius.all(new Radius.circular(30.0)),
                        color: Colors.grey.withOpacity(0.5),
                      ),
                      right: 5.0,
                      top: 5.0,
                    ),
                  ],
                ),
                width: double.infinity,
                height: 200.0,
              ),
              Expanded(
                  child: TabPlaceDetails(
                place: widget.place,
                nestedTabController: _nestedTabController,
                events: state.events,
                targetPosition: _placePosition,
                markers: _markers,
                onMapCreated: _onMapCreated,
              ))
            ]));
      }
      return Container();
    }

    return BlocListener<PlaceDetailsBloc, PlaceDetailsState>(
        listener: (context, state) {
      if (state is PlaceDetailsError) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('${state.errorMsg}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }, child: BlocBuilder<PlaceDetailsBloc, PlaceDetailsState>(
            builder: (context, state) {
      return _getWidgetByState(state);
    }));
  }
}
