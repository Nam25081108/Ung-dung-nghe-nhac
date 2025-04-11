import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:t4/data/song_list.dart';
import 'package:t4/presentation/screen/FavoriteScreen.dart';
import 'package:t4/presentation/screen/search_screen.dart';
import 'now_playing_screen.dart';

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
  // Danh sách album
  late List<Song> _popularAlbums = [];

  // Phân trang hiển thị
  int _maxDisplayItems = 5; // Hiển thị 5 bài/album đầu tiên
  bool _showAllRecommended = false;
  bool _showAllAlbums = false;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    // Tải danh sách bài hát từ file local
    _loadSongs();
  }

  void _loadSongs() {
    setState(() {
      _recommendedSongs = songList;
      _popularAlbums = songList;
      _isLoading = false;
    });
  }

  Future<void> _signOut() async {
    try {
      await _auth.signOut();
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
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
                          GestureDetector(
                            onTap: _signOut,
                            child: const CircleAvatar(
                              backgroundColor: Color(0xFFE0E0E0),
                              child: Icon(Icons.person, color: Colors.grey),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Row(
                              children: [
                                _buildTabButton('Tất Cả', 0),
                                const SizedBox(width: 15),
                                _buildTabButton('Album', 1),
                                const SizedBox(width: 15),
                                _buildTabButton('Danh sách phát', 2),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Được Đề Xuất Cho Hôm Nay',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (_recommendedSongs.length > _maxDisplayItems)
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _showAllRecommended = !_showAllRecommended;
                                });
                              },
                              child: Text(
                                _showAllRecommended ? 'Thu gọn' : 'Xem thêm',
                                style: const TextStyle(
                                  color: Color(0xFF31C934),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        height: 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _showAllRecommended
                              ? _recommendedSongs.length
                              : _recommendedSongs.length > _maxDisplayItems
                                  ? _maxDisplayItems
                                  : _recommendedSongs.length,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Album Và Đĩa Nổi Tiếng',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (_popularAlbums.length > _maxDisplayItems)
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _showAllAlbums = !_showAllAlbums;
                                });
                              },
                              child: Text(
                                _showAllAlbums ? 'Thu gọn' : 'Xem thêm',
                                style: const TextStyle(
                                  color: Color(0xFF31C934),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        height: 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _showAllAlbums
                              ? _popularAlbums.length
                              : _popularAlbums.length > _maxDisplayItems
                                  ? _maxDisplayItems
                                  : _popularAlbums.length,
                          itemBuilder: (context, index) {
                            final album = _popularAlbums[index];
                            return Padding(
                              padding: EdgeInsets.only(
                                right:
                                    index != _popularAlbums.length - 1 ? 15 : 0,
                              ),
                              child: GestureDetector(
                                onTap: () =>
                                    _onSongTapped(album, _popularAlbums, index),
                                child: _buildAlbumItem(
                                  album.title,
                                  album.artist,
                                  album.coverImage,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
      bottomNavigationBar: BottomNavigationBar(
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
            icon: Icon(Icons.favorite_border),
            label: '',
          ),
        ],
        currentIndex: _selectedTabIndex,
        onTap: (index) {
          if (index == 1) {
            // Mở màn hình tìm kiếm
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchScreen()),
            );
          } else if (index == 2) {
            // Mở màn hình yêu thích
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FavoriteScreen()),
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
    );
  }

  Widget _buildTabButton(String text, int index) {
    bool isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
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
    return Container(
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
    return Container(
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
