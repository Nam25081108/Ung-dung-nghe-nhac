class Playlist {
  final String id;
  String name;
  final String coverImage;
  final List<int> songIds;
  final bool isSystem; // Đánh dấu danh sách phát mặc định của hệ thống
  final String? userId; // ID của người dùng sở hữu playlist

  Playlist({
    required this.id,
    required this.name,
    required this.coverImage,
    required this.songIds,
    this.isSystem = false,
    this.userId, // Thêm ID người dùng
  });
}