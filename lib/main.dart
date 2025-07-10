import 'models/trip_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
  final anonKey = String.fromEnvironment('SUPABASE_KEY');
  print('==============================');
  print('SUPABASE_KEY:');
  print(anonKey);
  print('==============================');
  await Supabase.initialize(
    url: 'https://wydeynespdgvksfyhtwd.supabase.co',
    anonKey: anonKey,
  );
  print('Supabase inicializado');
  runApp(
    ProviderScope(
      child: KiloApp(),
    ),
  );
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
        Routes.profile: (context) => const ProfileScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == Routes.tripDetail) {
          final trip = settings.arguments as TripModel;
          return MaterialPageRoute(
            builder: (context) => TripDetailScreen(trip: trip),
          );
        }
        return null;
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