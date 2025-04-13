<?php
require_once('../admin/config.php');

// Allow CORS
header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');
header('Access-Control-Allow-Methods: GET, POST, DELETE');
header('Access-Control-Allow-Headers: Access-Control-Allow-Headers, Content-Type, Access-Control-Allow-Methods, Authorization, X-Requested-With');

$conn = connectDB();
$data = json_decode(file_get_contents("php://input"));
$response = array();

switch ($_SERVER['REQUEST_METHOD']) {
    case 'GET':
        // Lấy danh sách bài hát yêu thích của user
        if (isset($_GET['user_id'])) {
            $user_id = $conn->real_escape_string($_GET['user_id']);
            
            $sql = "SELECT s.* FROM songs s 
                    INNER JOIN favorites f ON s.id = f.song_id 
                    WHERE f.user_id = '$user_id' 
                    ORDER BY f.added_at DESC";
            
            $result = $conn->query($sql);
            $favorites = array();
            
            if ($result->num_rows > 0) {
                while ($row = $result->fetch_assoc()) {
                    $favorites[] = $row;
                }
                
                $response['success'] = true;
                $response['favorites'] = $favorites;
            } else {
                $response['success'] = true;
                $response['favorites'] = [];
            }
        } else {
            $response['success'] = false;
            $response['message'] = 'Thiếu user_id';
        }
        break;
        
    case 'POST':
        // Thêm bài hát vào danh sách yêu thích
        if (isset($data->user_id) && isset($data->song_id)) {
            $user_id = $conn->real_escape_string($data->user_id);
            $song_id = $conn->real_escape_string($data->song_id);
            
            // Kiểm tra xem đã có trong danh sách yêu thích chưa
            $sql = "SELECT * FROM favorites WHERE user_id = '$user_id' AND song_id = '$song_id'";
            $result = $conn->query($sql);
            
            if ($result->num_rows == 0) {
                $sql = "INSERT INTO favorites (user_id, song_id) VALUES ('$user_id', '$song_id')";
                
                if ($conn->query($sql)) {
                    $response['success'] = true;
                    $response['message'] = 'Đã thêm vào danh sách yêu thích';
                } else {
                    $response['success'] = false;
                    $response['message'] = 'Lỗi: ' . $conn->error;
                }
            } else {
                $response['success'] = false;
                $response['message'] = 'Bài hát đã có trong danh sách yêu thích';
            }
        } else {
            $response['success'] = false;
            $response['message'] = 'Thiếu thông tin bài hát';
        }
        break;
        
    case 'DELETE':
        // Xóa bài hát khỏi danh sách yêu thích
        if (isset($_GET['user_id']) && isset($_GET['song_id'])) {
            $user_id = $conn->real_escape_string($_GET['user_id']);
            $song_id = $conn->real_escape_string($_GET['song_id']);
            
            $sql = "DELETE FROM favorites WHERE user_id = '$user_id' AND song_id = '$song_id'";
            
            if ($conn->query($sql)) {
                $response['success'] = true;
                $response['message'] = 'Đã xóa khỏi danh sách yêu thích';
            } else {
                $response['success'] = false;
                $response['message'] = 'Lỗi: ' . $conn->error;
            }
        } else {
            $response['success'] = false;
            $response['message'] = 'Thiếu thông tin bài hát';
        }
        break;
        
    default:
        $response['success'] = false;
        $response['message'] = 'Phương thức không được hỗ trợ';
        break;
}

echo json_encode($response);
$conn->close(); 