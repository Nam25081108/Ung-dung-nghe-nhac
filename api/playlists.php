<?php
require_once('../admin/config.php');

// Allow CORS
header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE');
header('Access-Control-Allow-Headers: Access-Control-Allow-Headers, Content-Type, Access-Control-Allow-Methods, Authorization, X-Requested-With');

$conn = connectDB();
$data = json_decode(file_get_contents("php://input"));
$response = array();

switch ($_SERVER['REQUEST_METHOD']) {
    case 'GET':
        // Lấy danh sách playlist của user
        if (isset($_GET['user_id'])) {
            $user_id = $conn->real_escape_string($_GET['user_id']);
            
            $sql = "SELECT p.*, COUNT(ps.song_id) as song_count 
                    FROM playlists p 
                    LEFT JOIN playlist_songs ps ON p.id = ps.playlist_id 
                    WHERE p.user_id = '$user_id' 
                    GROUP BY p.id";
            
            $result = $conn->query($sql);
            $playlists = array();
            
            if ($result->num_rows > 0) {
                while ($row = $result->fetch_assoc()) {
                    // Lấy danh sách bài hát trong playlist
                    $playlist_id = $row['id'];
                    $sql_songs = "SELECT s.* FROM songs s 
                                INNER JOIN playlist_songs ps ON s.id = ps.song_id 
                                WHERE ps.playlist_id = '$playlist_id'";
                    
                    $result_songs = $conn->query($sql_songs);
                    $songs = array();
                    
                    if ($result_songs->num_rows > 0) {
                        while ($song = $result_songs->fetch_assoc()) {
                            $songs[] = $song;
                        }
                    }
                    
                    $row['songs'] = $songs;
                    $playlists[] = $row;
                }
                
                $response['success'] = true;
                $response['playlists'] = $playlists;
            } else {
                $response['success'] = true;
                $response['playlists'] = [];
            }
        } else {
            $response['success'] = false;
            $response['message'] = 'Thiếu user_id';
        }
        break;
        
    case 'POST':
        // Tạo playlist mới
        if (isset($data->user_id) && isset($data->name)) {
            $user_id = $conn->real_escape_string($data->user_id);
            $name = $conn->real_escape_string($data->name);
            
            $sql = "INSERT INTO playlists (user_id, name) VALUES ('$user_id', '$name')";
            
            if ($conn->query($sql)) {
                $playlist_id = $conn->insert_id;
                
                // Thêm bài hát vào playlist nếu có
                if (isset($data->song_ids) && is_array($data->song_ids)) {
                    foreach ($data->song_ids as $song_id) {
                        $song_id = $conn->real_escape_string($song_id);
                        $sql = "INSERT INTO playlist_songs (playlist_id, song_id) VALUES ('$playlist_id', '$song_id')";
                        $conn->query($sql);
                    }
                }
                
                $response['success'] = true;
                $response['message'] = 'Tạo playlist thành công';
                $response['playlist_id'] = $playlist_id;
            } else {
                $response['success'] = false;
                $response['message'] = 'Lỗi: ' . $conn->error;
            }
        } else {
            $response['success'] = false;
            $response['message'] = 'Thiếu thông tin playlist';
        }
        break;
        
    case 'PUT':
        // Cập nhật playlist
        if (isset($data->playlist_id) && isset($data->name)) {
            $playlist_id = $conn->real_escape_string($data->playlist_id);
            $name = $conn->real_escape_string($data->name);
            
            $sql = "UPDATE playlists SET name = '$name' WHERE id = '$playlist_id'";
            
            if ($conn->query($sql)) {
                // Cập nhật danh sách bài hát nếu có
                if (isset($data->song_ids) && is_array($data->song_ids)) {
                    // Xóa danh sách bài hát cũ
                    $sql = "DELETE FROM playlist_songs WHERE playlist_id = '$playlist_id'";
                    $conn->query($sql);
                    
                    // Thêm danh sách bài hát mới
                    foreach ($data->song_ids as $song_id) {
                        $song_id = $conn->real_escape_string($song_id);
                        $sql = "INSERT INTO playlist_songs (playlist_id, song_id) VALUES ('$playlist_id', '$song_id')";
                        $conn->query($sql);
                    }
                }
                
                $response['success'] = true;
                $response['message'] = 'Cập nhật playlist thành công';
            } else {
                $response['success'] = false;
                $response['message'] = 'Lỗi: ' . $conn->error;
            }
        } else {
            $response['success'] = false;
            $response['message'] = 'Thiếu thông tin playlist';
        }
        break;
        
    case 'DELETE':
        // Xóa playlist
        if (isset($_GET['playlist_id'])) {
            $playlist_id = $conn->real_escape_string($_GET['playlist_id']);
            
            $sql = "DELETE FROM playlists WHERE id = '$playlist_id'";
            
            if ($conn->query($sql)) {
                $response['success'] = true;
                $response['message'] = 'Xóa playlist thành công';
            } else {
                $response['success'] = false;
                $response['message'] = 'Lỗi: ' . $conn->error;
            }
        } else {
            $response['success'] = false;
            $response['message'] = 'Thiếu playlist_id';
        }
        break;
        
    default:
        $response['success'] = false;
        $response['message'] = 'Phương thức không được hỗ trợ';
        break;
}

echo json_encode($response);
$conn->close(); 