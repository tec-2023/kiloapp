import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../utils/constants.dart';
import '../../main.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider);
    final authNotifier = ref.read(authStateProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.tabProfile),
        backgroundColor: Colors.blue[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 40,
              child: Text(
                user!.name[0].toUpperCase(),
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            Text('Nombre: ${user.name}', style: Theme.of(context).textTheme.bodyLarge),
            Text('Correo: ${user.email}', style: Theme.of(context).textTheme.bodyMedium),
            if (user.phoneNumber != null && user.phoneNumber!.isNotEmpty)
              Text('Teléfono: ${user.phoneNumber}'),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () async {
                await authNotifier.signOut();
                Navigator.of(context).pushReplacementNamed(Routes.login);
              },
              icon: const Icon(Icons.logout),
              label: const Text('Cerrar sesión'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
            )
          ],
        ),
      ),
    );
  }
}