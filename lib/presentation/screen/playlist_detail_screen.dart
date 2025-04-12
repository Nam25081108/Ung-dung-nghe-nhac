import 'package:flutter/material.dart';
import 'package:t4/data/playlist_list.dart';
import 'package:t4/data/song_list.dart';
import 'package:t4/presentation/screen/now_playing_screen.dart';
import 'package:t4/presentation/screen/FavoriteScreen.dart';
import 'package:t4/presentation/screen/search_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
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
              background: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(widget.playlist.coverImage),
                    fit: BoxFit.cover,
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
                child: Container(
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
              ),
            ),
            backgroundColor: const Color(0xFF31C934),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.playlist.isSystem
                        ? 'Danh sách hệ thống'
                        : 'Danh sách người dùng',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${playlistSongs.length} bài hát',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _playAllSongs,
                        icon: const Icon(Icons.play_circle_filled),
                        label: const Text('Phát tất cả'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF31C934),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      if (!widget.playlist.isSystem)
                        IconButton(
                          onPressed: () {
                            _showEditPlaylistDialog();
                          },
                          icon:
                              const Icon(Icons.edit, color: Color(0xFF31C934)),
                          style: IconButton.styleFrom(
                            backgroundColor:
                                const Color(0xFF31C934).withOpacity(0.2),
                            padding: const EdgeInsets.all(12),
                          ),
                        ),
                      IconButton(
                        onPressed: () {
                          if (!widget.playlist.isSystem) {
                            _showAddSongsDialog();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Không thể thêm bài hát vào danh sách hệ thống'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.add, color: Color(0xFF31C934)),
                        style: IconButton.styleFrom(
                          backgroundColor:
                              const Color(0xFF31C934).withOpacity(0.2),
                          padding: const EdgeInsets.all(12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (playlistSongs.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        'Chưa có bài hát nào trong danh sách phát này',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  );
                }

                final song = playlistSongs[index];
                return Dismissible(
                  key: Key('song-${song.id}'),
                  direction: widget.playlist.isSystem
                      ? DismissDirection.none
                      : DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20.0),
                    color: Colors.red,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (direction) async {
                    if (widget.playlist.isSystem) return false;

                    return await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Xác nhận'),
                          content: Text(
                              'Bạn có chắc muốn xóa "${song.title}" khỏi danh sách phát?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Hủy'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('Xóa'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  onDismissed: (direction) {
                    setState(() {
                      widget.playlist.songIds.remove(song.id);
                      playlistSongs.removeAt(index);

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
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        song.coverImage,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      song.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(song.artist),
                    trailing: IconButton(
                      icon: const Icon(Icons.more_vert),
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
                  ),
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
              MaterialPageRoute(builder: (context) => FavoriteScreen()),
            );
          } else if (index == 0) {
            // Trở về màn hình home
            Navigator.pushNamedAndRemoveUntil(
                context, '/home', (route) => false);
          }
        },
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: const Color(0xFF31C934),
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  void _showSongOptions(Song song) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.play_arrow),
              title: const Text('Phát bài hát'),
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
              leading: const Icon(Icons.playlist_add),
              title: const Text('Thêm vào danh sách phát khác'),
              onTap: () {
                Navigator.pop(context);
                // Hiển thị dialog chọn playlist khác
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Tính năng đang phát triển'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
            if (!widget.playlist.isSystem)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Xóa khỏi danh sách phát'),
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
              backgroundColor: const Color(0xFF31C934),
            ),
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }
}
