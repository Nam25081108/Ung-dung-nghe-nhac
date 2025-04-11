<?php
session_start();
require_once('config.php');

if (!isLoggedIn()) {
    header('Location: index.php');
    exit;
}

// Hàm tạo ID duy nhất dựa trên tên bài hát và nghệ sĩ
function generateUniqueId($title, $artist) {
    $cleanTitle = preg_replace('/[^a-zA-Z0-9]/', '_', strtolower($title));
    $cleanArtist = preg_replace('/[^a-zA-Z0-9]/', '_', strtolower($artist));
    return $cleanTitle . '_' . $cleanArtist;
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

// Đọc danh sách album từ file
function getAlbums() {
    global $ALBUM_LIST_PATH;
    
    $albums = [];
    
    if (file_exists($ALBUM_LIST_PATH)) {
        $content = file_get_contents($ALBUM_LIST_PATH);
        
        // Sử dụng regex để trích xuất thông tin album
        preg_match_all('/Album\(\s*id:\s*\'(.*?)\',\s*name:\s*\'(.*?)\',\s*coverImage:\s*\'(.*?)\',\s*songIds:\s*\[(.*?)\],?\s*\)/s', $content, $matches, PREG_SET_ORDER);
        
        foreach ($matches as $match) {
            // Trích xuất các ID bài hát từ mảng songIds
            $songIds = [];
            if (!empty($match[4])) {
                preg_match_all('/(\d+)/', $match[4], $songMatches);
                if (isset($songMatches[1])) {
                    foreach ($songMatches[1] as $id) {
                        $songIds[] = (int)$id;
                    }
                }
            }
            
            $albums[] = [
                'id' => $match[1],
                'name' => $match[2],
                'coverImage' => $match[3],
                'songIds' => $songIds
            ];
        }
    }
    
    return $albums;
}

// Cập nhật file album_list.dart
function updateAlbumList($albums) {
    global $ALBUM_LIST_PATH;
    
    // Tạo mã Dart cho file album_list.dart
    $content = "import 'package:t4/data/song_list.dart';\n\n";
    $content .= "class Album {\n";
    $content .= "  final String id;\n";
    $content .= "  final String name;\n";
    $content .= "  final String coverImage;\n";
    $content .= "  final List<int> songIds;\n\n";
    $content .= "  Album({\n";
    $content .= "    required this.id,\n";
    $content .= "    required this.name,\n";
    $content .= "    required this.coverImage,\n";
    $content .= "    required this.songIds,\n";
    $content .= "  });\n";
    $content .= "}\n\n";
    $content .= "final List<Album> albumList = [\n";
    
    // Thêm tất cả album vào danh sách
    foreach ($albums as $album) {
        $content .= "  Album(\n";
        $content .= "    id: '" . $album['id'] . "',\n";
        $content .= "    name: '" . $album['name'] . "',\n";
        $content .= "    coverImage: '" . $album['coverImage'] . "',\n";
        $content .= "    songIds: [";
        
        if (!empty($album['songIds'])) {
            foreach ($album['songIds'] as $songId) {
                $content .= $songId . ", ";
            }
        }
        
        $content .= "],\n";
        $content .= "  ),\n";
    }
    
    $content .= "];";
    
    // Lưu nội dung vào file
    if (file_put_contents($ALBUM_LIST_PATH, $content) === false) {
        die('Lỗi khi cập nhật file album_list.dart!');
    }
}

// Xử lý form chỉnh sửa album
if ($_POST['action'] === 'edit_form') {
    $index = (int)$_POST['index'];
    
    // Chuyển hướng về trang dashboard với tham số edit_album
    header("Location: dashboard.php?edit_album=true&index=$index");
    exit;
}

// Xử lý cập nhật album
elseif ($_POST['action'] === 'update') {
    $index = (int)$_POST['index'];
    $albumId = $_POST['album_id'];
    $albumName = $_POST['album_name'] ?? '';
    $selectedSongs = $_POST['selected_songs'] ?? [];
    
    // Kiểm tra tên album
    if (empty($albumName)) {
        die('Vui lòng nhập tên album!');
    }
    
    // Đọc danh sách album hiện tại
    $albums = getAlbums();
    
    // Kiểm tra index hợp lệ
    if ($index < 0 || $index >= count($albums)) {
        die('Index không hợp lệ!');
    }
    
    // Lấy thông tin album cần cập nhật
    $oldAlbum = $albums[$index];
    
    // Xử lý đường dẫn hình ảnh
    $relativeImagePath = $oldAlbum['coverImage']; // Giữ nguyên hình ảnh cũ
    
    // Xử lý upload hình ảnh mới (nếu có)
    if (isset($_FILES['album_cover']) && $_FILES['album_cover']['error'] === UPLOAD_ERR_OK && $_FILES['album_cover']['size'] > 0) {
        // Tạo tên file an toàn
        $safeTitle = preg_replace('/[^a-zA-Z0-9]/', '_', strtolower($albumName));
        $imageExt = pathinfo($_FILES['album_cover']['name'], PATHINFO_EXTENSION);
        $imageFileName = 'album_' . $safeTitle . '.' . $imageExt;
        $imagePath = $IMAGE_ASSETS_PATH . $imageFileName;
        
        // Xóa hình ảnh cũ nếu tên khác
        $oldImagePath = $FLUTTER_PROJECT_PATH . $oldAlbum['coverImage'];
        if (file_exists($oldImagePath) && $relativeImagePath !== "assets/images/$imageFileName") {
            unlink($oldImagePath);
        }
        
        // Upload file mới
        if (!move_uploaded_file($_FILES['album_cover']['tmp_name'], $imagePath)) {
            die('Lỗi khi lưu hình ảnh!');
        }
        
        // Cập nhật đường dẫn tương đối
        $relativeImagePath = 'assets/images/' . $imageFileName;
    }
    
    // Lấy danh sách bài hát
    $songs = getSongs();
    
    // Tạo mảng songIds
    $songIds = [];
    if (!empty($selectedSongs)) {
        foreach ($selectedSongs as $songIndex) {
            if (isset($songs[(int)$songIndex])) {
                $song = $songs[(int)$songIndex];
                $songIds[] = $song['id'];
            }
        }
    }
    
    // Cập nhật thông tin album
    $albums[$index] = [
        'id' => $albumId,
        'name' => $albumName,
        'coverImage' => $relativeImagePath,
        'songIds' => $songIds
    ];
    
    // Cập nhật file album_list.dart
    updateAlbumList($albums);
    
    // Chuyển hướng về dashboard
    header('Location: dashboard.php?success=album_update');
    exit;
}

// Xử lý thêm album mới
elseif ($_POST['action'] === 'add') {
    $albumName = $_POST['album_name'] ?? '';
    $selectedSongs = $_POST['selected_songs'] ?? [];
    
    // Kiểm tra tên album
    if (empty($albumName)) {
        die('Vui lòng nhập tên album!');
    }
    
    // Kiểm tra file hình ảnh
    if (!isset($_FILES['album_cover']) || $_FILES['album_cover']['error'] !== UPLOAD_ERR_OK) {
        die('Lỗi khi tải lên hình ảnh!');
    }
    
    // Tạo ID duy nhất cho album
    $albumId = 'album_' . preg_replace('/[^a-zA-Z0-9]/', '_', strtolower($albumName)) . '_' . time();
    
    // Xử lý hình ảnh bìa album
    $safeTitle = preg_replace('/[^a-zA-Z0-9]/', '_', strtolower($albumName));
    $imageExt = pathinfo($_FILES['album_cover']['name'], PATHINFO_EXTENSION);
    $imageFileName = 'album_' . $safeTitle . '.' . $imageExt;
    $imagePath = $IMAGE_ASSETS_PATH . $imageFileName;
    
    if (!move_uploaded_file($_FILES['album_cover']['tmp_name'], $imagePath)) {
        die('Lỗi khi lưu hình ảnh!');
    }
    
    // Đường dẫn tương đối
    $relativeImagePath = 'assets/images/' . $imageFileName;
    
    // Lấy danh sách bài hát
    $songs = getSongs();
    
    // Tạo mảng songIds
    $songIds = [];
    if (!empty($selectedSongs)) {
        foreach ($selectedSongs as $songIndex) {
            if (isset($songs[(int)$songIndex])) {
                $song = $songs[(int)$songIndex];
                $songIds[] = $song['id'];
            }
        }
    }
    
    // Đọc danh sách album hiện tại
    $albums = getAlbums();
    
    // Thêm album mới
    $albums[] = [
        'id' => $albumId,
        'name' => $albumName,
        'coverImage' => $relativeImagePath,
        'songIds' => $songIds
    ];
    
    // Cập nhật file album_list.dart
    updateAlbumList($albums);
    
    // Chuyển hướng về dashboard
    header('Location: dashboard.php?success=album_add');
    exit;
}

// Xử lý xóa album
elseif ($_POST['action'] === 'delete') {
    $index = (int)$_POST['index'];
    
    // Đọc danh sách album hiện tại
    $albums = getAlbums();
    
    // Kiểm tra index hợp lệ
    if ($index < 0 || $index >= count($albums)) {
        die('Index không hợp lệ!');
    }
    
    // Lấy thông tin album cần xóa
    $album = $albums[$index];
    
    // Xóa hình ảnh bìa album
    $imagePath = $FLUTTER_PROJECT_PATH . $album['coverImage'];
    if (file_exists($imagePath)) {
        unlink($imagePath);
    }
    
    // Xóa album khỏi mảng
    array_splice($albums, $index, 1);
    
    // Cập nhật file album_list.dart
    updateAlbumList($albums);
    
    // Chuyển hướng về dashboard
    header('Location: dashboard.php?success=album_delete');
    exit;
}

// Nếu không có action hợp lệ
else {
    header('Location: dashboard.php');
    exit;
} 