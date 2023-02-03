import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Tag {
  final String group;
  final List<String> tags;

  Tag({this.group, this.tags});

  factory Tag.fromJson(Map<String, dynamic> json) =>
      new Tag(group: json["group"], tags: new List<String>.from(json["tags"]));

  Map<String, dynamic> toJson() => {"group": group, "tags": tags};
}
