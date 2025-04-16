import 'package:flutter/material.dart';
import 'package:t4/data/song_list.dart';
import 'package:t4/data/album_list.dart';
import 'package:t4/data/playlist_list.dart';
import 'package:t4/presentation/screen/now_playing_screen.dart';
import 'package:t4/presentation/screen/album_detail_screen.dart';
import 'package:t4/presentation/screen/ProfileScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:t4/services/audio_player_handler.dart';
import 'package:t4/widgets/mini_player.dart';
import 'package:t4/models/song.dart';
import 'package:t4/models/playlist.dart';
import 'package:t4/models/album.dart';

class SearchHistory {
  final String type; // 'song' hoặc 'album'
  final String title;
  final String artist;
  final String coverImage;
  final String id;

  SearchHistory({
    required this.type,
    required this.title,
    required this.artist,
    required this.coverImage,
    required this.id,
  });

  Map<String, dynamic> toJson() => {
        'type': type,
        'title': title,
        'artist': artist,
        'coverImage': coverImage,
        'id': id,
      };

  factory SearchHistory.fromJson(Map<String, dynamic> json) => SearchHistory(
        type: json['type'],
        title: json['title'],
        artist: json['artist'],
        coverImage: json['coverImage'],
        id: json['id'],
      );
}

class SearchScreen extends StatefulWidget {
  final bool isSelectingSongs;
  final Playlist? targetPlaylist;
  final bool isFavoritePlaylist;

