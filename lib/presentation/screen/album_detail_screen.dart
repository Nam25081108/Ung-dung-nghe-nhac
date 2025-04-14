import 'package:flutter/material.dart';

import 'package:t4/data/song_list.dart';
import 'package:t4/presentation/screen/now_playing_screen.dart';
import 'package:t4/presentation/screen/ProfileScreen.dart';
import 'package:t4/presentation/screen/search_screen.dart';
import 'package:t4/data/playlist_list.dart';
import 'package:t4/presentation/screen/artist_profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:t4/services/audio_player_handler.dart';
import 'package:t4/widgets/mini_player.dart';
import 'package:t4/models/song.dart';
import 'package:t4/models/playlist.dart';
import 'package:t4/models/album.dart';

class AlbumDetailScreen extends StatefulWidget {
  final Album album;

  const AlbumDetailScreen({Key? key, required this.album}) : super(key: key);

  @override
  State<AlbumDetailScreen> createState() => _AlbumDetailScreenState();
}

class _AlbumDetailScreenState extends State<AlbumDetailScreen> {
  late List<Song> albumSongs = [];
  late String artistName = '';

  @override
  void initState() {
    super.initState();
    _loadAlbumSongs();
  }

  void _loadAlbumSongs() {
    // Lấy tất cả bài hát trong album
    albumSongs = songList
        .where((song) => widget.album.songIds.contains(song.id))
        .toList();

    // Lấy tên nghệ sĩ từ bài hát đầu tiên
    if (albumSongs.isNotEmpty) {
      artistName = albumSongs[0].artist;
    }
  }

  void _playAllSongs() {
    if (albumSongs.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NowPlayingScreen(
            song: albumSongs[0],
            songList: albumSongs,
            initialIndex: 0,
          ),
        ),
      );
    }
  }

  void _showAddToPlaylistDialog(Song song) {
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

    // Lọc ra các playlist không phải hệ thống và thuộc về người dùng hiện tại
    List<Playlist> userPlaylists = globalPlaylistList
        .where((playlist) =>
            !playlist.isSystem && playlist.userId == currentUserId)
        .toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Thêm vào danh sách phát',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
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
                    title: const Text('Tạo danh sách phát mới'),
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
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Danh sách phát của bạn',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: userPlaylists.isEmpty
                        ? const Center(
                            child: Text('Chưa có danh sách phát nào'),
                          )
                        : ListView.builder(
                            itemCount: userPlaylists.length,
                            itemBuilder: (context, index) {
                              final playlist = userPlaylists[index];
                              return ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    playlist.coverImage,
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                title: Text(playlist.name),
                                subtitle:
                                    Text('${playlist.songIds.length} bài hát'),
                                onTap: () {
                                  if (!playlist.songIds.contains(song.id)) {
                                    setState(() {
                                      playlist.songIds.add(song.id);
                                      // Cập nhật lại playlist trong danh sách toàn cục
                                      final index =
                                          globalPlaylistList.indexWhere(
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
              ),
            );
          },
        );
      },
    );
  }

  void _updateFavoritePlaylist() {
    final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) return;

    // Lấy danh sách các bài hát yêu thích của người dùng hiện tại
    List<Song> favoriteSongs = getFavoriteSongs(currentUserId);
    List<int> favoriteSongIds = favoriteSongs.map((song) => song.id).toList();

    // Tìm và cập nhật playlist "Yêu thích của tôi" trong globalPlaylistList
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

  void _showSongOptions(Song song) {
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

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(
                  isSongFavoriteByUser(song.id, currentUserId)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: isSongFavoriteByUser(song.id, currentUserId)
                      ? Colors.red
                      : const Color(0xFF31C934),
                ),
                title: Text(isSongFavoriteByUser(song.id, currentUserId)
                    ? 'Xóa khỏi yêu thích'
                    : 'Thêm vào yêu thích'),
                onTap: () {
                  setState(() {
                    // Cập nhật trạng thái yêu thích
                    toggleFavorite(song.id, currentUserId);
                    // Cập nhật danh sách phát yêu thích
                    _updateFavoritePlaylist();
                  });

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isSongFavoriteByUser(song.id, currentUserId)
                          ? 'Đã thêm vào danh sách yêu thích'
                          : 'Đã xóa khỏi danh sách yêu thích'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.playlist_add),
                title: const Text('Thêm vào danh sách phát'),
                onTap: () {
                  Navigator.pop(context);
                  _showAddToPlaylistDialog(song);
                },
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Trang cá nhân nghệ sĩ'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArtistProfileScreen(
                        artistName: song.artist,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final audioHandler = Provider.of<AudioPlayerHandler>(context);
    final bool showMiniPlayer = audioHandler.currentSong != null;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                widget.album.coverImage,
                fit: BoxFit.cover,
              ),
            ),
            backgroundColor: const Color(0xFF31C934),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.album.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          artistName,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${albumSongs.length} bài hát',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _playAllSongs,
                    icon: const Icon(
                      Icons.play_circle_filled,
                      color: Color(0xFF31C934),
                      size: 48,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final song = albumSongs[index];
                return ListTile(
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
                    onPressed: () => _showSongOptions(song),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NowPlayingScreen(
                          song: song,
                          songList: albumSongs,
                          initialIndex: index,
                        ),
                      ),
                    );
                  },
                );
              },
              childCount: albumSongs.length,
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
                  MaterialPageRoute(builder: (context) => const SearchScreen()),
                );
              } else if (index == 2) {
                // Mở màn hình yêu thích
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
            selectedItemColor: const Color(0xFF31C934),
            unselectedItemColor: Colors.grey,
          ),
        ],
      ),
    );
  }
}
