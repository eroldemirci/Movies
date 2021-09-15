// To parse this JSON data, do
//
//     final moviesReviews = moviesReviewsFromJson(jsonString);

import 'dart:convert';

MoviesReviews moviesReviewsFromJson(String str) =>
    MoviesReviews.fromJson(json.decode(str));

String moviesReviewsToJson(MoviesReviews data) => json.encode(data.toJson());

class MoviesReviews {
  MoviesReviews({
    this.id,
    this.page,
    this.results,
    this.totalPages,
    this.totalResults,
  });

  int? id;
  int? page;
  List<Result>? results;
  int? totalPages;
  int? totalResults;

  factory MoviesReviews.fromJson(Map<String, dynamic> json) => MoviesReviews(
        id: json["id"] == null ? null : json["id"],
        page: json["page"] == null ? null : json["page"],
        results: json["results"] == null
            ? null
            : List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
        totalPages: json["total_pages"] == null ? null : json["total_pages"],
        totalResults:
            json["total_results"] == null ? null : json["total_results"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "page": page == null ? null : page,
        "results": results == null
            ? null
            : List<dynamic>.from(results!.map((x) => x.toJson())),
        "total_pages": totalPages == null ? null : totalPages,
        "total_results": totalResults == null ? null : totalResults,
      };
}

class Result {
  Result({
    this.author,
    this.authorDetails,
    this.content,
    this.createdAt,
    this.id,
    this.updatedAt,
    this.url,
  });

  String? author;
  AuthorDetails? authorDetails;
  String? content;
  DateTime? createdAt;
  String? id;
  DateTime? updatedAt;
  String? url;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        author: json["author"] == null ? null : json["author"],
        authorDetails: json["author_details"] == null
            ? null
            : AuthorDetails.fromJson(json["author_details"]),
        content: json["content"] == null ? null : json["content"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        id: json["id"] == null ? null : json["id"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        url: json["url"] == null ? null : json["url"],
      );

  Map<String, dynamic> toJson() => {
        "author": author == null ? null : author,
        "author_details":
            authorDetails == null ? null : authorDetails!.toJson(),
        "content": content == null ? null : content,
        "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
        "id": id == null ? null : id,
        "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
        "url": url == null ? null : url,
      };
}

class AuthorDetails {
  AuthorDetails({
    this.name,
    this.username,
    this.avatarPath,
    this.rating,
  });

  String? name;
  String? username;
  String? avatarPath;
  int? rating;

  factory AuthorDetails.fromJson(Map<String, dynamic> json) => AuthorDetails(
        name: json["name"] == null ? null : json["name"],
        username: json["username"] == null ? null : json["username"],
        avatarPath: json["avatar_path"] == null ? null : json["avatar_path"],
        rating: json["rating"] == null ? null : json["rating"],
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "username": username == null ? null : username,
        "avatar_path": avatarPath == null ? null : avatarPath,
        "rating": rating == null ? null : rating,
      };
}
