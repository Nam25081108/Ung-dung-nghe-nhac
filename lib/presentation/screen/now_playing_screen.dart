import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:t4/data/song_list.dart';
import 'package:t4/presentation/screen/lyric_screen.dart';
import 'package:t4/data/playlist_list.dart';
import 'dart:math';

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
  late AudioPlayer _audioPlayer;
  late Song _currentSong;
  late int _currentIndex;

  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = const Duration(seconds: 100); // default ban đầu
  bool _isPlaying = false;
  bool _isAddedToPlaylist = false; // Trạng thái đã thêm vào danh sách phát chưa

  // Thêm trạng thái cho lặp lại và phát ngẫu nhiên
  bool _isRepeatEnabled = false;
  bool _isShuffleEnabled = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _currentIndex = widget.initialIndex;
    _currentSong = widget.song;
    _initializePlayer(_currentSong.assetPath);

    // Nghe sự kiện thời lượng và vị trí
    _audioPlayer.positionStream.listen((position) {
      setState(() {
        _currentPosition = position;
      });
    });
    _audioPlayer.durationStream.listen((duration) {
      if (duration != null) {
        setState(() {
          _totalDuration = duration;
        });
      }
    });

    // Nghe sự kiện kết thúc bài hát để phát bài tiếp theo
    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        if (_isRepeatEnabled) {
          // Nếu lặp lại được bật, phát lại bài hiện tại
          _audioPlayer.seek(Duration.zero);
          _audioPlayer.play();
        } else {
          // Nếu không, chuyển sang bài tiếp theo
          _playNextSong();
        }
      }
    });
  }

  Future<void> _initializePlayer(String assetPath) async {
    try {
      await _audioPlayer.setAsset(assetPath);
      _audioPlayer.play();
      setState(() {
        _isPlaying = true;
      });
    } catch (e) {
      print('Lỗi khi tải file audio: $e');
    }
  }

  void _playNextSong() {
    if (_isShuffleEnabled) {
      // Nếu phát ngẫu nhiên được bật, chọn một bài ngẫu nhiên từ danh sách
      final Random random = Random();
      // Tránh phát lại bài hiện tại khi chọn ngẫu nhiên
      int nextIndex;
      do {
        nextIndex = random.nextInt(widget.songList.length);
      } while (nextIndex == _currentIndex && widget.songList.length > 1);

      _currentIndex = nextIndex;
    } else {
      // Nếu không, phát bài tiếp theo trong danh sách
      _currentIndex = (_currentIndex + 1) % widget.songList.length;
    }

    _currentSong = widget.songList[_currentIndex];
    _initializePlayer(_currentSong.assetPath);
    // Cập nhật lại trạng thái khi chuyển bài
    setState(() {
      _isAddedToPlaylist = false;
    });
  }

  void _playPreviousSong() {
    if (_isShuffleEnabled) {
      // Nếu phát ngẫu nhiên được bật, chọn một bài ngẫu nhiên
      final Random random = Random();
      int prevIndex;
      do {
        prevIndex = random.nextInt(widget.songList.length);
      } while (prevIndex == _currentIndex && widget.songList.length > 1);

      _currentIndex = prevIndex;
    } else {
      // Nếu không, phát bài trước đó
      _currentIndex =
          (_currentIndex - 1 + widget.songList.length) % widget.songList.length;
    }

    _currentSong = widget.songList[_currentIndex];
    _initializePlayer(_currentSong.assetPath);
    // Cập nhật lại trạng thái khi chuyển bài
    setState(() {
      _isAddedToPlaylist = false;
    });
  }

  void _togglePlay() {
    if (_isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _toggleRepeat() {
    setState(() {
      _isRepeatEnabled = !_isRepeatEnabled;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isRepeatEnabled ? 'Đã bật lặp lại' : 'Đã tắt lặp lại'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _toggleShuffle() {
    setState(() {
      _isShuffleEnabled = !_isShuffleEnabled;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isShuffleEnabled
            ? 'Đã bật phát ngẫu nhiên'
            : 'Đã tắt phát ngẫu nhiên'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _showAddToPlaylistDialog() {
    if (_isAddedToPlaylist) {
      // Nếu đã thêm vào danh sách phát, không làm gì cả
      return;
    }

    // Lọc ra các playlist không phải hệ thống
    List<Playlist> userPlaylists =
        globalPlaylistList.where((playlist) => !playlist.isSystem).toList();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thêm vào danh sách phát'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: userPlaylists.isEmpty
              ? const Center(child: Text('Chưa có danh sách phát nào'))
              : ListView.builder(
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
                        // Thêm bài hát vào playlist
                        if (!playlist.songIds.contains(_currentSong.id)) {
                          playlist.songIds.add(_currentSong.id);

                          // Cập nhật lại playlist trong danh sách toàn cục
                          for (int i = 0; i < globalPlaylistList.length; i++) {
                            if (globalPlaylistList[i].id == playlist.id) {
                              globalPlaylistList[i] = playlist;
                              break;
                            }
                          }

                          setState(() {
                            _isAddedToPlaylist = true;
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Đã thêm "${_currentSong.title}" vào danh sách phát "${playlist.name}"'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                          
                          // Đóng dialog sau khi thêm thành công
                          Navigator.pop(context);
                        } else {
                          // Nếu bài hát đã có trong playlist
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Bài hát "${_currentSong.title}" đã có trong danh sách phát này'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
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

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(duration.inMinutes)}:${twoDigits(duration.inSeconds % 60)}";
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
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
              const SizedBox(height: 40),

              // Album image
              Expanded(
                child: Center(
                  child: Container(
                    width: double.infinity,
                    height: 350,
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
                        image: AssetImage(_currentSong.coverImage),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Song info
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _currentSong.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _currentSong.artist,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      final wasFavorite = _currentSong.isFavorite;
                      setState(() {
                        _currentSong.isFavorite = !wasFavorite;
                        widget.songList[_currentIndex].isFavorite =
                            _currentSong.isFavorite;
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            wasFavorite
                                ? 'Đã xoá khỏi yêu thích'
                                : 'Đã thêm vào yêu thích',
                          ),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    icon: Icon(
                      _currentSong.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color:
                          _currentSong.isFavorite ? Colors.red : Colors.white,
                    ),
                  ),
                ],
              ),

              // Slider
              Slider(
                value: _currentPosition.inSeconds
                    .toDouble()
                    .clamp(0.0, _totalDuration.inSeconds.toDouble()),
                min: 0,
                max: _totalDuration.inSeconds.toDouble(),
                activeColor: const Color(0xFF31C934),
                inactiveColor: Colors.grey.shade800,
                onChanged: (value) {
                  final position = Duration(seconds: value.toInt());
                  _audioPlayer.seek(position);
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDuration(_currentPosition),
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    Text(
                      _formatDuration(_totalDuration),
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Controls
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.shuffle,
                      color: _isShuffleEnabled
                          ? const Color(0xFF31C934)
                          : Colors.white,
                    ),
                    onPressed: _toggleShuffle,
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_previous,
                        color: Colors.white, size: 36),
                    onPressed: _playPreviousSong,
                  ),
                  Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF31C934),
                    ),
                    child: IconButton(
                      icon: Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: 32,
                      ),
                      onPressed: _togglePlay,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_next,
                        color: Colors.white, size: 36),
                    onPressed: _playNextSong,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.repeat,
                      color: _isRepeatEnabled
                          ? const Color(0xFF31C934)
                          : Colors.white,
                    ),
                    onPressed: _toggleRepeat,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Nút xem lời bài hát
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LyricsScreen(song: _currentSong),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
