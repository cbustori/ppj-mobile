import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import '../enums/place_state.dart';
import '../enums/place_status.dart';
import '../enums/place_type.dart';
import 'address.dart';
import 'place.dart';

@JsonSerializable()
class Restaurant extends Place {
  Restaurant(String id, String name, Address address, PlaceType type,
      PlaceState state, PlaceStatus status, List<String> tags, String picture)
      : super(id, name, address, type, state, status, null, tags,
            Icons.restaurant, picture);

  factory Restaurant.fromJson(Map<String, dynamic> json) => new Restaurant(
      json["id"],
      json["name"],
      json["address"] != null ? Address.fromJson(json["address"]) : null,
      PlaceTypeHelper.getValue(json["type"]),
      PlaceStateHelper.getValue(json["state"]),
      PlaceStatusHelper.getValue(json["status"]),
      json["tags"] != null ? new List<String>.from(json["tags"]) : null,
      json["picture"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "address": address,
        "type": type,
        "state": state,
        "status": status
      };
}
