import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionTile extends StatelessWidget {
  final Permission permission;
  final String title;
  final String description;

  const PermissionTile({
    super.key,
    required this.permission,
    required this.title,
    required this.description,
  });

  Future<void> _requestPermission(BuildContext context) async {
    final status = await permission.request();
    if (status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permiso concedido')),
      );
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permiso denegado')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: const Icon(Icons.lock_open, color: Colors.blueAccent),
        title: Text(title),
        subtitle: Text(description),
        trailing: ElevatedButton(
          onPressed: () => _requestPermission(context),
          child: const Text('Permitir'),
        ),
      ),
    );
  }
}
