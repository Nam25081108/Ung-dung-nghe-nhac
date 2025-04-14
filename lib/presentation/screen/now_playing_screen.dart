import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:t4/data/song_list.dart';
import 'package:t4/data/playlist_list.dart';
import 'package:t4/presentation/screen/lyric_screen.dart';
import 'package:t4/data/user_settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:t4/presentation/screen/artist_profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:t4/services/audio_player_handler.dart';
import 'package:t4/models/song.dart';
import 'package:t4/models/playlist.dart';

class NowPlayingScreen extends StatefulWidget {
  final Song song;
  final List<Song> songList;
  final int initialIndex;

  const NowPlayingScreen({
    Key? key,
    required this.song,
    required this.songList,
    required this.initialIndex,
  }) : super(key: key);

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> {
  late AudioPlayerHandler _audioHandler;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = const Duration(seconds: 100); // default ban đầu
  bool _isPlaying = false;
  bool _isAddedToPlaylist = false; // Trạng thái đã thêm vào danh sách phát chưa

  @override
  void initState() {
    super.initState();

    // Các hàm khởi tạo khác sẽ được chuyển vào didChangeDependencies
    // vì cần access Provider
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Lấy AudioPlayerHandler từ Provider
    _audioHandler = Provider.of<AudioPlayerHandler>(context);

    // Khởi tạo với bài hát hiện tại nếu khác với bài đang phát
    if (_audioHandler.currentSong?.id != widget.song.id) {
      _initPlayer();
    }

    // Lắng nghe các sự kiện
    _setupStreams();
  }

  void _initPlayer() {
    _audioHandler.playSong(widget.song,
        songList: widget.songList, initialIndex: widget.initialIndex);

    setState(() {
      _isPlaying = true;
    });
  }

  void _setupStreams() {
    // Lắng nghe vị trí phát hiện tại
    _audioHandler.positionStream.listen((position) {
      setState(() {
        _currentPosition = position;
      });
    });

    // Lắng nghe tổng thời gian bài hát
    _audioHandler.durationStream.listen((duration) {
      if (duration != null) {
        setState(() {
          _totalDuration = duration;
        });
      }
    });

    // Lắng nghe trạng thái playing/paused
    _audioHandler.playerStateStream.listen((state) {
      setState(() {
        _isPlaying = state.playing;
      });
    });
  }

  void _playNextSong() {
    _audioHandler.playNextSong();
    setState(() {
      _isAddedToPlaylist = false;
    });
  }

  void _playPreviousSong() {
    _audioHandler.playPreviousSong();
    setState(() {
      _isAddedToPlaylist = false;
    });
  }

  void _togglePlay() {
    _audioHandler.togglePlayPause();
  }

  void _toggleRepeat() {
    _audioHandler.toggleRepeat();

    // Lưu cài đặt người dùng
    final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId != null) {
      UserSettings settings = getUserSettings(currentUserId);
      settings.repeatByDefault = _audioHandler.isRepeatEnabled;
      updateUserSettings(settings);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_audioHandler.isRepeatEnabled
            ? 'Đã bật lặp lại'
            : 'Đã tắt lặp lại'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _toggleShuffle() {
    _audioHandler.toggleShuffle();

    // Lưu cài đặt người dùng
    final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId != null) {
      UserSettings settings = getUserSettings(currentUserId);
      settings.shuffleByDefault = _audioHandler.isShuffleEnabled;
      updateUserSettings(settings);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_audioHandler.isShuffleEnabled
            ? 'Đã bật phát ngẫu nhiên'
            : 'Đã tắt phát ngẫu nhiên'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _showAddToPlaylistDialog() {
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

    // Lọc ra các playlist không phải hệ thống và thuộc về người dùng hiện tại
    List<Playlist> userPlaylists = globalPlaylistList
        .where((playlist) =>
            !playlist.isSystem && playlist.userId == currentUserId)
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
                                    coverImage: widget.song.coverImage,
                                    songIds: [widget.song.id],
                                    isSystem: false,
                                    userId: currentUserId,
                                  );

                                  // Thêm vào danh sách toàn cục
                                  globalPlaylistList.add(newPlaylist);

                                  // Đóng cả 2 dialog
                                  Navigator.pop(
                                      context); // Đóng dialog tạo playlist
                                  Navigator.pop(context); // Đóng bottom sheet

                                  setState(() {
                                    _isAddedToPlaylist = true;
                                  });

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
                            if (!playlist.songIds.contains(widget.song.id)) {
                              setState(() {
                                playlist.songIds.add(widget.song.id);
                                // Cập nhật lại playlist trong danh sách toàn cục
                                final index = globalPlaylistList.indexWhere(
                                  (p) => p.id == playlist.id,
                                );
                                if (index != -1) {
                                  globalPlaylistList[index] = playlist;
                                }
                                _isAddedToPlaylist = true;
                              });

                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Đã thêm "${widget.song.title}" vào ${playlist.name}',
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

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(duration.inMinutes)}:${twoDigits(duration.inSeconds % 60)}";
  }

  void _toggleFavorite(Song song) {
    final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) {
      // Nếu chưa đăng nhập, hiển thị thông báo
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng đăng nhập để sử dụng tính năng này'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      // Cập nhật trạng thái yêu thích
      bool isFavorite = isSongFavoriteByUser(song.id, currentUserId);

      // Thêm/xóa khỏi danh sách yêu thích
      toggleFavorite(song.id, currentUserId);

      // Cập nhật trạng thái hiển thị
      song.isFavorite = !isFavorite;

      // Cập nhật danh sách phát yêu thích
      _updateFavoritePlaylist();
    });

    // Hiển thị thông báo
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(song.isFavorite
            ? 'Đã thêm vào danh sách yêu thích'
            : 'Đã xóa khỏi danh sách yêu thích'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // Thêm phương thức để cập nhật danh sách phát yêu thích
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    'Đang Phát',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _isAddedToPlaylist
                          ? Icons.check_circle
                          : Icons.add_circle,
                      color: _isAddedToPlaylist
                          ? const Color(0xFF31C934)
                          : Colors.white,
                    ),
                    onPressed: _showAddToPlaylistDialog,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Album image và song info
              StreamBuilder<PlayerState>(
                  stream: _audioHandler.playerStateStream,
                  builder: (context, snapshot) {
                    final currentSong =
                        _audioHandler.currentSong ?? widget.song;
                    return Expanded(
                      child: Column(
                        children: [
                          // Album image
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    spreadRadius: 5,
                                    blurRadius: 15,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                                image: DecorationImage(
                                  image: AssetImage(currentSong.coverImage),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),

                          // Song info
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ArtistProfileScreen(
                                              artistName: currentSong.artist,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        currentSong.title,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ArtistProfileScreen(
                                              artistName: currentSong.artist,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        currentSong.artist,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey[600],
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () => _toggleFavorite(currentSong),
                                icon: Icon(
                                  currentSong.isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: currentSong.isFavorite
                                      ? Colors.red
                                      : Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),

              // Slider
              StreamBuilder<Duration>(
                  stream: _audioHandler.positionStream,
                  builder: (context, positionSnapshot) {
                    final position = positionSnapshot.data ?? Duration.zero;
                    return StreamBuilder<Duration?>(
                        stream: _audioHandler.durationStream,
                        builder: (context, durationSnapshot) {
                          final duration = durationSnapshot.data ??
                              const Duration(seconds: 100);
                          return Column(
                            children: [
                              Slider(
                                value: position.inSeconds
                                    .toDouble()
                                    .clamp(0.0, duration.inSeconds.toDouble()),
                                min: 0,
                                max: duration.inSeconds.toDouble(),
                                activeColor: const Color(0xFF31C934),
                                inactiveColor: Colors.grey.shade800,
                                onChanged: (value) {
                                  final newPosition =
                                      Duration(seconds: value.toInt());
                                  _audioHandler.seekTo(newPosition);
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _formatDuration(position),
                                      style: const TextStyle(
                                          color: Colors.grey, fontSize: 12),
                                    ),
                                    Text(
                                      _formatDuration(duration),
                                      style: const TextStyle(
                                          color: Colors.grey, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        });
                  }),
              const SizedBox(height: 20),

              // Controls
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Shuffle button
                  StreamBuilder<bool>(
                    stream: Stream.value(_audioHandler.isShuffleEnabled),
                    builder: (context, snapshot) {
                      final isShuffleEnabled = snapshot.data ?? false;
                      return IconButton(
                        icon: Icon(
                          Icons.shuffle,
                          color: isShuffleEnabled
                              ? const Color(0xFF31C934)
                              : Colors.white,
                        ),
                        onPressed: _toggleShuffle,
                      );
                    },
                  ),
                  // Previous button
                  IconButton(
                    icon: const Icon(Icons.skip_previous,
                        color: Colors.white, size: 36),
                    onPressed: () {
                      _audioHandler.playPreviousSong();
                      setState(() {
                        _isAddedToPlaylist = false;
                      });
                    },
                  ),
                  // Play/Pause button
                  Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF31C934),
                    ),
                    child: StreamBuilder<PlayerState>(
                      stream: _audioHandler.playerStateStream,
                      builder: (context, snapshot) {
                        final playing = snapshot.data?.playing ?? false;
                        return IconButton(
                          icon: Icon(
                            playing ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                            size: 32,
                          ),
                          onPressed: () => _audioHandler.togglePlayPause(),
                        );
                      },
                    ),
                  ),
                  // Next button
                  IconButton(
                    icon: const Icon(Icons.skip_next,
                        color: Colors.white, size: 36),
                    onPressed: () {
                      _audioHandler.playNextSong();
                      setState(() {
                        _isAddedToPlaylist = false;
                      });
                    },
                  ),
                  // Repeat button
                  StreamBuilder<bool>(
                    stream: Stream.value(_audioHandler.isRepeatEnabled),
                    builder: (context, snapshot) {
                      final isRepeatEnabled = snapshot.data ?? false;
                      return IconButton(
                        icon: Icon(
                          Icons.repeat,
                          color: isRepeatEnabled
                              ? const Color(0xFF31C934)
                              : Colors.white,
                        ),
                        onPressed: _toggleRepeat,
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Nút xem lời bài hát
              StreamBuilder<PlayerState>(
                  stream: _audioHandler.playerStateStream,
                  builder: (context, snapshot) {
                    final currentSong =
                        _audioHandler.currentSong ?? widget.song;
                    return Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => LyricsScreen(song: currentSong),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.grey.shade900,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text('Lời bài hát'),
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
