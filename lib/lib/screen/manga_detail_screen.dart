import 'package:flutter/material.dart';
import '../models/manga_detail.dart';
import 'manga_chapter_screen.dart'; // Import MangaChapterScreen

class MangaDetailScreen extends StatelessWidget {
  final MangaDetail mangaDetail;
  final String mangaId;

  const MangaDetailScreen({
    Key? key,
    required this.mangaDetail,
    required this.mangaId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(mangaDetail.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 85),
              child: Image.network(mangaDetail.imageUrl),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                mangaDetail.name,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Author: ${mangaDetail.author}',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Status: ${mangaDetail.status}',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Updated: ${mangaDetail.updated}',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Views: ${mangaDetail.view}',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Genres: ${mangaDetail.genres.join(', ')}',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ...mangaDetail.chapterList.map((chapter) {
              return ListTile(
                title: Text(
                  chapter.name,
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  'Views: ${chapter.view}',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  print(
                      'Navigating to chapter with mangaId: $mangaId and chapterId: ${chapter.id}');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MangaChapterScreen(
                        mangaId: mangaId,
                        id: chapter.id,
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
