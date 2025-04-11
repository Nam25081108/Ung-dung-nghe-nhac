<?php
session_start();
require_once('config.php');

if (!isLoggedIn()) {
    header('Location: index.php');
    exit;
}

// Đọc danh sách bài hát
function getSongs() {
    global $SONG_LIST_PATH;
    
    $songs = [];
    $content = file_get_contents($SONG_LIST_PATH);
    
    // Sử dụng regex để trích xuất thông tin bài hát
    preg_match_all('/Song\(\s*id:\s*(\d+),\s*title:\s*\'(.*?)\',\s*artist:\s*\'(.*?)\',\s*coverImage:\s*\'(.*?)\',\s*assetPath:\s*\'(.*?)\',\s*lyrics:\s*\'(.*?)\'(?:,\s*album:\s*\'(.*?)\')?(?:,)?\s*\)/s', $content, $matches, PREG_SET_ORDER);
    
    foreach ($matches as $match) {
        $songs[] = [
            'id' => (int)$match[1],
            'title' => $match[2],
            'artist' => $match[3],
            'coverImage' => $match[4],
            'assetPath' => $match[5],
            'lyrics' => $match[6],
            'album' => isset($match[7]) ? $match[7] : ''
        ];
    }
    
    return $songs;
}

// Tìm ID lớn nhất hiện tại và tạo ID mới
function getNextSongId() {
    $songs = getSongs();
    $maxId = 0;
    
    foreach ($songs as $song) {
        if ($song['id'] > $maxId) {
            $maxId = $song['id'];
        }
    }
    
    return $maxId + 1;
}

// Xử lý form chỉnh sửa bài hát
if ($_POST['action'] === 'edit_form') {
    $index = (int)$_POST['index'];
    
    // Chuyển hướng về trang dashboard với tham số edit
    header("Location: dashboard.php?edit=true&index=$index");
    exit;
}

