import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PlayerControl extends StatefulWidget {
  final AudioPlayer audioPlayer;

  const PlayerControl({super.key, required this.audioPlayer});

  @override
  State<PlayerControl> createState() => _PlayerControlState();
}

class _PlayerControlState extends State<PlayerControl> {
  bool isPlaying = false;

  void _togglePlayPause() async {
    if (widget.audioPlayer.playing) {
      await widget.audioPlayer.pause();
    } else {
      await widget.audioPlayer.play();
    }

    setState(() {
      isPlaying = widget.audioPlayer.playing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(isPlaying ? Icons.pause_circle : Icons.play_circle, size: 64),
      onPressed: _togglePlayPause,
    );
  }
}
