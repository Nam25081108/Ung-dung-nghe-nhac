import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../models/artist.dart';
import '../../models/song.dart';
import '../../data/artists_list.dart';
import '../../data/song_list.dart';
import 'now_playing_screen.dart';

class ArtistScreen extends StatefulWidget {
  final String artistId;

  const ArtistScreen({Key? key, required this.artistId}) : super(key: key);

  @override
  State<ArtistScreen> createState() => _ArtistScreenState();
}

class _ArtistScreenState extends State<ArtistScreen> {
  late Artist _artist;
  late List<Song> _artistSongs;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _loadArtistData();
  }

  void _loadArtistData() {
    _artist = artists.firstWhere((artist) => artist.id == widget.artistId);
    _artistSongs =
        songList.where((song) => song.artist.contains(_artist.name)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_artist.name),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Artist Header
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      _artist.image,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _artist.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '${_artistSongs.length} bài hát',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Play All Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton.icon(
                onPressed: () async {
                  if (_artistSongs.isNotEmpty) {
                    await _audioPlayer.stop();
                    await _audioPlayer.setAsset(_artistSongs[0].assetPath);
                    if (mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NowPlayingScreen(
                            song: _artistSongs[0],
                            songList: _artistSongs,
                            initialIndex: 0,
                          ),
                        ),
                      );
                    }
                  }
                },
                icon: const Icon(Icons.play_arrow),
                label: const Text('Phát tất cả'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Songs List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bài hát',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _artistSongs.length,
                    itemBuilder: (context, index) {
                      final song = _artistSongs[index];
                      return ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.asset(
                            song.coverImage,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(song.title),
                        subtitle: Text(song.artist),
                        trailing: IconButton(
                          icon: const Icon(Icons.play_arrow),
                          onPressed: () async {
                            await _audioPlayer.stop();
                            await _audioPlayer.setAsset(song.assetPath);
                            if (mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NowPlayingScreen(
                                    song: song,
                                    songList: _artistSongs,
                                    initialIndex: index,
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                        onTap: () async {
                          await _audioPlayer.stop();
                          await _audioPlayer.setAsset(song.assetPath);
                          if (mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NowPlayingScreen(
                                  song: song,
                                  songList: _artistSongs,
                                  initialIndex: index,
                                ),
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
