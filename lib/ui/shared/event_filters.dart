import '../../core/enums/place_type.dart';

class EventFilter {
  List<String> foodTags;
  PlaceType placeType;
  double minPrice = 10;
  double maxPrice = 40;
  double maxDistance = 2;

  EventFilter(
      {this.foodTags,
      this.placeType,
      this.minPrice,
      this.maxPrice,
      this.maxDistance});

  Map<String, dynamic> toJson() => {
        "minPrice": this.minPrice,
        "maxPrice": this.maxPrice,
        "distanceInKms": this.maxDistance,
        "placeType": this.placeType,
        "tags": this.foodTags
      };
}