// Xử lý cập nhật bài hát
elseif ($_POST['action'] === 'update') {
    $index = (int)$_POST['index'];
    $title = $_POST['title'] ?? '';
    $artist = $_POST['artist'] ?? '';
    $album = $_POST['album'] ?? '';
    $lyrics = $_POST['lyrics'] ?? '';
    
    // Kiểm tra các trường bắt buộc
    if (empty($title) || empty($artist) || empty($lyrics)) {
        die('Vui lòng điền đầy đủ thông tin!');
    }
    
    // Đọc danh sách bài hát hiện tại
    $content = file_get_contents($SONG_LIST_PATH);
    
    // Trích xuất thông tin bài hát cần sửa
    preg_match_all('/Song\(\s*id:\s*(\d+),\s*title:\s*\'(.*?)\',\s*artist:\s*\'(.*?)\',\s*coverImage:\s*\'(.*?)\',\s*assetPath:\s*\'(.*?)\',\s*lyrics:\s*\'(.*?)\'(?:,\s*album:\s*\'(.*?)\')?(?:,)?\s*\)/s', $content, $matches, PREG_SET_ORDER);
    
    // Kiểm tra index hợp lệ
    if ($index < 0 || $index >= count($matches)) {
        die('Index không hợp lệ!');
    }
    
    // Lấy thông tin bài hát cần sửa
    $oldSong = [
        'id' => (int)$matches[$index][1],
        'title' => $matches[$index][2],
        'artist' => $matches[$index][3],
        'coverImage' => $matches[$index][4],
        'assetPath' => $matches[$index][5],
        'lyrics' => $matches[$index][6],
        'album' => isset($matches[$index][7]) ? $matches[$index][7] : ''
    ];
    
    // Đường dẫn tương đối cho các file
    $relativeImagePath = $oldSong['coverImage'];
    $relativeAudioPath = $oldSong['assetPath'];
    
    // Xử lý upload file âm thanh mới (nếu có)
    if (isset($_FILES['audio_file']) && $_FILES['audio_file']['error'] === UPLOAD_ERR_OK && $_FILES['audio_file']['size'] > 0) {
        // Tạo tên file an toàn
        $safeTitle = preg_replace('/[^a-zA-Z0-9]/', '_', strtolower($title));
        $audioExt = pathinfo($_FILES['audio_file']['name'], PATHINFO_EXTENSION);
        $audioFileName = $safeTitle . '.' . $audioExt;
        $audioPath = $AUDIO_ASSETS_PATH . $audioFileName;
        
        // Xóa file âm thanh cũ nếu tên khác
        $oldAudioPath = $FLUTTER_PROJECT_PATH . $oldSong['assetPath'];
        if (file_exists($oldAudioPath) && $relativeAudioPath !== "assets/audio/$audioFileName") {
            unlink($oldAudioPath);
        }
        
        // Upload file mới
        if (!move_uploaded_file($_FILES['audio_file']['tmp_name'], $audioPath)) {
            die('Lỗi khi lưu file âm thanh!');
        }
        
        // Cập nhật đường dẫn tương đối
        $relativeAudioPath = 'assets/audio/' . $audioFileName;
    }
    
    // Xử lý upload hình ảnh mới (nếu có)
    if (isset($_FILES['image_file']) && $_FILES['image_file']['error'] === UPLOAD_ERR_OK && $_FILES['image_file']['size'] > 0) {
        // Tạo tên file an toàn
        $safeTitle = preg_replace('/[^a-zA-Z0-9]/', '_', strtolower($title));
        $imageExt = pathinfo($_FILES['image_file']['name'], PATHINFO_EXTENSION);
        $imageFileName = $safeTitle . '.' . $imageExt;
        $imagePath = $IMAGE_ASSETS_PATH . $imageFileName;
        
        // Xóa hình ảnh cũ nếu tên khác
        $oldImagePath = $FLUTTER_PROJECT_PATH . $oldSong['coverImage'];
        if (file_exists($oldImagePath) && $relativeImagePath !== "assets/images/$imageFileName") {
            unlink($oldImagePath);
        }
        
        // Upload file mới
        if (!move_uploaded_file($_FILES['image_file']['tmp_name'], $imagePath)) {
            die('Lỗi khi lưu hình ảnh!');
        }
        
        // Cập nhật đường dẫn tương đối
        $relativeImagePath = 'assets/images/' . $imageFileName;
    }
    
    // Escape các ký tự đặc biệt trong lời bài hát
    $escapedLyrics = str_replace("'", "\\'", $lyrics);
    $escapedLyrics = str_replace("\r\n", "\\n", $escapedLyrics);
    $escapedLyrics = str_replace("\n", "\\n", $escapedLyrics);
    
    // Tạo đoạn code mới cho bài hát
    $newSongCode = "  Song(\n    id: " . $oldSong['id'] . ",\n    title: '$title',\n    artist: '$artist',\n    coverImage: '$relativeImagePath',\n    assetPath: '$relativeAudioPath',\n    lyrics: '$escapedLyrics'";
    
    // Thêm album nếu có
    if (!empty($album)) {
        $newSongCode .= ",\n    album: '$album'";
    }
    
    $newSongCode .= ",\n  ),";
    
    // Tìm và thay thế đoạn code của bài hát trong file
    $pattern = '/\s*Song\(\s*id:\s*' . $oldSong['id'] . '.*?\),\s*/s';
    $updatedContent = preg_replace($pattern, $newSongCode . "\n", $content);
    
    // Lưu file đã cập nhật
    if (file_put_contents($SONG_LIST_PATH, $updatedContent) === false) {
        die('Lỗi khi cập nhật file song_list.dart!');
    }
    
    // Chuyển hướng về dashboard
    header('Location: dashboard.php?success=update');
    exit;
}

