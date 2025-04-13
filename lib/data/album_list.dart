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
    id: 'album_ronboogz3_1744535696',
    name: 'Ronboogz',
    coverImage: 'assets/images/album_ronboogz3.jpg',
    songIds: [11, 14, 16, 17, ],
  ),
  Album(
    id: 'album_1__1744548637',
    name: '1%',
    coverImage: 'assets/images/album_1_.jpg',
    songIds: [2, 3, 13, 18, ],
  ),
  Album(
    id: 'album_l___ng_1744554174',
    name: 'Lặng',
    coverImage: 'assets/images/album_l___ng.png',
    songIds: [19, 20, 21, ],
  ),
];