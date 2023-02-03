enum EventType { DISH, HAPPY_HOUR, CONCERT, OTHER }

class EventTypeHelper {
  static EventType getValue(String type) {
    switch (type) {
      case "DISH_OF_THE_DAY":
        return EventType.DISH;
      case "HAPPY_HOUR":
        return EventType.HAPPY_HOUR;
      case "CONCERT":
        return EventType.CONCERT;
      default:
        return EventType.OTHER;
    }
  }
}
