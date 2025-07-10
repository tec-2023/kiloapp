import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../services/gps_service.dart';
import '../../utils/constants.dart';

class MapWidget extends StatefulWidget {
  final List<LatLng> points;

  const MapWidget({super.key, required this.points});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> with SingleTickerProviderStateMixin {
  LatLng? _userLocation;
  bool _loading = false;
  String? _error;
  late AnimationController _controller;
  final MapController _mapController = MapController();

  // Ejemplo de alerta visual (círculo de advertencia)
  final LatLng? _alertLocation = LatLng(12.137, -86.251); // Puedes cambiar la ubicación

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: false);
    // Escuchar cambios de ubicación en tiempo real
    GpsService().onPositionChanged.listen((pos) {
      final newLoc = LatLng(pos.latitude, pos.longitude);
      if (_userLocation == null || _userLocation != newLoc) {
        setState(() {
          _userLocation = newLoc;
        });
        // Centrar el mapa suavemente en la nueva posición
        _mapController.move(newLoc, _mapController.camera.zoom);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _getUserLocation() async {
    setState(() => _loading = true);
    try {
      final pos = await GpsService().getCurrentPosition();
      setState(() {
        _userLocation = LatLng(pos.latitude, pos.longitude);
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'No se pudo obtener la ubicación';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(child: Text(_error!));
    }
    final center = widget.points.isNotEmpty
        ? widget.points.last
        : (_userLocation ?? LatLng(12.1364, -86.2514));

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: center,
        initialZoom: 15,
        keepAlive: true,
        // Desactiva el centrado automático si el usuario interactúa
        onPositionChanged: (pos, hasGesture) {
          if (hasGesture) return;
        },
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        ),
        // Sombra de la ruta (más ancha y difusa)
        if (widget.points.isNotEmpty)
          PolylineLayer(
            polylines: [
              Polyline(
                points: widget.points,
                strokeWidth: 10.0,
                color: AppColors.primaryBlue.withOpacity(0.18),
              ),
            ],
          ),
        // Ruta principal con degradado
        if (widget.points.isNotEmpty)
          PolylineLayer(
            polylines: [
              Polyline(
                points: widget.points,
                strokeWidth: 5.0,
                color: AppColors.accentYellow,
                gradientColors: [
                  AppColors.accentYellow,
                  AppColors.primaryBlue,
                ],
              ),
            ],
          ),
        // Marcadores de inicio y fin de ruta
        if (widget.points.isNotEmpty)
          MarkerLayer(
            markers: [
              Marker(
                point: widget.points.first,
                width: 44,
                height: 44,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.secondaryRed,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.secondaryRed.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.play_arrow, color: Colors.white, size: 28),
                ),
              ),
              Marker(
                point: widget.points.last,
                width: 44,
                height: 44,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.accentYellow,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accentYellow.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.flag, color: AppColors.primaryBlue, size: 28),
                ),
              ),
            ],
          ),
        // Marcador animado de usuario
        if (widget.points.isEmpty && _userLocation != null)
          MarkerLayer(
            markers: [
              Marker(
                point: _userLocation!,
                width: 60,
                height: 60,
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        // Onda animada
                        Container(
                          width: 40 + 20 * _controller.value,
                          height: 40 + 20 * _controller.value,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryBlue.withOpacity(0.15 * (1 - _controller.value)),
                          ),
                        ),
                        // Círculo principal
                        AnimatedScale(
                          scale: 1 + 0.1 * _controller.value,
                          duration: const Duration(milliseconds: 300),
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primaryBlue,
                              border: Border.all(color: AppColors.accentYellow, width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryBlue.withOpacity(0.3),
                                  blurRadius: 12,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const Icon(Icons.navigation, color: AppColors.onPrimary, size: 18),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        // Ejemplo de alerta visual (círculo de advertencia)
        if (_alertLocation != null)
          CircleLayer(
            circles: [
              CircleMarker(
                point: _alertLocation,
                color: AppColors.secondaryRed.withOpacity(0.18),
                borderStrokeWidth: 3,
                borderColor: AppColors.secondaryRed,
                useRadiusInMeter: true,
                radius: 80, // metros
              ),
            ],
          ),
        // Ejemplo de marcador de alerta
        if (_alertLocation != null)
          MarkerLayer(
            markers: [
              Marker(
                point: _alertLocation,
                width: 40,
                height: 40,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.secondaryRed,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.secondaryRed.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.warning, color: Colors.white, size: 24),
                ),
              ),
            ],
          ),
      ],
    );
  }
}