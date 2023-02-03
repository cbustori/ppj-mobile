import 'package:flutter/widgets.dart';
import 'package:ppj/core/enums/event_type.dart';
import 'package:ppj/core/models/picture.dart';

import 'dish.dart';
import 'place.dart';

abstract class Event {
  Event(this.id, this.title, this.description, this.availableOn, this.type, this.place, this.pictures,
      this.tags, this.icon);

  Event.fromEvent(this.title, this.description, this.availableOn, this.type, this.place, this.pictures,
      this.icon, this.tags);

  String id;
  String title;
  String description;
  DateTime availableOn;
  EventType type;
  Place place;
  double distanceWithUser;
  List<Picture> pictures;
  List<String> tags;
  IconData icon;

  static Event fromJson(Map<String, dynamic> json) {
    EventType type = EventTypeHelper.getValue(json["type"]);
    switch (type) {
      case EventType.DISH:
        return Dish.fromJson(json);
      case EventType.HAPPY_HOUR:
        // TODO: Handle this case.
        break;
      case EventType.OTHER:
        // TODO: Handle this case.
        break;
      case EventType.CONCERT:
        // TODO: Handle this case.
        break;
    }
    return null;
  }
}
