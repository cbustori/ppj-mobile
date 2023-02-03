import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

typedef void VoidCallback(GoogleMapController controller);

class GoogleMapWidget extends StatelessWidget {
  final LatLng targetPosition;
  final Map<String, Marker> markers;
  final VoidCallback onMapCreated;

  GoogleMapWidget({this.targetPosition, this.markers, this.onMapCreated});

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: onMapCreated,
      scrollGesturesEnabled: true,
      tiltGesturesEnabled: true,
      rotateGesturesEnabled: true,
      myLocationEnabled: true,
      compassEnabled: true,
      initialCameraPosition: CameraPosition(
        target: targetPosition,
        zoom: 11.0,
      ),
      markers: markers?.values?.toSet(),
    );
  }
}
