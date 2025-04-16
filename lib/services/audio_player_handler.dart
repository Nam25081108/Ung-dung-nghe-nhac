import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/recently_played.dart';
import '../models/song.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../data/song_list.dart';

class AudioPlayerHandler with ChangeNotifier {
  AudioPlayer _player = AudioPlayer();
  Song? _currentSong;
  List<Song> _currentSongList = [];
  int _currentIndex = 0;
  bool _isRepeatEnabled = false;
  bool _isShuffleEnabled = false;

  Duration _currentPosition = Duration.zero;
  Duration _duration = Duration.zero;
  bool _isPlaying = false;

  AudioPlayer get player => _player;
  Song? get currentSong => _currentSong;
  List<Song> get currentSongList => _currentSongList;
  int get currentIndex => _currentIndex;
  bool get isRepeatEnabled => _isRepeatEnabled;
  bool get isShuffleEnabled => _isShuffleEnabled;

  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  AudioPlayerHandler() {
    _initializePlayer();
  }

  void _initializePlayer() {
    _player.positionStream.listen((position) {
      _currentPosition = position;
      notifyListeners();
    });

    _player.durationStream.listen((duration) {
      if (duration != null) {
        _duration = duration;
        notifyListeners();
      }
    });

    _player.playerStateStream.listen((state) {
      _isPlaying = state.playing;
      notifyListeners();
    });

    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        if (_isRepeatEnabled) {
          _player.seek(Duration.zero);
          _player.play();
        } else if (_currentIndex < _currentSongList.length - 1 ||
            _isShuffleEnabled) {
          playNextSong();
        } else {
          _player.seek(Duration.zero);
          _player.pause();
        }
      }
    });
  }

  void reinitialize() {
    _player.dispose();
    _player = AudioPlayer();
    _currentSong = null;
    _currentSongList = [];
    _currentIndex = 0;
    _isRepeatEnabled = false;
    _isShuffleEnabled = false;
    _currentPosition = Duration.zero;
    _duration = Duration.zero;
    _isPlaying = false;
    _initializePlayer();
    notifyListeners();
  }

  Future<void> playSong(Song song,
      {List<Song>? songList, int? initialIndex}) async {
    try {
      if (songList != null) {
        _currentSongList = List<Song>.from(songList);
      } else if (_currentSongList.isEmpty) {
        _currentSongList = [song];
      }

      if (initialIndex != null) {
        _currentIndex = initialIndex;
      } else {
        _currentIndex = _currentSongList.indexOf(song);
        if (_currentIndex < 0) _currentIndex = 0;
      }

      _currentSong = song;
      await _player.setAsset(song.assetPath);
      await _player.play();

      final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
      if (currentUserId != null) {
        addToRecentlyPlayed(song.id, currentUserId);
        updateRecentlyPlayedPlaylist(currentUserId);
      }

      notifyListeners();
    } catch (e) {
      print('Lỗi khi tải file audio: $e');
    }
  }

  Future<void> seekTo(Duration position) async {
    await _player.seek(position);
  }

  Future<void> playNextSong() async {
    if (_currentSongList.isEmpty || _currentSong == null) return;

    int nextIndex;
    if (_isShuffleEnabled) {
      nextIndex = _getRandomIndex();
    } else {
      nextIndex = (_currentIndex + 1) % _currentSongList.length;
    }

    _currentIndex = nextIndex;
    await playSong(_currentSongList[_currentIndex]);
  }

  Future<void> playPreviousSong() async {
    if (_currentSongList.isEmpty || _currentSong == null) return;

    int prevIndex;
    if (_isShuffleEnabled) {
      prevIndex = _getRandomIndex();
    } else {
      prevIndex = (_currentIndex - 1 + _currentSongList.length) %
          _currentSongList.length;
    }

    _currentIndex = prevIndex;
    await playSong(_currentSongList[_currentIndex]);
  }

  int _getRandomIndex() {
    if (_currentSongList.length <= 1) return 0;
    int randomIndex = _currentIndex;
    while (randomIndex == _currentIndex) {
      randomIndex =
          DateTime.now().millisecondsSinceEpoch % _currentSongList.length;
    }
    return randomIndex;
  }

  void toggleRepeat() {
    _isRepeatEnabled = !_isRepeatEnabled;
    notifyListeners();
  }

  void toggleShuffle() {
    _isShuffleEnabled = !_isShuffleEnabled;
    notifyListeners();
  }

  void togglePlayPause() {
    if (_player.playing) {
      _player.pause();
    } else {
      _player.play();
    }
    notifyListeners();
  }

  void disposePlayer() {
    _player.dispose();
  }

  // Lưu trạng thái phát nhạc cho user hiện tại
  Future<void> savePlaybackState() async {
    if (_currentSong == null) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final prefs = await SharedPreferences.getInstance();
    final playbackState = {
      'songId': _currentSong!.id,
      'position': _currentPosition.inMilliseconds,
      'isPlaying': _isPlaying,
      'isRepeatEnabled': _isRepeatEnabled,
      'isShuffleEnabled': _isShuffleEnabled,
      'songList': _currentSongList.map((song) => song.id).toList(),
      'currentIndex': _currentIndex,
    };

    // Lưu với key riêng cho từng user
    await prefs.setString(
        'playback_state_${user.uid}', jsonEncode(playbackState));
  }

  // Khôi phục trạng thái phát nhạc của user hiện tại
  Future<void> restorePlaybackState() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final prefs = await SharedPreferences.getInstance();
      final stateString = prefs.getString('playback_state_${user.uid}');

      if (stateString == null) return;

      final state = jsonDecode(stateString) as Map<String, dynamic>;

      // Khôi phục danh sách phát và bài hát hiện tại
      final List<int> songIds = (state['songList'] as List).cast<int>();
      final List<Song> restoredSongList = songIds
          .map((id) => songList.firstWhere((song) => song.id == id))
          .toList();

      final currentSong =
          restoredSongList.firstWhere((song) => song.id == state['songId']);

      // Khởi tạo lại player trước khi phát
      await _player.dispose();
      _player = AudioPlayer();

      // Cập nhật trạng thái
      _currentSongList = restoredSongList;
      _currentIndex = state['currentIndex'] as int;
      _currentSong = currentSong;
      _isRepeatEnabled = state['isRepeatEnabled'] as bool;
      _isShuffleEnabled = state['isShuffleEnabled'] as bool;
      _isPlaying = false; // Đặt trạng thái là tạm dừng

      // Khởi tạo lại các listeners
      _initializePlayer();

      // Thiết lập và phát nhạc
      try {
        await _player.setAsset(currentSong.assetPath);
        await _player.seek(Duration(milliseconds: state['position'] as int));
        await _player.pause(); // Đảm bảo nhạc ở trạng thái tạm dừng
      } catch (e) {
        print('Lỗi khi phát nhạc: $e');
      }

      notifyListeners();
    } catch (e) {
      print('Lỗi khi khôi phục trạng thái phát nhạc: $e');
    }
  }

  // Xóa trạng thái phát nhạc khi đăng xuất
  Future<void> clearPlaybackState() async {
    _player.dispose();
    _player = AudioPlayer();
    _currentSong = null;
    _currentSongList = [];
    _currentIndex = 0;
    _isRepeatEnabled = false;
    _isShuffleEnabled = false;
    _currentPosition = Duration.zero;
    _duration = Duration.zero;
    _isPlaying = false;
    _initializePlayer();
    notifyListeners();
  }

  @override
  void dispose() {
    savePlaybackState(); // Lưu trạng thái trước khi dispose
    _player.dispose();
    super.dispose();
  }
}
