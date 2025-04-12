# SGU-SP-MusicApp

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Dự án chuyên ngành - Trường Đại học Sài Gòn (SGU)

### Giới thiệu

SGU-SP-MusicApp là ứng dụng nghe nhạc đa nền tảng được phát triển bằng Flutter, là sản phẩm của đồ án chuyên ngành tại Trường Đại học Sài Gòn. Ứng dụng cho phép người dùng nghe nhạc, quản lý danh sách phát cá nhân, xem lời bài hát đồng bộ và nhiều tính năng khác.

### Tính năng chính

- **Đăng nhập/Đăng ký**: Hệ thống xác thực người dùng thông qua Firebase
- **Thư viện nhạc**: Nghe nhạc với bộ điều khiển đầy đủ (phát/tạm dừng, chuyển bài, lặp lại, ngẫu nhiên)
- **Danh sách phát**: 
  - Tạo, chỉnh sửa và xóa danh sách phát cá nhân
  - Danh sách yêu thích tự động
- **Lời bài hát**: Hiển thị lời bài hát đồng bộ với nhạc đang phát
- **Album**: Duyệt và phát nhạc theo album
- **Tìm kiếm**: Tìm kiếm bài hát theo tên hoặc nghệ sĩ
- **Giao diện người dùng**: UI/UX thân thiện, hiện đại và dễ sử dụng
- **Quản lý admin**: Bảng điều khiển dành cho quản trị viên

### Công nghệ sử dụng

- **Flutter & Dart**: Framework phát triển ứng dụng đa nền tảng
- **Firebase**:
  - Authentication: Xác thực người dùng
  - Firestore: Lưu trữ dữ liệu
- **just_audio**: Thư viện phát nhạc
- **flutter_lyric**: Hiển thị lời bài hát đồng bộ
- **Material Design**: Thiết kế giao diện người dùng

### Cài đặt và chạy ứng dụng

1. **Yêu cầu hệ thống**:
   - Flutter SDK (phiên bản 3.2.3 trở lên)
   - Dart SDK (phiên bản 3.2.0 trở lên)
   - IDE: Android Studio, VS Code hoặc IntelliJ IDEA
   - Firebase Project (cho xác thực và lưu trữ)

2. **Cài đặt**:
```bash
# Clone dự án
git clone https://github.com/yourusername/SGU-SP-MusicApp.git

# Di chuyển vào thư mục dự án
cd SGU-SP-MusicApp

# Cài đặt các phụ thuộc
flutter pub get

# Chạy ứng dụng
flutter run
```

3. **Build cho các nền tảng**:
```bash
# Android
flutter build apk

# iOS
flutter build ios

# Web
flutter build web
```

### Cấu trúc dự án

```
lib/
├── data/              # Dữ liệu và mô hình dữ liệu
├── models/            # Định nghĩa các lớp mô hình
├── presentation/      # Giao diện người dùng
│   ├── screen/        # Các màn hình ứng dụng
│   └── widgets/       # Các widget tái sử dụng
├── firebase_options.dart  # Cấu hình Firebase
└── main.dart          # Điểm khởi đầu ứng dụng

assets/
├── audio/             # File nhạc
├── images/            # Hình ảnh
└── lyrics/            # Lời bài hát
```

### Nhóm phát triển

- Thành viên 1 - MSSV: xxxxxx
- Thành viên 2 - MSSV: xxxxxx
- Thành viên 3 - MSSV: xxxxxx

### Giảng viên hướng dẫn

- GV. xxxxxxx

### Giấy phép

© 2025 - Đồ án chuyên ngành - Trường Đại học Sài Gòn (SGU)

---

*Lưu ý: Đây là sản phẩm học thuật, được phát triển cho mục đích giáo dục và không nhằm mục đích thương mại.*

---

# English Version

## Specialized Project - Saigon University (SGU)

### Introduction

SGU-SP-MusicApp is a cross-platform music streaming application developed with Flutter, created as a specialized project at Saigon University. The application allows users to listen to music, manage personal playlists, view synchronized lyrics, and enjoy many other features.

### Key Features

- **Authentication**: User authentication system through Firebase
- **Music Library**: Listen to music with full controls (play/pause, skip tracks, repeat, shuffle)
- **Playlists**: 
  - Create, edit, and delete personal playlists
  - Automatic favorites list
- **Lyrics**: Display lyrics synchronized with the playing music
- **Albums**: Browse and play music by albums
- **Search**: Search for songs by title or artist
- **User Interface**: Friendly, modern, and easy-to-use UI/UX
- **Admin Management**: Dashboard for administrators

### Technologies Used

- **Flutter & Dart**: Cross-platform application development framework
- **Firebase**:
  - Authentication: User authentication
  - Firestore: Data storage
- **just_audio**: Music playback library
- **flutter_lyric**: Synchronized lyrics display
- **Material Design**: User interface design

### Installation and Running the Application

1. **System Requirements**:
   - Flutter SDK (version 3.2.3 or higher)
   - Dart SDK (version 3.2.0 or higher)
   - IDE: Android Studio, VS Code, or IntelliJ IDEA
   - Firebase Project (for authentication and storage)

2. **Installation**:
```bash
# Clone the project
git clone https://github.com/yourusername/SGU-SP-MusicApp.git

# Navigate to the project directory
cd SGU-SP-MusicApp

# Install dependencies
flutter pub get

# Run the application
flutter run
```

3. **Build for platforms**:
```bash
# Android
flutter build apk

# iOS
flutter build ios

# Web
flutter build web
```

### Project Structure

```
lib/
├── data/              # Data and data models
├── models/            # Class definitions
├── presentation/      # User interface
│   ├── screen/        # Application screens
│   └── widgets/       # Reusable widgets
├── firebase_options.dart  # Firebase configuration
└── main.dart          # Application entry point

assets/
├── audio/             # Music files
├── images/            # Images
└── lyrics/            # Lyrics
```

### Development Team

- Member 1 - Student ID: xxxxxx
- Member 2 - Student ID: xxxxxx
- Member 3 - Student ID: xxxxxx

### Instructor

- Prof. xxxxxxx

### License

© 2025 - Specialized Project - Saigon University (SGU)

---

*Note: This is an academic product, developed for educational purposes and not intended for commercial use.*