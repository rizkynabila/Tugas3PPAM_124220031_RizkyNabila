import 'package:flutter/material.dart';
import 'package:tugas_ppam_3/models/anime_model.dart';
import 'package:tugas_ppam_3/presenters/anime_presenter.dart';
import 'package:tugas_ppam_3/views/anime_detail.dart';

class AnimeListScreen extends StatefulWidget {
  const AnimeListScreen({super.key});

  @override
  State<AnimeListScreen> createState() => _AnimeListScreenState();
}

class _AnimeListScreenState extends State<AnimeListScreen>
    implements AnimeView {
  late AnimePresenter _presenter;
  bool _isLoading = false;
  List<Anime> _animeList = [];
  String? _errorMessage;
  String _currentEndpoint = 'akatsuki';
  List<bool> isSelected = [true, false];

  @override
  void initState() {
    super.initState();
    _presenter = AnimePresenter(this);
    _presenter.loadAnimedata(_currentEndpoint);
  }

  void _fetchData(String endpoint, int index) {
    setState(() {
      _currentEndpoint = endpoint;
      isSelected = [index == 0, index == 1];
      _presenter.loadAnimedata(endpoint);
    });
  }

  @override
  void showLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  @override
  void hideLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void showAnimeList(List<Anime> animeList) {
    setState(() {
      _animeList = animeList;
    });
  }

  @override
  void showError(String message) {
    setState(() {
      _errorMessage = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Anime List"),
      ),
      body: Column(
        children: [
          Center(
            child: ToggleButtons(
              borderColor: Colors.blueAccent,
              fillColor: Colors.blueAccent.withOpacity(0.2),
              borderWidth: 1,
              selectedBorderColor: Colors.blueAccent,
              selectedColor: Colors.blueAccent,
              borderRadius: BorderRadius.circular(30),
              isSelected: isSelected,
              onPressed: (int index) {
                if (index == 0) {
                  _fetchData('akatsuki', index);
                } else if (index == 1) {
                  _fetchData('kara', index);
                }
              },
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  alignment: Alignment.center,
                  child: const Text(
                    "Akatsuki",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  alignment: Alignment.center,
                  child: const Text(
                    "Kara",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                    ? Center(child: Text("Error : $_errorMessage"))
                    : ListView.builder(
                        itemCount: _animeList.length,
                        itemBuilder: (context, index) {
                          final anime = _animeList[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            elevation: 4,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailScreen(
                                        id: anime.id,
                                        endpoint: _currentEndpoint),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    anime.imageUrl.isNotEmpty
                                        ? Image.network(
                                            anime.imageUrl,
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.network(
                                            'https://placehold.co/600x400',
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.cover,
                                          ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            anime.name,
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 8),
                                          Text('Family ${anime.familyCreator}'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          )
        ],
      ),
    );
  }
}
