/*
  File: lib/services/db_service.dart
  - Servicio unificado de datos con funciones avanzadas:
  - CRUD completo con Supabase
  - Filtrado por rango de fechas
  - Paginación
  - Sincronización de viajes pendientes para modo offline
*/

// Asegúrate de tener supabase_flutter en pubspec.yaml
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/trip_model.dart';

class DbService {
  final SupabaseClient _client = Supabase.instance.client;

  /// Inserta un nuevo viaje en Supabase y retorna éxito.
  Future<bool> insertTrip(TripModel trip) async {
    final res = await _client.from('trips').insert({
      'id': trip.id,
      'userId': trip.userId,
      'startTime': trip.startTime.toIso8601String(),
      'endTime': trip.endTime.toIso8601String(),
      'distance': trip.distance,
      'route': trip.route.map((c) => c.toJson()).toList(),
    });
    return res.error == null;
  }

  /// Devuelve todos los viajes de un usuario.
  Future<List<TripModel>> getTripsByUser(String userId) async {
    try {
      final List res = await _client.from('trips').select().eq('userId', userId);
      return res.map((e) => TripModel.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Filtra viajes de un usuario en un rango de fechas.
  Future<List<TripModel>> getTripsByDateRange(
      String userId, DateTime from, DateTime to) async {
    try {
      final List res = await _client.from('trips').select()
        .eq('userId', userId)
        .gte('startTime', from.toIso8601String())
        .lte('endTime', to.toIso8601String());
      return res.map((e) => TripModel.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Paginación: obtiene un "page" de viajes.
  Future<List<TripModel>> getTripsPage(
      String userId, int page, int pageSize) async {
    try {
      final fromIdx = (page - 1) * pageSize;
      final toIdx = fromIdx + pageSize - 1;
      final List res = await _client.from('trips').select()
        .eq('userId', userId)
        .range(fromIdx, toIdx);
      return res.map((e) => TripModel.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Obtiene un viaje por su ID.
  Future<TripModel?> getTripById(String id) async {
    try {
      final res = await _client.from('trips').select().eq('id', id).single();
      return TripModel.fromJson(res);
    } catch (e) {
      return null;
    }
  }

  /// Actualiza datos de un viaje existente.
  Future<bool> updateTrip(TripModel trip) async {
    final res = await _client.from('trips').update({
      'startTime': trip.startTime.toIso8601String(),
      'endTime': trip.endTime.toIso8601String(),
      'distance': trip.distance,
      'route': trip.route.map((c) => c.toJson()).toList(),
    }).eq('id', trip.id);
    return res.error == null;
  }

  /// Elimina un viaje.
  Future<bool> deleteTrip(String id) async {
    final res = await _client.from('trips').delete().eq('id', id);
    return res.error == null;
  }

  /// Sincroniza viajes pendientes guardados en Supabase Storage o tabla temporal.
  /// (Implementar lógica offline: reintentos, conflict resolution, etc.)
  Future<void> syncPendingTrips() async {
    // TODO: implementar cola de sincronización offline
  }
}
// Este servicio proporciona una interfaz unificada para interactuar con la base de datos,
// permitiendo realizar operaciones CRUD completas sobre los viajes de un usuario.