import 'package:flutter/material.dart';
import 'package:t4/data/album_list.dart';
import 'package:t4/data/song_list.dart';
import 'package:t4/data/playlist_list.dart';
import 'package:t4/presentation/screen/album_detail_screen.dart';
import 'package:t4/presentation/screen/FavoriteScreen.dart';
import 'package:t4/presentation/screen/search_screen.dart';
import 'package:t4/presentation/screen/playlist_screen.dart';
import 'dart:math';

class AlbumScreen extends StatefulWidget {
  const AlbumScreen({Key? key}) : super(key: key);

  @override
  State<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  int _selectedTabIndex = 1; // Album tab is selected by default

  // Không cần khai báo lại globalPlaylistList ở đây, sử dụng trực tiếp từ playlist_list.dart

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
              const Text(
                'Tất cả Album',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: albumList.length,
                  itemBuilder: (context, index) {
                    final album = albumList[index];
                    // Lấy ra nghệ sĩ từ bài hát đầu tiên trong album
                    String artistName = '';
                    if (album.songIds.isNotEmpty) {
                      int firstSongId = album.songIds[0];
                      Song? firstSong = songList.firstWhere(
                        (song) => song.id == firstSongId,
                        orElse: () => Song(
                          id: 0,
                          title: '',
                          artist: 'Không xác định',
                          coverImage: '',
                          assetPath: '',
                          lyrics: '',
                        ),
                      );
                      artistName = firstSong.artist;
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: _buildAlbumListItem(album, artistName),
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
            // Đã ở màn hình Album, không cần chuyển
          } else if (index == 2) {
            // Chuyển sang màn hình Playlist
            Navigator.pushReplacementNamed(context, '/playlist');
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

  Widget _buildAlbumListItem(Album album, String artistName) {
    return GestureDetector(
      onTap: () {
        // Mở trang chi tiết album khi bấm vào một album
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AlbumDetailScreen(album: album),
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
            // Hình ảnh album
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                image: DecorationImage(
                  image: AssetImage(album.coverImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Thông tin album
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      artistName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      album.name,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${album.songIds.length} bài hát',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Nút thêm vào danh sách phát
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(
                backgroundColor: const Color(0xFF31C934).withOpacity(0.2),
                radius: 20,
                child: IconButton(
                  icon: const Icon(Icons.add, color: Color(0xFF31C934)),
                  onPressed: () {
                    // Kiểm tra xem album đã có trong danh sách phát chưa
                    bool alreadyExists = false;
                    for (var playlist in globalPlaylistList) {
                      if (!playlist.isSystem &&
                          playlist.name == "Album ${album.name}") {
                        alreadyExists = true;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Album ${album.name} đã có trong danh sách phát'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                        break;
                      }
                    }

                    if (!alreadyExists) {
                      // Tạo một playlist mới từ album
                      final timestamp = DateTime.now().millisecondsSinceEpoch;
                      final newId =
                          'playlist_album_${album.name.toLowerCase().replaceAll(' ', '_')}_$timestamp';

                      final newPlaylist = Playlist(
                        id: newId,
                        name: "Album ${album.name}",
                        coverImage: album.coverImage,
                        songIds: List.from(
                            album.songIds), // Tạo bản sao danh sách songIds
                        isSystem: false,
                      );

                      // Thêm vào danh sách toàn cục
                      globalPlaylistList.add(newPlaylist);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Đã thêm album ${album.name} vào danh sách phát'),
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
