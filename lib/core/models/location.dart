import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class GeoJsonPoint {
  GeoJsonPoint({
    this.lat,
    this.lng,
  });

  factory GeoJsonPoint.fromJson(List<dynamic> json) =>
      new GeoJsonPoint(lat: json[0], lng: json[1]);

  Map<String, dynamic> toJson() => {"lat": lat, "lng": lng};

  final double lat;
  final double lng;
}
