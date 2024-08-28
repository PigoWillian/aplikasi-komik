import 'dart:convert';
import 'package:app_komik_manga/Api/fetch_manga_chapter.dart';
import 'package:app_komik_manga/models/chapter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../Api/fetch_manga_detail.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Home> {
  List<dynamic> manga = [];
  List<String> imageUrls = [];
  List<String> mangaIds = [];
  bool _isLoading = true; // Added to handle loading state

  @override
  void initState() {
    super.initState();
    fetchImageUrls();
    fetchManga();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Color.alphaBlend(
            Color.fromARGB(221, 16, 59, 115), Colors.deepPurpleAccent),
        title: const Text(
          "MANGA",
          textAlign: TextAlign.justify,
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  if (imageUrls.isNotEmpty && mangaIds.isNotEmpty)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 20, top: 20),
                          child: Text(
                            "Top View",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        CarouselSlider(
                          items: imageUrls.asMap().entries.map((entry) {
                            int index = entry.key;
                            String url = entry.value;
                            return GestureDetector(
                              onTap: () async {
                                final mangaId = mangaIds[index];
                                print(
                                    'Fetching details for manga ID: $mangaId');

                                // Fetch manga details
                                final mangaDetail =
                                    await fetchMangaDetail(mangaId);

                                if (mounted) {
                                  if (mangaDetail != null) {
                                    Navigator.pushNamed(
                                      context,
                                      'mangaDetail',
                                      arguments: {
                                        'mangaDetail': mangaDetail,
                                        'mangaId':
                                            mangaId, // Pass mangaId as well
                                      },
                                    );
                                  } else {
                                    print(
                                        'Failed to fetch manga details for ID: $mangaId');
                                  }
                                }
                              },
                              child: Image.network(
                                url,
                                fit: BoxFit.cover,
                              ),
                            );
                          }).toList(),
                          options: CarouselOptions(
                            enableInfiniteScroll: false,
                            viewportFraction: 0.4,
                            initialPage: 0,
                            height: MediaQuery.of(context).size.height / 4,
                            enlargeCenterPage: true,
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                margin: EdgeInsets.only(top: 20),
                                color: Color.alphaBlend(
                                    Color.fromARGB(221, 16, 59, 115),
                                    Colors.deepPurpleAccent),
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    'Updated',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                margin: EdgeInsets.only(top: 20),
                                color: Colors.blueGrey,
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(''),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    padding: const EdgeInsets.all(4.0),
                    mainAxisSpacing: 1.0,
                    crossAxisSpacing: 1.0,
                    children: manga.map((mangaItem) {
                      final title = mangaItem['title'];
                      final imageUrl = mangaItem['image'];
                      final chapterId = mangaItem['chapter'];

                      return GestureDetector(
                        onTap: () async {
                          final mangaId = mangaItem['id'] ?? '';
                          print('mangaId before fetching details: $mangaId');

                          if (mangaId.isNotEmpty) {
                            print(
                                'Fetching initial chapter content for mangaId: $mangaId');
                            final ContentChapter? initialChapterContent =
                                await fetchChapterContent(mangaId, 'chapter-1');

                            if (mounted) {
                              if (initialChapterContent != null &&
                                  initialChapterContent
                                      .chapterListIds.isNotEmpty) {
                                print(
                                    'Fetched initial chapter content successfully.');
                                final String? id = initialChapterContent
                                    .chapterListIds.first.id;

                                if (id != null && id.isNotEmpty) {
                                  print(
                                      'Fetching chapter content with valid id: $id');
                                  final chapterContentWithId =
                                      await fetchChapterContent(mangaId, id);

                                  if (mounted) {
                                    if (chapterContentWithId != null) {
                                      Navigator.pushNamed(
                                        context,
                                        'mangaChapter',
                                        arguments: {
                                          'mangaId': mangaId,
                                          'id': id,
                                        },
                                      );
                                    } else {
                                      print(
                                          'Failed to fetch chapter content for mangaId: $mangaId, Chapter ID: $id');
                                    }
                                  }
                                } else {
                                  print(
                                      'Invalid id retrieved from initial chapter content');
                                }
                              } else {
                                print(
                                    'Initial chapter content is null or has an empty chapterListIds');
                              }
                            }
                          } else {
                            print('Invalid mangaId, skipping this item');
                          }
                        },
                        child: Card(
                          elevation: 12,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    color: Color.fromARGB(190, 14, 8, 8),
                                    padding: EdgeInsets.all(8),
                                    margin: EdgeInsets.only(bottom: 30),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            title,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    color: Color.fromARGB(190, 14, 8, 8),
                                    padding: EdgeInsets.all(8),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            chapterId,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> fetchManga() async {
    try {
      const url = "http://getdata.mangapi-go.site/api/mangaList?page=4";
      final uri = Uri.parse(url);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (mounted) {
          setState(() {
            manga = json['mangaList'];
            mangaIds = manga
                .map<String>((item) => item['id'])
                .toList(); // Store manga IDs
            _isLoading = false; // Set loading to false
          });
        }
        print('fetchManga Completed');
      } else {
        print('Error fetching manga data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching manga data: $e');
    }
  }

  Future<void> fetchImageUrls() async {
    try {
      final response = await http.get(Uri.parse(
          'http://getdata.mangapi-go.site/api/mangaList?category=Action'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (mounted) {
          setState(() {
            imageUrls = (data['mangaList'] as List)
                .map((item) => item['image'] as String)
                .toList();
            mangaIds = (data['mangaList'] as List)
                .map((item) => item['id'] as String)
                .toList(); // Store manga IDs associated with images
            _isLoading = false; // Set loading to false
          });
        }
      } else {
        throw Exception('Failed to load images');
      }
    } catch (e) {
      print('Error fetching image URLs: $e');
    }
  }
}
