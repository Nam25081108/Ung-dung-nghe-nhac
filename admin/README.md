# Trang Quản Lý Bài Hát

Đây là trang quản lý âm nhạc cho ứng dụng Flutter, cho phép thêm hoặc xóa bài hát trực tiếp vào file `song_list.dart` và các thư mục assets của ứng dụng.

## Tính năng

- Đăng nhập với tài khoản quản trị
- Thêm bài hát mới (tên, nghệ sĩ, file âm thanh, hình ảnh, lời bài hát)
- Quản lý danh sách bài hát hiện có (xem, nghe, xóa)
- Tự động cập nhật file `song_list.dart` khi thêm/xóa bài hát
- Tự động lưu file âm thanh vào thư mục `assets/audio/`
- Tự động lưu hình ảnh vào thư mục `assets/images/`

## Yêu cầu

- PHP 7.0 trở lên
- Web server (Apache, Nginx, hoặc XAMPP trên Windows)
- Quyền ghi vào các thư mục và file của dự án

## Cài đặt

1. Đặt thư mục `admin` vào thư mục gốc của dự án Flutter
2. Cấu hình web server để có thể truy cập thư mục này
3. Đảm bảo PHP có quyền đọc/ghi vào:
   - `lib/data/song_list.dart`
   - `assets/audio/`
   - `assets/images/`

## Sử dụng

1. Truy cập trang admin thông qua đường dẫn: `http://your-server/path-to-project/admin/`
2. Đăng nhập với tài khoản mặc định:
   - Tên đăng nhập: `admin`
   - Mật khẩu: `admin123`
3. Sau khi đăng nhập, bạn có thể:
   - Thêm bài hát mới (tab "Thêm bài hát")
   - Xem và quản lý danh sách bài hát hiện có (tab "Danh sách bài hát")

## Sửa đổi

- Thay đổi tài khoản admin trong file `config.php`
- Tùy chỉnh giao diện trong file `assets/css/style.css`
- Điều chỉnh cấu trúc file song_list.dart trong file `song_actions.php`

## Lưu ý

- Sau khi thêm hoặc xóa bài hát, bạn cần rebuild ứng dụng Flutter để các thay đổi có hiệu lực
- Luôn sao lưu file `song_list.dart` trước khi thực hiện các thay đổi lớn
- Đảm bảo kích thước file âm thanh và hình ảnh phù hợp để tránh làm tăng kích thước ứng dụng quá mức 