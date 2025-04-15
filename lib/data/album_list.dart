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
  Album(
    id: 'album_t___ng_ng__y_nh___m__i_m__i_1744724692',
    name: 'Từng ngày như mãi mãi',
    coverImage: 'assets/images/album_t___ng_ng__y_nh___m__i_m__i.jpg',
    songIds: [23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, ],
  ),
  Album(
    id: 'album_v___ng_1744725400',
    name: 'Vọng',
    coverImage: 'assets/images/album_v___ng.jpg',
    songIds: [34, 35, 36, 37, 38, 39, 40, ],
  ),
  Album(
    id: 'album_s__n_t__ng_mtp_1744730201',
    name: 'Sơn Tùng MTP',
    coverImage: 'assets/images/album_s__n_t__ng_mtp.jpg',
    songIds: [47, 48, 49, 50, 51, 52, 53, 54, 55, 56, ],
  ),
];