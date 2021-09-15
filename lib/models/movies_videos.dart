// To parse this JSON data, do
//
//     final moviesVideos = moviesVideosFromJson(jsonString);

import 'dart:convert';

MoviesVideos moviesVideosFromJson(String str) =>
    MoviesVideos.fromJson(json.decode(str));

String moviesVideosToJson(MoviesVideos data) => json.encode(data.toJson());

class MoviesVideos {
  MoviesVideos({
    this.id,
    this.results,
  });

  int? id;
  List<Result>? results;

  factory MoviesVideos.fromJson(Map<String, dynamic> json) => MoviesVideos(
        id: json["id"] == null ? null : json["id"],
        results: json["results"] == null
            ? null
            : List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "results": results == null
            ? null
            : List<dynamic>.from(results!.map((x) => x.toJson())),
      };
}

class Result {
  Result({
    this.iso6391,
    this.iso31661,
    this.name,
    this.key,
    this.site,
    this.size,
    this.type,
    this.official,
    this.publishedAt,
    this.id,
  });

  Iso6391? iso6391;
  Iso31661? iso31661;
  String? name;
  String? key;
  Site? site;
  int? size;
  String? type;
  bool? official;
  DateTime? publishedAt;
  String? id;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        iso6391: json["iso_639_1"] == null
            ? null
            : iso6391Values.map![json["iso_639_1"]],
        iso31661: json["iso_3166_1"] == null
            ? null
            : iso31661Values.map![json["iso_3166_1"]],
        name: json["name"] == null ? null : json["name"],
        key: json["key"] == null ? null : json["key"],
        site: json["site"] == null ? null : siteValues.map![json["site"]],
        size: json["size"] == null ? null : json["size"],
        type: json["type"] == null ? null : json["type"],
        official: json["official"] == null ? null : json["official"],
        publishedAt: json["published_at"] == null
            ? null
            : DateTime.parse(json["published_at"]),
        id: json["id"] == null ? null : json["id"],
      );

  Map<String, dynamic> toJson() => {
        "iso_639_1": iso6391 == null ? null : iso6391Values.reverse![iso6391],
        "iso_3166_1":
            iso31661 == null ? null : iso31661Values.reverse![iso31661],
        "name": name == null ? null : name,
        "key": key == null ? null : key,
        "site": site == null ? null : siteValues.reverse![site],
        "size": size == null ? null : size,
        "type": type == null ? null : type,
        "official": official == null ? null : official,
        "published_at":
            publishedAt == null ? null : publishedAt!.toIso8601String(),
        "id": id == null ? null : id,
      };
}

enum Iso31661 { US }

final iso31661Values = EnumValues({"US": Iso31661.US});

enum Iso6391 { EN }

final iso6391Values = EnumValues({"en": Iso6391.EN});

enum Site { YOU_TUBE }

final siteValues = EnumValues({"YouTube": Site.YOU_TUBE});

class EnumValues<T> {
  Map<String, T>? map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String>? get reverse {
    if (reverseMap == null) {
      reverseMap = map!.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
