import 'package:flutter/material.dart';
import 'package:flutter_music/models/song.dart';
import 'package:flutter_music/services/song_api_provider.dart';

class FavoritesProvider with ChangeNotifier {
  List<Song> _favoritesPlaylist = [];

  List<Song> get favoritesPlaylist => _favoritesPlaylist;

  final SongApiClient songApiClient = SongApiClient();

  Future<void> fetchFavorites(String userId) async {
    try {
      List<Song> favorites = await songApiClient.getUserFavorites(userId);
      _favoritesPlaylist = favorites;
      notifyListeners();
    } catch (e) {
      print('获取收藏出错: $e');
    }
  }

  Future<bool> isFavorite(String userId, String songId) async {
    try {
      bool isFavorited = await songApiClient.isFavorite(userId, songId);
      return isFavorited;
    } catch (e) {
      print('检查收藏状态出错: $e');
      return false;
    }
  }

  Future<void> toggleFavorite(Song song, String userId) async {
    try {
      bool isFavorited = await isFavorite(userId, song.id);
      if (isFavorited) {
        await songApiClient.removeFavorite(userId, song.id);
        song.isFavorited = false;
        _favoritesPlaylist.removeWhere((s) => s.id == song.id);
      } else {
        await songApiClient.addFavorite(userId, song.id);
        song.isFavorited = true;
        _favoritesPlaylist.add(song);
      }
      notifyListeners();
    } catch (e) {
      print('收藏切换出错: $e');
    }
  }
}
