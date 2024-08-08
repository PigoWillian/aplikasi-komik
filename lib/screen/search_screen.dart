import 'package:flutter/material.dart';
import 'package:app_komik_manga/Api/get_manga_by_search.dart';
import 'package:app_komik_manga/Api/fetch_manga_detail.dart'; // Ensure this import is correct
import 'package:app_komik_manga/models/manga_search.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<MangaSearch> _searchResults = [];
  bool _isLoading = false;

  void _performSearch() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final query = _searchController.text.trim();
      if (query.isNotEmpty) {
        final results = await getMangaBySearch(query: query);
        setState(() {
          _searchResults = results;
        });
      }
    } catch (e) {
      print('Error during search: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _showMangaDetail(MangaSearch mangaSearch) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final mangaDetail = await fetchMangaDetail(mangaSearch.id);
      if (mangaDetail != null) {
        Navigator.pushNamed(
          context,
          'mangaDetail',
          arguments: mangaDetail,
        );
      } else {
        // Handle the case where mangaDetail is null
        print('No details available for this manga');
      }
    } catch (e) {
      print('Error fetching manga detail: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Color.alphaBlend(
            Color.fromARGB(221, 16, 59, 115), Colors.deepPurpleAccent),
        title: TextField(
          controller: _searchController,
          style:
              const TextStyle(color: Colors.white), // Set text color to white
          decoration: const InputDecoration(
            labelStyle:
                TextStyle(color: Colors.white), // Set label text color to white
            hintText: 'Search...',
            hintStyle: TextStyle(
                color: Colors
                    .white70), // Set hint text color to white with some transparency
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.white), // Set the underline color to white
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color:
                      Colors.white), // Set the focused underline color to white
            ),
          ),
          onSubmitted: (value) => _performSearch(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _performSearch(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(),
            const SizedBox(height: 12),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                    child: GridView.builder(
                      itemCount: _searchResults.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                        childAspectRatio: 0.75,
                      ),
                      itemBuilder: (context, index) {
                        final manga = _searchResults[index];
                        return GestureDetector(
                          onTap: () => _showMangaDetail(manga),
                          child: GridTile(
                            footer: GridTileBar(
                              backgroundColor: Colors.black54,
                              title: Text(
                                manga.name,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            child: manga.imageUrl.isNotEmpty
                                ? Image.network(
                                    manga.imageUrl,
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(Icons.image_not_supported),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
