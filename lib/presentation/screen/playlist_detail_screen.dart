import 'package:flutter/material.dart';
import 'package:t4/data/playlist_list.dart';
import 'package:t4/data/song_list.dart';
import 'package:t4/presentation/screen/now_playing_screen.dart';
import 'package:t4/presentation/screen/search_screen.dart';
import 'package:t4/presentation/screen/ProfileScreen.dart';

class PlaylistDetailScreen extends StatefulWidget {
  final Playlist playlist;

  const PlaylistDetailScreen({Key? key, required this.playlist})
      : super(key: key);

  @override
  State<PlaylistDetailScreen> createState() => _PlaylistDetailScreenState();
}

class _PlaylistDetailScreenState extends State<PlaylistDetailScreen> {
  late List<Song> playlistSongs = [];
  late String playlistName = '';

  @override
  void initState() {
    super.initState();
    _loadPlaylistSongs();
    playlistName = widget.playlist.name;
  }

  void _loadPlaylistSongs() {
    // Lấy tất cả bài hát trong playlist
    playlistSongs = getPlaylistSongs(widget.playlist);
  }

  void _playAllSongs() {
    if (playlistSongs.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NowPlayingScreen(
            song: playlistSongs[0],
            songList: playlistSongs,
            initialIndex: 0,
          ),
        ),
      );
    }
  }

  void _showAddSongsDialog() {
    // Lọc ra các bài hát chưa có trong playlist
    List<Song> availableSongs = songList
        .where((song) => !widget.playlist.songIds.contains(song.id))
        .toList();

    // Danh sách các bài hát đã chọn
    List<int> selectedSongIds = [];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Thêm bài hát vào danh sách phát'),
            content: SizedBox(
              width: double.maxFinite,
              height: 400,
              child: availableSongs.isEmpty
                  ? const Center(child: Text('Không có bài hát nào khả dụng'))
                  : ListView.builder(
                      itemCount: availableSongs.length,
                      itemBuilder: (context, index) {
                        final song = availableSongs[index];
                        final isSelected = selectedSongIds.contains(song.id);

                        return CheckboxListTile(
                          title: Text(song.title),
                          subtitle: Text(song.artist),
                          secondary: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.asset(
                              song.coverImage,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                          ),
                          value: isSelected,
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                selectedSongIds.add(song.id);
                              } else {
                                selectedSongIds.remove(song.id);
                              }
                            });
                          },
                        );
                      },
                    ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (selectedSongIds.isNotEmpty) {
                    // Thêm các bài hát đã chọn vào playlist
                    for (int songId in selectedSongIds) {
                      if (!widget.playlist.songIds.contains(songId)) {
                        widget.playlist.songIds.add(songId);
                      }
                    }

                    // Cập nhật playlist trong danh sách toàn cục
                    for (int i = 0; i < globalPlaylistList.length; i++) {
                      if (globalPlaylistList[i].id == widget.playlist.id) {
                        globalPlaylistList[i] = widget.playlist;
                        break;
                      }
                    }

                    // Cập nhật UI
                    setState(() {
                      _loadPlaylistSongs();
                    });

                    // Hiển thị thông báo
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Đã thêm ${selectedSongIds.length} bài hát vào danh sách phát'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF31C934),
                ),
                child: const Text('Thêm'),
              ),
            ],
          );
        },
      ),
    ).then((_) {
      // Cập nhật UI sau khi dialog đóng
      this.setState(() {
        _loadPlaylistSongs();
      });
    });
  }

  void _showAddToOtherPlaylistDialog(Song song) {
    // Lọc ra các playlist không phải hệ thống và không phải playlist hiện tại
    List<Playlist> userPlaylists = globalPlaylistList
        .where((playlist) => 
            !playlist.isSystem && playlist.id != widget.playlist.id)
        .toList();

    if (userPlaylists.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bạn chưa tạo danh sách phát nào khác'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thêm vào danh sách phát khác'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: ListView.builder(
            itemCount: userPlaylists.length,
            itemBuilder: (context, index) {
              final playlist = userPlaylists[index];
              return ListTile(
                title: Text(playlist.name),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.asset(
                    playlist.coverImage,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
                onTap: () {
                  // Thêm bài hát vào playlist được chọn
                  if (!playlist.songIds.contains(song.id)) {
                    playlist.songIds.add(song.id);
                    
                    // Cập nhật globalPlaylistList
                    for (int i = 0; i < globalPlaylistList.length; i++) {
                      if (globalPlaylistList[i].id == playlist.id) {
                        globalPlaylistList[i] = playlist;
                        break;
                      }
                    }
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Đã thêm "${song.title}" vào danh sách phát "${playlist.name}"'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Bài hát đã có trong danh sách phát "${playlist.name}"'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                playlistName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    widget.playlist.coverImage,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            backgroundColor: Colors.black,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${playlistSongs.length} bài hát',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade300,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      // Xóa nút tải xuống và phát ngẫu nhiên
                      // Chỉ giữ lại nút phát
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _playAllSongs,
                          icon: const Icon(Icons.play_circle_filled),
                          label: const Text('Phát', style: TextStyle(fontSize: 16)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (!widget.playlist.isSystem)
                    OutlinedButton.icon(
                      onPressed: _showAddSongsDialog,
                      icon: const Icon(Icons.add),
                      label: const Text('Thêm bài hát', style: TextStyle(fontSize: 14)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.grey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  const Divider(color: Colors.grey),
                ],
              ),
            ),
          ),
          // Danh sách bài hát
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (playlistSongs.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Icon(Icons.music_note, size: 48, color: Colors.grey.shade600),
                          const SizedBox(height: 16),
                          Text(
                            'Chưa có bài hát nào',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade400,
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (!widget.playlist.isSystem)
                            ElevatedButton(
                              onPressed: _showAddSongsDialog,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text('Thêm bài hát đầu tiên'),
                            ),
                        ],
                      ),
                    ),
                  );
                }

                final song = playlistSongs[index];
                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.asset(
                      song.coverImage,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    song.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    song.artist,
                    style: TextStyle(color: Colors.grey.shade400),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.more_vert, color: Colors.grey),
                    onPressed: () {
                      _showSongOptions(song);
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NowPlayingScreen(
                          song: song,
                          songList: playlistSongs,
                          initialIndex: index,
                        ),
                      ),
                    );
                  },
                );
              },
              childCount: playlistSongs.isEmpty ? 1 : playlistSongs.length,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
            backgroundColor: Colors.black,
          ),
        ],
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            // Mở màn hình tìm kiếm
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchScreen()),
            );
          } else if (index == 2) {
            // Mở màn hình hồ sơ (trước đây là yêu thích)
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );
          } else if (index == 0) {
            // Trở về màn hình home
            Navigator.pushNamedAndRemoveUntil(
                context, '/home', (route) => false);
          }
        },
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.black,
      ),
    );
  }

  void _showSongOptions(Song song) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey.shade900,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.play_arrow, color: Colors.white),
              title: const Text('Phát', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                int index = playlistSongs.indexOf(song);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NowPlayingScreen(
                      song: song,
                      songList: playlistSongs,
                      initialIndex: index,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.playlist_add, color: Colors.white),
              title: const Text('Thêm vào danh sách phát khác', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _showAddToOtherPlaylistDialog(song);
              },
            ),
            if (!widget.playlist.isSystem)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Xóa khỏi danh sách phát', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    widget.playlist.songIds.remove(song.id);
                    playlistSongs.remove(song);

                    // Cập nhật globalPlaylistList
                    for (int i = 0; i < globalPlaylistList.length; i++) {
                      if (globalPlaylistList[i].id == widget.playlist.id) {
                        // Đã tìm thấy playlist cần cập nhật
                        globalPlaylistList[i] = widget.playlist;
                        break;
                      }
                    }
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('Đã xóa "${song.title}" khỏi danh sách phát'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
          ],
        );
      },
    );
  }

  void _showEditPlaylistDialog() {
    final TextEditingController nameController =
        TextEditingController(text: playlistName);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chỉnh sửa danh sách phát'),
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
              // Cập nhật tên playlist (trong ứng dụng thật sẽ cập nhật vào cơ sở dữ liệu)
              final name = nameController.text.trim();
              if (name.isNotEmpty) {
                setState(() {
                  playlistName = name;
                  widget.playlist.name = name;

                  // Cập nhật globalPlaylistList
                  for (int i = 0; i < globalPlaylistList.length; i++) {
                    if (globalPlaylistList[i].id == widget.playlist.id) {
                      // Đã tìm thấy playlist cần cập nhật
                      globalPlaylistList[i].name = name;
                      break;
                    }
                  }
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Đã đổi tên danh sách phát thành "$name"'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }
}
