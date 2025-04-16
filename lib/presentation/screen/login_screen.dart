import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'forgot_password_screen.dart';
import 'package:provider/provider.dart';
import 'package:t4/services/audio_player_handler.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscureText = true;
  bool _isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showErrorMessage("Vui lòng nhập đầy đủ thông tin");
      return;
    }

    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        if (mounted) {
          // Khôi phục trạng thái phát nhạc của user vừa đăng nhập
          final audioHandler =
              Provider.of<AudioPlayerHandler>(context, listen: false);
          await audioHandler.clearPlaybackState(); // Xóa trạng thái cũ
          await audioHandler
              .restorePlaybackState(); // Khôi phục trạng thái của user mới

          Navigator.pushReplacementNamed(context, '/home');
        }
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = "Không tìm thấy tài khoản";
          break;
        case 'wrong-password':
          errorMessage = "Mật khẩu không đúng";
          break;
        case 'invalid-email':
          errorMessage = "Email không hợp lệ";
          break;
        case 'user-disabled':
          errorMessage = "Tài khoản đã bị vô hiệu hóa";
          break;
        default:
          errorMessage = e.message ?? "Đăng nhập thất bại";
      }
      _showErrorMessage(errorMessage);
    } catch (e) {
      _showErrorMessage("Có lỗi xảy ra: ${e.toString()}");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Đăng xuất khỏi tài khoản Google hiện tại
      await _googleSignIn.signOut();

      // Hiển thị dialog chọn tài khoản
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        if (mounted) {
          // Khôi phục trạng thái phát nhạc của user vừa đăng nhập
          final audioHandler =
              Provider.of<AudioPlayerHandler>(context, listen: false);
          await audioHandler.clearPlaybackState(); // Xóa trạng thái cũ
          await audioHandler
              .restorePlaybackState(); // Khôi phục trạng thái của user mới

          Navigator.pushReplacementNamed(context, '/home');
        }
      }
    } catch (e) {
      _showErrorMessage("Đăng nhập Google thất bại: ${e.toString()}");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorMessage(String message) {
    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),
                  // Logo
                  Image.asset(
                    'assets/logo.png',
                    width: 170,
                    height: 170,
                  ),
                  const SizedBox(height: 60),

                  // Trường nhập email
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        hintText: "Nhập email",
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Trường nhập mật khẩu
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: TextField(
                      controller: passwordController,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        hintText: "Mật khẩu",
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                    ),
                  ),

                  // Quên mật khẩu
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ForgotPasswordScreen()),
                        );
                      },
                      child: const Text(
                        "Quên mật khẩu?",
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Nút đăng nhập
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF31C934),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              "Đăng nhập",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),

                  // Dòng phân cách "Hoặc"
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      children: [
                        Expanded(child: Divider()),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text("Hoặc",
                              style: TextStyle(color: Colors.grey)),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),
                  ),

                  // Nút đăng nhập bằng Google
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: TextButton.icon(
                      icon: Image.asset(
                        'assets/logo_icon.png',
                        height: 24,
                      ),
                      label: const Text(
                        "Đăng nhập bằng Google",
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: _signInWithGoogle,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),

                  // Dòng chuyển đến đăng ký
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Bạn chưa có tài khoản?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/register');
                        },
                        child: const Text(
                          "Đăng ký",
                          style: TextStyle(color: Color(0xFF1B7A10)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withValues(alpha: 128),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
