import 'dart:io';
import 'package:flutter/material.dart';
import 'package:t4/data/song_list.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:t4/models/song.dart';


class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _artistController = TextEditingController();
  final TextEditingController _albumController = TextEditingController();
  final TextEditingController _lyricsController = TextEditingController();

  File? _selectedImageFile;
  File? _selectedAudioFile;

  bool _isUploading = false;
  String _message = '';
  bool _isSuccess = false;

  final ImagePicker _picker = ImagePicker();
  // Danh sách bài hát hiện tại để hiển thị
  late List<Song> _currentSongs;
  // Phân trang
  int _currentPage = 0;
  final int _songsPerPage = 10;

  @override
  void initState() {
    super.initState();
    _currentSongs = songList;
  }

  // Chọn file hình ảnh
  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        setState(() {
          _selectedImageFile = File(image.path);
        });
      }
    } catch (e) {
      _showMessage('Lỗi chọn hình ảnh: ${e.toString()}', false);
    }
  }

  // Chọn file âm thanh
  Future<void> _pickAudio() async {
    try {
      // Image picker không hỗ trợ trực tiếp chọn audio
      // Nhưng chúng ta có thể sử dụng để chọn bất kỳ file nào
      final XFile? audio = await _picker.pickMedia();

      if (audio != null) {
        setState(() {
          _selectedAudioFile = File(audio.path);
        });
      }
    } catch (e) {
      _showMessage('Lỗi chọn file âm thanh: ${e.toString()}', false);
    }
  }

  // Hiển thị thông báo
  void _showMessage(String message, bool isSuccess) {
    setState(() {
      _message = message;
      _isSuccess = isSuccess;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Xử lý thêm bài hát mới
  Future<void> _addNewSong() async {
    // Kiểm tra các trường bắt buộc
    if (_titleController.text.isEmpty ||
        _artistController.text.isEmpty ||
        _selectedImageFile == null ||
        _selectedAudioFile == null ||
        _lyricsController.text.isEmpty) {
      _showMessage('Vui lòng điền đầy đủ thông tin và chọn file', false);
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      // Trong dự án thực tế, bạn sẽ copy các file vào assets
      // Ở đây chúng ta giả định đã copy thành công và tạo đường dẫn
      String imageName = path
          .basename(_selectedImageFile!.path)
          .toLowerCase()
          .replaceAll(' ', '_');
      String audioName = path
          .basename(_selectedAudioFile!.path)
          .toLowerCase()
          .replaceAll(' ', '_');

      // Tạo đường dẫn tương đối cho assets
      String imageAssetPath = 'assets/images/$imageName';
      String audioAssetPath = 'assets/audio/$audioName';

      // Tạo ID mới cho bài hát
      int newId = 1;
      if (songList.isNotEmpty) {
        newId = songList.map((s) => s.id).reduce((a, b) => a > b ? a : b) + 1;
      }

      // Tạo bài hát mới
      final newSong = Song(
        id: newId,
        title: _titleController.text,
        artist: _artistController.text,
        coverImage: imageAssetPath,
        assetPath: audioAssetPath,
        lyrics: _lyricsController.text,
        album: _albumController.text.isNotEmpty ? _albumController.text : null,
      );

      // Thêm bài hát vào danh sách
      songList.add(newSong);

      // Cập nhật state
      setState(() {
        _currentSongs = songList;
      });

      _showMessage('Đã thêm bài hát thành công!', true);

      // Reset form
      _resetForm();
    } catch (e) {
      _showMessage('Lỗi khi thêm bài hát: ${e.toString()}', false);
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  // Reset lại form
  void _resetForm() {
    setState(() {
      _titleController.clear();
      _artistController.clear();
      _albumController.clear();
      _lyricsController.clear();
      _selectedImageFile = null;
      _selectedAudioFile = null;
    });
  }

  // Xóa bài hát
  void _deleteSong(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc chắn muốn xóa bài hát này không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              try {
                songList.removeAt(index);
                setState(() {
                  _currentSongs = songList;
                });
                _showMessage('Đã xóa bài hát', true);
              } catch (e) {
                _showMessage('Không thể xóa bài hát: ${e.toString()}', false);
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  // Đăng xuất
  void _logout() {
    Navigator.pushReplacementNamed(context, '/admin_login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý bài hát'),
        backgroundColor: const Color(0xFF31C934),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              color: const Color(0xFF31C934).withValues(alpha: 50),
              child: const TabBar(
                tabs: [
                  Tab(text: 'Thêm bài hát'),
                  Tab(text: 'Danh sách bài hát'),
                ],
                labelColor: Color(0xFF1B7A10),
                indicatorColor: Color(0xFF31C934),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Tab thêm bài hát
                  _buildAddSongTab(),

                  // Tab danh sách bài hát
                  _buildSongListTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget tab thêm bài hát
  Widget _buildAddSongTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Thêm bài hát mới',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          // Form thêm bài hát
          _buildTextField(
            controller: _titleController,
            labelText: 'Tên bài hát',
            icon: Icons.music_note,
          ),
          const SizedBox(height: 12),

          _buildTextField(
            controller: _artistController,
            labelText: 'Nghệ sĩ',
            icon: Icons.person,
          ),
          const SizedBox(height: 12),

          _buildTextField(
            controller: _albumController,
            labelText: 'Album (tùy chọn)',
            icon: Icons.album,
          ),
          const SizedBox(height: 12),

          // Chọn hình ảnh
          _buildFileSelector(
            label: 'Chọn hình ảnh',
            icon: Icons.image,
            selectedFile: _selectedImageFile,
            onTap: _pickImage,
          ),
          const SizedBox(height: 12),

          // Chọn file âm thanh
          _buildFileSelector(
            label: 'Chọn file MP3',
            icon: Icons.audiotrack,
            selectedFile: _selectedAudioFile,
            onTap: _pickAudio,
          ),
          const SizedBox(height: 12),

          // Textarea cho lời bài hát
          const Text(
            'Lời bài hát:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey),
            ),
            child: TextField(
              controller: _lyricsController,
              maxLines: 10,
              decoration: const InputDecoration(
                hintText: 'Nhập lời bài hát...',
                contentPadding: EdgeInsets.all(16),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Nút thêm bài hát
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isUploading ? null : _addNewSong,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF31C934),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isUploading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      "Thêm bài hát",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),

          // Hiển thị thông báo nếu có
          if (_message.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Container(
                padding: const EdgeInsets.all(12),
                width: double.infinity,
                decoration: BoxDecoration(
                  color:
                      _isSuccess ? Colors.green.shade100 : Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _isSuccess ? Colors.green : Colors.red,
                  ),
                ),
                child: Text(
                  _message,
                  style: TextStyle(
                    color: _isSuccess
                        ? Colors.green.shade900
                        : Colors.red.shade900,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Widget tab danh sách bài hát
  Widget _buildSongListTab() {
    // Tính toán số lượng trang và danh sách bài hát cho trang hiện tại
    int totalPages = (_currentSongs.length / _songsPerPage).ceil();
    int startIndex = _currentPage * _songsPerPage;
    int endIndex = (_currentPage + 1) * _songsPerPage;
    if (endIndex > _currentSongs.length) endIndex = _currentSongs.length;

    List<Song> displayedSongs = _currentSongs.sublist(startIndex, endIndex);

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: displayedSongs.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final song = displayedSongs[index];
              final actualIndex = startIndex + index;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 2,
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.asset(
                      song.coverImage,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(song.title),
                  subtitle: Text(song.artist),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          // Chức năng chỉnh sửa (sẽ phát triển sau)
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteSong(actualIndex),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // Điều khiển phân trang
        if (totalPages > 1)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: _currentPage > 0
                      ? () {
                          setState(() {
                            _currentPage--;
                          });
                        }
                      : null,
                ),
                Text(
                  'Trang ${_currentPage + 1}/$totalPages',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: _currentPage < totalPages - 1
                      ? () {
                          setState(() {
                            _currentPage++;
                          });
                        }
                      : null,
                ),
              ],
            ),
          ),
      ],
    );
  }

  // Widget cho trường nhập liệu
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          border: InputBorder.none,
          prefixIcon: Icon(icon),
        ),
      ),
    );
  }

  // Widget cho chọn file
  Widget _buildFileSelector({
    required String label,
    required IconData icon,
    required File? selectedFile,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey),
            ),
            child: Row(
              children: [
                Icon(icon, color: const Color(0xFF31C934)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    selectedFile != null
                        ? path.basename(selectedFile.path)
                        : 'Chọn file',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.file_upload, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
