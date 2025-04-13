import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences.dart';
import 'auth_service.dart';

class UserDataService {
  static const String baseUrl = AuthService.baseUrl;
  static String? _currentUserId;

  // Kiểm tra và cập nhật user_id hiện tại
  static Future<bool> _checkAndUpdateUserId() async {
    final user = await AuthService.getCurrentUser();
    final newUserId = user['user_id']?.toString();

    // Nếu user_id thay đổi (đăng nhập tài khoản khác), xóa cache
    if (newUserId != null &&
        _currentUserId != null &&
        newUserId != _currentUserId) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AuthService.favoritesKey);
      await prefs.remove(AuthService.playlistsKey);
    }

    _currentUserId = newUserId;
    return newUserId != null;
  }

  // Lấy danh sách yêu thích
  static Future<List<dynamic>> getFavorites() async {
    try {
      if (!await _checkAndUpdateUserId()) return [];

      // Thử lấy từ cache trước
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString(AuthService.favoritesKey);
      if (cachedData != null) {
        return jsonDecode(cachedData);
      }

      // Nếu không có cache, lấy từ server
      final response = await http.get(
        Uri.parse('$baseUrl/favorites.php?user_id=$_currentUserId'),
      );

      final data = jsonDecode(response.body);
      if (data['success']) {
        // Lưu vào cache
        await prefs.setString(
            AuthService.favoritesKey, jsonEncode(data['favorites']));
        return data['favorites'];
      }
      return [];
    } catch (e) {
      print('Lỗi khi lấy danh sách yêu thích: $e');
      return [];
    }
  }

  // Thêm bài hát vào yêu thích
  static Future<bool> addToFavorites(int songId) async {
    try {
      if (!await _checkAndUpdateUserId()) return false;

      final response = await http.post(
        Uri.parse('$baseUrl/favorites.php'),
        body: jsonEncode({
          'user_id': _currentUserId,
          'song_id': songId,
        }),
      );

      final data = jsonDecode(response.body);
      if (data['success']) {
        // Xóa cache để lần sau lấy dữ liệu mới
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove(AuthService.favoritesKey);
      }
      return data['success'] ?? false;
    } catch (e) {
      print('Lỗi khi thêm vào yêu thích: $e');
      return false;
    }
  }

  // Xóa bài hát khỏi yêu thích
  static Future<bool> removeFromFavorites(int songId) async {
    try {
      final user = await AuthService.getCurrentUser();
      if (user['user_id'] == null) return false;

      final response = await http.delete(
        Uri.parse(
            '$baseUrl/favorites.php?user_id=${user['user_id']}&song_id=$songId'),
      );

      final data = jsonDecode(response.body);
      return data['success'] ?? false;
    } catch (e) {
      print('Lỗi khi xóa khỏi yêu thích: $e');
      return false;
    }
  }

  // Lấy danh sách playlist
  static Future<List<dynamic>> getPlaylists() async {
    try {
      if (!await _checkAndUpdateUserId()) return [];

      // Thử lấy từ cache trước
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString(AuthService.playlistsKey);
      if (cachedData != null) {
        return jsonDecode(cachedData);
      }

      final response = await http.get(
        Uri.parse('$baseUrl/playlists.php?user_id=$_currentUserId'),
      );

      final data = jsonDecode(response.body);
      if (data['success']) {
        // Lưu vào cache
        await prefs.setString(
            AuthService.playlistsKey, jsonEncode(data['playlists']));
        return data['playlists'];
      }
      return [];
    } catch (e) {
      print('Lỗi khi lấy danh sách playlist: $e');
      return [];
    }
  }

  // Tạo playlist mới
  static Future<Map<String, dynamic>> createPlaylist(
      String name, List<int> songIds) async {
    try {
      if (!await _checkAndUpdateUserId()) {
        return {'success': false, 'message': 'Chưa đăng nhập'};
      }

      final response = await http.post(
        Uri.parse('$baseUrl/playlists.php'),
        body: jsonEncode({
          'user_id': _currentUserId,
          'name': name,
          'song_ids': songIds,
        }),
      );

      final data = jsonDecode(response.body);
      if (data['success']) {
        // Xóa cache để lần sau lấy dữ liệu mới
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove(AuthService.playlistsKey);
      }
      return data;
    } catch (e) {
      return {
        'success': false,
        'message': 'Lỗi khi tạo playlist: $e',
      };
    }
  }

  // Cập nhật playlist
  static Future<bool> updatePlaylist(
      int playlistId, String name, List<int> songIds) async {
    try {
      final user = await AuthService.getCurrentUser();
      if (user['user_id'] == null) return false;

      final response = await http.put(
        Uri.parse('$baseUrl/playlists.php'),
        body: jsonEncode({
          'playlist_id': playlistId,
          'name': name,
          'song_ids': songIds,
        }),
      );

      final data = jsonDecode(response.body);
      return data['success'] ?? false;
    } catch (e) {
      print('Lỗi khi cập nhật playlist: $e');
      return false;
    }
  }

  // Xóa playlist
  static Future<bool> deletePlaylist(int playlistId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/playlists.php?playlist_id=$playlistId'),
      );

      final data = jsonDecode(response.body);
      return data['success'] ?? false;
    } catch (e) {
      print('Lỗi khi xóa playlist: $e');
      return false;
    }
  }

  // Xóa cache khi đăng xuất
  static Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AuthService.favoritesKey);
    await prefs.remove(AuthService.playlistsKey);
    _currentUserId = null;
  }
}
