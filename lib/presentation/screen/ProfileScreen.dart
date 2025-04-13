import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:just_audio/just_audio.dart';
import 'package:t4/data/song_list.dart';
import 'package:t4/data/playlist_list.dart';
import 'package:t4/presentation/screen/home_screen.dart';
import 'package:t4/presentation/screen/search_screen.dart';
import 'package:t4/presentation/screen/playlist_detail_screen.dart';
import 'now_playing_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  late List<Song> favoriteSongs;
  final Map<String, Duration> _durations = {};
  int _selectedIndex = 2;
  late List<Playlist> userPlaylists = [];
  final TextEditingController _usernameController = TextEditingController();

  // Phân trang
  int _currentPage = 0;
  final int _songsPerPage = 10;

  @override
  void initState() {
    super.initState();
    favoriteSongs = songList.where((s) => s.isFavorite).toList();
    _loadDurations();
    _updateFavoritePlaylist();
    _loadUserPlaylists();
    _usernameController.text = user?.displayName ?? 'Người dùng';
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
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
          coverImage: 'assets/favorite_playlist.png',
          songIds: favoriteSongIds,
          isSystem: true,
        );
        break;
      }
    }
  }

  void _loadUserPlaylists() {
    // Lấy danh sách playlist do người dùng tạo (không phải hệ thống)
    setState(() {
      userPlaylists = globalPlaylistList
          .where((playlist) =>
              !playlist.isSystem || playlist.id == 'playlist_my_favorites')
          .toList();
    });
  }

  void _toggleFavorite(Song song) {
    setState(() {
      song.isFavorite = false;
      favoriteSongs = songList.where((s) => s.isFavorite).toList();
      _updateFavoritePlaylist();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã xoá khỏi danh sách yêu thích')),
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

  void _navigateToPlaylistScreen() {
    Navigator.pushNamed(context, '/playlist');
  }

  Future<void> _updateUsername() async {
    if (user != null && _usernameController.text.trim().isNotEmpty) {
      try {
        await user!.updateDisplayName(_usernameController.text.trim());

        setState(() {
          // Cập nhật UI ngay lập tức
          user?.updateDisplayName(_usernameController.text.trim());
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tên người dùng đã được cập nhật')),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Không thể cập nhật tên người dùng')),
        );
      }
    }
  }

  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Chỉnh sửa hồ sơ'),
        content: TextField(
          controller: _usernameController,
          decoration: InputDecoration(labelText: 'Tên người dùng'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              _updateUsername();
              Navigator.pop(context);
            },
            child: Text('Lưu'),
          ),
        ],
      ),
    );
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header và ảnh đại diện
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.grey.shade200,
                      Colors.white,
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back, color: Colors.black),
                            onPressed: () => Navigator.pop(context),
                          ),
                          Spacer(),
                        ],
                      ),
                      const SizedBox(height: 20),
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey.shade300,
                        child: Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        user?.displayName ?? 'Người dùng',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        user?.email ?? '',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton(
                            onPressed: _showEditDialog,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.black,
                              side: BorderSide(color: Colors.grey.shade400),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text('Chỉnh sửa'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Phần Playlists
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Playlists',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextButton(
                          onPressed: _navigateToPlaylistScreen,
                          child: Text(
                            'Xem tất cả',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    userPlaylists.isEmpty
                        ? Center(
                            child: Column(
                              children: [
                                const SizedBox(height: 20),
                                Icon(
                                  Icons.playlist_play,
                                  size: 60,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Chưa có danh sách phát nào',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: _navigateToPlaylistScreen,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: Text('Tạo danh sách phát'),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: userPlaylists.length > 2
                                ? 2
                                : userPlaylists.length,
                            itemBuilder: (context, index) {
                              final playlist = userPlaylists[index];
                              // Lấy danh sách bài hát trong playlist
                              List<Song> songs = getPlaylistSongs(playlist);
                              String coverImage = playlist.coverImage;

                              if (songs.isNotEmpty &&
                                  coverImage.contains('default_playlist')) {
                                coverImage = songs.first.coverImage;
                              }

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PlaylistDetailScreen(
                                          playlist: playlist,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.asset(
                                          coverImage,
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              playlist.name,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color: Colors.black,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '${songs.length} bài hát',
                                              style: TextStyle(
                                                color: Colors.grey.shade700,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.play_circle_filled,
                                          color: Colors.green,
                                          size: 40,
                                        ),
                                        onPressed: () {
                                          if (songs.isNotEmpty) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    NowPlayingScreen(
                                                  song: songs[0],
                                                  songList: songs,
                                                  initialIndex: 0,
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
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
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
            backgroundColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
