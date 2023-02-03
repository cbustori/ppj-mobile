enum PlaceStatus { PENDING, CONFIRMED, NOT_APPLICABLE }

class PlaceStatusHelper {
  static PlaceStatus getValue(String status) {
    switch (status) {
      case "PENDING":
        return PlaceStatus.PENDING;
      case "CONFIRMED":
        return PlaceStatus.CONFIRMED;
      case "NOT_APPLICABLE":
        return PlaceStatus.NOT_APPLICABLE;
      default:
        return null;
    }
  }
}
