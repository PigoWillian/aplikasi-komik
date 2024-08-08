import 'package:app_komik_manga/models/chapter.dart';

class MangaDetail {
  final String imageUrl;
  final String name;
  final String author;
  final String status;
  final String updated;
  final String view;
  final String description;
  final List<String> genres;
  final List<Chapter> chapterList;

  const MangaDetail({
    required this.imageUrl,
    required this.name,
    required this.author,
    required this.status,
    required this.updated,
    required this.view,
    required this.description,
    required this.genres,
    required this.chapterList,
    required id,
  });

  factory MangaDetail.fromJson(Map<String, dynamic> json) {
    List<String> genreList =
        json['genres'] != null ? List<String>.from(json['genres']) : [];
    List<Chapter> chapterList = json['chapterList'] != null
        ? (json['chapterList'] as List)
            .map((item) => Chapter.fromJson(item))
            .toList()
        : [];

    return MangaDetail(
      id: json['id'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      name: json['name'] ?? '',
      author: json['author'] ?? '',
      status: json['status'] ?? '',
      updated: json['updated'] ?? '',
      view: json['view'] ?? '',
      description: json['description'] ?? '',
      genres: genreList,
      chapterList: chapterList,
    );
  }
}
