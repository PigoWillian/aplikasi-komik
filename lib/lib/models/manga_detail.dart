class MangaDetail {
  final String id; // Add this line
  final String imageUrl;
  final String name;
  final String author;
  final String status;
  final String updated;
  final String view;
  final List<String> genres;
  final List<Chapter> chapterList;

  MangaDetail({
    required this.id, // Add this line
    required this.imageUrl,
    required this.name,
    required this.author,
    required this.status,
    required this.updated,
    required this.view,
    required this.genres,
    required this.chapterList,
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
      id: json['id'] ?? '', // Ensure id is handled
      imageUrl: json['imageUrl'] ?? '',
      name: json['name'] ?? '',
      author: json['author'] ?? '',
      status: json['status'] ?? '',
      updated: json['updated'] ?? '',
      view: json['view'] ?? '',
      genres: genreList,
      chapterList: chapterList,
    );
  }
}

class Chapter {
  final String id;
  final String path;
  final String name;
  final String view;
  final String createdAt;

  const Chapter({
    required this.id,
    required this.path,
    required this.name,
    required this.view,
    required this.createdAt,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      id: json['id'] as String,
      path: json['path'] as String,
      name: json['name'] as String,
      view: json['view'] as String,
      createdAt: json['createdAt'] as String,
    );
  }
}
