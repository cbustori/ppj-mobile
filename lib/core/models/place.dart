import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import '../enums/place_state.dart';
import '../enums/place_status.dart';
import '../enums/place_type.dart';
import 'pub.dart';
import 'restaurant.dart';
import 'user.dart';
import 'address.dart';

@JsonSerializable()
abstract class Place extends Equatable {
  final String id;
  final String name;
  final Address address;
  final PlaceType type;
  final PlaceState state;
  final PlaceStatus status;
  final List<User> subscribers;
  final List<String> tags;
  final IconData icon;
  final String picture;

  Place(this.id, this.name, this.address, this.type, this.state, this.status,
      this.subscribers, this.tags, this.icon, this.picture);

  static Place fromJson(Map<String, dynamic> json) {
    PlaceType type = PlaceTypeHelper.getValue(json["type"]);
    switch (type) {
      case PlaceType.RESTAURANT:
        return Restaurant.fromJson(json);
      case PlaceType.PUB:
        return Pub.fromJson(json);
      case PlaceType.HOTEL:
        // TODO: Handle this case.
        break;
      case PlaceType.OFFICE:
        // TODO: Handle this case.
        break;
    }
    return null;
  }

  @override
  List<Object> get props => [id];
}
