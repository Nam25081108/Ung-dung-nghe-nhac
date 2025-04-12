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
    id: 'album_ronboogz2_1744479368',
    name: 'Nam',
    coverImage: 'assets/images/album_ronboogz2.jpg',
    songIds: [11, 12, 14, ],
  ),
  Album(
    id: 'album_ronboogz1_1744479485',
    name: 'Ronboogz1',
    coverImage: 'assets/images/album_ronboogz1.jpg',
    songIds: [],
  ),
];