import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:just_audio/just_audio.dart';
import 'package:t4/data/song_list.dart';
import 'package:t4/data/playlist_list.dart';
import 'package:t4/presentation/screen/home_screen.dart';
import 'now_playing_screen.dart';
import 'search_screen.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  late List<Song> favoriteSongs;
  final Map<String, Duration> _durations = {};
  int _selectedIndex = 2;

  // Phân trang
  int _currentPage = 0;
  final int _songsPerPage = 10;

  @override
  void initState() {
    super.initState();
    favoriteSongs = songList.where((s) => s.isFavorite).toList();
    _loadDurations();
    _updateFavoritePlaylist();
  }

  Future<void> _loadDurations() async {
    for (var song in favoriteSongs) {
      if (!_durations.containsKey(song.assetPath)) {
        final player = AudioPlayer();
        try {
          await player.setAsset(song.assetPath);
          final duration = player.duration;
          if (duration != null) {
            setState(() {
              _durations[song.assetPath] = duration;
            });
          }
        } catch (e) {
          print("Lỗi khi load duration: $e");
        } finally {
          player.dispose();
        }
      }
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(duration.inMinutes)}:${twoDigits(duration.inSeconds % 60)}";
  }

  void _updateFavoritePlaylist() {
    List<int> favoriteSongIds = favoriteSongs.map((song) => song.id).toList();
    
    for (int i = 0; i < globalPlaylistList.length; i++) {
      if (globalPlaylistList[i].id == 'playlist_my_favorites') {
        globalPlaylistList[i] = Playlist(
          id: 'playlist_my_favorites',
          name: 'Yêu thích của tôi',
          coverImage: 'assets/images/favorite_playlist.jpg',
          songIds: favoriteSongIds,
          isSystem: true,
        );
        break;
      }
    }
  }

  void _toggleFavorite(Song song) {
    setState(() {
      song.isFavorite = false;
      favoriteSongs = songList.where((s) => s.isFavorite).toList();
      _updateFavoritePlaylist();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã xoá khỏi yêu thích')),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SearchScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tính toán số lượng trang và danh sách bài hát cho trang hiện tại
    int totalPages = (favoriteSongs.length / _songsPerPage).ceil();
    int startIndex = _currentPage * _songsPerPage;
    int endIndex = (_currentPage + 1) * _songsPerPage;
    if (endIndex > favoriteSongs.length) endIndex = favoriteSongs.length;

    List<Song> displayedSongs = favoriteSongs.isNotEmpty
        ? favoriteSongs.sublist(startIndex, endIndex)
        : [];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Spacer(),
                  Icon(Icons.more_vert),
                ],
              ),
              SizedBox(height: 10),
              Center(child: Icon(Icons.account_circle, size: 100)),
              SizedBox(height: 10),
              Center(
                child: Text(user?.email ?? '', style: TextStyle(fontSize: 16)),
              ),
              Center(
                child: Text(
                  user?.displayName ?? 'Không rõ tên',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Bài hát ưa thích',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  if (favoriteSongs.isNotEmpty)
                    Text(
                      'Tổng: ${favoriteSongs.length} bài hát',
                      style: TextStyle(color: Colors.grey),
                    ),
                ],
              ),
              SizedBox(height: 15),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: favoriteSongs.isEmpty
                          ? Center(child: Text('Không có bài hát yêu thích.'))
                          : ListView.builder(
                              itemCount: displayedSongs.length,
                              itemBuilder: (context, index) {
                                final song = displayedSongs[index];
                                final duration = _durations[song.assetPath];
                                return ListTile(
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(song.coverImage,
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover),
                                  ),
                                  title: Text(song.title,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  subtitle: Text(song.artist),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        duration != null
                                            ? _formatDuration(duration)
                                            : "--:--",
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.favorite_border),
                                        iconSize: 24,
                                        onPressed: () => _toggleFavorite(song),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => NowPlayingScreen(
                                          song: song,
                                          songList: favoriteSongs,
                                          initialIndex: startIndex + index,
                                        ),
                                      ),
                                    );
                                  },
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: ''),
        ],
      ),
    );
  }
}
