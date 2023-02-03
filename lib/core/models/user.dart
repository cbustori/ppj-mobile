import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:ppj/core/enums/user_type.dart';

import 'address.dart';
import 'managed_place.dart';
import 'place.dart';

@JsonSerializable()
class User {
  String id;
  String firstName;
  String name;
  String email;
  String phoneNumber;
  UserType type;
  String profilePicture;
  String backgroundPicture;
  List<ManagedPlace> managedPlaces;
  List<Place> favoritePlaces;

  User(
      {this.type,
      @required this.id,
      this.firstName,
      this.name,
      @required this.email,
      this.profilePicture,
      this.backgroundPicture,
      this.phoneNumber,
      this.managedPlaces,
      this.favoritePlaces});

  factory User.fromJson(Map<String, dynamic> json) {
    UserType type = UserTypeHelper.getValue(json["__typename"]);
    List<ManagedPlace> managedPlaces = (json['managedPlaces'] as List<dynamic>)
        ?.map((repoJson) => ManagedPlace.fromJson(repoJson))
        ?.toList();
    List<Place> favoritePlaces = (json['favoritePlaces'] as List<dynamic>)
        ?.map((repoJson) => Place.fromJson(repoJson))
        ?.toList();

    return User(
        type: type,
        id: json["id"],
        firstName: json["firstName"],
        name: json["name"],
        email: json["email"],
        //profilePicture: json["profilePicture"],
        //backgroundPicture: json["backgroundPicture"],
        phoneNumber: json["phoneNumber"],
        managedPlaces: managedPlaces,
        favoritePlaces: favoritePlaces);
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "name": name,
        "email": email,
        "phoneNumber": phoneNumber
      };
}
