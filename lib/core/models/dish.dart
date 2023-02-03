import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:ppj/core/enums/event_type.dart';
import 'package:ppj/core/models/picture.dart';
import 'package:ppj/core/models/place.dart';

import 'event.dart';

@JsonSerializable()
class Dish extends Event {
  final double price;

  Dish(String id, String title, String description, DateTime availableOn, Place place,
      List<String> tags, List<Picture> pictures, {this.price})
      : super(id, title, description, availableOn, EventType.DISH, place, pictures, tags,
            Icons.restaurant_menu);

  factory Dish.fromJson(Map<String, dynamic> json) => new Dish(
      json["id"],
      json["title"],
      json["description"],
      DateTime.parse(json["availableOn"]),
      json["place"] != null ? Place.fromJson(json["place"]) : null,
      json["tags"] != null ? List<String>.from(json["tags"]) : null,
      (json["pictures"] as List).map((p) => Picture.fromJson(p)).toList(),
      price: json["price"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "availableOn": availableOn,
        "type": type,
        "place": place,
        "price": price
      };
}
