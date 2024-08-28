import 'dart:convert';
import 'package:app_komik_manga/models/chapter.dart';
import 'package:http/http.dart' as http;

Future<ContentChapter?> fetchChapterContent(String mangaId, String id) async {
  void debugPrintIds(String mangaId, String chapterId) {
    if (mangaId.isEmpty || chapterId.isEmpty) {
      print(
          'Error: mangaId or chapterId is empty. mangaId = "$mangaId", chapterId = "$chapterId"');
    } else {
      print(
          'Valid mangaId and chapterId: mangaId = $mangaId, chapterId = $chapterId');
    }
  }

  final url = 'http://getdata.mangapi-go.site/api/manga/$mangaId/$id';
  print('Fetching details from URL: $url');

  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('Fetched chapter content successfully: ${data.toString()}');

      // Validasi struktur data JSON
      if (data is Map<String, dynamic> &&
          data['chapterListIds'] is List &&
          data['images'] is List) {
        return ContentChapter.fromJson(data);
      } else {
        print('Invalid data structure in API response.');
      }
    } else {
      print('Error fetching chapter content: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching chapter content: $e');
  }
  return null;
}
