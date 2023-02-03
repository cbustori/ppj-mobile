import 'place_type.dart';

class FilterPlaceTypeHelper {
  static PlaceType fromType(String type) {
    switch (type) {
      case "Restaurant":
        return PlaceType.RESTAURANT;
      case "Pub":
        return PlaceType.PUB;
      case "Hôtel":
        return PlaceType.HOTEL;
      case "Office":
        return PlaceType.OFFICE;
      default:
        return null;
    }
  }

  static String stringValue(PlaceType type) {
    switch (type) {
      case PlaceType.RESTAURANT:
        return "Restaurant";
      case PlaceType.PUB:
        return "Pub";
      case PlaceType.HOTEL:
        return "Hôtel";
      case PlaceType.OFFICE:
        return "Snack-Bar";
      default:
        return null;
    }
  }

  static List<String> getTypes() {
    return ["Hôtel", "Pub", "Restaurant", "Snack-Bar"];
  }
}
