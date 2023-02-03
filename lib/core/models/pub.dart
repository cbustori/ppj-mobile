import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import '../enums/place_state.dart';
import '../enums/place_status.dart';
import '../enums/place_type.dart';
import 'address.dart';
import 'place.dart';

@JsonSerializable()
class Pub extends Place {
  Pub(String id, String name, Address address, PlaceType type, PlaceState state,
      PlaceStatus status, List<String> tags, String picture)
      : super(id, name, address, type, state, status, null, tags,
            Icons.local_bar, picture);

  factory Pub.fromJson(Map<String, dynamic> json) => new Pub(
      json["id"],
      json["name"],
      Address.fromJson(json["address"]),
      PlaceTypeHelper.getValue(json["type"]),
      PlaceStateHelper.getValue(json["state"]),
      PlaceStatusHelper.getValue(json["status"]),
      new List<String>.from(json["tags"]),
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
