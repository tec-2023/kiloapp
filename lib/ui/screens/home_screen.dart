import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import '../../utils/constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/trip_provider.dart';
import '../../services/gps_service.dart';
import '../../models/trip_model.dart';
import '../widgets/map_widget.dart';
import '../../main.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _gps = GpsService();
  late final String _userId;
  bool _tracking = false;
  final List<LatLng> _points = [];
  late StreamSubscription _sub;
  DateTime? _tripStartTime;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authStateProvider)!;
    _userId = user.id;
    ref.read(tripProvider(_userId).notifier).loadTrips();
  }

  void _startTrip() async {
    await _gps.startTracking();
    _tripStartTime = DateTime.now();
    _sub = _gps.onPositionChanged.listen((pos) {
      setState(() {
        _points.add(LatLng(pos.latitude, pos.longitude));
      });
    });
    setState(() => _tracking = true);
  }

  void _stopTrip() async {
    await _gps.stopTracking();
    _sub.cancel();
    final endTime = DateTime.now();
    final startTime = _tripStartTime ?? endTime;
    final distance = _calculateDistance(_points);
    final trip = TripModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: _userId,
      startTime: startTime,
      endTime: endTime,
      distance: distance,
      route: _points
          .map((p) => Coordinate(latitude: p.latitude, longitude: p.longitude))
          .toList(),
    );
    await ref.read(tripProvider(_userId).notifier).addTrip(trip);
    setState(() {
      _tracking = false;
      _points.clear();
      _tripStartTime = null;
    });
  }

  double _calculateDistance(List<LatLng> points) {
    double total = 0;
    for (var i = 0; i < points.length - 1; i++) {
      total += Distance().as(
        LengthUnit.Kilometer,
        points[i],
        points[i + 1],
      );
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapWidget(points: _points),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (i) {
          switch (i) {
            case 0:
              break;
            case 1:
              Navigator.pushNamed(context, Routes.history);
              break;
            case 2:
              Navigator.pushNamed(context, Routes.profile);
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: AppStrings.tabMap,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: AppStrings.tabHistory,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: AppStrings.tabProfile,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _tracking ? _stopTrip : _startTrip,
        label: Text(_tracking
            ? AppStrings.btnStopTrip
            : AppStrings.btnStartTrip),
        icon: Icon(_tracking ? Icons.stop : Icons.play_arrow),
      ),
    );
  }
}