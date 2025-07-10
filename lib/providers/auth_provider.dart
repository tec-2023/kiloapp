/*
  File: lib/providers/auth_provider.dart
*/

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

/// Proveedor de AuthService
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

/// Estado de autenticación: usuario actual o null
class AuthState extends StateNotifier<UserModel?> {
  final AuthService _authService;
  AuthState(this._authService) : super(null);

  /// Inicializa cargando el usuario actual
  Future<void> loadCurrentUser() async {
    final user = await _authService.getCurrentUser();
    state = user;
  }

  /// Iniciar sesión
  Future<bool> signIn(String email, String password) async {
    final user = await _authService.signIn(email: email, password: password);
    if (user != null) {
      state = user;
      return true;
    }
    return false;
  }

  /// Registrarse
  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
    String? phoneNumber,
  }) async {
    final user = await _authService.signUp(
      email: email,
      password: password,
      name: name,
      phoneNumber: phoneNumber,
    );
    if (user != null) {
      state = user;
      return true;
    }
    return false;
  }

  /// Cerrar sesión
  Future<void> signOut() async {
    await _authService.signOut();
    state = null;
  }

  /// Ingresar como invitado
  void signInAsGuest() {
    state = UserModel(
      id: 'guest',
      name: 'Invitado',
      email: '',
      phoneNumber: null,
      photoUrl: '',
      role: 'guest',
      token: '',
      isEmailVerified: false,
      createdAt: DateTime.now(),
      lastLogin: DateTime.now(),
    );
  }
}

/// Proveedor de estado de autenticación
final authStateProvider = StateNotifierProvider<AuthState, UserModel?>(
  (ref) {
    final authService = ref.watch(authServiceProvider);
    final authState = AuthState(authService);
    // Cargar usuario actual al inicio
    authState.loadCurrentUser();
    return authState;
  },
);
