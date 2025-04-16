import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:t4/data/song_list.dart';
import 'package:t4/data/album_list.dart';
import 'package:t4/data/recently_played.dart';
import 'package:t4/presentation/screen/search_screen.dart';
import 'package:t4/presentation/screen/now_playing_screen.dart';
import 'package:t4/presentation/screen/album_detail_screen.dart';
import 'dart:math';
import 'package:t4/presentation/screen/ProfileScreen.dart';
import 'package:provider/provider.dart';
import 'package:t4/services/audio_player_handler.dart';
import 'package:t4/widgets/mini_player.dart';
import 'package:t4/models/song.dart';
import 'package:t4/models/album.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int _selectedTabIndex = 0;

  // Danh sách bài hát
  late List<Song> _recommendedSongs = [];
  late List<Song> _recentlyPlayedSongs = [];
  // Danh sách album
  late List<Album> _popularAlbums = [];
  late List<Song> _popularSongs = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  void _loadSongs() {
    // Tạo một danh sách riêng biệt từ songList để có thể xáo trộn
    List<Song> shuffledSongs = List.from(songList);
    // Xáo trộn danh sách
    shuffledSongs.shuffle(Random());

    // Lấy 6 bài hát đầu tiên sau khi xáo trộn cho phần đề xuất
    List<Song> randomSongs = shuffledSongs.take(6).toList();

    // Lấy 3 bài hát cho phần nổi tiếng
    List<Song> popularSongs = shuffledSongs.take(3).toList();

    // Lấy danh sách bài hát nghe gần đây
    final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
    List<Song> recentlyPlayed = [];
    if (currentUserId != null) {
      recentlyPlayed = getRecentlyPlayedSongs(currentUserId);
    }

    // Tạo danh sách album từ albumList
    List<Album> allAlbums = List.from(albumList);
    allAlbums.shuffle(Random());

    // Lấy 3 album làm album nổi tiếng
    List<Album> popularAlbums = allAlbums.take(3).toList();

    setState(() {
      _recommendedSongs = randomSongs;
      _recentlyPlayedSongs = recentlyPlayed;
      _popularAlbums = popularAlbums;
      _popularSongs = popularSongs;
      _isLoading = false;
    });
  }

  Future<void> _signOut() async {
    try {
      // Lưu trạng thái phát nhạc trước khi đăng xuất
      final audioHandler =
          Provider.of<AudioPlayerHandler>(context, listen: false);
      await audioHandler.savePlaybackState();
      await audioHandler.clearPlaybackState();

      // Đăng xuất
      await _auth.signOut();
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/login',
          (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi đăng xuất: ${e.toString()}')),
        );
      }
    }
  }

  void _onSongTapped(Song song, List<Song> songList, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NowPlayingScreen(
          song: song,
          songList: songList,
          initialIndex: index,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final audioHandler = Provider.of<AudioPlayerHandler>(context);
    final bool showMiniPlayer = audioHandler.currentSong != null;

    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Tooltip(
                            message: 'Đăng xuất',
                            child: GestureDetector(
                              onTap: _signOut,
                              child: const CircleAvatar(
                                backgroundColor: Color(0xFFE0E0E0),
                                child: Icon(Icons.logout, color: Colors.grey),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildTabButton('Tất Cả', 0),
                                const SizedBox(width: 8),
                                _buildTabButton('Album', 1),
                                const SizedBox(width: 8),
                                _buildTabButton('Danh sách phát', 2),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'Được Đề Xuất Cho Hôm Nay',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        height: 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _recommendedSongs.length,
                          itemBuilder: (context, index) {
                            final song = _recommendedSongs[index];
                            return Padding(
                              padding: EdgeInsets.only(
                                right: index != _recommendedSongs.length - 1
                                    ? 15
                                    : 0,
                              ),
                              child: GestureDetector(
                                onTap: () => _onSongTapped(
                                    song, _recommendedSongs, index),
                                child: _buildMusicItem(
                                  song.title,
                                  song.artist,
                                  song.coverImage,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 25),
                      const Text(
                        'Album Và Bài Hát Nổi Tiếng',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        height: 200,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            // Hiển thị 3 album
                            ...List.generate(_popularAlbums.length, (index) {
                              final album = _popularAlbums[index];
                              return Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AlbumDetailScreen(album: album),
                                      ),
                                    );
                                  },
                                  child: _buildAlbumItem(
                                    album.name,
                                    'Album',
                                    album.coverImage,
                                  ),
                                ),
                              );
                            }),
                            // Hiển thị 3 bài hát
                            ...List.generate(_popularSongs.length, (index) {
                              final song = _popularSongs[index];
                              return Padding(
                                padding: EdgeInsets.only(
                                  right: index != _popularSongs.length - 1
                                      ? 15
                                      : 0,
                                ),
                                child: GestureDetector(
                                  onTap: () =>
                                      _onSongTapped(song, _popularSongs, index),
                                  child: _buildMusicItem(
                                    song.title,
                                    song.artist,
                                    song.coverImage,
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      if (_recentlyPlayedSongs.isNotEmpty) ...[
                        const Text(
                          'Nghe Gần Đây',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          height: 200,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _recentlyPlayedSongs.length,
                            itemBuilder: (context, index) {
                              final song = _recentlyPlayedSongs[index];
                              return Padding(
                                padding: EdgeInsets.only(
                                  right:
                                      index != _recentlyPlayedSongs.length - 1
                                          ? 15
                                          : 0,
                                ),
                                child: GestureDetector(
                                  onTap: () => _onSongTapped(
                                      song, _recentlyPlayedSongs, index),
                                  child: _buildMusicItem(
                                    song.title,
                                    song.artist,
                                    song.coverImage,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Mini Player khi có bài hát đang phát
          if (showMiniPlayer)
            GestureDetector(
              onTap: () {
                if (audioHandler.currentSong != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NowPlayingScreen(
                        song: audioHandler.currentSong!,
                        songList: audioHandler.currentSongList,
                        initialIndex: audioHandler.currentIndex,
                      ),
                    ),
                  );
                }
              },
              child: const MiniPlayer(),
            ),
          // Bottom Navigation Bar
          BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: '',
              ),
            ],
            currentIndex: _selectedTabIndex,
            onTap: (index) {
              if (index == 1) {
                // Mở màn hình tìm kiếm
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchScreen()),
                );
              } else if (index == 2) {
                // Mở màn hình yêu thích
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileScreen()),
                );
              } else {
                setState(() {
                  _selectedTabIndex = index;
                });
              }
            },
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedItemColor: const Color(0xFF31C934),
            unselectedItemColor: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String text, int index) {
    bool isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        if (_selectedTabIndex != index) {
          setState(() {
            _selectedTabIndex = index;
          });

          if (index == 0) {
            // Đã ở màn hình home, không cần điều hướng
          } else if (index == 1) {
            // Chuyển sang màn hình Album
            Navigator.pushNamed(context, '/album');
          } else if (index == 2) {
            // Chuyển sang màn hình Playlist
            Navigator.pushNamed(context, '/playlist');
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF31C934) : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildMusicItem(String title, String artist, String imagePath) {
    return SizedBox(
      width: 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            artist,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildAlbumItem(String title, String artist, String imagePath) {
    return SizedBox(
      width: 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            artist,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
