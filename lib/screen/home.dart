import 'dart:convert';

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
  List<String> mangaIds = []; // List to store manga IDs associated with images
  // int _currentScreenIndex = 0;

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
      body: manga.isEmpty
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
                            "Recomendation",
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
                                final mangaDetail =
                                    await fetchMangaDetail(mangaId);
                                if (mangaDetail != null) {
                                  Navigator.pushNamed(
                                    context,
                                    'mangaDetail',
                                    arguments: mangaDetail,
                                  );
                                } else {
                                  // Handle error
                                  print(
                                      'Failed to fetch manga details for ID: $mangaId');
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
                            viewportFraction:
                                0.4, // Adjust to control the item width and spacing
                            initialPage: 0,
                            height: MediaQuery.of(context).size.height / 4,
                            enlargeCenterPage:
                                true, // Optional: enlarges the center item for emphasis
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
                      final chapter = mangaItem['chapter'];
                      return GestureDetector(
                        onTap: () async {
                          final mangaId = mangaItem['id'];
                          print('Fetching details for manga ID: $mangaId');
                          final mangaDetail = await fetchMangaDetail(mangaId);
                          if (mangaDetail != null) {
                            Navigator.pushNamed(
                              context,
                              'mangaDetail',
                              arguments: mangaDetail,
                            );
                          } else {
                            // Handle error
                            print(
                                'Failed to fetch manga details for ID: $mangaId');
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
                                            chapter,
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
      // bottomNavigationBar: BottomNavigationBar(
      //   backgroundColor: Theme.of(context).dialogBackgroundColor,
      //   currentIndex: _currentScreenIndex,
      //   onTap: (index) {
      //     setState(() {
      //       _currentScreenIndex = index;
      //     });
      //     if (index == 1) {
      //       Navigator.pushNamed(context, 'search');
      //     } else if (index == 2) {
      //       Navigator.pushNamed(context, 'Genres');
      //     } else if (index == 3) {
      //       Navigator.pushNamed(context, 'Settings');
      //     }
      //   },
      //   items: const [
      //     BottomNavigationBarItem(
      //       backgroundColor: Colors.black,
      //       icon: Icon(
      //         Icons.home,
      //         color: Colors.grey,
      //       ),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       backgroundColor: Colors.black,
      //       icon: Icon(Icons.search, color: Colors.grey),
      //       label: 'Search',
      //     ),
      //     BottomNavigationBarItem(
      //       backgroundColor: Colors.black,
      //       icon: Icon(Icons.category, color: Colors.grey),
      //       label: 'Genres',
      //     ),
      //     BottomNavigationBarItem(
      //       backgroundColor: Colors.black,
      //       icon: Icon(
      //         Icons.settings,
      //         color: Colors.grey,
      //       ),
      //       label: 'Settings',
      //     ),
      //   ],
      // ),
    );
  }

  void fetchManga() async {
    try {
      const url = "http://10.0.2.2:3000/api/mangaList?page=3";
      final uri = Uri.parse(url);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        setState(() {
          manga = json['mangaList'];
          mangaIds = manga
              .map<String>((item) => item['id'])
              .toList(); // Store manga IDs
        });
        print('fetchManga Completed');
      } else {
        print('Error fetching manga data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching manga data: $e');
    }
  }

  Future<void> fetchImageUrls() async {
    final response = await http
        .get(Uri.parse('http://10.0.2.2:3000/api/mangaList?category=Action'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        imageUrls = (data['mangaList'] as List)
            .map((item) => item['image'] as String)
            .toList();
        mangaIds = (data['mangaList'] as List)
            .map((item) => item['id'] as String)
            .toList(); // Ensure mangaIds list is updated
      });
    } else {
      throw Exception('Failed to load images');
    }
  }
}
