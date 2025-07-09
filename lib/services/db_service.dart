/*
  File: lib/services/db_service.dart
  - Servicio unificado de datos con funciones avanzadas:
  - CRUD completo con Supabase
  - Filtrado por rango de fechas
  - Paginación
  - Sincronización de viajes pendientes para modo offline
*/

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
    }).execute();
    return res.error == null;
  }

  /// Devuelve todos los viajes de un usuario.
  Future<List<TripModel>> getTripsByUser(String userId) async {
    return await _fetchTrips(
      query: () => _client
          .from('trips')
          .select()
          .eq('userId', userId)
          .order('startTime', ascending: false),
    );
  }

  /// Filtra viajes de un usuario en un rango de fechas.
  Future<List<TripModel>> getTripsByDateRange(
      String userId, DateTime from, DateTime to) async {
    return await _fetchTrips(
      query: () => _client
          .from('trips')
          .select()
          .eq('userId', userId)
          .gte('startTime', from.toIso8601String())
          .lte('startTime', to.toIso8601String())
          .order('startTime', ascending: false),
    );
  }

  /// Paginación: obtiene un "page" de viajes.
  Future<List<TripModel>> getTripsPage(
      String userId, int page, int pageSize) async {
    final from = (page - 1) * pageSize;
    final to = from + pageSize - 1;
    return await _fetchTrips(
      query: () => _client
          .from('trips')
          .select()
          .eq('userId', userId)
          .order('startTime', ascending: false)
          .range(from, to),
    );
  }

  /// Obtiene un viaje por su ID.
  Future<TripModel?> getTripById(String id) async {
    final res = await _client
        .from('trips')
        .select()
        .eq('id', id)
        .single()
        .execute();
    if (res.error != null) return null;
    return TripModel.fromJson(res.data as Map<String, dynamic>);
  }

  /// Actualiza datos de un viaje existente.
  Future<bool> updateTrip(TripModel trip) async {
    final res = await _client
        .from('trips')
        .update({
          'endTime': trip.endTime.toIso8601String(),
          'distance': trip.distance,
          'route': trip.route.map((c) => c.toJson()).toList(),
        })
        .eq('id', trip.id)
        .execute();
    return res.error == null;
  }

  /// Elimina un viaje.
  Future<bool> deleteTrip(String id) async {
    final res = await _client.from('trips').delete().eq('id', id).execute();
    return res.error == null;
  }

  /// Sincroniza viajes pendientes guardados en Supabase Storage o tabla temporal.
  /// (Implementar lógica offline: reintentos, conflict resolution, etc.)
  Future<void> syncPendingTrips() async {
    // TODO: implementar cola de sincronización offline
  }

  /// Helper para ejecutar la query y mapear TripModel.
  Future<List<TripModel>> _fetchTrips({
    required TableBuilder Function() query,
  }) async {
    final res = await query().execute();
    if (res.error != null) {
      throw Exception(res.error!.message);
    }
    final data = res.data as List<dynamic>;
    return data
        .map((e) => TripModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
// Este servicio proporciona una interfaz unificada para interactuar con la base de datos,
// permitiendo realizar operaciones CRUD completas sobre los viajes de un usuario.