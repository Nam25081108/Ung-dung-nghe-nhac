import 'package:flutter/material.dart';
import 'package:t4/data/song_list.dart';
import 'package:t4/presentation/screen/now_playing_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Song> _filteredSongs = [];
  List<String> _searchHistory = [];
  static const String _searchHistoryKey = 'search_history';

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
  }

  Future<void> _loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _searchHistory = prefs.getStringList(_searchHistoryKey) ?? [];
    });
  }

  Future<void> _saveSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_searchHistoryKey, _searchHistory);
  }

  void _addToSearchHistory(String query) {
    if (query.isEmpty) return;

    setState(() {
      _searchHistory.remove(query); // Xóa nếu đã tồn tại
      _searchHistory.insert(0, query); // Thêm vào đầu danh sách
      if (_searchHistory.length > 10) {
        // Giới hạn 10 lịch sử tìm kiếm
        _searchHistory.removeLast();
      }
    });
    _saveSearchHistory();
  }

  void _removeFromHistory(String query) {
    setState(() {
      _searchHistory.remove(query);
    });
    _saveSearchHistory();
  }

  void _filterSongs(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredSongs = [];
      });
      return;
    }

    _addToSearchHistory(query);

    final results = songList.where((song) {
      final lowerQuery = query.toLowerCase();
      return song.title.toLowerCase().contains(lowerQuery) ||
          song.artist.toLowerCase().contains(lowerQuery);
    }).toList();

    setState(() {
      _filteredSongs = results;
    });
  }

  void _onSongTapped(Song song, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NowPlayingScreen(
          song: song,
          songList: _filteredSongs,
          initialIndex: index,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: const Color.fromARGB(255, 0, 0, 0), width: 2),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back_ios_new, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        onChanged: _filterSongs,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Bạn muốn nghe gì?',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (_controller.text.isEmpty) ...[
                const Text(
                  'Lịch sử tìm kiếm',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: _searchHistory.isEmpty
                      ? const Center(
                          child: Text('Chưa có lịch sử tìm kiếm'),
                        )
                      : ListView.builder(
                          itemCount: _searchHistory.length,
                          itemBuilder: (context, index) {
                            final query = _searchHistory[index];
                            return ListTile(
                              leading: const Icon(Icons.history),
                              title: Text(query),
                              trailing: IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () => _removeFromHistory(query),
                              ),
                              onTap: () {
                                _controller.text = query;
                                _filterSongs(query);
                              },
                            );
                          },
                        ),
                ),
              ] else if (_filteredSongs.isNotEmpty) ...[
                Expanded(
                  child: ListView.builder(
                    itemCount: _filteredSongs.length,
                    itemBuilder: (context, index) {
                      final song = _filteredSongs[index];
                      return ListTile(
                        leading: Image.asset(
                          song.coverImage,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(
                          song.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(song.artist),
                        onTap: () => _onSongTapped(song, index),
                      );
                    },
                  ),
                ),
              ] else ...[
                const Expanded(
                  child: Center(
                    child: Text('Không tìm thấy bài hát nào'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
