import 'package:flutter/material.dart';
import 'package:t4/data/playlist_list.dart';
import 'package:t4/data/song_list.dart';
import 'package:t4/data/album_list.dart';
import 'package:t4/presentation/screen/now_playing_screen.dart';
import 'package:t4/presentation/screen/search_screen.dart';
import 'package:t4/presentation/screen/ProfileScreen.dart';
import 'package:t4/presentation/screen/album_detail_screen.dart';
import 'package:t4/presentation/screen/artist_profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:t4/services/audio_player_handler.dart';
import 'package:t4/widgets/mini_player.dart';

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
      setState(() {
        _loadPlaylistSongs();
      });
    });
  }

  void _showAddToOtherPlaylistDialog(Song song) {
    // Lấy ID của người dùng hiện tại
    final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng đăng nhập để sử dụng tính năng này'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Lọc ra các playlist của người dùng (loại trừ playlist hiện tại)
    List<Playlist> userPlaylists = globalPlaylistList
        .where((playlist) =>
            !playlist.isSystem &&
            playlist.id != widget.playlist.id &&
            playlist.userId == currentUserId)
        .toList();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey.shade900,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Thêm vào danh sách phát',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Nút tạo danh sách phát mới
                ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF31C934).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Color(0xFF31C934),
                    ),
                  ),
                  title: const Text(
                    'Tạo danh sách phát mới',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    // Hiển thị dialog tạo playlist mới
                    showDialog(
                      context: context,
                      builder: (context) {
                        String newPlaylistName = '';
                        return AlertDialog(
                          title: const Text('Tạo danh sách phát mới'),
                          content: TextField(
                            autofocus: true,
                            decoration: const InputDecoration(
                              hintText: 'Nhập tên danh sách phát',
                            ),
                            onChanged: (value) {
                              newPlaylistName = value;
                            },
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Hủy'),
                            ),
                            TextButton(
                              onPressed: () async {
                                if (newPlaylistName.trim().isNotEmpty) {
                                  // Tạo playlist mới
                                  final timestamp =
                                      DateTime.now().millisecondsSinceEpoch;
                                  final newId =
                                      'playlist_${timestamp}_${currentUserId}';
                                  final newPlaylist = Playlist(
                                    id: newId,
                                    name: newPlaylistName.trim(),
                                    coverImage: song.coverImage,
                                    songIds: [song.id],
                                    isSystem: false,
                                    userId: currentUserId,
                                  );

                                  // Thêm vào danh sách toàn cục
                                  globalPlaylistList.add(newPlaylist);
                                  playlistUpdateController.add(null);

                                  // Đóng cả 2 dialog
                                  Navigator.pop(
                                      context); // Đóng dialog tạo playlist
                                  Navigator.pop(context); // Đóng bottom sheet

                                  // Hiển thị thông báo
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Đã tạo danh sách phát "${newPlaylistName}" và thêm bài hát vào',
                                      ),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                }
                              },
                              child: const Text('Tạo'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                if (userPlaylists.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Danh sách phát của bạn',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: userPlaylists.length,
                      itemBuilder: (context, index) {
                        final playlist = userPlaylists[index];
                        return ListTile(
                          title: Text(
                            playlist.name,
                            style: const TextStyle(color: Colors.white),
                          ),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.asset(
                              playlist.coverImage,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                          ),
                          subtitle: Text(
                            '${playlist.songIds.length} bài hát',
                            style: TextStyle(color: Colors.grey.shade400),
                          ),
                          onTap: () {
                            if (!playlist.songIds.contains(song.id)) {
                              setState(() {
                                playlist.songIds.add(song.id);
                                // Cập nhật lại playlist trong danh sách toàn cục
                                final index = globalPlaylistList.indexWhere(
                                  (p) => p.id == playlist.id,
                                );
                                if (index != -1) {
                                  globalPlaylistList[index] = playlist;
                                  playlistUpdateController.add(null);
                                }
                              });

                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Đã thêm "${song.title}" vào ${playlist.name}',
                                  ),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            } else {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Bài hát đã có trong ${playlist.name}',
                                  ),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final audioHandler = Provider.of<AudioPlayerHandler>(context);
    final bool showMiniPlayer = audioHandler.currentSong != null;

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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Nút phát
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.green,
                        child: IconButton(
                          icon: const Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 24,
                          ),
                          onPressed: _playAllSongs,
                        ),
                      ),
                      // Nút thêm bài hát
                      if (!widget.playlist.isSystem ||
                          widget.playlist.id == 'playlist_my_favorites')
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.grey.shade800,
                          child: IconButton(
                            icon: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 24,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SearchScreen(
                                    isSelectingSongs: true,
                                    targetPlaylist: widget.playlist,
                                    isFavoritePlaylist: widget.playlist.id ==
                                        'playlist_my_favorites',
                                  ),
                                ),
                              ).then((_) {
                                setState(() {
                                  _loadPlaylistSongs();
                                });
                              });
                            },
                          ),
                        ),
                      // Nút chỉnh sửa
                      if (!widget.playlist.isSystem &&
                          widget.playlist.id != 'playlist_my_favorites')
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.grey.shade800,
                          child: IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: _showEditPlaylistDialog,
                          ),
                        ),
                    ],
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
                          Icon(Icons.music_note,
                              size: 48, color: Colors.grey.shade600),
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
                backgroundColor: Colors.black,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: '',
                backgroundColor: Colors.black,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: '',
                backgroundColor: Colors.black,
              ),
            ],
            currentIndex: 0,
            onTap: (index) {
              if (index == 1) {
                // Mở màn hình tìm kiếm
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchScreen()),
                );
              } else if (index == 2) {
                // Mở màn hình hồ sơ (trước đây là yêu thích)
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileScreen()),
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
        ],
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
            // Phát bài hát
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

            // Xóa khỏi danh sách phát/yêu thích
            if (widget.playlist.id == 'playlist_my_favorites')
              ListTile(
                leading: const Icon(Icons.favorite_border, color: Colors.red),
                title: const Text('Xóa khỏi danh sách yêu thích',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  final String? currentUserId =
                      FirebaseAuth.instance.currentUser?.uid;
                  if (currentUserId != null) {
                    setState(() {
                      toggleFavorite(song.id, currentUserId);
                      song.isFavorite = false;
                      widget.playlist.songIds.remove(song.id);
                      playlistSongs.remove(song);

                      // Cập nhật playlist trong danh sách toàn cục
                      for (int i = 0; i < globalPlaylistList.length; i++) {
                        if (globalPlaylistList[i].id == widget.playlist.id) {
                          globalPlaylistList[i] = widget.playlist;
                          playlistUpdateController.add(null);
                          break;
                        }
                      }
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Đã xóa "${song.title}" khỏi danh sách yêu thích'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
              )
            else if (!widget.playlist.isSystem)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Xóa khỏi danh sách phát',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    widget.playlist.songIds.remove(song.id);
                    playlistSongs.remove(song);

                    // Cập nhật globalPlaylistList
                    for (int i = 0; i < globalPlaylistList.length; i++) {
                      if (globalPlaylistList[i].id == widget.playlist.id) {
                        globalPlaylistList[i] = widget.playlist;
                        playlistUpdateController.add(null);
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

            // Thêm vào danh sách phát mới
            ListTile(
              leading: const Icon(Icons.playlist_add, color: Colors.white),
              title: const Text('Thêm vào danh sách phát mới',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                final String? currentUserId =
                    FirebaseAuth.instance.currentUser?.uid;
                if (currentUserId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('Vui lòng đăng nhập để sử dụng tính năng này'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  return;
                }

                showDialog(
                  context: context,
                  builder: (context) {
                    String newPlaylistName = '';
                    return AlertDialog(
                      title: const Text('Tạo danh sách phát mới'),
                      content: TextField(
                        autofocus: true,
                        decoration: const InputDecoration(
                          hintText: 'Nhập tên danh sách phát',
                        ),
                        onChanged: (value) {
                          newPlaylistName = value;
                        },
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Hủy'),
                        ),
                        TextButton(
                          onPressed: () {
                            if (newPlaylistName.trim().isNotEmpty) {
                              // Tạo playlist mới
                              final timestamp =
                                  DateTime.now().millisecondsSinceEpoch;
                              final newId =
                                  'playlist_${timestamp}_${currentUserId}';
                              final newPlaylist = Playlist(
                                id: newId,
                                name: newPlaylistName.trim(),
                                coverImage: song.coverImage,
                                songIds: [song.id],
                                isSystem: false,
                                userId: currentUserId,
                              );

                              // Thêm vào danh sách toàn cục
                              globalPlaylistList.add(newPlaylist);
                              playlistUpdateController.add(null);

                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Đã tạo danh sách phát "${newPlaylistName}" và thêm bài hát vào',
                                  ),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                          child: const Text('Tạo'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),

            // Chuyển đến trang nghệ sĩ
            ListTile(
              leading: const Icon(Icons.person, color: Colors.white),
              title: const Text('Chuyển đến nghệ sĩ',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ArtistProfileScreen(artistName: song.artist),
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
              final name = nameController.text.trim();
              if (name.isNotEmpty) {
                setState(() {
                  playlistName = name;
                  widget.playlist.name = name;

                  // Cập nhật globalPlaylistList
                  for (int i = 0; i < globalPlaylistList.length; i++) {
                    if (globalPlaylistList[i].id == widget.playlist.id) {
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
