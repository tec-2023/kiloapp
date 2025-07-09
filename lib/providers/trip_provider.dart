import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/trip_model.dart';
import '../services/db_service.dart';

/// Proveedor de DbService
final dbServiceProvider = Provider<DbService>((ref) {
  return DbService();
});

/// Estado de viajes y selección
class TripState {
  final List<TripModel> trips;
  final TripModel? selectedTrip;
  final bool isLoading;
  final String? error;

  TripState({
    required this.trips,
    this.selectedTrip,
    this.isLoading = false,
    this.error,
  });

  TripState copyWith({
    List<TripModel>? trips,
    TripModel? selectedTrip,
    bool? isLoading,
    String? error,
  }) {
    return TripState(
      trips: trips ?? this.trips,
      selectedTrip: selectedTrip ?? this.selectedTrip,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// StateNotifier para controlar viajes
class TripNotifier extends StateNotifier<TripState> {
  final DbService _dbService;
  final String userId;

  TripNotifier(this._dbService, this.userId)
      : super(TripState(trips: []));

  /// Carga todos los viajes del usuario
  Future<void> loadTrips() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final trips = await _dbService.getTripsByUser(userId);
      state = state.copyWith(trips: trips, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Carga viajes en un rango de fechas
  Future<void> loadTripsByDate(DateTime from, DateTime to) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final trips = await _dbService.getTripsByDateRange(userId, from, to);
      state = state.copyWith(trips: trips, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Paginación de viajes
  Future<void> loadTripsPage(int page, int pageSize) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final trips = await _dbService.getTripsPage(userId, page, pageSize);
      state = state.copyWith(trips: trips, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Selecciona un viaje por ID
  void selectTrip(String id) {
    final trip = state.trips.firstWhere((t) => t.id == id, orElse: () => TripModel.empty());
    state = state.copyWith(selectedTrip: trip);
  }

  /// Agrega un nuevo viaje y recarga
  Future<void> addTrip(TripModel trip) async {
    state = state.copyWith(isLoading: true, error: null);
    final success = await _dbService.insertTrip(trip);
    if (success) {
      await loadTrips();
    } else {
      state = state.copyWith(isLoading: false, error: 'Error al guardar viaje');
    }
  }

  /// Elimina un viaje y recarga
  Future<void> deleteTrip(String id) async {
    state = state.copyWith(isLoading: true, error: null);
    final success = await _dbService.deleteTrip(id);
    if (success) {
      await loadTrips();
    } else {
      state = state.copyWith(isLoading: false, error: 'Error al eliminar viaje');
    }
  }
}

/// Proveedor de TripNotifier
final tripProvider = StateNotifierProvider.family<TripNotifier, TripState, String>(
  (ref, userId) {
    final dbService = ref.watch(dbServiceProvider);
    return TripNotifier(dbService, userId);
  },
);