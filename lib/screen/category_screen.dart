import 'dart:convert';
import 'package:app_komik_manga/Api/fetch_manga_detail.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  // List of categories or text items
  final List<String> categories = [
    'All',
    'Action',
    'Adventure',
    'Comedy',
    'Cooking',
    'Doujinshi',
    'Drama',
    'Romance',
    'Horror',
    'Fantasy',
    'Shounen',
    'Isekai',
  ];

  // The currently selected category
  String selectedCategory = 'All';

  // Data to be displayed in the GridView
  List<dynamic> items = [];

  List<String> mangaIds = [];

  @override
  void initState() {
    super.initState();
    // Load data for the initial category
    fetchItems(selectedCategory);
  }

  void fetchItems(String category) async {
    setState(() {
      // Simulate a loading state
      items = [];
    });

    try {
      // Replace with your API endpoint
      final url = 'http://10.0.2.2:3000/api/mangaList?category=$category';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          items = data['mangaList'];
        });
      } else {
        print('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Color.alphaBlend(
            Color.fromARGB(221, 16, 59, 115), Colors.deepPurpleAccent),
        title: const Text('Category'),
      ),
      body: Column(
        children: [
          // Categories grid
          Container(
            color: Colors.transparent,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 2,
              children: categories.map((category) {
                return GestureDetector(
                  onTap: () {
                    if (selectedCategory != category) {
                      setState(() {
                        selectedCategory = category;
                        fetchItems(
                            category); // Fetch items for the selected category
                      });
                    }
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    decoration: BoxDecoration(
                      color: selectedCategory == category
                          ? Colors.blue
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        category,
                        style: TextStyle(
                          color: selectedCategory == category
                              ? Colors.white
                              : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          // GridView to display items
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.8,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final title = item['title'];
                final imageUrl = item['image'];
                final view = item['view'];
                return GestureDetector(
                  onTap: () async {
                    final mangaId = item['id'];
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
                      print('Failed to fetch manga details for ID: $mangaId');
                    }
                  },
                  child: Card(
                    elevation: 5,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            color: Colors.black54,
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  view,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
