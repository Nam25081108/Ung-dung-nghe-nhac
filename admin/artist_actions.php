<?php
session_start();
require_once('config.php');

if (!isLoggedIn()) {
    header('Location: index.php');
    exit;
}

// Đường dẫn đến file artists_list.dart
$ARTISTS_LIST_PATH = $FLUTTER_PROJECT_PATH . 'lib/data/artists_list.dart';

// Đọc danh sách nghệ sĩ từ file
function getArtists() {
    global $ARTISTS_LIST_PATH;
    
    $artists = [];
    if (file_exists($ARTISTS_LIST_PATH)) {
        $content = file_get_contents($ARTISTS_LIST_PATH);
        
        // Sử dụng regex để trích xuất thông tin nghệ sĩ
        preg_match_all('/Artist\(\s*id:\s*\'(.*?)\',\s*name:\s*\'(.*?)\',\s*image:\s*\'(.*?)\',\s*songIds:\s*\[(.*?)\],?\s*\)/s', $content, $matches, PREG_SET_ORDER);
        
        foreach ($matches as $match) {
            $artists[] = [
                'id' => $match[1],
                'name' => $match[2],
                'image' => $match[3],
                'songIds' => []  // Khởi tạo mảng rỗng, sẽ được cập nhật khi thêm/sửa bài hát
            ];
        }
    }
    
    return $artists;
}

// Lưu danh sách nghệ sĩ vào file
function saveArtists($artists) {
    global $ARTISTS_LIST_PATH;
    
    $content = "List<Artist> artists = [\n";
    foreach ($artists as $artist) {
        $songIds = implode(', ', $artist['songIds']);
        $content .= "  Artist(\n";
        $content .= "    id: '{$artist['id']}',\n";
        $content .= "    name: '{$artist['name']}',\n";
        $content .= "    image: '{$artist['image']}',\n";
        $content .= "    songIds: [$songIds],\n";
        $content .= "  ),\n";
    }
    $content .= "];\n";
    
    file_put_contents($ARTISTS_LIST_PATH, $content);
}

$action = $_POST['action'] ?? '';

switch ($action) {
    case 'add':
        $artist_name = $_POST['artist_name'] ?? '';
        
        // Kiểm tra tên nghệ sĩ
        if (empty($artist_name)) {
            die('Vui lòng nhập tên nghệ sĩ!');
        }
        
        // Xử lý upload hình ảnh
        $image_file = $_FILES['artist_image'] ?? null;
        if ($image_file && $image_file['error'] === UPLOAD_ERR_OK) {
            $image_name = uniqid() . '_' . $image_file['name'];
            $image_path = $IMAGE_ASSETS_PATH . $image_name;
            
            // Upload file trực tiếp không cần resize
            if (move_uploaded_file($image_file['tmp_name'], $image_path)) {
                $artists = getArtists();
                
                // Tạo ID duy nhất cho nghệ sĩ
                $artist_id = uniqid('artist_');
                
                $artists[] = [
                    'id' => $artist_id,
                    'name' => $artist_name,
                    'image' => 'assets/images/' . $image_name,
                    'songIds' => []  // Khởi tạo mảng rỗng
                ];
                
                saveArtists($artists);
                header('Location: dashboard.php?success=artist_add');
                exit;
            }
        } else {
            die('Vui lòng chọn hình ảnh cho nghệ sĩ!');
        }
        break;
        
    case 'delete':
        $artist_id = $_POST['artist_id'] ?? '';
        
        if ($artist_id) {
            $artists = getArtists();
            $artists = array_filter($artists, function($artist) use ($artist_id) {
                return $artist['id'] !== $artist_id;
            });
            
            saveArtists($artists);
            header('Location: dashboard.php?success=artist_delete');
            exit;
        }
        break;
        
    case 'edit_form':
        $artist_id = $_POST['artist_id'] ?? '';
        
        if ($artist_id) {
            header("Location: dashboard.php?edit_artist=$artist_id");
            exit;
        }
        break;

    case 'update':
        $artist_id = $_POST['artist_id'] ?? '';
        $artist_name = $_POST['artist_name'] ?? '';
        
        // Kiểm tra tên nghệ sĩ
        if (empty($artist_name)) {
            die('Vui lòng nhập tên nghệ sĩ!');
        }
        
        if ($artist_id) {
            $artists = getArtists();
            $image_path = '';
            
            // Xử lý upload hình ảnh mới nếu có
            $image_file = $_FILES['artist_image'] ?? null;
            if ($image_file && $image_file['error'] === UPLOAD_ERR_OK) {
                $image_name = uniqid() . '_' . $image_file['name'];
                $image_path = $IMAGE_ASSETS_PATH . $image_name;
                
                if (move_uploaded_file($image_file['tmp_name'], $image_path)) {
                    $image_path = 'assets/images/' . $image_name;
                }
            }
            
            // Cập nhật thông tin nghệ sĩ
            foreach ($artists as &$artist) {
                if ($artist['id'] === $artist_id) {
                    $artist['name'] = $artist_name;
                    if ($image_path) {
                        // Xóa ảnh cũ nếu có
                        $old_image_path = $FLUTTER_PROJECT_PATH . $artist['image'];
                        if (file_exists($old_image_path)) {
                            unlink($old_image_path);
                        }
                        $artist['image'] = $image_path;
                    }
                    break;
                }
            }
            
            saveArtists($artists);
            header('Location: dashboard.php?success=artist_update');
            exit;
        }
        break;
}

// Nếu không có action nào được thực hiện, quay lại dashboard
header('Location: dashboard.php');
exit;