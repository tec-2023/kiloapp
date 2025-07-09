import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../utils/constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/trip_provider.dart';
import '../../models/trip_model.dart';
import '../widgets/trip_card.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider);
    final tripState = ref.watch(tripProvider(user!.id));
    final tripNotifier = ref.read(tripProvider(user.id).notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.tabHistory),
        backgroundColor: Colors.blue[900],
      ),
      body: RefreshIndicator(
        onRefresh: () => tripNotifier.loadTrips(),
        child: tripState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : tripState.trips.isEmpty
                ? const Center(child: Text('No hay viajes registrados.'))
                : ListView.builder(
                    itemCount: tripState.trips.length,
                    itemBuilder: (context, index) {
                      final trip = tripState.trips[index];
                      return TripCard(trip: trip);
                    },
                  ),
      ),
    );
  }
}