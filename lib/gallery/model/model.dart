import 'dart:convert';

class PhotoModel {
  final String photographer;
  final String photographer_url;
  final Src src;
  PhotoModel({
    required this.photographer,
    required this.photographer_url,
    required this.src,
  });

  PhotoModel copyWith({
    String? photographer,
    String? photographer_url,
    Src? src,
  }) {
    return PhotoModel(
      photographer: photographer ?? this.photographer,
      photographer_url: photographer_url ?? this.photographer_url,
      src: src ?? this.src,
    );
  }

  factory PhotoModel.fromMap(Map<String, dynamic> map) {
    return PhotoModel(
      photographer: map['photographer'] ?? '',
      photographer_url: map['photographer_url'] ?? '',
      src: Src.fromMap(map['src']),
    );
  }
  factory PhotoModel.fromJson(String source) =>
      PhotoModel.fromMap(json.decode(source));
}

class Src {
  final String original;
  final String large2x;
  final String large;
  final String small;
  final String portrait;
  final String landscape;
  Src({
    required this.original,
    required this.large2x,
    required this.large,
    required this.small,
    required this.portrait,
    required this.landscape,
  });
  factory Src.fromMap(Map<String, dynamic> map) {
    return Src(
      original: map['original'] ?? '',
      large2x: map['large2x'] ?? '',
      large: map['large'] ?? '',
      small: map['small'] ?? '',
      portrait: map['portrait'] ?? '',
      landscape: map['landscape'] ?? '',
    );
  }
  factory Src.fromJson(String source) => Src.fromMap(json.decode(source));
}

List<PhotoModel> images = [];
List<PhotoModel> sImages = [];
