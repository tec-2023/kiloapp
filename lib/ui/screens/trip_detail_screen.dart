import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../../models/trip_model.dart';
import '../../utils/constants.dart';
import '../widgets/map_widget.dart';

class TripDetailScreen extends StatelessWidget {
  final TripModel trip;

  const TripDetailScreen({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    final points = trip.route
        .map((coord) => LatLng(coord.latitude, coord.longitude))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Viaje'),
        backgroundColor: Colors.blue[900],
      ),
      body: Column(
        children: [
          Expanded(
            child: MapWidget(points: points),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fecha: ${AppStrings.formatDate(trip.startTime)}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Hora de inicio: ${AppStrings.formatTime(trip.startTime)}',
                ),
                Text(
                  'Hora de fin: ${AppStrings.formatTime(trip.endTime)}',
                ),
                const SizedBox(height: 8),
                Text(
                  'Distancia: ${trip.distance.toStringAsFixed(2)} km',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}