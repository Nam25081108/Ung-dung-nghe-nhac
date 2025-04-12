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
            
            $artists[] = [
                'id' => $match[1],
                'name' => $match[2],
                'image' => $match[3],
                'songIds' => $songIds
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
        $selected_songs = $_POST['selected_songs'] ?? [];
        
        // Xử lý upload hình ảnh
        $image_file = $_FILES['artist_image'] ?? null;
        if ($image_file && $image_file['error'] === UPLOAD_ERR_OK) {
            $image_name = uniqid() . '_' . $image_file['name'];
            $image_path = $IMAGE_ASSETS_PATH . $image_name;
            
            // Resize ảnh trước khi lưu
            list($width, $height) = getimagesize($image_file['tmp_name']);
            $max_dimension = 300; // Kích thước tối đa cho cả chiều rộng và chiều cao
            
            if ($width > $max_dimension || $height > $max_dimension) {
                $ratio = $width / $height;
                if ($ratio > 1) {
                    $new_width = $max_dimension;
                    $new_height = $max_dimension / $ratio;
                } else {
                    $new_height = $max_dimension;
                    $new_width = $max_dimension * $ratio;
                }
                
                $src = imagecreatefromstring(file_get_contents($image_file['tmp_name']));
                $dst = imagecreatetruecolor($new_width, $new_height);
                
                imagecopyresampled($dst, $src, 0, 0, 0, 0, $new_width, $new_height, $width, $height);
                
                switch (strtolower(pathinfo($image_name, PATHINFO_EXTENSION))) {
                    case 'jpeg':
                    case 'jpg':
                        imagejpeg($dst, $image_path, 90);
                        break;
                    case 'png':
                        imagepng($dst, $image_path, 9);
                        break;
                    case 'gif':
                        imagegif($dst, $image_path);
                        break;
                }
                
                imagedestroy($src);
                imagedestroy($dst);
            } else {
                move_uploaded_file($image_file['tmp_name'], $image_path);
            }
            
            $artists = getArtists();
            
            // Tạo ID duy nhất cho nghệ sĩ
            $artist_id = uniqid('artist_');
            
            $artists[] = [
                'id' => $artist_id,
                'name' => $artist_name,
                'image' => 'assets/images/' . $image_name,
                'songIds' => array_map('intval', $selected_songs)
            ];
            
            saveArtists($artists);
            header('Location: dashboard.php?success=artist_add');
            exit;
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
        $selected_songs = $_POST['selected_songs'] ?? [];
        
        if ($artist_id) {
            $artists = getArtists();
            $image_path = '';
            
            // Xử lý upload hình ảnh mới nếu có
            $image_file = $_FILES['artist_image'] ?? null;
            if ($image_file && $image_file['error'] === UPLOAD_ERR_OK) {
                $image_name = uniqid() . '_' . $image_file['name'];
                $image_path = $IMAGE_ASSETS_PATH . $image_name;
                
                // Resize ảnh trước khi lưu
                list($width, $height) = getimagesize($image_file['tmp_name']);
                $max_dimension = 300; // Kích thước tối đa cho cả chiều rộng và chiều cao
                
                if ($width > $max_dimension || $height > $max_dimension) {
                    $ratio = $width / $height;
                    if ($ratio > 1) {
                        $new_width = $max_dimension;
                        $new_height = $max_dimension / $ratio;
                    } else {
                        $new_height = $max_dimension;
                        $new_width = $max_dimension * $ratio;
                    }
                    
                    $src = imagecreatefromstring(file_get_contents($image_file['tmp_name']));
                    $dst = imagecreatetruecolor($new_width, $new_height);
                    
                    imagecopyresampled($dst, $src, 0, 0, 0, 0, $new_width, $new_height, $width, $height);
                    
                    switch (strtolower(pathinfo($image_name, PATHINFO_EXTENSION))) {
                        case 'jpeg':
                        case 'jpg':
                            imagejpeg($dst, $image_path, 90);
                            break;
                        case 'png':
                            imagepng($dst, $image_path, 9);
                            break;
                        case 'gif':
                            imagegif($dst, $image_path);
                            break;
                    }
                    
                    imagedestroy($src);
                    imagedestroy($dst);
                } else {
                    move_uploaded_file($image_file['tmp_name'], $image_path);
                }
                
                // Cập nhật thông tin nghệ sĩ
                foreach ($artists as &$artist) {
                    if ($artist['id'] === $artist_id) {
                        $artist['name'] = $artist_name;
                        if ($image_path) {
                            $artist['image'] = $image_path;
                        }
                        $artist['songIds'] = array_map('intval', $selected_songs);
                        break;
                    }
                }
                
                saveArtists($artists);
                header('Location: dashboard.php?success=artist_update');
                exit;
            }
        }
        break;
}

// Nếu không có action nào được thực hiện, quay lại dashboard
header('Location: dashboard.php');
exit;
?> 