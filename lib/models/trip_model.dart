
class TripModel {
  final String id;
  final String userId;
  final DateTime startTime;
  final DateTime endTime;
  final double distance; // en kilómetros
  final List<Coordinate> route;

  TripModel({
    required this.id,
    required this.userId,
    required this.startTime,
    required this.endTime,
    required this.distance,
    required this.route,
  });

  // Deserialización desde JSON
  factory TripModel.fromJson(Map<String, dynamic> json) {
    var coords = <Coordinate>[];
    if (json['route'] != null) {
      coords = (json['route'] as List)
          .map((e) => Coordinate.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return TripModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      distance: (json['distance'] as num).toDouble(),
      route: coords,
    );
  }

  // Serialización a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'distance': distance,
      'route': route.map((c) => c.toJson()).toList(),
    };
  }

  // Factory para ruta vacía
  factory TripModel.empty() {
    return TripModel(
      id: '',
      userId: '',
      startTime: DateTime.now(),
      endTime: DateTime.now(),
      distance: 0.0,
      route: [],
    );
  }
}

class Coordinate {
  final double latitude;
  final double longitude;

  Coordinate({
    required this.latitude,
    required this.longitude,
  });

  factory Coordinate.fromJson(Map<String, dynamic> json) {
    return Coordinate(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
