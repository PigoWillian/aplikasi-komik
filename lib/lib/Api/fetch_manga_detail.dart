import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_komik_manga/models/manga_detail.dart'; // Adjust import path as needed

Future<MangaDetail?> fetchMangaDetail(String mangaId) async {
  final url = 'http://getdata.mangapi-go.site/api/manga/$mangaId';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return MangaDetail.fromJson(data);
  } else {
    print('Error fetching manga detail: ${response.statusCode}');
    print(response.body);
    return null;
  }
}
