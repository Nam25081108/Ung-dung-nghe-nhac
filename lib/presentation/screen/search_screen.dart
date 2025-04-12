import 'package:flutter/material.dart';
import 'package:t4/data/song_list.dart';
import 'package:t4/presentation/screen/now_playing_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _controller = TextEditingController();
  List<Song> _filteredSongs = songList;

  // Quản lý phân trang
  int _currentPage = 0;
  final int _songsPerPage = 10;

  void _filterSongs(String query) {
    final results = songList.where((song) {
      final lowerQuery = query.toLowerCase();
      return song.title.toLowerCase().contains(lowerQuery) ||
          song.artist.toLowerCase().contains(lowerQuery);
    }).toList();

    setState(() {
      _filteredSongs = results;
      _currentPage = 0; // Reset về trang đầu tiên khi tìm kiếm mới
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
    // Tính toán số lượng trang và danh sách bài hát cho trang hiện tại
    int totalPages = (_filteredSongs.length / _songsPerPage).ceil();
    int startIndex = _currentPage * _songsPerPage;
    int endIndex = (_currentPage + 1) * _songsPerPage;
    if (endIndex > _filteredSongs.length) endIndex = _filteredSongs.length;

    List<Song> displayedSongs = _filteredSongs.isNotEmpty
        ? _filteredSongs.sublist(startIndex, endIndex)
        : [];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thanh tìm kiếm có nút quay lại bên trong container bo tròn
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Kết quả tìm kiếm',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  if (_filteredSongs.isNotEmpty)
                    Text(
                      '${_filteredSongs.length} bài hát',
                      style: TextStyle(color: Colors.grey),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: _filteredSongs.isEmpty
                          ? const Center(
                              child: Text('Không tìm thấy bài hát nào.'))
                          : ListView.builder(
                              itemCount: displayedSongs.length,
                              itemBuilder: (context, index) {
                                final song = displayedSongs[index];
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
                                  onTap: () =>
                                      _onSongTapped(song, startIndex + index),
                                );
                              },
                            ),
                    ),

                    // Điều khiển phân trang
                    if (totalPages > 1)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back_ios),
                              onPressed: _currentPage > 0
                                  ? () {
                                      setState(() {
                                        _currentPage--;
                                      });
                                    }
                                  : null,
                            ),
                            Text(
                              'Trang ${_currentPage + 1}/$totalPages',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.arrow_forward_ios),
                              onPressed: _currentPage < totalPages - 1
                                  ? () {
                                      setState(() {
                                        _currentPage++;
                                      });
                                    }
                                  : null,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
