import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/recently_played.dart';
import '../models/song.dart';

class AudioPlayerHandler with ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();
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
          _player.setAsset(_currentSong!.assetPath).then((_) {
            _player.play();
          });
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

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
