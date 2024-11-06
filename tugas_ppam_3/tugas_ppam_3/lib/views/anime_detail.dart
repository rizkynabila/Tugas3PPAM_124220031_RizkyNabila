import 'package:flutter/material.dart';
import 'package:tugas_ppam_3/presenters/anime_detail_presenter.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.id, required this.endpoint});

  final int id;
  final String endpoint;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen>
    implements AnimeDetailView {
  late AnimeDetailPresenter _presenter;
  bool _isLoading = true;
  Map<String, dynamic>? _detailData;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _presenter = AnimeDetailPresenter(this);
    _presenter.loadDetailData(widget.endpoint, widget.id);
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
  void showDetailData(Map<String, dynamic> detailData) {
    setState(() {
      _detailData = detailData;
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
        title: const Text("Detail"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text("Error: $_errorMessage"))
              : _detailData != null
                  ? SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Image.network(
                            _detailData!['images'][0] ??
                                'https://placehold.co/600x400',
                            width: double.infinity,
                            height: 250,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              "Name : ${_detailData!['name']}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              "Kekkei Genkai : ${_detailData!['personal']['kekkeiGenkai'] ?? 'Empty'}",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              "Title : ${_detailData!['personal']['titles']}",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const Center(child: Text("Tidak ada data!")),
    );
  }
}
