<?php
// Đường dẫn tương đối đến thư mục project Flutter
$FLUTTER_PROJECT_PATH = '../';

// Đường dẫn đến các file và thư mục
$SONG_LIST_PATH = $FLUTTER_PROJECT_PATH . 'lib/data/song_list.dart';
$ALBUM_LIST_PATH = $FLUTTER_PROJECT_PATH . 'lib/data/album_list.dart';
$AUDIO_ASSETS_PATH = $FLUTTER_PROJECT_PATH . 'assets/audio/';
$IMAGE_ASSETS_PATH = $FLUTTER_PROJECT_PATH . 'assets/images/';

// Thông tin tài khoản admin
$ADMIN_USERNAME = 'admin';
$ADMIN_PASSWORD = 'admin123';

// Kiểm tra đăng nhập
function isLoggedIn() {
    return isset($_SESSION['logged_in']) && $_SESSION['logged_in'] === true;
}
?> 