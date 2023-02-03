enum PlaceState { OPEN, CLOSED }

class PlaceStateHelper {
  static PlaceState getValue(String state) {
    switch (state) {
      case "OPEN":
        return PlaceState.OPEN;
      case "CLOSED":
        return PlaceState.CLOSED;
      default:
        return PlaceState.OPEN;
    }
  }

  static String fromValue(PlaceState state) {
    switch (state) {
      case PlaceState.OPEN:
        return "Ouvert";
      case PlaceState.CLOSED:
        return "Fermé";
      default:
        return "Fermé";
    }
  }
}
