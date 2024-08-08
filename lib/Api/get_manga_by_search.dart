import 'dart:convert';
import 'package:app_komik_manga/models/manga_search.dart';
import 'package:http/http.dart' as http;

Future<List<MangaSearch>> getMangaBySearch({required String query}) async {
  final response =
      await http.get(Uri.parse("http://10.0.2.2:3000/api/search/$query"));

  if (response.statusCode == 200) {
    final List<dynamic> jsonResponse = json.decode(response.body)['mangaList'];
    return jsonResponse.map((json) => MangaSearch.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load manga');
  }
}
