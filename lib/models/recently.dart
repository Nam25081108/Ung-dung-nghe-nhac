// Lớp lưu trữ lịch sử phát nhạc của người dùng
class RecentlyPlayed {
  final String userId;
  final int songId;
  final DateTime playedAt;

  RecentlyPlayed({
    required this.userId,
    required this.songId,
    required this.playedAt,
  });
}
