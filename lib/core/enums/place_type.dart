enum PlaceType { RESTAURANT, PUB, HOTEL, OFFICE }

class PlaceTypeHelper {
  static PlaceType getValue(String type) {
    switch (type) {
      case "RESTAURANT":
        return PlaceType.RESTAURANT;
      case "PUB":
        return PlaceType.PUB;
      case "HOTEL":
        return PlaceType.HOTEL;
      case "OFFICE":
        return PlaceType.OFFICE;
      default:
        return null;
    }
  }

  static String stringValue(PlaceType type) {
    switch (type) {
      case PlaceType.RESTAURANT:
        return "RESTAURANT";
      case PlaceType.PUB:
        return "PUB";
      case PlaceType.HOTEL:
        return "HOTEL";
      case PlaceType.OFFICE:
        return "OFFICE";
      default:
        return null;
    }
  }
}
