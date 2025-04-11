import 'package:t4/data/song_list.dart';

class Album {
  final String id;
  final String name;
  final String coverImage;
  final List<int> songIds;

  Album({
    required this.id,
    required this.name,
    required this.coverImage,
    required this.songIds,
  });
}

final List<Album> albumList = [
  Album(
    id: 'album_ronboogz_1744305674',
    name: 'Ronboogz',
    coverImage: 'assets/images/album_ronboogz.jpg',
    songIds: [
      11,
      12,
    ],
  ),
];
