import 'package:ppj/core/enums/user_type.dart';
import 'package:ppj/core/models/place.dart';

class ManagedPlace {
  final Place place;
  final UserType role;

  ManagedPlace({this.place, this.role});

  factory ManagedPlace.fromJson(Map<String, dynamic> json) => new ManagedPlace(
      place: Place.fromJson(json["place"]),
      role: UserTypeHelper.getValue(json["role"]));
}
