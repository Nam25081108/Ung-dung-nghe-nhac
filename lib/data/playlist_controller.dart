import 'package:flutter/material.dart';

class PlaylistUpdateController extends ChangeNotifier {
  void notifyPlaylistsUpdated() {
    notifyListeners();
  }
}

final playlistUpdateController = PlaylistUpdateController();
