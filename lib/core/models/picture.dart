class Picture {
  String url;
  String publicId;

  Picture({this.url, this.publicId});

  factory Picture.fromJson(Map<String, dynamic> json) {
    return Picture(url: json['url'], publicId: json['publicId']);
  }
}
