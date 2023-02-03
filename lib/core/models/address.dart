import 'package:json_annotation/json_annotation.dart';

import 'location.dart';

@JsonSerializable()
class Address {
  String street;
  String zipCode;
  String city;
  String country;
  GeoJsonPoint location;

  Address({this.street, this.zipCode, this.city, this.country, this.location});

  factory Address.fromJson(Map<String, dynamic> json) => new Address(
      street: json["street"],
      zipCode: json["zipCode"],
      city: json["city"],
      country: json["country"],
      location: json["location"] != null
          ? GeoJsonPoint.fromJson(json["location"])
          : null);

  Map<String, dynamic> toJson() => {
        "street": street,
        "zipCode": zipCode,
        "city": city,
        "country": country,
        "location": location
      };
}
