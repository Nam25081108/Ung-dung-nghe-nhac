import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'http://10.0.2.2/Ung-dung-nghe-nhac/api';
  static const String userIdKey = 'user_id';
  static const String usernameKey = 'username';
  static const String favoritesKey = 'favorites';
  static const String playlistsKey = 'playlists';

  // Đăng nhập
  static Future<Map<String, dynamic>> login(
      String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth.php?action=login'),
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);
      if (data['success']) {
        // Lưu thông tin đăng nhập vào SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt(userIdKey, data['user_id']);
        await prefs.setString(usernameKey, data['username']);
      }
      return data;
    } catch (e) {
      return {
        'success': false,
        'message': 'Lỗi kết nối: $e',
      };
    }
  }

  // Đăng ký
  static Future<Map<String, dynamic>> register(
      String username, String password, String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth.php?action=register'),
        body: jsonEncode({
          'username': username,
          'password': password,
          'email': email,
        }),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {
        'success': false,
        'message': 'Lỗi kết nối: $e',
      };
    }
  }

  // Kiểm tra đã đăng nhập chưa
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(userIdKey);
  }

  // Lấy thông tin người dùng đã đăng nhập
  static Future<Map<String, dynamic>> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'user_id': prefs.getInt(userIdKey),
      'username': prefs.getString(usernameKey),
    };
  }

  // Đăng xuất
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    // Xóa thông tin người dùng
    await prefs.remove(userIdKey);
    await prefs.remove(usernameKey);
    // Xóa dữ liệu local
    await prefs.remove(favoritesKey);
    await prefs.remove(playlistsKey);
    // Xóa tất cả dữ liệu khác nếu có
    await prefs.clear();
  }
}
