import 'package:flutter/material.dart';
import 'package:t4/data/playlist_list.dart';
import 'package:t4/data/song_list.dart';
import 'package:t4/presentation/screen/ProfileScreen.dart';
import 'package:t4/presentation/screen/search_screen.dart';
import 'package:t4/presentation/screen/playlist_detail_screen.dart';
import 'package:t4/presentation/screen/now_playing_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({Key? key}) : super(key: key);

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  int _selectedTabIndex = 2; // Danh sách phát tab is selected by default
  // Lưu trữ danh sách phát cục bộ để có thể thêm/xóa
  List<Playlist> _localPlaylistList = [];

  @override
  void initState() {
    super.initState();
    // Chỉ hiển thị danh sách yêu thích và danh sách tạo bởi người dùng
    _updateLocalPlaylistList();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Cập nhật danh sách playlist khi quay lại màn hình này
    _updateLocalPlaylistList();
  }

  // Phương thức mới để cập nhật danh sách playlist cục bộ
  void _updateLocalPlaylistList() {
    // Lấy ID của người dùng hiện tại
    final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

    setState(() {
      // Lọc chỉ lấy danh sách yêu thích và danh sách do người dùng hiện tại tạo
      _localPlaylistList = globalPlaylistList
          .where((playlist) =>
              // Chỉ lấy danh sách yêu thích của người dùng hiện tại
              (playlist.id == 'playlist_my_favorites' &&
                  playlist.userId == currentUserId) ||
              // Lấy các danh sách phát do người dùng hiện tại tạo
              (!playlist.isSystem && playlist.userId == currentUserId))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      // Navigate back to home screen
                      Navigator.pop(context);
                    },
                    child: const CircleAvatar(
                      backgroundColor: Color(0xFFE0E0E0),
                      child: Icon(Icons.person, color: Colors.grey),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Danh sách phát của bạn',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _showCreatePlaylistDialog();
                    },
                    icon: const Icon(
                      Icons.add_circle_outline,
                      color: Color(0xFF31C934),
                      size: 28,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _localPlaylistList.length,
                  itemBuilder: (context, index) {
                    final playlist = _localPlaylistList[index];

                    // Lấy bài hát đầu tiên để hiển thị hình ảnh nếu không có coverImage
                    String coverImage = playlist.coverImage;
                    if (playlist.songIds.isNotEmpty) {
                      int firstSongId = playlist.songIds[0];
                      Song? firstSong = songList.firstWhere(
                        (song) => song.id == firstSongId,
                        orElse: () => Song(
                          id: 0,
                          title: '',
                          artist: 'Không xác định',
                          coverImage: 'assets/default_playlist.png',
                          assetPath: '',
                          lyrics: '',
                        ),
                      );
                      if (coverImage.isEmpty) {
                        coverImage = firstSong.coverImage;
                      }
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Dismissible(
                        key: Key(playlist.id),
                        direction: playlist.isSystem
                            ? DismissDirection.none
                            : DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20.0),
                          color: Colors.red,
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        confirmDismiss: (direction) async {
                          if (playlist.isSystem) return false;

                          return await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Xác nhận'),
                                content: Text(
                                    'Bạn có chắc muốn xóa danh sách phát "${playlist.name}"?'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: const Text('Hủy'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: const Text('Xóa'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        onDismissed: (direction) {
                          // Lưu lại thông tin playlist trước khi xóa
                          final playlistId = playlist.id;

                          setState(() {
                            // Xóa khỏi danh sách cục bộ
                            _localPlaylistList.removeAt(index);

                            // Xóa khỏi danh sách toàn cục
                            globalPlaylistList
                                .removeWhere((p) => p.id == playlistId);
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Đã xóa danh sách phát "${playlist.name}"'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        child: _buildPlaylistListItem(playlist, coverImage),
                      ),
                    );
                  },
                ),
              ),
            ],
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
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
        currentIndex: 0, // Home is selected by default
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
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );
          } else if (index == 0) {
            // Trở về màn hình home
            Navigator.pushReplacementNamed(context, '/home');
          }
        },
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: const Color(0xFF31C934),
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  void _showCreatePlaylistDialog() {
    final TextEditingController nameController = TextEditingController();
    final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tạo danh sách phát mới'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            hintText: 'Nhập tên danh sách phát',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              // Tạo playlist mới và thêm vào danh sách cục bộ
              final name = nameController.text.trim();
              if (name.isNotEmpty) {
                // Tạo ID duy nhất dựa trên thời gian hiện tại
                final timestamp = DateTime.now().millisecondsSinceEpoch;
                final newId =
                    'playlist_${name.toLowerCase().replaceAll(' ', '_')}_$timestamp';

                // Tạo một playlist mới
                final newPlaylist = Playlist(
                  id: newId,
                  name: name,
                  coverImage: 'assets/default_playlist.png', // Ảnh mặc định
                  songIds: [], // Chưa có bài hát nào
                  isSystem: false, // Playlist người dùng tạo
                  userId:
                      currentUserId, // Thêm thông tin người dùng tạo playlist
                );

                // Thêm vào biến toàn cục
                globalPlaylistList.add(newPlaylist);

                // Cập nhật danh sách cục bộ ngay lập tức
                _updateLocalPlaylistList();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Đã tạo danh sách phát "$name"'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF31C934),
            ),
            child: const Text('Tạo'),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String text, int index) {
    bool isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        // Cập nhật chỉ khi đang ở tab khác
        if (_selectedTabIndex != index) {
          setState(() {
            _selectedTabIndex = index;
          });

          if (index == 0) {
            // Trở về màn hình home
            Navigator.pushReplacementNamed(context, '/home');
          } else if (index == 1) {
            // Chuyển sang màn hình album
            Navigator.pushReplacementNamed(context, '/album');
          } else if (index == 2) {
            // Đã ở màn hình Playlist, không cần chuyển
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

  Widget _buildPlaylistListItem(Playlist playlist, String coverImage) {
    List<Song> songs = getPlaylistSongs(playlist);

    return GestureDetector(
      onTap: () {
        // Khi bấm vào playlist sẽ mở trang chi tiết playlist
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlaylistDetailScreen(
              playlist: playlist,
            ),
          ),
        );
      },
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Hình ảnh playlist
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                image: DecorationImage(
                  image: AssetImage(coverImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Thông tin playlist
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      playlist.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      playlist.isSystem ? 'Hệ thống' : 'Playlist',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${playlist.songIds.length} bài hát',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Nút phát toàn bộ playlist
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(
                backgroundColor: const Color(0xFF31C934).withOpacity(0.2),
                radius: 20,
                child: IconButton(
                  icon: const Icon(Icons.play_arrow, color: Color(0xFF31C934)),
                  onPressed: () {
                    // Phát toàn bộ playlist từ bài đầu tiên
                    if (songs.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NowPlayingScreen(
                            song: songs[0],
                            songList: songs,
                            initialIndex: 0,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Danh sách phát "${playlist.name}" không có bài hát nào'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
