import 'dart:async';
import 'package:geolocator/geolocator.dart';

/// Servicio para obtener la ubicación en tiempo real y en background.
class GpsService {
  static final GpsService _instance = GpsService._internal();
  factory GpsService() => _instance;
  GpsService._internal();

  StreamSubscription<Position>? _positionSub;
  final _controller = StreamController<Position>.broadcast();

  /// Solicita permisos de ubicación (foreground y background)
  Future<bool> requestPermissions() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever || permission == LocationPermission.denied) {
      return false;
    }
    return true;
  }

  /// Inicia el seguimiento continuo de la posición.
  Future<void> startTracking({LocationAccuracy accuracy = LocationAccuracy.high, int intervalMs = 1000}) async {
    bool granted = await requestPermissions();
    if (!granted) {
      throw Exception('Permiso de ubicación denegado');
    }
    _positionSub ??= Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: accuracy,
        distanceFilter: 0,
      ),
    ).listen((Position pos) {
      _controller.add(pos);
    });
  }

  /// Detiene el seguimiento de la posición.
  Future<void> stopTracking() async {
    await _positionSub?.cancel();
    _positionSub = null;
  }

  /// Obtiene la posición actual una sola vez.
  Future<Position> getCurrentPosition({LocationAccuracy accuracy = LocationAccuracy.high}) {
    return Geolocator.getCurrentPosition(desiredAccuracy: accuracy);
  }

  /// Stream de posiciones emitidas.
  Stream<Position> get onPositionChanged => _controller.stream;

  /// Calcula la distancia en kilómetros entre dos posiciones.
  double distanceBetween(Position start, Position end) {
    return Geolocator.distanceBetween(
          start.latitude,
          start.longitude,
          end.latitude,
          end.longitude,
        ) / 1000; // metros a km
  }

  /// Dispone los recursos.
  void dispose() {
    _controller.close();
    _positionSub?.cancel();
  }
}