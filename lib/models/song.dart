class Song {
  final int id;
  final String title;
  final String artist;
  final String coverImage;
  final String assetPath;
  final String lyrics;
  final String? album;
  final int? albumId;
  bool isFavorite;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.coverImage,
    required this.assetPath,
    required this.lyrics,
    this.album,
    this.albumId,
    this.isFavorite = false,
  });
}
