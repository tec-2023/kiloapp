import 'package:flutter/material.dart';
import '../../models/trip_model.dart';
import '../../ui/screens/trip_detail_screen.dart';
import '../../utils/constants.dart';

class TripCard extends StatelessWidget {
  final TripModel trip;

  const TripCard({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: ListTile(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TripDetailScreen(trip: trip),
          ),
        ),
        title: Text(AppStrings.formatDate(trip.startTime)),
        subtitle: Text(
            '${AppStrings.formatTime(trip.startTime)} - ${AppStrings.formatTime(trip.endTime)}'),
        trailing: Text(
          '${trip.distance.toStringAsFixed(2)} km',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: const Icon(Icons.directions_bike, color: Colors.blueAccent),
      ),
    );
  }
}