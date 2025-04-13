<?php
require_once('../admin/config.php');

// Allow CORS
header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Access-Control-Allow-Headers, Content-Type, Access-Control-Allow-Methods, Authorization, X-Requested-With');

$conn = connectDB();
$data = json_decode(file_get_contents("php://input"));
$response = array();

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $action = isset($_GET['action']) ? $_GET['action'] : '';
    
    switch ($action) {
        case 'register':
            if (isset($data->username) && isset($data->password) && isset($data->email)) {
                $username = $conn->real_escape_string($data->username);
                $password = password_hash($data->password, PASSWORD_DEFAULT);
                $email = $conn->real_escape_string($data->email);
                
                $sql = "INSERT INTO users (username, password, email) VALUES ('$username', '$password', '$email')";
                
                if ($conn->query($sql)) {
                    $response['success'] = true;
                    $response['message'] = 'Đăng ký thành công';
                    $response['user_id'] = $conn->insert_id;
                } else {
                    $response['success'] = false;
                    $response['message'] = 'Lỗi: ' . $conn->error;
                }
            } else {
                $response['success'] = false;
                $response['message'] = 'Thiếu thông tin đăng ký';
            }
            break;
            
        case 'login':
            if (isset($data->username) && isset($data->password)) {
                $username = $conn->real_escape_string($data->username);
                
                $sql = "SELECT id, username, password FROM users WHERE username = '$username'";
                $result = $conn->query($sql);
                
                if ($result->num_rows > 0) {
                    $user = $result->fetch_assoc();
                    if (password_verify($data->password, $user['password'])) {
                        $response['success'] = true;
                        $response['message'] = 'Đăng nhập thành công';
                        $response['user_id'] = $user['id'];
                        $response['username'] = $user['username'];
                    } else {
                        $response['success'] = false;
                        $response['message'] = 'Sai mật khẩu';
                    }
                } else {
                    $response['success'] = false;
                    $response['message'] = 'Tài khoản không tồn tại';
                }
            } else {
                $response['success'] = false;
                $response['message'] = 'Thiếu thông tin đăng nhập';
            }
            break;
            
        default:
            $response['success'] = false;
            $response['message'] = 'Hành động không hợp lệ';
            break;
    }
} else {
    $response['success'] = false;
    $response['message'] = 'Phương thức không được hỗ trợ';
}

echo json_encode($response);
$conn->close(); 