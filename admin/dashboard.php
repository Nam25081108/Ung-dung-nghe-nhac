<?php
session_start();
require_once('config.php');

if (!isLoggedIn()) {
    header('Location: index.php');
    exit;
}

// Đọc danh sách bài hát từ file song_list.dart
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

// Đọc danh sách album từ file album_list.dart
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

$songs = getSongs();
$albums = getAlbums();

// Hiển thị thông báo thành công nếu có
$success = isset($_GET['success']) ? $_GET['success'] : '';
$successMessage = '';

if ($success === 'add') {
    $successMessage = 'Đã thêm bài hát thành công!';
} elseif ($success === 'delete') {
    $successMessage = 'Đã xóa bài hát thành công!';
} elseif ($success === 'update') {
    $successMessage = 'Đã cập nhật bài hát thành công!';
} elseif ($success === 'album_add') {
    $successMessage = 'Đã tạo album thành công!';
} elseif ($success === 'album_delete') {
    $successMessage = 'Đã xóa album thành công!';
} elseif ($success === 'album_update') {
    $successMessage = 'Đã cập nhật album thành công!';
}
?>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý âm nhạc - Dashboard</title>
    <link rel="stylesheet" href="assets/css/style.css">
</head>
<body>
    <div class="dashboard-container">
        <header>
            <h1>Quản lý bài hát</h1>
            <a href="logout.php" class="btn btn-logout">Đăng xuất</a>
        </header>
        
        <?php if ($successMessage): ?>
            <div class="success">
                <?php echo $successMessage; ?>
            </div>
        <?php endif; ?>
        
        <div class="tabs">
            <button class="tab-btn active" data-tab="add-song">Thêm bài hát</button>
            <button class="tab-btn" data-tab="song-list">Danh sách bài hát</button>
            <button class="tab-btn" data-tab="album-manager">Quản lý Album</button>
            <?php if (isset($_GET['edit'])): ?>
            <button class="tab-btn" data-tab="edit-song" id="edit-tab">Sửa bài hát</button>
            <?php endif; ?>
            <?php if (isset($_GET['edit_album'])): ?>
            <button class="tab-btn" data-tab="edit-album" id="edit-album-tab">Sửa album</button>
            <?php endif; ?>
        </div>
        
        <div class="tab-content active" id="add-song">
            <h2>Thêm bài hát mới</h2>
            <form method="post" action="song_actions.php" enctype="multipart/form-data">
                <input type="hidden" name="action" value="add">
                
                <div class="form-group">
                    <label for="title">Tên bài hát</label>
                    <input type="text" id="title" name="title" required>
                </div>
                
                <div class="form-group">
                    <label for="artist">Nghệ sĩ</label>
                    <input type="text" id="artist" name="artist" required>
                </div>
                
                <div class="form-group">
                    <label for="album">Album (có thể để trống)</label>
                    <input type="text" id="album" name="album">
                </div>
                
                <div class="form-group">
                    <label for="audio_file">File âm thanh (MP3)</label>
                    <input type="file" id="audio_file" name="audio_file" accept="audio/mp3,audio/mpeg" required>
                </div>
                
                <div class="form-group">
                    <label for="image_file">Hình ảnh bìa</label>
                    <input type="file" id="image_file" name="image_file" accept="image/*" required>
                </div>
                
                <div class="form-group">
                    <label for="lyrics">Lời bài hát</label>
                    <textarea id="lyrics" name="lyrics" rows="8" required></textarea>
                </div>
                
                <button type="submit" class="btn">Thêm bài hát</button>
            </form>
        </div>
        
        <div class="tab-content" id="song-list">
            <h2>Danh sách bài hát</h2>
            
            <table class="song-table">
                <thead>
                    <tr>
                        <th>Hình ảnh</th>
                        <th>Tên bài hát</th>
                        <th>Nghệ sĩ</th>
                        <th>Album</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <?php foreach ($songs as $index => $song): ?>
                    <tr>
                        <td><img src="<?php echo $FLUTTER_PROJECT_PATH . $song['coverImage']; ?>" alt="<?php echo $song['title']; ?>" class="song-cover"></td>
                        <td><?php echo $song['title']; ?></td>
                        <td><?php echo $song['artist']; ?></td>
                        <td><?php echo $song['album']; ?></td>
                        <td>
                            <div class="action-buttons">
                                <a href="<?php echo $FLUTTER_PROJECT_PATH . $song['assetPath']; ?>" class="btn btn-small btn-play" target="_blank">Nghe</a>
                                <form method="post" action="song_actions.php" class="inline-form">
                                    <input type="hidden" name="action" value="edit_form">
                                    <input type="hidden" name="index" value="<?php echo $index; ?>">
                                    <button type="submit" class="btn btn-small btn-edit">Sửa</button>
                                </form>
                                <form method="post" action="song_actions.php" onsubmit="return confirm('Bạn có chắc chắn muốn xóa bài hát này?');" class="inline-form">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="index" value="<?php echo $index; ?>">
                                    <button type="submit" class="btn btn-small btn-delete">Xóa</button>
                                </form>
                            </div>
                        </td>
                    </tr>
                    <?php endforeach; ?>
                </tbody>
            </table>
        </div>
        
        <div class="tab-content" id="album-manager">
            <h2>Quản lý Album</h2>
            
            <div class="album-create-form">
                <h3>Tạo Album mới</h3>
                <form method="post" action="album_actions.php" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="add">
                    
                    <div class="form-group">
                        <label for="album_name">Tên album</label>
                        <input type="text" id="album_name" name="album_name" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="album_cover">Hình ảnh bìa album</label>
                        <input type="file" id="album_cover" name="album_cover" accept="image/*" required>
                    </div>
                    
                    <div class="form-group">
                        <label>Chọn bài hát cho album</label>
                        <div class="song-search">
                            <input type="text" id="song-search" placeholder="Tìm bài hát..." class="search-input">
                        </div>
                        <div class="song-selection">
                            <?php foreach ($songs as $index => $song): ?>
                            <div class="song-checkbox">
                                <input type="checkbox" id="song_<?php echo $index; ?>" name="selected_songs[]" value="<?php echo $index; ?>">
                                <label for="song_<?php echo $index; ?>" class="song-item">
                                    <?php echo $song['title']; ?> - <?php echo $song['artist']; ?>
                                </label>
                            </div>
                            <?php endforeach; ?>
                        </div>
                    </div>
                    
                    <button type="submit" class="btn">Tạo Album</button>
                </form>
            </div>
            
            <div class="album-list">
                <h3>Danh sách Album</h3>
                <?php if (empty($albums)): ?>
                <p>Chưa có album nào.</p>
                <?php else: ?>
                <div class="albums-grid">
                    <?php foreach ($albums as $index => $album): ?>
                    <div class="album-card">
                        <div class="album-cover">
                            <img src="<?php echo $FLUTTER_PROJECT_PATH . $album['coverImage']; ?>" alt="<?php echo $album['name']; ?>">
                        </div>
                        <div class="album-info">
                            <h4><?php echo $album['name']; ?></h4>
                            <p><?php echo count($album['songIds']); ?> bài hát</p>
                            <div class="album-actions">
                                <form method="post" action="album_actions.php" class="inline-form">
                                    <input type="hidden" name="action" value="edit_form">
                                    <input type="hidden" name="index" value="<?php echo $index; ?>">
                                    <button type="submit" class="btn btn-small btn-edit">Sửa</button>
                                </form>
                                <form method="post" action="album_actions.php" onsubmit="return confirm('Bạn có chắc chắn muốn xóa album này?');" class="inline-form">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="index" value="<?php echo $index; ?>">
                                    <button type="submit" class="btn btn-small btn-delete">Xóa</button>
                                </form>
                            </div>
                        </div>
                        <div class="album-songs">
                            <strong>Bài hát trong album:</strong>
                            <ul>
                                <?php 
                                foreach ($album['songIds'] as $songId): 
                                    foreach ($songs as $song) {
                                        if ($song['id'] === $songId) {
                                            echo '<li>' . $song['title'] . ' - ' . $song['artist'] . '</li>';
                                            break;
                                        }
                                    }
                                endforeach; 
                                ?>
                            </ul>
                        </div>
                    </div>
                    <?php endforeach; ?>
                </div>
                <?php endif; ?>
            </div>
        </div>
        
        <?php if (isset($_GET['edit']) && isset($_GET['index'])): ?>
        <div class="tab-content <?php echo isset($_GET['edit']) ? 'active' : ''; ?>" id="edit-song">
            <h2>Sửa bài hát</h2>
            <?php 
            $editIndex = (int)$_GET['index'];
            $editSong = $songs[$editIndex] ?? null;
            
            if ($editSong): 
            ?>
            <form method="post" action="song_actions.php" enctype="multipart/form-data">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="index" value="<?php echo $editIndex; ?>">
                
                <div class="form-group">
                    <label for="edit_title">Tên bài hát</label>
                    <input type="text" id="edit_title" name="title" value="<?php echo htmlspecialchars($editSong['title']); ?>" required>
                </div>
                
                <div class="form-group">
                    <label for="edit_artist">Nghệ sĩ</label>
                    <input type="text" id="edit_artist" name="artist" value="<?php echo htmlspecialchars($editSong['artist']); ?>" required>
                </div>
                
                <div class="form-group">
                    <label for="edit_album">Album (có thể để trống)</label>
                    <input type="text" id="edit_album" name="album" value="<?php echo htmlspecialchars($editSong['album']); ?>">
                </div>
                
                <div class="form-group">
                    <label for="edit_audio_file">File âm thanh mới (MP3) - Để trống nếu không đổi</label>
                    <input type="file" id="edit_audio_file" name="audio_file" accept="audio/mp3,audio/mpeg">
                    <p class="current-file">File hiện tại: <?php echo $editSong['assetPath']; ?></p>
                </div>
                
                <div class="form-group">
                    <label for="edit_image_file">Hình ảnh bìa mới - Để trống nếu không đổi</label>
                    <input type="file" id="edit_image_file" name="image_file" accept="image/*">
                    <p class="current-file">File hiện tại: <?php echo $editSong['coverImage']; ?></p>
                    <div class="preview-image">
                        <img src="<?php echo $FLUTTER_PROJECT_PATH . $editSong['coverImage']; ?>" alt="<?php echo $editSong['title']; ?>" class="song-cover-large">
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="edit_lyrics">Lời bài hát</label>
                    <textarea id="edit_lyrics" name="lyrics" rows="8" required><?php echo htmlspecialchars($editSong['lyrics']); ?></textarea>
                </div>
                
                <button type="submit" class="btn">Cập nhật bài hát</button>
                <a href="dashboard.php" class="btn btn-cancel">Hủy</a>
            </form>
            <?php else: ?>
            <p>Không tìm thấy bài hát để sửa.</p>
            <a href="dashboard.php" class="btn">Quay lại</a>
            <?php endif; ?>
        </div>
        <?php endif; ?>
        
        <?php if (isset($_GET['edit_album']) && isset($_GET['index'])): ?>
        <div class="tab-content <?php echo isset($_GET['edit_album']) ? 'active' : ''; ?>" id="edit-album">
            <h2>Sửa Album</h2>
            <?php 
            $editIndex = (int)$_GET['index'];
            $editAlbum = $albums[$editIndex] ?? null;
            
            if ($editAlbum): 
            ?>
            <form method="post" action="album_actions.php" enctype="multipart/form-data">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="index" value="<?php echo $editIndex; ?>">
                <input type="hidden" name="album_id" value="<?php echo $editAlbum['id']; ?>">
                
                <div class="form-group">
                    <label for="edit_album_name">Tên album</label>
                    <input type="text" id="edit_album_name" name="album_name" value="<?php echo htmlspecialchars($editAlbum['name']); ?>" required>
                </div>
                
                <div class="form-group">
                    <label for="edit_album_cover">Hình ảnh bìa album mới - Để trống nếu không đổi</label>
                    <input type="file" id="edit_album_cover" name="album_cover" accept="image/*">
                    <p class="current-file">File hiện tại: <?php echo $editAlbum['coverImage']; ?></p>
                    <div class="preview-image">
                        <img src="<?php echo $FLUTTER_PROJECT_PATH . $editAlbum['coverImage']; ?>" alt="<?php echo $editAlbum['name']; ?>" class="song-cover-large">
                    </div>
                </div>
                
                <div class="form-group">
                    <label>Chọn bài hát cho album</label>
                    <div class="song-search">
                        <input type="text" id="edit-song-search" placeholder="Tìm bài hát..." class="search-input">
                    </div>
                    <div class="song-selection">
                        <?php foreach ($songs as $index => $song): 
                            $isSelected = in_array($song['id'], $editAlbum['songIds']);
                        ?>
                        <div class="song-checkbox">
                            <input type="checkbox" id="edit_song_<?php echo $index; ?>" name="selected_songs[]" value="<?php echo $index; ?>" <?php echo $isSelected ? 'checked' : ''; ?>>
                            <label for="edit_song_<?php echo $index; ?>" class="song-item">
                                <?php echo $song['title']; ?> - <?php echo $song['artist']; ?>
                            </label>
                        </div>
                        <?php endforeach; ?>
                    </div>
                </div>
                
                <button type="submit" class="btn">Cập nhật Album</button>
                <a href="dashboard.php" class="btn btn-cancel">Hủy</a>
            </form>
            <?php else: ?>
            <p>Không tìm thấy album để sửa.</p>
            <a href="dashboard.php" class="btn">Quay lại</a>
            <?php endif; ?>
        </div>
        <?php endif; ?>
    </div>
    
    <script>
        // Tab switching
        document.querySelectorAll('.tab-btn').forEach(button => {
            button.addEventListener('click', () => {
                // Deactivate all tabs
                document.querySelectorAll('.tab-btn').forEach(btn => btn.classList.remove('active'));
                document.querySelectorAll('.tab-content').forEach(content => content.classList.remove('active'));
                
                // Activate clicked tab
                button.classList.add('active');
                document.getElementById(button.dataset.tab).classList.add('active');
            });
        });
        
        // Activate edit tab if present
        <?php if (isset($_GET['edit'])): ?>
        document.querySelectorAll('.tab-btn').forEach(btn => btn.classList.remove('active'));
        document.querySelectorAll('.tab-content').forEach(content => content.classList.remove('active'));
        document.getElementById('edit-tab').classList.add('active');
        document.getElementById('edit-song').classList.add('active');
        <?php endif; ?>
        
        // Activate edit album tab if present
        <?php if (isset($_GET['edit_album'])): ?>
        document.querySelectorAll('.tab-btn').forEach(btn => btn.classList.remove('active'));
        document.querySelectorAll('.tab-content').forEach(content => content.classList.remove('active'));
        document.getElementById('edit-album-tab').classList.add('active');
        document.getElementById('edit-album').classList.add('active');
        <?php endif; ?>
        
        // Tìm kiếm bài hát
        function setupSearch(searchInputId, songContainerSelector) {
            const searchInput = document.getElementById(searchInputId);
            if (!searchInput) return;
            
            searchInput.addEventListener('input', function() {
                const searchTerm = this.value.toLowerCase();
                const songItems = document.querySelectorAll(songContainerSelector + ' .song-checkbox');
                
                songItems.forEach(item => {
                    const songTitle = item.querySelector('.song-item').textContent.toLowerCase();
                    if (songTitle.includes(searchTerm)) {
                        item.style.display = 'block';
                    } else {
                        item.style.display = 'none';
                    }
                });
            });
        }
        
        // Thiết lập tìm kiếm cho form tạo album
        setupSearch('song-search', '#album-manager .song-selection');
        
        // Thiết lập tìm kiếm cho form sửa album
        setupSearch('edit-song-search', '#edit-album .song-selection');
    </script>
</body>
</html>

<?php
// Hàm tạo ID duy nhất dựa trên tên bài hát và nghệ sĩ
function generateUniqueId($title, $artist) {
    $cleanTitle = preg_replace('/[^a-zA-Z0-9]/', '_', strtolower($title));
    $cleanArtist = preg_replace('/[^a-zA-Z0-9]/', '_', strtolower($artist));
    return $cleanTitle . '_' . $cleanArtist;
}
?> 