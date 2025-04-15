import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/audio_player_handler.dart';
import 'package:just_audio/just_audio.dart';
import '../presentation/screen/now_playing_screen.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final audioHandler = context.watch<AudioPlayerHandler>();
    final song = audioHandler.currentSong;

    if (song == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NowPlayingScreen(
              song: song,
              songList: audioHandler.currentSongList,
              initialIndex: audioHandler.currentIndex,
            ),
          ),
        );
      },
      child: Container(
        color: Colors.grey.shade900,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Image.asset(song.coverImage,
                width: 50, height: 50, fit: BoxFit.cover),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    song.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    song.artist,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            StreamBuilder<PlayerState>(
              stream: audioHandler.playerStateStream,
              builder: (context, snapshot) {
                final playing = snapshot.data?.playing ?? false;
                return IconButton(
                  icon: Icon(
                    playing ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                  ),
                  iconSize: 32,
                  onPressed: () => audioHandler.togglePlayPause(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
