import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:t4/presentation/screen/login_screen.dart';
import 'package:t4/presentation/screen/register_screen.dart';
import 'package:t4/presentation/screen/spash_screen.dart';
import 'package:t4/presentation/screen/home_screen.dart';
import 'package:t4/presentation/screen/admin_login_screen.dart';
import 'package:t4/presentation/screen/admin_dashboard_screen.dart';
import 'package:t4/presentation/screen/forgot_password_screen.dart';
import 'package:t4/presentation/screen/album_screen.dart';
import 'package:t4/presentation/screen/playlist_screen.dart';
import 'package:t4/presentation/screen/ProfileScreen.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'services/audio_player_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => AudioPlayerHandler(), // Quản lý player toàn app
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF31C934)),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/admin_login': (context) => const AdminLoginScreen(),
        '/admin': (context) => const AdminDashboardScreen(),
        '/forgot_password': (context) => const ForgotPasswordScreen(),
        '/album': (context) => const AlbumScreen(),
        '/playlist': (context) => const PlaylistScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
