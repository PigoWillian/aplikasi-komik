import 'dart:convert';
import 'package:app_komik_manga/models/manga_detail.dart';
import 'package:http/http.dart' as http;

Future<MangaDetail> getMangaDetail(String mangaId) async {
  final response = await http
      .get(Uri.parse("http://getdata.mangapi-go.site/api/detail/$mangaId"));

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    return MangaDetail.fromJson(jsonResponse);
  } else {
    throw Exception('Failed to load manga detail');
  }
}

class MangaSearch {
  final String id;
  final String imageUrl;
  final String name;

  const MangaSearch({
    required this.id,
    required this.imageUrl,
    required this.name,
  });

  factory MangaSearch.fromJson(Map<String, dynamic> json) {
    return MangaSearch(
      id: json['id'] ?? '',
      imageUrl: json['image'] ?? '',
      name: json['title'] ?? '',
    );
  }

  @override
  String toString() {
    return 'MangaSearch(id: $id, name: $name, imageUrl: $imageUrl)';
  }
}
