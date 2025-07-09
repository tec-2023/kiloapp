import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapWidget extends StatelessWidget {
  final List<LatLng> points;

  const MapWidget({super.key, required this.points});

  @override
  Widget build(BuildContext context) {
    final center = points.isNotEmpty ? points.last : LatLng(12.1364, -86.2514); // Managua como centro por defecto

    return FlutterMap(
      options: MapOptions(
        initialCenter: center,
        initialZoom: 15,
        keepAlive: true,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        ),
        if (points.isNotEmpty)
          PolylineLayer(
            polylines: [
              Polyline(
                points: points,
                strokeWidth: 4.0,
                color: Colors.blueAccent,
              ),
            ],
          ),
        if (points.isNotEmpty)
          MarkerLayer(
            markers: [
              Marker(
                point: points.first,
                width: 40,
                height: 40,
                child: const Icon(Icons.location_on, color: Colors.green, size: 30),
              ),
              Marker(
                point: points.last,
                width: 40,
                height: 40,
                child: const Icon(Icons.location_on, color: Colors.red, size: 30),
              ),
            ],
          ),
      ],
    );
  }
}