  const SearchScreen({
    Key? key,
    this.isSelectingSongs = false,
    this.targetPlaylist,
    this.isFavoritePlaylist = false,
  }) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Song> _filteredSongs = [];
  List<Album> _filteredAlbums = [];
  List<SearchHistory> _searchHistory = [];
  static const String _searchHistoryKey = 'search_history';
  String _searchQuery = '';
  final List<Song> selectedSongs = [];

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
  }

  Future<void> _loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getStringList(_searchHistoryKey) ?? [];
    setState(() {
      _searchHistory = historyJson
          .map((item) => SearchHistory.fromJson(json.decode(item)))
          .toList();
    });
  }

  Future<void> _saveSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson =
        _searchHistory.map((item) => json.encode(item.toJson())).toList();
    await prefs.setStringList(_searchHistoryKey, historyJson);
  }

  void _addToSearchHistory(SearchHistory item) {
    setState(() {
      // Xóa item cũ nếu đã tồn tại
      _searchHistory.removeWhere(
          (history) => history.type == item.type && history.id == item.id);
      // Thêm item mới vào đầu danh sách
      _searchHistory.insert(0, item);
      // Giới hạn 10 item
      if (_searchHistory.length > 10) {
        _searchHistory.removeLast();
      }
    });
    _saveSearchHistory();
  }

  void _removeFromHistory(SearchHistory item) {
    setState(() {
      _searchHistory.removeWhere(
          (history) => history.type == item.type && history.id == item.id);
    });
    _saveSearchHistory();
  }

  void _filterResults(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredSongs = [];
        _filteredAlbums = [];
      });
      return;
    }

    final lowerQuery = query.toLowerCase();

    final albums = albumList.where((album) {
      return album.name.toLowerCase().contains(lowerQuery);
    }).toList();

    final songs = songList.where((song) {
      return song.title.toLowerCase().contains(lowerQuery) ||
          song.artist.toLowerCase().contains(lowerQuery);
    }).toList();

    setState(() {
      _filteredAlbums = albums;
      _filteredSongs = songs;
    });
  }

  void _onSongTapped(Song song, List<Song> songList, int index) {
    _addToSearchHistory(SearchHistory(
      type: 'song',
      title: song.title,
      artist: song.artist,
      coverImage: song.coverImage,
      id: song.id.toString(),
    ));
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NowPlayingScreen(
          song: song,
          songList: songList,
          initialIndex: index,
        ),
      ),
    );
  }

  void _onAlbumTapped(Album album) {
    // Lấy nghệ sĩ từ bài hát đầu tiên trong album
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

    _addToSearchHistory(SearchHistory(
      type: 'album',
      title: album.name,
      artist: artistName,
      coverImage: album.coverImage,
      id: album.id.toString(),
    ));
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AlbumDetailScreen(album: album),
      ),
    );
  }

  void _onHistoryItemTapped(SearchHistory history) {
    if (history.type == 'song') {
      final song = songList.firstWhere((s) => s.id.toString() == history.id);
      _onSongTapped(song, [song], 0);
    } else {
      final album = albumList.firstWhere((a) => a.id.toString() == history.id);
      _onAlbumTapped(album);
    }
  }

  void _filterSongs() {
    if (_searchQuery.isEmpty) {
      setState(() {
        _filteredSongs = [];
        _filteredAlbums = [];
      });
      return;
    }

    final lowerQuery = _searchQuery.toLowerCase();

    final albums = albumList.where((album) {
      return album.name.toLowerCase().contains(lowerQuery);
    }).toList();

    final songs = songList.where((song) {
      return song.title.toLowerCase().contains(lowerQuery) ||
          song.artist.toLowerCase().contains(lowerQuery);
    }).toList();

    setState(() {
      _filteredAlbums = albums;
      _filteredSongs = songs;
    });
  }

  void _addSongToPlaylist(Song song) {
    if (widget.isFavoritePlaylist) {
      // Thêm vào danh sách yêu thích
      final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
      if (currentUserId != null) {
        toggleFavorite(song.id, currentUserId);
        song.isFavorite = true;

        // Cập nhật playlist yêu thích
        if (widget.targetPlaylist != null) {
          widget.targetPlaylist!.songIds.add(song.id);
          // Cập nhật trong danh sách toàn cục
          for (int i = 0; i < globalPlaylistList.length; i++) {
            if (globalPlaylistList[i].id == widget.targetPlaylist!.id) {
              globalPlaylistList[i] = widget.targetPlaylist!;
              playlistUpdateController.add(null);
              break;
            }
          }
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã thêm "${song.title}" vào danh sách yêu thích'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } else {
      // Thêm vào playlist thường
      if (widget.targetPlaylist != null &&
          !widget.targetPlaylist!.songIds.contains(song.id)) {
        widget.targetPlaylist!.songIds.add(song.id);
        // Cập nhật trong danh sách toàn cục
        for (int i = 0; i < globalPlaylistList.length; i++) {
          if (globalPlaylistList[i].id == widget.targetPlaylist!.id) {
            globalPlaylistList[i] = widget.targetPlaylist!;
            playlistUpdateController.add(null);
            break;
          }
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Đã thêm "${song.title}" vào ${widget.targetPlaylist!.name}'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final audioHandler = Provider.of<AudioPlayerHandler>(context);
    final bool showMiniPlayer = audioHandler.currentSong != null;

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: widget.isSelectingSongs
                ? widget.isFavoritePlaylist
                    ? 'Tìm bài hát để thêm vào yêu thích...'
                    : 'Tìm bài hát để thêm vào playlist...'
                : 'Tìm kiếm bài hát, nghệ sĩ hoặc album...',
            border: InputBorder.none,
            hintStyle: const TextStyle(color: Colors.grey),
          ),
          style: const TextStyle(color: Colors.black),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
              _filterSongs();
            });
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (widget.isSelectingSongs && selectedSongs.isNotEmpty)
            TextButton(
              onPressed: () {
                // Thêm các bài hát đã chọn vào playlist
                for (var song in selectedSongs) {
                  if (!widget.targetPlaylist!.songIds.contains(song.id)) {
                    widget.targetPlaylist!.songIds.add(song.id);
                  }
                }

                // Cập nhật playlist trong danh sách toàn cục
                for (int i = 0; i < globalPlaylistList.length; i++) {
                  if (globalPlaylistList[i].id == widget.targetPlaylist!.id) {
                    globalPlaylistList[i] = widget.targetPlaylist!;
                    playlistUpdateController.add(null);
                    break;
                  }
                }

                // Hiển thị thông báo và quay về
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Đã thêm ${selectedSongs.length} bài hát vào playlist'),
                    duration: const Duration(seconds: 2),
                  ),
                );
                Navigator.pop(context);
              },
              child: Text(
                'Thêm (${selectedSongs.length})',
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              if (_controller.text.isEmpty) ...[
                const Text(
                  'Các tìm kiếm gần đây',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: _searchHistory.isEmpty
                      ? const Center(
                          child: Text('Chưa có lịch sử tìm kiếm'),
                        )
                      : ListView.builder(
                          itemCount: _searchHistory.length,
                          itemBuilder: (context, index) {
                            final history = _searchHistory[index];
                            return ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.asset(
                                  history.coverImage,
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Text(
                                history.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: Text(
                                '${history.type == 'album' ? 'Album • ' : 'Bài hát • '}${history.artist}',
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () => _removeFromHistory(history),
                              ),
                              onTap: () => _onHistoryItemTapped(history),
                            );
                          },
                        ),
                ),
                if (_searchHistory.isNotEmpty)
                  Center(
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _searchHistory.clear();
                        });
                        _saveSearchHistory();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Xóa nội dung tìm kiếm gần đây',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
              ] else if (_filteredAlbums.isNotEmpty ||
                  _filteredSongs.isNotEmpty) ...[
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      if (_filteredAlbums.isNotEmpty) ...[
                        const SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text(
                              'Album',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final album = _filteredAlbums[index];
                              return ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Image.asset(
                                    album.coverImage,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                title: Text(
                                  album.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                    'Album • ${album.songIds.length} bài hát'),
                                onTap: () => _onAlbumTapped(album),
                              );
                            },
                            childCount: _filteredAlbums.length,
                          ),
                        ),
                      ],
                      if (_filteredSongs.isNotEmpty) ...[
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: _filteredAlbums.isNotEmpty ? 20 : 0,
                              bottom: 10,
                            ),
                            child: const Text(
                              'Bài hát',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final song = _filteredSongs[index];
                              final bool isSelected =
                                  selectedSongs.contains(song);
                              final bool isInPlaylist =
                                  widget.targetPlaylist != null &&
                                      widget.targetPlaylist!.songIds
                                          .contains(song.id);

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
                                  ),
                                ),
                                subtitle: Text(song.artist),
                                trailing: widget.isSelectingSongs
                                    ? IconButton(
                                        icon: Icon(
                                          widget.isFavoritePlaylist
                                              ? (song.isFavorite
                                                  ? Icons.favorite
                                                  : Icons.favorite_border)
                                              : (isInPlaylist
                                                  ? Icons.check_circle
                                                  : Icons.add_circle_outline),
                                          color: widget.isFavoritePlaylist
                                              ? (song.isFavorite
                                                  ? Colors.red
                                                  : Colors.grey)
                                              : (isInPlaylist
                                                  ? Colors.green
                                                  : Colors.grey),
                                        ),
                                        onPressed: () {
                                          if (!isInPlaylist) {
                                            _addSongToPlaylist(song);
                                          }
                                        },
                                      )
                                    : null,
                                onTap: () {
                                  if (widget.isSelectingSongs) {
                                    if (!isInPlaylist) {
                                      _addSongToPlaylist(song);
                                    }
                                  } else {
                                    _onSongTapped(song, _filteredSongs, index);
                                  }
                                },
                              );
                            },
                            childCount: _filteredSongs.length,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ] else ...[
                const Expanded(
                  child: Center(
                    child: Text('Không tìm thấy kết quả'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
            currentIndex: 1, // Tab search được chọn
            onTap: (index) {
              if (index == 0) {
                // Về home
                Navigator.pushReplacementNamed(context, '/home');
              } else if (index == 2) {
                // Mở profile
                Navigator.pushNamed(context, '/profile');
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
