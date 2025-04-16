import 'package:flutter/material.dart';
import 'package:t4/data/song_list.dart';
import 'package:t4/data/album_list.dart';
import 'package:t4/presentation/screen/now_playing_screen.dart';
import 'package:t4/presentation/screen/album_detail_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:t4/data/playlist_list.dart';
import 'package:t4/data/playlist_controller.dart' as playlist_controller;
import 'package:t4/presentation/screen/home_screen.dart';
import 'package:t4/presentation/screen/search_screen.dart';
import 'package:provider/provider.dart';
import 'package:t4/services/audio_player_handler.dart';
import 'package:t4/widgets/mini_player.dart';
import 'package:t4/models/song.dart';
import 'package:t4/models/playlist.dart';
import 'package:t4/models/album.dart';
import 'package:t4/presentation/screen/ProfileScreen.dart';

class ArtistProfileScreen extends StatefulWidget {
  final String artistName;

  const ArtistProfileScreen({Key? key, required this.artistName})
      : super(key: key);

  @override
  State<ArtistProfileScreen> createState() => _ArtistProfileScreenState();
}

class _ArtistProfileScreenState extends State<ArtistProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<Song> artistSongs;
  late List<Album> artistAlbums;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadArtistContent();
  }

  void _loadArtistContent() {
    // Lấy tất cả bài hát của nghệ sĩ
    artistSongs = songList
        .where((song) =>
            song.artist.toLowerCase() == widget.artistName.toLowerCase())
        .toList();

    // Lấy tất cả album có bài hát của nghệ sĩ
    artistAlbums = albumList.where((album) {
      bool hasArtistSong = false;
      for (var songId in album.songIds) {
        final song = songList.firstWhere((s) => s.id == songId);
        if (song.artist.toLowerCase() == widget.artistName.toLowerCase()) {
          hasArtistSong = true;
          break;
        }
      }
      return hasArtistSong;
    }).toList();
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

    // Lọc ra các playlist của người dùng
    List<Playlist> userPlaylists = globalPlaylistList
        .where((playlist) =>
            !playlist.isSystem &&
            playlist.userId == currentUserId &&
            playlist.id != 'playlist_my_favorites')
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
                                  playlist_controller.playlistUpdateController
                                      .notifyPlaylistsUpdated();

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
                                  playlist_controller.playlistUpdateController
                                      .notifyPlaylistsUpdated();
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
                int index = artistSongs.indexOf(song);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NowPlayingScreen(
                      song: song,
                      songList: artistSongs,
                      initialIndex: index,
                    ),
                  ),
                );
              },
            ),

            // Thêm/Xóa khỏi yêu thích
            ListTile(
              leading: Icon(
                song.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: song.isFavorite ? Colors.red : Colors.white,
              ),
              title: Text(
                song.isFavorite ? 'Xóa khỏi yêu thích' : 'Thêm vào yêu thích',
                style: const TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                final String? currentUserId =
                    FirebaseAuth.instance.currentUser?.uid;
                if (currentUserId != null) {
                  setState(() {
                    toggleFavorite(song.id, currentUserId);
                    song.isFavorite = !song.isFavorite;

                    // Tìm playlist yêu thích
                    final favoritePlaylist = globalPlaylistList.firstWhere(
                      (playlist) => playlist.id == 'playlist_my_favorites',
                    );

                    if (song.isFavorite) {
                      // Thêm vào danh sách yêu thích
                      if (!favoritePlaylist.songIds.contains(song.id)) {
                        favoritePlaylist.songIds.add(song.id);
                      }
                    } else {
                      // Xóa khỏi danh sách yêu thích
                      favoritePlaylist.songIds.remove(song.id);
                    }

                    // Thông báo cập nhật
                    playlist_controller.playlistUpdateController
                        .notifyPlaylistsUpdated();
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        song.isFavorite
                            ? 'Đã thêm "${song.title}" vào yêu thích'
                            : 'Đã xóa "${song.title}" khỏi yêu thích',
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('Vui lòng đăng nhập để sử dụng tính năng này'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),

            // Thêm vào danh sách phát
            ListTile(
              leading: const Icon(Icons.playlist_add, color: Colors.white),
              title: const Text('Thêm vào danh sách phát',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _showAddToOtherPlaylistDialog(song);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final audioHandler = Provider.of<AudioPlayerHandler>(context);
    final bool showMiniPlayer = audioHandler.currentSong != null;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    artistSongs.isNotEmpty
                        ? artistSongs[0].coverImage
                        : 'assets/images/default_artist.jpg',
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
                  Positioned(
                    left: 20,
                    bottom: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.artistName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${artistSongs.length} bài hát • ${artistAlbums.length} album',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPersistentHeader(
            delegate: _SliverAppBarDelegate(
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Bài hát'),
                  Tab(text: 'Album'),
                ],
                labelColor: const Color(0xFF31C934),
                unselectedLabelColor: Colors.grey,
                indicatorColor: const Color(0xFF31C934),
              ),
            ),
            pinned: true,
          ),
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Tab Bài hát
                ListView.builder(
                  padding: const EdgeInsets.all(0),
                  itemCount: artistSongs.length,
                  itemBuilder: (context, index) {
                    final song = artistSongs[index];
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
                        icon: const Icon(Icons.more_vert, color: Colors.grey),
                        onPressed: () => _showSongOptions(song),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NowPlayingScreen(
                              song: song,
                              songList: artistSongs,
                              initialIndex: index,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                // Tab Album
                GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: artistAlbums.length,
                  itemBuilder: (context, index) {
                    final album = artistAlbums[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AlbumDetailScreen(album: album),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: AssetImage(album.coverImage),
                                  fit: BoxFit.cover,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            album.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${album.songIds.length} bài hát',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
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
            currentIndex: 0,
            selectedItemColor: const Color(0xFF31C934),
            unselectedItemColor: Colors.grey,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            type: BottomNavigationBarType.fixed,
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
            onTap: (index) {
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
              } else if (index == 2) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileScreen()),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