// Xử lý thêm bài hát mới
elseif ($_POST['action'] === 'add') {
    $title = $_POST['title'] ?? '';
    $artist = $_POST['artist'] ?? '';
    $album = $_POST['album'] ?? '';
    $lyrics = $_POST['lyrics'] ?? '';
    
    // Kiểm tra các trường bắt buộc
    if (empty($title) || empty($artist) || empty($lyrics)) {
        die('Vui lòng điền đầy đủ thông tin!');
    }
    
    // Xử lý upload file âm thanh
    if (!isset($_FILES['audio_file']) || $_FILES['audio_file']['error'] !== UPLOAD_ERR_OK) {
        die('Lỗi khi tải lên file âm thanh!');
    }
    
    // Xử lý upload hình ảnh
    if (!isset($_FILES['image_file']) || $_FILES['image_file']['error'] !== UPLOAD_ERR_OK) {
        die('Lỗi khi tải lên hình ảnh!');
    }
    
    // Tạo tên file an toàn (không dấu, không ký tự đặc biệt)
    $safeTitle = preg_replace('/[^a-zA-Z0-9]/', '_', strtolower($title));
    
    // Upload file âm thanh
    $audioExt = pathinfo($_FILES['audio_file']['name'], PATHINFO_EXTENSION);
    $audioFileName = $safeTitle . '.' . $audioExt;
    $audioPath = $AUDIO_ASSETS_PATH . $audioFileName;
    
    if (!move_uploaded_file($_FILES['audio_file']['tmp_name'], $audioPath)) {
        die('Lỗi khi lưu file âm thanh!');
    }
    
    // Upload hình ảnh
    $imageExt = pathinfo($_FILES['image_file']['name'], PATHINFO_EXTENSION);
    $imageFileName = $safeTitle . '.' . $imageExt;
    $imagePath = $IMAGE_ASSETS_PATH . $imageFileName;
    
    if (!move_uploaded_file($_FILES['image_file']['tmp_name'], $imagePath)) {
        // Xóa file âm thanh nếu không thể upload hình ảnh
        unlink($audioPath);
        die('Lỗi khi lưu hình ảnh!');
    }
    
    // Đường dẫn tương đối cho Flutter
    $relativeAudioPath = 'assets/audio/' . $audioFileName;
    $relativeImagePath = 'assets/images/' . $imageFileName;
    
    // Escape các ký tự đặc biệt trong lời bài hát
    $escapedLyrics = str_replace("'", "\\'", $lyrics);
    $escapedLyrics = str_replace("\r\n", "\\n", $escapedLyrics);
    $escapedLyrics = str_replace("\n", "\\n", $escapedLyrics);
    
    // Lấy ID mới
    $newId = getNextSongId();
    
    // Thêm bài hát vào song_list.dart
    $songContent = file_get_contents($SONG_LIST_PATH);
    
    // Tìm vị trí cuối cùng của danh sách bài hát
    $insertPosition = strrpos($songContent, '];');
    if ($insertPosition === false) {
        die('Lỗi định dạng file song_list.dart!');
    }
    
    // Tạo đoạn code cho bài hát mới
    $newSongCode = "  Song(\n    id: $newId,\n    title: '$title',\n    artist: '$artist',\n    coverImage: '$relativeImagePath',\n    assetPath: '$relativeAudioPath',\n    lyrics: '$escapedLyrics'";
    
    // Thêm album nếu có
    if (!empty($album)) {
        $newSongCode .= ",\n    album: '$album'";
    }
    
    $newSongCode .= ",\n  ),\n";
    
    // Chèn bài hát mới vào danh sách
    $updatedContent = substr_replace($songContent, $newSongCode, $insertPosition, 0);
    
    // Lưu file đã cập nhật
    if (file_put_contents($SONG_LIST_PATH, $updatedContent) === false) {
        die('Lỗi khi cập nhật file song_list.dart!');
    }
    
    // Chuyển hướng về dashboard
    header('Location: dashboard.php?success=add');
    exit;
}

// Xử lý xóa bài hát
elseif ($_POST['action'] === 'delete') {
    $index = (int)$_POST['index'];
    
    // Đọc danh sách bài hát hiện tại
    $content = file_get_contents($SONG_LIST_PATH);
    
    // Trích xuất thông tin bài hát cần xóa
    preg_match_all('/Song\(\s*id:\s*(\d+),\s*title:\s*\'(.*?)\',\s*artist:\s*\'(.*?)\',\s*coverImage:\s*\'(.*?)\',\s*assetPath:\s*\'(.*?)\',\s*lyrics:\s*\'(.*?)\'(?:,\s*album:\s*\'(.*?)\')?(?:,)?\s*\)/s', $content, $matches, PREG_SET_ORDER);
    
    // Kiểm tra index hợp lệ
    if ($index < 0 || $index >= count($matches)) {
        die('Index không hợp lệ!');
    }
    
    // Lấy thông tin bài hát cần xóa
    $song = [
        'id' => (int)$matches[$index][1],
        'title' => $matches[$index][2],
        'artist' => $matches[$index][3],
        'coverImage' => $matches[$index][4],
        'assetPath' => $matches[$index][5]
    ];
    
    // Xóa file âm thanh
    $audioPath = $FLUTTER_PROJECT_PATH . $song['assetPath'];
    if (file_exists($audioPath)) {
        unlink($audioPath);
    }
    
    // Xóa hình ảnh
    $imagePath = $FLUTTER_PROJECT_PATH . $song['coverImage'];
    if (file_exists($imagePath)) {
        unlink($imagePath);
    }
    
    // Xóa bài hát khỏi file song_list.dart
    $pattern = '/\s*Song\(\s*id:\s*' . $song['id'] . '.*?\),\s*/s';
    $updatedContent = preg_replace($pattern, '', $content);
    
    // Lưu file đã cập nhật
    if (file_put_contents($SONG_LIST_PATH, $updatedContent) === false) {
        die('Lỗi khi cập nhật file song_list.dart!');
    }
    
    // Chuyển hướng về dashboard
    header('Location: dashboard.php?success=delete');
    exit;
}

// Nếu không có action hợp lệ
else {
    header('Location: dashboard.php');
    exit;
}