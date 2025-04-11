import 'package:t4/data/song_list.dart';

class Playlist {
  final String id;
  String name;
  final String coverImage;
  final List<int> songIds;
  final bool isSystem; // Đánh dấu danh sách phát mặc định của hệ thống

  Playlist({
    required this.id,
    required this.name,
    required this.coverImage,
    required this.songIds,
    this.isSystem = false,
  });
}

// Tạo danh sách phát mặc định
final List<Playlist> playlistList = [
  Playlist(
    id: 'playlist_my_favorites',
    name: 'Yêu thích của tôi',
    coverImage: 'assets/images/favorite_playlist.jpg',
    songIds: [1, 3, 5, 8],
    isSystem: true,
  ),
  Playlist(
    id: 'playlist_recently_played',
    name: 'Đã phát gần đây',
    coverImage: 'assets/images/recent_playlist.jpg',
    songIds: [2, 4, 6, 9],
    isSystem: true,
  ),
  Playlist(
    id: 'playlist_top_hits',
    name: 'Top Hits Việt Nam',
    coverImage: 'assets/images/top_hits.jpg',
    songIds: [1, 2, 3, 4, 5],
  ),
  Playlist(
    id: 'playlist_ballad',
    name: 'Ballad Việt',
    coverImage: 'assets/images/ballad.jpg',
    songIds: [3, 5, 7, 9],
  ),
  Playlist(
    id: 'playlist_rap_viet',
    name: 'Rap Việt',
    coverImage: 'assets/images/rap_viet.jpg',
    songIds: [2, 3, 8],
  ),
];

// Biến toàn cục để lưu trữ tất cả playlist, bao gồm cả những playlist được thêm từ album
List<Playlist> globalPlaylistList = List.from(playlistList);

// Lấy danh sách các bài hát trong playlist
List<Song> getPlaylistSongs(Playlist playlist) {
  return songList.where((song) => playlist.songIds.contains(song.id)).toList();
}
