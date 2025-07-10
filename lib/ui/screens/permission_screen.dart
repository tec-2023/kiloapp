import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../utils/constants.dart';
import '../../main.dart';
import '../../services/gps_service.dart';

class PermissionScreen extends ConsumerStatefulWidget {
  const PermissionScreen({super.key});

  @override
  ConsumerState<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends ConsumerState<PermissionScreen> {
  bool _granted = false;
  bool _loading = false;

  Future<void> _requestPermissions() async {
    setState(() => _loading = true);
    final gpsService = GpsService();
    final granted = await gpsService.requestPermissions();
    setState(() {
      _granted = granted;
      _loading = false;
    });
    if (granted) {
      Navigator.of(context).pushReplacementNamed(Routes.login);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Permisos denegados. No puedes continuar.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.permissionTitle),
        backgroundColor: AppColors.primaryBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PermissionTile(
              icon: Icons.location_on,
              text: AppStrings.permissionLocation,
            ),
            const SizedBox(height: 12),
            PermissionTile(
              icon: Icons.storage,
              text: AppStrings.permissionStorage,
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _loading ? null : _requestPermissions,
              child: _loading
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    )
                  : const Text(AppStrings.btnGrantPermissions),
            ),
          ],
        ),
      ),
    );
  }
}

class PermissionTile extends StatelessWidget {
  final IconData icon;
  final String text;

  const PermissionTile({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryBlue),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}