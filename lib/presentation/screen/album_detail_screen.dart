import 'package:flutter/material.dart';
import 'package:t4/data/album_list.dart';
import 'package:t4/data/song_list.dart';
import 'package:t4/presentation/screen/now_playing_screen.dart';
import 'package:t4/presentation/screen/FavoriteScreen.dart';
import 'package:t4/presentation/screen/search_screen.dart';

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

  @override
  Widget build(BuildContext context) {
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
                      IconButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Đã thêm album ${widget.album.name} vào danh sách phát'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
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
                    onPressed: () {
                      // Hiển thị menu tùy chọn
                    },
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
}
