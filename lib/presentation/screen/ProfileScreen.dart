import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:async';
import 'package:t4/data/song_list.dart';
import 'package:t4/data/playlist_list.dart';
import 'package:t4/presentation/screen/home_screen.dart';
import 'package:t4/presentation/screen/search_screen.dart';
import 'package:t4/presentation/screen/playlist_detail_screen.dart';
import 'now_playing_screen.dart';
import 'package:provider/provider.dart';
import 'package:t4/services/audio_player_handler.dart';
import 'package:t4/widgets/mini_player.dart';
import 'package:t4/models/song.dart';
import 'package:t4/models/playlist.dart';

// Stream controller toàn cục để thông báo thay đổi playlist
final StreamController<void> playlistUpdateController =
    StreamController<void>.broadcast();

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

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
  late StreamSubscription<void> _playlistUpdateSubscription;

  // Phân trang
  final int _currentPage = 0;
  final int _songsPerPage = 10;

  @override
  void initState() {
    super.initState();
    final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId != null) {
      favoriteSongs = getFavoriteSongs(currentUserId);
    } else {
      favoriteSongs = [];
    }
    _loadDurations();
    _updateFavoritePlaylist();
    _loadUserPlaylists();
    _usernameController.text = user?.displayName ?? 'Người dùng';

    // Đăng ký lắng nghe sự kiện cập nhật playlist
    _playlistUpdateSubscription = playlistUpdateController.stream.listen((_) {
      if (mounted) {
        _loadUserPlaylists();
      }
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _playlistUpdateSubscription.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId != null) {
      setState(() {
        favoriteSongs = getFavoriteSongs(currentUserId);
        _loadDurations();
        _updateFavoritePlaylist();
        _loadUserPlaylists();
      });
    }
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
    final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

    // Kiểm tra xem userId hiện tại đã có danh sách yêu thích chưa
    bool hasPersonalFavorites = false;
    int existingFavoritesIndex = -1;

    for (int i = 0; i < globalPlaylistList.length; i++) {
      if (globalPlaylistList[i].id == 'playlist_my_favorites' &&
          globalPlaylistList[i].userId == currentUserId) {
        hasPersonalFavorites = true;
        existingFavoritesIndex = i;
        break;
      }
    }

    if (hasPersonalFavorites) {
      // Cập nhật danh sách yêu thích hiện có của người dùng
      globalPlaylistList[existingFavoritesIndex] = Playlist(
        id: 'playlist_my_favorites',
        name: 'Yêu thích của tôi',
        coverImage: 'assets/favorite_playlist.png',
        songIds: favoriteSongIds,
        isSystem: true,
        userId: currentUserId,
      );
    } else {
      // Tạo một danh sách yêu thích mới cho người dùng hiện tại
      bool foundDefaultFavorites = false;
      for (int i = 0; i < globalPlaylistList.length; i++) {
        if (globalPlaylistList[i].id == 'playlist_my_favorites' &&
            globalPlaylistList[i].userId == null) {
          // Cập nhật playlist mặc định để thuộc về người dùng hiện tại
          globalPlaylistList[i] = Playlist(
            id: 'playlist_my_favorites',
            name: 'Yêu thích của tôi',
            coverImage: 'assets/favorite_playlist.png',
            songIds: favoriteSongIds,
            isSystem: true,
            userId: currentUserId,
          );
          foundDefaultFavorites = true;
          break;
        }
      }

      if (!foundDefaultFavorites) {
        // Tạo mới hoàn toàn nếu không tìm thấy playlist mặc định
        globalPlaylistList.add(Playlist(
          id: 'playlist_my_favorites',
          name: 'Yêu thích của tôi',
          coverImage: 'assets/favorite_playlist.png',
          songIds: favoriteSongIds,
          isSystem: true,
          userId: currentUserId,
        ));
      }
    }
  }

  void _loadUserPlaylists() {
    final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId != null && mounted) {
      // Lấy danh sách playlist do người dùng tạo và danh sách yêu thích
      List<Playlist> updatedPlaylists = globalPlaylistList
          .where((playlist) =>
              (playlist.id == 'playlist_my_favorites' &&
                  playlist.userId == currentUserId) ||
              (!playlist.isSystem && playlist.userId == currentUserId))
          .toList();

      // Sắp xếp playlist theo thời gian tạo (mới nhất lên đầu)
      updatedPlaylists.sort((a, b) {
        // Đảm bảo playlist yêu thích luôn ở đầu
        if (a.id == 'playlist_my_favorites') return -1;
        if (b.id == 'playlist_my_favorites') return 1;

        // Lấy timestamp từ ID của playlist (format: playlist_timestamp_userId)
        int timestampA = int.tryParse(a.id.split('_')[1]) ?? 0;
        int timestampB = int.tryParse(b.id.split('_')[1]) ?? 0;
        return timestampB.compareTo(timestampA);
      });

      // Chỉ cập nhật state nếu có sự thay đổi
      if (!_arePlaylistsEqual(userPlaylists, updatedPlaylists)) {
        setState(() {
          userPlaylists = updatedPlaylists;
        });
      }
    }
  }

  // Hàm so sánh hai danh sách playlist
  bool _arePlaylistsEqual(List<Playlist> list1, List<Playlist> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i].id != list2[i].id ||
          list1[i].songIds.length != list2[i].songIds.length ||
          !list1[i].songIds.every((id) => list2[i].songIds.contains(id))) {
        return false;
      }
    }
    return true;
  }

  void _toggleFavorite(Song song) {
    final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId != null) {
      setState(() {
        // Sử dụng hàm toggleFavorite mới
        toggleFavorite(song.id, currentUserId);
        // Cập nhật lại danh sách bài hát yêu thích
        favoriteSongs = getFavoriteSongs(currentUserId);
        // Cập nhật lại trạng thái song.isFavorite để UI hiển thị đúng
        song.isFavorite = isSongFavoriteByUser(song.id, currentUserId);
        // Cập nhật playlist yêu thích
        _updateFavoritePlaylist();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã xoá khỏi danh sách yêu thích')),
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SearchScreen()),
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
          const SnackBar(content: Text('Tên người dùng đã được cập nhật')),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không thể cập nhật tên người dùng')),
        );
      }
    }
  }

  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chỉnh sửa hồ sơ'),
        content: TextField(
          controller: _usernameController,
          decoration: const InputDecoration(labelText: 'Tên người dùng'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              _updateUsername();
              Navigator.pop(context);
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final audioHandler = Provider.of<AudioPlayerHandler>(context);
    final bool showMiniPlayer = audioHandler.currentSong != null;

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
                            icon: const Icon(Icons.arrow_back,
                                color: Colors.black),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const Spacer(),
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
                        style: const TextStyle(
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
                            child: const Text('Chỉnh sửa'),
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
                        const Text(
                          'Playlists',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextButton(
                          onPressed: _navigateToPlaylistScreen,
                          child: const Text(
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
                                const Icon(
                                  Icons.playlist_play,
                                  size: 60,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 16),
                                const Text(
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
                                  child: const Text('Tạo danh sách phát'),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
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
                                              style: const TextStyle(
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
                                        icon: const Icon(
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
            currentIndex: 2, // Tab profile được chọn
            onTap: (index) {
              if (index == 0) {
                // Về home
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              } else if (index == 1) {
                // Mở search
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchScreen()),
                );
              }
            },
            selectedItemColor: const Color(0xFF31C934),
            unselectedItemColor: Colors.grey,
          ),
        ],
      ),
    );
  }
}
