import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../providers/auth_provider.dart';
import '../../utils/constants.dart';
import '../../main.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    await Future.delayed(const Duration(seconds: 2)); // Simula carga

    // Chequea permisos esenciales
    if (!await Permission.locationWhenInUse.isGranted) {
      Navigator.of(context).pushReplacementNamed(Routes.permission);
      return;
    }

    final user = ref.read(authStateProvider);
    if (user != null) {
      Navigator.of(context).pushReplacementNamed(Routes.home);
    } else {
      Navigator.of(context).pushReplacementNamed(Routes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.motorcycle,
              size: 100,
              color: Colors.white,
            ),
            const SizedBox(height: 24),
            Text(
              'KiloApp',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}