import 'json_value.dart';

class MovieSummary {
  final String title;
  final String cover;
  final String rating;
  final String releaseDate;

  const MovieSummary({
    required this.title,
    required this.cover,
    this.rating = '',
    this.releaseDate = '',
  });

  factory MovieSummary.fromJson(Map<String, dynamic> json) => MovieSummary(
        title: jsonString(json['title']),
        cover: jsonString(json['cover']),
        rating: jsonString(json['rate']),
        releaseDate: jsonString(json['release_date']),
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'cover': cover,
        'rate': rating,
        'release_date': releaseDate,
      };
}
