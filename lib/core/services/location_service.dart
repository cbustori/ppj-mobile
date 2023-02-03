import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';

class LocationService {
  Future<LatLng> getCurrentPosition() async {
    bool isLocationEnabled = await Geolocator().isLocationServiceEnabled();
    if (isLocationEnabled) {
      var position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      return new LatLng(position.latitude, position.longitude);
    } else {
      return null;
    }
  }
}
