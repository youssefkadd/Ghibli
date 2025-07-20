class Movie {
  String? id,
      title,
      originalTitle,
      originalTitleRomanised,
      image,
      movieBanner,
      description,
      director,
      producer,
      releaseDate,
      runningTime,
      rtScore;

  Movie({
    required this.id,
    required this.title,
    required this.originalTitle,
    required this.originalTitleRomanised,
    required this.image,
    required this.movieBanner,
    required this.description,
    required this.director,
    required this.producer,
    required this.releaseDate,
    required this.runningTime,
    required this.rtScore,
  });

  factory Movie.fromJSON(Map<String, dynamic> data) {
    return Movie(
      id: data['id'],
      title: data['title'],
      originalTitle: data['original_title'],
      originalTitleRomanised: data['original_title_romanised'],
      image: data['image'],
      movieBanner: data['movie_banner'],
      description: data['description'],
      director: data['director'],
      producer: data['producer'],
      releaseDate: data['release_date'],
      runningTime: data['running_time'],
      rtScore: data['rt_score'],
    );
  }
}
