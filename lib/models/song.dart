class Song {
  final String title;
  final String artist;
  final String coverImage;
  final String assetPath;
  final String lyrics;
  bool isFavorite;

  Song({
    required this.title,
    required this.artist,
    required this.coverImage,
    required this.assetPath,
    required this.lyrics,
    this.isFavorite = false,
  });
}
