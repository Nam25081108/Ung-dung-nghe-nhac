// Lớp quản lý cài đặt riêng của mỗi người dùng
class UserSettings {
  final String userId;
  bool darkMode;
  bool shuffleByDefault;
  bool repeatByDefault;
  int audioQuality; // 0: thấp, 1: trung bình, 2: cao

  UserSettings({
    required this.userId,
    this.darkMode = false,
    this.shuffleByDefault = false,
    this.repeatByDefault = false,
    this.audioQuality = 1,
  });
}

// Danh sách lưu trữ cài đặt của người dùng
List<UserSettings> userSettingsList = [];

// Lấy cài đặt của người dùng, tạo mới nếu chưa có
UserSettings getUserSettings(String userId) {
  // Tìm cài đặt hiện có của người dùng
  int index = userSettingsList.indexWhere((settings) => settings.userId == userId);
  
  if (index >= 0) {
    return userSettingsList[index];
  } else {
    // Tạo cài đặt mặc định cho người dùng mới
    UserSettings defaultSettings = UserSettings(userId: userId);
    userSettingsList.add(defaultSettings);
    return defaultSettings;
  }
}

// Cập nhật cài đặt của người dùng
void updateUserSettings(UserSettings settings) {
  int index = userSettingsList.indexWhere((s) => s.userId == settings.userId);
  
  if (index >= 0) {
    userSettingsList[index] = settings;
  } else {
    userSettingsList.add(settings);
  }
}

// Xóa cài đặt khi người dùng đăng xuất (nếu cần)
void clearUserSettings(String userId) {
  userSettingsList.removeWhere((settings) => settings.userId == userId);
} 