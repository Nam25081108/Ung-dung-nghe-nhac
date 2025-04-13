<?php
// Đường dẫn tương đối đến thư mục project Flutter
$FLUTTER_PROJECT_PATH = '../';

// Đường dẫn đến các file và thư mục
$SONG_LIST_PATH = $FLUTTER_PROJECT_PATH . 'lib/data/song_list.dart';
$ALBUM_LIST_PATH = $FLUTTER_PROJECT_PATH . 'lib/data/album_list.dart';
$ARTISTS_LIST_PATH = $FLUTTER_PROJECT_PATH . 'lib/data/artists_list.dart';
$AUDIO_ASSETS_PATH = $FLUTTER_PROJECT_PATH . 'assets/audio/';
$IMAGE_ASSETS_PATH = $FLUTTER_PROJECT_PATH . 'assets/images/';

// Thông tin tài khoản admin
$ADMIN_USERNAME = 'admin';
$ADMIN_PASSWORD = 'admin123';

// Kiểm tra đăng nhập
function isLoggedIn() {
    return isset($_SESSION['logged_in']) && $_SESSION['logged_in'] === true;
}

// Database configuration
define('DB_HOST', 'localhost');
define('DB_USER', 'root');
define('DB_PASS', '');
define('DB_NAME', 'music_app');

// Create database connection
function connectDB() {
    $conn = new mysqli(DB_HOST, DB_USER, DB_PASS);
    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }
    
    // Create database if not exists
    $sql = "CREATE DATABASE IF NOT EXISTS " . DB_NAME;
    if ($conn->query($sql) === TRUE) {
        $conn->select_db(DB_NAME);
        
        // Create users table
        $sql = "CREATE TABLE IF NOT EXISTS users (
            id INT AUTO_INCREMENT PRIMARY KEY,
            username VARCHAR(50) UNIQUE NOT NULL,
            password VARCHAR(255) NOT NULL,
            email VARCHAR(100) UNIQUE NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )";
        $conn->query($sql);

        // Create songs table
        $sql = "CREATE TABLE IF NOT EXISTS songs (
            id INT AUTO_INCREMENT PRIMARY KEY,
            title VARCHAR(255) NOT NULL,
            artist VARCHAR(255) NOT NULL,
            album VARCHAR(255),
            coverImage VARCHAR(255) NOT NULL,
            assetPath VARCHAR(255) NOT NULL,
            lyrics TEXT NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )";
        $conn->query($sql);
        
        // Create playlists table
        $sql = "CREATE TABLE IF NOT EXISTS playlists (
            id INT AUTO_INCREMENT PRIMARY KEY,
            user_id INT NOT NULL,
            name VARCHAR(100) NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
        )";
        $conn->query($sql);
        
        // Create playlist_songs table
        $sql = "CREATE TABLE IF NOT EXISTS playlist_songs (
            playlist_id INT NOT NULL,
            song_id INT NOT NULL,
            added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (playlist_id, song_id),
            FOREIGN KEY (playlist_id) REFERENCES playlists(id) ON DELETE CASCADE,
            FOREIGN KEY (song_id) REFERENCES songs(id) ON DELETE CASCADE
        )";
        $conn->query($sql);
        
        // Create favorites table
        $sql = "CREATE TABLE IF NOT EXISTS favorites (
            user_id INT NOT NULL,
            song_id INT NOT NULL,
            added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (user_id, song_id),
            FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
            FOREIGN KEY (song_id) REFERENCES songs(id) ON DELETE CASCADE
        )";
        $conn->query($sql);
    }
    
    return $conn;
}

// Function to sync songs from song_list.dart to database
function syncSongsToDatabase() {
    global $SONG_LIST_PATH;
    $conn = connectDB();
    
    // Read song_list.dart
    $content = file_get_contents($SONG_LIST_PATH);
    preg_match_all('/Song\(\s*id:\s*(\d+),\s*title:\s*\'(.*?)\',\s*artist:\s*\'(.*?)\',\s*coverImage:\s*\'(.*?)\',\s*assetPath:\s*\'(.*?)\',\s*lyrics:\s*\'(.*?)\'(?:,\s*album:\s*\'(.*?)\')?(?:,)?\s*\)/s', $content, $matches, PREG_SET_ORDER);
    
    foreach ($matches as $match) {
        $id = $match[1];
        $title = $conn->real_escape_string($match[2]);
        $artist = $conn->real_escape_string($match[3]);
        $coverImage = $conn->real_escape_string($match[4]);
        $assetPath = $conn->real_escape_string($match[5]);
        $lyrics = $conn->real_escape_string($match[6]);
        $album = isset($match[7]) ? $conn->real_escape_string($match[7]) : '';
        
        // Check if song exists
        $sql = "SELECT id FROM songs WHERE id = $id";
        $result = $conn->query($sql);
        
        if ($result->num_rows == 0) {
            // Insert new song
            $sql = "INSERT INTO songs (id, title, artist, album, coverImage, assetPath, lyrics) 
                    VALUES ($id, '$title', '$artist', '$album', '$coverImage', '$assetPath', '$lyrics')";
        } else {
            // Update existing song
            $sql = "UPDATE songs 
                    SET title = '$title', artist = '$artist', album = '$album', 
                        coverImage = '$coverImage', assetPath = '$assetPath', lyrics = '$lyrics' 
                    WHERE id = $id";
        }
        
        $conn->query($sql);
    }
    
    $conn->close();
}
?> 