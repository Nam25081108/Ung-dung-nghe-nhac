import 'package:t4/models/playlist.dart';
import 'package:t4/models/recently.dart';
import 'package:t4/models/song.dart';
import 'package:t4/data/playlist_list.dart';
import 'package:t4/data/song_list.dart';

// Danh sách lưu trữ lịch sử phát nhạc
List<RecentlyPlayed> recentlyPlayedList = [];

// Thêm một bài hát vào lịch sử phát gần đây
void addToRecentlyPlayed(int songId, String userId) {
  // Loại bỏ bài hát cũ (nếu đã tồn tại) trước khi thêm mới
  recentlyPlayedList.removeWhere(
      (history) => history.songId == songId && history.userId == userId);

  // Thêm bài hát vào lịch sử với thời gian hiện tại
  recentlyPlayedList.add(RecentlyPlayed(
    userId: userId,
    songId: songId,
    playedAt: DateTime.now(),
  ));

  // Giới hạn số lượng bài hát lưu trữ cho mỗi người dùng (nếu cần)
  const int maxHistoryPerUser = 20;
  List<RecentlyPlayed> userHistory =
      recentlyPlayedList.where((history) => history.userId == userId).toList();

  if (userHistory.length > maxHistoryPerUser) {
    // Sắp xếp theo thời gian mới nhất -> cũ nhất
    userHistory.sort((a, b) => b.playedAt.compareTo(a.playedAt));

    // Lấy danh sách ID bài hát cần xóa (quá số lượng tối đa)
    List<int> songIdsToRemove = userHistory
        .sublist(maxHistoryPerUser)
        .map((history) => history.songId)
        .toList();

    // Xóa các bài hát cũ khỏi lịch sử
    recentlyPlayedList.removeWhere((history) =>
        history.userId == userId && songIdsToRemove.contains(history.songId));
  }
}

// Lấy danh sách các bài hát đã phát gần đây của người dùng
List<Song> getRecentlyPlayedSongs(String userId) {
  // Lấy danh sách ID bài hát đã phát gần đây của người dùng
  List<RecentlyPlayed> userHistory =
      recentlyPlayedList.where((history) => history.userId == userId).toList();

  // Sắp xếp theo thời gian mới nhất -> cũ nhất
  userHistory.sort((a, b) => b.playedAt.compareTo(a.playedAt));

  // Lấy danh sách ID bài hát
  List<int> recentSongIds =
      userHistory.map((history) => history.songId).toList();

  // Lọc danh sách bài hát theo ID và giữ nguyên thứ tự đã phát
  List<Song> result = [];
  for (int id in recentSongIds) {
    Song? song =
        songList.firstWhere((s) => s.id == id, orElse: () => null as Song);
    result.add(song);
  }

  return result;
}

// Cập nhật Playlist "Đã phát gần đây" của người dùng
void updateRecentlyPlayedPlaylist(String userId) {
  // Lấy danh sách bài hát đã phát gần đây
  List<Song> recentSongs = getRecentlyPlayedSongs(userId);
  List<int> recentSongIds = recentSongs.map((song) => song.id).toList();

  // Tìm và cập nhật playlist "Đã phát gần đây" trong globalPlaylistList
  bool hasPersonalRecents = false;
  int existingRecentsIndex = -1;

  for (int i = 0; i < globalPlaylistList.length; i++) {
    if (globalPlaylistList[i].id == 'playlist_recently_played' &&
        globalPlaylistList[i].userId == userId) {
      hasPersonalRecents = true;
      existingRecentsIndex = i;
      break;
    }
  }

  if (hasPersonalRecents) {
    // Cập nhật danh sách đã phát gần đây hiện có của người dùng
    globalPlaylistList[existingRecentsIndex] = Playlist(
      id: 'playlist_recently_played',
      name: 'Đã phát gần đây',
      coverImage: 'assets/images/recent_playlist.jpg',
      songIds: recentSongIds,
      isSystem: true,
      userId: userId,
    );
  } else {
    // Tạo một danh sách đã phát gần đây mới cho người dùng hiện tại
    globalPlaylistList.add(Playlist(
      id: 'playlist_recently_played',
      name: 'Đã phát gần đây',
      coverImage: 'assets/images/recent_playlist.jpg',
      songIds: recentSongIds,
      isSystem: true,
      userId: userId,
    ));
  }
}
