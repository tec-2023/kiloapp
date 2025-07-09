import 'package:flutter/material.dart';
import 'utils/theme.dart';
import 'utils/constants.dart';
import 'ui/screens/splash_screen.dart';
import 'ui/screens/permission_screen.dart';
import 'ui/screens/login_screen.dart';
import 'ui/screens/register_screen.dart';
import 'ui/screens/home_screen.dart';
import 'ui/screens/history_screen.dart';
import 'ui/screens/trip_detail_screen.dart';
import 'ui/screens/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Inicializar servicios aquí si es necesario (por ejemplo Supabase)
  runApp(const KiloApp());
}

class KiloApp extends StatelessWidget {
  const KiloApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: Routes.splash,
      routes: {
        Routes.splash: (context) => const SplashScreen(),
        Routes.permission: (context) => const PermissionScreen(),
        Routes.login: (context) => const LoginScreen(),
        Routes.register: (context) => const RegisterScreen(),
        Routes.home: (context) => const HomeScreen(),
        Routes.history: (context) => const HistoryScreen(),
        Routes.tripDetail: (context) => const TripDetailScreen(),
        Routes.profile: (context) => const ProfileScreen(),
      },
    );
  }
}

class Routes {
  static const String splash = '/splash';
  static const String permission = '/permission';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String history = '/history';
  static const String tripDetail = '/trip_detail';
  static const String profile = '/profile';
}