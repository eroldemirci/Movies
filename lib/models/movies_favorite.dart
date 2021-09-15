class MoviesFavorite {
  final int? id;
  final int movieId;
  final String title;
  final String imagePath;
  final double voteAverage;
  final DateTime time;
  MoviesFavorite({
    this.id,
    required this.movieId,
    required this.title,
    required this.time,
    required this.imagePath,
    required this.voteAverage,
  });
  MoviesFavorite copy({
    int? id,
    int? movieId,
    String? title,
    String? imagePath,
    double? voteAverage,
    DateTime? time,
  }) =>
      MoviesFavorite(
          id: id ?? this.id,
          movieId: movieId ?? this.movieId,
          title: title ?? this.title,
          imagePath: imagePath ?? this.imagePath,
          voteAverage: voteAverage ?? this.voteAverage,
          time: time ?? this.time);

  static MoviesFavorite fromJson(Map<String, Object?> json) => MoviesFavorite(
        id: json['id'] as int?,
        movieId: json['movie_id'] as int,
        title: json['title'] as String,
        imagePath: json['poster_path'] as String,
        voteAverage: json['vote_average'] as double,
        time: DateTime.parse(json['time'] as String),
      );

  Map<String, Object?> toJson() => {
        'id': id,
        'movie_id': movieId,
        'title': title,
        'poster_path': imagePath,
        'vote_average': voteAverage,
        'time': time.toIso8601String()
      };
}
