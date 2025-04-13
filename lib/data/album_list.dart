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
    songIds: [10, 11, 13, 14, ],
  ),
  Album(
    id: 'album_ronboogz1_1744479485',
    name: 'Ronboogz1',
    coverImage: 'assets/images/album_ronboogz1.jpg',
    songIds: [1, 2, 3, 4, ],
  ),
  Album(
    id: 'album_ronboogz3_1744535696',
    name: 'Ronboogz3',
    coverImage: 'assets/images/album_ronboogz3.jpg',
    songIds: [11, 14, 16, 17, ],
  ),
];