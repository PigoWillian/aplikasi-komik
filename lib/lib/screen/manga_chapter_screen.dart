import 'package:flutter/material.dart';
import 'package:app_komik_manga/Api/fetch_manga_chapter.dart';
import 'package:app_komik_manga/models/chapter.dart';

class MangaChapterScreen extends StatelessWidget {
  final String mangaId;
  final String id;

  MangaChapterScreen({super.key, required this.mangaId, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        title: Text('Manga'),
      ),
      body: FutureBuilder<ContentChapter?>(
        future: fetchChapterContent(mangaId, id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No data found'));
          }

          final content = snapshot.data;
          if (content == null || content.images.isEmpty) {
            return Center(child: Text('No images available for this chapter.'));
          }

          final List<ImageData> images = content.images;

          return ListView.builder(
            itemCount: images.length,
            itemBuilder: (context, index) {
              final image = images[index];
              return Padding(
                padding: const EdgeInsets.symmetric(),
                child: Image.network(
                  image.image,
                  fit: BoxFit.cover,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
